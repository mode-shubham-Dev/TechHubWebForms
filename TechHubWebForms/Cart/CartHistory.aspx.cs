using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using TechHubWebForms.DAL;

namespace TechHubWebForms.Cart
{
    public partial class CartHistory : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (!User.Identity.IsAuthenticated)
            {
                Response.Redirect("~/Account/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.Url.PathAndQuery));
                return;
            }

            if (!IsPostBack)
            {
                LoadOrders();
            }
        }

        private void LoadOrders()
        {
            try
            {
                using (var context = new TechHubContext())
                {
                    // Get current user
                    string userEmail = User.Identity.Name;
                    var user = context.Users.FirstOrDefault(u => u.Email == userEmail);

                    if (user == null)
                    {
                        return;
                    }

                    // Get orders for current user
                    var ordersQuery = context.Orders
                        .Include("OrderDetails")
                        .Include("OrderDetails.Product")
                        .Where(o => o.UserID == user.UserID);

                    // Apply status filter
                    string statusFilter = ddlStatusFilter.SelectedValue;
                    if (statusFilter != "All")
                    {
                        ordersQuery = ordersQuery.Where(o => o.OrderStatus == statusFilter);
                    }

                    // Order by date (newest first)
                    var orders = ordersQuery.OrderByDescending(o => o.OrderDate).ToList();

                    if (orders.Any())
                    {
                        rptOrders.DataSource = orders;
                        rptOrders.DataBind();
                        pnlOrders.Visible = true;
                        pnlNoOrders.Visible = false;

                        // Update order count
                        lblOrderCount.Text = $"Showing {orders.Count} order(s)";
                    }
                    else
                    {
                        pnlOrders.Visible = false;
                        pnlNoOrders.Visible = true;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading orders: " + ex.Message);
            }
        }

        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadOrders();
        }

        protected void rptOrders_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ViewDetails")
            {
                int orderId = Convert.ToInt32(e.CommandArgument);
                ShowOrderDetails(orderId);
            }
        }

        private void ShowOrderDetails(int orderId)
        {
            try
            {
                using (var context = new TechHubContext())
                {
                    var order = context.Orders
                        .Include("OrderDetails")
                        .Include("OrderDetails.Product")
                        .FirstOrDefault(o => o.OrderID == orderId);

                    if (order != null)
                    {
                        // Bind order information
                        lblOrderID.Text = order.OrderID.ToString();
                        lblDetailOrderDate.Text = order.OrderDate.ToString("MMMM dd, yyyy hh:mm tt");
                        lblDetailStatus.Text = $"<span style='{GetStatusStyle(order.OrderStatus)}'>{order.OrderStatus}</span>";
                        lblDetailPayment.Text = order.PaymentMethod;
                        lblDetailAddress.Text = order.ShippingAddress ?? "N/A";
                        lblDetailTotal.Text = string.Format("{0:N0}", order.TotalAmount);

                        // Bind order items
                        rptOrderItems.DataSource = order.OrderDetails.ToList();
                        rptOrderItems.DataBind();

                        // Show modal
                        pnlOrderDetails.Visible = true;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading order details: " + ex.Message);
            }
        }

        protected void btnCloseDetails_Click(object sender, EventArgs e)
        {
            pnlOrderDetails.Visible = false;
        }

        // Helper method to get status badge styling
        protected string GetStatusStyle(string status)
        {
            string baseStyle = "display: inline-block; padding: 6px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; text-transform: uppercase;";

            switch (status?.ToLower())
            {
                case "pending":
                    return baseStyle + " background: #fef3c7; color: #92400e;";
                case "processing":
                    return baseStyle + " background: #dbeafe; color: #1e40af;";
                case "shipped":
                    return baseStyle + " background: #e0e7ff; color: #4338ca;";
                case "delivered":
                    return baseStyle + " background: #d1fae5; color: #065f46;";
                case "cancelled":
                    return baseStyle + " background: #fee2e2; color: #991b1b;";
                default:
                    return baseStyle + " background: #f1f5f9; color: #475569;";
            }
        }
    }
}
