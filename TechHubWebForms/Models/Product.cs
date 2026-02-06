using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TechHubWebForms.Models
{
    [Table("Products")]
    public class Product
    {
        [Key]
        public int ProductID { get; set; }

        [Required]
        [StringLength(200)]
        public string Name { get; set; }

        [StringLength(1000)]
        public string Description { get; set; }

        public decimal Price { get; set; }

        [Required]
        [StringLength(100)]
        public string Brand { get; set; }

        public int StockQuantity { get; set; }

        [Required]
        public int CategoryID { get; set; }

        [StringLength(255)]
        public string ImageURL1 { get; set; }

        [StringLength(255)]
        public string ImageURL2 { get; set; }

        [StringLength(255)]
        public string ImageURL3 { get; set; }

        public string Specifications { get; set; }

        public bool IsActive { get; set; } = true;

        public DateTime DateAdded { get; set; } = DateTime.Now;

        // Foreign Key
        [ForeignKey("CategoryID")]
        public virtual Category Category { get; set; }

        // Navigation Properties
        public virtual ICollection<Cart> Carts { get; set; }
        public virtual ICollection<OrderDetail> OrderDetails { get; set; }
        public virtual ICollection<Rating> Ratings { get; set; }
        public virtual ICollection<Wishlist> Wishlists { get; set; }

        public Product()
        {
            Carts = new HashSet<Cart>();
            OrderDetails = new HashSet<OrderDetail>();
            Ratings = new HashSet<Rating>();
            Wishlists = new HashSet<Wishlist>();
        }
    }
}