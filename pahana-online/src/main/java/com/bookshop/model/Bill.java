package com.bookshop.model;

import java.util.ArrayList;
import java.util.List;

public class Bill {

    private int billId;                  
    private Customer customer;           
    private List<Item> items;             
    private double totalAmount;          
    private String date;                

    
    public Bill(int billId, Customer customer, String date) {
        this.billId = billId;
        this.customer = customer;
        this.date = date;
        this.items = new ArrayList<>();
        this.totalAmount = 0.0;
    }


    public Bill() {
        this.items = new ArrayList<>();
        this.totalAmount = 0.0;
    }

    // Getters and Setters
    
    public int getBillId() {
        return billId;
    }

    public void setBillId(int billId) {
        this.billId = billId;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    public List<Item> getItems() {
        return items;
    }

    public void setItems(List<Item> items) {
        this.items = items;
        calculateTotal();
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    // Add an item to the bill
    public void addItem(Item item) {
        this.items.add(item);
        calculateTotal();
    }

    // Remove an item from the bill
    public void removeItem(Item item) {
        this.items.remove(item);
        calculateTotal();
    }

    // Calculate total bill amount
    private void calculateTotal() {
        double total = 0.0;
        for (Item item : items) {
            total += item.getPrice() * item.getQuantity();
        }
        this.totalAmount = total;
    }

    @Override
    public String toString() {
        return "Bill [Bill ID=" + billId +
               ", Customer=" + customer.getName() +
               ", Date=" + date +
               ", Total Amount=" + totalAmount +
               ", Items Count=" + items.size() + "]";
    }
}

