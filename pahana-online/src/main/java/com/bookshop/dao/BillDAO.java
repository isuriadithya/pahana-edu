package com.bookshop.dao;

import com.bookshop.controller.BillController.ItemQuantity;

import com.bookshop.dao.DBConnectionFactory;

import java.sql.*;
import java.util.List;

public class BillDAO {

    /**
     * Save a bill and its items into the database.
     *
     * @param accountNumber Customer account number
     * @param billItems     List of items with itemId and quantity
     * @return generated billId
     * @throws SQLException if something goes wrong
     */
    public int saveBill(int accountNumber, List<ItemQuantity> billItems) throws SQLException {
        int billId = -1;

        String insertBillSQL = "INSERT INTO bills (account_number, bill_date) VALUES (?, NOW())";
        String insertItemSQL = "INSERT INTO bill_items (bill_id, item_id, quantity, price) " +
                               "VALUES (?, ?, ?, (SELECT price FROM items WHERE item_id = ?))";
        String updateStockSQL = "UPDATE items SET quantity = quantity - ? " +
                                "WHERE item_id = ? AND quantity >= ?";

        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement billStmt = conn.prepareStatement(insertBillSQL, Statement.RETURN_GENERATED_KEYS);
             PreparedStatement itemStmt = conn.prepareStatement(insertItemSQL);
             PreparedStatement stockStmt = conn.prepareStatement(updateStockSQL)) {

            conn.setAutoCommit(false); // start transaction

            // 1. Insert bill header
            billStmt.setInt(1, accountNumber);
            billStmt.executeUpdate();

            try (ResultSet rs = billStmt.getGeneratedKeys()) {
                if (rs.next()) {
                    billId = rs.getInt(1);
                } else {
                    throw new SQLException("Failed to create bill record.");
                }
            }

            // 2. Insert bill items + update stock
            for (ItemQuantity bItem : billItems) {
                // Insert into bill_items
                itemStmt.setInt(1, billId);
                itemStmt.setInt(2, bItem.getItemId());
                itemStmt.setInt(3, bItem.getQuantity());
                itemStmt.setInt(4, bItem.getItemId());
                itemStmt.addBatch();

                // Update stock
                stockStmt.setInt(1, bItem.getQuantity());
                stockStmt.setInt(2, bItem.getItemId());
                stockStmt.setInt(3, bItem.getQuantity());
                stockStmt.addBatch();
            }

            itemStmt.executeBatch();
            int[] stockResults = stockStmt.executeBatch();

            // Check stock update success
            for (int r : stockResults) {
                if (r == 0) {
                    conn.rollback();
                    throw new SQLException("Not enough stock for one or more items.");
                }
            }

            conn.commit(); // commit if all good

        } catch (SQLException e) {
            throw new SQLException("Error saving bill: " + e.getMessage(), e);
        }

        return billId;
    }
}
