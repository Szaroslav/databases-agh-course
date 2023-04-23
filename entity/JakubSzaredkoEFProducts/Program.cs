namespace JakubSzaredkoEFProducts
{
    class Program
    {
        public static void Main(string[] args)
        {
            ProductContext productContext = new ProductContext();

            List<Product> products = new();
            products.Add(new Product("Yogurt"));
            products.Add(new Product("Beer"));
            products.Add(new Product("Hard drugs"));

            Supplier supplier = new Supplier() {
                CompanyName = "Krakow Trans", City = "Czestochowa", Street = "Jasnogorska 333"
            };

            foreach (Product product in products)
            {
                supplier.Products.Add(product);
                product.Suppliers.Add(supplier);

                productContext.Products.Add(product);
            }
            productContext.Suppliers.Add(supplier);

            productContext.SaveChanges();
        }
    }
}
