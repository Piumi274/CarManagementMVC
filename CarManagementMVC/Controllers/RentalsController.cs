using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using CarManagementMVC.Data;
using CarManagementMVC.Models.Domain;
using Microsoft.Data.SqlClient;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace CarManagementMVC.Controllers
{
    public class RentalsController : Controller
    {
        private readonly CarManagementDbContext _context;

        public RentalsController(CarManagementDbContext context)
        {
            _context = context;
        }

        // GET: Rentals
        public async Task<IActionResult> Index()
        {
              return _context.Rental != null ? 
                          View(await _context.Rental.ToListAsync()) :
                          Problem("Entity set 'CarManagementDbContext.Rental'  is null.");
        }

        // GET: Rentals/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null || _context.Rental == null)
            {
                return NotFound();
            }

            var rental = await _context.Rental
                .FirstOrDefaultAsync(m => m.Id == id);
            if (rental == null)
            {
                return NotFound();
            }

            return View(rental);
        }

        // GET: Rentals/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: Rentals/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("Id,CustomerId,VehicleId,RentalStartDate,RentalEndDate,TotalCost")] Rental rental)
        {
            if (ModelState.IsValid)
            {
                rental.Id = _context.Rental.Count() + 1;
                _context.Add(rental);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            return View(rental);
        }

        // GET: Rentals/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null || _context.Rental == null)
            {
                return NotFound();
            }

            var rental = await _context.Rental.FindAsync(id);
            if (rental == null)
            {
                return NotFound();
            }
            return View(rental);
        }

        // POST: Rentals/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("Id,CustomerId,VehicleId,RentalStartDate,RentalEndDate,TotalCost")] Rental rental)
        {
            if (id != rental.Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    await Task.Run(() =>
                    {
                        using var connection = new SqlConnection(ConfigHelpers.connectionString);
                    connection.Open();

                        using var command = new SqlCommand("UPDATE Rental SET customerId = @CustomerId, vehicleId = @VehicleId, rentalStartDate = @RentalStartDate,rentalEndDate = @RentalEndDate,totalCost = @TotalCost WHERE Id = @Id;", connection);
                        command.Parameters.AddWithValue("@Id", rental.Id);
                        command.Parameters.AddWithValue("@CustomerId", rental.CustomerId);
                        command.Parameters.AddWithValue("@VehicleId", rental.VehicleId);
                        command.Parameters.AddWithValue("@RentalStartDate", rental.RentalStartDate);
                        command.Parameters.AddWithValue("@RentalEndDate", rental.RentalEndDate);
                        command.Parameters.AddWithValue("@TotalCost", rental.TotalCost);
                        command.ExecuteNonQuery();

                    });
                    //_context.Update(rental);
                    //await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!RentalExists(rental.Id))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            return View(rental);
        }

        // GET: Rentals/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null || _context.Rental == null)
            {
                return NotFound();
            }

            var rental = await _context.Rental
                .FirstOrDefaultAsync(m => m.Id == id);
            if (rental == null)
            {
                return NotFound();
            }

            return View(rental);
        }

        // POST: Rentals/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            if (_context.Rental == null)
            {
                return Problem("Entity set 'CarManagementDbContext.Rental'  is null.");
            }
            var rental = await _context.Rental.FindAsync(id);
            if (rental != null)
            {
                _context.Rental.Remove(rental);
            }
            
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool RentalExists(int id)
        {
          return (_context.Rental?.Any(e => e.Id == id)).GetValueOrDefault();
        }
    }
}
