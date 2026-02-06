using System;
using System.Linq;
using TechHubWebForms.Models;
using System.Security.Cryptography;
using System.Text;

namespace TechHubWebForms.DAL
{
    public class DbSeeder
    {
        public static void Seed(TechHubContext context)
        {
            // Only seed if database is empty
            if (context.Users.Any())
            {
                return; // Database already seeded
            }

            // Helper method to hash passwords
            string HashPassword(string password)
            {
                using (SHA256 sha256 = SHA256.Create())
                {
                    byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                    return BitConverter.ToString(bytes).Replace("-", "").ToLower();
                }
            }

            // 1. SEED USERS
            var users = new[]
            {
                new User
                {
                    Name = "Admin User",
                    Email = "admin@techhub.com",
                    Password = HashPassword("Admin@123"),
                    Phone = "9801234567",
                    Address = "Kathmandu, Nepal",
                    Role = "Admin",
                    DateRegistered = DateTime.Now.AddMonths(-6),
                    IsActive = true
                },
                new User
                {
                    Name = "John Doe",
                    Email = "john@example.com",
                    Password = HashPassword("Test@123"),
                    Phone = "9807654321",
                    Address = "Lalitpur, Nepal",
                    Role = "Customer",
                    DateRegistered = DateTime.Now.AddMonths(-3),
                    IsActive = true
                },
                new User
                {
                    Name = "Jane Smith",
                    Email = "jane@example.com",
                    Password = HashPassword("Test@123"),
                    Phone = "9809876543",
                    Address = "Bhaktapur, Nepal",
                    Role = "Customer",
                    DateRegistered = DateTime.Now.AddMonths(-2),
                    IsActive = true
                }
            };
            context.Users.AddRange(users);
            context.SaveChanges();

            // 2. SEED CATEGORIES
            var categories = new[]
            {
                new Category { CategoryName = "Smartphones", Description = "Latest mobile phones and accessories", ImageURL = "/Content/images/categories/smartphones.jpg", IsActive = true },
                new Category { CategoryName = "Laptops", Description = "High-performance laptops and notebooks", ImageURL = "/Content/images/categories/laptops.jpg", IsActive = true },
                new Category { CategoryName = "Audio", Description = "Headphones, earbuds, and speakers", ImageURL = "/Content/images/categories/audio.jpg", IsActive = true },
                new Category { CategoryName = "Wearables", Description = "Smartwatches and fitness trackers", ImageURL = "/Content/images/categories/wearables.jpg", IsActive = true },
                new Category { CategoryName = "Gaming", Description = "Gaming consoles and accessories", ImageURL = "/Content/images/categories/gaming.jpg", IsActive = true },
                new Category { CategoryName = "Accessories", Description = "Chargers, cables, and cases", ImageURL = "/Content/images/categories/accessories.jpg", IsActive = true }
            };
            context.Categories.AddRange(categories);
            context.SaveChanges();

            // 3. SEED PRODUCTS
            var products = new[]
            {
                // Smartphones
                new Product { Name = "iPhone 15 Pro Max", Description = "Latest flagship iPhone with A17 Pro chip", Price = 164999, Brand = "Apple", StockQuantity = 15, CategoryID = 1, ImageURL1 = "/Content/images/products/iphone15pro.jpg", Specifications = "6.7-inch display, 256GB storage, Titanium design", DateAdded = DateTime.Now.AddDays(-10) },
                new Product { Name = "Samsung Galaxy S24 Ultra", Description = "Premium Android flagship", Price = 149999, Brand = "Samsung", StockQuantity = 12, CategoryID = 1, ImageURL1 = "/Content/images/products/galaxys24.jpg", Specifications = "6.8-inch AMOLED, 12GB RAM, 256GB storage", DateAdded = DateTime.Now.AddDays(-8) },
                new Product { Name = "OnePlus 12", Description = "Flagship killer with Snapdragon 8 Gen 3", Price = 64999, Brand = "OnePlus", StockQuantity = 20, CategoryID = 1, ImageURL1 = "/Content/images/products/oneplus12.jpg", Specifications = "6.7-inch display, 12GB RAM, 256GB storage", DateAdded = DateTime.Now.AddDays(-5) },
                new Product { Name = "Google Pixel 8 Pro", Description = "Google's flagship with AI features", Price = 119999, Brand = "Google", StockQuantity = 10, CategoryID = 1, ImageURL1 = "/Content/images/products/pixel8pro.jpg", Specifications = "6.7-inch display, Tensor G3, 128GB storage", DateAdded = DateTime.Now.AddDays(-3) },

                // Laptops
                new Product { Name = "MacBook Pro 14-inch M3", Description = "Powerful laptop for professionals", Price = 249999, Brand = "Apple", StockQuantity = 8, CategoryID = 2, ImageURL1 = "/Content/images/products/macbookpro14.jpg", Specifications = "14-inch Liquid Retina, M3 chip, 16GB RAM, 512GB SSD", DateAdded = DateTime.Now.AddDays(-12) },
                new Product { Name = "Dell XPS 15", Description = "Premium Windows laptop", Price = 189999, Brand = "Dell", StockQuantity = 6, CategoryID = 2, ImageURL1 = "/Content/images/products/dellxps15.jpg", Specifications = "15.6-inch 4K, Intel i7, 16GB RAM, 512GB SSD", DateAdded = DateTime.Now.AddDays(-7) },
                new Product { Name = "HP Spectre x360", Description = "2-in-1 convertible laptop", Price = 154999, Brand = "HP", StockQuantity = 9, CategoryID = 2, ImageURL1 = "/Content/images/products/hpspectre.jpg", Specifications = "13.5-inch touchscreen, Intel i7, 16GB RAM", DateAdded = DateTime.Now.AddDays(-6) },
                new Product { Name = "ASUS ROG Zephyrus G14", Description = "Compact gaming laptop", Price = 174999, Brand = "ASUS", StockQuantity = 5, CategoryID = 2, ImageURL1 = "/Content/images/products/rogg14.jpg", Specifications = "14-inch QHD, Ryzen 9, RTX 4060, 16GB RAM", DateAdded = DateTime.Now.AddDays(-4) },

                // Audio
                new Product { Name = "Sony WH-1000XM5", Description = "Industry-leading noise cancellation", Price = 39999, Brand = "Sony", StockQuantity = 18, CategoryID = 3, ImageURL1 = "/Content/images/products/sonywh1000xm5.jpg", Specifications = "30hr battery, AI noise cancellation, Premium sound", DateAdded = DateTime.Now.AddDays(-9) },
                new Product { Name = "AirPods Pro 2nd Gen", Description = "Apple's premium wireless earbuds", Price = 29999, Brand = "Apple", StockQuantity = 25, CategoryID = 3, ImageURL1 = "/Content/images/products/airpodspro2.jpg", Specifications = "Active noise cancellation, Spatial audio, 6hr battery", DateAdded = DateTime.Now.AddDays(-11) },
                new Product { Name = "Bose QuietComfort 45", Description = "Premium comfort headphones", Price = 34999, Brand = "Bose", StockQuantity = 14, CategoryID = 3, ImageURL1 = "/Content/images/products/boseqc45.jpg", Specifications = "24hr battery, Noise cancellation, Premium comfort", DateAdded = DateTime.Now.AddDays(-15) },
                new Product { Name = "JBL Charge 5", Description = "Portable Bluetooth speaker", Price = 17999, Brand = "JBL", StockQuantity = 30, CategoryID = 3, ImageURL1 = "/Content/images/products/jblcharge5.jpg", Specifications = "20hr battery, IP67 waterproof, Powerbank feature", DateAdded = DateTime.Now.AddDays(-2) },

                // Wearables
                new Product { Name = "Apple Watch Series 9", Description = "Advanced health and fitness tracking", Price = 54999, Brand = "Apple", StockQuantity = 12, CategoryID = 4, ImageURL1 = "/Content/images/products/applewatch9.jpg", Specifications = "Always-on Retina, ECG, Blood oxygen, GPS", DateAdded = DateTime.Now.AddDays(-13) },
                new Product { Name = "Samsung Galaxy Watch 6", Description = "Comprehensive smartwatch", Price = 42999, Brand = "Samsung", StockQuantity = 16, CategoryID = 4, ImageURL1 = "/Content/images/products/galaxywatch6.jpg", Specifications = "AMOLED display, Health tracking, 40hr battery", DateAdded = DateTime.Now.AddDays(-8) },
                new Product { Name = "Fitbit Charge 6", Description = "Advanced fitness tracker", Price = 14999, Brand = "Fitbit", StockQuantity = 22, CategoryID = 4, ImageURL1 = "/Content/images/products/fitbitcharge6.jpg", Specifications = "7-day battery, Heart rate, Sleep tracking", DateAdded = DateTime.Now.AddDays(-5) },
                new Product { Name = "Garmin Forerunner 265", Description = "GPS running smartwatch", Price = 49999, Brand = "Garmin", StockQuantity = 8, CategoryID = 4, ImageURL1 = "/Content/images/products/garmin265.jpg", Specifications = "AMOLED display, Training metrics, 20-day battery", DateAdded = DateTime.Now.AddDays(-1) },

                // Gaming
                new Product { Name = "PlayStation 5", Description = "Next-gen gaming console", Price = 64999, Brand = "Sony", StockQuantity = 7, CategoryID = 5, ImageURL1 = "/Content/images/products/ps5.jpg", Specifications = "4K gaming, 825GB SSD, Ray tracing", DateAdded = DateTime.Now.AddDays(-14) },
                new Product { Name = "Xbox Series X", Description = "Microsoft's flagship console", Price = 59999, Brand = "Microsoft", StockQuantity = 9, CategoryID = 5, ImageURL1 = "/Content/images/products/xboxseriesx.jpg", Specifications = "4K 120fps, 1TB SSD, Game Pass compatible", DateAdded = DateTime.Now.AddDays(-10) },
                new Product { Name = "Nintendo Switch OLED", Description = "Hybrid gaming console", Price = 42999, Brand = "Nintendo", StockQuantity = 15, CategoryID = 5, ImageURL1 = "/Content/images/products/switcholed.jpg", Specifications = "7-inch OLED, Handheld/Docked modes, 64GB storage", DateAdded = DateTime.Now.AddDays(-6) },
                new Product { Name = "Steam Deck", Description = "Portable PC gaming device", Price = 54999, Brand = "Valve", StockQuantity = 6, CategoryID = 5, ImageURL1 = "/Content/images/products/steamdeck.jpg", Specifications = "7-inch touchscreen, PC games, 512GB SSD", DateAdded = DateTime.Now.AddDays(-3) },

                // Accessories
                new Product { Name = "Anker PowerCore 20000", Description = "High-capacity power bank", Price = 4999, Brand = "Anker", StockQuantity = 50, CategoryID = 6, ImageURL1 = "/Content/images/products/ankerpowercore.jpg", Specifications = "20000mAh, Fast charging, Dual USB ports", DateAdded = DateTime.Now.AddDays(-7) },
                new Product { Name = "Belkin USB-C Cable 2m", Description = "Premium charging cable", Price = 1499, Brand = "Belkin", StockQuantity = 100, CategoryID = 6, ImageURL1 = "/Content/images/products/belkincable.jpg", Specifications = "USB-C to USB-C, 100W power delivery, 2m length", DateAdded = DateTime.Now.AddDays(-4) },
                new Product { Name = "Spigen Phone Case", Description = "Protective phone case", Price = 2499, Brand = "Spigen", StockQuantity = 75, CategoryID = 6, ImageURL1 = "/Content/images/products/spigencase.jpg", Specifications = "Military-grade protection, Slim design, Air cushion", DateAdded = DateTime.Now.AddDays(-9) },
                new Product { Name = "SanDisk 1TB microSD", Description = "High-speed storage card", Price = 8999, Brand = "SanDisk", StockQuantity = 40, CategoryID = 6, ImageURL1 = "/Content/images/products/sandiskmicrosd.jpg", Specifications = "1TB capacity, 170MB/s read speed, A2 rated", DateAdded = DateTime.Now.AddDays(-2) }
            };
            context.Products.AddRange(products);
            context.SaveChanges();
        }
    }
}