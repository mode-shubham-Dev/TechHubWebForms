using System;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using TechHubWebForms.DAL;
using TechHubWebForms.Models;

namespace TechHubWebForms.Account
{
    public partial class ChangePassword : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (!HttpContext.Current.User.Identity.IsAuthenticated)
            {
                Response.Redirect("~/Account/Login.aspx");
                return;
            }
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                string userEmail = HttpContext.Current.User.Identity.Name;
                string currentPassword = txtCurrentPassword.Text.Trim();
                string newPassword = txtNewPassword.Text.Trim();

                using (var context = new TechHubContext())
                {
                    var user = context.Users.FirstOrDefault(u => u.Email == userEmail);

                    if (user != null)
                    {
                        // Verify current password
                        string hashedCurrentPassword = HashPassword(currentPassword);

                        if (user.Password != hashedCurrentPassword)
                        {
                            ShowMessage("Current password is incorrect.", "danger");
                            return;
                        }

                        // Check if new password is same as current
                        if (currentPassword == newPassword)
                        {
                            ShowMessage("New password must be different from current password.", "danger");
                            return;
                        }

                        // Update password
                        user.Password = HashPassword(newPassword);
                        context.SaveChanges();

                        ShowMessage("Password changed successfully!", "success");

                        // Clear password fields
                        txtCurrentPassword.Text = "";
                        txtNewPassword.Text = "";
                        txtConfirmPassword.Text = "";
                    }
                    else
                    {
                        ShowMessage("User not found.", "danger");
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error changing password: " + ex.Message, "danger");
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Account/Profile.aspx");
        }

        private string HashPassword(string password)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                StringBuilder builder = new StringBuilder();
                foreach (byte b in bytes)
                {
                    builder.Append(b.ToString("x2"));
                }
                return builder.ToString();
            }
        }

        private void ShowMessage(string message, string type)
        {
            pnlMessage.Visible = true;
            lblMessage.Text = message;

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