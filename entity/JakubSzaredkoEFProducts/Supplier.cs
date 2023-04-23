using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace JakubSzaredkoEFProducts
{
    internal class Supplier : Company
    {
        public string BankAccountNumber;
        public List<Product> Products { get; } = new();
    }
}
