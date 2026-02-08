using System;
using System.Web.UI;
using TechHubWebForms.Helpers;  // ✅ ADDED for EmailHelper

namespace TechHubWebForms
{
    public partial class Contact : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Contact page loaded
        }

        /// <summary>
        /// Send contact message
        /// </summary>
        protected void btnSendMessage_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                // Get form data
                string name = txtName.Text.Trim();
                string email = txtEmail.Text.Trim();
                string phone = txtPhone.Text.Trim();
                string subject = txtSubject.Text.Trim();
                string message = txtMessage.Text.Trim();

                // ✅ Send email notification to admin
                try
                {
                    bool emailSent = EmailHelper.SendContactNotification(email, name, subject, message);

                    if (emailSent)
                    {
                        System.Diagnostics.Debug.WriteLine($"Contact notification email sent");
                    }
                }
                catch (Exception emailEx)
                {
                    System.Diagnostics.Debug.WriteLine($"Contact email failed: {emailEx.Message}");
                }

                ShowMessage($"Thank you, {name}! Your message has been sent successfully. We'll get back to you at {email} within 24 hours.", true);
                ClearForm();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error sending message: " + ex.Message);
                ShowMessage("Error sending message. Please try again or contact us directly at info@techhub.com", false);
            }
        }

        /// <summary>
        /// Clear form fields
        /// </summary>
        private void ClearForm()
        {
            txtName.Text = "";
            txtEmail.Text = "";
            txtPhone.Text = "";
            txtSubject.Text = "";
            txtMessage.Text = "";
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