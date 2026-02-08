using System;
using System.Data.Entity;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using TechHubWebForms.DAL;

namespace TechHubWebForms.Admin
{
    public partial class ManageUsers : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check authentication
            if (!User.Identity.IsAuthenticated)
            {
                Response.Redirect("~/Account/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.Url.PathAndQuery));
                return;
            }

            // Check admin role
            if (Session["UserRole"]?.ToString() != "Admin")
            {
                Response.Redirect("~/Default.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadUsers();
            }
        }

        /// <summary>
        /// Load all users into GridView
        /// </summary>
        private void LoadUsers(string searchTerm = "")
        {
            try
            {
                using (var context = new TechHubContext())
                {
                    var query = context.Users.Include(u => u.Orders).AsQueryable();

                    // Apply search filter
                    if (!string.IsNullOrWhiteSpace(searchTerm))
                    {
                        query = query.Where(u =>
                            u.Name.Contains(searchTerm) ||
                            u.Email.Contains(searchTerm) ||
                            u.Phone.Contains(searchTerm));
                    }

                    var users = query.OrderByDescending(u => u.UserID).ToList();

                    lblUserCount.Text = users.Count.ToString();

                    gvUsers.DataSource = users;
                    gvUsers.DataBind();

                    pnlUsers.Visible = users.Any();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading users: " + ex.Message);
                ShowMessage("Error loading users: " + ex.Message, false);
            }
        }

        /// <summary>
        /// Search users
        /// </summary>
        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            LoadUsers(txtSearch.Text.Trim());
        }

        /// <summary>
        /// GridView Edit mode
        /// </summary>
        protected void gvUsers_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvUsers.EditIndex = e.NewEditIndex;
            LoadUsers(txtSearch.Text.Trim());
        }

        /// <summary>
        /// GridView Row Data Bound - Set role dropdown selected value
        /// </summary>
        protected void gvUsers_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow && gvUsers.EditIndex == e.Row.RowIndex)
            {
                DropDownList ddlEditRole = (DropDownList)e.Row.FindControl("ddlEditRole");

                if (ddlEditRole != null)
                {
                    var user = (Models.User)e.Row.DataItem;
                    if (user != null)
                    {
                        ddlEditRole.SelectedValue = user.Role;
                    }
                }
            }
        }

        /// <summary>
        /// GridView Cancel Edit
        /// </summary>
        protected void gvUsers_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvUsers.EditIndex = -1;
            LoadUsers(txtSearch.Text.Trim());
        }

        /// <summary>
        /// GridView Update user
        /// </summary>
        protected void gvUsers_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            try
            {
                int userId = Convert.ToInt32(gvUsers.DataKeys[e.RowIndex].Value);
                GridViewRow row = gvUsers.Rows[e.RowIndex];

                // Get updated values
                string name = ((TextBox)row.FindControl("txtEditName")).Text.Trim();
                string email = ((TextBox)row.FindControl("txtEditEmail")).Text.Trim();
                string phone = ((TextBox)row.FindControl("txtEditPhone")).Text.Trim();
                string address = ((TextBox)row.FindControl("txtEditAddress")).Text.Trim();
                string role = ((DropDownList)row.FindControl("ddlEditRole")).SelectedValue;
                bool isActive = ((CheckBox)row.FindControl("chkEditIsActive")).Checked;

                using (var context = new TechHubContext())
                {
                    var user = context.Users.Find(userId);

                    if (user != null)
                    {
                        // Check if email already exists (for other users)
                        bool emailExists = context.Users.Any(u => u.Email == email && u.UserID != userId);
                        if (emailExists)
                        {
                            ShowMessage("Email already exists for another user!", false);
                            return;
                        }

                        user.Name = name;
                        user.Email = email;
                        user.Phone = phone;
                        user.Address = address;
                        user.Role = role;
                        user.IsActive = isActive;

                        context.SaveChanges();
                        ShowMessage($"User '{user.Name}' updated successfully!", true);
                    }
                }

                gvUsers.EditIndex = -1;
                LoadUsers(txtSearch.Text.Trim());
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error updating user: " + ex.Message);
                ShowMessage("Error updating user: " + ex.Message, false);
            }
        }

        /// <summary>
        /// GridView Delete user (soft delete)
        /// </summary>
        protected void gvUsers_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                int userId = Convert.ToInt32(gvUsers.DataKeys[e.RowIndex].Value);

                using (var context = new TechHubContext())
                {
                    var user = context.Users.Include(u => u.Orders).FirstOrDefault(u => u.UserID == userId);

                    if (user != null)
                    {
                        // Prevent deleting admin account being used
                        string currentUserEmail = User.Identity.Name;
                        if (user.Email == currentUserEmail)
                        {
                            ShowMessage("You cannot delete your own account!", false);
                            return;
                        }

                        // Check if user has pending orders
                        var pendingOrders = user.Orders.Where(o => o.OrderStatus == "Pending" || o.OrderStatus == "Processing").ToList();
                        if (pendingOrders.Any())
                        {
                            ShowMessage($"Cannot delete '{user.Name}' because they have {pendingOrders.Count} pending/processing order(s).", false);
                            return;
                        }

                        // Soft delete - set IsActive to false
                        user.IsActive = false;
                        context.SaveChanges();
                        ShowMessage($"User '{user.Name}' deleted successfully!", true);
                    }
                }

                LoadUsers(txtSearch.Text.Trim());
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error deleting user: " + ex.Message);
                ShowMessage("Error deleting user: " + ex.Message, false);
            }
        }

        /// <summary>
        /// GridView pagination
        /// </summary>
        protected void gvUsers_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvUsers.PageIndex = e.NewPageIndex;
            LoadUsers(txtSearch.Text.Trim());
        }

        /// <summary>
        /// Show success or error message
        /// </summary>
        private void ShowMessage(string message, bool isSuccess)
        {
            pnlMessage.Visible = true;
            divMessage.InnerText = message;

            if (isSuccess)
            {
                divMessage.Attributes["class"] = "message-content message-success";
            }
            else
            {
                divMessage.Attributes["class"] = "message-content message-error";
            }

            // Auto-hide after 5 seconds
            ScriptManager.RegisterStartupScript(this, GetType(), "HideMessage",
                "setTimeout(function(){ document.getElementById('" + pnlMessage.ClientID + "').style.display='none'; }, 5000);", true);
        }
    }
}