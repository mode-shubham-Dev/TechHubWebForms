using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using TechHubWebForms.DAL;
using TechHubWebForms.Models;
using TechHubWebForms.Helpers;  // ✅ ADDED for EmailHelper
using CartModel = TechHubWebForms.Models.Cart;

namespace TechHubWebForms.Checkout
{
    public partial class Checkout : Page
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
                LoadUserInfo();
                LoadCartItems();
                CalculateTotal();
            }
        }

        private void LoadUserInfo()
        {
            try
            {
                using (var context = new TechHubContext())
                {
                    string userEmail = User.Identity.Name;
                    var user = context.Users.FirstOrDefault(u => u.Email == userEmail);

                    if (user != null)
                    {
                        // Pre-fill user information
                        txtFullName.Text = user.Name;
                        txtPhone.Text = user.Phone ?? "";
                        txtAddress.Text = user.Address ?? "";
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading user info: " + ex.Message);
            }
        }

        private void LoadCartItems()
        {
            try
            {
                using (var context = new TechHubContext())
                {
                    string userEmail = User.Identity.Name;
                    var user = context.Users.FirstOrDefault(u => u.Email == userEmail);

                    if (user == null)
                    {
                        ShowEmptyCart();
                        return;
                    }

                    var cartItems = context.Carts
                        .Include(c => c.Product)
                        .Where(c => c.UserID == user.UserID)
                        .ToList();

                    if (cartItems.Any())
                    {
                        rptOrderItems.DataSource = cartItems;
                        rptOrderItems.DataBind();
                        pnlCheckout.Visible = true;
                        pnlEmptyCart.Visible = false;
                    }
                    else
                    {
                        ShowEmptyCart();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading cart items: " + ex.Message);
                ShowEmptyCart();
            }
        }

        private void CalculateTotal()
        {
            try
            {
                using (var context = new TechHubContext())
                {
                    string userEmail = User.Identity.Name;
                    var user = context.Users.FirstOrDefault(u => u.Email == userEmail);

                    if (user == null) return;

                    var cartItems = context.Carts
                        .Include(c => c.Product)
                        .Where(c => c.UserID == user.UserID)
                        .ToList();

                    if (!cartItems.Any()) return;

                    // Calculate subtotal
                    decimal subtotal = cartItems.Sum(c => c.Product.Price * c.Quantity);
                    lblSubtotal.Text = string.Format("{0:N0}", subtotal);

                    // Delivery fee
                    decimal deliveryFee = 0;
                    lblDeliveryFee.Text = deliveryFee > 0 ? string.Format("NPR {0:N0}", deliveryFee) : "FREE";

                    // Get applied discount from ViewState
                    decimal appliedDiscount = 0;
                    if (ViewState["AppliedDiscount"] != null)
                    {
                        appliedDiscount = Convert.ToDecimal(ViewState["AppliedDiscount"]);
                        pnlDiscount.Visible = true;
                        lblDiscount.Text = string.Format("{0:N0}", appliedDiscount);
                    }
                    else
                    {
                        pnlDiscount.Visible = false;
                    }

                    // Calculate total
                    decimal total = subtotal + deliveryFee - appliedDiscount;
                    if (total < 0) total = 0;

                    lblTotal.Text = string.Format("{0:N0}", total);

                    // Store total in ViewState
                    ViewState["TotalAmount"] = total;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error calculating total: " + ex.Message);
            }
        }

        protected void btnApplyCoupon_Click(object sender, EventArgs e)
        {
            string couponCode = txtCouponCode.Text.Trim().ToUpper();

            if (string.IsNullOrEmpty(couponCode))
            {
                lblCouponMessage.Text = "Please enter a coupon code";
                lblCouponMessage.ForeColor = System.Drawing.Color.FromArgb(239, 68, 68);
                return;
            }

            try
            {
                using (var context = new TechHubContext())
                {
                    var coupon = context.Coupons.FirstOrDefault(c => c.CouponCode.ToUpper() == couponCode && c.IsActive);

                    if (coupon == null)
                    {
                        lblCouponMessage.Text = "Invalid coupon code";
                        lblCouponMessage.ForeColor = System.Drawing.Color.FromArgb(239, 68, 68);
                        return;
                    }

                    // Check if coupon is valid
                    DateTime now = DateTime.Now;
                    if (now < coupon.StartDate || now > coupon.EndDate)
                    {
                        lblCouponMessage.Text = "This coupon has expired";
                        lblCouponMessage.ForeColor = System.Drawing.Color.FromArgb(239, 68, 68);
                        return;
                    }

                    // Check usage limit
                    if (coupon.UsedCount >= coupon.UsageLimit)
                    {
                        lblCouponMessage.Text = "This coupon has reached its usage limit";
                        lblCouponMessage.ForeColor = System.Drawing.Color.FromArgb(239, 68, 68);
                        return;
                    }

                    // Calculate discount
                    string userEmail = User.Identity.Name;
                    var user = context.Users.FirstOrDefault(u => u.Email == userEmail);
                    if (user == null) return;

                    var cartItems = context.Carts
                        .Include(c => c.Product)
                        .Where(c => c.UserID == user.UserID)
                        .ToList();

                    decimal subtotal = cartItems.Sum(c => c.Product.Price * c.Quantity);
                    decimal discount = (subtotal * coupon.DiscountPercentage) / 100;

                    // Store discount and coupon ID in ViewState
                    ViewState["AppliedDiscount"] = discount;
                    ViewState["AppliedCouponId"] = coupon.CouponID;

                    lblCouponMessage.Text = $"✓ Coupon applied! You saved NPR {discount:N0} ({coupon.DiscountPercentage}% off)";
                    lblCouponMessage.ForeColor = System.Drawing.Color.FromArgb(16, 185, 129);

                    // Recalculate total
                    CalculateTotal();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error applying coupon: " + ex.Message);
                lblCouponMessage.Text = "Error applying coupon";
                lblCouponMessage.ForeColor = System.Drawing.Color.FromArgb(239, 68, 68);
            }
        }

        protected void btnPlaceOrder_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
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
                        ShowMessage("User not found", false);
                        return;
                    }

                    // Get cart items
                    var cartItems = context.Carts
                        .Include(c => c.Product)
                        .Where(c => c.UserID == user.UserID)
                        .ToList();

                    if (!cartItems.Any())
                    {
                        ShowMessage("Your cart is empty", false);
                        ShowEmptyCart();
                        return;
                    }

                    // Validate stock availability
                    foreach (var item in cartItems)
                    {
                        if (item.Product.StockQuantity < item.Quantity)
                        {
                            ShowMessage($"Sorry, {item.Product.Name} is out of stock or insufficient quantity available", false);
                            return;
                        }
                    }

                    // Get total amount from ViewState
                    decimal totalAmount = ViewState["TotalAmount"] != null ? Convert.ToDecimal(ViewState["TotalAmount"]) : 0;

                    // Create Order
                    var order = new Order
                    {
                        UserID = user.UserID,
                        TotalAmount = totalAmount,
                        OrderStatus = "Pending",
                        PaymentMethod = rblPaymentMethod.SelectedValue,
                        ShippingAddress = txtAddress.Text.Trim(),
                        ContactPhone = txtPhone.Text.Trim(),
                        OrderDate = DateTime.Now,
                        Notes = txtNotes.Text.Trim()
                    };

                    context.Orders.Add(order);
                    context.SaveChanges();

                    // Create Order Details and Update Stock
                    foreach (var cartItem in cartItems)
                    {
                        var orderDetail = new OrderDetail
                        {
                            OrderID = order.OrderID,
                            ProductID = cartItem.ProductID,
                            Quantity = cartItem.Quantity,
                            UnitPrice = cartItem.Product.Price,
                            Subtotal = cartItem.Product.Price * cartItem.Quantity
                        };
                        context.OrderDetails.Add(orderDetail);

                        // Update product stock
                        var product = context.Products.Find(cartItem.ProductID);
                        if (product != null)
                        {
                            product.StockQuantity -= cartItem.Quantity;
                        }
                    }

                    // Update coupon usage if applied
                    if (ViewState["AppliedCouponId"] != null)
                    {
                        int couponId = Convert.ToInt32(ViewState["AppliedCouponId"]);
                        var coupon = context.Coupons.Find(couponId);
                        if (coupon != null)
                        {
                            coupon.UsedCount++;
                        }
                    }

                    // Clear cart
                    context.Carts.RemoveRange(cartItems);

                    // Save all changes
                    context.SaveChanges();

                    // ✅ NEW: Send order confirmation email
                    try
                    {
                        // Reload order with details for email
                        var orderWithDetails = context.Orders
                            .Include(o => o.OrderDetails.Select(od => od.Product))
                            .FirstOrDefault(o => o.OrderID == order.OrderID);

                        if (orderWithDetails != null)
                        {
                            string orderDetails = BuildOrderDetailsHtml(orderWithDetails);
                            bool emailSent = EmailHelper.SendOrderConfirmation(
                                user.Email,
                                user.Name,
                                orderWithDetails.OrderID,
                                orderWithDetails.TotalAmount,
                                orderDetails
                            );

                            if (emailSent)
                            {
                                System.Diagnostics.Debug.WriteLine($"Order confirmation email sent to {user.Email}");
                            }
                        }
                    }
                    catch (Exception emailEx)
                    {
                        System.Diagnostics.Debug.WriteLine($"Email send failed: {emailEx.Message}");
                        // Continue even if email fails - don't block the order
                    }

                    // Redirect to order confirmation page
                    Response.Redirect($"~/Checkout/OrderConfirmation.aspx?orderId={order.OrderID}");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error placing order: " + ex.Message);
                ShowMessage("Failed to place order. Please try again.", false);
            }
        }

        /// <summary>
        /// Build HTML for order details email
        /// </summary>
        private string BuildOrderDetailsHtml(Models.Order order)
        {
            var html = "<ul style='padding-left: 20px;'>";

            foreach (var item in order.OrderDetails)
            {
                html += $@"
                    <li style='margin-bottom: 10px;'>
                        <strong>{item.Product.Name}</strong><br>
                        Quantity: {item.Quantity} × NPR {item.UnitPrice:N0} = NPR {item.Subtotal:N0}
                    </li>";
            }

            html += "</ul>";
            return html;
        }

        private void ShowMessage(string message, bool isSuccess)
        {
            pnlMessage.Visible = true;
            divMessage.InnerText = message;

            if (isSuccess)
            {
                divMessage.Style["background"] = "#d1fae5";
                divMessage.Style["color"] = "#065f46";
                divMessage.Style["border"] = "1px solid #6ee7b7";
            }
            else
            {
                divMessage.Style["background"] = "#fee2e2";
                divMessage.Style["color"] = "#991b1b";
                divMessage.Style["border"] = "1px solid #fca5a5";
            }
        }

        private void ShowEmptyCart()
        {
            pnlCheckout.Visible = false;
            pnlEmptyCart.Visible = true;
        }
    }
}