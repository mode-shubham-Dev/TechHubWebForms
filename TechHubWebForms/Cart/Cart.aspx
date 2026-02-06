<%@ Page Title="Shopping Cart" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Cart.aspx.cs" Inherits="TechHubWebForms.Cart.Cart" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="container" style="padding: 40px 20px; max-width: 1400px; margin: 0 auto;">
        
        <!-- Page Header -->
        <div style="margin-bottom: 30px;">
            <h1 style="font-size: 36px; font-weight: 700; color: #1e293b; margin-bottom: 10px;">
                <i class="fas fa-shopping-cart" style="color: #3b82f6;"></i> Shopping Cart
            </h1>
            <p style="font-size: 18px; color: #64748b;">Review your items and proceed to checkout</p>
        </div>

        <!-- Cart Items Section -->
        <asp:Panel ID="pnlCartItems" runat="server" Visible="true">
            <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 30px;">
                
                <!-- Left Side - Cart Items List -->
                <div>
                    <div style="background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); padding: 20px;">
                        
                        <!-- Cart Items Header -->
                        <div style="display: grid; grid-template-columns: 2fr 1fr 1fr 1fr 80px; gap: 15px; padding: 15px; background: #f8fafc; border-radius: 8px; margin-bottom: 20px; font-weight: 600; color: #475569; font-size: 14px;">
                            <div>PRODUCT</div>
                            <div style="text-align: center;">PRICE</div>
                            <div style="text-align: center;">QUANTITY</div>
                            <div style="text-align: center;">SUBTOTAL</div>
                            <div></div>
                        </div>

                        <!-- Cart Items Repeater -->
                        <asp:Repeater ID="rptCartItems" runat="server" OnItemCommand="rptCartItems_ItemCommand">
                            <ItemTemplate>
                                <div style="display: grid; grid-template-columns: 2fr 1fr 1fr 1fr 80px; gap: 15px; align-items: center; padding: 20px 15px; border-bottom: 1px solid #e5e7eb;">
                                    
                                    <!-- Product Info -->
                                    <div style="display: flex; gap: 15px; align-items: center;">
                                        <!-- Product Image Placeholder -->
                                        <div style="width: 80px; height: 80px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 8px; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                                            <i class="fas fa-mobile-alt" style="font-size: 32px; color: rgba(255,255,255,0.5);"></i>
                                        </div>
                                        <div>
                                            <div style="font-size: 12px; color: #3b82f6; font-weight: 600; text-transform: uppercase; margin-bottom: 5px;">
                                                <%# Eval("Product.Brand") %>
                                            </div>
                                            <h4 style="font-size: 16px; font-weight: 600; color: #1e293b; margin-bottom: 5px;">
                                                <%# Eval("Product.Name") %>
                                            </h4>
                                            <div style="font-size: 12px; color: #94a3b8;">
                                                Stock: <%# Eval("Product.StockQuantity") %> available
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Price -->
                                    <div style="text-align: center; font-size: 16px; font-weight: 600; color: #1e293b;">
                                        NPR <%# String.Format("{0:N0}", Eval("Product.Price")) %>
                                    </div>

                                    <!-- Quantity Controls -->
                                    <div style="display: flex; align-items: center; justify-content: center; gap: 5px;">
                                        <asp:LinkButton ID="btnDecreaseQty" runat="server" 
                                            CommandName="DecreaseQuantity" 
                                            CommandArgument='<%# Eval("CartID") %>'
                                            CausesValidation="false"
                                            style="width: 32px; height: 32px; background: #f1f5f9; color: #475569; border: none; border-radius: 6px; display: flex; align-items: center; justify-content: center; cursor: pointer; text-decoration: none; font-size: 18px; font-weight: 600;"
                                            onmouseover="this.style.background='#e2e8f0'" 
                                            onmouseout="this.style.background='#f1f5f9'">
                                            <i class="fas fa-minus"></i>
                                        </asp:LinkButton>
                                        
                                        <span style="width: 50px; text-align: center; font-size: 16px; font-weight: 600; color: #1e293b;">
                                            <%# Eval("Quantity") %>
                                        </span>
                                        
                                        <asp:LinkButton ID="btnIncreaseQty" runat="server" 
                                            CommandName="IncreaseQuantity" 
                                            CommandArgument='<%# Eval("CartID") + "," + Eval("Product.StockQuantity") %>'
                                            CausesValidation="false"
                                            style="width: 32px; height: 32px; background: #f1f5f9; color: #475569; border: none; border-radius: 6px; display: flex; align-items: center; justify-content: center; cursor: pointer; text-decoration: none; font-size: 18px; font-weight: 600;"
                                            onmouseover="this.style.background='#e2e8f0'" 
                                            onmouseout="this.style.background='#f1f5f9'">
                                            <i class="fas fa-plus"></i>
                                        </asp:LinkButton>
                                    </div>

                                    <!-- Subtotal -->
                                    <div style="text-align: center; font-size: 18px; font-weight: 700; color: #1e293b;">
                                        NPR <%# String.Format("{0:N0}", Convert.ToDecimal(Eval("Product.Price")) * Convert.ToInt32(Eval("Quantity"))) %>
                                    </div>

                                    <!-- Remove Button -->
                                    <div style="text-align: center;">
                                        <asp:LinkButton ID="btnRemove" runat="server" 
                                            CommandName="RemoveItem" 
                                            CommandArgument='<%# Eval("CartID") %>'
                                            CausesValidation="false"
                                            OnClientClick="return confirm('Are you sure you want to remove this item from cart?');"
                                            style="width: 36px; height: 36px; background: #fef2f2; color: #ef4444; border: none; border-radius: 6px; display: flex; align-items: center; justify-content: center; cursor: pointer; text-decoration: none;"
                                            onmouseover="this.style.background='#fee2e2'" 
                                            onmouseout="this.style.background='#fef2f2'">
                                            <i class="fas fa-trash-alt"></i>
                                        </asp:LinkButton>
                                    </div>

                                </div>
                            </ItemTemplate>
                        </asp:Repeater>

                        <!-- Continue Shopping Button -->
                        <div style="margin-top: 20px; padding-top: 20px; border-top: 1px solid #e5e7eb;">
                            <asp:HyperLink ID="lnkContinueShopping" runat="server" NavigateUrl="~/Products/Default.aspx"
                                style="display: inline-flex; align-items: center; gap: 8px; padding: 12px 24px; background: white; color: #3b82f6; border: 2px solid #3b82f6; border-radius: 8px; text-decoration: none; font-weight: 600; transition: all 0.3s;"
                                onmouseover="this.style.background='#eff6ff'" 
                                onmouseout="this.style.background='white'">
                                <i class="fas fa-arrow-left"></i> Continue Shopping
                            </asp:HyperLink>
                        </div>

                    </div>
                </div>

                <!-- Right Side - Order Summary -->
                <div>
                    <div style="background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); padding: 25px; position: sticky; top: 20px;">
                        
                        <h3 style="font-size: 20px; font-weight: 700; color: #1e293b; margin-bottom: 20px; padding-bottom: 15px; border-bottom: 2px solid #e5e7eb;">
                            Order Summary
                        </h3>

                        <!-- Items Count -->
                        <div style="display: flex; justify-content: space-between; margin-bottom: 15px; color: #64748b; font-size: 14px;">
                            <span>Items in Cart:</span>
                            <span style="font-weight: 600; color: #1e293b;">
                                <asp:Label ID="lblItemCount" runat="server"></asp:Label>
                            </span>
                        </div>

                        <!-- Subtotal -->
                        <div style="display: flex; justify-content: space-between; margin-bottom: 15px; font-size: 16px;">
                            <span style="color: #64748b;">Subtotal:</span>
                            <span style="font-weight: 600; color: #1e293b;">
                                NPR <asp:Label ID="lblSubtotal" runat="server"></asp:Label>
                            </span>
                        </div>

                        <!-- Delivery Fee -->
                        <div style="display: flex; justify-content: space-between; margin-bottom: 15px; font-size: 16px;">
                            <span style="color: #64748b;">Delivery Fee:</span>
                            <span style="font-weight: 600; color: #10b981;">
                                <asp:Label ID="lblDeliveryFee" runat="server">FREE</asp:Label>
                            </span>
                        </div>

                        <!-- Divider -->
                        <div style="border-top: 2px solid #e5e7eb; margin: 20px 0;"></div>

                        <!-- Total -->
                        <div style="display: flex; justify-content: space-between; margin-bottom: 25px;">
                            <span style="font-size: 20px; font-weight: 700; color: #1e293b;">Total:</span>
                            <span style="font-size: 24px; font-weight: 700; color: #3b82f6;">
                                NPR <asp:Label ID="lblTotal" runat="server"></asp:Label>
                            </span>
                        </div>

                        <!-- Proceed to Checkout Button -->
                        <asp:Button ID="btnCheckout" runat="server" Text="Proceed to Checkout" OnClick="btnCheckout_Click"
                            CausesValidation="false"
                            style="width: 100%; padding: 16px; background: #3b82f6; color: white; border: none; border-radius: 8px; font-size: 16px; font-weight: 600; cursor: pointer; margin-bottom: 12px; transition: background 0.3s;"
                            onmouseover="this.style.background='#2563eb'" 
                            onmouseout="this.style.background='#3b82f6'" />

                        <!-- Clear Cart Button -->
                        <asp:Button ID="btnClearCart" runat="server" Text="Clear Cart" OnClick="btnClearCart_Click"
                            CausesValidation="false"
                            OnClientClick="return confirm('Are you sure you want to clear your entire cart?');"
                            style="width: 100%; padding: 12px; background: white; color: #ef4444; border: 2px solid #ef4444; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; transition: all 0.3s;"
                            onmouseover="this.style.background='#fef2f2'" 
                            onmouseout="this.style.background='white'" />

                        <!-- Security Badge -->
                        <div style="margin-top: 20px; padding: 15px; background: #f8fafc; border-radius: 8px; text-align: center;">
                            <i class="fas fa-lock" style="color: #10b981; font-size: 20px; margin-bottom: 8px;"></i>
                            <p style="font-size: 12px; color: #64748b; margin: 0;">Secure Checkout</p>
                        </div>

                    </div>
                </div>

            </div>
        </asp:Panel>

        <!-- Empty Cart Panel -->
        <asp:Panel ID="pnlEmptyCart" runat="server" Visible="false">
            <div style="background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); padding: 80px 40px; text-align: center;">
                <i class="fas fa-shopping-cart" style="font-size: 100px; color: #cbd5e1; margin-bottom: 25px;"></i>
                <h2 style="font-size: 28px; font-weight: 700; color: #1e293b; margin-bottom: 15px;">Your Cart is Empty</h2>
                <p style="font-size: 16px; color: #64748b; margin-bottom: 30px;">Looks like you haven't added any items to your cart yet.</p>
                <asp:HyperLink ID="lnkStartShopping" runat="server" NavigateUrl="~/Products/Default.aspx"
                    style="display: inline-block; padding: 14px 40px; background: #3b82f6; color: white; border-radius: 8px; text-decoration: none; font-size: 16px; font-weight: 600; transition: background 0.3s;"
                    onmouseover="this.style.background='#2563eb'" 
                    onmouseout="this.style.background='#3b82f6'">
                    <i class="fas fa-shopping-bag"></i> Start Shopping
                </asp:HyperLink>
            </div>
        </asp:Panel>

        <!-- Success/Error Message -->
        <asp:Panel ID="pnlMessage" runat="server" Visible="false" style="margin-bottom: 20px;">
            <div id="divMessage" runat="server" style="padding: 15px; border-radius: 8px; font-size: 14px; font-weight: 500;"></div>
        </asp:Panel>

    </div>

    <!-- Mobile Responsive Styles -->
    <style>
        @media (max-width: 992px) {
            .container > div > div {
                grid-template-columns: 1fr !important;
            }
            
            .container > div > div > div:first-child > div > div:first-child {
                display: none !important;
            }
            
            .container > div > div > div:first-child > div > div:not(:first-child) {
                grid-template-columns: 1fr !important;
                gap: 10px !important;
            }
        }
    </style>

</asp:Content>
