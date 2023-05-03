import model.Category;
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

        Supplier supplier = new Supplier("Kraków Speed", "Warszawska 33", "Kraków");

        List<Category> categories = new ArrayList<>();
        categories.add(new Category("Fruit"));
        categories.add(new Category("Vegetable"));

        Product product = new Product("Cucumbers", 10);
        product.setCategory(categories.get(1));

        try {
        } finally {
            Transaction tx = session.beginTransaction();

            session.save(product);

            for (Category category : categories) {
                session.save(category);
            }

            product = session.load(Product.class, 1L);
            product.setCategory(categories.get(0));
            session.save(product);

            product = session.load(Product.class, 2L);
            product.setCategory(categories.get(0));
            session.save(product);

            product = session.load(Product.class, 3L);
            product.setCategory(categories.get(0));
            session.save(product);

            session.save(supplier);

            tx.commit();
            session.close();
        }
    }
}