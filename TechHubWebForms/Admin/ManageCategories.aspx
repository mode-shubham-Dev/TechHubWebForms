<%@ Page Title="Manage Categories" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageCategories.aspx.cs" Inherits="TechHubWebForms.Admin.ManageCategories" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="admin-header">
        <div class="container">
            <div class="admin-header-content">
                <div class="admin-title-section">
                    <h1 class="admin-page-title">
                        <i class="fas fa-folder"></i> Manage Categories
                    </h1>
                    <p class="admin-page-subtitle">Organize your products with categories</p>
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
                <a href="ManageCategories.aspx" class="admin-tab active">
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
                        <i class="fas fa-plus-circle"></i> Add New Category
                    </h2>
                    <asp:Button ID="btnToggleForm" runat="server" Text="Show Form" CssClass="btn-toggle-form" OnClick="btnToggleForm_Click" CausesValidation="false" />
                </div>

                <asp:Panel ID="pnlAddCategory" runat="server" Visible="false" CssClass="admin-card">
                    <div class="form-container">
                        <div class="form-grid">
                            
                            <div class="form-group">
                                <label class="form-label">Category Name <span class="required">*</span></label>
                                <asp:TextBox ID="txtCategoryName" runat="server" CssClass="form-control" MaxLength="100" placeholder="e.g., Smartphones"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvCategoryName" runat="server" ControlToValidate="txtCategoryName" 
                                    ErrorMessage="Category name is required" CssClass="field-error" Display="Dynamic" ValidationGroup="AddCategory"></asp:RequiredFieldValidator>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Image URL</label>
                                <asp:TextBox ID="txtImageURL" runat="server" CssClass="form-control" MaxLength="255" placeholder="https://example.com/category-image.jpg"></asp:TextBox>
                                <small class="form-text">Optional category icon/image URL</small>
                            </div>

                            <div class="form-group form-group-full">
                                <label class="form-label">Description</label>
                                <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" 
                                    Rows="3" MaxLength="500" placeholder="Enter category description..."></asp:TextBox>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Status</label>
                                <div class="checkbox-wrapper">
                                    <asp:CheckBox ID="chkIsActive" runat="server" Checked="true" />
                                    <span>Active (Category will be visible to customers)</span>
                                </div>
                            </div>

                        </div>

                        <div class="form-actions">
                            <asp:Button ID="btnAddCategory" runat="server" Text="Add Category" CssClass="btn-primary-admin" 
                                OnClick="btnAddCategory_Click" ValidationGroup="AddCategory" />
                            <asp:Button ID="btnCancelAdd" runat="server" Text="Cancel" CssClass="btn-secondary-admin" 
                                OnClick="btnCancelAdd_Click" CausesValidation="false" />
                        </div>
                    </div>
                </asp:Panel>
            </div>

            <div class="admin-section">
                <div class="section-header-admin">
                    <h2 class="section-title-admin">
                        <i class="fas fa-list"></i> All Categories (<asp:Label ID="lblCategoryCount" runat="server" Text="0"></asp:Label>)
                    </h2>
                </div>

                <div class="admin-card">
                    <asp:Panel ID="pnlCategories" runat="server" Visible="true">
                        <div class="table-responsive">
                            <asp:GridView ID="gvCategories" runat="server" AutoGenerateColumns="False" 
                                CssClass="admin-table" DataKeyNames="CategoryID" 
                                OnRowEditing="gvCategories_RowEditing" 
                                OnRowCancelingEdit="gvCategories_RowCancelingEdit" 
                                OnRowUpdating="gvCategories_RowUpdating" 
                                OnRowDeleting="gvCategories_RowDeleting"
                                AllowPaging="True" PageSize="10" 
                                OnPageIndexChanging="gvCategories_PageIndexChanging">
                                
                                <Columns>
                                    <asp:BoundField DataField="CategoryID" HeaderText="ID" ReadOnly="True" />
                                    
                                    <asp:TemplateField HeaderText="Category Name">
                                        <ItemTemplate>
                                            <strong><%# Eval("CategoryName") %></strong>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtEditCategoryName" runat="server" Text='<%# Bind("CategoryName") %>' CssClass="form-control-sm" MaxLength="100"></asp:TextBox>
                                        </EditItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Description">
                                        <ItemTemplate>
                                            <%# Eval("Description") != null && Eval("Description").ToString().Length > 80 ? Eval("Description").ToString().Substring(0, 80) + "..." : Eval("Description") %>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtEditDescription" runat="server" Text='<%# Bind("Description") %>' CssClass="form-control-sm" TextMode="MultiLine" Rows="2"></asp:TextBox>
                                        </EditItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Products Count">
                                        <ItemTemplate>
                                            <span class="status-badge status-processing">
                                                <%# Eval("Products.Count") %> products
                                            </span>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Date Created">
                                        <ItemTemplate>
                                            <%# Convert.ToDateTime(Eval("DateCreated")).ToString("MMM dd, yyyy") %>
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
                                        </EditItemTemplate>
                                    </asp:TemplateField>

                                    <asp:CommandField HeaderText="Actions" ShowEditButton="True" ShowDeleteButton="True" 
                                        ButtonType="Button" ControlStyle-CssClass="btn-grid-action" />
                                </Columns>

                                <EmptyDataTemplate>
                                    <div class="empty-state">
                                        <i class="fas fa-folder-open"></i>
                                        <h3>No Categories Found</h3>
                                        <p>Start by adding your first category above.</p>
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