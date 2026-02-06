using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TechHubWebForms.Models
{
    [Table("Feedback")]
    public class Feedback
    {
        [Key]
        public int FeedbackID { get; set; }

        [Required]
        public int UserID { get; set; }

        public int? OrderID { get; set; }

        [Required]
        [StringLength(100)]
        public string Subject { get; set; }

        [Required]
        [StringLength(2000)]
        public string Message { get; set; }

        [Range(1, 5)]
        public int? Rating { get; set; }

        public DateTime DateSubmitted { get; set; } = DateTime.Now;

        [StringLength(50)]
        public string Status { get; set; } = "Pending";

        // Foreign Keys
        [ForeignKey("UserID")]
        public virtual User User { get; set; }

        [ForeignKey("OrderID")]
        public virtual Order Order { get; set; }
    }
}