using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using TechHubWebForms.DAL;
using TechHubWebForms.Models;
using CartModel = TechHubWebForms.Models.Cart;

namespace TechHubWebForms
{
    public partial class Wishlist : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!User.Identity.IsAuthenticated)
            {
                Response.Redirect("~/Account/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.Url.PathAndQuery));
                return;
            }

            if (!IsPostBack)
            {
                LoadWishlist();
            }
        }

        private void LoadWishlist()
        {
            try
            {
                using (var context = new TechHubContext())
                {
                    string userEmail = User.Identity.Name;
                    var user = context.Users.FirstOrDefault(u => u.Email == userEmail);

                    if (user == null)
                    {
                        ShowEmptyWishlist();
                        return;
                    }

                    var wishlistItems = context.Wishlists
                        .Include("Product")
                        .Include("Product.Category")
                        .Where(w => w.UserID == user.UserID)
                        .OrderByDescending(w => w.DateAdded)
                        .ToList();

                    if (wishlistItems.Any())
                    {
                        rptWishlistItems.DataSource = wishlistItems;
                        rptWishlistItems.DataBind();
                        pnlWishlistItems.Visible = true;
                        pnlEmptyWishlist.Visible = false;

                        lblItemCount.Text = wishlistItems.Count.ToString();
                    }
                    else
                    {
                        ShowEmptyWishlist();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading wishlist: " + ex.Message);
                ShowEmptyWishlist();
            }
        }

        protected void rptWishlistItems_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            try
            {
                if (e.CommandName == "AddToCart")
                {
                    // Parse ProductID and StockQuantity
                    string[] args = e.CommandArgument.ToString().Split(',');
                    int productId = Convert.ToInt32(args[0]);
                    int stockQuantity = Convert.ToInt32(args[1]);

                    if (stockQuantity <= 0)
                    {
                        ShowMessage("Product is out of stock", false);
                        return;
                    }

                    using (var context = new TechHubContext())
                    {
                        string userEmail = User.Identity.Name;
                        var user = context.Users.FirstOrDefault(u => u.Email == userEmail);

                        if (user == null)
                        {
                            ShowMessage("User not found", false);
                            return;
                        }

                        // Check if product already in cart
                        var existingCartItem = context.Carts
                            .FirstOrDefault(c => c.UserID == user.UserID && c.ProductID == productId);

                        if (existingCartItem != null)
                        {
                            // Update quantity if stock allows
                            if (existingCartItem.Quantity < stockQuantity)
                            {
                                existingCartItem.Quantity++;
                                existingCartItem.DateAdded = DateTime.Now;
                            }
                            else
                            {
                                ShowMessage("Cannot add more. Maximum stock reached in cart", false);
                                return;
                            }
                        }
                        else
                        {
                            // Add new cart item
                            var cartItem = new CartModel
                            {
                                UserID = user.UserID,
                                ProductID = productId,
                                Quantity = 1,
                                DateAdded = DateTime.Now
                            };
                            context.Carts.Add(cartItem);
                        }

                        context.SaveChanges();
                        ShowMessage("Product added to cart successfully!", true);
                    }
                }
                else if (e.CommandName == "RemoveItem")
                {
                    int wishlistId = Convert.ToInt32(e.CommandArgument);

                    using (var context = new TechHubContext())
                    {
                        var wishlistItem = context.Wishlists.Find(wishlistId);
                        if (wishlistItem != null)
                        {
                            context.Wishlists.Remove(wishlistItem);
                            context.SaveChanges();
                            ShowMessage("Item removed from wishlist", true);
                        }
                    }

                    LoadWishlist();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in wishlist operation: " + ex.Message);
                ShowMessage("Error processing request", false);
            }
        }

        protected void btnClearWishlist_Click(object sender, EventArgs e)
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

                    var wishlistItems = context.Wishlists.Where(w => w.UserID == user.UserID).ToList();

                    if (wishlistItems.Any())
                    {
                        context.Wishlists.RemoveRange(wishlistItems);
                        context.SaveChanges();
                        ShowMessage("Wishlist cleared successfully", true);
                        LoadWishlist();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error clearing wishlist: " + ex.Message);
                ShowMessage("Error clearing wishlist", false);
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

        private void ShowEmptyWishlist()
        {
            pnlWishlistItems.Visible = false;
            pnlEmptyWishlist.Visible = true;
        }
    }
}