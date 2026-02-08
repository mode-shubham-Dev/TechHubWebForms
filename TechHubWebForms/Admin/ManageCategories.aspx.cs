using System;
using System.Data.Entity;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using TechHubWebForms.DAL;
using TechHubWebForms.Models;

namespace TechHubWebForms.Admin
{
    public partial class ManageCategories : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check authentication
            if (!User.Identity.IsAuthenticated)
            {
                Response.Redirect("~/Account/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.Url.PathAndQuery));
                return;
            }

            // Check admin role
            if (Session["UserRole"]?.ToString() != "Admin")
            {
                Response.Redirect("~/Default.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadCategories();
            }
        }

        /// <summary>
        /// Load all categories into GridView
        /// </summary>
        private void LoadCategories()
        {
            try
            {
                using (var context = new TechHubContext())
                {
                    var categories = context.Categories
                        .Include(c => c.Products)
                        .OrderByDescending(c => c.CategoryID)
                        .ToList();

                    lblCategoryCount.Text = categories.Count.ToString();

                    gvCategories.DataSource = categories;
                    gvCategories.DataBind();

                    pnlCategories.Visible = categories.Any();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading categories: " + ex.Message);
                ShowMessage("Error loading categories: " + ex.Message, false);
            }
        }

        /// <summary>
        /// Toggle Add Category form visibility
        /// </summary>
        protected void btnToggleForm_Click(object sender, EventArgs e)
        {
            pnlAddCategory.Visible = !pnlAddCategory.Visible;
            btnToggleForm.Text = pnlAddCategory.Visible ? "Hide Form" : "Show Form";
        }

        /// <summary>
        /// Add new category
        /// </summary>
        protected void btnAddCategory_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                using (var context = new TechHubContext())
                {
                    var category = new Category
                    {
                        CategoryName = txtCategoryName.Text.Trim(),
                        Description = txtDescription.Text.Trim(),
                        ImageURL = txtImageURL.Text.Trim(),
                        IsActive = chkIsActive.Checked,
                        DateCreated = DateTime.Now
                    };

                    context.Categories.Add(category);
                    context.SaveChanges();

                    ShowMessage($"Category '{category.CategoryName}' added successfully!", true);
                    ClearAddForm();
                    LoadCategories();
                    pnlAddCategory.Visible = false;
                    btnToggleForm.Text = "Show Form";
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error adding category: " + ex.Message);
                ShowMessage("Error adding category: " + ex.Message, false);
            }
        }

        /// <summary>
        /// Cancel add category
        /// </summary>
        protected void btnCancelAdd_Click(object sender, EventArgs e)
        {
            ClearAddForm();
            pnlAddCategory.Visible = false;
            btnToggleForm.Text = "Show Form";
        }

        /// <summary>
        /// Clear add category form
        /// </summary>
        private void ClearAddForm()
        {
            txtCategoryName.Text = "";
            txtDescription.Text = "";
            txtImageURL.Text = "";
            chkIsActive.Checked = true;
        }

        /// <summary>
        /// GridView Edit mode
        /// </summary>
        protected void gvCategories_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvCategories.EditIndex = e.NewEditIndex;
            LoadCategories();
        }

        /// <summary>
        /// GridView Cancel Edit
        /// </summary>
        protected void gvCategories_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvCategories.EditIndex = -1;
            LoadCategories();
        }

        /// <summary>
        /// GridView Update category
        /// </summary>
        protected void gvCategories_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            try
            {
                int categoryId = Convert.ToInt32(gvCategories.DataKeys[e.RowIndex].Value);
                GridViewRow row = gvCategories.Rows[e.RowIndex];

                // Get updated values
                string categoryName = ((TextBox)row.FindControl("txtEditCategoryName")).Text.Trim();
                string description = ((TextBox)row.FindControl("txtEditDescription")).Text.Trim();
                bool isActive = ((CheckBox)row.FindControl("chkEditIsActive")).Checked;

                using (var context = new TechHubContext())
                {
                    var category = context.Categories.Find(categoryId);

                    if (category != null)
                    {
                        category.CategoryName = categoryName;
                        category.Description = description;
                        category.IsActive = isActive;

                        context.SaveChanges();
                        ShowMessage($"Category '{category.CategoryName}' updated successfully!", true);
                    }
                }

                gvCategories.EditIndex = -1;
                LoadCategories();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error updating category: " + ex.Message);
                ShowMessage("Error updating category: " + ex.Message, false);
            }
        }

        /// <summary>
        /// GridView Delete category (soft delete)
        /// </summary>
        protected void gvCategories_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                int categoryId = Convert.ToInt32(gvCategories.DataKeys[e.RowIndex].Value);

                using (var context = new TechHubContext())
                {
                    var category = context.Categories.Include(c => c.Products).FirstOrDefault(c => c.CategoryID == categoryId);

                    if (category != null)
                    {
                        // Check if category has products
                        if (category.Products.Any())
                        {
                            ShowMessage($"Cannot delete '{category.CategoryName}' because it has {category.Products.Count} product(s). Please reassign or delete the products first.", false);
                            return;
                        }

                        // Soft delete - set IsActive to false
                        category.IsActive = false;
                        context.SaveChanges();
                        ShowMessage($"Category '{category.CategoryName}' deleted successfully!", true);
                    }
                }

                LoadCategories();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error deleting category: " + ex.Message);
                ShowMessage("Error deleting category: " + ex.Message, false);
            }
        }

        /// <summary>
        /// GridView pagination
        /// </summary>
        protected void gvCategories_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvCategories.PageIndex = e.NewPageIndex;
            LoadCategories();
        }

        /// <summary>
        /// Show success or error message
        /// </summary>
        private void ShowMessage(string message, bool isSuccess)
        {
            pnlMessage.Visible = true;
            divMessage.InnerText = message;

            if (isSuccess)
            {
                divMessage.Attributes["class"] = "message-content message-success";
            }
            else
            {
                divMessage.Attributes["class"] = "message-content message-error";
            }

            // Auto-hide after 5 seconds
            ScriptManager.RegisterStartupScript(this, GetType(), "HideMessage",
                "setTimeout(function(){ document.getElementById('" + pnlMessage.ClientID + "').style.display='none'; }, 5000);", true);
        }
    }
}