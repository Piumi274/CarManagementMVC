using Microsoft.EntityFrameworkCore;
using CarManagementMVC.Models.Domain;

namespace CarManagementMVC.Data
{
    public class CarManagementDbContext : DbContext
    {
        public CarManagementDbContext(DbContextOptions<CarManagementDbContext> options) : base(options)
        {
        }
        public DbSet<CarManagementMVC.Models.Domain.Customer>? Customer { get; set; }
        public DbSet<CarManagementMVC.Models.Domain.Vehicle>? Vehicle { get; set; }
        public DbSet<CarManagementMVC.Models.Domain.Rental>? Rental { get; set; }
        public DbSet<CarManagementMVC.Models.Domain.MonthlyRevenue>? MonthlyRevenue { get; set; }
        public DbSet<CarManagementMVC.Models.Domain.RentalDetails>? RentalDetails { get; set; } 
    }
}
