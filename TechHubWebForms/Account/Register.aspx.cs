using System;
using System.Linq;
using System.Web.UI;
using TechHubWebForms.DAL;
using TechHubWebForms.Models;
using TechHubWebForms.Utilities;

namespace TechHubWebForms.Account
{
    public partial class Register : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if user is already logged in
                if (User.Identity.IsAuthenticated)
                {
                    Response.Redirect("~/Default.aspx");
                }
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                // Validate password strength
                string passwordError;
                if (!SecurityHelper.IsPasswordValid(txtPassword.Text, out passwordError))
                {
                    ShowMessage(passwordError, "error");
                    return;
                }

                // Validate email format
                if (!SecurityHelper.IsEmailValid(txtEmail.Text))
                {
                    ShowMessage("Invalid email format", "error");
                    return;
                }

                using (var context = new TechHubContext())
                {
                    // Check if email already exists
                    var existingUser = context.Users.FirstOrDefault(u => u.Email == txtEmail.Text.Trim());
                    if (existingUser != null)
                    {
                        ShowMessage("Email address already registered. Please login or use a different email.", "error");
                        return;
                    }

                    // Create new user
                    var newUser = new User
                    {
                        Name = txtName.Text.Trim(),
                        Email = txtEmail.Text.Trim().ToLower(),
                        Password = SecurityHelper.HashPassword(txtPassword.Text),
                        Phone = txtPhone.Text.Trim(),
                        Address = txtAddress.Text.Trim(),
                        Role = "Customer", // Default role
                        DateRegistered = DateTime.Now,
                        IsActive = true
                    };

                    context.Users.Add(newUser);
                    context.SaveChanges();

                    // Registration successful
                    ShowMessage("Registration successful! Redirecting to login...", "success");

                    // Clear form
                    ClearForm();

                    // Redirect to login page after 2 seconds
                    Response.AddHeader("REFRESH", "2;URL=Login.aspx");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("An error occurred during registration. Please try again.", "error");
                System.Diagnostics.Debug.WriteLine("Registration error: " + ex.Message);
            }
        }

        private void ShowMessage(string message, string type)
        {
            pnlMessage.Visible = true;
            lblMessage.Text = message;

            // Add appropriate CSS class
            pnlMessage.CssClass = type == "success" ? "alert-message alert-success" : "alert-message alert-error";
        }

        private void ClearForm()
        {
            txtName.Text = string.Empty;
            txtEmail.Text = string.Empty;
            txtPhone.Text = string.Empty;
            txtAddress.Text = string.Empty;
            txtPassword.Text = string.Empty;
            txtConfirmPassword.Text = string.Empty;
        }
    }
}