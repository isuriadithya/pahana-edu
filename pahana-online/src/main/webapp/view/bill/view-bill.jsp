<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.bookshop.dao.DBConnectionFactory" %>
<%@ page import="java.time.LocalDate, java.time.format.DateTimeFormatter" %>
<%@ page import="com.bookshop.model.UserModel" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>View Bills - Pahana Edu Bookshop</title>
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
<link rel="stylesheet" href="billing-style.css">
<style>
    .bills-table {
        width: 100%;
        border-collapse: collapse;
        background: white;
        border-radius: 10px;
        overflow: hidden;
        box-shadow: 0 4px 20px rgba(0,0,0,0.1);
    }
    
    .bills-table th {
        background: linear-gradient(135deg, #667eea, #764ba2);
        color: white;
        padding: 15px;
        text-align: left;
        font-weight: 600;
    }
    
    .bills-table td {
        padding: 12px 15px;
        border-bottom: 1px solid #eee;
        color: #555;
    }
    
    .bills-table tbody tr:hover {
        background-color: rgba(102, 126, 234, 0.05);
    }
    
    .status-badge {
        padding: 4px 12px;
        border-radius: 20px;
        font-size: 0.8rem;
        font-weight: 600;
        text-transform: uppercase;
    }
    
    .status-pending {
        background: #fff3cd;
        color: #856404;
    }
    
    .status-paid {
        background: #d1edff;
        color: #0c5460;
    }
    
    .action-btn {
        padding: 6px 12px;
        margin: 2px;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        font-size: 0.85rem;
        text-decoration: none;
        display: inline-block;
        transition: all 0.3s ease;
    }
    
    .btn-print {
        background: linear-gradient(135deg, #28a745, #20c997);
        color: white;
    }
    
    .btn-view {
        background: linear-gradient(135deg, #007bff, #0056b3);
        color: white;
    }
    
    .action-btn:hover {
        transform: translateY(-1px);
        box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        color: white;
        text-decoration: none;
    }
</style>
</head>
<body>

<%
    // Generate current date
    LocalDate today = LocalDate.now();
    String formattedDate = today.format(DateTimeFormatter.ofPattern("MMMM dd, yyyy"));
    int year = today.getYear();

    // Get user from session
    UserModel user = (UserModel) session.getAttribute("username");
    String username = (user == null) ? "Admin User" : user.getUsername();

    // Get all bills
    List<Map<String, Object>> bills = new ArrayList<>();
    
    try (Connection conn = DBConnectionFactory.getConnection()) {
        String billsQuery = """
            SELECT b.billId, b.billDate, b.totalAmount, b.status,
                   c.name as customerName
            FROM Bills b 
            LEFT JOIN Customer c ON b.accountNumber = c.accountNumber 
            ORDER BY b.billDate DESC
        """;
        
        try (PreparedStatement ps = conn.prepareStatement(billsQuery);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> bill = new HashMap<>();
                bill.put("billId", rs.getInt("billId"));
                bill.put("billDate", rs.getString("billDate"));
                bill.put("totalAmount", rs.getDouble("totalAmount"));
                bill.put("status", rs.getString("status"));
                bill.put("customerName", rs.getString("customerName") != null ? rs.getString("customerName") : "Unknown Customer");
                bills.add(bill);
            }
        }
    } catch (Exception e) {
        out.println("<!-- Database error: " + e.getMessage() + " -->");
        e.printStackTrace();
    }
%>

<!-- Header matching dashboard -->
<header class="header">
    <h1><i class="fas fa-calculator"></i> Pahana Edu Bookshop</h1>
    <div class="user-info">
        <span><i class="fas fa-user"></i> Welcome, <%= username %></span>
        <span><i class="fas fa-calendar"></i> <%= formattedDate %></span>
        <a href="logout.jsp" class="logout-btn">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </div>
</header>

<div class="container">
    <!-- Page Title -->
    <div class="page-title">
        <h2><i class="fas fa-list"></i> All Bills</h2>
        <p>View and print generated bills</p>
    </div>

    <!-- Main Content Card -->
    <div class="billing-card">
        <div class="selection-section">
            <h3><i class="fas fa-chart-bar"></i> Bills Summary</h3>
            <p>Total Bills: <strong><%= bills.size() %></strong></p>
            <div style="margin: 1rem 0;">
                <a href="billing.jsp" class="action-btn btn-view">
                    <i class="fas fa-plus"></i> Generate New Bill
                </a>
            </div>
        </div>

        <% if (bills.isEmpty()) { %>
            <div class="empty-state">
                <i class="fas fa-file-invoice"></i>
                <h5>No bills found</h5>
                <p>No bills have been generated yet. <a href="billing.jsp">Create your first bill</a></p>
            </div>
        <% } else { %>
            <table class="bills-table">
                <thead>
                    <tr>
                        <th>Bill ID</th>
                        <th>Customer Name</th>
                        <th>Date</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map<String, Object> bill : bills) { %>
                    <tr>
                        <td><strong>#<%= bill.get("billId") %></strong></td>
                        <td><%= bill.get("customerName") %></td>
                        <td><%= bill.get("billDate") %></td>
                        <td><strong>$<%= String.format("%.2f", (Double) bill.get("totalAmount")) %></strong></td>
                        <td>
                            <span class="status-badge <%= "PAID".equals(bill.get("status")) ? "status-paid" : "status-pending" %>">
                                <%= bill.get("status") %>
                            </span>
                        </td>
                        <td>
                            <a href="printBill.jsp?billId=<%= bill.get("billId") %>" 
                               class="action-btn btn-view" target="_blank" title="View Bill">
                                <i class="fas fa-eye"></i> View
                            </a>
                            <a href="printBill.jsp?billId=<%= bill.get("billId") %>&print=true" 
                               class="action-btn btn-print" target="_blank" title="Print Bill">
                                <i class="fas fa-print"></i> Print
                            </a>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</div>

<!-- Footer -->
<footer class="footer">
    <p>&copy; <%= year %> Pahana Edu Bookshop. All rights reserved.</p>
</footer>

<script>
    // Add some interactivity
    document.addEventListener('DOMContentLoaded', function() {
        // Add click event to table rows for better UX
        const tableRows = document.querySelectorAll('.bills-table tbody tr');
        tableRows.forEach(row => {
            row.addEventListener('click', function(e) {
                if (!e.target.closest('.action-btn')) {
                    const billId = this.querySelector('td:first-child').textContent.replace('#', '');
                    window.open('printBill.jsp?billId=' + billId, '_blank');
                }
            });
            
            // Add pointer cursor
            row.style.cursor = 'pointer';
        });
    });
</script>

</body>
</html>