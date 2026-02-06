using System;
using System.Data.Entity;
using System.Linq;
using System.Web.UI;
using TechHubWebForms.DAL;

namespace TechHubWebForms.Admin
{
    public partial class Dashboard : Page
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
                LoadStatistics();
                LoadRecentOrders();
                LoadLowStockProducts();
            }
        }

        /// <summary>
        /// Load dashboard statistics from database
        /// </summary>
        private void LoadStatistics()
        {
            try
            {
                using (var context = new TechHubContext())
                {
                    // Total Products
                    int totalProducts = context.Products.Count(p => p.IsActive);
                    lblTotalProducts.Text = totalProducts.ToString();

                    // Total Users
                    int totalUsers = context.Users.Count(u => u.IsActive);
                    lblTotalUsers.Text = totalUsers.ToString();

                    // Total Orders
                    int totalOrders = context.Orders.Count();
                    lblTotalOrders.Text = totalOrders.ToString();

                    // Total Revenue
                    decimal totalRevenue = context.Orders
                        .Where(o => o.OrderStatus != "Cancelled")
                        .Sum(o => (decimal?)o.TotalAmount) ?? 0m;
                    lblTotalRevenue.Text = string.Format("{0:N0}", totalRevenue);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading statistics: " + ex.Message);
                // Set default values on error
                lblTotalProducts.Text = "0";
                lblTotalUsers.Text = "0";
                lblTotalOrders.Text = "0";
                lblTotalRevenue.Text = "0";
            }
        }

        /// <summary>
        /// Load recent orders (last 5)
        /// </summary>
        private void LoadRecentOrders()
        {
            try
            {
                using (var context = new TechHubContext())
                {
                    // Get last 5 orders with user details
                    var recentOrders = context.Orders
                        .Include(o => o.User)
                        .OrderByDescending(o => o.OrderDate)
                        .Take(5)
                        .ToList();

                    if (recentOrders.Any())
                    {
                        rptRecentOrders.DataSource = recentOrders;
                        rptRecentOrders.DataBind();

                        pnlRecentOrders.Visible = true;
                        pnlNoOrders.Visible = false;
                    }
                    else
                    {
                        pnlRecentOrders.Visible = false;
                        pnlNoOrders.Visible = true;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading recent orders: " + ex.Message);
                pnlRecentOrders.Visible = false;
                pnlNoOrders.Visible = true;
            }
        }

        /// <summary>
        /// Load products with low stock (less than 10 units)
        /// </summary>
        private void LoadLowStockProducts()
        {
            try
            {
                using (var context = new TechHubContext())
                {
                    // Get products with stock less than 10
                    var lowStockProducts = context.Products
                        .Include(p => p.Category)
                        .Where(p => p.IsActive && p.StockQuantity < 10)
                        .OrderBy(p => p.StockQuantity)
                        .Take(10)
                        .ToList();

                    if (lowStockProducts.Any())
                    {
                        rptLowStock.DataSource = lowStockProducts;
                        rptLowStock.DataBind();

                        pnlLowStock.Visible = true;
                        pnlNoLowStock.Visible = false;
                    }
                    else
                    {
                        pnlLowStock.Visible = false;
                        pnlNoLowStock.Visible = true;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading low stock products: " + ex.Message);
                pnlLowStock.Visible = false;
                pnlNoLowStock.Visible = true;
            }
        }
    }
}