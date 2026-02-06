<%@ Page Title="My Wishlist" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Wishlist.aspx.cs" Inherits="TechHubWebForms.Wishlist" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="container" style="padding: 40px 20px; max-width: 1400px; margin: 0 auto;">
        
        <!-- Page Header -->
        <div style="margin-bottom: 30px;">
            <h1 style="font-size: 36px; font-weight: 700; color: #1e293b; margin-bottom: 10px;">
                <i class="fas fa-heart" style="color: #ef4444;"></i> My Wishlist
            </h1>
            <p style="font-size: 18px; color: #64748b;">Save your favorite products for later</p>
        </div>

        <!-- Success/Error Message -->
        <asp:Panel ID="pnlMessage" runat="server" Visible="false" style="margin-bottom: 20px;">
            <div id="divMessage" runat="server" style="padding: 15px; border-radius: 8px; font-size: 14px; font-weight: 500;"></div>
        </asp:Panel>

        <!-- Wishlist Items Section -->
        <asp:Panel ID="pnlWishlistItems" runat="server" Visible="true">
            
            <!-- Wishlist Header -->
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; padding: 20px; background: white; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.1);">
                <div>
                    <span style="font-size: 18px; font-weight: 600; color: #1e293b;">
                        <asp:Label ID="lblItemCount" runat="server"></asp:Label> item(s) in your wishlist
                    </span>
                </div>
                <asp:Button ID="btnClearWishlist" runat="server" Text="Clear Wishlist" OnClick="btnClearWishlist_Click"
                    CausesValidation="false"
                    OnClientClick="return confirm('Are you sure you want to clear your entire wishlist?');"
                    style="padding: 10px 20px; background: white; color: #ef4444; border: 2px solid #ef4444; border-radius: 8px; font-weight: 600; cursor: pointer; transition: all 0.3s;"
                    onmouseover="this.style.background='#fef2f2'" 
                    onmouseout="this.style.background='white'" />
            </div>

            <!-- Wishlist Items Grid -->
            <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 25px;">
                
                <asp:Repeater ID="rptWishlistItems" runat="server" OnItemCommand="rptWishlistItems_ItemCommand">
                    <ItemTemplate>
                        <div style="background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); overflow: hidden; transition: transform 0.3s, box-shadow 0.3s; position: relative;"
                             onmouseover="this.style.transform='translateY(-5px)'; this.style.boxShadow='0 8px 20px rgba(0,0,0,0.15)'" 
                             onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='0 2px 8px rgba(0,0,0,0.1)'">
                            
                            <!-- Remove Button -->
                            <asp:LinkButton ID="btnRemove" runat="server" 
                                CommandName="RemoveItem" 
                                CommandArgument='<%# Eval("WishlistID") %>'
                                CausesValidation="false"
                                OnClientClick="return confirm('Remove this item from wishlist?');"
                                style="position: absolute; top: 10px; right: 10px; width: 36px; height: 36px; background: rgba(255,255,255,0.95); color: #ef4444; border: none; border-radius: 18px; display: flex; align-items: center; justify-content: center; cursor: pointer; z-index: 10; box-shadow: 0 2px 6px rgba(0,0,0,0.15); text-decoration: none;"
                                onmouseover="this.style.background='#fee2e2'" 
                                onmouseout="this.style.background='rgba(255,255,255,0.95)'">
                                <i class="fas fa-times"></i>
                            </asp:LinkButton>

                            <!-- Product Image -->
                            <div style="height: 200px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); display: flex; align-items: center; justify-content: center;">
                                <i class="fas fa-mobile-alt" style="font-size: 80px; color: rgba(255,255,255,0.3);"></i>
                            </div>

                            <!-- Product Details -->
                            <div style="padding: 20px;">
                                <!-- Brand -->
                                <div style="font-size: 12px; color: #3b82f6; font-weight: 600; text-transform: uppercase; margin-bottom: 8px;">
                                    <%# Eval("Product.Brand") %>
                                </div>

                                <!-- Product Name -->
                                <h3 style="font-size: 18px; font-weight: 600; color: #1e293b; margin-bottom: 10px; line-height: 1.4; min-height: 50px;">
                                    <%# Eval("Product.Name") %>
                                </h3>

                                <!-- Price -->
                                <div style="font-size: 24px; font-weight: 700; color: #10b981; margin-bottom: 15px;">
                                    NPR <%# String.Format("{0:N0}", Eval("Product.Price")) %>
                                </div>

                                <!-- Stock Status -->
                                <div style="margin-bottom: 15px;">
                                    <%# Convert.ToInt32(Eval("Product.StockQuantity")) > 0 
                                        ? "<span style='padding: 4px 10px; background: #d1fae5; color: #065f46; border-radius: 12px; font-size: 12px; font-weight: 600;'>In Stock</span>" 
                                        : "<span style='padding: 4px 10px; background: #fee2e2; color: #991b1b; border-radius: 12px; font-size: 12px; font-weight: 600;'>Out of Stock</span>" %>
                                </div>

                                <!-- Date Added -->
                                <div style="font-size: 12px; color: #94a3b8; margin-bottom: 15px;">
                                    <i class="fas fa-clock"></i> Added on <%# Convert.ToDateTime(Eval("DateAdded")).ToString("MMM dd, yyyy") %>
                                </div>

                                <!-- Buttons -->
                                <div style="display: flex; gap: 10px;">
                                    <asp:LinkButton ID="btnAddToCart" runat="server" 
                                        CommandName="AddToCart" 
                                        CommandArgument='<%# Eval("ProductID") + "," + Eval("Product.StockQuantity") %>'
                                        CausesValidation="false"
                                        Enabled='<%# Convert.ToInt32(Eval("Product.StockQuantity")) > 0 %>'
                                        style='<%# Convert.ToInt32(Eval("Product.StockQuantity")) > 0 
                                            ? "flex: 1; padding: 12px; background: #3b82f6; color: white; border: none; border-radius: 8px; text-align: center; font-weight: 600; cursor: pointer; text-decoration: none; transition: background 0.3s;" 
                                            : "flex: 1; padding: 12px; background: #e5e7eb; color: #94a3b8; border: none; border-radius: 8px; text-align: center; font-weight: 600; cursor: not-allowed; text-decoration: none;" %>'
                                        onmouseover='<%# Convert.ToInt32(Eval("Product.StockQuantity")) > 0 ? "this.style.background=\"#2563eb\"" : "" %>'
                                        onmouseout='<%# Convert.ToInt32(Eval("Product.StockQuantity")) > 0 ? "this.style.background=\"#3b82f6\"" : "" %>'>
                                        <i class="fas fa-shopping-cart"></i> Add to Cart
                                    </asp:LinkButton>

                                    <asp:HyperLink ID="lnkViewProduct" runat="server" 
                                        NavigateUrl='<%# "~/Products/Details.aspx?id=" + Eval("ProductID") %>'
                                        style="flex: 1; padding: 12px; background: white; color: #3b82f6; border: 2px solid #3b82f6; border-radius: 8px; text-align: center; font-weight: 600; text-decoration: none; transition: all 0.3s;"
                                        onmouseover="this.style.background='#eff6ff'" 
                                        onmouseout="this.style.background='white'">
                                        <i class="fas fa-eye"></i> View
                                    </asp:HyperLink>
                                </div>
                            </div>

                        </div>
                    </ItemTemplate>
                </asp:Repeater>

            </div>

        </asp:Panel>

        <!-- Empty Wishlist Panel -->
        <asp:Panel ID="pnlEmptyWishlist" runat="server" Visible="false">
            <div style="background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); padding: 80px 40px; text-align: center;">
                <i class="fas fa-heart-broken" style="font-size: 100px; color: #cbd5e1; margin-bottom: 25px;"></i>
                <h2 style="font-size: 28px; font-weight: 700; color: #1e293b; margin-bottom: 15px;">Your Wishlist is Empty</h2>
                <p style="font-size: 16px; color: #64748b; margin-bottom: 30px;">Start adding products you love to your wishlist!</p>
                <asp:HyperLink ID="lnkStartShopping" runat="server" NavigateUrl="~/Products/Default.aspx"
                    style="display: inline-block; padding: 14px 40px; background: #3b82f6; color: white; border-radius: 8px; text-decoration: none; font-size: 16px; font-weight: 600; transition: background 0.3s;"
                    onmouseover="this.style.background='#2563eb'" 
                    onmouseout="this.style.background='#3b82f6'">
                    <i class="fas fa-shopping-bag"></i> Browse Products
                </asp:HyperLink>
            </div>
        </asp:Panel>

    </div>

    <!-- Mobile Responsive Styles -->
    <style>
        @media (max-width: 768px) {
            .container > div > div {
                grid-template-columns: 1fr !important;
            }
        }
    </style>

</asp:Content>
