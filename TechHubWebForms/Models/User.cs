using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TechHubWebForms.Models
{
    [Table("Users")]
    public class User
    {
        [Key]
        public int UserID { get; set; }

        [Required]
        [StringLength(100)]
        public string Name { get; set; }

        [Required]
        [StringLength(100)]
        [Index(IsUnique = true)]
        public string Email { get; set; }

        [Required]
        [StringLength(255)]
        public string Password { get; set; }

        [StringLength(20)]
        public string Phone { get; set; }

        [StringLength(500)]
        public string Address { get; set; }

        [Required]
        [StringLength(20)]
        public string Role { get; set; } = "Customer";

        public DateTime DateRegistered { get; set; } = DateTime.Now;

        public bool IsActive { get; set; } = true;

        public virtual ICollection<Cart> Carts { get; set; }
        public virtual ICollection<Order> Orders { get; set; }
        public virtual ICollection<Rating> Ratings { get; set; }
        public virtual ICollection<Feedback> Feedbacks { get; set; }
        public virtual ICollection<Wishlist> Wishlists { get; set; }

        public User()
        {
            Carts = new HashSet<Cart>();
            Orders = new HashSet<Order>();
            Ratings = new HashSet<Rating>();
            Feedbacks = new HashSet<Feedback>();
            Wishlists = new HashSet<Wishlist>();
        }
    }
}