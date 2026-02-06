using System;
using System.Collections.Generic;
using System.Data.Entity; // for Include()
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using TechHubWebForms.DAL;

namespace TechHubWebForms.Cart
{
    public partial class Cart : Page
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
                LoadCart();
            }
        }

        private void LoadCart()
        {
            try
            {
                using (var context = new TechHubContext())
                {
                    // Get current user (by email stored in Identity.Name)
                    string userEmail = User.Identity.Name;
                    var user = context.Users.FirstOrDefault(u => u.Email == userEmail);

                    if (user == null)
                    {
                        ShowMessage("User not found", false);
                        pnlCartItems.Visible = false;
                        pnlEmptyCart.Visible = true;
                        return;
                    }

                    // ✅ IMPORTANT: Explicitly force EF Model Cart type
                    List<TechHubWebForms.Models.Cart> cartItems = context.Carts
                        .Include(c => c.Product)
                        .Include(c => c.Product.Category)
                        .Where(c => c.UserID == user.UserID)
                        .OrderByDescending(c => c.DateAdded)
                        .ToList();

                    if (cartItems.Any())
                    {
                        // Bind UI
                        rptCartItems.DataSource = cartItems;
                        rptCartItems.DataBind();

                        pnlCartItems.Visible = true;
                        pnlEmptyCart.Visible = false;

                        // Totals
                        CalculateTotals(cartItems);
                    }
                    else
                    {
                        pnlCartItems.Visible = false;
                        pnlEmptyCart.Visible = true;

                        // Reset totals display (optional but cleaner)
                        lblItemCount.Text = "0";
                        lblSubtotal.Text = "0";
                        lblDeliveryFee.Text = "FREE";
                        lblTotal.Text = "0";
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading cart: " + ex);
                ShowMessage("Error loading cart", false);

                pnlCartItems.Visible = false;
                pnlEmptyCart.Visible = true;
            }
        }

        // ✅ IMPORTANT: Explicit model list type
        private void CalculateTotals(List<TechHubWebForms.Models.Cart> cartItems)
        {
            try
            {
                // Total quantity
                int itemCount = cartItems.Sum(c => c.Quantity);
                lblItemCount.Text = itemCount.ToString();

                // Subtotal (safe against null Product)
                decimal subtotal = cartItems.Sum(c =>
                    (c.Product != null ? c.Product.Price : 0m) * c.Quantity
                );

                lblSubtotal.Text = string.Format("{0:N0}", subtotal);

                // Delivery fee
                decimal deliveryFee = 0m;
                lblDeliveryFee.Text = deliveryFee > 0 ? string.Format("NPR {0:N0}", deliveryFee) : "FREE";

                // Total
                decimal total = subtotal + deliveryFee;
                lblTotal.Text = string.Format("{0:N0}", total);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error calculating totals: " + ex);
            }
        }

        protected void rptCartItems_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            try
            {
                if (e.CommandName == "IncreaseQuantity")
                {
                    // CommandArgument: "CartID,StockQuantity"
                    string[] args = e.CommandArgument.ToString().Split(',');
                    int cartId = Convert.ToInt32(args[0]);
                    int stockQuantity = Convert.ToInt32(args[1]);

                    using (var context = new TechHubContext())
                    {
                        var cartItem = context.Carts.Find(cartId);

                        if (cartItem == null)
                        {
                            ShowMessage("Cart item not found", false);
                            LoadCart();
                            return;
                        }

                        if (cartItem.Quantity < stockQuantity)
                        {
                            cartItem.Quantity++;
                            cartItem.DateAdded = DateTime.Now;
                            context.SaveChanges();
                            ShowMessage("Quantity updated successfully", true);
                        }
                        else
                        {
                            ShowMessage($"Cannot add more. Only {stockQuantity} items available in stock", false);
                        }
                    }

                    LoadCart();
                }
                else if (e.CommandName == "DecreaseQuantity")
                {
                    int cartId = Convert.ToInt32(e.CommandArgument);

                    using (var context = new TechHubContext())
                    {
                        var cartItem = context.Carts.Find(cartId);

                        if (cartItem == null)
                        {
                            ShowMessage("Cart item not found", false);
                            LoadCart();
                            return;
                        }

                        if (cartItem.Quantity > 1)
                        {
                            cartItem.Quantity--;
                            cartItem.DateAdded = DateTime.Now;
                            context.SaveChanges();
                            ShowMessage("Quantity updated successfully", true);
                        }
                        else
                        {
                            ShowMessage("Quantity cannot be less than 1. Use remove button to delete item", false);
                        }
                    }

                    LoadCart();
                }
                else if (e.CommandName == "RemoveItem")
                {
                    int cartId = Convert.ToInt32(e.CommandArgument);

                    using (var context = new TechHubContext())
                    {
                        var cartItem = context.Carts.Find(cartId);

                        if (cartItem == null)
                        {
                            ShowMessage("Cart item not found", false);
                            LoadCart();
                            return;
                        }

                        context.Carts.Remove(cartItem);
                        context.SaveChanges();
                        ShowMessage("Item removed from cart", true);
                    }

                    LoadCart();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in cart operation: " + ex);
                ShowMessage("Error updating cart", false);
                LoadCart();
            }
        }

        protected void btnCheckout_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Checkout/Checkout.aspx");
        }

        protected void btnClearCart_Click(object sender, EventArgs e)
        {
            try
            {
                using (var context = new TechHubContext())
                {
                    string userEmail = User.Identity.Name;
                    var user = context.Users.FirstOrDefault(u => u.Email == userEmail);

                    if (user == null)
                    {
                        ShowMessage("User not found", false);
                        return;
                    }

                    var cartItems = context.Carts.Where(c => c.UserID == user.UserID).ToList();

                    if (cartItems.Any())
                    {
                        context.Carts.RemoveRange(cartItems);
                        context.SaveChanges();
                        ShowMessage("Cart cleared successfully", true);
                    }
                    else
                    {
                        ShowMessage("Cart is already empty", false);
                    }
                }

                LoadCart();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error clearing cart: " + ex);
                ShowMessage("Error clearing cart", false);
            }
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
    }
}
