package model;

import javax.persistence.Entity;

@Entity
public class Customer extends Company {
    private float discount;

    public Customer() {  }

    public Customer(String companyName, String street, String city, String zipCode, float discount) {
        super(companyName, street, city, zipCode);
        this.discount = discount;
    }

    public float getDiscount() {
        return discount;
    }

    public void setDiscount(float discount) {
        this.discount = discount;
    }
}
