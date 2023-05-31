import model.Category;
import model.Invoice;
import model.Product;
import model.Supplier;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import java.util.ArrayList;
import java.util.List;

public class MainJpa {
    public static void main(final String[] args) throws Exception {
//        EntityManagerFactory emFactory = Persistence.createEntityManagerFactory("JakubSzaredkoJPA");
//        EntityManager entityManager = emFactory.createEntityManager();
//
//        entityManager.getTransaction().begin();
//
//        List<Product> products = new ArrayList<>();
//        products.add(new Product("Bananas", 500));
//        products.add(new Product("Pumpkins", 100));
//        products.add(new Product("Coconuts", 3000));
//
//        Supplier supplier = new Supplier("Kraków Speed", "Warszawska 33", "Kraków");
//
//        List<Category> categories = new ArrayList<>();
//        categories.add(new Category("Fruit"));
//        categories.add(new Category("Vegetable"));
//        for (Category category : categories) {
//            category.setProduct(products.get(0));
//        }
//
//        for (Product product : products) {
//            product.getSuppliers().add(supplier);
//            product.setSupplier(supplier);
//            product.setCategory(categories.get(0));
//            supplier.getProducts().add(product);
//            supplier.setProduct(product);
//        }
//
//        List<Invoice> invoices = new ArrayList<>();
//        invoices.add(new Invoice(1));
//        invoices.add(new Invoice(5));
//
//        invoices.get(0).setProduct(products.get(0));
//        invoices.get(0).getProducts().addAll(products);
//        invoices.get(1).setProduct(products.get(2));
//        invoices.get(1).getProducts().add(products.get(2));
//
//        // Add to database new records
//        entityManager.persist(supplier);
//        for (Product product : products) {
//            entityManager.persist(product);
//        }
//        for (Category category : categories) {
//            entityManager.persist(category);
//        }
//        for (Invoice invoice : invoices) {
//            entityManager.persist(invoice);
//        }
//
//        entityManager.getTransaction().commit();
//        entityManager.close();
//        emFactory.close();
    }
}