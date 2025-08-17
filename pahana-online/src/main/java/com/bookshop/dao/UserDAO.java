package com.bookshop.dao;

import com.bookshop.model.UserModel;
import java.sql.*;


public class UserDAO {

//    // CREATE - Add new user
//    public void addUser(UserModel user) {
//        String sql = "INSERT INTO users (username, password, role) VALUES (?, ?, ?)";
//        try (Connection conn = DBConnectionFactory.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setString(1, user.getUsername());
//            ps.setString(2, user.getPassword());
//            ps.setString(3, user.getRole());
//            ps.executeUpdate();
//
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//    }
//
//    // READ - Get all users
//    public List<UserModel> getAllUsers() {
//        List<UserModel> users = new ArrayList<>();
//        String sql = "SELECT * FROM users";
//        try (Connection conn = DBConnectionFactory.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql);
//             ResultSet rs = ps.executeQuery()) {
//
//            while (rs.next()) {
//                int id = rs.getInt("userId");
//                String username = rs.getString("username");
//                String password = rs.getString("password");
//                String role = rs.getString("role");
//                users.add(new UserModel(id, username, password, role));
//            }
//
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return users;
//    }
//
//    // READ - Get user by ID
//    public UserModel getUserById(int userId) {
//        String sql = "SELECT * FROM users WHERE userId = ?";
//        try (Connection conn = DBConnectionFactory.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, userId);
//            ResultSet rs = ps.executeQuery();
//
//            if (rs.next()) {
//                return new UserModel(
//                    rs.getInt("userId"),
//                    rs.getString("username"),
//                    rs.getString("password"),
//                    rs.getString("role")
//                );
//            }
//
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return null;
//    }
//
//    // UPDATE - Update user info
//    public boolean updateUser(UserModel user) {
//        String sql = "UPDATE users SET username = ?, password = ?, role = ? WHERE userId = ?";
//        try (Connection conn = DBConnectionFactory.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setString(1, user.getUsername());
//            ps.setString(2, user.getPassword());
//            ps.setString(3, user.getRole());
//            ps.setInt(4, user.getUserId());
//
//            int updated = ps.executeUpdate();
//            return updated > 0;
//
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return false;
//    }
//
//    // DELETE - Delete user by ID
//    public boolean deleteUser(int userId) {
//        String sql = "DELETE FROM users WHERE userId = ?";
//        try (Connection conn = DBConnectionFactory.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, userId);
//            int deleted = ps.executeUpdate();
//            return deleted > 0;
//
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return false;
//    }
	
	public UserModel getUserByUsername(String username) {
        String query = "SELECT * FROM Users WHERE username = ?";
        try (Connection con = DBConnectionFactory.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new UserModel(
                        rs.getInt("userId"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("role")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null; // user not found
    }
}
