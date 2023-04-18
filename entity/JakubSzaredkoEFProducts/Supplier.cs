using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace JakubSzaredkoEFProducts
{
    internal class Supplier
    {
        public int SupplierID { get; set; }
        public string CompanyName { get; set; }
        public string? Street { get; set; }
        public string? City { get; set; }

        public Product? Product { get; set; }

        public Supplier()
        {
            //Products = new List<Product>();
        }
    }
}
