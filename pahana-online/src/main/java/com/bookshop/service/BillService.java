package com.bookshop.service;

import com.bookshop.controller.BillController.ItemQuantity;
import com.bookshop.dao.BillDAO;

import java.sql.SQLException;
import java.util.List;

public class BillService {

    private static BillService instance;
    private BillDAO billDAO;

    private BillService() {
        billDAO = new BillDAO();
    }

    public static BillService getInstance() {
        if (instance == null) {
            synchronized (BillService.class) {
                if (instance == null) {
                    instance = new BillService();
                }
            }
        }
        return instance;
    }

    /**
     * Save a bill for a customer with given items.
     *
     * @param accountNumber The customer account number
     * @param billItems List of items (itemId, quantity)
     * @return generated billId
     */
    public int saveBill(int accountNumber, List<ItemQuantity> billItems) throws SQLException {
        if (billItems == null || billItems.isEmpty()) {
            throw new IllegalArgumentException("No items provided for the bill.");
        }
        return billDAO.saveBill(accountNumber, billItems);
    }
}
