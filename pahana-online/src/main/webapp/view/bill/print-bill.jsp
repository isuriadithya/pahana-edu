<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.bookshop.dao.DBConnectionFactory" %>
<%@ page import="java.time.LocalDate, java.time.format.DateTimeFormatter" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bill Invoice - Pahana Edu Bookshop</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        /* Print-specific styles */
        @media print {
            .no-print {
                display: none !important;
            }
            body {
                background: white !important;
                -webkit-print-color-adjust: exact;
                color-adjust: exact;
            }
            .bill-container {
                box-shadow: none !important;
                border: 1px solid #000 !important;
                margin: 0 !important;
                padding: 20px !important;
            }
        }

        /* Screen styles */
        body {
            font-family: 'Arial', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            margin: 0;
            padding: 20px;
            min-height: 100vh;
        }

        .bill-container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .bill-header {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 30px;
            text-align: center;
        }

        .bill-header h1 {
            margin: 0 0 10px 0;
            font-size: 2.5rem;
            font-weight: bold;
        }

        .bill-header p {
            margin: 0;
            font-size: 1.1rem;
            opacity: 0.9;
        }

        .bill-content {
            padding: 30px;
        }

        .bill-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #eee;
        }

        .info-section h3 {
            color: #667eea;
            margin-bottom: 15px;
            font-size: 1.2rem;
            border-bottom: 1px solid #667eea;
            padding-bottom: 5px;
        }

        .info-section p {
            margin: 8px 0;
            color: #555;
            font-size: 1rem;
        }

        .info-section strong {
            color: #333;
            font-weight: 600;
        }

        .items-table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
            font-size: 1rem;
        }

        .items-table th {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 15px 10px;
            text-align: left;
            font-weight: 600;
            border: none;
        }

        .items-table td {
            padding: 12px 10px;
            border-bottom: 1px solid #eee;
            color: #555;
        }

        .items-table tbody tr:nth-child(even) {
            background-color: #f8f9fa;
        }

        .items-table tbody tr:hover {
            background-color: #e3f2fd;
        }

        .text-right {
            text-align: right;
        }

        .text-center {
            text-align: center;
        }

        .bill-summary {
            margin-top: 30px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 8px;
            border-left: 4px solid #667eea;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            font-size: 1.1rem;
        }

        .summary-row.total {
            font-weight: bold;
            font-size: 1.3rem;
            color: #667eea;
            border-top: 2px solid #667eea;
            padding-top: 15px;
            margin-top: 15px;
        }

        .print-actions {
            text-align: center;
            padding: 20px;
            background: #f8f9fa;
            border-top: 1px solid #eee;
        }

        .btn {
            padding: 12px 30px;
            margin: 0 10px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
        }

        .btn-print {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
        }

        .btn-back {
            background: linear-gradient(135deg, #6c757d, #5a6268);
            color: white;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }

        .bill-footer {
            text-align: center;
            padding: 20px;
            background: #f8f9fa;
            color: #666;
            font-size: 0.9rem;
            border-top: 1px solid #eee;
        }

        .error-message {
            background: #f8d7da;
            color: #721c24;
            padding: 15px;
            border: 1px solid #f5c6cb;
            border-radius: 5px;
            margin: 20px;
        }

        @media (max-width: 768px) {
            .bill-info {
                grid-template-columns: 1fr;
                gap: 20px;
            }
            
            .items-table {
                font-size: 0.9rem;
            }
            
            .items-table th,
            .items-table td {
                padding: 8px 5px;
            }
        }
    </style>
</head>
<body>

<%
    String billId = request.getParameter("billId");
    if (billId == null || billId.trim().isEmpty()) {
        out.println("<div class='error-message'>Error: Bill ID not provided</div>");
        return;
    }

    // Bill details
    String customerName = "";
    String customerAddress = "";
    String customerEmail = "";
    String customerPhone = "";
    String billDate = "";
    String billStatus = "";
    double totalAmount = 0.0;
    
    List<Map<String, Object>> billItems = new ArrayList<>();
    
    try (Connection conn = DBConnectionFactory.getConnection()) {
        // Get bill details with customer information
        String billQuery = """
            SELECT b.billId, b.billDate, b.totalAmount, b.status,
                   c.name as customerName, 
                   c.address as customerAddress,
                   c.email as customerEmail,
                   c.phone as customerPhone
            FROM Bills b 
            LEFT JOIN Customer c ON b.accountNumber = c.accountNumber 
            WHERE b.billId = ?
        """;
        
        try (PreparedStatement ps = conn.prepareStatement(billQuery)) {
            ps.setInt(1, Integer.parseInt(billId));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    customerName = rs.getString("customerName") != null ? rs.getString("customerName") : "N/A";
                    customerAddress = rs.getString("customerAddress") != null ? rs.getString("customerAddress") : "N/A";
                    customerEmail = rs.getString("customerEmail") != null ? rs.getString("customerEmail") : "N/A";
                    customerPhone = rs.getString("customerPhone") != null ? rs.getString("customerPhone") : "N/A";
                    billDate = rs.getString("billDate");
                    billStatus = rs.getString("status");
                    totalAmount = rs.getDouble("totalAmount");
                } else {
                    out.println("<div class='error-message'>Error: Bill not found with ID: " + billId + "</div>");
                    return;
                }
            }
        }
        
        // Get bill items
        String itemsQuery = """
            SELECT bi.quantity, bi.unitPrice, bi.totalPrice,
                   i.name as itemName, i.description as itemDescription
            FROM BillItems bi
            LEFT JOIN Items i ON bi.itemId = i.itemId
            WHERE bi.billId = ?
        """;
        
        try (PreparedStatement ps = conn.prepareStatement(itemsQuery)) {
            ps.setInt(1, Integer.parseInt(billId));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new HashMap<>();
                    item.put("name", rs.getString("itemName") != null ? rs.getString("itemName") : "Unknown Item");
                    item.put("description", rs.getString("itemDescription") != null ? rs.getString("itemDescription") : "N/A");
                    item.put("quantity", rs.getInt("quantity"));
                    item.put("unitPrice", rs.getDouble("unitPrice"));
                    item.put("totalPrice", rs.getDouble("totalPrice"));
                    billItems.add(item);
                }
            }
        }
        
    } catch (Exception e) {
        out.println("<div class='error-message'>Database error: " + e.getMessage() + "</div>");
        e.printStackTrace();
        return;
    }
    
    // Format current date
    LocalDate today = LocalDate.now();
    String formattedDate = today.format(DateTimeFormatter.ofPattern("MMMM dd, yyyy"));
%>

<div class="bill-container">
    <!-- Bill Header -->
    <div class="bill-header">
        <h1><i class="fas fa-store"></i> Pahana Edu Bookshop</h1>
        <p>Your Trusted Educational Partner</p>
        <p>📍 Negombo, Western Province, Sri Lanka | 📞 +94 XX XXX XXXX | 📧 info@pahanaedu.lk</p>
    </div>

    <!-- Bill Content -->
    <div class="bill-content">
        <!-- Bill Information -->
        <div class="bill-info">
            <div class="info-section">
                <h3><i class="fas fa-file-invoice"></i> Bill Details</h3>
                <p><strong>Bill ID:</strong> #<%= billId %></p>
                <p><strong>Bill Date:</strong> <%= billDate != null ? billDate : formattedDate %></p>
                <p><strong>Status:</strong> <span style="color: <%= "PAID".equals(billStatus) ? "#28a745" : "#ffc107" %>;"><%= billStatus %></span></p>
                <p><strong>Generated On:</strong> <%= formattedDate %></p>
            </div>
            
            <div class="info-section">
                <h3><i class="fas fa-user"></i> Customer Information</h3>
                <p><strong>Name:</strong> <%= customerName %></p>
                <p><strong>Address:</strong> <%= customerAddress %></p>
                <p><strong>Email:</strong> <%= customerEmail %></p>
                <p><strong>Phone:</strong> <%= customerPhone %></p>
            </div>
        </div>

        <!-- Items Table -->
        <table class="items-table">
            <thead>
                <tr>
                    <th>Item</th>
                    <th>Description</th>
                    <th class="text-center">Quantity</th>
                    <th class="text-right">Unit Price</th>
                    <th class="text-right">Total</th>
                </tr>
            </thead>
            <tbody>
                <%
                double subtotal = 0;
                for (Map<String, Object> item : billItems) {
                    subtotal += (Double) item.get("totalPrice");
                %>
                <tr>
                    <td><strong><%= item.get("name") %></strong></td>
                    <td><%= item.get("description") %></td>
                    <td class="text-center"><%= item.get("quantity") %></td>
                    <td class="text-right">$<%= String.format("%.2f", (Double) item.get("unitPrice")) %></td>
                    <td class="text-right">$<%= String.format("%.2f", (Double) item.get("totalPrice")) %></td>
                </tr>
                <% } %>
                
                <% if (billItems.isEmpty()) { %>
                <tr>
                    <td colspan="5" class="text-center" style="color: #666; font-style: italic;">No items found for this bill</td>
                </tr>
                <% } %>
            </tbody>
        </table>

        <!-- Bill Summary -->
        <div class="bill-summary">
            <div class="summary-row">
                <span>Subtotal:</span>
                <span>$<%= String.format("%.2f", subtotal) %></span>
            </div>
            <div class="summary-row">
                <span>Tax (10%):</span>
                <span>$<%= String.format("%.2f", subtotal * 0.10) %></span>
            </div>
            <div class="summary-row total">
                <span>Total Amount:</span>
                <span>$<%= String.format("%.2f", totalAmount) %></span>
            </div>
        </div>
    </div>

    <!-- Print Actions -->
    <div class="print-actions no-print">
        <button class="btn btn-print" onclick="window.print()">
            <i class="fas fa-print"></i> Print Bill
        </button>
        <a href="billing.jsp" class="btn btn-back">
            <i class="fas fa-arrow-left"></i> Back to Billing
        </a>
    </div>

    <!-- Bill Footer -->
    <div class="bill-footer">
        <p><strong>Thank you for your business!</strong></p>
        <p>This is a computer-generated bill. For any queries, please contact us.</p>
        <p>&copy; <%= java.time.Year.now().getValue() %> Pahana Edu Bookshop. All rights reserved.</p>
    </div>
</div>

<script>
    // Auto-print if print parameter is set
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('print') === 'true') {
        window.onload = function() {
            setTimeout(function() {
                window.print();
            }, 500);
        };
    }
</script>

</body>
</html>