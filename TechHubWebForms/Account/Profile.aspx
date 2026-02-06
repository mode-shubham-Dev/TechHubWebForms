<%@ Page Title="My Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="TechHubWebForms.Account.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container" style="padding: 40px 20px; max-width: 800px; margin: 0 auto;">
        
        <!-- Page Header -->
        <div style="margin-bottom: 30px;">
            <h2 style="color: #1e293b; font-size: 28px; font-weight: 600; margin-bottom: 10px;">
                <i class="fas fa-user-circle" style="color: #3b82f6;"></i> My Profile
            </h2>
            <p style="color: #64748b; font-size: 16px;">View and manage your account information</p>
        </div>

        <!-- Success/Error Messages -->
        <asp:Panel ID="pnlMessage" runat="server" Visible="false" style="margin-bottom: 20px;">
            <div id="messageBox" runat="server" style="padding: 15px; border-radius: 8px; margin-bottom: 20px;">
                <asp:Label ID="lblMessage" runat="server"></asp:Label>
            </div>
        </asp:Panel>

        <!-- Profile Card -->
        <div style="background: white; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); padding: 30px; margin-bottom: 20px;">
            
            <!-- User Avatar Section -->
            <div style="text-align: center; margin-bottom: 30px; padding-bottom: 30px; border-bottom: 1px solid #e5e7eb;">
                <div style="width: 100px; height: 100px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 50%; margin: 0 auto 15px; display: flex; align-items: center; justify-content: center;">
                    <i class="fas fa-user" style="font-size: 48px; color: white;"></i>
                </div>
                <h3 style="color: #1e293b; font-size: 22px; font-weight: 600; margin-bottom: 5px;">
                    <asp:Label ID="lblUserName" runat="server"></asp:Label>
                </h3>
                <p style="color: #64748b; font-size: 14px;">
                    <asp:Label ID="lblUserRole" runat="server"></asp:Label>
                </p>
            </div>

            <!-- Profile Information -->
            <div style="display: grid; gap: 20px;">
                
                <!-- Full Name -->
                <div style="padding: 15px; background: #f8fafc; border-radius: 8px;">
                    <div style="display: flex; align-items: center; margin-bottom: 8px;">
                        <i class="fas fa-user" style="color: #3b82f6; width: 24px;"></i>
                        <label style="color: #64748b; font-size: 14px; font-weight: 500; margin-left: 8px;">Full Name</label>
                    </div>
                    <div style="color: #1e293b; font-size: 16px; margin-left: 32px;">
                        <asp:Label ID="lblName" runat="server"></asp:Label>
                    </div>
                </div>

                <!-- Email -->
                <div style="padding: 15px; background: #f8fafc; border-radius: 8px;">
                    <div style="display: flex; align-items: center; margin-bottom: 8px;">
                        <i class="fas fa-envelope" style="color: #3b82f6; width: 24px;"></i>
                        <label style="color: #64748b; font-size: 14px; font-weight: 500; margin-left: 8px;">Email Address</label>
                    </div>
                    <div style="color: #1e293b; font-size: 16px; margin-left: 32px;">
                        <asp:Label ID="lblEmail" runat="server"></asp:Label>
                    </div>
                </div>

                <!-- Phone -->
                <div style="padding: 15px; background: #f8fafc; border-radius: 8px;">
                    <div style="display: flex; align-items: center; margin-bottom: 8px;">
                        <i class="fas fa-phone" style="color: #3b82f6; width: 24px;"></i>
                        <label style="color: #64748b; font-size: 14px; font-weight: 500; margin-left: 8px;">Phone Number</label>
                    </div>
                    <div style="color: #1e293b; font-size: 16px; margin-left: 32px;">
                        <asp:Label ID="lblPhone" runat="server"></asp:Label>
                    </div>
                </div>

                <!-- Address -->
                <div style="padding: 15px; background: #f8fafc; border-radius: 8px;">
                    <div style="display: flex; align-items: center; margin-bottom: 8px;">
                        <i class="fas fa-map-marker-alt" style="color: #3b82f6; width: 24px;"></i>
                        <label style="color: #64748b; font-size: 14px; font-weight: 500; margin-left: 8px;">Address</label>
                    </div>
                    <div style="color: #1e293b; font-size: 16px; margin-left: 32px;">
                        <asp:Label ID="lblAddress" runat="server"></asp:Label>
                    </div>
                </div>

                <!-- Member Since -->
                <div style="padding: 15px; background: #f8fafc; border-radius: 8px;">
                    <div style="display: flex; align-items: center; margin-bottom: 8px;">
                        <i class="fas fa-calendar-alt" style="color: #3b82f6; width: 24px;"></i>
                        <label style="color: #64748b; font-size: 14px; font-weight: 500; margin-left: 8px;">Member Since</label>
                    </div>
                    <div style="color: #1e293b; font-size: 16px; margin-left: 32px;">
                        <asp:Label ID="lblMemberSince" runat="server"></asp:Label>
                    </div>
                </div>

            </div>

            <!-- Action Buttons -->
            <div style="margin-top: 30px; display: flex; gap: 15px; flex-wrap: wrap;">
                <asp:Button 
                    ID="btnEditProfile" 
                    runat="server" 
                    Text="Edit Profile" 
                    OnClick="btnEditProfile_Click"
                    style="padding: 12px 24px; background: #3b82f6; color: white; border: none; border-radius: 8px; font-size: 16px; font-weight: 500; cursor: pointer; transition: all 0.3s;" 
                    onmouseover="this.style.background='#2563eb'" 
                    onmouseout="this.style.background='#3b82f6'" />
                
                <asp:Button 
                    ID="btnChangePassword" 
                    runat="server" 
                    Text="Change Password" 
                    OnClick="btnChangePassword_Click"
                    style="padding: 12px 24px; background: white; color: #3b82f6; border: 2px solid #3b82f6; border-radius: 8px; font-size: 16px; font-weight: 500; cursor: pointer; transition: all 0.3s;" 
                    onmouseover="this.style.background='#eff6ff'" 
                    onmouseout="this.style.background='white'" />
            </div>

        </div>

        <!-- Account Statistics (Optional - nice to have) -->
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin-top: 20px;">
            
            <!-- Total Orders -->
            <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 12px; padding: 20px; color: white;">
                <div style="display: flex; align-items: center; justify-content: space-between;">
                    <div>
                        <p style="font-size: 14px; opacity: 0.9; margin-bottom: 8px;">Total Orders</p>
                        <h3 style="font-size: 28px; font-weight: 600; margin: 0;">0</h3>
                    </div>
                    <i class="fas fa-shopping-bag" style="font-size: 36px; opacity: 0.3;"></i>
                </div>
            </div>

            <!-- Wishlist Items -->
            <div style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); border-radius: 12px; padding: 20px; color: white;">
                <div style="display: flex; align-items: center; justify-content: space-between;">
                    <div>
                        <p style="font-size: 14px; opacity: 0.9; margin-bottom: 8px;">Wishlist</p>
                        <h3 style="font-size: 28px; font-weight: 600; margin: 0;">0</h3>
                    </div>
                    <i class="fas fa-heart" style="font-size: 36px; opacity: 0.3;"></i>
                </div>
            </div>

        </div>

    </div>
</asp:Content>