<%@ Page Title="Feedback" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Feedback.aspx.cs" Inherits="TechHubWebForms.Feedback" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container" style="padding: 40px 20px; max-width: 1200px; margin: 0 auto;">

        <div style="text-align: center; margin-bottom: 40px;">
            <h1 style="font-size: 36px; font-weight: 700; color: #1e293b; margin-bottom: 10px;">
                <i class="fas fa-comments" style="color: #3b82f6;"></i> Customer Feedback
            </h1>
            <p style="font-size: 18px; color: #64748b;">We value your opinion! Share your experience with us.</p>
        </div>

        <asp:Panel ID="pnlMessage" runat="server" Visible="false" style="margin-bottom: 30px;">
            <div id="divMessage" runat="server" style="padding: 16px 20px; border-radius: 8px; font-size: 14px; font-weight: 500;"></div>
        </asp:Panel>

        <div style="display: grid; grid-template-columns: 1fr; gap: 30px;">

            <div style="background: white; padding: 30px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                <h2 style="font-size: 24px; font-weight: 600; color: #1e293b; margin-bottom: 20px;">
                    <i class="fas fa-pen"></i> Submit Feedback
                </h2>

                <div style="display: grid; gap: 20px;">

                    <div>
                        <label style="display: block; margin-bottom: 8px; color: #1e293b; font-weight: 500;">
                            Subject <span style="color: #ef4444;">*</span>
                        </label>
                        <asp:TextBox ID="txtSubject" runat="server" CssClass="form-control" MaxLength="100" 
                            placeholder="e.g., Product Quality, Delivery Service, Website Experience"
                            style="width: 100%; padding: 12px; border: 1px solid #e2e8f0; border-radius: 8px; font-size: 16px;"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvSubject" runat="server" ControlToValidate="txtSubject" 
                            ErrorMessage="Subject is required" Display="Dynamic" 
                            style="color: #ef4444; font-size: 14px; margin-top: 4px;"></asp:RequiredFieldValidator>
                    </div>

                    <div>
                        <label style="display: block; margin-bottom: 8px; color: #1e293b; font-weight: 500;">
                            Your Feedback <span style="color: #ef4444;">*</span>
                        </label>
                        <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" Rows="6" CssClass="form-control" MaxLength="2000"
                            placeholder="Tell us about your experience..."
                            style="width: 100%; padding: 12px; border: 1px solid #e2e8f0; border-radius: 8px; font-size: 16px; resize: vertical;"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvMessage" runat="server" ControlToValidate="txtMessage" 
                            ErrorMessage="Feedback message is required" Display="Dynamic" 
                            style="color: #ef4444; font-size: 14px; margin-top: 4px;"></asp:RequiredFieldValidator>
                        <small style="color: #64748b; font-size: 14px;">
                            <asp:Label ID="lblCharCount" runat="server" Text="0"></asp:Label> / 2000 characters
                        </small>
                    </div>

                    <div>
                        <label style="display: block; margin-bottom: 12px; color: #1e293b; font-weight: 500;">
                            Overall Rating
                        </label>
                        <div class="star-rating" style="display: flex; gap: 8px; font-size: 32px;">
                            <asp:RadioButtonList ID="rblRating" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow"
                                style="display: flex; gap: 8px;">
                                <asp:ListItem Value="5" style="cursor: pointer;">⭐⭐⭐⭐⭐</asp:ListItem>
                                <asp:ListItem Value="4" style="cursor: pointer;">⭐⭐⭐⭐</asp:ListItem>
                                <asp:ListItem Value="3" style="cursor: pointer;">⭐⭐⭐</asp:ListItem>
                                <asp:ListItem Value="2" style="cursor: pointer;">⭐⭐</asp:ListItem>
                                <asp:ListItem Value="1" style="cursor: pointer;">⭐</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <small style="color: #64748b; font-size: 14px; display: block; margin-top: 8px;">
                            Optional: Rate your overall experience
                        </small>
                    </div>

                    <div>
                        <label style="display: block; margin-bottom: 8px; color: #1e293b; font-weight: 500;">
                            Related to Order (Optional)
                        </label>
                        <asp:DropDownList ID="ddlOrder" runat="server" CssClass="form-control"
                            style="width: 100%; padding: 12px; border: 1px solid #e2e8f0; border-radius: 8px; font-size: 16px;">
                            <asp:ListItem Value="0">-- Select Order (Optional) --</asp:ListItem>
                        </asp:DropDownList>
                        <small style="color: #64748b; font-size: 14px; display: block; margin-top: 4px;">
                            If your feedback is about a specific order, select it here
                        </small>
                    </div>

                    <div style="margin-top: 10px;">
                        <asp:Button ID="btnSubmitFeedback" runat="server" Text="Submit Feedback" 
                            OnClick="btnSubmitFeedback_Click"
                            style="padding: 14px 32px; background: #3b82f6; color: white; border: none; border-radius: 8px; font-size: 16px; font-weight: 600; cursor: pointer; transition: all 0.3s;"
                            onmouseover="this.style.background='#2563eb'" 
                            onmouseout="this.style.background='#3b82f6'" />
                        
                        <asp:Button ID="btnClearForm" runat="server" Text="Clear Form" 
                            OnClick="btnClearForm_Click" CausesValidation="false"
                            style="padding: 14px 32px; background: white; color: #64748b; border: 2px solid #e2e8f0; border-radius: 8px; font-size: 16px; font-weight: 600; cursor: pointer; margin-left: 10px;" />
                    </div>

                </div>
            </div>

            <asp:Panel ID="pnlUserFeedback" runat="server" Visible="false" 
                style="background: white; padding: 30px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                <h2 style="font-size: 24px; font-weight: 600; color: #1e293b; margin-bottom: 20px;">
                    <i class="fas fa-history"></i> Your Previous Feedback
                </h2>

                <asp:Repeater ID="rptUserFeedback" runat="server">
                    <ItemTemplate>
                        <div style="padding: 20px; border: 1px solid #e2e8f0; border-radius: 8px; margin-bottom: 15px; background: #f8fafc;">
                            <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 12px;">
                                <div>
                                    <h4 style="font-size: 16px; font-weight: 600; color: #1e293b; margin-bottom: 4px;">
                                        <%# Eval("Subject") %>
                                    </h4>
                                    <small style="color: #64748b;">
                                        <%# Convert.ToDateTime(Eval("DateSubmitted")).ToString("MMMM dd, yyyy hh:mm tt") %>
                                    </small>
                                </div>
                                <div>
                                    <%# Eval("Rating") != null ? new string('⭐', Convert.ToInt32(Eval("Rating"))) : "" %>
                                </div>
                            </div>
                            <p style="color: #475569; font-size: 14px; line-height: 1.6; margin-bottom: 12px;">
                                <%# Eval("Message") %>
                            </p>
                            <div style="display: flex; gap: 15px; font-size: 13px;">
                                <span style="background: <%# Eval("Status").ToString() == "Pending" ? "#f59e0b" : (Eval("Status").ToString() == "Reviewed" ? "#3b82f6" : "#10b981") %>; color: white; padding: 4px 12px; border-radius: 20px; font-weight: 600;">
                                    <%# Eval("Status") %>
                                </span>
                                <%# Eval("OrderID") != null ? "<span style='color: #64748b;'><i class='fas fa-shopping-cart'></i> Order #" + Eval("OrderID") + "</span>" : "" %>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

                <asp:Panel ID="pnlNoFeedback" runat="server" Visible="false" style="text-align: center; padding: 40px;">
                    <i class="fas fa-comments" style="font-size: 60px; color: #cbd5e1; margin-bottom: 15px;"></i>
                    <p style="color: #64748b; font-size: 16px;">You haven't submitted any feedback yet.</p>
                </asp:Panel>
            </asp:Panel>

        </div>

    </div>

    <script type="text/javascript">
        document.addEventListener('DOMContentLoaded', function() {
            var txtMessage = document.getElementById('<%= txtMessage.ClientID %>');
            var lblCharCount = document.getElementById('<%= lblCharCount.ClientID %>');

            if (txtMessage && lblCharCount) {
                txtMessage.addEventListener('input', function () {
                    lblCharCount.textContent = this.value.length;
                });
                lblCharCount.textContent = txtMessage.value.length;
            }

            var radioButtons = document.querySelectorAll('input[type="radio"][name*="rblRating"]');
            radioButtons.forEach(function (radio) {
                radio.style.display = 'none';
                var label = radio.nextElementSibling;
                if (label) {
                    label.style.cursor = 'pointer';
                    label.style.transition = 'transform 0.2s';
                    label.addEventListener('mouseover', function () {
                        this.style.transform = 'scale(1.1)';
                    });
                    label.addEventListener('mouseout', function () {
                        this.style.transform = 'scale(1)';
                    });
                }
            });
        });
    </script>

</asp:Content>