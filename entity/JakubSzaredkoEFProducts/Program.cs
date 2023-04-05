namespace JakubSzaredkoEFProducts
{
    class Program
    {
        public static void Main(string[] args)
        {
            Console.WriteLine("Enter a new product name");
            string productName = Console.ReadLine();

            ProductContext productContext = new ProductContext();
            Product product = new Product { ProductName = productName };
            productContext.Products.Add(product);
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
