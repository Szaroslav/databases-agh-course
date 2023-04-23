namespace JakubSzaredkoEFProducts
{
    class Program
    {
        public static void Main(string[] args)
        {
            ProductContext productContext = new ProductContext();

            List<Product> products = new();
            products.Add(new Product("Yogurt", 2137));
            products.Add(new Product("Beer", 50));
            products.Add(new Product("Hard drugs", 3));

            List<Invoice> invoices = new();
            invoices.Add(new Invoice(1));
            invoices.Add(new Invoice(4));

            Supplier supplier = new Supplier() {
                CompanyName = "Krakow Trans", City = "Czestochowa", Street = "Jasnogorska 333"
            };

            products[0].Invoices.Add(invoices[0]);
            products[1].Invoices.Add(invoices[0]);
            products[1].Invoices.Add(invoices[1]);
            products[2].Invoices.Add(invoices[1]);

            invoices[0].Products.Add(products[0]);
            invoices[0].Products.Add(products[1]);
            invoices[1].Products.Add(products[1]);
            invoices[1].Products.Add(products[2]);

            foreach (Product product in products)
            {
                supplier.Products.Add(product);
                product.Suppliers.Add(supplier);

                productContext.Products.Add(product);
            }
            foreach (Invoice invoice in invoices)
            {
                productContext.Invoices.Add(invoice);
            }
            productContext.Suppliers.Add(supplier);
            
            productContext.SaveChanges();
        }
    }
}
