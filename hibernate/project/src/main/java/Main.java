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

        for (Product product : products) {
            product.getSuppliers().add(supplier);
            product.setSupplier(supplier);
            supplier.getProducts().add(product);
            supplier.setProduct(product);
        }

        try {
        } finally {
            Transaction tx = session.beginTransaction();

            // Add to database new supplier and products
            session.save(supplier);
            for (Product product : products) {
                session.save(product);
            }

            tx.commit();
            session.close();
        }
    }
}