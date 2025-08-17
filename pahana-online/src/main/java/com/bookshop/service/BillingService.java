package com.bookshop.service;
import com.bookshop.model.Customer;

public class BillingService {
    private static BillingService instance;

    private BillingService() {}

    public static BillingService getInstance() {
        if (instance == null) {
            synchronized (BillingService.class) {
                if (instance == null) {
                    instance = new BillingService();
                }
            }
        }
        return instance;
    }

    // Simple rule: Rs. 50 per unit
    public double calculateBill(Customer customer) {
        double billAmount = customer.getUnitsConsumed() * 50.0;
        customer.setBillAmount(billAmount);
        return billAmount;
    }
}
