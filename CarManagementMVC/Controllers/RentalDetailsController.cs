using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using CarManagementMVC.Data;
using CarManagementMVC.Models.Domain;

namespace CarManagementMVC.Controllers
{
    public class RentalDetailsController : Controller
    {
        private readonly CarManagementDbContext _context;

        public RentalDetailsController(CarManagementDbContext context)
        {
            _context = context;
        }

        // GET: RentalDetails
        public async Task<IActionResult> Index()
        {
              return _context.RentalDetails != null ? 
                          View(await _context.RentalDetails.ToListAsync()) :
                          Problem("Entity set 'CarManagementDbContext.RentalDetails'  is null.");
        }

        // GET: RentalDetails/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null || _context.RentalDetails == null)
            {
                return NotFound();
            }

            var rentalDetails = await _context.RentalDetails
                .FirstOrDefaultAsync(m => m.RentalId == id);
            if (rentalDetails == null)
            {
                return NotFound();
            }

            return View(rentalDetails);
        }

        // GET: RentalDetails/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: RentalDetails/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("RentalId,CustomerName,Make,Model,RentalStartDate,RentalEndDate")] RentalDetails rentalDetails)
        {
            if (ModelState.IsValid)
            {
                _context.Add(rentalDetails);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            return View(rentalDetails);
        }

        // GET: RentalDetails/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null || _context.RentalDetails == null)
            {
                return NotFound();
            }

            var rentalDetails = await _context.RentalDetails.FindAsync(id);
            if (rentalDetails == null)
            {
                return NotFound();
            }
            return View(rentalDetails);
        }

        // POST: RentalDetails/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("RentalId,CustomerName,Make,Model,RentalStartDate,RentalEndDate")] RentalDetails rentalDetails)
        {
            if (id != rentalDetails.RentalId)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(rentalDetails);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!RentalDetailsExists(rentalDetails.RentalId))
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
            return View(rentalDetails);
        }

        // GET: RentalDetails/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null || _context.RentalDetails == null)
            {
                return NotFound();
            }

            var rentalDetails = await _context.RentalDetails
                .FirstOrDefaultAsync(m => m.RentalId == id);
            if (rentalDetails == null)
            {
                return NotFound();
            }

            return View(rentalDetails);
        }

        // POST: RentalDetails/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            if (_context.RentalDetails == null)
            {
                return Problem("Entity set 'CarManagementDbContext.RentalDetails'  is null.");
            }
            var rentalDetails = await _context.RentalDetails.FindAsync(id);
            if (rentalDetails != null)
            {
                _context.RentalDetails.Remove(rentalDetails);
            }
            
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool RentalDetailsExists(int id)
        {
          return (_context.RentalDetails?.Any(e => e.RentalId == id)).GetValueOrDefault();
        }
    }
}
