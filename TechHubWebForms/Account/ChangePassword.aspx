<%@ Page Title="Change Password" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ChangePassword.aspx.cs" Inherits="TechHubWebForms.Account.ChangePassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container" style="padding: 40px 20px; max-width: 600px; margin: 0 auto;">
        
        <!-- Page Header -->
        <div style="margin-bottom: 30px;">
            <h2 style="color: #1e293b; font-size: 28px; font-weight: 600; margin-bottom: 10px;">
                <i class="fas fa-lock" style="color: #3b82f6;"></i> Change Password
            </h2>
            <p style="color: #64748b; font-size: 16px;">Update your account password</p>
        </div>

        <!-- Success/Error Messages -->
        <asp:Panel ID="pnlMessage" runat="server" Visible="false" style="margin-bottom: 20px;">
            <div id="messageBox" runat="server" style="padding: 15px; border-radius: 8px;">
                <asp:Label ID="lblMessage" runat="server"></asp:Label>
            </div>
        </asp:Panel>

        <!-- Change Password Form -->
        <div style="background: white; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); padding: 30px;">
            
            <div style="display: grid; gap: 20px;">
                
                <!-- Current Password -->
                <div>
                    <label style="display: block; color: #1e293b; font-weight: 500; margin-bottom: 8px;">
                        <i class="fas fa-key" style="color: #3b82f6; margin-right: 8px;"></i>
                        Current Password <span style="color: #ef4444;">*</span>
                    </label>
                    <asp:TextBox 
                        ID="txtCurrentPassword" 
                        runat="server" 
                        TextMode="Password"
                        CssClass="form-control"
                        placeholder="Enter your current password"
                        style="width: 100%; padding: 12px; border: 1px solid #e5e7eb; border-radius: 8px; font-size: 16px;" />
                    <asp:RequiredFieldValidator 
                        ID="rfvCurrentPassword" 
                        runat="server" 
                        ControlToValidate="txtCurrentPassword"
                        ErrorMessage="Current password is required" 
                        Display="Dynamic"
                        ForeColor="#ef4444"
                        style="font-size: 14px; margin-top: 5px; display: block;" />
                </div>

                <!-- New Password -->
                <div>
                    <label style="display: block; color: #1e293b; font-weight: 500; margin-bottom: 8px;">
                        <i class="fas fa-lock" style="color: #3b82f6; margin-right: 8px;"></i>
                        New Password <span style="color: #ef4444;">*</span>
                    </label>
                    <asp:TextBox 
                        ID="txtNewPassword" 
                        runat="server" 
                        TextMode="Password"
                        CssClass="form-control"
                        placeholder="Enter new password"
                        style="width: 100%; padding: 12px; border: 1px solid #e5e7eb; border-radius: 8px; font-size: 16px;" />
                    <asp:RequiredFieldValidator 
                        ID="rfvNewPassword" 
                        runat="server" 
                        ControlToValidate="txtNewPassword"
                        ErrorMessage="New password is required" 
                        Display="Dynamic"
                        ForeColor="#ef4444"
                        style="font-size: 14px; margin-top: 5px; display: block;" />
                    <asp:RegularExpressionValidator 
                        ID="revNewPassword" 
                        runat="server" 
                        ControlToValidate="txtNewPassword"
                        ErrorMessage="Password must be at least 6 characters with letters and numbers" 
                        ValidationExpression="^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{6,}$"
                        Display="Dynamic"
                        ForeColor="#ef4444"
                        style="font-size: 14px; margin-top: 5px; display: block;" />
                    <small style="color: #64748b; font-size: 13px; display: block; margin-top: 5px;">
                        <i class="fas fa-info-circle"></i> At least 6 characters with letters and numbers
                    </small>
                </div>

                <!-- Confirm New Password -->
                <div>
                    <label style="display: block; color: #1e293b; font-weight: 500; margin-bottom: 8px;">
                        <i class="fas fa-check-circle" style="color: #3b82f6; margin-right: 8px;"></i>
                        Confirm New Password <span style="color: #ef4444;">*</span>
                    </label>
                    <asp:TextBox 
                        ID="txtConfirmPassword" 
                        runat="server" 
                        TextMode="Password"
                        CssClass="form-control"
                        placeholder="Re-enter new password"
                        style="width: 100%; padding: 12px; border: 1px solid #e5e7eb; border-radius: 8px; font-size: 16px;" />
                    <asp:RequiredFieldValidator 
                        ID="rfvConfirmPassword" 
                        runat="server" 
                        ControlToValidate="txtConfirmPassword"
                        ErrorMessage="Please confirm your new password" 
                        Display="Dynamic"
                        ForeColor="#ef4444"
                        style="font-size: 14px; margin-top: 5px; display: block;" />
                    <asp:CompareValidator 
                        ID="cvPasswords" 
                        runat="server" 
                        ControlToValidate="txtConfirmPassword"
                        ControlToCompare="txtNewPassword"
                        ErrorMessage="Passwords do not match" 
                        Display="Dynamic"
                        ForeColor="#ef4444"
                        style="font-size: 14px; margin-top: 5px; display: block;" />
                </div>

                <!-- Buttons -->
                <div style="display: flex; gap: 15px; margin-top: 10px;">
                    <asp:Button 
                        ID="btnChangePassword" 
                        runat="server" 
                        Text="Change Password" 
                        OnClick="btnChangePassword_Click"
                        CausesValidation="true"
                        style="padding: 12px 32px; background: #3b82f6; color: white; border: none; border-radius: 8px; font-size: 16px; font-weight: 500; cursor: pointer; transition: all 0.3s;" 
                        onmouseover="this.style.background='#2563eb'" 
                        onmouseout="this.style.background='#3b82f6'" />
                    
                    <asp:Button 
                        ID="btnCancel" 
                        runat="server" 
                        Text="Cancel" 
                        OnClick="btnCancel_Click"
                        CausesValidation="false"
                        style="padding: 12px 32px; background: white; color: #64748b; border: 2px solid #e5e7eb; border-radius: 8px; font-size: 16px; font-weight: 500; cursor: pointer; transition: all 0.3s;" 
                        onmouseover="this.style.background='#f8fafc'" 
                        onmouseout="this.style.background='white'" />
                </div>

            </div>

        </div>

        <!-- Security Tips -->
        <div style="margin-top: 20px; padding: 20px; background: #fef3c7; border-left: 4px solid #f59e0b; border-radius: 8px;">
            <h4 style="color: #92400e; font-size: 16px; font-weight: 600; margin: 0 0 10px 0;">
                <i class="fas fa-shield-alt"></i> Password Security Tips
            </h4>
            <ul style="color: #78350f; font-size: 14px; margin: 0; padding-left: 20px; line-height: 1.8;">
                <li>Use a strong password with letters, numbers, and special characters</li>
                <li>Avoid using personal information like birthdays or names</li>
                <li>Don't reuse passwords from other websites</li>
                <li>Change your password regularly for better security</li>
            </ul>
        </div>

    </div>
</asp:Content>