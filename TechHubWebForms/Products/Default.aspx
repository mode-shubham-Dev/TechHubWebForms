<%@ Page Title="Products" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="TechHubWebForms.Products.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="container" style="padding: 40px 20px; max-width: 1400px; margin: 0 auto;">
        
        <div style="margin-bottom: 30px;">
            <h1 style="font-size: 36px; font-weight: 700; color: #1e293b; margin-bottom: 10px;">
                <i class="fas fa-shopping-bag" style="color: #3b82f6;"></i> Our Products
            </h1>
            <p style="font-size: 18px; color: #64748b;">Browse our wide range of tech products</p>
        </div>

        <div style="background: white; padding: 20px; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); margin-bottom: 30px;">
            <div style="display: flex; flex-wrap: wrap; gap: 20px; align-items: center;">
                
                <div style="flex: 1; min-width: 250px;">
                    <label style="display: block; margin-bottom: 8px; color: #1e293b; font-weight: 500;">
                        <i class="fas fa-search"></i> Search Products
                    </label>
                    <div style="display: flex; gap: 10px;">
                        <asp:TextBox 
                            ID="txtSearch" 
                            runat="server" 
                            CssClass="form-control"
                            placeholder="Search by name or brand..."
                            style="flex: 1; padding: 10px; border: 1px solid #e5e7eb; border-radius: 8px; font-size: 16px;" />
                        <asp:Button 
                            ID="btnSearch" 
                            runat="server" 
                            Text="Search" 
                            OnClick="btnSearch_Click"
                            CausesValidation="false"
                            style="padding: 10px 24px; background: #3b82f6; color: white; border: none; border-radius: 8px; font-weight: 500; cursor: pointer;" />
                    </div>
                </div>

                <div style="min-width: 200px;">
                    <label style="display: block; margin-bottom: 8px; color: #1e293b; font-weight: 500;">
                        <i class="fas fa-filter"></i> Category
                    </label>
                    <asp:DropDownList 
                        ID="ddlCategory" 
                        runat="server" 
                        AutoPostBack="true"
                        OnSelectedIndexChanged="ddlCategory_SelectedIndexChanged"
                        CssClass="form-control"
                        style="width: 100%; padding: 10px; border: 1px solid #e5e7eb; border-radius: 8px; font-size: 16px;">
                    </asp:DropDownList>
                </div>

                <div style="min-width: 200px;">
                    <label style="display: block; margin-bottom: 8px; color: #1e293b; font-weight: 500;">
                        <i class="fas fa-sort"></i> Sort By
                    </label>
                    <asp:DropDownList 
                        ID="ddlSort" 
                        runat="server" 
                        AutoPostBack="true"
                        OnSelectedIndexChanged="ddlSort_SelectedIndexChanged"
                        CssClass="form-control"
                        style="width: 100%; padding: 10px; border: 1px solid #e5e7eb; border-radius: 8px; font-size: 16px;">
                        <asp:ListItem Value="newest" Selected="True">Newest First</asp:ListItem>
                        <asp:ListItem Value="price_low">Price: Low to High</asp:ListItem>
                        <asp:ListItem Value="price_high">Price: High to Low</asp:ListItem>
                        <asp:ListItem Value="name">Name: A to Z</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div style="padding-top: 28px;">
                    <asp:Button 
                        ID="btnClearFilters" 
                        runat="server" 
                        Text="Clear Filters" 
                        OnClick="btnClearFilters_Click"
                        CausesValidation="false"
                        style="padding: 10px 20px; background: white; color: #64748b; border: 2px solid #e5e7eb; border-radius: 8px; font-weight: 500; cursor: pointer;" />
                </div>

            </div>

            <div style="margin-top: 15px; padding-top: 15px; border-top: 1px solid #e5e7eb;">
                <asp:Label ID="lblResultsCount" runat="server" style="color: #64748b; font-size: 14px;"></asp:Label>
            </div>
        </div>

        <asp:Repeater ID="rptProducts" runat="server" OnItemCommand="rptProducts_ItemCommand">
            <HeaderTemplate>
                <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 25px;">
            </HeaderTemplate>
            
            <ItemTemplate>
                <div style="background: white; border-radius: 12px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.1); transition: all 0.3s; cursor: pointer;"
                     onmouseover="this.style.transform='translateY(-5px)'; this.style.boxShadow='0 8px 20px rgba(0,0,0,0.15)'" 
                     onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='0 2px 8px rgba(0,0,0,0.1)'">
                    
                    <div style="height: 220px; position: relative; overflow: hidden; background: #f8fafc;">
                        <asp:Image ID="imgProduct" runat="server" 
                            ImageUrl='<%# GetProductImageUrl(Eval("ImageURL1")) %>' 
                            AlternateText='<%# Eval("Name") %>' 
                            style="width: 100%; height: 100%; object-fit: cover;"
                            onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                        
                        <div style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); display: none; align-items: center; justify-content: center;">
                            <i class="fas fa-mobile-alt" style="font-size: 80px; color: rgba(255,255,255,0.3);"></i>
                        </div>
                        
                        <div style="position: absolute; top: 10px; right: 10px; background: <%# Convert.ToInt32(Eval("StockQuantity")) > 10 ? "#10b981" : "#ef4444" %>; color: white; padding: 5px 12px; border-radius: 20px; font-size: 12px; font-weight: 600;">
                            <%# Convert.ToInt32(Eval("StockQuantity")) > 10 ? "In Stock" : "Low Stock" %>
                        </div>
                    </div>

                    <div style="padding: 20px;">
                        <div style="color: #3b82f6; font-size: 12px; font-weight: 600; text-transform: uppercase; margin-bottom: 8px;">
                            <%# Eval("Brand") %>
                        </div>

                        <h3 style="font-size: 16px; font-weight: 600; color: #1e293b; margin-bottom: 8px; height: 40px; overflow: hidden; line-height: 1.3;">
                            <%# Eval("Name") %>
                        </h3>

                        <p style="font-size: 14px; color: #64748b; margin-bottom: 15px; height: 40px; overflow: hidden; line-height: 1.4;">
                            <%# Eval("Description") != null && Eval("Description").ToString().Length > 60 ? Eval("Description").ToString().Substring(0, 60) + "..." : Eval("Description") %>
                        </p>

                        <div style="margin-bottom: 15px;">
                            <span style="font-size: 24px; font-weight: 700; color: #1e293b;">
                                NPR <%# String.Format("{0:N0}", Eval("Price")) %>
                            </span>
                        </div>

                        <div style="display: flex; gap: 10px;">
                            <asp:LinkButton 
                                ID="btnViewDetails" 
                                runat="server" 
                                CommandName="ViewDetails"
                                CommandArgument='<%# Eval("ProductID") %>'
                                style="flex: 1; padding: 10px; background: #3b82f6; color: white; text-align: center; border-radius: 8px; text-decoration: none; font-weight: 500; transition: background 0.3s;"
                                onmouseover="this.style.background='#2563eb'" 
                                onmouseout="this.style.background='#3b82f6'">
                                <i class="fas fa-eye"></i> View Details
                            </asp:LinkButton>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
            
            <FooterTemplate>
                </div>
            </FooterTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlNoResults" runat="server" Visible="false" style="text-align: center; padding: 60px 20px;">
            <i class="fas fa-inbox" style="font-size: 80px; color: #cbd5e1; margin-bottom: 20px;"></i>
            <h3 style="color: #64748b; font-size: 24px; margin-bottom: 10px;">No Products Found</h3>
            <p style="color: #94a3b8; font-size: 16px; margin-bottom: 20px;">Try adjusting your filters or search terms</p>
            <asp:Button 
                ID="btnResetSearch" 
                runat="server" 
                Text="Clear All Filters" 
                OnClick="btnClearFilters_Click"
                style="padding: 12px 32px; background: #3b82f6; color: white; border: none; border-radius: 8px; font-size: 16px; font-weight: 500; cursor: pointer;" />
        </asp:Panel>

    </div>

</asp:Content>