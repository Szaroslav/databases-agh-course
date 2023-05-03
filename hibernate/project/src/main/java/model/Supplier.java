package model;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
public class Supplier {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long SupplierID;
    private String CompanyName;
    private String Street;
    private String City;
    @ManyToOne
    @JoinColumn(name = "ProductID")
    private Product product;
    @OneToMany(mappedBy = "supplier")
    private final List<Product> products = new ArrayList<>();

    public Supplier() {  }

    public Supplier(String companyName, String street, String city) {
        CompanyName = companyName;
        Street = street;
        City = city;
    }

    public Long getSupplierID() {
        return SupplierID;
    }

    public void setSupplierID(Long supplierID) {
        SupplierID = supplierID;
    }

    public String getCompanyName() {
        return CompanyName;
    }

    public void setCompanyName(String companyName) {
        CompanyName = companyName;
    }

    public String getStreet() {
        return Street;
    }

    public void setStreet(String street) {
        Street = street;
    }

    public String getCity() {
        return City;
    }

    public void setCity(String city) {
        City = city;
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
