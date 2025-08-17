<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalDate, java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.*" %>
<%@ page import="com.bookshop.model.UserModel" %>

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

    // Dummy values (replace with DB queries or session attributes)
    int totalCustomers = 156;
    int activeItems = 89;
    double monthlyRevenue = 45230.00;
    int pendingBills = 12;

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
        <a href="logout.jsp" class="logout-btn">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </div>
</header>


<div class="dashboard-container">
    <div class="welcome-section">
        <h2>Dashboard Overview</h2>
        <p>Manage your billing system efficiently with our comprehensive tools</p>
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
                <span class="stat-label">Active Items</span>
            </div>
            <div class="stat-item">
                <span class="stat-number">₹<%= monthlyRevenue %></span>
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

        <div class="menu-card items-card" onclick="window.location='items.jsp'">
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

        <div class="menu-card billing-card" onclick="window.location='billing.jsp'">
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

        <div class="menu-card help-card" onclick="window.location='help.jsp'">
            <i class="fas fa-question-circle"></i>
            <h3>Help & Support</h3>
            <p>Get assistance and learn how to use the system effectively with our comprehensive user guide and support resources.</p>
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="quick-actions">
        <h3 class="quick-actions-title">
            <i class="fas fa-bolt"></i> Quick Actions
        </h3>
        <div class="action-grid">
            <div class="action-item" onclick="window.location='addCustomer.jsp'">
                <i class="fas fa-user-plus action-icon green"></i>
                <span class="action-label">Add Customer</span>
            </div>
            <div class="action-item" onclick="window.location='addItem.jsp'">
                <i class="fas fa-plus-circle action-icon blue"></i>
                <span class="action-label">Add Item</span>
            </div>
            <div class="action-item" onclick="window.location='generateBill.jsp'">
                <i class="fas fa-file-invoice action-icon orange"></i>
                <span class="action-label">Generate Bill</span>
            </div>
            <div class="action-item" onclick="window.location='reports.jsp'">
                <i class="fas fa-chart-bar action-icon purple"></i>
                <span class="action-label">View Reports</span>
            </div>
        </div>
    </div>
</div>

<footer class="footer">
    <p>&copy; <%= year %> Billing Management System. All rights reserved. | Secure • Reliable • Efficient</p>
</footer>

</body>
</html>
