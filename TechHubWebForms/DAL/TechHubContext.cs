using System.Data.Entity;

namespace TechHubWebForms.DAL
{
    public class TechHubContext : DbContext
    {
        // Constructor - specifies connection string name
        public TechHubContext() : base("TechHubConnection")
        {
        }

        // DbSet properties - one for each table
        public DbSet<TechHubWebForms.Models.User> Users { get; set; }
        public DbSet<TechHubWebForms.Models.Category> Categories { get; set; }
        public DbSet<TechHubWebForms.Models.Product> Products { get; set; }

        // ✅ FIX: Fully qualify Cart model to avoid conflict with namespace TechHubWebForms.Cart
        public DbSet<TechHubWebForms.Models.Cart> Carts { get; set; }

        public DbSet<TechHubWebForms.Models.Order> Orders { get; set; }
        public DbSet<TechHubWebForms.Models.OrderDetail> OrderDetails { get; set; }
        public DbSet<TechHubWebForms.Models.Rating> Ratings { get; set; }
        public DbSet<TechHubWebForms.Models.Feedback> Feedbacks { get; set; }
        public DbSet<TechHubWebForms.Models.Wishlist> Wishlists { get; set; }
        public DbSet<TechHubWebForms.Models.Coupon> Coupons { get; set; }

        // Configure database relationships and constraints
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            // User unique email constraint
            modelBuilder.Entity<TechHubWebForms.Models.User>()
                .Property(u => u.Email)
                .IsRequired()
                .HasMaxLength(100);

            modelBuilder.Entity<TechHubWebForms.Models.User>()
                .HasIndex(u => u.Email)
                .IsUnique();

            // Coupon unique code constraint
            modelBuilder.Entity<TechHubWebForms.Models.Coupon>()
                .Property(c => c.CouponCode)
                .IsRequired()
                .HasMaxLength(50);

            modelBuilder.Entity<TechHubWebForms.Models.Coupon>()
                .HasIndex(c => c.CouponCode)
                .IsUnique();

            // Configure relationships with cascade delete behavior

            // Product -> Category (no cascade delete)
            modelBuilder.Entity<TechHubWebForms.Models.Product>()
                .HasRequired(p => p.Category)
                .WithMany(c => c.Products)
                .HasForeignKey(p => p.CategoryID)
                .WillCascadeOnDelete(false);

            // Cart -> User
            modelBuilder.Entity<TechHubWebForms.Models.Cart>()
                .HasRequired(c => c.User)
                .WithMany(u => u.Carts)
                .HasForeignKey(c => c.UserID)
                .WillCascadeOnDelete(true);

            // Cart -> Product
            modelBuilder.Entity<TechHubWebForms.Models.Cart>()
                .HasRequired(c => c.Product)
                .WithMany(p => p.Carts)
                .HasForeignKey(c => c.ProductID)
                .WillCascadeOnDelete(false);

            // Order -> User
            modelBuilder.Entity<TechHubWebForms.Models.Order>()
                .HasRequired(o => o.User)
                .WithMany(u => u.Orders)
                .HasForeignKey(o => o.UserID)
                .WillCascadeOnDelete(false);

            // OrderDetail -> Order
            modelBuilder.Entity<TechHubWebForms.Models.OrderDetail>()
                .HasRequired(od => od.Order)
                .WithMany(o => o.OrderDetails)
                .HasForeignKey(od => od.OrderID)
                .WillCascadeOnDelete(true);

            // OrderDetail -> Product
            modelBuilder.Entity<TechHubWebForms.Models.OrderDetail>()
                .HasRequired(od => od.Product)
                .WithMany(p => p.OrderDetails)
                .HasForeignKey(od => od.ProductID)
                .WillCascadeOnDelete(false);

            // Rating -> User
            modelBuilder.Entity<TechHubWebForms.Models.Rating>()
                .HasRequired(r => r.User)
                .WithMany(u => u.Ratings)
                .HasForeignKey(r => r.UserID)
                .WillCascadeOnDelete(false);

            // Rating -> Product
            modelBuilder.Entity<TechHubWebForms.Models.Rating>()
                .HasRequired(r => r.Product)
                .WithMany(p => p.Ratings)
                .HasForeignKey(r => r.ProductID)
                .WillCascadeOnDelete(false);

            // Feedback -> User
            modelBuilder.Entity<TechHubWebForms.Models.Feedback>()
                .HasRequired(f => f.User)
                .WithMany(u => u.Feedbacks)
                .HasForeignKey(f => f.UserID)
                .WillCascadeOnDelete(false);

            // Feedback -> Order (optional)
            modelBuilder.Entity<TechHubWebForms.Models.Feedback>()
                .HasOptional(f => f.Order)
                .WithMany(o => o.Feedbacks)
                .HasForeignKey(f => f.OrderID)
                .WillCascadeOnDelete(false);

            // Wishlist -> User
            modelBuilder.Entity<TechHubWebForms.Models.Wishlist>()
                .HasRequired(w => w.User)
                .WithMany(u => u.Wishlists)
                .HasForeignKey(w => w.UserID)
                .WillCascadeOnDelete(true);

            // Wishlist -> Product
            modelBuilder.Entity<TechHubWebForms.Models.Wishlist>()
                .HasRequired(w => w.Product)
                .WithMany(p => p.Wishlists)
                .HasForeignKey(w => w.ProductID)
                .WillCascadeOnDelete(false);

            base.OnModelCreating(modelBuilder);
        }
    }
}
