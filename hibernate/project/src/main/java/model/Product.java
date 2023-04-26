package model;

import javax.persistence.Entity;

@Entity
public class Product {
    public int ProductID;

    public int getProductID() {
        return ProductID;
    }

    public void setProductID(int productID) {
        ProductID = productID;
    }

    public String ProductName;

    public String getProductName() {
        return ProductName;
    }

    public void setProductName(String productName) {
        ProductName = productName;
    }

    public int UnitsOnStock;

    public int getUnitsOnStock() {
        return UnitsOnStock;
    }

    public void setUnitsOnStock(int unitsOnStock) {
        UnitsOnStock = unitsOnStock;
    }

    public Product() {  }

    public Product(String name, int unitsOnStock) {
        ProductName = name;
        UnitsOnStock = unitsOnStock;
    }
}
