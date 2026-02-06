using System;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;
using TechHubWebForms.DAL;

namespace TechHubWebForms.Checkout
{
    public partial class OrderConfirmation : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!User.Identity.IsAuthenticated)
            {
                Response.Redirect("~/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadOrderDetails();
            }
        }

        private void LoadOrderDetails()
        {
            // Get order ID from query string
            if (Request.QueryString["orderId"] == null)
            {
                ShowError();
                return;
            }

            int orderId;
            if (!int.TryParse(Request.QueryString["orderId"], out orderId))
            {
                ShowError();
                return;
            }

            try
            {
                using (var context = new TechHubContext())
                {
                    // Get current user
                    string userEmail = User.Identity.Name;
                    var user = context.Users.FirstOrDefault(u => u.Email == userEmail);

                    if (user == null)
                    {
                        ShowError();
                        return;
                    }

                    // Get order (make sure it belongs to current user)
                    var order = context.Orders
                        .Include("OrderDetails")
                        .Include("OrderDetails.Product")
                        .FirstOrDefault(o => o.OrderID == orderId && o.UserID == user.UserID);

                    if (order == null)
                    {
                        ShowError();
                        return;
                    }

                    // Display order information
                    lblOrderID.Text = order.OrderID.ToString();
                    lblOrderDate.Text = order.OrderDate.ToString("MMMM dd, yyyy hh:mm tt");
                    lblOrderStatus.Text = order.OrderStatus;
                    lblTotalAmount.Text = string.Format("{0:N0}", order.TotalAmount);
                    lblShippingAddress.Text = order.ShippingAddress ?? "N/A";
                    lblContactPhone.Text = order.ContactPhone ?? "N/A";
                    lblPaymentMethod.Text = order.PaymentMethod;
                    lblUserEmail.Text = user.Email;

                    // Payment method note
                    switch (order.PaymentMethod.ToLower())
                    {
                        case "cod":
                            lblPaymentNote.Text = "Pay cash when your order is delivered";
                            break;
                        case "online":
                            lblPaymentNote.Text = "Payment processed successfully";
                            break;
                        case "bank transfer":
                            lblPaymentNote.Text = "Transfer details sent to your email";
                            break;
                        default:
                            lblPaymentNote.Text = "";
                            break;
                    }

                    // Bind order items
                    if (order.OrderDetails.Any())
                    {
                        rptOrderItems.DataSource = order.OrderDetails.ToList();
                        rptOrderItems.DataBind();
                    }

                    // Show success panel
                    pnlSuccess.Visible = true;
                    pnlError.Visible = false;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading order confirmation: " + ex.Message);
                ShowError();
            }
        }

        private void ShowError()
        {
            pnlSuccess.Visible = false;
            pnlError.Visible = true;
        }
    }
}