using System;
using System.Data.Entity;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TechHubWebForms.DAL;
using TechHubWebForms.Models;

namespace TechHubWebForms.Admin
{
    public partial class ManageProducts : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // ✅ CRITICAL: Check authentication
            if (!User.Identity.IsAuthenticated)
            {
                Response.Redirect("~/Account/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.Url.PathAndQuery));
                return;
            }

            // ✅ CRITICAL: Check admin role
            if (Session["UserRole"]?.ToString() != "Admin")
            {
                Response.Redirect("~/Default.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadCategories();
                LoadProducts();
            }
        }

        /// <summary>
        /// Load categories into dropdown
        /// </summary>
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

                    // For Add form
                    ddlCategory.DataSource = categories;
                    ddlCategory.DataTextField = "CategoryName";
                    ddlCategory.DataValueField = "CategoryID";
                    ddlCategory.DataBind();
                    ddlCategory.Items.Insert(0, new ListItem("-- Select Category --", "0"));
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading categories: " + ex.Message);
            }
        }

        /// <summary>
        /// Load all products into GridView
        /// </summary>
        private void LoadProducts(string searchTerm = "")
        {
            try
            {
                using (var context = new TechHubContext())
                {
                    var query = context.Products.Include(p => p.Category).AsQueryable();

                    // Apply search filter
                    if (!string.IsNullOrWhiteSpace(searchTerm))
                    {
                        query = query.Where(p =>
                            p.Name.Contains(searchTerm) ||
                            p.Brand.Contains(searchTerm) ||
                            p.Description.Contains(searchTerm));
                    }

                    var products = query.OrderByDescending(p => p.ProductID).ToList();

                    lblProductCount.Text = products.Count.ToString();

                    gvProducts.DataSource = products;
                    gvProducts.DataBind();

                    pnlProducts.Visible = products.Any();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading products: " + ex.Message);
                ShowMessage("Error loading products: " + ex.Message, false);
            }
        }

        /// <summary>
        /// ✅ NEW: Helper method to get image URL for display
        /// </summary>
        protected string GetImageUrl(object imageUrl)
        {
            string url = imageUrl?.ToString();

            if (string.IsNullOrWhiteSpace(url))
            {
                // Return placeholder if no image
                return ResolveUrl("~/Content/Images/placeholder.png");
            }

            // If it's a relative path, resolve it
            if (!url.StartsWith("http"))
            {
                return ResolveUrl(url);
            }

            return url;
        }

        /// <summary>
        /// ✅ NEW: Upload image file and return saved path
        /// </summary>
        private string UploadImage(FileUpload fileUpload)
        {
            if (fileUpload.HasFile)
            {
                try
                {
                    // Validate file extension
                    string fileExtension = Path.GetExtension(fileUpload.FileName).ToLower();
                    string[] allowedExtensions = { ".jpg", ".jpeg", ".png", ".gif" };

                    if (!allowedExtensions.Contains(fileExtension))
                    {
                        ShowMessage("Invalid file type. Only JPG, PNG, and GIF are allowed.", false);
                        return null;
                    }

                    // Validate file size (2MB max)
                    if (fileUpload.PostedFile.ContentLength > 2097152) // 2MB in bytes
                    {
                        ShowMessage("File size must be less than 2MB.", false);
                        return null;
                    }

                    // Generate unique filename
                    string fileName = Guid.NewGuid().ToString() + fileExtension;

                    // Get server path
                    string folderPath = Server.MapPath("~/Content/Images/Products/");

                    // Create directory if doesn't exist
                    if (!Directory.Exists(folderPath))
                    {
                        Directory.CreateDirectory(folderPath);
                    }

                    // Save file
                    string filePath = Path.Combine(folderPath, fileName);
                    fileUpload.SaveAs(filePath);

                    // Return relative path for database
                    return "~/Content/Images/Products/" + fileName;
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Error uploading image: " + ex.Message);
                    ShowMessage("Error uploading image: " + ex.Message, false);
                    return null;
                }
            }

            return null;
        }

        /// <summary>
        /// Toggle Add Product form visibility
        /// </summary>
        protected void btnToggleForm_Click(object sender, EventArgs e)
        {
            pnlAddProduct.Visible = !pnlAddProduct.Visible;
            btnToggleForm.Text = pnlAddProduct.Visible ? "Hide Form" : "Show Form";
        }

        /// <summary>
        /// ✅ UPDATED: Add new product with image upload
        /// </summary>
        protected void btnAddProduct_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                using (var context = new TechHubContext())
                {
                    // ✅ Upload images
                    string imageUrl1 = UploadImage(fuImage1);
                    string imageUrl2 = UploadImage(fuImage2);
                    string imageUrl3 = UploadImage(fuImage3);

                    var product = new Product
                    {
                        Name = txtProductName.Text.Trim(),
                        Brand = txtBrand.Text.Trim(),
                        CategoryID = Convert.ToInt32(ddlCategory.SelectedValue),
                        Price = Convert.ToDecimal(txtPrice.Text),
                        StockQuantity = Convert.ToInt32(txtStock.Text),
                        Description = txtDescription.Text.Trim(),
                        Specifications = txtSpecifications.Text.Trim(),
                        ImageURL1 = imageUrl1, // ✅ From file upload
                        ImageURL2 = imageUrl2, // ✅ From file upload
                        ImageURL3 = imageUrl3, // ✅ From file upload
                        IsActive = chkIsActive.Checked,
                        DateAdded = DateTime.Now
                    };

                    context.Products.Add(product);
                    context.SaveChanges();

                    ShowMessage($"Product '{product.Name}' added successfully!", true);
                    ClearAddForm();
                    LoadProducts();
                    pnlAddProduct.Visible = false;
                    btnToggleForm.Text = "Show Form";
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error adding product: " + ex.Message);
                ShowMessage("Error adding product: " + ex.Message, false);
            }
        }

        /// <summary>
        /// Cancel add product
        /// </summary>
        protected void btnCancelAdd_Click(object sender, EventArgs e)
        {
            ClearAddForm();
            pnlAddProduct.Visible = false;
            btnToggleForm.Text = "Show Form";
        }

        /// <summary>
        /// Clear add product form
        /// </summary>
        private void ClearAddForm()
        {
            txtProductName.Text = "";
            txtBrand.Text = "";
            ddlCategory.SelectedIndex = 0;
            txtPrice.Text = "";
            txtStock.Text = "";
            txtDescription.Text = "";
            txtSpecifications.Text = "";
            chkIsActive.Checked = true;

            // Note: FileUpload controls don't have a clear method
            // They reset automatically on postback
        }

        /// <summary>
        /// Search products
        /// </summary>
        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            LoadProducts(txtSearch.Text.Trim());
        }

        /// <summary>
        /// GridView Edit mode
        /// </summary>
        protected void gvProducts_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvProducts.EditIndex = e.NewEditIndex;
            LoadProducts(txtSearch.Text.Trim());
        }

        /// <summary>
        /// GridView Row Data Bound
        /// </summary>
        protected void gvProducts_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow && gvProducts.EditIndex == e.Row.RowIndex)
            {
                // This is the edit row, load categories
                DropDownList ddlEditCategory = (DropDownList)e.Row.FindControl("ddlEditCategory");

                if (ddlEditCategory != null)
                {
                    try
                    {
                        // Load categories
                        using (var context = new TechHubContext())
                        {
                            var categories = context.Categories
                                .Where(c => c.IsActive)
                                .OrderBy(c => c.CategoryName)
                                .ToList();

                            ddlEditCategory.DataSource = categories;
                            ddlEditCategory.DataTextField = "CategoryName";
                            ddlEditCategory.DataValueField = "CategoryID";
                            ddlEditCategory.DataBind();
                        }

                        // Set the selected value from the current product
                        Product product = (Product)e.Row.DataItem;
                        if (product != null)
                        {
                            ddlEditCategory.SelectedValue = product.CategoryID.ToString();
                        }
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine("Error in RowDataBound: " + ex.Message);
                    }
                }
            }
        }

        /// <summary>
        /// GridView Cancel Edit
        /// </summary>
        protected void gvProducts_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvProducts.EditIndex = -1;
            LoadProducts(txtSearch.Text.Trim());
        }

        /// <summary>
        /// GridView Update product
        /// </summary>
        protected void gvProducts_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            try
            {
                int productId = Convert.ToInt32(gvProducts.DataKeys[e.RowIndex].Value);
                GridViewRow row = gvProducts.Rows[e.RowIndex];

                // Get updated values
                string name = ((TextBox)row.FindControl("txtEditName")).Text.Trim();
                string brand = ((TextBox)row.FindControl("txtEditBrand")).Text.Trim();
                int categoryId = Convert.ToInt32(((DropDownList)row.FindControl("ddlEditCategory")).SelectedValue);
                decimal price = Convert.ToDecimal(((TextBox)row.FindControl("txtEditPrice")).Text);
                int stock = Convert.ToInt32(((TextBox)row.FindControl("txtEditStock")).Text);
                bool isActive = ((CheckBox)row.FindControl("chkEditIsActive")).Checked;

                using (var context = new TechHubContext())
                {
                    var product = context.Products.Find(productId);

                    if (product != null)
                    {
                        product.Name = name;
                        product.Brand = brand;
                        product.CategoryID = categoryId;
                        product.Price = price;
                        product.StockQuantity = stock;
                        product.IsActive = isActive;

                        context.SaveChanges();
                        ShowMessage($"Product '{product.Name}' updated successfully!", true);
                    }
                }

                gvProducts.EditIndex = -1;
                LoadProducts(txtSearch.Text.Trim());
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error updating product: " + ex.Message);
                ShowMessage("Error updating product: " + ex.Message, false);
            }
        }

        /// <summary>
        /// GridView Delete product (soft delete)
        /// </summary>
        protected void gvProducts_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                int productId = Convert.ToInt32(gvProducts.DataKeys[e.RowIndex].Value);

                using (var context = new TechHubContext())
                {
                    var product = context.Products.Find(productId);

                    if (product != null)
                    {
                        // Soft delete - set IsActive to false
                        product.IsActive = false;
                        context.SaveChanges();
                        ShowMessage($"Product '{product.Name}' deleted successfully!", true);
                    }
                }

                LoadProducts(txtSearch.Text.Trim());
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error deleting product: " + ex.Message);
                ShowMessage("Error deleting product: " + ex.Message, false);
            }
        }

        /// <summary>
        /// GridView pagination
        /// </summary>
        protected void gvProducts_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvProducts.PageIndex = e.NewPageIndex;
            LoadProducts(txtSearch.Text.Trim());
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