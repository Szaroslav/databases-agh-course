using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JakubSzaredkoEFProducts
{
    internal class Invoice
    {
        public int InvoiceID { get; set; }
        public int Quantity { get; set; }

        public List<Product> Products { get; } = new();

        public Invoice(int quantity)
        {
            this.Quantity = quantity;
        }
    }
}
