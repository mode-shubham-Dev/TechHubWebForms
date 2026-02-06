using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TechHubWebForms.Models
{
    [Table("Ratings")]
    public class Rating
    {
        [Key]
        public int RatingID { get; set; }

        [Required]
        public int UserID { get; set; }

        [Required]
        public int ProductID { get; set; }

        [Required]
        [Range(1, 5)]
        public int Stars { get; set; }

        [StringLength(1000)]
        public string Review { get; set; }

        public DateTime DatePosted { get; set; } = DateTime.Now;

        // Foreign Keys
        [ForeignKey("UserID")]
        public virtual User User { get; set; }

        [ForeignKey("ProductID")]
        public virtual Product Product { get; set; }
    }
}