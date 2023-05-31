package model;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
public class Invoice {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long InvoiceID;
    private int quantity;
    @ManyToOne
    @JoinColumn(name = "ProductID")
    private Product product;
    @OneToMany(mappedBy = "invoice", cascade = CascadeType.REFRESH)
    private final List<Product> products = new ArrayList<>();

    public Invoice() {  }

    public Invoice(int quantity) {
        this.quantity = quantity;
    }

    public Long getInvoiceID() {
        return InvoiceID;
    }

    public void setInvoiceID(Long invoiceID) {
        InvoiceID = invoiceID;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public List<Product> getProducts() {
        return products;
    }
}