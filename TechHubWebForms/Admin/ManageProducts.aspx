<%@ Page Title="Manage Products" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageProducts.aspx.cs" Inherits="TechHubWebForms.Admin.ManageProducts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

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
                        <i class="fas fa-plus-circle"></i> Add New Product
                    </h2>
                    <asp:Button ID="btnToggleForm" runat="server" Text="Show Form" CssClass="btn-toggle-form" OnClick="btnToggleForm_Click" CausesValidation="false" />
                </div>

                <asp:Panel ID="pnlAddProduct" runat="server" Visible="false" CssClass="admin-card">
                    <div class="form-container">
                        <div class="form-grid">
                            
                            <div class="form-group">
                                <label class="form-label">Product Name <span class="required">*</span></label>
                                <asp:TextBox ID="txtProductName" runat="server" CssClass="form-control" MaxLength="200" placeholder="e.g., iPhone 15 Pro Max"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvProductName" runat="server" ControlToValidate="txtProductName" 
                                    ErrorMessage="Product name is required" CssClass="field-error" Display="Dynamic" ValidationGroup="AddProduct"></asp:RequiredFieldValidator>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Brand <span class="required">*</span></label>
                                <asp:TextBox ID="txtBrand" runat="server" CssClass="form-control" MaxLength="100" placeholder="e.g., Apple"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvBrand" runat="server" ControlToValidate="txtBrand" 
                                    ErrorMessage="Brand is required" CssClass="field-error" Display="Dynamic" ValidationGroup="AddProduct"></asp:RequiredFieldValidator>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Category <span class="required">*</span></label>
                                <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control">
                                    <asp:ListItem Value="0">-- Select Category --</asp:ListItem>
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvCategory" runat="server" ControlToValidate="ddlCategory" 
                                    InitialValue="0" ErrorMessage="Please select a category" CssClass="field-error" Display="Dynamic" ValidationGroup="AddProduct"></asp:RequiredFieldValidator>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Price (NPR) <span class="required">*</span></label>
                                <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control" TextMode="Number" step="0.01" placeholder="0.00"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvPrice" runat="server" ControlToValidate="txtPrice" 
                                    ErrorMessage="Price is required" CssClass="field-error" Display="Dynamic" ValidationGroup="AddProduct"></asp:RequiredFieldValidator>
                                <asp:RangeValidator ID="rvPrice" runat="server" ControlToValidate="txtPrice" 
                                    MinimumValue="0.01" MaximumValue="999999999" Type="Double" 
                                    ErrorMessage="Price must be greater than 0" CssClass="field-error" Display="Dynamic" ValidationGroup="AddProduct"></asp:RangeValidator>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Stock Quantity <span class="required">*</span></label>
                                <asp:TextBox ID="txtStock" runat="server" CssClass="form-control" TextMode="Number" placeholder="0"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvStock" runat="server" ControlToValidate="txtStock" 
                                    ErrorMessage="Stock quantity is required" CssClass="field-error" Display="Dynamic" ValidationGroup="AddProduct"></asp:RequiredFieldValidator>
                                <asp:RangeValidator ID="rvStock" runat="server" ControlToValidate="txtStock" 
                                    MinimumValue="0" MaximumValue="999999" Type="Integer" 
                                    ErrorMessage="Stock must be between 0 and 999999" CssClass="field-error" Display="Dynamic" ValidationGroup="AddProduct"></asp:RangeValidator>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Product Image 1</label>
                                <div class="file-upload-wrapper">
                                    <asp:FileUpload ID="fuImage1" runat="server" CssClass="file-upload-input" accept="image/*" onchange="updateFileName(this, 'filename1')" />
                                    <div class="file-upload-label" id="uploadLabel1">
                                        <i class="fas fa-cloud-upload-alt"></i>
                                        <span id="filename1">Choose Image</span>
                                    </div>
                                </div>
                                <small class="form-text">Recommended: 400x400px, Max 2MB (JPG, PNG, GIF)</small>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Product Image 2</label>
                                <div class="file-upload-wrapper">
                                    <asp:FileUpload ID="fuImage2" runat="server" CssClass="file-upload-input" accept="image/*" onchange="updateFileName(this, 'filename2')" />
                                    <div class="file-upload-label" id="uploadLabel2">
                                        <i class="fas fa-cloud-upload-alt"></i>
                                        <span id="filename2">Choose Image</span>
                                    </div>
                                </div>
                                <small class="form-text">Optional additional image</small>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Product Image 3</label>
                                <div class="file-upload-wrapper">
                                    <asp:FileUpload ID="fuImage3" runat="server" CssClass="file-upload-input" accept="image/*" onchange="updateFileName(this, 'filename3')" />
                                    <div class="file-upload-label" id="uploadLabel3">
                                        <i class="fas fa-cloud-upload-alt"></i>
                                        <span id="filename3">Choose Image</span>
                                    </div>
                                </div>
                                <small class="form-text">Optional additional image</small>
                            </div>

                            <div class="form-group form-group-full">
                                <label class="form-label">Description</label>
                                <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" 
                                    Rows="3" MaxLength="1000" placeholder="Enter product description..."></asp:TextBox>
                            </div>

                            <div class="form-group form-group-full">
                                <label class="form-label">Specifications</label>
                                <asp:TextBox ID="txtSpecifications" runat="server" CssClass="form-control" TextMode="MultiLine" 
                                    Rows="3" placeholder="Enter product specifications (one per line)..."></asp:TextBox>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Status</label>
                                <div class="checkbox-wrapper">
                                    <asp:CheckBox ID="chkIsActive" runat="server" Checked="true" />
                                    <span>Active (Product will be visible to customers)</span>
                                </div>
                            </div>

                        </div>

                        <div class="form-actions">
                            <asp:Button ID="btnAddProduct" runat="server" Text="Add Product" CssClass="btn-primary-admin" 
                                OnClick="btnAddProduct_Click" ValidationGroup="AddProduct" />
                            <asp:Button ID="btnCancelAdd" runat="server" Text="Cancel" CssClass="btn-secondary-admin" 
                                OnClick="btnCancelAdd_Click" CausesValidation="false" />
                        </div>
                    </div>
                </asp:Panel>
            </div>

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
                                    
                                    <asp:TemplateField HeaderText="Image">
                                        <ItemTemplate>
                                            <asp:Image ID="imgProduct" runat="server" 
                                                ImageUrl='<%# GetImageUrl(Eval("ImageURL1")) %>' 
                                                CssClass="product-thumb" 
                                                AlternateText='<%# Eval("Name") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>

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

    <script type="text/javascript">
        function updateFileName(input, spanId) {
            var fileName = input.files && input.files.length > 0 ? input.files[0].name : 'Choose Image';
            var fileSize = input.files && input.files.length > 0 ? (input.files[0].size / 1024 / 1024).toFixed(2) : 0;
            
            var span = document.getElementById(spanId);
            var label = span.parentElement;
            
            if (input.files && input.files.length > 0) {
                span.innerHTML = '<i class="fas fa-check-circle" style="color: #10b981;"></i> ' + fileName + ' (' + fileSize + ' MB)';
                label.style.borderColor = '#10b981';
                label.style.background = '#d1fae5';
            } else {
                span.textContent = 'Choose Image';
                label.style.borderColor = '#cbd5e1';
                label.style.background = '#f8fafc';
            }
        }
    </script>

</asp:Content>