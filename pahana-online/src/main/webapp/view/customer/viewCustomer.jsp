<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bookshop.model.Customer" %>
<%
    // Get the customer object from request attribute
    Customer customer = (Customer) request.getAttribute("customer");

    if (customer == null) {
%>
    <p style="color:red;">Customer not found.</p>
<%
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>View Customer</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .container {
            max-width: 700px;
            margin: 40px auto;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            background: #fff;
            font-family: Arial, sans-serif;
        }
        h2 {
            margin-bottom: 20px;
            color: #333;
            border-bottom: 2px solid #eee;
            padding-bottom: 10px;
        }
        .field {
            margin-bottom: 15px;
        }
        .field label {
            font-weight: bold;
            display: block;
            color: #444;
        }
        .field span {
            display: block;
            padding: 8px 12px;
            background: #f9f9f9;
            border-radius: 6px;
        }
        .btn {
            display: inline-block;
            padding: 10px 18px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: bold;
            margin-right: 8px;
        }
        .btn-back { background: #6c757d; color: #fff; }
        .btn-edit { background: #0d6efd; color: #fff; }
        .btn-delete { background: #dc3545; color: #fff; }
    </style>
</head>
<body>
<div class="container">
    <h2><i class="fas fa-user"></i> Customer Details</h2>

    <div class="field">
        <label>Account Number:</label>
        <span><%= customer.getAccountNumber() %></span>
    </div>
    <div class="field">
        <label>Name:</label>
        <span><%= customer.getName() %></span>
    </div>
    <div class="field">
        <label>Address:</label>
        <span><%= customer.getAddress() %></span>
    </div>
    <div class="field">
        <label>Telephone:</label>
        <span><%= customer.getTelephone() %></span>
    </div>
    <div class="field">
        <label>Units Consumed:</label>
        <span><%= customer.getUnitsConsumed() %></span>
    </div>
    <div class="field">
        <label>Bill Amount (Rs.):</label>
        <span><%= customer.getBillAmount() %></span>
    </div>

    <div style="margin-top: 20px;">
        <a href="<%=request.getContextPath()%>/customer?action=list" class="btn btn-back">
            <i class="fas fa-arrow-left"></i> Back
        </a>
        <a href="<%=request.getContextPath()%>/customer?action=edit&accountNumber=<%=customer.getAccountNumber()%>" class="btn btn-edit">
            <i class="fas fa-edit"></i> Edit
        </a>
        <a href="<%=request.getContextPath()%>/customer?action=delete&accountNumber=<%=customer.getAccountNumber()%>" 
           class="btn btn-delete" 
           onclick="return confirm('Are you sure you want to delete this customer?');">
            <i class="fas fa-trash"></i> Delete
        </a>
    </div>
</div>
</body>
</html>
