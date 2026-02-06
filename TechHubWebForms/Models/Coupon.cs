using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TechHubWebForms.Models
{
    [Table("Coupons")]
    public class Coupon
    {
        [Key]
        public int CouponID { get; set; }

        [Required]
        [StringLength(50)]
        [Index(IsUnique = true)]
        public string CouponCode { get; set; }

        [Required]
        [StringLength(200)]
        public string Description { get; set; }

        [Required]
        public decimal DiscountPercentage { get; set; }

        public DateTime StartDate { get; set; }

        public DateTime EndDate { get; set; }

        public bool IsActive { get; set; } = true;

        public int UsageLimit { get; set; }

        public int UsedCount { get; set; } = 0;
    }
}