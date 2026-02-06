using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using TechHubWebForms.DAL;

namespace TechHubWebForms.Products
{
    public partial class Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCategories();
                LoadProducts();
            }
        }

        private void LoadCategories()
        {
            try
            {
                using (var context = new TechHubContext())
                {
                    var categories = context.Categories
                        .Where(c => c.IsActive)
                        .OrderBy(c => c.CategoryName)
                        .ToList();

                    ddlCategory.Items.Clear();
                    ddlCategory.Items.Add(new ListItem("All Categories", "0"));

                    foreach (var category in categories)
                    {
                        ddlCategory.Items.Add(new ListItem(category.CategoryName, category.CategoryID.ToString()));
                    }

                    // Check if category filter from query string (from homepage)
                    if (Request.QueryString["category"] != null)
                    {
                        string categoryId = Request.QueryString["category"];
                        var item = ddlCategory.Items.FindByValue(categoryId);
                        if (item != null)
                        {
                            ddlCategory.SelectedValue = categoryId;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading categories: " + ex.Message);
            }
        }

        private void LoadProducts()
        {
            try
            {
                using (var context = new TechHubContext())
                {
                    var query = context.Products.Where(p => p.IsActive);

                    // Apply category filter
                    int categoryId = Convert.ToInt32(ddlCategory.SelectedValue);
                    if (categoryId > 0)
                    {
                        query = query.Where(p => p.CategoryID == categoryId);
                    }

                    // Apply search filter
                    string searchTerm = txtSearch.Text.Trim();
                    if (!string.IsNullOrEmpty(searchTerm))
                    {
                        query = query.Where(p => p.Name.Contains(searchTerm) || p.Brand.Contains(searchTerm) || p.Description.Contains(searchTerm));
                    }

                    // Apply sorting
                    switch (ddlSort.SelectedValue)
                    {
                        case "price_low":
                            query = query.OrderBy(p => p.Price);
                            break;
                        case "price_high":
                            query = query.OrderByDescending(p => p.Price);
                            break;
                        case "name":
                            query = query.OrderBy(p => p.Name);
                            break;
                        case "newest":
                        default:
                            query = query.OrderByDescending(p => p.DateAdded);
                            break;
                    }

                    var products = query.ToList();

                    // Update results count
                    lblResultsCount.Text = $"Showing {products.Count} product(s)";

                    // Bind to repeater
                    if (products.Any())
                    {
                        rptProducts.DataSource = products;
                        rptProducts.DataBind();
                        rptProducts.Visible = true;
                        pnlNoResults.Visible = false;
                    }
                    else
                    {
                        rptProducts.Visible = false;
                        pnlNoResults.Visible = true;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading products: " + ex.Message);
                lblResultsCount.Text = "Error loading products";
            }
        }

        protected void ddlCategory_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadProducts();
        }

        protected void ddlSort_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadProducts();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadProducts();
        }

        protected void btnClearFilters_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ddlCategory.SelectedValue = "0";
            ddlSort.SelectedValue = "newest";
            LoadProducts();
        }

        protected void rptProducts_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ViewDetails")
            {
                int productId = Convert.ToInt32(e.CommandArgument);
                Response.Redirect($"~/Products/Details.aspx?id={productId}");
            }
        }
    }
}