<%@ Page Title="Order History" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CartHistory.aspx.cs" Inherits="TechHubWebForms.Cart.CartHistory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="container" style="padding: 40px 20px; max-width: 1400px; margin: 0 auto;">
        
        <!-- Page Header -->
        <div style="margin-bottom: 30px;">
            <h1 style="font-size: 36px; font-weight: 700; color: #1e293b; margin-bottom: 10px;">
                <i class="fas fa-history" style="color: #3b82f6;"></i> Order History
            </h1>
            <p style="font-size: 18px; color: #64748b;">View your past orders and their details</p>
        </div>

        <!-- Orders List Section -->
        <asp:Panel ID="pnlOrders" runat="server" Visible="true">
            
            <!-- Filter Options -->
            <div style="background: white; padding: 20px; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); margin-bottom: 20px;">
                <div style="display: flex; gap: 15px; align-items: center; flex-wrap: wrap;">
                    <div style="flex: 1; min-width: 200px;">
                        <label style="display: block; margin-bottom: 8px; color: #1e293b; font-weight: 500; font-size: 14px;">Filter by Status</label>
                        <asp:DropDownList ID="ddlStatusFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged"
                            style="width: 100%; padding: 10px; border: 1px solid #e5e7eb; border-radius: 8px; font-size: 14px;">
                            <asp:ListItem Value="All" Selected="True">All Orders</asp:ListItem>
                            <asp:ListItem Value="Pending">Pending</asp:ListItem>
                            <asp:ListItem Value="Processing">Processing</asp:ListItem>
                            <asp:ListItem Value="Shipped">Shipped</asp:ListItem>
                            <asp:ListItem Value="Delivered">Delivered</asp:ListItem>
                            <asp:ListItem Value="Cancelled">Cancelled</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div style="padding-top: 28px;">
                        <asp:Label ID="lblOrderCount" runat="server" style="color: #64748b; font-size: 14px;"></asp:Label>
                    </div>
                </div>
            </div>

            <!-- Orders Repeater -->
            <asp:Repeater ID="rptOrders" runat="server" OnItemCommand="rptOrders_ItemCommand">
                <ItemTemplate>
                    <div style="background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); margin-bottom: 20px; overflow: hidden;">
                        
                        <!-- Order Header -->
                        <div style="background: #f8fafc; padding: 20px; border-bottom: 1px solid #e5e7eb;">
                            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px;">
                                
                                <!-- Order ID -->
                                <div>
                                    <div style="font-size: 12px; color: #64748b; margin-bottom: 5px;">ORDER ID</div>
                                    <div style="font-size: 16px; font-weight: 600; color: #1e293b;">
                                        #<%# Eval("OrderID") %>
                                    </div>
                                </div>

                                <!-- Order Date -->
                                <div>
                                    <div style="font-size: 12px; color: #64748b; margin-bottom: 5px;">ORDER DATE</div>
                                    <div style="font-size: 14px; font-weight: 600; color: #1e293b;">
                                        <%# Convert.ToDateTime(Eval("OrderDate")).ToString("MMM dd, yyyy") %>
                                    </div>
                                </div>

                                <!-- Total Amount -->
                                <div>
                                    <div style="font-size: 12px; color: #64748b; margin-bottom: 5px;">TOTAL</div>
                                    <div style="font-size: 18px; font-weight: 700; color: #3b82f6;">
                                        NPR <%# String.Format("{0:N0}", Eval("TotalAmount")) %>
                                    </div>
                                </div>

                                <!-- Order Status -->
                                <div>
                                    <div style="font-size: 12px; color: #64748b; margin-bottom: 5px;">STATUS</div>
                                    <div>
                                        <span style='<%# GetStatusStyle(Eval("OrderStatus").ToString()) %>'>
                                            <%# Eval("OrderStatus") %>
                                        </span>
                                    </div>
                                </div>

                            </div>
                        </div>

                        <!-- Order Details Section -->
                        <div style="padding: 20px;">
                            
                            <!-- Shipping Address -->
                            <div style="display: flex; gap: 10px; margin-bottom: 15px; padding: 15px; background: #f8fafc; border-radius: 8px;">
                                <i class="fas fa-map-marker-alt" style="color: #3b82f6; margin-top: 3px;"></i>
                                <div>
                                    <div style="font-size: 12px; font-weight: 600; color: #64748b; margin-bottom: 5px;">SHIPPING ADDRESS</div>
                                    <div style="font-size: 14px; color: #1e293b;">
                                        <%# Eval("ShippingAddress") ?? "N/A" %>
                                    </div>
                                </div>
                            </div>

                            <!-- Payment Method -->
                            <div style="display: flex; gap: 10px; margin-bottom: 15px; padding: 15px; background: #f8fafc; border-radius: 8px;">
                                <i class="fas fa-credit-card" style="color: #10b981; margin-top: 3px;"></i>
                                <div>
                                    <div style="font-size: 12px; font-weight: 600; color: #64748b; margin-bottom: 5px;">PAYMENT METHOD</div>
                                    <div style="font-size: 14px; color: #1e293b;">
                                        <%# Eval("PaymentMethod") %>
                                    </div>
                                </div>
                            </div>

                            <!-- View Details Button -->
                            <div style="margin-top: 20px; padding-top: 20px; border-top: 1px solid #e5e7eb;">
                                <asp:LinkButton ID="btnViewDetails" runat="server" 
                                    CommandName="ViewDetails" 
                                    CommandArgument='<%# Eval("OrderID") %>'
                                    CausesValidation="false"
                                    style="display: inline-flex; align-items: center; gap: 8px; padding: 10px 20px; background: #3b82f6; color: white; border-radius: 8px; text-decoration: none; font-size: 14px; font-weight: 600; transition: background 0.3s;"
                                    onmouseover="this.style.background='#2563eb'" 
                                    onmouseout="this.style.background='#3b82f6'">
                                    <i class="fas fa-eye"></i> View Order Details
                                </asp:LinkButton>
                            </div>

                        </div>

                    </div>
                </ItemTemplate>
            </asp:Repeater>

        </asp:Panel>

        <!-- Order Details Modal/Panel -->
        <asp:Panel ID="pnlOrderDetails" runat="server" Visible="false" 
            style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 9999; display: flex; align-items: center; justify-content: center; padding: 20px; overflow-y: auto;">
            
            <div style="background: white; border-radius: 12px; max-width: 900px; width: 100%; max-height: 90vh; overflow-y: auto; box-shadow: 0 20px 60px rgba(0,0,0,0.3);">
                
                <!-- Modal Header -->
                <div style="padding: 25px; border-bottom: 1px solid #e5e7eb; display: flex; justify-content: space-between; align-items: center; position: sticky; top: 0; background: white; z-index: 10;">
                    <h2 style="font-size: 24px; font-weight: 700; color: #1e293b; margin: 0;">
                        Order #<asp:Label ID="lblOrderID" runat="server"></asp:Label>
                    </h2>
                    <asp:Button ID="btnCloseDetails" runat="server" Text="✕" OnClick="btnCloseDetails_Click"
                        CausesValidation="false"
                        style="width: 40px; height: 40px; background: #f1f5f9; color: #64748b; border: none; border-radius: 8px; font-size: 20px; cursor: pointer; transition: background 0.3s;"
                        onmouseover="this.style.background='#e2e8f0'" 
                        onmouseout="this.style.background='#f1f5f9'" />
                </div>

                <!-- Modal Body -->
                <div style="padding: 25px;">
                    
                    <!-- Order Info Grid -->
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 30px;">
                        <div style="padding: 15px; background: #f8fafc; border-radius: 8px;">
                            <div style="font-size: 12px; color: #64748b; margin-bottom: 5px;">ORDER DATE</div>
                            <div style="font-size: 14px; font-weight: 600; color: #1e293b;">
                                <asp:Label ID="lblDetailOrderDate" runat="server"></asp:Label>
                            </div>
                        </div>
                        <div style="padding: 15px; background: #f8fafc; border-radius: 8px;">
                            <div style="font-size: 12px; color: #64748b; margin-bottom: 5px;">STATUS</div>
                            <div>
                                <asp:Label ID="lblDetailStatus" runat="server"></asp:Label>
                            </div>
                        </div>
                        <div style="padding: 15px; background: #f8fafc; border-radius: 8px;">
                            <div style="font-size: 12px; color: #64748b; margin-bottom: 5px;">PAYMENT METHOD</div>
                            <div style="font-size: 14px; font-weight: 600; color: #1e293b;">
                                <asp:Label ID="lblDetailPayment" runat="server"></asp:Label>
                            </div>
                        </div>
                    </div>

                    <!-- Shipping Address -->
                    <div style="padding: 20px; background: #f8fafc; border-radius: 8px; margin-bottom: 20px;">
                        <div style="font-size: 14px; font-weight: 600; color: #1e293b; margin-bottom: 10px;">
                            <i class="fas fa-map-marker-alt" style="color: #3b82f6;"></i> Shipping Address
                        </div>
                        <div style="font-size: 14px; color: #64748b;">
                            <asp:Label ID="lblDetailAddress" runat="server"></asp:Label>
                        </div>
                    </div>

                    <!-- Order Items -->
                    <div style="margin-bottom: 20px;">
                        <h3 style="font-size: 18px; font-weight: 600; color: #1e293b; margin-bottom: 15px;">Order Items</h3>
                        
                        <asp:Repeater ID="rptOrderItems" runat="server">
                            <ItemTemplate>
                                <div style="display: flex; gap: 15px; padding: 15px; border: 1px solid #e5e7eb; border-radius: 8px; margin-bottom: 10px;">
                                    
                                    <!-- Product Image Placeholder -->
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

                    <!-- Order Total -->
                    <div style="padding: 20px; background: #f8fafc; border-radius: 8px;">
                        <div style="display: flex; justify-content: space-between; font-size: 20px; font-weight: 700;">
                            <span style="color: #1e293b;">Order Total:</span>
                            <span style="color: #3b82f6;">
                                NPR <asp:Label ID="lblDetailTotal" runat="server"></asp:Label>
                            </span>
                        </div>
                    </div>

                </div>

            </div>

        </asp:Panel>

        <!-- No Orders Panel -->
        <asp:Panel ID="pnlNoOrders" runat="server" Visible="false">
            <div style="background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); padding: 80px 40px; text-align: center;">
                <i class="fas fa-shopping-bag" style="font-size: 100px; color: #cbd5e1; margin-bottom: 25px;"></i>
                <h2 style="font-size: 28px; font-weight: 700; color: #1e293b; margin-bottom: 15px;">No Orders Found</h2>
                <p style="font-size: 16px; color: #64748b; margin-bottom: 30px;">You haven't placed any orders yet.</p>
                <asp:HyperLink ID="lnkStartShopping" runat="server" NavigateUrl="~/Products/Default.aspx"
                    style="display: inline-block; padding: 14px 40px; background: #3b82f6; color: white; border-radius: 8px; text-decoration: none; font-size: 16px; font-weight: 600; transition: background 0.3s;"
                    onmouseover="this.style.background='#2563eb'" 
                    onmouseout="this.style.background='#3b82f6'">
                    <i class="fas fa-shopping-bag"></i> Start Shopping
                </asp:HyperLink>
            </div>
        </asp:Panel>

    </div>

    <!-- Mobile Responsive Styles -->
    <style>
        @media (max-width: 768px) {
            .container > div > div > div > div {
                grid-template-columns: 1fr !important;
            }
        }
    </style>

</asp:Content>
