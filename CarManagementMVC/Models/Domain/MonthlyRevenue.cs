using System.ComponentModel.DataAnnotations;

namespace CarManagementMVC.Models.Domain
{
    public class MonthlyRevenue
    {
        [Key]
        public int Month { get; set; }
        public int Year { get; set; }
        public decimal Revenue { get; set; }
    }
}
