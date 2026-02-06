using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TechHubWebForms.Models
{
    [Table("Orders")]
    public class Order
    {
        [Key]
        public int OrderID { get; set; }

        [Required]
        public int UserID { get; set; }

        [Required]
        public decimal TotalAmount { get; set; }

        [Required]
        [StringLength(50)]
        public string OrderStatus { get; set; } = "Pending";

        [Required]
        [StringLength(100)]
        public string PaymentMethod { get; set; }

        [StringLength(500)]
        public string ShippingAddress { get; set; }

        [StringLength(20)]
        public string ContactPhone { get; set; }

        public DateTime OrderDate { get; set; } = DateTime.Now;

        public DateTime? DeliveryDate { get; set; }

        public string Notes { get; set; }

        // Foreign Key
        [ForeignKey("UserID")]
        public virtual User User { get; set; }

        // Navigation Properties
        public virtual ICollection<OrderDetail> OrderDetails { get; set; }
        public virtual ICollection<Feedback> Feedbacks { get; set; }

        public Order()
        {
            OrderDetails = new HashSet<OrderDetail>();
            Feedbacks = new HashSet<Feedback>();
        }
    }
}