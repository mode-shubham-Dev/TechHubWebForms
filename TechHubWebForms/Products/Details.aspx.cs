using System;
using System.Data.Entity;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using TechHubWebForms.DAL;
using TechHubWebForms.Models;
using CartModel = TechHubWebForms.Models.Cart;
using WishlistModel = TechHubWebForms.Models.Wishlist;

namespace TechHubWebForms.Products
{
    public partial class Details : Page
    {
        private int ProductId
        {
            get
            {
                if (Request.QueryString["id"] != null)
                {
                    int id;
                    if (int.TryParse(Request.QueryString["id"], out id))
                    {
                        return id;
                    }
                }
                return 0;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadProductDetails();
                LoadReviews();
                LoadRelatedProducts();
                CheckUserLoginForReview();
            }
        }

        private void LoadProductDetails()
        {
            if (ProductId == 0)
            {
                ShowNotFound();
                return;
            }

            try
            {
                using (var context = new TechHubContext())
                {
                    var product = context.Products
                        .Include("Category")
                        .FirstOrDefault(p => p.ProductID == ProductId && p.IsActive);

                    if (product == null)
                    {
                        ShowNotFound();
                        return;
                    }

                    // Bind product data
                    lblBrand.Text = product.Brand;
                    lblProductName.Text = product.Name;
                    lblPrice.Text = string.Format("{0:N0}", product.Price);
                    lblDescription.Text = product.Description;
                    lblSpecifications.Text = product.Specifications ?? "No specifications available";
                    lblCategory.Text = product.Category?.CategoryName ?? "Uncategorized";

                    // Stock status
                    if (product.StockQuantity > 10)
                    {
                        lblStockStatus.Text = "In Stock";
                        pnlStockBadge.Style["background"] = "#10b981";
                        pnlStockBadge.Style["color"] = "white";
                        btnAddToCart.Enabled = true;
                    }
                    else if (product.StockQuantity > 0)
                    {
                        lblStockStatus.Text = $"Only {product.StockQuantity} left";
                        pnlStockBadge.Style["background"] = "#f59e0b";
                        pnlStockBadge.Style["color"] = "white";
                        btnAddToCart.Enabled = true;
                        txtQuantity.Attributes["max"] = product.StockQuantity.ToString();
                    }
                    else
                    {
                        lblStockStatus.Text = "Out of Stock";
                        pnlStockBadge.Style["background"] = "#ef4444";
                        pnlStockBadge.Style["color"] = "white";
                        btnAddToCart.Enabled = false;
                        btnAddToCart.Text = "Out of Stock";
                    }

                    // Calculate average rating
                    var ratings = context.Ratings.Where(r => r.ProductID == ProductId).ToList();
                    if (ratings.Any())
                    {
                        double avgRating = ratings.Average(r => r.Stars);
                        lblRatingCount.Text = ratings.Count.ToString();
                        litStars.Text = GenerateStars(avgRating);
                    }
                    else
                    {
                        lblRatingCount.Text = "0";
                        litStars.Text = GenerateStars(0);
                    }

                    // Set max quantity
                    txtQuantity.Attributes["max"] = product.StockQuantity.ToString();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading product: " + ex.Message);
                ShowNotFound();
            }
        }

        private void LoadReviews()
        {
            try
            {
                using (var context = new TechHubContext())
                {
                    var reviews = context.Ratings
                        .Include("User")
                        .Where(r => r.ProductID == ProductId)
                        .OrderByDescending(r => r.DatePosted)
                        .ToList();

                    if (reviews.Any())
                    {
                        rptReviews.DataSource = reviews;
                        rptReviews.DataBind();
                        pnlNoReviews.Visible = false;
                    }
                    else
                    {
                        pnlNoReviews.Visible = true;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading reviews: " + ex.Message);
            }
        }

        private void LoadRelatedProducts()
        {
            try
            {
                using (var context = new TechHubContext())
                {
                    var currentProduct = context.Products.Find(ProductId);
                    if (currentProduct != null)
                    {
                        var relatedProducts = context.Products
                            .Where(p => p.CategoryID == currentProduct.CategoryID
                                && p.ProductID != ProductId
                                && p.IsActive)
                            .OrderByDescending(p => p.DateAdded)
                            .Take(4)
                            .ToList();

                        if (relatedProducts.Any())
                        {
                            rptRelatedProducts.DataSource = relatedProducts;
                            rptRelatedProducts.DataBind();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading related products: " + ex.Message);
            }
        }

        private void CheckUserLoginForReview()
        {
            if (User.Identity.IsAuthenticated)
            {
                pnlAddReview.Visible = true;
            }
            else
            {
                pnlAddReview.Visible = false;
            }
        }

        protected void btnAddToCart_Click(object sender, EventArgs e)
        {
            if (!User.Identity.IsAuthenticated)
            {
                ShowMessage("Please login to add items to cart", false);
                Response.Redirect("~/Account/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.Url.PathAndQuery));
                return;
            }

            try
            {
                int quantity = Convert.ToInt32(txtQuantity.Text);
                if (quantity <= 0)
                {
                    ShowMessage("Please enter a valid quantity", false);
                    return;
                }

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

                    // Check product stock
                    var product = context.Products.Find(ProductId);
                    if (product == null || !product.IsActive)
                    {
                        ShowMessage("Product not available", false);
                        return;
                    }

                    if (product.StockQuantity < quantity)
                    {
                        ShowMessage($"Only {product.StockQuantity} items available", false);
                        return;
                    }

                    // Check if product already in cart
                    var existingCartItem = context.Carts
                        .FirstOrDefault(c => c.UserID == user.UserID && c.ProductID == ProductId);

                    if (existingCartItem != null)
                    {
                        // Update quantity
                        existingCartItem.Quantity += quantity;
                        existingCartItem.DateAdded = DateTime.Now;
                    }
                    else
                    {
                        // Add new cart item - Use CartModel alias
                        var cartItem = new CartModel
                        {
                            UserID = user.UserID,
                            ProductID = ProductId,
                            Quantity = quantity,
                            DateAdded = DateTime.Now
                        };
                        context.Carts.Add(cartItem);
                    }

                    context.SaveChanges();
                    ShowMessage("Product added to cart successfully!", true);

                    // Reset quantity
                    txtQuantity.Text = "1";
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error adding to cart: " + ex.Message);
                ShowMessage("Failed to add product to cart", false);
            }
        }

        protected void btnAddToWishlist_Click(object sender, EventArgs e)
        {
            if (!User.Identity.IsAuthenticated)
            {
                ShowMessage("Please login to add items to wishlist", false);
                Response.Redirect("~/Account/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.Url.PathAndQuery));
                return;
            }

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

                    // Check if already in wishlist
                    var existingWishlist = context.Wishlists
                        .FirstOrDefault(w => w.UserID == user.UserID && w.ProductID == ProductId);

                    if (existingWishlist != null)
                    {
                        ShowMessage("Product already in wishlist", false);
                        return;
                    }

                    // Add to wishlist - FIXED: Use WishlistModel alias
                    var wishlistItem = new WishlistModel
                    {
                        UserID = user.UserID,
                        ProductID = ProductId,
                        DateAdded = DateTime.Now
                    };

                    context.Wishlists.Add(wishlistItem);
                    context.SaveChanges();

                    ShowMessage("Product added to wishlist!", true);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error adding to wishlist: " + ex.Message);
                ShowMessage("Failed to add to wishlist", false);
            }
        }

        protected void btnSubmitReview_Click(object sender, EventArgs e)
        {
            if (!User.Identity.IsAuthenticated)
            {
                ShowMessage("Please login to submit a review", false);
                return;
            }

            try
            {
                string review = txtReviewComment.Text.Trim();
                if (string.IsNullOrEmpty(review))
                {
                    ShowMessage("Please write a review comment", false);
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

                    // Check if user already reviewed this product
                    var existingReview = context.Ratings
                        .FirstOrDefault(r => r.UserID == user.UserID && r.ProductID == ProductId);

                    if (existingReview != null)
                    {
                        ShowMessage("You have already reviewed this product", false);
                        return;
                    }

                    // Add new review
                    var rating = new Rating
                    {
                        UserID = user.UserID,
                        ProductID = ProductId,
                        Stars = Convert.ToInt32(ddlRating.SelectedValue),
                        Review = review,
                        DatePosted = DateTime.Now
                    };

                    context.Ratings.Add(rating);
                    context.SaveChanges();

                    ShowMessage("Review submitted successfully!", true);

                    // Clear form
                    txtReviewComment.Text = "";
                    ddlRating.SelectedIndex = 0;

                    // Reload reviews and product details
                    LoadReviews();
                    LoadProductDetails();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error submitting review: " + ex.Message);
                ShowMessage("Failed to submit review", false);
            }
        }

        // THIS METHOD MUST BE PROTECTED (NOT PUBLIC) FOR REPEATER ITEMDATABOUND
        protected void rptReviews_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                var rating = (Rating)e.Item.DataItem;
                var lblStars = (Literal)e.Item.FindControl("litReviewStars");
                if (lblStars != null)
                {
                    lblStars.Text = GetStarRating(rating.Stars);
                }
            }
        }

        // KEEP THIS PROTECTED - It's called from ItemDataBound event
        protected string GetStarRating(int rating)
        {
            string stars = "";
            for (int i = 1; i <= 5; i++)
            {
                if (i <= rating)
                {
                    stars += "⭐";
                }
                else
                {
                    stars += "☆";
                }
            }
            return stars;
        }

        private string GenerateStars(double rating)
        {
            string stars = "";
            int fullStars = (int)Math.Floor(rating);
            bool hasHalfStar = (rating - fullStars) >= 0.5;

            for (int i = 0; i < fullStars; i++)
            {
                stars += "<i class='fas fa-star' style='color: #fbbf24;'></i>";
            }

            if (hasHalfStar)
            {
                stars += "<i class='fas fa-star-half-alt' style='color: #fbbf24;'></i>";
                fullStars++;
            }

            for (int i = fullStars; i < 5; i++)
            {
                stars += "<i class='far fa-star' style='color: #fbbf24;'></i>";
            }

            return stars;
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

        private void ShowNotFound()
        {
            pnlProductDetails.Visible = false;
            pnlNotFound.Visible = true;
        }
    }
}