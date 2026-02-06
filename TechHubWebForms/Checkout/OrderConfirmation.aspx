<%@ Page Title="Order Confirmation" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="OrderConfirmation.aspx.cs" Inherits="TechHubWebForms.Checkout.OrderConfirmation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="container" style="padding: 60px 20px; max-width: 900px; margin: 0 auto;">
        
        <!-- Success Panel -->
        <asp:Panel ID="pnlSuccess" runat="server" Visible="true">
            
            <!-- Success Icon & Message -->
            <div style="text-align: center; margin-bottom: 40px;">
                <div style="width: 120px; height: 120px; background: linear-gradient(135deg, #10b981 0%, #059669 100%); border-radius: 60px; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 25px; box-shadow: 0 10px 40px rgba(16, 185, 129, 0.3);">
                    <i class="fas fa-check" style="font-size: 60px; color: white;"></i>
                </div>
                <h1 style="font-size: 36px; font-weight: 700; color: #1e293b; margin-bottom: 15px;">
                    Order Placed Successfully!
                </h1>
                <p style="font-size: 18px; color: #64748b; margin-bottom: 10px;">
                    Thank you for your purchase! Your order has been confirmed.
                </p>
                <p style="font-size: 16px; color: #64748b;">
                    We've sent a confirmation email to <strong><asp:Label ID="lblUserEmail" runat="server"></asp:Label></strong>
                </p>
            </div>

            <!-- Order Details Card -->
            <div style="background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); padding: 30px; margin-bottom: 30px;">
                
                <!-- Order ID & Status -->
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 30px; padding-bottom: 20px; border-bottom: 2px solid #f1f5f9;">
                    <div>
                        <div style="font-size: 14px; color: #64748b; margin-bottom: 8px;">ORDER ID</div>
                        <div style="font-size: 24px; font-weight: 700; color: #3b82f6;">
                            #<asp:Label ID="lblOrderID" runat="server"></asp:Label>
                        </div>
                    </div>
                    <div>
                        <div style="font-size: 14px; color: #64748b; margin-bottom: 8px;">ORDER DATE</div>
                        <div style="font-size: 16px; font-weight: 600; color: #1e293b;">
                            <asp:Label ID="lblOrderDate" runat="server"></asp:Label>
                        </div>
                    </div>
                    <div>
                        <div style="font-size: 14px; color: #64748b; margin-bottom: 8px;">STATUS</div>
                        <div>
                            <span style="display: inline-block; padding: 6px 14px; background: #fef3c7; color: #92400e; border-radius: 20px; font-size: 14px; font-weight: 600; text-transform: uppercase;">
                                <asp:Label ID="lblOrderStatus" runat="server"></asp:Label>
                            </span>
                        </div>
                    </div>
                    <div>
                        <div style="font-size: 14px; color: #64748b; margin-bottom: 8px;">TOTAL AMOUNT</div>
                        <div style="font-size: 20px; font-weight: 700; color: #10b981;">
                            NPR <asp:Label ID="lblTotalAmount" runat="server"></asp:Label>
                        </div>
                    </div>
                </div>

                <!-- Shipping & Payment Info -->
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px;">
                    <div style="padding: 20px; background: #f8fafc; border-radius: 8px;">
                        <h3 style="font-size: 16px; font-weight: 600; color: #1e293b; margin-bottom: 12px;">
                            <i class="fas fa-shipping-fast" style="color: #3b82f6;"></i> Shipping Address
                        </h3>
                        <p style="font-size: 14px; color: #64748b; line-height: 1.6; margin: 0;">
                            <asp:Label ID="lblShippingAddress" runat="server"></asp:Label>
                        </p>
                        <p style="font-size: 14px; color: #64748b; margin-top: 8px; margin-bottom: 0;">
                            <i class="fas fa-phone"></i> <asp:Label ID="lblContactPhone" runat="server"></asp:Label>
                        </p>
                    </div>
                    <div style="padding: 20px; background: #f8fafc; border-radius: 8px;">
                        <h3 style="font-size: 16px; font-weight: 600; color: #1e293b; margin-bottom: 12px;">
                            <i class="fas fa-credit-card" style="color: #10b981;"></i> Payment Method
                        </h3>
                        <p style="font-size: 14px; color: #64748b; margin: 0;">
                            <asp:Label ID="lblPaymentMethod" runat="server"></asp:Label>
                        </p>
                        <p style="font-size: 12px; color: #94a3b8; margin-top: 8px; margin-bottom: 0;">
                            <asp:Label ID="lblPaymentNote" runat="server"></asp:Label>
                        </p>
                    </div>
                </div>

                <!-- Order Items -->
                <div>
                    <h3 style="font-size: 18px; font-weight: 600; color: #1e293b; margin-bottom: 15px;">
                        Order Items
                    </h3>
                    
                    <asp:Repeater ID="rptOrderItems" runat="server">
                        <ItemTemplate>
                            <div style="display: flex; gap: 15px; padding: 15px; border: 1px solid #e5e7eb; border-radius: 8px; margin-bottom: 10px;">
                                <!-- Product Image -->
                                <div style="width: 80px; height: 80px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 8px; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                                    <i class="fas fa-mobile-alt" style="font-size: 32px; color: rgba(255,255,255,0.5);"></i>
                                </div>
                                <!-- Product Details -->
                                <div style="flex: 1;">
                                    <div style="font-size: 12px; color: #3b82f6; font-weight: 600; text-transform: uppercase; margin-bottom: 5px;">
                                        <%# Eval("Product.Brand") %>
                                    </div>
                                    <h4 style="font-size: 16px; font-weight: 600; color: #1e293b; margin-bottom: 8px;">
                                        <%# Eval("Product.Name") %>
                                    </h4>
                                    <div style="display: flex; gap: 20px; font-size: 14px; color: #64748b;">
                                        <span>Qty: <strong style="color: #1e293b;"><%# Eval("Quantity") %></strong></span>
                                        <span>Price: <strong style="color: #1e293b;">NPR <%# String.Format("{0:N0}", Eval("UnitPrice")) %></strong></span>
                                    </div>
                                </div>
                                <!-- Subtotal -->
                                <div style="text-align: right; min-width: 120px;">
                                    <div style="font-size: 12px; color: #64748b; margin-bottom: 5px;">SUBTOTAL</div>
                                    <div style="font-size: 18px; font-weight: 700; color: #1e293b;">
                                        NPR <%# String.Format("{0:N0}", Eval("Subtotal")) %>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                </div>

            </div>

            <!-- What's Next Section -->
            <div style="background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%); border-radius: 12px; padding: 30px; margin-bottom: 30px;">
                <h2 style="font-size: 24px; font-weight: 700; color: #1e293b; margin-bottom: 20px;">
                    <i class="fas fa-info-circle" style="color: #3b82f6;"></i> What Happens Next?
                </h2>
                <div style="display: grid; gap: 15px;">
                    <div style="display: flex; gap: 15px; align-items: start;">
                        <div style="width: 40px; height: 40px; background: #3b82f6; color: white; border-radius: 20px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-weight: 700;">1</div>
                        <div>
                            <div style="font-weight: 600; color: #1e293b; margin-bottom: 5px;">Order Confirmation</div>
                            <div style="font-size: 14px; color: #64748b;">You'll receive an email confirmation shortly with your order details.</div>
                        </div>
                    </div>
                    <div style="display: flex; gap: 15px; align-items: start;">
                        <div style="width: 40px; height: 40px; background: #3b82f6; color: white; border-radius: 20px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-weight: 700;">2</div>
                        <div>
                            <div style="font-weight: 600; color: #1e293b; margin-bottom: 5px;">Order Processing</div>
                            <div style="font-size: 14px; color: #64748b;">We'll prepare your order and send you tracking information once shipped.</div>
                        </div>
                    </div>
                    <div style="display: flex; gap: 15px; align-items: start;">
                        <div style="width: 40px; height: 40px; background: #3b82f6; color: white; border-radius: 20px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; font-weight: 700;">3</div>
                        <div>
                            <div style="font-weight: 600; color: #1e293b; margin-bottom: 5px;">Delivery</div>
                            <div style="font-size: 14px; color: #64748b;">Your order will be delivered to your address within 3-5 business days.</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Action Buttons -->
            <div style="display: flex; gap: 15px; justify-content: center; flex-wrap: wrap;">
                <asp:HyperLink ID="lnkViewOrders" runat="server" NavigateUrl="~/Cart/CartHistory.aspx"
                    style="display: inline-flex; align-items: center; gap: 8px; padding: 14px 32px; background: #3b82f6; color: white; border-radius: 8px; text-decoration: none; font-size: 16px; font-weight: 600; transition: background 0.3s;"
                    onmouseover="this.style.background='#2563eb'" 
                    onmouseout="this.style.background='#3b82f6'">
                    <i class="fas fa-list"></i> View My Orders
                </asp:HyperLink>
                <asp:HyperLink ID="lnkContinueShopping" runat="server" NavigateUrl="~/Products/Default.aspx"
                    style="display: inline-flex; align-items: center; gap: 8px; padding: 14px 32px; background: white; color: #3b82f6; border: 2px solid #3b82f6; border-radius: 8px; text-decoration: none; font-size: 16px; font-weight: 600; transition: all 0.3s;"
                    onmouseover="this.style.background='#eff6ff'" 
                    onmouseout="this.style.background='white'">
                    <i class="fas fa-shopping-bag"></i> Continue Shopping
                </asp:HyperLink>
            </div>

        </asp:Panel>

        <!-- Error Panel -->
        <asp:Panel ID="pnlError" runat="server" Visible="false">
            <div style="background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); padding: 80px 40px; text-align: center;">
                <i class="fas fa-exclamation-triangle" style="font-size: 100px; color: #fbbf24; margin-bottom: 25px;"></i>
                <h2 style="font-size: 28px; font-weight: 700; color: #1e293b; margin-bottom: 15px;">Order Not Found</h2>
                <p style="font-size: 16px; color: #64748b; margin-bottom: 30px;">We couldn't find the order you're looking for.</p>
                <asp:HyperLink ID="lnkGoHome" runat="server" NavigateUrl="~/Default.aspx"
                    style="display: inline-block; padding: 14px 40px; background: #3b82f6; color: white; border-radius: 8px; text-decoration: none; font-size: 16px; font-weight: 600; transition: background 0.3s;"
                    onmouseover="this.style.background='#2563eb'" 
                    onmouseout="this.style.background='#3b82f6'">
                    <i class="fas fa-home"></i> Go to Home
                </asp:HyperLink>
            </div>
        </asp:Panel>

    </div>

    <!-- Mobile Responsive Styles -->
    <style>
        @media (max-width: 768px) {
            .container > div > div > div {
                grid-template-columns: 1fr !important;
            }
        }
    </style>

</asp:Content>
