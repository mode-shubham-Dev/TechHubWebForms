<%@ Page Title="Admin Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="TechHubWebForms.Admin.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- ADMIN HEADER -->
    <div class="admin-header">
        <div class="container">
            <div class="admin-header-content">
                <div class="admin-title-section">
                    <h1 class="admin-page-title">
                        <i class="fas fa-tachometer-alt"></i> Admin Dashboard
                    </h1>
                    <p class="admin-page-subtitle">Welcome back, <%= Session["UserName"] %>! Here's your store overview.</p>
                </div>
                <div class="admin-header-actions">
                    <a href="<%= ResolveUrl("~/Default.aspx") %>" class="btn-view-site">
                        <i class="fas fa-home"></i> View Main Site
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- ADMIN NAVIGATION TABS -->
    <div class="admin-nav-tabs">
        <div class="container">
            <div class="admin-tabs">
                <a href="Dashboard.aspx" class="admin-tab active">
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
                <a href="ManageOrders.aspx" class="admin-tab">
                    <i class="fas fa-shopping-cart"></i> Orders
                </a>
            </div>
        </div>
    </div>

    <!-- MAIN ADMIN CONTENT -->
    <div class="admin-content">
        <div class="container">

            <!-- STATISTICS CARDS -->
            <div class="stats-grid">
                
                <!-- Total Products -->
                <div class="stat-card stat-card-blue">
                    <div class="stat-icon">
                        <i class="fas fa-box"></i>
                    </div>
                    <div class="stat-details">
                        <h3 class="stat-value">
                            <asp:Label ID="lblTotalProducts" runat="server" Text="0"></asp:Label>
                        </h3>
                        <p class="stat-label">Total Products</p>
                    </div>
                    <a href="ManageProducts.aspx" class="stat-link">
                        View All <i class="fas fa-arrow-right"></i>
                    </a>
                </div>

                <!-- Total Users -->
                <div class="stat-card stat-card-green">
                    <div class="stat-icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-details">
                        <h3 class="stat-value">
                            <asp:Label ID="lblTotalUsers" runat="server" Text="0"></asp:Label>
                        </h3>
                        <p class="stat-label">Total Users</p>
                    </div>
                    <a href="ManageUsers.aspx" class="stat-link">
                        View All <i class="fas fa-arrow-right"></i>
                    </a>
                </div>

                <!-- Total Orders -->
                <div class="stat-card stat-card-orange">
                    <div class="stat-icon">
                        <i class="fas fa-shopping-cart"></i>
                    </div>
                    <div class="stat-details">
                        <h3 class="stat-value">
                            <asp:Label ID="lblTotalOrders" runat="server" Text="0"></asp:Label>
                        </h3>
                        <p class="stat-label">Total Orders</p>
                    </div>
                    <a href="ManageOrders.aspx" class="stat-link">
                        View All <i class="fas fa-arrow-right"></i>
                    </a>
                </div>

                <!-- Total Revenue -->
                <div class="stat-card stat-card-purple">
                    <div class="stat-icon">
                        <i class="fas fa-dollar-sign"></i>
                    </div>
                    <div class="stat-details">
                        <h3 class="stat-value">
                            NPR <asp:Label ID="lblTotalRevenue" runat="server" Text="0"></asp:Label>
                        </h3>
                        <p class="stat-label">Total Revenue</p>
                    </div>
                </div>

            </div>

            <!-- RECENT ORDERS SECTION -->
            <div class="admin-section">
                <div class="section-header-admin">
                    <h2 class="section-title-admin">
                        <i class="fas fa-clock"></i> Recent Orders
                    </h2>
                    <a href="ManageOrders.aspx" class="btn-view-all">
                        View All Orders <i class="fas fa-arrow-right"></i>
                    </a>
                </div>

                <div class="admin-card">
                    <asp:Panel ID="pnlRecentOrders" runat="server" Visible="true">
                        <div class="table-responsive">
                            <table class="admin-table">
                                <thead>
                                    <tr>
                                        <th>Order ID</th>
                                        <th>Customer</th>
                                        <th>Date</th>
                                        <th>Total</th>
                                        <th>Status</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <asp:Repeater ID="rptRecentOrders" runat="server">
                                        <ItemTemplate>
                                            <tr>
                                                <td><strong>#<%# Eval("OrderID") %></strong></td>
                                                <td><%# Eval("User.Name") %></td>
                                                <td><%# Convert.ToDateTime(Eval("OrderDate")).ToString("MMM dd, yyyy") %></td>
                                                <td><strong>NPR <%# String.Format("{0:N0}", Eval("TotalAmount")) %></strong></td>
                                                <td>
                                                    <span class='status-badge status-<%# Eval("OrderStatus").ToString().ToLower() %>'>
                                                        <%# Eval("OrderStatus") %>
                                                    </span>
                                                </td>
                                                <td>
                                                    <a href='ManageOrders.aspx?id=<%# Eval("OrderID") %>' class="btn-action">
                                                        <i class="fas fa-eye"></i> View
                                                    </a>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </tbody>
                            </table>
                        </div>
                    </asp:Panel>

                    <asp:Panel ID="pnlNoOrders" runat="server" Visible="false">
                        <div class="empty-state">
                            <i class="fas fa-shopping-cart"></i>
                            <h3>No Orders Yet</h3>
                            <p>Orders will appear here once customers start purchasing.</p>
                        </div>
                    </asp:Panel>
                </div>
            </div>

            <!-- LOW STOCK ALERTS SECTION -->
            <div class="admin-section">
                <div class="section-header-admin">
                    <h2 class="section-title-admin">
                        <i class="fas fa-exclamation-triangle"></i> Low Stock Alerts
                    </h2>
                    <a href="ManageProducts.aspx" class="btn-view-all">
                        Manage Products <i class="fas fa-arrow-right"></i>
                    </a>
                </div>

                <div class="admin-card">
                    <asp:Panel ID="pnlLowStock" runat="server" Visible="true">
                        <div class="table-responsive">
                            <table class="admin-table">
                                <thead>
                                    <tr>
                                        <th>Product ID</th>
                                        <th>Product Name</th>
                                        <th>Category</th>
                                        <th>Stock Quantity</th>
                                        <th>Status</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <asp:Repeater ID="rptLowStock" runat="server">
                                        <ItemTemplate>
                                            <tr>
                                                <td><strong>#<%# Eval("ProductID") %></strong></td>
                                                <td><%# Eval("Name") %></td>
                                                <td><%# Eval("Category.CategoryName") %></td>
                                                <td>
                                                    <span class="stock-quantity stock-low">
                                                        <%# Eval("StockQuantity") %> units
                                                    </span>
                                                </td>
                                                <td>
                                                    <span class="status-badge status-warning">
                                                        Low Stock
                                                    </span>
                                                </td>
                                                <td>
                                                    <a href='ManageProducts.aspx?id=<%# Eval("ProductID") %>' class="btn-action">
                                                        <i class="fas fa-edit"></i> Update
                                                    </a>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </tbody>
                            </table>
                        </div>
                    </asp:Panel>

                    <asp:Panel ID="pnlNoLowStock" runat="server" Visible="false">
                        <div class="empty-state">
                            <i class="fas fa-check-circle"></i>
                            <h3>All Products Well Stocked</h3>
                            <p>No products have low stock at the moment.</p>
                        </div>
                    </asp:Panel>
                </div>
            </div>

        </div>
    </div>

</asp:Content>