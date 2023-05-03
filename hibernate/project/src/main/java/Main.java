import model.Product;
import model.Supplier;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;

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
        Supplier supplier = new Supplier("Kraków HomoTrans", "Stefana Batorego 4", "Kraków");
        supplier.setSupplierID(0L);
//        Product product = new Product("Strawberries", 2137, supplier);

        try {
        } finally {
            Transaction tx = session.beginTransaction();

            session.save(supplier);

            // Get all products from Product table, add every available product new created supplier
            List<Product> products = session.createQuery("SELECT a FROM Product a", Product.class).getResultList();
            for (Product p : products) {
                p.setSupplier(supplier);
                supplier.getProducts().add(p);
                session.save(p);
            }

            tx.commit();
            session.close();
        }
    }
}