<%@ Page Title="Manage Orders" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageOrders.aspx.cs" Inherits="TechHubWebForms.Admin.ManageOrders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="admin-header">
        <div class="container">
            <div class="admin-header-content">
                <div class="admin-title-section">
                    <h1 class="admin-page-title">
                        <i class="fas fa-shopping-cart"></i> Manage Orders
                    </h1>
                    <p class="admin-page-subtitle">View and manage customer orders</p>
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
                <a href="ManageUsers.aspx" class="admin-tab">
                    <i class="fas fa-users"></i> Users
                </a>
                <a href="ManageOrders.aspx" class="admin-tab active">
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
                        <i class="fas fa-list"></i> All Orders (<asp:Label ID="lblOrderCount" runat="server" Text="0"></asp:Label>)
                    </h2>
                    <div style="display: flex; gap: 15px; align-items: center;">
                        <div class="search-box">
                            <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="search-input" AutoPostBack="true" OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged">
                                <asp:ListItem Value="">All Status</asp:ListItem>
                                <asp:ListItem Value="Pending">Pending</asp:ListItem>
                                <asp:ListItem Value="Processing">Processing</asp:ListItem>
                                <asp:ListItem Value="Shipped">Shipped</asp:ListItem>
                                <asp:ListItem Value="Delivered">Delivered</asp:ListItem>
                                <asp:ListItem Value="Cancelled">Cancelled</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="search-box">
                            <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" placeholder="Search by Order ID or User..." AutoPostBack="true" OnTextChanged="txtSearch_TextChanged"></asp:TextBox>
                            <i class="fas fa-search search-icon"></i>
                        </div>
                    </div>
                </div>

                <div class="admin-card">
                    <asp:Panel ID="pnlOrders" runat="server" Visible="true">
                        <div class="table-responsive">
                            <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="False" 
                                CssClass="admin-table" DataKeyNames="OrderID" 
                                OnRowEditing="gvOrders_RowEditing" 
                                OnRowCancelingEdit="gvOrders_RowCancelingEdit" 
                                OnRowUpdating="gvOrders_RowUpdating"
                                OnRowDataBound="gvOrders_RowDataBound"
                                OnRowCommand="gvOrders_RowCommand"
                                AllowPaging="True" PageSize="10" 
                                OnPageIndexChanging="gvOrders_PageIndexChanging">
                                
                                <Columns>
                                    <asp:BoundField DataField="OrderID" HeaderText="Order #" ReadOnly="True" />
                                    
                                    <asp:TemplateField HeaderText="Customer">
                                        <ItemTemplate>
                                            <strong><%# Eval("User.Name") %></strong><br />
                                            <small class="text-muted"><%# Eval("User.Email") %></small>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Order Date">
                                        <ItemTemplate>
                                            <%# Convert.ToDateTime(Eval("OrderDate")).ToString("MMM dd, yyyy") %><br />
                                            <small class="text-muted"><%# Convert.ToDateTime(Eval("OrderDate")).ToString("hh:mm tt") %></small>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Total Amount">
                                        <ItemTemplate>
                                            <strong style="color: #1e293b;">NPR <%# String.Format("{0:N0}", Eval("TotalAmount")) %></strong>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Payment">
                                        <ItemTemplate>
                                            <%# Eval("PaymentMethod") %>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Status">
                                        <ItemTemplate>
                                            <span class='<%# GetStatusBadgeClass(Eval("OrderStatus").ToString()) %>'>
                                                <%# Eval("OrderStatus") %>
                                            </span>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:DropDownList ID="ddlEditStatus" runat="server" CssClass="form-control-sm">
                                                <asp:ListItem Value="Pending">Pending</asp:ListItem>
                                                <asp:ListItem Value="Processing">Processing</asp:ListItem>
                                                <asp:ListItem Value="Shipped">Shipped</asp:ListItem>
                                                <asp:ListItem Value="Delivered">Delivered</asp:ListItem>
                                                <asp:ListItem Value="Cancelled">Cancelled</asp:ListItem>
                                            </asp:DropDownList>
                                        </EditItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Actions">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit" CssClass="btn-grid-action" ToolTip="Edit Status">
                                                <i class="fas fa-edit"></i> Edit
                                            </asp:LinkButton>
                                            <asp:LinkButton ID="btnViewDetails" runat="server" CommandName="ViewDetails" CommandArgument='<%# Eval("OrderID") %>' CssClass="btn-grid-action" ToolTip="View Details">
                                                <i class="fas fa-eye"></i> Details
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:LinkButton ID="btnUpdate" runat="server" CommandName="Update" CssClass="btn-grid-action" ToolTip="Update">
                                                <i class="fas fa-check"></i> Update
                                            </asp:LinkButton>
                                            <asp:LinkButton ID="btnCancel" runat="server" CommandName="Cancel" CssClass="btn-grid-action" ToolTip="Cancel">
                                                <i class="fas fa-times"></i> Cancel
                                            </asp:LinkButton>
                                        </EditItemTemplate>
                                    </asp:TemplateField>
                                </Columns>

                                <EmptyDataTemplate>
                                    <div class="empty-state">
                                        <i class="fas fa-shopping-cart"></i>
                                        <h3>No Orders Found</h3>
                                        <p>No orders match your search criteria.</p>
                                    </div>
                                </EmptyDataTemplate>

                                <PagerStyle CssClass="gridview-pager" />
                            </asp:GridView>
                        </div>
                    </asp:Panel>
                </div>
            </div>

            <asp:Panel ID="pnlOrderDetails" runat="server" Visible="false" CssClass="admin-section" style="margin-top: 30px;">
                <div class="section-header-admin">
                    <h2 class="section-title-admin">
                        <i class="fas fa-receipt"></i> Order Details - #<asp:Label ID="lblOrderID" runat="server"></asp:Label>
                    </h2>
                    <asp:Button ID="btnCloseDetails" runat="server" Text="Close" CssClass="btn-secondary-admin" OnClick="btnCloseDetails_Click" CausesValidation="false" />
                </div>

                <div class="admin-card">
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin-bottom: 30px;">
                        <div>
                            <h4 style="font-size: 14px; color: #64748b; margin-bottom: 8px;">Customer Information</h4>
                            <p style="margin: 0; font-weight: 600;">
                                <asp:Label ID="lblCustomerName" runat="server"></asp:Label>
                            </p>
                            <p style="margin: 4px 0; font-size: 14px; color: #64748b;">
                                <asp:Label ID="lblCustomerEmail" runat="server"></asp:Label>
                            </p>
                            <p style="margin: 4px 0; font-size: 14px; color: #64748b;">
                                <asp:Label ID="lblCustomerPhone" runat="server"></asp:Label>
                            </p>
                        </div>

                        <div>
                            <h4 style="font-size: 14px; color: #64748b; margin-bottom: 8px;">Shipping Address</h4>
                            <p style="margin: 0; font-size: 14px; line-height: 1.6;">
                                <asp:Label ID="lblShippingAddress" runat="server"></asp:Label>
                            </p>
                        </div>

                        <div>
                            <h4 style="font-size: 14px; color: #64748b; margin-bottom: 8px;">Order Information</h4>
                            <p style="margin: 4px 0; font-size: 14px;">
                                <strong>Order Date:</strong> <asp:Label ID="lblOrderDate" runat="server"></asp:Label>
                            </p>
                            <p style="margin: 4px 0; font-size: 14px;">
                                <strong>Payment Method:</strong> <asp:Label ID="lblPaymentMethod" runat="server"></asp:Label>
                            </p>
                            <p style="margin: 4px 0; font-size: 14px;">
                                <strong>Status:</strong> <asp:Label ID="lblOrderStatus" runat="server"></asp:Label>
                            </p>
                        </div>
                    </div>

                    <h4 style="font-size: 16px; margin-bottom: 15px; color: #1e293b;">Order Items</h4>
                    <div class="table-responsive">
                        <asp:GridView ID="gvOrderDetails" runat="server" AutoGenerateColumns="False" CssClass="admin-table">
                            <Columns>
                                <asp:BoundField DataField="Product.Name" HeaderText="Product Name" />
                                <asp:BoundField DataField="Product.Brand" HeaderText="Brand" />
                                <asp:TemplateField HeaderText="Unit Price">
                                    <ItemTemplate>
                                        NPR <%# String.Format("{0:N0}", Eval("UnitPrice")) %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Quantity" HeaderText="Quantity" />
                                <asp:TemplateField HeaderText="Subtotal">
                                    <ItemTemplate>
                                        <strong>NPR <%# String.Format("{0:N0}", Eval("Subtotal")) %></strong>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>

                    <div style="text-align: right; margin-top: 20px; padding-top: 20px; border-top: 2px solid #e2e8f0;">
                        <h3 style="font-size: 24px; color: #1e293b; margin: 0;">
                            Total: NPR <asp:Label ID="lblOrderTotal" runat="server" style="font-weight: 700;"></asp:Label>
                        </h3>
                    </div>

                    <asp:Panel ID="pnlNotes" runat="server" Visible="false" style="margin-top: 20px; padding: 15px; background: #f8fafc; border-radius: 8px;">
                        <h4 style="font-size: 14px; color: #64748b; margin-bottom: 8px;">Notes</h4>
                        <p style="margin: 0; font-size: 14px;">
                            <asp:Label ID="lblNotes" runat="server"></asp:Label>
                        </p>
                    </asp:Panel>
                </div>
            </asp:Panel>

        </div>
    </div>

</asp:Content>