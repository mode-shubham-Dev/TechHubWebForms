<%@ Page Title="Contact Us" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="TechHubWebForms.Contact" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 80px 20px; text-align: center; color: white;">
        <div class="container" style="max-width: 800px; margin: 0 auto;">
            <h1 style="font-size: 48px; font-weight: 700; margin-bottom: 20px;">Get In Touch</h1>
            <p style="font-size: 20px; opacity: 0.95; line-height: 1.6;">
                Have questions? We'd love to hear from you. Send us a message and we'll respond as soon as possible.
            </p>
        </div>
    </div>

    <div class="container" style="padding: 60px 20px; max-width: 1200px; margin: 0 auto;">

        <asp:Panel ID="pnlMessage" runat="server" Visible="false" style="margin-bottom: 30px;">
            <div id="divMessage" runat="server" style="padding: 16px 20px; border-radius: 8px; font-size: 14px; font-weight: 500;"></div>
        </asp:Panel>

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 40px; margin-bottom: 60px;">

            <div style="background: white; padding: 40px; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.08);">
                <h2 style="font-size: 28px; font-weight: 700; color: #1e293b; margin-bottom: 25px;">Send Us a Message</h2>

                <div style="display: grid; gap: 20px;">

                    <div>
                        <label style="display: block; margin-bottom: 8px; color: #1e293b; font-weight: 500;">
                            Your Name <span style="color: #ef4444;">*</span>
                        </label>
                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control" MaxLength="100" 
                            placeholder="John Doe"
                            style="width: 100%; padding: 12px; border: 1px solid #e2e8f0; border-radius: 8px; font-size: 16px;"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName" 
                            ErrorMessage="Name is required" Display="Dynamic" 
                            style="color: #ef4444; font-size: 14px; margin-top: 4px;"></asp:RequiredFieldValidator>
                    </div>

                    <div>
                        <label style="display: block; margin-bottom: 8px; color: #1e293b; font-weight: 500;">
                            Email Address <span style="color: #ef4444;">*</span>
                        </label>
                        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" MaxLength="100" 
                            placeholder="john@example.com"
                            style="width: 100%; padding: 12px; border: 1px solid #e2e8f0; border-radius: 8px; font-size: 16px;"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" 
                            ErrorMessage="Email is required" Display="Dynamic" 
                            style="color: #ef4444; font-size: 14px; margin-top: 4px;"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail" 
                            ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$"
                            ErrorMessage="Invalid email format" Display="Dynamic" 
                            style="color: #ef4444; font-size: 14px; margin-top: 4px;"></asp:RegularExpressionValidator>
                    </div>

                    <div>
                        <label style="display: block; margin-bottom: 8px; color: #1e293b; font-weight: 500;">
                            Phone Number
                        </label>
                        <asp:TextBox ID="txtPhone" runat="server" TextMode="Phone" CssClass="form-control" MaxLength="20" 
                            placeholder="+977 98012-34567"
                            style="width: 100%; padding: 12px; border: 1px solid #e2e8f0; border-radius: 8px; font-size: 16px;"></asp:TextBox>
                    </div>

                    <div>
                        <label style="display: block; margin-bottom: 8px; color: #1e293b; font-weight: 500;">
                            Subject <span style="color: #ef4444;">*</span>
                        </label>
                        <asp:TextBox ID="txtSubject" runat="server" CssClass="form-control" MaxLength="100" 
                            placeholder="How can we help you?"
                            style="width: 100%; padding: 12px; border: 1px solid #e2e8f0; border-radius: 8px; font-size: 16px;"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvSubject" runat="server" ControlToValidate="txtSubject" 
                            ErrorMessage="Subject is required" Display="Dynamic" 
                            style="color: #ef4444; font-size: 14px; margin-top: 4px;"></asp:RequiredFieldValidator>
                    </div>

                    <div>
                        <label style="display: block; margin-bottom: 8px; color: #1e293b; font-weight: 500;">
                            Message <span style="color: #ef4444;">*</span>
                        </label>
                        <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" Rows="6" CssClass="form-control" MaxLength="1000"
                            placeholder="Write your message here..."
                            style="width: 100%; padding: 12px; border: 1px solid #e2e8f0; border-radius: 8px; font-size: 16px; resize: vertical;"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvMessage" runat="server" ControlToValidate="txtMessage" 
                            ErrorMessage="Message is required" Display="Dynamic" 
                            style="color: #ef4444; font-size: 14px; margin-top: 4px;"></asp:RequiredFieldValidator>
                        <small style="color: #64748b; font-size: 14px;">
                            <asp:Label ID="lblCharCount" runat="server" Text="0"></asp:Label> / 1000 characters
                        </small>
                    </div>

                    <div style="margin-top: 10px;">
                        <asp:Button ID="btnSendMessage" runat="server" Text="Send Message" 
                            OnClick="btnSendMessage_Click"
                            style="padding: 14px 32px; background: #3b82f6; color: white; border: none; border-radius: 8px; font-size: 16px; font-weight: 600; cursor: pointer; transition: all 0.3s; width: 100%;"
                            onmouseover="this.style.background='#2563eb'" 
                            onmouseout="this.style.background='#3b82f6'" />
                    </div>

                </div>
            </div>

            <div style="display: grid; gap: 30px;">

                <div style="background: white; padding: 30px; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.08);">
                    <h3 style="font-size: 22px; font-weight: 600; color: #1e293b; margin-bottom: 20px;">
                        <i class="fas fa-map-marker-alt" style="color: #3b82f6;"></i> Our Location
                    </h3>
                    <p style="color: #64748b; line-height: 1.8; margin-bottom: 15px;">
                        <strong>TechHub E-Commerce</strong><br>
                        Kathmandu, Bagmati Province<br>
                        Nepal
                    </p>
                </div>

                <div style="background: white; padding: 30px; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.08);">
                    <h3 style="font-size: 22px; font-weight: 600; color: #1e293b; margin-bottom: 20px;">
                        <i class="fas fa-phone" style="color: #10b981;"></i> Contact Information
                    </h3>
                    <div style="display: grid; gap: 15px; color: #64748b;">
                        <div>
                            <i class="fas fa-phone-alt" style="color: #3b82f6; margin-right: 10px;"></i>
                            <strong>Phone:</strong> +977 98012-34567
                        </div>
                        <div>
                            <i class="fas fa-envelope" style="color: #3b82f6; margin-right: 10px;"></i>
                            <strong>Email:</strong> info@techhub.com
                        </div>
                        <div>
                            <i class="fas fa-envelope" style="color: #3b82f6; margin-right: 10px;"></i>
                            <strong>Support:</strong> support@techhub.com
                        </div>
                    </div>
                </div>

                <div style="background: white; padding: 30px; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.08);">
                    <h3 style="font-size: 22px; font-weight: 600; color: #1e293b; margin-bottom: 20px;">
                        <i class="fas fa-clock" style="color: #f59e0b;"></i> Business Hours
                    </h3>
                    <div style="display: grid; gap: 10px; color: #64748b;">
                        <div style="display: flex; justify-content: space-between;">
                            <span><strong>Monday - Friday:</strong></span>
                            <span>9:00 AM - 6:00 PM</span>
                        </div>
                        <div style="display: flex; justify-content: space-between;">
                            <span><strong>Saturday:</strong></span>
                            <span>10:00 AM - 4:00 PM</span>
                        </div>
                        <div style="display: flex; justify-content: space-between;">
                            <span><strong>Sunday:</strong></span>
                            <span>Closed</span>
                        </div>
                    </div>
                </div>

                <div style="background: white; padding: 30px; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.08);">
                    <h3 style="font-size: 22px; font-weight: 600; color: #1e293b; margin-bottom: 20px;">
                        <i class="fas fa-share-alt" style="color: #8b5cf6;"></i> Follow Us
                    </h3>
                    <div style="display: flex; gap: 15px;">
                        <a href="#" style="width: 45px; height: 45px; background: #3b5998; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; text-decoration: none; transition: transform 0.3s;"
                           onmouseover="this.style.transform='scale(1.1)'" onmouseout="this.style.transform='scale(1)'">
                            <i class="fab fa-facebook-f"></i>
                        </a>
                        <a href="#" style="width: 45px; height: 45px; background: #E1306C; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; text-decoration: none; transition: transform 0.3s;"
                           onmouseover="this.style.transform='scale(1.1)'" onmouseout="this.style.transform='scale(1)'">
                            <i class="fab fa-instagram"></i>
                        </a>
                        <a href="#" style="width: 45px; height: 45px; background: #1DA1F2; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; text-decoration: none; transition: transform 0.3s;"
                           onmouseover="this.style.transform='scale(1.1)'" onmouseout="this.style.transform='scale(1)'">
                            <i class="fab fa-twitter"></i>
                        </a>
                        <a href="#" style="width: 45px; height: 45px; background: #0077B5; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; text-decoration: none; transition: transform 0.3s;"
                           onmouseover="this.style.transform='scale(1.1)'" onmouseout="this.style.transform='scale(1)'">
                            <i class="fab fa-linkedin-in"></i>
                        </a>
                    </div>
                </div>

            </div>

        </div>

        <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 50px 40px; border-radius: 16px; text-align: center; color: white;">
            <h2 style="font-size: 32px; font-weight: 700; margin-bottom: 15px;">Have Questions About Our Products?</h2>
            <p style="font-size: 18px; margin-bottom: 25px; opacity: 0.95;">
                Our team is here to help you find the perfect tech solution
            </p>
            <div style="display: flex; justify-content: center; gap: 15px; flex-wrap: wrap;">
                <a href="<%= ResolveUrl("~/Products/Default.aspx") %>" 
                   style="display: inline-block; padding: 14px 32px; background: white; color: #667eea; border-radius: 8px; text-decoration: none; font-weight: 600; transition: all 0.3s;"
                   onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 8px 20px rgba(0,0,0,0.2)'" 
                   onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='none'">
                    <i class="fas fa-shopping-bag"></i> Browse Products
                </a>
                <a href="<%= ResolveUrl("~/Feedback.aspx") %>" 
                   style="display: inline-block; padding: 14px 32px; background: rgba(255,255,255,0.2); color: white; border: 2px solid white; border-radius: 8px; text-decoration: none; font-weight: 600; transition: all 0.3s;"
                   onmouseover="this.style.background='rgba(255,255,255,0.3)'" 
                   onmouseout="this.style.background='rgba(255,255,255,0.2)'">
                    <i class="fas fa-comments"></i> Send Feedback
                </a>
            </div>
        </div>

    </div>

    <script type="text/javascript">
        document.addEventListener('DOMContentLoaded', function() {
            var txtMessage = document.getElementById('<%= txtMessage.ClientID %>');
            var lblCharCount = document.getElementById('<%= lblCharCount.ClientID %>');
            
            if (txtMessage && lblCharCount) {
                txtMessage.addEventListener('input', function() {
                    lblCharCount.textContent = this.value.length;
                });
                lblCharCount.textContent = txtMessage.value.length;
            }
        });
    </script>

    <style>
        @media (max-width: 768px) {
            .container > div[style*="grid-template-columns: 1fr 1fr"] {
                grid-template-columns: 1fr !important;
            }
        }
    </style>

</asp:Content>