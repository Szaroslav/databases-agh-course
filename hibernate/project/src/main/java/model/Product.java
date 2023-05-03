package model;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

@Entity
public class Product {
    @Id
    private Long ProductID;
    private String ProductName;
    private int UnitsOnStock;
    @ManyToOne
    @JoinColumn(name = "SupplierID")
    private Supplier supplier;

    public Product() {  }

    public Product(String name, int unitsOnStock, Supplier supplier) {
        ProductName = name;
        UnitsOnStock = unitsOnStock;
        this.supplier = supplier;
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

    public Supplier getSupplier() {
        return supplier;
    }

    public void setSupplier(Supplier supplier) {
        this.supplier = supplier;
    }
}