import model.Category;
import model.Invoice;
import model.Product;
import model.Supplier;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;

import java.util.ArrayList;
import java.util.List;

public class Main {
    private static final SessionFactory ourSessionFactory;

    static {
        try {
            Configuration configuration = new Configuration();
            configuration.configure();

            ourSessionFactory = configuration.buildSessionFactory();
        } catch (Throwable ex) {
            throw new ExceptionInInitializerError(ex);
        }
    }

    public static Session getSession() throws HibernateException {
        return ourSessionFactory.openSession();
    }

    public static void main(final String[] args) throws Exception {
        final Session session = getSession();

        List<Product> products = new ArrayList<>();
        products.add(new Product("Bananas", 500));
        products.add(new Product("Pumpkins", 100));
        products.add(new Product("Coconuts", 3000));

        Supplier supplier = new Supplier("Kraków Speed", "Warszawska 33", "Kraków");

        List<Category> categories = new ArrayList<>();
        categories.add(new Category("Fruit"));
        categories.add(new Category("Vegetable"));
        for (Category category : categories) {
            category.setProduct(products.get(0));
        }

        for (Product product : products) {
            product.getSuppliers().add(supplier);
            product.setSupplier(supplier);
            product.setCategory(categories.get(0));
            supplier.getProducts().add(product);
            supplier.setProduct(product);
        }

        List<Invoice> invoices = new ArrayList<>();
        invoices.add(new Invoice(1));
        invoices.add(new Invoice(5));

        invoices.get(0).setProduct(products.get(0));
        invoices.get(0).getProducts().addAll(products);
        invoices.get(1).setProduct(products.get(2));
        invoices.get(1).getProducts().add(products.get(2));

        try {
        } finally {
            Transaction tx = session.beginTransaction();

            // Add to database new records
            session.save(supplier);
            for (Product product : products) {
                session.save(product);
            }
            for (Category category : categories) {
                session.save(category);
            }
            for (Invoice invoice : invoices) {
                session.save(invoice);
            }

            tx.commit();
            session.close();
        }
    }
}