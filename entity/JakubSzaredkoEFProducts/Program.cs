namespace JakubSzaredkoEFProducts
{
    class Program
    {
        public static void Main(string[] args)
        {
            ProductContext productContext = new ProductContext();

            Console.WriteLine("Enter a new supplier [company name;street;city]");
            string[] supplierData = Console.ReadLine().Split(';');

            Supplier supplier = new Supplier {
                CompanyName = supplierData[0], Street = supplierData[1], City = supplierData[2]
            };

            Console.WriteLine("Enter a new product name");
            string productName = Console.ReadLine();
            
            Product product = new Product { ProductName = productName };
            productContext.Products.Add(product);

            supplier.Products.Add(product);
            productContext.Suppliers.Add(supplier);

            productContext.SaveChanges();

            Console.WriteLine("\nList of all products stored in the database:");

            IQueryable<string> query = from prod in productContext.Products select prod.ProductName;
            foreach (string pName in query)
            {
                Console.WriteLine(pName);
            }
        }
    }
}
