package com.bookshop.servlet;

import com.bookshop.dao.DBConnectionFactory;
import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/SaveBillServlet")
public class SaveBillServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        JSONObject jsonResponse = new JSONObject();

        try {
            // Read JSON body
            StringBuilder sb = new StringBuilder();
            BufferedReader reader = request.getReader();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
            JSONObject json = new JSONObject(sb.toString());

            int accountNumber = json.getInt("accountNumber");
            JSONArray billItems = json.getJSONArray("billItems");

            try (Connection conn = DBConnectionFactory.getConnection()) {
                conn.setAutoCommit(false);

                // Insert into Bill table
                String insertBill = "INSERT INTO Bill (accountNumber, totalAmount) VALUES (?, ?)";
                double totalAmount = 0;
                for (int i = 0; i < billItems.length(); i++) {
                    JSONObject item = billItems.getJSONObject(i);
                    totalAmount += item.getDouble("price") * item.getInt("quantity");
                }
                double tax = totalAmount * 0.10;
                double grandTotal = totalAmount + tax;

                int billId = 0;
                try (PreparedStatement ps = conn.prepareStatement(insertBill, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setInt(1, accountNumber);
                    ps.setDouble(2, grandTotal);
                    ps.executeUpdate();
                    ResultSet rs = ps.getGeneratedKeys();
                    if (rs.next()) {
                        billId = rs.getInt(1);
                    }
                }

                // Insert into Bill_Items table
                String insertItem = "INSERT INTO Bill_Items (billId, itemId, quantity, price) VALUES (?, ?, ?, ?)";
                try (PreparedStatement psItem = conn.prepareStatement(insertItem)) {
                    for (int i = 0; i < billItems.length(); i++) {
                        JSONObject item = billItems.getJSONObject(i);
                        psItem.setInt(1, billId);
                        psItem.setInt(2, item.getInt("itemId"));
                        psItem.setInt(3, item.getInt("quantity"));
                        psItem.setDouble(4, item.getDouble("price"));
                        psItem.addBatch();
                    }
                    psItem.executeBatch();
                }

                conn.commit();
                jsonResponse.put("success", true);
                jsonResponse.put("billId", billId);

            } catch (SQLException e) {
                // If a database error occurs, rollback the transaction and report the error
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // Set 500 status code
                e.printStackTrace();
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Database error: " + e.getMessage());
            }

        } catch (Exception e) {
            // If any other error occurs (e.g., JSON parsing), report it
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // Set 400 status code
            e.printStackTrace();
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Request error: " + e.getMessage());
        } finally {
            // Ensure the JSON response is written to the output stream
            out.print(jsonResponse.toString());
            out.flush();
        }
    }
}