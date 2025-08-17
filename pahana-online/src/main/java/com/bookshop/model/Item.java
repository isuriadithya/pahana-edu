package com.bookshop.model;

public class Item {

	  private int itemId;        
	    private String name;        
	    private String description;  
	    private double price;        
	    private int quantity;        

	   
	    public Item(int itemId, String name, String description, double price, int quantity) {
	        this.itemId = itemId;
	        this.name = name;
	        this.description = description;
	        this.price = price;
	        this.quantity = quantity;
	    }
	    

	    public Item() {
	    }

	    // Getters and Setters
	    public int getItemId() {
	        return itemId;
	    }

	    public void setItemId(int itemId) {
	        this.itemId = itemId;
	    }

	    public String getName() {
	        return name;
	    }

	    public void setName(String name) {
	        this.name = name;
	    }

	    public String getDescription() {
	        return description;
	    }

	    public void setDescription(String description) {
	        this.description = description;
	    }

	    public double getPrice() {
	        return price;
	    }

	    public void setPrice(double price) {
	        this.price = price;
	    }

	    public int getQuantity() {
	        return quantity;
	    }

	    public void setQuantity(int quantity) {
	        this.quantity = quantity;
	    }

	    // Method to calculate total value of this item in stock
	    public double getTotalValue() {
	        return price * quantity;
	    }
}
