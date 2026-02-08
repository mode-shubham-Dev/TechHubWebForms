<%@ Page Title="Manage Users" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageUsers.aspx.cs" Inherits="TechHubWebForms.Admin.ManageUsers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="admin-header">
        <div class="container">
            <div class="admin-header-content">
                <div class="admin-title-section">
                    <h1 class="admin-page-title">
                        <i class="fas fa-users"></i> Manage Users
                    </h1>
                    <p class="admin-page-subtitle">View and manage registered users</p>
                </div>
                <div class="admin-header-actions">
                    <a href="<%= ResolveUrl("~/Default.aspx") %>" class="btn-view-site">
                        <i class="fas fa-home"></i> View Main Site
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="admin-nav-tabs">
        <div class="container">
            <div class="admin-tabs">
                <a href="Dashboard.aspx" class="admin-tab">
                    <i class="fas fa-tachometer-alt"></i> Dashboard
                </a>
                <a href="ManageProducts.aspx" class="admin-tab">
                    <i class="fas fa-box"></i> Products
                </a>
                <a href="ManageCategories.aspx" class="admin-tab">
                    <i class="fas fa-folder"></i> Categories
                </a>
                <a href="ManageUsers.aspx" class="admin-tab active">
                    <i class="fas fa-users"></i> Users
                </a>
                <a href="ManageOrders.aspx" class="admin-tab">
                    <i class="fas fa-shopping-cart"></i> Orders
                </a>
            </div>
        </div>
    </div>

    <div class="admin-content">
        <div class="container">

            <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert-message">
                <div id="divMessage" runat="server" class="message-content"></div>
                <button type="button" class="message-close" onclick="this.parentElement.style.display='none';">
                    <i class="fas fa-times"></i>
                </button>
            </asp:Panel>

            <div class="admin-section">
                <div class="section-header-admin">
                    <h2 class="section-title-admin">
                        <i class="fas fa-list"></i> All Users (<asp:Label ID="lblUserCount" runat="server" Text="0"></asp:Label>)
                    </h2>
                    <div class="search-box">
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" placeholder="Search users..." AutoPostBack="true" OnTextChanged="txtSearch_TextChanged"></asp:TextBox>
                        <i class="fas fa-search search-icon"></i>
                    </div>
                </div>

                <div class="admin-card">
                    <asp:Panel ID="pnlUsers" runat="server" Visible="true">
                        <div class="table-responsive">
                            <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False" 
                                CssClass="admin-table" DataKeyNames="UserID" 
                                OnRowEditing="gvUsers_RowEditing" 
                                OnRowCancelingEdit="gvUsers_RowCancelingEdit" 
                                OnRowUpdating="gvUsers_RowUpdating" 
                                OnRowDeleting="gvUsers_RowDeleting"
                                OnRowDataBound="gvUsers_RowDataBound"
                                AllowPaging="True" PageSize="10" 
                                OnPageIndexChanging="gvUsers_PageIndexChanging">
                                
                                <Columns>
                                    <asp:BoundField DataField="UserID" HeaderText="ID" ReadOnly="True" />
                                    
                                    <asp:TemplateField HeaderText="User Details">
                                        <ItemTemplate>
                                            <strong><%# Eval("Name") %></strong><br />
                                            <small class="text-muted">
                                                <i class="fas fa-envelope"></i> <%# Eval("Email") %>
                                            </small>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtEditName" runat="server" Text='<%# Bind("Name") %>' CssClass="form-control-sm" MaxLength="100" placeholder="Name"></asp:TextBox>
                                            <br />
                                            <asp:TextBox ID="txtEditEmail" runat="server" Text='<%# Bind("Email") %>' CssClass="form-control-sm" MaxLength="100" placeholder="Email"></asp:TextBox>
                                        </EditItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Contact Info">
                                        <ItemTemplate>
                                            <div style="font-size: 13px;">
                                                <div style="margin-bottom: 4px;">
                                                    <i class="fas fa-phone"></i> <%# string.IsNullOrEmpty(Eval("Phone")?.ToString()) ? "N/A" : Eval("Phone") %>
                                                </div>
                                                <div style="color: #64748b;">
                                                    <i class="fas fa-map-marker-alt"></i> <%# string.IsNullOrEmpty(Eval("Address")?.ToString()) ? "N/A" : (Eval("Address").ToString().Length > 30 ? Eval("Address").ToString().Substring(0, 30) + "..." : Eval("Address")) %>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtEditPhone" runat="server" Text='<%# Bind("Phone") %>' CssClass="form-control-sm" MaxLength="20" placeholder="Phone"></asp:TextBox>
                                            <br />
                                            <asp:TextBox ID="txtEditAddress" runat="server" Text='<%# Bind("Address") %>' CssClass="form-control-sm" TextMode="MultiLine" Rows="2" placeholder="Address"></asp:TextBox>
                                        </EditItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Role">
                                        <ItemTemplate>
                                            <span class='<%# Eval("Role").ToString() == "Admin" ? "status-badge status-warning" : "status-badge status-processing" %>'>
                                                <%# Eval("Role") %>
                                            </span>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:DropDownList ID="ddlEditRole" runat="server" CssClass="form-control-sm">
                                                <asp:ListItem Value="Customer">Customer</asp:ListItem>
                                                <asp:ListItem Value="Admin">Admin</asp:ListItem>
                                            </asp:DropDownList>
                                        </EditItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Orders">
                                        <ItemTemplate>
                                            <span class="status-badge status-processing">
                                                <%# Eval("Orders.Count") %> orders
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Registered">
                                        <ItemTemplate>
                                            <%# Convert.ToDateTime(Eval("DateRegistered")).ToString("MMM dd, yyyy") %>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Status">
                                        <ItemTemplate>
                                            <span class='<%# Convert.ToBoolean(Eval("IsActive")) ? "status-badge status-delivered" : "status-badge status-cancelled" %>'>
                                                <%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Inactive" %>
                                            </span>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:CheckBox ID="chkEditIsActive" runat="server" Checked='<%# Bind("IsActive") %>' />
                                            <span style="font-size: 12px;">Active</span>
                                        </EditItemTemplate>
                                    </asp:TemplateField>

                                    <asp:CommandField HeaderText="Actions" ShowEditButton="True" ShowDeleteButton="True" 
                                        ButtonType="Button" ControlStyle-CssClass="btn-grid-action" />
                                </Columns>

                                <EmptyDataTemplate>
                                    <div class="empty-state">
                                        <i class="fas fa-users"></i>
                                        <h3>No Users Found</h3>
                                        <p>No registered users in the system.</p>
                                    </div>
                                </EmptyDataTemplate>

                                <PagerStyle CssClass="gridview-pager" />
                            </asp:GridView>
                        </div>
                    </asp:Panel>
                </div>
            </div>

        </div>
    </div>

</asp:Content>