package com.bookshop.dao;

import com.bookshop.model.Bill;
import com.bookshop.model.Customer;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BillDAO {

    // CREATE - Add new bill
    public void addBill(Bill bill) {
        String sql = "INSERT INTO bills (billId, customerAccountNumber, date, totalAmount) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bill.getBillId());
            ps.setInt(2, bill.getCustomer().getAccountNumber());
            ps.setString(3, bill.getDate());
            ps.setDouble(4, bill.getTotalAmount());

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // READ - Get all bills
    public List<Bill> getAllBills() {
        List<Bill> bills = new ArrayList<>();
        String sql = "SELECT * FROM bills";
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            CustomerDAO customerDAO = new CustomerDAO();

            while (rs.next()) {
                int billId = rs.getInt("billId");
                int customerAccountNumber = rs.getInt("customerAccountNumber");
                String date = rs.getString("date");
                double totalAmount = rs.getDouble("totalAmount");

                // Get Customer object by account number
                Customer customer = customerDAO.getCustomerByAccountNumber(customerAccountNumber);

                //bills.add(new Bill(billId, customer, date, totalAmount));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bills;
    }

    // READ - Get bill by ID
    public Bill getBillById(int billId) {
        String sql = "SELECT * FROM bills WHERE billId = ?";
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, billId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int customerAccountNumber = rs.getInt("customerAccountNumber");
                String date = rs.getString("date");
                double totalAmount = rs.getDouble("totalAmount");

                CustomerDAO customerDAO = new CustomerDAO();
                Customer customer = customerDAO.getCustomerByAccountNumber(customerAccountNumber);

               // return new Bill(billId, customer, date, totalAmount);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // UPDATE - Update bill
    public boolean updateBill(Bill bill) {
        String sql = "UPDATE bills SET customerAccountNumber = ?, date = ?, totalAmount = ? WHERE billId = ?";
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bill.getCustomer().getAccountNumber());
            ps.setString(2, bill.getDate());
            ps.setDouble(3, bill.getTotalAmount());
            ps.setInt(4, bill.getBillId());

            int updated = ps.executeUpdate();
            return updated > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // DELETE - Delete bill by ID
    public boolean deleteBill(int billId) {
        String sql = "DELETE FROM bills WHERE billId = ?";
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, billId);
            int deleted = ps.executeUpdate();
            return deleted > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
