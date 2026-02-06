using System;
using System.Linq;
using System.Web.Security;
using System.Web.UI;
using TechHubWebForms.DAL;
using TechHubWebForms.Utilities;

namespace TechHubWebForms.Account
{
    public partial class Login : Page
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

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                string email = txtEmail.Text.Trim().ToLower();
                string password = txtPassword.Text;

                using (var context = new TechHubContext())
                {
                    // Find user by email
                    var user = context.Users.FirstOrDefault(u => u.Email == email);

                    if (user == null)
                    {
                        ShowMessage("Invalid email or password", "error");
                        return;
                    }

                    // Check if account is active
                    if (!user.IsActive)
                    {
                        ShowMessage("Your account has been deactivated. Please contact support.", "error");
                        return;
                    }

                    // Verify password
                    if (!SecurityHelper.VerifyPassword(password, user.Password))
                    {
                        ShowMessage("Invalid email or password", "error");
                        return;
                    }

                    // Login successful - Create authentication cookie
                    FormsAuthentication.SetAuthCookie(user.Email, chkRememberMe.Checked);

                    // Store user info in session
                    Session["UserID"] = user.UserID;
                    Session["UserName"] = user.Name;
                    Session["UserEmail"] = user.Email;
                    Session["UserRole"] = user.Role;

                    // Redirect based on role
                    if (user.Role == "Admin")
                    {
                        Response.Redirect("~/Admin/Dashboard.aspx", false);
                    }
                    else
                    {
                        // Check if there's a return URL
                        string returnUrl = Request.QueryString["ReturnUrl"];
                        if (!string.IsNullOrEmpty(returnUrl))
                        {
                            Response.Redirect(returnUrl, false);
                        }
                        else
                        {
                            Response.Redirect("~/Default.aspx", false);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("An error occurred during login. Please try again.", "error");
                System.Diagnostics.Debug.WriteLine("Login error: " + ex.Message);
            }
        }

        private void ShowMessage(string message, string type)
        {
            pnlMessage.Visible = true;
            lblMessage.Text = message;
            pnlMessage.CssClass = type == "success" ? "alert-message alert-success" : "alert-message alert-error";
        }
    }
}