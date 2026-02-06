<%@ Page Title="Edit Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EditProfile.aspx.cs" Inherits="TechHubWebForms.Account.EditProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container" style="padding: 40px 20px; max-width: 800px; margin: 0 auto;">
        
        <!-- Page Header -->
        <div style="margin-bottom: 30px;">
            <h2 style="color: #1e293b; font-size: 28px; font-weight: 600; margin-bottom: 10px;">
                <i class="fas fa-user-edit" style="color: #3b82f6;"></i> Edit Profile
            </h2>
            <p style="color: #64748b; font-size: 16px;">Update your account information</p>
        </div>

        <!-- Success/Error Messages -->
        <asp:Panel ID="pnlMessage" runat="server" Visible="false" style="margin-bottom: 20px;">
            <div id="messageBox" runat="server" style="padding: 15px; border-radius: 8px;">
                <asp:Label ID="lblMessage" runat="server"></asp:Label>
            </div>
        </asp:Panel>

        <!-- FormView for Editing Profile -->
        <div style="background: white; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); padding: 30px;">
            
            <asp:FormView 
                ID="fvEditProfile" 
                runat="server" 
                OnModeChanging="fvEditProfile_ModeChanging"
                OnItemUpdating="fvEditProfile_ItemUpdating"
                DefaultMode="Edit"
                Width="100%">
                
                <EditItemTemplate>
                    <div style="display: grid; gap: 20px;">
                        
                        <!-- Full Name -->
                        <div>
                            <label style="display: block; color: #1e293b; font-weight: 500; margin-bottom: 8px;">
                                <i class="fas fa-user" style="color: #3b82f6; margin-right: 8px;"></i>
                                Full Name <span style="color: #ef4444;">*</span>
                            </label>
                            <asp:TextBox 
                                ID="txtName" 
                                runat="server" 
                                Text='<%# Bind("Name") %>'
                                CssClass="form-control"
                                style="width: 100%; padding: 12px; border: 1px solid #e5e7eb; border-radius: 8px; font-size: 16px;" />
                            <asp:RequiredFieldValidator 
                                ID="rfvName" 
                                runat="server" 
                                ControlToValidate="txtName"
                                ErrorMessage="Name is required" 
                                Display="Dynamic"
                                ForeColor="#ef4444"
                                style="font-size: 14px; margin-top: 5px; display: block;" />
                        </div>

                        <!-- Email (Read-only) -->
                        <div>
                            <label style="display: block; color: #1e293b; font-weight: 500; margin-bottom: 8px;">
                                <i class="fas fa-envelope" style="color: #3b82f6; margin-right: 8px;"></i>
                                Email Address
                            </label>
                            <asp:TextBox 
                                ID="txtEmail" 
                                runat="server" 
                                Text='<%# Bind("Email") %>'
                                ReadOnly="true"
                                CssClass="form-control"
                                style="width: 100%; padding: 12px; border: 1px solid #e5e7eb; border-radius: 8px; font-size: 16px; background: #f8fafc; color: #64748b;" />
                            <small style="color: #64748b; font-size: 13px; display: block; margin-top: 5px;">
                                <i class="fas fa-info-circle"></i> Email cannot be changed
                            </small>
                        </div>

                        <!-- Phone -->
                        <div>
                            <label style="display: block; color: #1e293b; font-weight: 500; margin-bottom: 8px;">
                                <i class="fas fa-phone" style="color: #3b82f6; margin-right: 8px;"></i>
                                Phone Number
                            </label>
                            <asp:TextBox 
                                ID="txtPhone" 
                                runat="server" 
                                Text='<%# Bind("Phone") %>'
                                CssClass="form-control"
                                style="width: 100%; padding: 12px; border: 1px solid #e5e7eb; border-radius: 8px; font-size: 16px;" />
                            <asp:RegularExpressionValidator 
                                ID="revPhone" 
                                runat="server" 
                                ControlToValidate="txtPhone"
                                ErrorMessage="Please enter a valid phone number (10 digits)" 
                                ValidationExpression="^\d{10}$"
                                Display="Dynamic"
                                ForeColor="#ef4444"
                                style="font-size: 14px; margin-top: 5px; display: block;" />
                        </div>

                        <!-- Address -->
                        <div>
                            <label style="display: block; color: #1e293b; font-weight: 500; margin-bottom: 8px;">
                                <i class="fas fa-map-marker-alt" style="color: #3b82f6; margin-right: 8px;"></i>
                                Address
                            </label>
                            <asp:TextBox 
                                ID="txtAddress" 
                                runat="server" 
                                Text='<%# Bind("Address") %>'
                                TextMode="MultiLine"
                                Rows="3"
                                CssClass="form-control"
                                style="width: 100%; padding: 12px; border: 1px solid #e5e7eb; border-radius: 8px; font-size: 16px; resize: vertical;" />
                        </div>

                        <!-- Hidden Fields -->
                        <asp:HiddenField ID="hfUserID" runat="server" Value='<%# Bind("UserID") %>' />
                        <asp:HiddenField ID="hfRole" runat="server" Value='<%# Bind("Role") %>' />
                        <asp:HiddenField ID="hfPassword" runat="server" Value='<%# Bind("Password") %>' />
                        <asp:HiddenField ID="hfDateRegistered" runat="server" Value='<%# Bind("DateRegistered") %>' />
                        <asp:HiddenField ID="hfIsActive" runat="server" Value='<%# Bind("IsActive") %>' />

                        <!-- Buttons -->
                        <div style="display: flex; gap: 15px; margin-top: 10px;">
                            <asp:Button 
                                ID="btnUpdate" 
                                runat="server" 
                                Text="Save Changes" 
                                CommandName="Update"
                                CausesValidation="true"
                                style="padding: 12px 32px; background: #3b82f6; color: white; border: none; border-radius: 8px; font-size: 16px; font-weight: 500; cursor: pointer; transition: all 0.3s;" 
                                onmouseover="this.style.background='#2563eb'" 
                                onmouseout="this.style.background='#3b82f6'" />
                            
                            <asp:Button 
                                ID="btnCancel" 
                                runat="server" 
                                Text="Cancel" 
                                CommandName="Cancel"
                                CausesValidation="false"
                                OnClick="btnCancel_Click"
                                style="padding: 12px 32px; background: white; color: #64748b; border: 2px solid #e5e7eb; border-radius: 8px; font-size: 16px; font-weight: 500; cursor: pointer; transition: all 0.3s;" 
                                onmouseover="this.style.background='#f8fafc'" 
                                onmouseout="this.style.background='white'" />
                        </div>

                    </div>
                </EditItemTemplate>

            </asp:FormView>

        </div>

        <!-- Info Box -->
        <div style="margin-top: 20px; padding: 15px; background: #eff6ff; border-left: 4px solid #3b82f6; border-radius: 8px;">
            <p style="margin: 0; color: #1e40af; font-size: 14px;">
                <i class="fas fa-info-circle"></i> 
                Your email address cannot be changed. If you need to update it, please contact support.
            </p>
        </div>

    </div>
</asp:Content>