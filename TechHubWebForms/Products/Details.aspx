<%@ Page Title="Product Details" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Details.aspx.cs" Inherits="TechHubWebForms.Products.Details" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container" style="padding: 40px 20px; max-width: 1400px; margin: 0 auto;">

        <!-- Back Button -->
        <div style="margin-bottom: 20px;">
            <asp:HyperLink ID="lnkBack" runat="server" NavigateUrl="~/Products/Default.aspx"
                style="display: inline-flex; align-items: center; gap: 8px; color: #3b82f6; text-decoration: none; font-weight: 500;">
                <i class="fas fa-arrow-left"></i> Back to Products
            </asp:HyperLink>
        </div>

        <!-- Product Details Section -->
        <asp:Panel ID="pnlProductDetails" runat="server" Visible="true">
            <div style="background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); overflow: hidden; margin-bottom: 30px;">
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 40px; padding: 40px;">

                    <!-- Left Side - Product Image -->
                    <div>
                        <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 12px; height: 500px; display: flex; align-items: center; justify-content: center; position: relative;">
                            <i class="fas fa-mobile-alt" style="font-size: 150px; color: rgba(255,255,255,0.3);"></i>

                            <!-- Stock Badge -->
                            <asp:Panel ID="pnlStockBadge" runat="server"
                                style="position: absolute; top: 20px; right: 20px; padding: 10px 20px; border-radius: 25px; font-size: 14px; font-weight: 600;">
                                <asp:Label ID="lblStockStatus" runat="server"></asp:Label>
                            </asp:Panel>
                        </div>
                    </div>

                    <!-- Right Side - Product Info -->
                    <div>
                        <!-- Brand -->
                        <div style="color: #3b82f6; font-size: 14px; font-weight: 600; text-transform: uppercase; margin-bottom: 10px;">
                            <asp:Label ID="lblBrand" runat="server"></asp:Label>
                        </div>

                        <!-- Product Name -->
                        <h1 style="font-size: 32px; font-weight: 700; color: #1e293b; margin-bottom: 15px;">
                            <asp:Label ID="lblProductName" runat="server"></asp:Label>
                        </h1>

                        <!-- Rating Display -->
                        <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 20px;">
                            <div style="display: flex; gap: 5px;">
                                <asp:Literal ID="litStars" runat="server"></asp:Literal>
                            </div>
                            <span style="color: #64748b; font-size: 14px;">
                                (<asp:Label ID="lblRatingCount" runat="server">0</asp:Label> reviews)
                            </span>
                        </div>

                        <!-- Category -->
                        <div style="margin-bottom: 20px;">
                            <span style="background: #f1f5f9; color: #475569; padding: 8px 16px; border-radius: 20px; font-size: 14px; font-weight: 500;">
                                <i class="fas fa-tag"></i>
                                <asp:Label ID="lblCategory" runat="server"></asp:Label>
                            </span>
                        </div>

                        <!-- Price -->
                        <div style="margin-bottom: 25px;">
                            <span style="font-size: 36px; font-weight: 700; color: #1e293b;">
                                NPR <asp:Label ID="lblPrice" runat="server"></asp:Label>
                            </span>
                        </div>

                        <!-- Description -->
                        <div style="margin-bottom: 25px; padding-bottom: 25px; border-bottom: 1px solid #e5e7eb;">
                            <h3 style="font-size: 18px; font-weight: 600; color: #1e293b; margin-bottom: 10px;">Description</h3>
                            <p style="font-size: 16px; color: #64748b; line-height: 1.6;">
                                <asp:Label ID="lblDescription" runat="server"></asp:Label>
                            </p>
                        </div>

                        <!-- Specifications -->
                        <div style="margin-bottom: 30px;">
                            <h3 style="font-size: 18px; font-weight: 600; color: #1e293b; margin-bottom: 10px;">Specifications</h3>
                            <div style="background: #f8fafc; padding: 15px; border-radius: 8px; font-size: 14px; color: #475569; line-height: 1.8;">
                                <asp:Label ID="lblSpecifications" runat="server"></asp:Label>
                            </div>
                        </div>

                        <!-- Quantity Selector & Add to Cart -->
                        <div style="display: flex; gap: 15px; margin-bottom: 20px;">
                            <div>
                                <label style="display: block; margin-bottom: 8px; color: #1e293b; font-weight: 500; font-size: 14px;">Quantity</label>
                                <asp:TextBox ID="txtQuantity" runat="server" TextMode="Number"
                                    Text="1" min="1"
                                    style="width: 80px; padding: 12px; border: 2px solid #e5e7eb; border-radius: 8px; font-size: 16px; text-align: center;" />
                            </div>
                            <div style="flex: 1; padding-top: 28px;">
                                <asp:Button ID="btnAddToCart" runat="server" Text="Add to Cart" OnClick="btnAddToCart_Click"
                                    CausesValidation="false"
                                    style="width: 100%; padding: 14px; background: #3b82f6; color: white; border: none; border-radius: 8px; font-size: 16px; font-weight: 600; cursor: pointer; transition: background 0.3s;"
                                    onmouseover="this.style.background='#2563eb'"
                                    onmouseout="this.style.background='#3b82f6'" />
                            </div>
                        </div>

                        <!-- Add to Wishlist Button -->
                        <asp:Button ID="btnAddToWishlist" runat="server" Text="♥ Add to Wishlist" OnClick="btnAddToWishlist_Click"
                            CausesValidation="false"
                            style="width: 100%; padding: 12px; background: white; color: #ef4444; border: 2px solid #ef4444; border-radius: 8px; font-size: 16px; font-weight: 600; cursor: pointer; transition: all 0.3s;"
                            onmouseover="this.style.background='#ef4444'; this.style.color='white'"
                            onmouseout="this.style.background='white'; this.style.color='#ef4444'" />

                        <!-- Success/Error Message -->
                        <asp:Panel ID="pnlMessage" runat="server" Visible="false" style="margin-top: 20px;">
                            <div id="divMessage" runat="server" style="padding: 15px; border-radius: 8px; font-size: 14px; font-weight: 500;"></div>
                        </asp:Panel>

                    </div>
                </div>
            </div>
        </asp:Panel>

        <!-- Customer Reviews Section -->
        <div style="background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); padding: 40px; margin-bottom: 30px;">
            <h2 style="font-size: 24px; font-weight: 700; color: #1e293b; margin-bottom: 25px;">
                <i class="fas fa-star" style="color: #fbbf24;"></i> Customer Reviews
            </h2>

            <!-- Add Review Form (Only for logged-in users) -->
            <asp:Panel ID="pnlAddReview" runat="server" Visible="false"
                style="background: #f8fafc; padding: 25px; border-radius: 8px; margin-bottom: 30px;">
                <h3 style="font-size: 18px; font-weight: 600; color: #1e293b; margin-bottom: 20px;">Write a Review</h3>

                <div style="margin-bottom: 15px;">
                    <label style="display: block; margin-bottom: 8px; color: #1e293b; font-weight: 500;">Rating</label>
                    <asp:DropDownList ID="ddlRating" runat="server"
                        style="width: 100%; padding: 10px; border: 1px solid #e5e7eb; border-radius: 8px; font-size: 16px;">
                        <asp:ListItem Value="5">⭐⭐⭐⭐⭐ (5 stars)</asp:ListItem>
                        <asp:ListItem Value="4">⭐⭐⭐⭐ (4 stars)</asp:ListItem>
                        <asp:ListItem Value="3">⭐⭐⭐ (3 stars)</asp:ListItem>
                        <asp:ListItem Value="2">⭐⭐ (2 stars)</asp:ListItem>
                        <asp:ListItem Value="1">⭐ (1 star)</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div style="margin-bottom: 15px;">
                    <label style="display: block; margin-bottom: 8px; color: #1e293b; font-weight: 500;">Your Review</label>
                    <asp:TextBox ID="txtReviewComment" runat="server" TextMode="MultiLine" Rows="4"
                        placeholder="Share your experience with this product..."
                        style="width: 100%; padding: 12px; border: 1px solid #e5e7eb; border-radius: 8px; font-size: 16px; font-family: inherit; resize: vertical;" />
                </div>

                <asp:Button ID="btnSubmitReview" runat="server" Text="Submit Review" OnClick="btnSubmitReview_Click"
                    style="padding: 12px 32px; background: #3b82f6; color: white; border: none; border-radius: 8px; font-size: 16px; font-weight: 600; cursor: pointer;" />
            </asp:Panel>

            <!-- Reviews List (UPDATED) -->
            <asp:Repeater ID="rptReviews" runat="server" OnItemDataBound="rptReviews_ItemDataBound">
                <ItemTemplate>
                    <div style="border-bottom: 1px solid #e5e7eb; padding: 20px 0;">
                        <div style="display: flex; justify-content: space-between; margin-bottom: 10px;">
                            <div>
                                <div style="font-weight: 600; color: #1e293b; margin-bottom: 5px;">
                                    <%# Eval("User.Name") %>
                                </div>
                                <div style="color: #fbbf24; font-size: 14px;">
                                    <asp:Literal ID="litReviewStars" runat="server"></asp:Literal>
                                </div>
                            </div>
                            <div style="color: #94a3b8; font-size: 14px;">
                                <%# Convert.ToDateTime(Eval("DatePosted")).ToString("MMM dd, yyyy") %>
                            </div>
                        </div>
                        <p style="color: #64748b; line-height: 1.6; margin: 0;">
                            <%# Eval("Review") %>
                        </p>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlNoReviews" runat="server" Visible="false"
                style="text-align: center; padding: 40px; color: #94a3b8;">
                <i class="fas fa-comment-slash" style="font-size: 48px; margin-bottom: 15px; display: block;"></i>
                <p style="font-size: 16px;">No reviews yet. Be the first to review this product!</p>
            </asp:Panel>
        </div>

        <!-- Related Products Section -->
        <div style="margin-top: 40px;">
            <h2 style="font-size: 24px; font-weight: 700; color: #1e293b; margin-bottom: 25px;">
                <i class="fas fa-tag"></i> Related Products
            </h2>

            <asp:Repeater ID="rptRelatedProducts" runat="server">
                <HeaderTemplate>
                    <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 20px;">
                </HeaderTemplate>

                <ItemTemplate>
                    <div style="background: white; border-radius: 12px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.1); transition: transform 0.3s;"
                        onmouseover="this.style.transform='translateY(-5px)'"
                        onmouseout="this.style.transform='translateY(0)'">

                        <div style="height: 180px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); display: flex; align-items: center; justify-content: center;">
                            <i class="fas fa-mobile-alt" style="font-size: 60px; color: rgba(255,255,255,0.3);"></i>
                        </div>

                        <div style="padding: 20px;">
                            <div style="color: #3b82f6; font-size: 11px; font-weight: 600; text-transform: uppercase; margin-bottom: 5px;">
                                <%# Eval("Brand") %>
                            </div>
                            <h4 style="font-size: 14px; font-weight: 600; color: #1e293b; margin-bottom: 10px; height: 35px; overflow: hidden;">
                                <%# Eval("Name") %>
                            </h4>
                            <div style="font-size: 18px; font-weight: 700; color: #1e293b; margin-bottom: 15px;">
                                NPR <%# String.Format("{0:N0}", Eval("Price")) %>
                            </div>

                            <asp:HyperLink runat="server"
                                NavigateUrl='<%# "~/Products/Details.aspx?id=" + Eval("ProductID") %>'
                                style="display: block; padding: 8px; background: #3b82f6; color: white; text-align: center; border-radius: 8px; text-decoration: none; font-size: 14px; font-weight: 500;">
                                View Details
                            </asp:HyperLink>
                        </div>
                    </div>
                </ItemTemplate>

                <FooterTemplate>
                    </div>
                </FooterTemplate>
            </asp:Repeater>
        </div>

        <!-- Product Not Found Panel -->
        <asp:Panel ID="pnlNotFound" runat="server" Visible="false"
            style="text-align: center; padding: 80px 20px; background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
            <i class="fas fa-exclamation-triangle" style="font-size: 80px; color: #fbbf24; margin-bottom: 20px;"></i>
            <h2 style="font-size: 28px; font-weight: 700; color: #1e293b; margin-bottom: 10px;">Product Not Found</h2>
            <p style="font-size: 16px; color: #64748b; margin-bottom: 25px;">The product you're looking for doesn't exist or has been removed.</p>
            <asp:HyperLink runat="server" NavigateUrl="~/Products/Default.aspx"
                style="display: inline-block; padding: 12px 32px; background: #3b82f6; color: white; border-radius: 8px; text-decoration: none; font-weight: 600;">
                Browse All Products
            </asp:HyperLink>
        </asp:Panel>

    </div>

    <!-- Mobile Responsive Styles -->
    <style>
        @media (max-width: 768px) {
            .container > div > div > div {
                grid-template-columns: 1fr !important;
                gap: 20px !important;
                padding: 20px !important;
            }
        }
    </style>

</asp:Content>
