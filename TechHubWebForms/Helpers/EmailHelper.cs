using System;
using System.Configuration;
using System.Net;
using System.Net.Mail;

namespace TechHubWebForms.Helpers
{
    public class EmailHelper
    {
        /// <summary>
        /// Send order confirmation email
        /// </summary>
        public static bool SendOrderConfirmation(string toEmail, string customerName, int orderId, decimal totalAmount, string orderDetails)
        {
            try
            {
                string subject = $"Order Confirmation - Order #{orderId}";

                string body = $@"
<!DOCTYPE html>
<html>
<head>
    <style>
        body {{ font-family: Arial, sans-serif; line-height: 1.6; color: #333; }}
        .container {{ max-width: 600px; margin: 0 auto; padding: 20px; }}
        .header {{ background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; border-radius: 8px 8px 0 0; }}
        .content {{ background: #f8f9fa; padding: 30px; border-radius: 0 0 8px 8px; }}
        .order-box {{ background: white; padding: 20px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #667eea; }}
        .footer {{ text-align: center; padding: 20px; color: #666; font-size: 14px; }}
        .btn {{ display: inline-block; padding: 12px 24px; background: #667eea; color: white; text-decoration: none; border-radius: 6px; margin: 10px 0; }}
    </style>
</head>
<body>
    <div class='container'>
        <div class='header'>
            <h1 style='margin: 0;'>🛒 TechHub</h1>
            <p style='margin: 10px 0 0 0; opacity: 0.9;'>Thank you for your order!</p>
        </div>
        
        <div class='content'>
            <h2>Hi {customerName},</h2>
            <p>Thank you for shopping with TechHub! We've received your order and it's being processed.</p>
            
            <div class='order-box'>
                <h3 style='margin-top: 0; color: #667eea;'>Order Summary</h3>
                <p><strong>Order Number:</strong> #{orderId}</p>
                <p><strong>Order Date:</strong> {DateTime.Now:MMMM dd, yyyy hh:mm tt}</p>
                <p><strong>Total Amount:</strong> NPR {totalAmount:N0}</p>
                <hr style='border: none; border-top: 1px solid #e0e0e0; margin: 15px 0;'>
                <p><strong>Order Details:</strong></p>
                {orderDetails}
            </div>
            
            <p><strong>What's Next?</strong></p>
            <ul>
                <li>We'll process your order within 24 hours</li>
                <li>You'll receive a shipping notification once your order is dispatched</li>
                <li>Track your order anytime from your account</li>
            </ul>
            
            <div style='text-align: center; margin: 30px 0;'>
                <a href='http://localhost/Cart/CartHistory.aspx' class='btn'>View Order Status</a>
            </div>
            
            <p>If you have any questions, feel free to contact us at <a href='mailto:info@techhub.com'>info@techhub.com</a> or call us at +977 98012-34567.</p>
            
            <p>Thank you for choosing TechHub!</p>
            <p><strong>The TechHub Team</strong></p>
        </div>
        
        <div class='footer'>
            <p>© {DateTime.Now.Year} TechHub E-Commerce. All rights reserved.</p>
            <p>Kathmandu, Nepal | info@techhub.com</p>
        </div>
    </div>
</body>
</html>";

                return SendEmail(toEmail, subject, body);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error sending order confirmation: {ex.Message}");
                return false;
            }
        }

        /// <summary>
        /// Send contact form notification to admin
        /// </summary>
        public static bool SendContactNotification(string fromEmail, string name, string subject, string message)
        {
            try
            {
                string emailSubject = $"New Contact Form Submission - {subject}";

                string body = $@"
<!DOCTYPE html>
<html>
<head>
    <style>
        body {{ font-family: Arial, sans-serif; line-height: 1.6; color: #333; }}
        .container {{ max-width: 600px; margin: 0 auto; padding: 20px; }}
        .header {{ background: #667eea; color: white; padding: 20px; text-align: center; }}
        .content {{ background: #f8f9fa; padding: 30px; }}
        .info-box {{ background: white; padding: 15px; border-radius: 6px; margin: 15px 0; }}
    </style>
</head>
<body>
    <div class='container'>
        <div class='header'>
            <h2>New Contact Form Submission</h2>
        </div>
        <div class='content'>
            <div class='info-box'>
                <p><strong>From:</strong> {name}</p>
                <p><strong>Email:</strong> {fromEmail}</p>
                <p><strong>Subject:</strong> {subject}</p>
            </div>
            <div class='info-box'>
                <p><strong>Message:</strong></p>
                <p>{message}</p>
            </div>
            <p style='color: #666; font-size: 14px;'>Received: {DateTime.Now:MMMM dd, yyyy hh:mm tt}</p>
        </div>
    </div>
</body>
</html>";

                return SendEmail("admin@techhub.com", emailSubject, body);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error sending contact notification: {ex.Message}");
                return false;
            }
        }

        /// <summary>
        /// Core email sending method using SMTP
        /// </summary>
        private static bool SendEmail(string toEmail, string subject, string body)
        {
            try
            {
                // Get SMTP settings from Web.config
                string smtpHost = ConfigurationManager.AppSettings["SMTP_Host"];
                int smtpPort = int.Parse(ConfigurationManager.AppSettings["SMTP_Port"]);
                string smtpUsername = ConfigurationManager.AppSettings["SMTP_Username"];
                string smtpPassword = ConfigurationManager.AppSettings["SMTP_Password"];
                string fromEmail = ConfigurationManager.AppSettings["SMTP_FromEmail"];

                using (MailMessage mail = new MailMessage())
                {
                    mail.From = new MailAddress(fromEmail, "TechHub E-Commerce");
                    mail.To.Add(toEmail);
                    mail.Subject = subject;
                    mail.Body = body;
                    mail.IsBodyHtml = true;

                    using (SmtpClient smtp = new SmtpClient(smtpHost, smtpPort))
                    {
                        smtp.Credentials = new NetworkCredential(smtpUsername, smtpPassword);
                        smtp.EnableSsl = true;
                        smtp.Send(mail);
                    }
                }

                System.Diagnostics.Debug.WriteLine($"Email sent successfully to {toEmail}");
                return true;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error sending email: {ex.Message}");
                return false;
            }
        }
    }
}