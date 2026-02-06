using System;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TechHubWebForms.DAL;
using TechHubWebForms.Models;

namespace TechHubWebForms.Account
{
    public partial class EditProfile : Page
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
                LoadUserData();
            }
        }

        private void LoadUserData()
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
                        // Bind user data to FormView
                        fvEditProfile.DataSource = new[] { user };
                        fvEditProfile.DataBind();
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

        protected void fvEditProfile_ItemUpdating(object sender, FormViewUpdateEventArgs e)
        {
            try
            {
                // Get values from FormView
                int userId = Convert.ToInt32(e.NewValues["UserID"]);
                string name = e.NewValues["Name"]?.ToString();
                string phone = e.NewValues["Phone"]?.ToString();
                string address = e.NewValues["Address"]?.ToString();

                // Update user in database
                using (var context = new TechHubContext())
                {
                    var user = context.Users.Find(userId);

                    if (user != null)
                    {
                        user.Name = name;
                        user.Phone = phone;
                        user.Address = address;

                        context.SaveChanges();

                        // Update session with new name
                        Session["UserName"] = name;

                        ShowMessage("Profile updated successfully!", "success");

                        // Reload data
                        LoadUserData();
                    }
                    else
                    {
                        ShowMessage("User not found.", "danger");
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error updating profile: " + ex.Message, "danger");
            }

            // Cancel the default update operation
            e.Cancel = true;
        }

        protected void fvEditProfile_ModeChanging(object sender, FormViewModeEventArgs e)
        {
            // Keep in Edit mode
            e.Cancel = true;
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            // Redirect back to profile page
            Response.Redirect("~/Account/Profile.aspx");
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