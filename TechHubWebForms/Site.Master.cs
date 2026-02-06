using System;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using TechHubWebForms.DAL;

namespace TechHubWebForms
{
    public partial class SiteMaster : MasterPage
    {
        // ✅ Must be PUBLIC to be accessible in Site.Master inline markup
        public bool IsUserAuthenticated
        {
            get
            {
                return HttpContext.Current?.User?.Identity != null
                       && HttpContext.Current.User.Identity.IsAuthenticated;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Optional: Ensure UserName exists for display
            if (IsUserAuthenticated && (Session["UserName"] == null || string.IsNullOrWhiteSpace(Session["UserName"].ToString())))
            {
                // Fallback: show email/username from identity if session missing
                Session["UserName"] = Context.User.Identity.Name;
            }

            // ✅ NEW: Update cart count on every page load
            UpdateCartCount();
        }

        /// <summary>
        /// Updates the cart badge count dynamically based on current user's cart items
        /// </summary>
        private void UpdateCartCount()
        {
            try
            {
                if (IsUserAuthenticated)
                {
                    using (var context = new TechHubContext())
                    {
                        // Get current user email
                        string userEmail = Context.User.Identity.Name;

                        // Find user in database
                        var user = context.Users.FirstOrDefault(u => u.Email == userEmail);

                        if (user != null)
                        {
                            // Count total quantity of items in cart
                            int cartCount = context.Carts
                                .Where(c => c.UserID == user.UserID)
                                .Sum(c => (int?)c.Quantity) ?? 0;

                            // Update badge text
                            lblCartCount.Text = cartCount.ToString();

                            // Show badge only if there are items
                            lblCartCount.Visible = cartCount > 0;
                        }
                        else
                        {
                            // User not found in database
                            lblCartCount.Text = "0";
                            lblCartCount.Visible = false;
                        }
                    }
                }
                else
                {
                    // User not logged in - hide badge
                    lblCartCount.Text = "0";
                    lblCartCount.Visible = false;
                }
            }
            catch (Exception ex)
            {
                // Log error and show 0
                System.Diagnostics.Debug.WriteLine("Error updating cart count: " + ex.Message);
                lblCartCount.Text = "0";
                lblCartCount.Visible = false;
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // Clear session
            Session.Clear();
            Session.Abandon();

            // Sign out from Forms Authentication
            FormsAuthentication.SignOut();

            // Redirect to home page
            Response.Redirect("~/Default.aspx");
        }
    }
}