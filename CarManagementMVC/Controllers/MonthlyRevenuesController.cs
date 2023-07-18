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
    public class MonthlyRevenuesController : Controller
    {
        private readonly CarManagementDbContext _context;

        public MonthlyRevenuesController(CarManagementDbContext context)
        {
            _context = context;
        }

        // GET: MonthlyRevenues
        public async Task<IActionResult> Index()
        {
              return _context.MonthlyRevenue != null ? 
                          View(await _context.MonthlyRevenue.ToListAsync()) :
                          Problem("Entity set 'CarManagementDbContext.MonthlyRevenue'  is null.");
        }

        // GET: MonthlyRevenues/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null || _context.MonthlyRevenue == null)
            {
                return NotFound();
            }

            var monthlyRevenue = await _context.MonthlyRevenue
                .FirstOrDefaultAsync(m => m.Month == id);
            if (monthlyRevenue == null)
            {
                return NotFound();
            }

            return View(monthlyRevenue);
        }

        // GET: MonthlyRevenues/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: MonthlyRevenues/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("Month,Year,Revenue")] MonthlyRevenue monthlyRevenue)
        {
            if (ModelState.IsValid)
            {
                _context.Add(monthlyRevenue);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            return View(monthlyRevenue);
        }

        // GET: MonthlyRevenues/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null || _context.MonthlyRevenue == null)
            {
                return NotFound();
            }

            var monthlyRevenue = await _context.MonthlyRevenue.FindAsync(id);
            if (monthlyRevenue == null)
            {
                return NotFound();
            }
            return View(monthlyRevenue);
        }

        // POST: MonthlyRevenues/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("Month,Year,Revenue")] MonthlyRevenue monthlyRevenue)
        {
            if (id != monthlyRevenue.Month)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(monthlyRevenue);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!MonthlyRevenueExists(monthlyRevenue.Month))
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
            return View(monthlyRevenue);
        }

        // GET: MonthlyRevenues/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null || _context.MonthlyRevenue == null)
            {
                return NotFound();
            }

            var monthlyRevenue = await _context.MonthlyRevenue
                .FirstOrDefaultAsync(m => m.Month == id);
            if (monthlyRevenue == null)
            {
                return NotFound();
            }

            return View(monthlyRevenue);
        }

        // POST: MonthlyRevenues/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            if (_context.MonthlyRevenue == null)
            {
                return Problem("Entity set 'CarManagementDbContext.MonthlyRevenue'  is null.");
            }
            var monthlyRevenue = await _context.MonthlyRevenue.FindAsync(id);
            if (monthlyRevenue != null)
            {
                _context.MonthlyRevenue.Remove(monthlyRevenue);
            }
            
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool MonthlyRevenueExists(int id)
        {
          return (_context.MonthlyRevenue?.Any(e => e.Month == id)).GetValueOrDefault();
        }
    }
}
