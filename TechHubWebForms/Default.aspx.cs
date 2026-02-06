using System;
using System.Linq;
using System.Web.UI;
using TechHubWebForms.DAL;

namespace TechHubWebForms
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadStatistics();
                LoadCategories();
                LoadFeaturedProducts();
            }
        }

        private void LoadStatistics()
        {
            try
            {
                using (var context = new TechHubContext())
                {
                    // Get total product count
                    var productCount = context.Products.Count(p => p.IsActive);
                    lblProductCount.Text = productCount.ToString();

                    // Get total user count
                    var userCount = context.Users.Count(u => u.IsActive);
                    lblUserCount.Text = userCount.ToString();
                }
            }
            catch (Exception ex)
            {
                // Log error (in production, use proper logging)
                System.Diagnostics.Debug.WriteLine("Error loading statistics: " + ex.Message);
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
                        .Take(6)
                        .ToList();

                    rptCategories.DataSource = categories;
                    rptCategories.DataBind();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading categories: " + ex.Message);
            }
        }

        private void LoadFeaturedProducts()
        {
            try
            {
                using (var context = new TechHubContext())
                {
                    // Get 8 random featured products
                    var products = context.Products
                        .Where(p => p.IsActive && p.StockQuantity > 0)
                        .OrderBy(p => Guid.NewGuid()) // Random order
                        .Take(8)
                        .ToList();

                    rptFeaturedProducts.DataSource = products;
                    rptFeaturedProducts.DataBind();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading products: " + ex.Message);
            }
        }

        protected string GetCategoryIcon(string categoryName)
        {
            // Return Font Awesome icon class based on category name
            switch (categoryName.ToLower())
            {
                case "smartphones":
                    return "fas fa-mobile-alt";
                case "laptops":
                    return "fas fa-laptop";
                case "audio":
                    return "fas fa-headphones";
                case "wearables":
                    return "fas fa-watch";
                case "gaming":
                    return "fas fa-gamepad";
                case "accessories":
                    return "fas fa-plug";
                default:
                    return "fas fa-box";
            }
        }

        protected void btnSubscribe_Click(object sender, EventArgs e)
        {
            // Newsletter subscription logic (for now, just show success message)
            if (!string.IsNullOrWhiteSpace(txtEmail.Text))
            {
                // In production, save to database
                Response.Write("<script>alert('Thank you for subscribing!');</script>");
                txtEmail.Text = "";
            }
        }
    }
}