package model;

import javax.persistence.*;

@MappedSuperclass
public class Company {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long CompanyID;
    private String companyName;
    @Embedded
    private Address address;

    public Company() {  }
    public Company(String companyName, String street, String city, String zipCode) {
        this.companyName = companyName;
        address = new Address(street, city, zipCode);
    }

    public Long getCompanyID() {
        return CompanyID;
    }

    public void setCompanyID(Long companyID) {
        CompanyID = companyID;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public Address getAddress() {
        return address;
    }

    public void setAddress(Address address) {
        this.address = address;
    }
}
