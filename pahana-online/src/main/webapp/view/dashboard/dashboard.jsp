<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalDate, java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.bookshop.model.UserModel" %>
<%@ page import="com.bookshop.dao.DBConnection" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Billing System Dashboard</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
</head>
<body>
<%
    // Generate current date and year
    LocalDate today = LocalDate.now();
    String formattedDate = today.format(DateTimeFormatter.ofPattern("MMMM dd, yyyy"));
    int year = today.getYear();

    // Variables to store real data
    int totalCustomers = 0;
    int activeItems = 0;
    double monthlyRevenue = 0.0;
    int pendingBills = 0;

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // Get database connection using your DBConnection singleton
        conn = DBConnection.getInstance().getConnection();

        // Query 1: Get total number of customers
        String customerQuery = "SELECT COUNT(*) as total_customers FROM customer";
        pstmt = conn.prepareStatement(customerQuery);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            totalCustomers = rs.getInt("total_customers");
        }
        rs.close();
        pstmt.close();

        // Query 2: Get number of active items
        String itemsQuery = "SELECT COUNT(*) as active_items FROM items";
        pstmt = conn.prepareStatement(itemsQuery);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            activeItems = rs.getInt("active_items");
        }
        rs.close();
        pstmt.close();


    } catch (SQLException e) {
        out.println("<!-- Database Error: " + e.getMessage() + " -->");
        // Use default values if database connection fails
        totalCustomers = 0;
        activeItems = 0;
        monthlyRevenue = 0.0;
        pendingBills = 0;
        
        System.out.println(e);
        
    } finally {
        // Close only PreparedStatement and ResultSet
        // Don't close the connection as it's managed by the singleton
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
        } catch (SQLException e) {
            out.println("<!-- Error closing database resources: " + e.getMessage() + " -->");
        }
    }

    //  Get UserModel from session (store it in controller as "user")
    UserModel user = (UserModel) session.getAttribute("username");

    String username;
    if (user == null) {
        username = "Admin User";   // fallback
    } else {
        username = user.getUsername();  // or user.getName() depending on your model
    }
%>

<header class="header">
    <h1><i class="fas fa-calculator"></i> Pahana Edu Bookshop </h1>
    <div class="user-info">
        <span><i class="fas fa-user"></i> Welcome, <%= username %></span>
        <span><i class="fas fa-calendar"></i> <%= formattedDate %></span>
       <a href="/pahana-online/index.jsp" class="logout-btn" onclick="return confirm('Are you sure you want to log out?');">
    <i class="fas fa-sign-out-alt"></i> Logout
</a>
    </div>
</header>

<div class="dashboard-container">
    <div class="welcome-section">
        <h2>Dashboard Overview</h2>
        <p>Manage your billing system efficiently with our comprehensive tools</p>
    </div>
    
           <!-- Quick Actions -->
    <div class="quick-actions">
    <h3 class="quick-actions-title">
        <i class="fas fa-bolt"></i> Quick Actions
    </h3>
    <div class="action-grid">
        <div class="action-item" onclick="window.location='/pahana-online/view/customer/customer.jsp'">
            <i class="fas fa-user-plus action-icon green"></i>
            <span class="action-label">Add Customer</span>
        </div>
        <div class="action-item" onclick="window.location='/pahana-online/view/item/items.jsp'">
            <i class="fas fa-plus-circle action-icon blue"></i>
            <span class="action-label">Add Item</span>
        </div>
        <div class="action-item" onclick="window.location='/pahana-online/view/bill/billing.jsp'">
            <i class="fas fa-file-invoice action-icon orange"></i>
            <span class="action-label">Generate Bill</span>
        </div>
        <div class="action-item" onclick="window.location='/pahana-online/view/reports/reports.jsp'">
            <i class="fas fa-chart-bar action-icon purple"></i>
            <span class="action-label">View Reports</span>
        </div>
    </div>
</div>

    <!-- Quick Stats -->
    <div class="quick-stats">
        <h3 class="quick-stats-title">
            <i class="fas fa-chart-line"></i> Quick Statistics
        </h3>
        <div class="stats-grid">
            <div class="stat-item">
                <span class="stat-number"><%= totalCustomers %></span>
                <span class="stat-label">Total Customers</span>
            </div>
            <div class="stat-item">
                <span class="stat-number"><%= activeItems %></span>
                <span class="stat-label">All Items</span>
            </div>
            <div class="stat-item">
                <span class="stat-number">Rs <%= String.format("%.2f", monthlyRevenue) %></span>
                <span class="stat-label">Monthly Revenue</span>
            </div>
            <div class="stat-item">
                <span class="stat-number"><%= pendingBills %></span>
                <span class="stat-label">Pending Bills</span>
            </div>
        </div>
    </div>

    <!-- Menu Grid -->
    <div class="menu-grid">
        <div class="menu-card customer-card" onclick="window.location='../customer/customer.jsp'">
            <i class="fas fa-users"></i>
            <h3>Manage Customers</h3>
            <p>Complete customer account management system</p>
            <ul class="features">
                <li>Add new customer accounts</li>
                <li>Edit customer information</li>
                <li>View account details</li>
                <li>Search and filter customers</li>
            </ul>
        </div>

        <div class="menu-card items-card" onclick="window.location='../item/items.jsp'">
            <i class="fas fa-boxes"></i>
            <h3>Manage Items</h3>
            <p>Comprehensive item and product management</p>
            <ul class="features">
                <li>Add new items/services</li>
                <li>Update item information</li>
                <li>Delete obsolete items</li>
                <li>Set pricing and units</li>
            </ul>
        </div>

        <div class="menu-card billing-card" onclick="window.location='../bill/billing.jsp'">
            <i class="fas fa-receipt"></i>
            <h3>Billing System</h3>
            <p>Advanced billing and invoice generation</p>
            <ul class="features">
                <li>Calculate consumption bills</li>
                <li>Generate and print invoices</li>
                <li>View billing history</li>
                <li>Payment tracking</li>
            </ul>
        </div>

        <div class="menu-card help-card" onclick="window.location='../help/help.jsp'">
            <i class="fas fa-question-circle"></i>
            <h3>Help & Support</h3>
            <p>Get assistance and learn how to use the system effectively with our comprehensive user guide and support resources.</p>
        </div>
    </div>

 


<footer class="footer">
    <p>&copy; <%= year %> Pahana Edu Bookshop. All rights reserved.</p>
</footer>

</body>
</html>