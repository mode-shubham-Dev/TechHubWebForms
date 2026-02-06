<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="TechHubWebForms.Account.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- LOGIN PAGE -->
    <div class="auth-page">
        <div class="container">
            <div class="auth-container">
                
                <!-- Left Side - Branding -->
                <div class="auth-left">
                    <div class="auth-branding">
                        <i class="fas fa-sign-in-alt"></i>
                        <h2>Welcome Back!</h2>
                        <p>Login to your TechHub account and continue your shopping experience</p>
                    </div>
                    <div class="auth-features">
                        <div class="feature-item">
                            <i class="fas fa-check-circle"></i>
                            <span>Access your wishlist</span>
                        </div>
                        <div class="feature-item">
                            <i class="fas fa-check-circle"></i>
                            <span>Track your orders</span>
                        </div>
                        <div class="feature-item">
                            <i class="fas fa-check-circle"></i>
                            <span>Fast checkout</span>
                        </div>
                        <div class="feature-item">
                            <i class="fas fa-check-circle"></i>
                            <span>Member-only deals</span>
                        </div>
                    </div>
                </div>

                <!-- Right Side - Login Form -->
                <div class="auth-right">
                    <div class="auth-form-container">
                        <h1 class="auth-title">Login to TechHub</h1>
                        <p class="auth-subtitle">Enter your credentials to access your account</p>

                        <!-- Success/Error Messages -->
                        <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert-message">
                            <asp:Label ID="lblMessage" runat="server"></asp:Label>
                        </asp:Panel>

                        <!-- Login Form -->
                        <div class="form-group">
                            <label for="txtEmail" class="form-label">
                                <i class="fas fa-envelope"></i> Email Address
                            </label>
                            <asp:TextBox 
                                ID="txtEmail" 
                                runat="server" 
                                CssClass="form-input" 
                                placeholder="Enter your email"
                                TextMode="Email"
                                MaxLength="100">
                            </asp:TextBox>
                            <asp:RequiredFieldValidator 
                                ID="rfvEmail" 
                                runat="server" 
                                ControlToValidate="txtEmail"
                                ErrorMessage="Email is required" 
                                CssClass="validation-error"
                                Display="Dynamic">
                            </asp:RequiredFieldValidator>
                        </div>

                        <div class="form-group">
                            <label for="txtPassword" class="form-label">
                                <i class="fas fa-lock"></i> Password
                            </label>
                            <asp:TextBox 
                                ID="txtPassword" 
                                runat="server" 
                                CssClass="form-input" 
                                placeholder="Enter your password"
                                TextMode="Password"
                                MaxLength="255">
                            </asp:TextBox>
                            <asp:RequiredFieldValidator 
                                ID="rfvPassword" 
                                runat="server" 
                                ControlToValidate="txtPassword"
                                ErrorMessage="Password is required" 
                                CssClass="validation-error"
                                Display="Dynamic">
                            </asp:RequiredFieldValidator>
                        </div>

                        <!-- Remember Me -->
                        <div class="form-check-group">
                            <asp:CheckBox 
                                ID="chkRememberMe" 
                                runat="server" 
                                CssClass="form-checkbox" />
                            <label for="chkRememberMe" class="form-check-label">
                                Remember me
                            </label>
                        </div>

                        <!-- Login Button -->
                        <asp:Button 
                            ID="btnLogin" 
                            runat="server" 
                            Text="Login" 
                            CssClass="btn-auth btn-primary-auth"
                            OnClick="btnLogin_Click" />

                        <!-- Footer Links -->
                        <div class="auth-footer">
                            <p>Don't have an account? <a href="Register.aspx" class="auth-link">Register here</a></p>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

</asp:Content>