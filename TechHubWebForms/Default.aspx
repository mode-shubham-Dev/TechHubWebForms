<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="TechHubWebForms._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <!-- MODERN HERO SECTION - FULL WIDTH -->
    <section class="modern-hero">
        <div class="hero-background">
            <div class="gradient-blob blob-1"></div>
            <div class="gradient-blob blob-2"></div>
            <div class="gradient-blob blob-3"></div>
        </div>
        
        <div class="hero-container">
            <div class="hero-left">
                <div class="hero-badge">
                    <i class="fas fa-bolt"></i> New Arrivals Every Week
                </div>
                <h1 class="modern-hero-title">
                    Discover Latest
                    <span class="gradient-text">Tech Products</span>
                    at Best Prices
                </h1>
                <p class="modern-hero-subtitle">
                    From smartphones to laptops, gaming consoles to smartwatches. 
                    Find everything you need for your digital lifestyle with exclusive deals.
                </p>
                
                <div class="hero-stats-inline">
                    <div class="stat-inline">
                        <strong><asp:Label ID="lblProductCount" runat="server" Text="24"></asp:Label>+</strong>
                        <span>Products</span>
                    </div>
                    <div class="stat-inline">
                        <strong><asp:Label ID="lblUserCount" runat="server" Text="3"></asp:Label>+</strong>
                        <span>Customers</span>
                    </div>
                    <div class="stat-inline">
                        <strong>4.8</strong>
                        <span>Rating</span>
                    </div>
                </div>
                
                <div class="hero-buttons-modern">
                    <a href="Products/Default.aspx" class="btn-modern btn-primary-modern">
                        <i class="fas fa-shopping-bag"></i>
                        <span>Start Shopping</span>
                    </a>
                    <a href="About.aspx" class="btn-modern btn-secondary-modern">
                        <i class="fas fa-play-circle"></i>
                        <span>Learn More</span>
                    </a>
                </div>
            </div>
            
            <div class="hero-right">
                <div class="phone-mockup-container">
                    <!-- Floating Phone 1 -->
                    <div class="phone-mockup phone-1">
                        <div class="phone-screen">
                            <i class="fas fa-mobile-alt"></i>
                            <div class="phone-content">
                                <div class="phone-dot"></div>
                                <div class="phone-line"></div>
                                <div class="phone-line short"></div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Floating Phone 2 -->
                    <div class="phone-mockup phone-2">
                        <div class="phone-screen">
                            <i class="fas fa-laptop"></i>
                            <div class="phone-content">
                                <div class="phone-dot"></div>
                                <div class="phone-line"></div>
                                <div class="phone-line short"></div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Decorative Elements -->
                    <div class="float-element element-1">
                        <i class="fas fa-bolt"></i>
                    </div>
                    <div class="float-element element-2">
                        <i class="fas fa-star"></i>
                    </div>
                    <div class="float-element element-3">
                        <i class="fas fa-shopping-cart"></i>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- FEATURED CATEGORIES -->
    <section class="categories-section">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">Shop by Category</h2>
                <p class="section-subtitle">Explore our wide range of tech products</p>
            </div>
            
            <div class="categories-grid">
                <asp:Repeater ID="rptCategories" runat="server">
                    <ItemTemplate>
                        <a href='Products/Default.aspx?category=<%# Eval("CategoryID") %>' class="category-card">
                            <div class="category-icon">
                                <i class='<%# GetCategoryIcon((string)Eval("CategoryName")) %>'></i>
                            </div>
                            <h3><%# Eval("CategoryName") %></h3>
                            <p><%# Eval("Description") %></p>
                            <span class="category-link">Browse <i class="fas fa-arrow-right"></i></span>
                        </a>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </section>

    <!-- FEATURED PRODUCTS -->
    <section class="products-section">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">Featured Products</h2>
                <p class="section-subtitle">Handpicked deals just for you</p>
            </div>

            <div class="products-grid">
                <asp:Repeater ID="rptFeaturedProducts" runat="server">
                    <ItemTemplate>
                        <div class="product-card">
                            <div class="product-image">
                                <div class="product-badge">New</div>
                                <div class="product-image-placeholder">
                                    <i class="fas fa-mobile-alt"></i>
                                </div>
                            </div>
                            <div class="product-info">
                                <div class="product-brand"><%# Eval("Brand") %></div>
                                <h3 class="product-name"><%# Eval("Name") %></h3>
                                <div class="product-rating">
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star-half-alt"></i>
                                    <span>(4.5)</span>
                                </div>
                                <div class="product-footer">
                                    <div class="product-price">
                                        <span class="price">NPR <%# String.Format("{0:N0}", Eval("Price")) %></span>
                                    </div>
                                    <a href='Products/Details.aspx?id=<%# Eval("ProductID") %>' class="btn-view">
                                        View Details
                                    </a>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <div class="text-center" style="margin-top: 40px;">
                <a href="Products/Default.aspx" class="btn-primary-custom btn-lg">
                    View All Products <i class="fas fa-arrow-right"></i>
                </a>
            </div>
        </div>
    </section>

    <!-- WHY CHOOSE US -->
    <section class="features-section">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">Why Choose TechHub?</h2>
                <p class="section-subtitle">Your trusted tech partner</p>
            </div>

            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-shipping-fast"></i>
                    </div>
                    <h3>Fast Delivery</h3>
                    <p>Get your products delivered within 2-3 business days across Nepal</p>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <h3>Secure Payment</h3>
                    <p>100% secure payment methods with buyer protection guarantee</p>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-undo"></i>
                    </div>
                    <h3>Easy Returns</h3>
                    <p>7-day return policy on all products with hassle-free process</p>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-headset"></i>
                    </div>
                    <h3>24/7 Support</h3>
                    <p>Our customer support team is always ready to help you</p>
                </div>
            </div>
        </div>
    </section>

    <!-- NEWSLETTER SECTION -->
    <section class="newsletter-section">
        <div class="container">
            <div class="newsletter-content">
                <div class="newsletter-text">
                    <h2>Stay Updated with Latest Tech</h2>
                    <p>Subscribe to our newsletter and get exclusive deals delivered to your inbox</p>
                </div>
                <div class="newsletter-form">
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="newsletter-input" placeholder="Enter your email address"></asp:TextBox>
                    <asp:Button ID="btnSubscribe" runat="server" Text="Subscribe" CssClass="btn-primary-custom" OnClick="btnSubscribe_Click" />
                </div>
            </div>
        </div>
    </section>

</asp:Content>