package com.bookshop.model;

public class Customer {
	
	private int accountNumber;   
    private String name;      
    private String address;      
    private String telephone;   
    private int unitsConsumed;  
    private double billAmount;  
    
    public Customer(int accountNumber, String name, String address, String telephone, int unitsConsumed, double billAmount) {
        this.accountNumber = accountNumber;
        this.name = name;
        this.address = address;
        this.telephone = telephone;
        this.unitsConsumed = unitsConsumed;
        this.billAmount = billAmount;
    }
    

    public Customer() {
    }

    // Getters and Setters
    public int getAccountNumber() {
        return accountNumber;
    }

    public void setAccountNumber(int accountNumber) {
        this.accountNumber = accountNumber;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public int getUnitsConsumed() {
        return unitsConsumed;
    }

    public void setUnitsConsumed(int unitsConsumed) {
        this.unitsConsumed = unitsConsumed;
    }

    public double getBillAmount() {
        return billAmount;
    }

    public void setBillAmount(double billAmount) {
        this.billAmount = billAmount;
    }

    // Method to calculate bill based on units
    public void calculateBill(double ratePerUnit) {
        this.billAmount = unitsConsumed * ratePerUnit;
    }


}
