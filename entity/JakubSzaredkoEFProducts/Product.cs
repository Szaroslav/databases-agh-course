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
        public List<Supplier> Suppliers { get; } = new();

        public Product()
        {
            ProductName = string.Empty;
        }

        public Product(string productName)
        {
            ProductName = productName;
        }
    }
}
