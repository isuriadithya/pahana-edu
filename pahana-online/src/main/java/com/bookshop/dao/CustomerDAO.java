package com.bookshop.dao;

import com.bookshop.model.Customer;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {

    // CREATE - Add new customer
    public void addCustomer(Customer customer) {
        String sql = "INSERT INTO customer (accountNumber, name, address, telephone, unitsConsumed, billAmount) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customer.getAccountNumber());
            ps.setString(2, customer.getName());
            ps.setString(3, customer.getAddress());
            ps.setString(4, customer.getTelephone());
            ps.setInt(5, customer.getUnitsConsumed());
            ps.setDouble(6, customer.getBillAmount());

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // READ - Get all customers
    public List<Customer> getAllCustomers() {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM customer";
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                customers.add(new Customer(
                    rs.getInt("accountNumber"),
                    rs.getString("name"),
                    rs.getString("address"),
                    rs.getString("telephone"),
                    rs.getInt("unitsConsumed"),
                    rs.getDouble("billAmount")
                ));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customers;
    }

    // READ - Get customer by account number
    public Customer getCustomerByAccountNumber(int accountNumber) {
        String sql = "SELECT * FROM customer WHERE accountNumber = ?";
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, accountNumber);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new Customer(
                    rs.getInt("accountNumber"),
                    rs.getString("name"),
                    rs.getString("address"),
                    rs.getString("telephone"),
                    rs.getInt("unitsConsumed"),
                    rs.getDouble("billAmount")
                );
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // UPDATE - Update customer details
    public boolean updateCustomer(Customer customer) {
        String sql = "UPDATE customer SET name = ?, address = ?, telephone = ?, unitsConsumed = ?, billAmount = ? WHERE accountNumber = ?";
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, customer.getName());
            ps.setString(2, customer.getAddress());
            ps.setString(3, customer.getTelephone());
            ps.setInt(4, customer.getUnitsConsumed());
            ps.setDouble(5, customer.getBillAmount());
            ps.setInt(6, customer.getAccountNumber());

            int updated = ps.executeUpdate();
            return updated > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // DELETE - Remove customer by account number
    public boolean deleteCustomer(int accountNumber) {
        String sql = "DELETE FROM customer WHERE accountNumber = ?";
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, accountNumber);
            int deleted = ps.executeUpdate();
            return deleted > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    
}
