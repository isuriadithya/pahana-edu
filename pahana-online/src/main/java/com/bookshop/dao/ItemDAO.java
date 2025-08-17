package com.bookshop.dao;

import com.bookshop.model.Item;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ItemDAO {

    // CREATE - Add new item
    public void addItem(Item item) {
        String sql = "INSERT INTO items (name, description, price, quantity) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, item.getName());
            ps.setString(2, item.getDescription());
            ps.setDouble(3, item.getPrice());
            ps.setInt(4, item.getQuantity());
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // READ - Get all items
    public List<Item> getAllItems() {
        List<Item> items = new ArrayList<>();
        String sql = "SELECT * FROM items";
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                items.add(new Item(
                    rs.getInt("itemId"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getInt("quantity")
                ));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    // READ - Get item by ID
    public Item getItemById(int itemId) {
        String sql = "SELECT * FROM items WHERE itemId = ?";
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, itemId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new Item(
                    rs.getInt("itemId"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getInt("quantity")
                );
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // UPDATE - Update item details
    public boolean updateItem(Item item) {
        String sql = "UPDATE items SET name = ?, description = ?, price = ?, quantity = ? WHERE itemId = ?";
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, item.getName());
            ps.setString(2, item.getDescription());
            ps.setDouble(3, item.getPrice());
            ps.setInt(4, item.getQuantity());
            ps.setInt(5, item.getItemId());

            int updated = ps.executeUpdate();
            return updated > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // DELETE - Delete item by ID
    public boolean deleteItem(int itemId) {
        String sql = "DELETE FROM items WHERE itemId = ?";
        try (Connection conn = DBConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, itemId);
            int deleted = ps.executeUpdate();
            return deleted > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
