<%@ Page Title="Manage Products" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageProducts.aspx.cs" Inherits="TechHubWebForms.Admin.ManageProducts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- ADMIN HEADER -->
    <div class="admin-header">
        <div class="container">
            <div class="admin-header-content">
                <div class="admin-title-section">
                    <h1 class="admin-page-title">
                        <i class="fas fa-box"></i> Manage Products
                    </h1>
                    <p class="admin-page-subtitle">Create, update, and manage your product inventory</p>
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
                <a href="Dashboard.aspx" class="admin-tab">
                    <i class="fas fa-tachometer-alt"></i> Dashboard
                </a>
                <a href="ManageProducts.aspx" class="admin-tab active">
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

            <!-- SUCCESS/ERROR MESSAGE -->
            <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert-message">
                <div id="divMessage" runat="server" class="message-content"></div>
                <button type="button" class="message-close" onclick="this.parentElement.style.display='none';">
                    <i class="fas fa-times"></i>
                </button>
            </asp:Panel>

            <!-- ADD NEW PRODUCT SECTION -->
            <div class="admin-section">
                <div class="section-header-admin">
                    <h2 class="section-title-admin">
                        <i class="fas fa-plus-circle"></i> Add New Product
                    </h2>
                    <asp:Button ID="btnToggleForm" runat="server" Text="Show Form" CssClass="btn-toggle-form" OnClick="btnToggleForm_Click" CausesValidation="false" />
                </div>

                <asp:Panel ID="pnlAddProduct" runat="server" Visible="false" CssClass="admin-card">
                    <div class="form-container">
                        <div class="form-grid">
                            
                            <!-- Product Name -->
                            <div class="form-group">
                                <label class="form-label">Product Name <span class="required">*</span></label>
                                <asp:TextBox ID="txtProductName" runat="server" CssClass="form-control" MaxLength="200" placeholder="e.g., iPhone 15 Pro Max"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvProductName" runat="server" ControlToValidate="txtProductName" 
                                    ErrorMessage="Product name is required" CssClass="field-error" Display="Dynamic" ValidationGroup="AddProduct"></asp:RequiredFieldValidator>
                            </div>

                            <!-- Brand -->
                            <div class="form-group">
                                <label class="form-label">Brand <span class="required">*</span></label>
                                <asp:TextBox ID="txtBrand" runat="server" CssClass="form-control" MaxLength="100" placeholder="e.g., Apple"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvBrand" runat="server" ControlToValidate="txtBrand" 
                                    ErrorMessage="Brand is required" CssClass="field-error" Display="Dynamic" ValidationGroup="AddProduct"></asp:RequiredFieldValidator>
                            </div>

                            <!-- Category -->
                            <div class="form-group">
                                <label class="form-label">Category <span class="required">*</span></label>
                                <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control">
                                    <asp:ListItem Value="0">-- Select Category --</asp:ListItem>
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvCategory" runat="server" ControlToValidate="ddlCategory" 
                                    InitialValue="0" ErrorMessage="Please select a category" CssClass="field-error" Display="Dynamic" ValidationGroup="AddProduct"></asp:RequiredFieldValidator>
                            </div>

                            <!-- Price -->
                            <div class="form-group">
                                <label class="form-label">Price (NPR) <span class="required">*</span></label>
                                <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control" TextMode="Number" step="0.01" placeholder="0.00"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvPrice" runat="server" ControlToValidate="txtPrice" 
                                    ErrorMessage="Price is required" CssClass="field-error" Display="Dynamic" ValidationGroup="AddProduct"></asp:RequiredFieldValidator>
                                <asp:RangeValidator ID="rvPrice" runat="server" ControlToValidate="txtPrice" 
                                    MinimumValue="0.01" MaximumValue="999999999" Type="Double" 
                                    ErrorMessage="Price must be greater than 0" CssClass="field-error" Display="Dynamic" ValidationGroup="AddProduct"></asp:RangeValidator>
                            </div>

                            <!-- Stock Quantity -->
                            <div class="form-group">
                                <label class="form-label">Stock Quantity <span class="required">*</span></label>
                                <asp:TextBox ID="txtStock" runat="server" CssClass="form-control" TextMode="Number" placeholder="0"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvStock" runat="server" ControlToValidate="txtStock" 
                                    ErrorMessage="Stock quantity is required" CssClass="field-error" Display="Dynamic" ValidationGroup="AddProduct"></asp:RequiredFieldValidator>
                                <asp:RangeValidator ID="rvStock" runat="server" ControlToValidate="txtStock" 
                                    MinimumValue="0" MaximumValue="999999" Type="Integer" 
                                    ErrorMessage="Stock must be between 0 and 999999" CssClass="field-error" Display="Dynamic" ValidationGroup="AddProduct"></asp:RangeValidator>
                            </div>

                            <!-- Image URL 1 -->
                            <div class="form-group">
                                <label class="form-label">Image URL 1</label>
                                <asp:TextBox ID="txtImageURL1" runat="server" CssClass="form-control" MaxLength="255" placeholder="https://example.com/image1.jpg"></asp:TextBox>
                            </div>

                            <!-- Image URL 2 -->
                            <div class="form-group">
                                <label class="form-label">Image URL 2</label>
                                <asp:TextBox ID="txtImageURL2" runat="server" CssClass="form-control" MaxLength="255" placeholder="https://example.com/image2.jpg"></asp:TextBox>
                            </div>

                            <!-- Image URL 3 -->
                            <div class="form-group">
                                <label class="form-label">Image URL 3</label>
                                <asp:TextBox ID="txtImageURL3" runat="server" CssClass="form-control" MaxLength="255" placeholder="https://example.com/image3.jpg"></asp:TextBox>
                            </div>

                            <!-- Description (Full Width) -->
                            <div class="form-group form-group-full">
                                <label class="form-label">Description</label>
                                <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" 
                                    Rows="3" MaxLength="1000" placeholder="Enter product description..."></asp:TextBox>
                            </div>

                            <!-- Specifications (Full Width) -->
                            <div class="form-group form-group-full">
                                <label class="form-label">Specifications</label>
                                <asp:TextBox ID="txtSpecifications" runat="server" CssClass="form-control" TextMode="MultiLine" 
                                    Rows="3" placeholder="Enter product specifications (one per line)..."></asp:TextBox>
                            </div>

                            <!-- Active Status -->
                            <div class="form-group">
                                <label class="form-label">Status</label>
                                <div class="checkbox-wrapper">
                                    <asp:CheckBox ID="chkIsActive" runat="server" Checked="true" />
                                    <span>Active (Product will be visible to customers)</span>
                                </div>
                            </div>

                        </div>

                        <!-- Form Actions -->
                        <div class="form-actions">
                            <asp:Button ID="btnAddProduct" runat="server" Text="Add Product" CssClass="btn-primary-admin" 
                                OnClick="btnAddProduct_Click" ValidationGroup="AddProduct" />
                            <asp:Button ID="btnCancelAdd" runat="server" Text="Cancel" CssClass="btn-secondary-admin" 
                                OnClick="btnCancelAdd_Click" CausesValidation="false" />
                        </div>
                    </div>
                </asp:Panel>
            </div>

            <!-- PRODUCTS LIST SECTION -->
            <div class="admin-section">
                <div class="section-header-admin">
                    <h2 class="section-title-admin">
                        <i class="fas fa-list"></i> All Products (<asp:Label ID="lblProductCount" runat="server" Text="0"></asp:Label>)
                    </h2>
                    <div class="search-box">
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" placeholder="Search products..." AutoPostBack="true" OnTextChanged="txtSearch_TextChanged"></asp:TextBox>
                        <i class="fas fa-search search-icon"></i>
                    </div>
                </div>

                <div class="admin-card">
                    <asp:Panel ID="pnlProducts" runat="server" Visible="true">
                        <div class="table-responsive">
                            <asp:GridView ID="gvProducts" runat="server" AutoGenerateColumns="False" 
                                CssClass="admin-table" DataKeyNames="ProductID" 
                                OnRowEditing="gvProducts_RowEditing" 
                                OnRowCancelingEdit="gvProducts_RowCancelingEdit" 
                                OnRowUpdating="gvProducts_RowUpdating" 
                                OnRowDeleting="gvProducts_RowDeleting"
                                OnRowDataBound="gvProducts_RowDataBound"
                                AllowPaging="True" PageSize="10" 
                                OnPageIndexChanging="gvProducts_PageIndexChanging">
                                
                                <Columns>
                                    <asp:BoundField DataField="ProductID" HeaderText="ID" ReadOnly="True" />
                                    
                                    <asp:TemplateField HeaderText="Product Name">
                                        <ItemTemplate>
                                            <strong><%# Eval("Name") %></strong><br />
                                            <small class="text-muted"><%# Eval("Brand") %></small>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtEditName" runat="server" Text='<%# Bind("Name") %>' CssClass="form-control-sm" MaxLength="200"></asp:TextBox>
                                            <br />
                                            <asp:TextBox ID="txtEditBrand" runat="server" Text='<%# Bind("Brand") %>' CssClass="form-control-sm" MaxLength="100" placeholder="Brand"></asp:TextBox>
                                        </EditItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Category">
                                        <ItemTemplate>
                                            <%# Eval("Category.CategoryName") %>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:DropDownList ID="ddlEditCategory" runat="server" CssClass="form-control-sm"></asp:DropDownList>
                                        </EditItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Price">
                                        <ItemTemplate>
                                            <strong>NPR <%# String.Format("{0:N0}", Eval("Price")) %></strong>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtEditPrice" runat="server" Text='<%# Bind("Price") %>' CssClass="form-control-sm" TextMode="Number" step="0.01"></asp:TextBox>
                                        </EditItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Stock">
                                        <ItemTemplate>
                                            <span class='<%# Convert.ToInt32(Eval("StockQuantity")) < 10 ? "stock-quantity stock-low" : "stock-quantity stock-good" %>'>
                                                <%# Eval("StockQuantity") %>
                                            </span>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtEditStock" runat="server" Text='<%# Bind("StockQuantity") %>' CssClass="form-control-sm" TextMode="Number"></asp:TextBox>
                                        </EditItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Status">
                                        <ItemTemplate>
                                            <span class='<%# Convert.ToBoolean(Eval("IsActive")) ? "status-badge status-delivered" : "status-badge status-cancelled" %>'>
                                                <%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Inactive" %>
                                            </span>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:CheckBox ID="chkEditIsActive" runat="server" Checked='<%# Bind("IsActive") %>' />
                                        </EditItemTemplate>
                                    </asp:TemplateField>

                                    <asp:CommandField HeaderText="Actions" ShowEditButton="True" ShowDeleteButton="True" 
                                        ButtonType="Button" ControlStyle-CssClass="btn-grid-action" />
                                </Columns>

                                <EmptyDataTemplate>
                                    <div class="empty-state">
                                        <i class="fas fa-box-open"></i>
                                        <h3>No Products Found</h3>
                                        <p>Start by adding your first product above.</p>
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