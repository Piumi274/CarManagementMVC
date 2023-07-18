using System.ComponentModel.DataAnnotations;

namespace CarManagementMVC.Models.Domain
{
    public class RentalDetails
    {
        [Key]
        public int RentalId { get; set; }
        public string CustomerName { get; set; }
        public string Make { get; set; }
        public string Model { get; set; }
        public DateTime RentalStartDate { get; set; }
        public DateTime RentalEndDate { get; set; }
    }
}
