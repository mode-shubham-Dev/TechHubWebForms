namespace TechHubWebForms.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class InitialCreate : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Cart",
                c => new
                    {
                        CartID = c.Int(nullable: false, identity: true),
                        UserID = c.Int(nullable: false),
                        ProductID = c.Int(nullable: false),
                        Quantity = c.Int(nullable: false),
                        DateAdded = c.DateTime(nullable: false),
                    })
                .PrimaryKey(t => t.CartID)
                .ForeignKey("dbo.Products", t => t.ProductID)
                .ForeignKey("dbo.Users", t => t.UserID, cascadeDelete: true)
                .Index(t => t.UserID)
                .Index(t => t.ProductID);
            
            CreateTable(
                "dbo.Products",
                c => new
                    {
                        ProductID = c.Int(nullable: false, identity: true),
                        Name = c.String(nullable: false, maxLength: 200),
                        Description = c.String(maxLength: 1000),
                        Price = c.Decimal(nullable: false, precision: 18, scale: 2),
                        Brand = c.String(nullable: false, maxLength: 100),
                        StockQuantity = c.Int(nullable: false),
                        CategoryID = c.Int(nullable: false),
                        ImageURL1 = c.String(maxLength: 255),
                        ImageURL2 = c.String(maxLength: 255),
                        ImageURL3 = c.String(maxLength: 255),
                        Specifications = c.String(),
                        IsActive = c.Boolean(nullable: false),
                        DateAdded = c.DateTime(nullable: false),
                    })
                .PrimaryKey(t => t.ProductID)
                .ForeignKey("dbo.Categories", t => t.CategoryID)
                .Index(t => t.CategoryID);
            
            CreateTable(
                "dbo.Categories",
                c => new
                    {
                        CategoryID = c.Int(nullable: false, identity: true),
                        CategoryName = c.String(nullable: false, maxLength: 100),
                        Description = c.String(maxLength: 500),
                        ImageURL = c.String(maxLength: 255),
                        IsActive = c.Boolean(nullable: false),
                        DateCreated = c.DateTime(nullable: false),
                    })
                .PrimaryKey(t => t.CategoryID);
            
            CreateTable(
                "dbo.OrderDetails",
                c => new
                    {
                        OrderDetailID = c.Int(nullable: false, identity: true),
                        OrderID = c.Int(nullable: false),
                        ProductID = c.Int(nullable: false),
                        Quantity = c.Int(nullable: false),
                        UnitPrice = c.Decimal(nullable: false, precision: 18, scale: 2),
                        Subtotal = c.Decimal(nullable: false, precision: 18, scale: 2),
                    })
                .PrimaryKey(t => t.OrderDetailID)
                .ForeignKey("dbo.Orders", t => t.OrderID, cascadeDelete: true)
                .ForeignKey("dbo.Products", t => t.ProductID)
                .Index(t => t.OrderID)
                .Index(t => t.ProductID);
            
            CreateTable(
                "dbo.Orders",
                c => new
                    {
                        OrderID = c.Int(nullable: false, identity: true),
                        UserID = c.Int(nullable: false),
                        TotalAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        OrderStatus = c.String(nullable: false, maxLength: 50),
                        PaymentMethod = c.String(nullable: false, maxLength: 100),
                        ShippingAddress = c.String(maxLength: 500),
                        ContactPhone = c.String(maxLength: 20),
                        OrderDate = c.DateTime(nullable: false),
                        DeliveryDate = c.DateTime(),
                        Notes = c.String(),
                    })
                .PrimaryKey(t => t.OrderID)
                .ForeignKey("dbo.Users", t => t.UserID)
                .Index(t => t.UserID);
            
            CreateTable(
                "dbo.Feedback",
                c => new
                    {
                        FeedbackID = c.Int(nullable: false, identity: true),
                        UserID = c.Int(nullable: false),
                        OrderID = c.Int(),
                        Subject = c.String(nullable: false, maxLength: 100),
                        Message = c.String(nullable: false, maxLength: 2000),
                        Rating = c.Int(),
                        DateSubmitted = c.DateTime(nullable: false),
                        Status = c.String(maxLength: 50),
                    })
                .PrimaryKey(t => t.FeedbackID)
                .ForeignKey("dbo.Orders", t => t.OrderID)
                .ForeignKey("dbo.Users", t => t.UserID)
                .Index(t => t.UserID)
                .Index(t => t.OrderID);
            
            CreateTable(
                "dbo.Users",
                c => new
                    {
                        UserID = c.Int(nullable: false, identity: true),
                        Name = c.String(nullable: false, maxLength: 100),
                        Email = c.String(nullable: false, maxLength: 100),
                        Password = c.String(nullable: false, maxLength: 255),
                        Phone = c.String(maxLength: 20),
                        Address = c.String(maxLength: 500),
                        Role = c.String(nullable: false, maxLength: 20),
                        DateRegistered = c.DateTime(nullable: false),
                        IsActive = c.Boolean(nullable: false),
                    })
                .PrimaryKey(t => t.UserID)
                .Index(t => t.Email, unique: true);
            
            CreateTable(
                "dbo.Ratings",
                c => new
                    {
                        RatingID = c.Int(nullable: false, identity: true),
                        UserID = c.Int(nullable: false),
                        ProductID = c.Int(nullable: false),
                        Stars = c.Int(nullable: false),
                        Review = c.String(maxLength: 1000),
                        DatePosted = c.DateTime(nullable: false),
                    })
                .PrimaryKey(t => t.RatingID)
                .ForeignKey("dbo.Products", t => t.ProductID)
                .ForeignKey("dbo.Users", t => t.UserID)
                .Index(t => t.UserID)
                .Index(t => t.ProductID);
            
            CreateTable(
                "dbo.Wishlist",
                c => new
                    {
                        WishlistID = c.Int(nullable: false, identity: true),
                        UserID = c.Int(nullable: false),
                        ProductID = c.Int(nullable: false),
                        DateAdded = c.DateTime(nullable: false),
                    })
                .PrimaryKey(t => t.WishlistID)
                .ForeignKey("dbo.Products", t => t.ProductID)
                .ForeignKey("dbo.Users", t => t.UserID, cascadeDelete: true)
                .Index(t => t.UserID)
                .Index(t => t.ProductID);
            
            CreateTable(
                "dbo.Coupons",
                c => new
                    {
                        CouponID = c.Int(nullable: false, identity: true),
                        CouponCode = c.String(nullable: false, maxLength: 50),
                        Description = c.String(nullable: false, maxLength: 200),
                        DiscountPercentage = c.Decimal(nullable: false, precision: 18, scale: 2),
                        StartDate = c.DateTime(nullable: false),
                        EndDate = c.DateTime(nullable: false),
                        IsActive = c.Boolean(nullable: false),
                        UsageLimit = c.Int(nullable: false),
                        UsedCount = c.Int(nullable: false),
                    })
                .PrimaryKey(t => t.CouponID)
                .Index(t => t.CouponCode, unique: true);
            
        }
        
        public override void Down()
        {
            DropForeignKey("dbo.Cart", "UserID", "dbo.Users");
            DropForeignKey("dbo.Cart", "ProductID", "dbo.Products");
            DropForeignKey("dbo.OrderDetails", "ProductID", "dbo.Products");
            DropForeignKey("dbo.OrderDetails", "OrderID", "dbo.Orders");
            DropForeignKey("dbo.Orders", "UserID", "dbo.Users");
            DropForeignKey("dbo.Feedback", "UserID", "dbo.Users");
            DropForeignKey("dbo.Wishlist", "UserID", "dbo.Users");
            DropForeignKey("dbo.Wishlist", "ProductID", "dbo.Products");
            DropForeignKey("dbo.Ratings", "UserID", "dbo.Users");
            DropForeignKey("dbo.Ratings", "ProductID", "dbo.Products");
            DropForeignKey("dbo.Feedback", "OrderID", "dbo.Orders");
            DropForeignKey("dbo.Products", "CategoryID", "dbo.Categories");
            DropIndex("dbo.Coupons", new[] { "CouponCode" });
            DropIndex("dbo.Wishlist", new[] { "ProductID" });
            DropIndex("dbo.Wishlist", new[] { "UserID" });
            DropIndex("dbo.Ratings", new[] { "ProductID" });
            DropIndex("dbo.Ratings", new[] { "UserID" });
            DropIndex("dbo.Users", new[] { "Email" });
            DropIndex("dbo.Feedback", new[] { "OrderID" });
            DropIndex("dbo.Feedback", new[] { "UserID" });
            DropIndex("dbo.Orders", new[] { "UserID" });
            DropIndex("dbo.OrderDetails", new[] { "ProductID" });
            DropIndex("dbo.OrderDetails", new[] { "OrderID" });
            DropIndex("dbo.Products", new[] { "CategoryID" });
            DropIndex("dbo.Cart", new[] { "ProductID" });
            DropIndex("dbo.Cart", new[] { "UserID" });
            DropTable("dbo.Coupons");
            DropTable("dbo.Wishlist");
            DropTable("dbo.Ratings");
            DropTable("dbo.Users");
            DropTable("dbo.Feedback");
            DropTable("dbo.Orders");
            DropTable("dbo.OrderDetails");
            DropTable("dbo.Categories");
            DropTable("dbo.Products");
            DropTable("dbo.Cart");
        }
    }
}
