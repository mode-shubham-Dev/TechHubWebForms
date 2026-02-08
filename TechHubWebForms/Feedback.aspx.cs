using System;
using System.Data.Entity;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using TechHubWebForms.DAL;
using TechHubWebForms.Models;

namespace TechHubWebForms
{
    public partial class Feedback : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadUserOrders();
                LoadUserFeedback();
            }
        }

        /// <summary>
        /// Load user's orders for dropdown
        /// </summary>
        private void LoadUserOrders()
        {
            if (User.Identity.IsAuthenticated)
            {
                try
                {
                    using (var context = new TechHubContext())
                    {
                        string userEmail = User.Identity.Name;
                        var user = context.Users.FirstOrDefault(u => u.Email == userEmail);

                        if (user != null)
                        {
                            var orders = context.Orders
                                .Where(o => o.UserID == user.UserID)
                                .OrderByDescending(o => o.OrderDate)
                                .ToList();

                            ddlOrder.Items.Clear();
                            ddlOrder.Items.Add(new ListItem("-- Select Order (Optional) --", "0"));

                            foreach (var order in orders)
                            {
                                string displayText = $"Order #{order.OrderID} - {order.OrderDate:MMM dd, yyyy} (NPR {order.TotalAmount:N0})";
                                ddlOrder.Items.Add(new ListItem(displayText, order.OrderID.ToString()));
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Error loading orders: " + ex.Message);
                }
            }
        }

        /// <summary>
        /// Load user's previous feedback
        /// </summary>
        private void LoadUserFeedback()
        {
            if (User.Identity.IsAuthenticated)
            {
                try
                {
                    using (var context = new TechHubContext())
                    {
                        string userEmail = User.Identity.Name;
                        var user = context.Users.FirstOrDefault(u => u.Email == userEmail);

                        if (user != null)
                        {
                            var feedbacks = context.Feedbacks
                                .Where(f => f.UserID == user.UserID)
                                .OrderByDescending(f => f.DateSubmitted)
                                .ToList();

                            if (feedbacks.Any())
                            {
                                rptUserFeedback.DataSource = feedbacks;
                                rptUserFeedback.DataBind();
                                pnlUserFeedback.Visible = true;
                                pnlNoFeedback.Visible = false;
                            }
                            else
                            {
                                pnlUserFeedback.Visible = true;
                                pnlNoFeedback.Visible = true;
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Error loading feedback: " + ex.Message);
                }
            }
        }

        /// <summary>
        /// Submit feedback
        /// </summary>
        protected void btnSubmitFeedback_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                using (var context = new TechHubContext())
                {
                    int userId = 1;

                    if (User.Identity.IsAuthenticated)
                    {
                        string userEmail = User.Identity.Name;
                        var user = context.Users.FirstOrDefault(u => u.Email == userEmail);
                        if (user != null)
                        {
                            userId = user.UserID;
                        }
                    }

                    var feedback = new Models.Feedback
                    {
                        UserID = userId,
                        OrderID = ddlOrder.SelectedValue != "0" ? Convert.ToInt32(ddlOrder.SelectedValue) : (int?)null,
                        Subject = txtSubject.Text.Trim(),
                        Message = txtMessage.Text.Trim(),
                        Rating = rblRating.SelectedValue != null ? Convert.ToInt32(rblRating.SelectedValue) : (int?)null,
                        DateSubmitted = DateTime.Now,
                        Status = "Pending"
                    };

                    context.Feedbacks.Add(feedback);
                    context.SaveChanges();

                    ShowMessage("Thank you for your feedback! We appreciate your input and will review it shortly.", true);
                    ClearForm();
                    LoadUserFeedback();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error submitting feedback: " + ex.Message);
                ShowMessage("Error submitting feedback. Please try again.", false);
            }
        }

        /// <summary>
        /// Clear form
        /// </summary>
        protected void btnClearForm_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        /// <summary>
        /// Clear all form fields
        /// </summary>
        private void ClearForm()
        {
            txtSubject.Text = "";
            txtMessage.Text = "";
            rblRating.ClearSelection();
            ddlOrder.SelectedIndex = 0;
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
                divMessage.Attributes["class"] = "";
                divMessage.Style["background"] = "#d1fae5";
                divMessage.Style["color"] = "#065f46";
                divMessage.Style["border"] = "1px solid #6ee7b7";
            }
            else
            {
                divMessage.Attributes["class"] = "";
                divMessage.Style["background"] = "#fee2e2";
                divMessage.Style["color"] = "#991b1b";
                divMessage.Style["border"] = "1px solid #fca5a5";
            }

            ScriptManager.RegisterStartupScript(this, GetType(), "HideMessage",
                "setTimeout(function(){ document.getElementById('" + pnlMessage.ClientID + "').style.display='none'; }, 5000);", true);
        }
    }
}