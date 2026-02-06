using System;
using System.Linq;
using System.Web;
using System.Web.UI;
using TechHubWebForms.DAL;
using TechHubWebForms.Models;

namespace TechHubWebForms.Account
{
    public partial class Profile : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (!HttpContext.Current.User.Identity.IsAuthenticated)
            {
                Response.Redirect("~/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadUserProfile();
            }
        }

        private void LoadUserProfile()
        {
            try
            {
                // Get user email from authentication
                string userEmail = HttpContext.Current.User.Identity.Name;

                // Get user from database
                using (var context = new TechHubContext())
                {
                    var user = context.Users.FirstOrDefault(u => u.Email == userEmail);

                    if (user != null)
                    {
                        // Populate labels with user data
                        lblUserName.Text = user.Name;
                        lblName.Text = user.Name;
                        lblEmail.Text = user.Email;
                        lblPhone.Text = user.Phone ?? "Not provided";
                        lblAddress.Text = user.Address ?? "Not provided";
                        lblUserRole.Text = user.Role + " Account";
                        lblMemberSince.Text = user.DateRegistered.ToString("MMMM dd, yyyy");
                    }
                    else
                    {
                        ShowMessage("User not found.", "danger");
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading profile: " + ex.Message, "danger");
            }
        }

        protected void btnEditProfile_Click(object sender, EventArgs e)
        {
            // Redirect to edit profile page
            Response.Redirect("~/Account/EditProfile.aspx");
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            // Redirect to change password page
            Response.Redirect("~/Account/ChangePassword.aspx");
        }

        private void ShowMessage(string message, string type)
        {
            pnlMessage.Visible = true;
            lblMessage.Text = message;

            // Set message box style based on type
            if (type == "success")
            {
                messageBox.Style["background-color"] = "#d1fae5";
                messageBox.Style["color"] = "#065f46";
                messageBox.Style["border"] = "1px solid #10b981";
            }
            else if (type == "danger")
            {
                messageBox.Style["background-color"] = "#fee2e2";
                messageBox.Style["color"] = "#991b1b";
                messageBox.Style["border"] = "1px solid #ef4444";
            }
        }
    }
}