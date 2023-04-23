using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JakubSzaredkoEFProducts
{
    internal class Customer : Company
    {
        public float Discount;
    }
}
