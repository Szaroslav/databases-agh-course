package model;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long ProductID;
    private String ProductName;
    private int UnitsOnStock;

    @OneToMany(mappedBy = "product")
    private final List<Supplier> suppliers = new ArrayList<>();

    public Product() {  }

    public Product(String name, int unitsOnStock) {
        ProductName = name;
        UnitsOnStock = unitsOnStock;
    }

    public Long getProductID() {
        return ProductID;
    }

    public void setProductID(Long productID) {
        ProductID = productID;
    }

    public String getProductName() {
        return ProductName;
    }

    public void setProductName(String productName) {
        ProductName = productName;
    }

    public int getUnitsOnStock() {
        return UnitsOnStock;
    }

    public void setUnitsOnStock(int unitsOnStock) {
        UnitsOnStock = unitsOnStock;
    }

    public List<Supplier> getSuppliers() {
        return suppliers;
    }
}