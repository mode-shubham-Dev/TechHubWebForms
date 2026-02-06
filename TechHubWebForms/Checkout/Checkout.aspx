<%@ Page Title="Checkout" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Checkout.aspx.cs" Inherits="TechHubWebForms.Checkout.Checkout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="container" style="padding: 40px 20px; max-width: 1400px; margin: 0 auto;">
        
        <!-- Page Header -->
        <div style="margin-bottom: 30px;">
            <h1 style="font-size: 36px; font-weight: 700; color: #1e293b; margin-bottom: 10px;">
                <i class="fas fa-credit-card" style="color: #3b82f6;"></i> Checkout
            </h1>
            <p style="font-size: 18px; color: #64748b;">Complete your order</p>
        </div>

        <!-- Success/Error Message -->
        <asp:Panel ID="pnlMessage" runat="server" Visible="false" style="margin-bottom: 20px;">
            <div id="divMessage" runat="server" style="padding: 15px; border-radius: 8px; font-size: 14px; font-weight: 500;"></div>
        </asp:Panel>

        <!-- Checkout Content -->
        <asp:Panel ID="pnlCheckout" runat="server" Visible="true">
            <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 30px;">
                
                <!-- Left Side - Checkout Form -->
                <div>
                    
                    <!-- Shipping Information -->
                    <div style="background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); padding: 30px; margin-bottom: 20px;">
                        <h2 style="font-size: 24px; font-weight: 700; color: #1e293b; margin-bottom: 20px;">
                            <i class="fas fa-shipping-fast" style="color: #3b82f6;"></i> Shipping Information
                        </h2>

                        <!-- Full Name -->
                        <div style="margin-bottom: 20px;">
                            <label style="display: block; margin-bottom: 8px; color: #1e293b; font-weight: 500;">Full Name <span style="color: #ef4444;">*</span></label>
                            <asp:TextBox ID="txtFullName" runat="server" 
                                CssClass="form-control"
                                placeholder="Enter your full name"
                                style="width: 100%; padding: 12px; border: 1px solid #e5e7eb; border-radius: 8px; font-size: 16px;" />
                            <asp:RequiredFieldValidator ID="rfvFullName" runat="server" 
                                ControlToValidate="txtFullName"
                                ErrorMessage="Full name is required"
                                ForeColor="#ef4444"
                                Display="Dynamic"
                                style="font-size: 14px; margin-top: 5px;" />
                        </div>

                        <!-- Phone Number -->
                        <div style="margin-bottom: 20px;">
                            <label style="display: block; margin-bottom: 8px; color: #1e293b; font-weight: 500;">Phone Number <span style="color: #ef4444;">*</span></label>
                            <asp:TextBox ID="txtPhone" runat="server" 
                                CssClass="form-control"
                                placeholder="Enter your phone number"
                                style="width: 100%; padding: 12px; border: 1px solid #e5e7eb; border-radius: 8px; font-size: 16px;" />
                            <asp:RequiredFieldValidator ID="rfvPhone" runat="server" 
                                ControlToValidate="txtPhone"
                                ErrorMessage="Phone number is required"
                                ForeColor="#ef4444"
                                Display="Dynamic"
                                style="font-size: 14px; margin-top: 5px;" />
                        </div>

                        <!-- Shipping Address -->
                        <div style="margin-bottom: 20px;">
                            <label style="display: block; margin-bottom: 8px; color: #1e293b; font-weight: 500;">Shipping Address <span style="color: #ef4444;">*</span></label>
                            <asp:TextBox ID="txtAddress" runat="server" 
                                TextMode="MultiLine"
                                Rows="3"
                                CssClass="form-control"
                                placeholder="Enter your complete shipping address"
                                style="width: 100%; padding: 12px; border: 1px solid #e5e7eb; border-radius: 8px; font-size: 16px; resize: vertical;" />
                            <asp:RequiredFieldValidator ID="rfvAddress" runat="server" 
                                ControlToValidate="txtAddress"
                                ErrorMessage="Shipping address is required"
                                ForeColor="#ef4444"
                                Display="Dynamic"
                                style="font-size: 14px; margin-top: 5px;" />
                        </div>

                        <!-- Order Notes (Optional) -->
                        <div style="margin-bottom: 0;">
                            <label style="display: block; margin-bottom: 8px; color: #1e293b; font-weight: 500;">Order Notes (Optional)</label>
                            <asp:TextBox ID="txtNotes" runat="server" 
                                TextMode="MultiLine"
                                Rows="2"
                                CssClass="form-control"
                                placeholder="Any special instructions for your order?"
                                style="width: 100%; padding: 12px; border: 1px solid #e5e7eb; border-radius: 8px; font-size: 16px; resize: vertical;" />
                        </div>
                    </div>

                    <!-- Payment Method -->
                    <div style="background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); padding: 30px;">
                        <h2 style="font-size: 24px; font-weight: 700; color: #1e293b; margin-bottom: 20px;">
                            <i class="fas fa-credit-card" style="color: #10b981;"></i> Payment Method
                        </h2>

                        <asp:RadioButtonList ID="rblPaymentMethod" runat="server" 
                            CssClass="payment-methods"
                            style="display: flex; flex-direction: column; gap: 15px;">
                            <asp:ListItem Value="COD" Selected="True">
                                <div style="padding: 15px; border: 2px solid #e5e7eb; border-radius: 8px; cursor: pointer; transition: all 0.3s;">
                                    <div style="display: flex; align-items: center; gap: 12px;">
                                        <i class="fas fa-money-bill-wave" style="font-size: 24px; color: #10b981;"></i>
                                        <div>
                                            <div style="font-weight: 600; color: #1e293b;">Cash on Delivery</div>
                                            <div style="font-size: 14px; color: #64748b;">Pay when you receive your order</div>
                                        </div>
                                    </div>
                                </div>
                            </asp:ListItem>
                            <asp:ListItem Value="Online">
                                <div style="padding: 15px; border: 2px solid #e5e7eb; border-radius: 8px; cursor: pointer; transition: all 0.3s;">
                                    <div style="display: flex; align-items: center; gap: 12px;">
                                        <i class="fas fa-credit-card" style="font-size: 24px; color: #3b82f6;"></i>
                                        <div>
                                            <div style="font-weight: 600; color: #1e293b;">Online Payment</div>
                                            <div style="font-size: 14px; color: #64748b;">Pay securely online (Simulated)</div>
                                        </div>
                                    </div>
                                </div>
                            </asp:ListItem>
                            <asp:ListItem Value="Bank Transfer">
                                <div style="padding: 15px; border: 2px solid #e5e7eb; border-radius: 8px; cursor: pointer; transition: all 0.3s;">
                                    <div style="display: flex; align-items: center; gap: 12px;">
                                        <i class="fas fa-university" style="font-size: 24px; color: #8b5cf6;"></i>
                                        <div>
                                            <div style="font-weight: 600; color: #1e293b;">Bank Transfer</div>
                                            <div style="font-size: 14px; color: #64748b;">Transfer directly to our bank account</div>
                                        </div>
                                    </div>
                                </div>
                            </asp:ListItem>
                        </asp:RadioButtonList>

                        <asp:RequiredFieldValidator ID="rfvPayment" runat="server" 
                            ControlToValidate="rblPaymentMethod"
                            ErrorMessage="Please select a payment method"
                            ForeColor="#ef4444"
                            Display="Dynamic"
                            style="font-size: 14px; margin-top: 10px;" />
                    </div>

                </div>

                <!-- Right Side - Order Summary -->
                <div>
                    <div style="background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); padding: 25px; position: sticky; top: 20px;">
                        
                        <h2 style="font-size: 20px; font-weight: 700; color: #1e293b; margin-bottom: 20px; padding-bottom: 15px; border-bottom: 2px solid #e5e7eb;">
                            Order Summary
                        </h2>

                        <!-- Cart Items -->
                        <div style="margin-bottom: 20px;">
                            <asp:Repeater ID="rptOrderItems" runat="server">
                                <ItemTemplate>
                                    <div style="display: flex; gap: 10px; padding: 10px 0; border-bottom: 1px solid #f1f5f9;">
                                        <div style="width: 60px; height: 60px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 6px; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                                            <i class="fas fa-mobile-alt" style="font-size: 24px; color: rgba(255,255,255,0.5);"></i>
                                        </div>
                                        <div style="flex: 1;">
                                            <div style="font-size: 14px; font-weight: 600; color: #1e293b; margin-bottom: 3px;">
                                                <%# Eval("Product.Name") %>
                                            </div>
                                            <div style="font-size: 12px; color: #64748b;">
                                                Qty: <%# Eval("Quantity") %> × NPR <%# String.Format("{0:N0}", Eval("Product.Price")) %>
                                            </div>
                                        </div>
                                        <div style="font-size: 14px; font-weight: 600; color: #1e293b;">
                                            NPR <%# String.Format("{0:N0}", Convert.ToDecimal(Eval("Product.Price")) * Convert.ToInt32(Eval("Quantity"))) %>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>

                        <!-- Coupon Code -->
                        <div style="margin-bottom: 20px; padding: 15px; background: #f8fafc; border-radius: 8px;">
                            <label style="display: block; margin-bottom: 8px; color: #1e293b; font-weight: 500; font-size: 14px;">Have a Coupon?</label>
                            <div style="display: flex; gap: 10px;">
                                <asp:TextBox ID="txtCouponCode" runat="server" 
                                    placeholder="Enter coupon code"
                                    style="flex: 1; padding: 10px; border: 1px solid #e5e7eb; border-radius: 6px; font-size: 14px;" />
                                <asp:Button ID="btnApplyCoupon" runat="server" Text="Apply" OnClick="btnApplyCoupon_Click"
                                    CausesValidation="false"
                                    style="padding: 10px 20px; background: #3b82f6; color: white; border: none; border-radius: 6px; font-weight: 600; cursor: pointer; transition: background 0.3s;"
                                    onmouseover="this.style.background='#2563eb'" 
                                    onmouseout="this.style.background='#3b82f6'" />
                            </div>
                            <asp:Label ID="lblCouponMessage" runat="server" style="display: block; margin-top: 8px; font-size: 12px;"></asp:Label>
                        </div>

                        <!-- Price Breakdown -->
                        <div style="margin-bottom: 15px;">
                            <div style="display: flex; justify-content: space-between; margin-bottom: 10px; color: #64748b; font-size: 14px;">
                                <span>Subtotal:</span>
                                <span style="font-weight: 600; color: #1e293b;">NPR <asp:Label ID="lblSubtotal" runat="server"></asp:Label></span>
                            </div>
                            <div style="display: flex; justify-content: space-between; margin-bottom: 10px; color: #64748b; font-size: 14px;">
                                <span>Delivery Fee:</span>
                                <span style="font-weight: 600; color: #10b981;"><asp:Label ID="lblDeliveryFee" runat="server">FREE</asp:Label></span>
                            </div>
                            <asp:Panel ID="pnlDiscount" runat="server" Visible="false">
                                <div style="display: flex; justify-content: space-between; margin-bottom: 10px; color: #10b981; font-size: 14px;">
                                    <span>Discount:</span>
                                    <span style="font-weight: 600;">- NPR <asp:Label ID="lblDiscount" runat="server">0</asp:Label></span>
                                </div>
                            </asp:Panel>
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

                        <!-- Place Order Button -->
                        <asp:Button ID="btnPlaceOrder" runat="server" Text="Place Order" OnClick="btnPlaceOrder_Click"
                            style="width: 100%; padding: 16px; background: #10b981; color: white; border: none; border-radius: 8px; font-size: 16px; font-weight: 600; cursor: pointer; margin-bottom: 12px; transition: background 0.3s;"
                            onmouseover="this.style.background='#059669'" 
                            onmouseout="this.style.background='#10b981'" />

                        <!-- Back to Cart -->
                        <asp:HyperLink ID="lnkBackToCart" runat="server" NavigateUrl="~/Cart/Cart.aspx"
                            style="display: block; text-align: center; padding: 12px; color: #64748b; text-decoration: none; font-size: 14px; font-weight: 500;">
                            <i class="fas fa-arrow-left"></i> Back to Cart
                        </asp:HyperLink>

                        <!-- Security Badge -->
                        <div style="margin-top: 20px; padding: 15px; background: #f8fafc; border-radius: 8px; text-align: center;">
                            <i class="fas fa-lock" style="color: #10b981; font-size: 20px; margin-bottom: 8px;"></i>
                            <p style="font-size: 12px; color: #64748b; margin: 0;">Secure Checkout • Safe Payment</p>
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
                <p style="font-size: 16px; color: #64748b; margin-bottom: 30px;">Add some products to your cart before checkout.</p>
                <asp:HyperLink ID="lnkGoShopping" runat="server" NavigateUrl="~/Products/Default.aspx"
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
        @media (max-width: 992px) {
            .container > div > div {
                grid-template-columns: 1fr !important;
            }
        }

        .payment-methods input[type="radio"] {
            margin-right: 10px;
        }

        .payment-methods label {
            cursor: pointer;
            width: 100%;
        }
    </style>

</asp:Content>
