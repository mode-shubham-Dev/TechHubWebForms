<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="TechHubWebForms.Account.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- REGISTER PAGE -->
    <div class="auth-page">
        <div class="container">
            <div class="auth-container">
                
                <!-- Left Side - Image/Info -->
                <div class="auth-left">
                    <div class="auth-branding">
                        <i class="fas fa-user-plus"></i>
                        <h2>Join TechHub</h2>
                        <p>Create your account and start shopping for the latest tech products</p>
                    </div>
                    <div class="auth-features">
                        <div class="feature-item">
                            <i class="fas fa-check-circle"></i>
                            <span>Exclusive deals for members</span>
                        </div>
                        <div class="feature-item">
                            <i class="fas fa-check-circle"></i>
                            <span>Track your orders easily</span>
                        </div>
                        <div class="feature-item">
                            <i class="fas fa-check-circle"></i>
                            <span>Save your favorite products</span>
                        </div>
                        <div class="feature-item">
                            <i class="fas fa-check-circle"></i>
                            <span>Fast checkout process</span>
                        </div>
                    </div>
                </div>

                <!-- Right Side - Form -->
                <div class="auth-right">
                    <div class="auth-form-container">
                        <h1 class="auth-title">Create Account</h1>
                        <p class="auth-subtitle">Fill in your details to get started</p>

                        <!-- Success/Error Messages -->
                        <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert-message">
                            <asp:Label ID="lblMessage" runat="server"></asp:Label>
                        </asp:Panel>

                        <!-- Registration Form -->
                        <div class="form-group">
                            <label for="txtName" class="form-label">
                                <i class="fas fa-user"></i> Full Name
                            </label>
                            <asp:TextBox 
                                ID="txtName" 
                                runat="server" 
                                CssClass="form-input" 
                                placeholder="Enter your full name"
                                MaxLength="100">
                            </asp:TextBox>
                            <asp:RequiredFieldValidator 
                                ID="rfvName" 
                                runat="server" 
                                ControlToValidate="txtName"
                                ErrorMessage="Name is required" 
                                CssClass="validation-error"
                                Display="Dynamic">
                            </asp:RequiredFieldValidator>
                        </div>

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
                            <asp:RegularExpressionValidator 
                                ID="revEmail" 
                                runat="server"
                                ControlToValidate="txtEmail"
                                ErrorMessage="Invalid email format"
                                ValidationExpression="^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$"
                                CssClass="validation-error"
                                Display="Dynamic">
                            </asp:RegularExpressionValidator>
                        </div>

                        <div class="form-group">
                            <label for="txtPhone" class="form-label">
                                <i class="fas fa-phone"></i> Phone Number
                            </label>
                            <asp:TextBox 
                                ID="txtPhone" 
                                runat="server" 
                                CssClass="form-input" 
                                placeholder="98XXXXXXXX"
                                MaxLength="20">
                            </asp:TextBox>
                            <asp:RequiredFieldValidator 
                                ID="rfvPhone" 
                                runat="server" 
                                ControlToValidate="txtPhone"
                                ErrorMessage="Phone number is required" 
                                CssClass="validation-error"
                                Display="Dynamic">
                            </asp:RequiredFieldValidator>
                        </div>

                        <div class="form-group">
                            <label for="txtAddress" class="form-label">
                                <i class="fas fa-map-marker-alt"></i> Address
                            </label>
                            <asp:TextBox 
                                ID="txtAddress" 
                                runat="server" 
                                CssClass="form-input" 
                                placeholder="Enter your address"
                                TextMode="MultiLine"
                                Rows="2"
                                MaxLength="500">
                            </asp:TextBox>
                            <asp:RequiredFieldValidator 
                                ID="rfvAddress" 
                                runat="server" 
                                ControlToValidate="txtAddress"
                                ErrorMessage="Address is required" 
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
                                placeholder="Create a strong password"
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
                            <small class="form-hint">
                                Minimum 6 characters, must include uppercase, lowercase, and number
                            </small>
                        </div>

                        <div class="form-group">
                            <label for="txtConfirmPassword" class="form-label">
                                <i class="fas fa-lock"></i> Confirm Password
                            </label>
                            <asp:TextBox 
                                ID="txtConfirmPassword" 
                                runat="server" 
                                CssClass="form-input" 
                                placeholder="Re-enter your password"
                                TextMode="Password"
                                MaxLength="255">
                            </asp:TextBox>
                            <asp:RequiredFieldValidator 
                                ID="rfvConfirmPassword" 
                                runat="server" 
                                ControlToValidate="txtConfirmPassword"
                                ErrorMessage="Please confirm your password" 
                                CssClass="validation-error"
                                Display="Dynamic">
                            </asp:RequiredFieldValidator>
                            <asp:CompareValidator 
                                ID="cvPassword" 
                                runat="server"
                                ControlToValidate="txtConfirmPassword"
                                ControlToCompare="txtPassword"
                                ErrorMessage="Passwords do not match"
                                CssClass="validation-error"
                                Display="Dynamic">
                            </asp:CompareValidator>
                        </div>

                        <!-- Register Button -->
                        <asp:Button 
                            ID="btnRegister" 
                            runat="server" 
                            Text="Create Account" 
                            CssClass="btn-auth btn-primary-auth"
                            OnClick="btnRegister_Click" />

                        <!-- Already have account -->
                        <div class="auth-footer">
                            <p>Already have an account? <a href="Login.aspx" class="auth-link">Login here</a></p>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

</asp:Content>