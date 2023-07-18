namespace CarManagementMVC.Models.Domain
{
    public class Vehicle
    {
        public int Id { get; set; }
        public string Make { get; set; }
        public string Model { get; set; }
        public int Year { get; set; }
        public string PlateNumber { get; set; }
        public decimal RentalRatePerDay { get; set; }
        public string Status { get; set; }
    }
}
