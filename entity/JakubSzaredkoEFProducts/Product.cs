using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JakubSzaredkoEFProducts
{
    internal class Product
    {
        public int ProductID { get; set; }
        public string ProductName { get; set; }
        public int UnitsOnStock { get; set; }
        public ICollection<Supplier> Suppliers { get; set; }

        public Product()
        {
            Suppliers = new List<Supplier>();
        }
    }
}
