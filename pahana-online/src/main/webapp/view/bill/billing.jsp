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
<title>Billing System - Pahana Edu Bookshop</title>
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
<link rel="stylesheet" href="billing-style.css">
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

    // Database operations with flexible column names
    List<String> customerOptions = new ArrayList<>();
    List<String> itemOptions = new ArrayList<>();
    
    try (Connection conn = DBConnectionFactory.getConnection()) {
        // First, let's check what columns exist in Customer table
        String customerIdColumn = "accountNumber"; // default
        String customerNameColumn = "name"; // default
        
        // Try to detect the actual column names
        DatabaseMetaData metaData = conn.getMetaData();
        ResultSet columns = metaData.getColumns(null, null, "Customer", null);
        List<String> availableColumns = new ArrayList<>();
        
        while (columns.next()) {
            String columnName = columns.getString("COLUMN_NAME").toLowerCase();
            availableColumns.add(columnName);
        }
        columns.close();
        
        // Determine the correct ID column name
        if (availableColumns.contains("accountnumber")) {
            customerIdColumn = "accountNumber";
        } else if (availableColumns.contains("customer_id")) {
            customerIdColumn = "customer_id";
        } else if (availableColumns.contains("customerid")) {
            customerIdColumn = "customerId";
        } else if (availableColumns.contains("id")) {
            customerIdColumn = "id";
        }
        
        // Determine the correct name column
        if (availableColumns.contains("name")) {
            customerNameColumn = "name";
        } else if (availableColumns.contains("customer_name")) {
            customerNameColumn = "customer_name";
        } else if (availableColumns.contains("customername")) {
            customerNameColumn = "customerName";
        }
        
        // Load customers with detected column names
        String customerQuery = "SELECT " + customerIdColumn + ", " + customerNameColumn + " FROM Customer";
        try (PreparedStatement ps = conn.prepareStatement(customerQuery);
             ResultSet rs = ps.executeQuery()) {
            while(rs.next()) {
                customerOptions.add("<option value='" + rs.getInt(customerIdColumn) + "' data-column='" + customerIdColumn + "'>" + rs.getString(customerNameColumn) + "</option>");
            }
        }

        // Load items (assuming Items table structure is correct)
        String itemQuery = "SELECT itemId, name, description, price FROM Items";
        try (PreparedStatement ps = conn.prepareStatement(itemQuery);
             ResultSet rs = ps.executeQuery()) {
            while(rs.next()) {
                itemOptions.add("<option value='" + rs.getInt("itemId") + "' data-description='" 
                    + rs.getString("description") + "' data-price='" 
                    + rs.getDouble("price") + "'>" + rs.getString("name") + "</option>");
            }
        }
        
        // Store the detected column name for JavaScript
        request.setAttribute("customerIdColumn", customerIdColumn);
        
    } catch (Exception e) {
        out.println("<!-- Database error: " + e.getMessage() + " -->");
        e.printStackTrace();
    }
%>

<!-- Header matching dashboard -->
   <header class="header">
        <div class="breadcrumb">
            <a href="/pahana-online/view/dashboard/dashboard.jsp">
                <i class="fas fa-home"></i> Dashboard
            </a>
            <span>Billing System </span>
        </div>
        <h1><i class="fas fa-file-invoice"></i> Manage Bills</h1>
    </header>



    <!-- Main Billing Card -->
    <div class="billing-card">
        <!-- Selection Section -->
        <div class="selection-section">
            <h3><i class="fas fa-cogs"></i> Select Customer & Items</h3>
            
            <div class="selection-row">
                <div class="form-group">
                    <label><i class="fas fa-user"></i> Select Customer:</label>
                    <select id="customerSelect" class="form-select">
                        <option value="">-- Select Customer --</option>
                        <% for(String c : customerOptions) out.print(c); %>
                    </select>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-box"></i> Select Item:</label>
                    <select id="itemSelect" class="form-select">
                        <option value="">-- Select Item --</option>
                        <% for(String i : itemOptions) out.print(i); %>
                    </select>
                </div>
            </div>
        </div>

        <!-- Bill Content -->
        <div class="bill-content">
            <!-- Bill Items Section -->
            <div class="bill-items-section">
                <h4><i class="fas fa-list"></i> Bill Items</h4>
                <div id="billItems">
                    <div class="empty-state">
                        <i class="fas fa-shopping-cart"></i>
                        <h5>No items added yet</h5>
                        <p>Select items from the dropdown above to add them to the bill</p>
                    </div>
                </div>
            </div>

            <!-- Summary Section -->
            <div class="summary-section">
                <h4><i class="fas fa-calculator"></i> Bill Summary</h4>
                <div id="billSummary">
                    <div class="summary-item">
                        <span class="summary-label">Total Items:</span>
                        <span class="summary-value">0</span>
                    </div>
                    <div class="summary-item">
                        <span class="summary-label">Subtotal:</span>
                        <span class="summary-value">Rs0.00</span>
                    </div>
                    <div class="summary-item">
                        <span class="summary-label">Tax (10%):</span>
                        <span class="summary-value">Rs0.00</span>
                    </div>
                    <div class="summary-item">
                        <span class="summary-label">Total Amount:</span>
                        <span class="summary-value">Rs0.00</span>
                    </div>
                </div>
                
                <button id="saveBill" class="save-bill-btn">
                    <i class="fas fa-save"></i> Save Bill
                </button>
                
                <a href="viewBills.jsp" class="save-bill-btn" style="margin-top: 10px; text-decoration: none; text-align: center; background: linear-gradient(135deg, #007bff, #0056b3);">
                    <i class="fas fa-list"></i> View All Bills
                </a>
            </div>
        </div>
    </div>
</div>

<!-- Footer -->
<footer class="footer">
    <p>&copy; <%= year %> Pahana Edu Bookshop. All rights reserved.</p>
</footer>

<script>
let selectedCustomer = null;
let billItems = [];
let customerIdColumn = '<%= request.getAttribute("customerIdColumn") %>';

console.log('Customer ID Column:', customerIdColumn);

document.getElementById('customerSelect').addEventListener('change', function() {
    const opt = this.options[this.selectedIndex];
    if (this.value) {
        selectedCustomer = {
            id: this.value,
            name: opt.text,
            columnName: opt.dataset.column || customerIdColumn
        };
    } else {
        selectedCustomer = null;
    }
    console.log('Selected customer:', selectedCustomer);
});

document.getElementById('itemSelect').addEventListener('change', function() {
    const opt = this.options[this.selectedIndex];
    if(!this.value) return;

    const item = {
        itemId: this.value,
        name: opt.text,
        description: opt.dataset.description,
        price: parseFloat(opt.dataset.price),
        quantity: 1
    };
    billItems.push(item);
    console.log('Added item:', item);
    updateBillDisplay();
    this.value = '';
});

function updateBillDisplay() {
    const div = document.getElementById('billItems');
    if(!billItems.length) {
        div.innerHTML = `
            <div class="empty-state">
                <i class="fas fa-shopping-cart"></i>
                <h5>No items added yet</h5>
                <p>Select items from the dropdown above to add them to the bill</p>
            </div>
        `;
        updateBillSummary();
        return;
    }

    div.innerHTML = billItems.map((item,i)=>`
        <div class="bill-item">
            <div class="item-header">
                <span class="item-name">${item.name}</span>
                <span class="item-price">Rs.${item.price.toFixed(2)}</span>
            </div>
            <div class="item-description">${item.description}</div>
            <div class="item-controls">
                <div class="quantity-control">
                    <label>Qty:</label>
                    <input type="number" value="${item.quantity}" onchange="updateQuantity(${i}, this.value)" 
                           class="quantity-input" min="1">
                </div>
                <div class="item-total">Rs.${(item.price*item.quantity).toFixed(2)}</div>
                <button onclick="removeItem(${i})" class="remove-btn">
                    <i class="fas fa-trash"></i> Remove
                </button>
            </div>
        </div>
    `).join('');

    updateBillSummary();
}

function updateQuantity(i,val){
    billItems[i].quantity = parseInt(val);
    updateBillDisplay();
}

function removeItem(i){
    billItems.splice(i,1);
    updateBillDisplay();
}

function updateBillSummary(){
    const div = document.getElementById('billSummary');
    const subtotal = billItems.reduce((sum,item)=>sum+item.price*item.quantity,0);
    const tax = subtotal*0.1;
    const total = subtotal+tax;
    
    div.innerHTML = `
        <div class="summary-item">
            <span class="summary-label">Total Items:</span>
            <span class="summary-value">${billItems.reduce((s,i)=>s+i.quantity,0)}</span>
        </div>
        <div class="summary-item">
            <span class="summary-label">Subtotal:</span>
            <span class="summary-value">Rs. ${subtotal.toFixed(2)}</span>
        </div>
        <div class="summary-item">
            <span class="summary-label">Tax (10%):</span>
            <span class="summary-value">Rs. ${tax.toFixed(2)}</span>
        </div>
        <div class="summary-item">
            <span class="summary-label">Total Amount:</span>
            <span class="summary-value">Rs. ${total.toFixed(2)}</span>
        </div>
    `;
}

// Enhanced Save Bill Function
document.getElementById('saveBill').addEventListener('click', function(){
    console.log('Save bill button clicked');
    console.log('Selected customer:', selectedCustomer);
    console.log('Bill items:', billItems);
    
    if(!selectedCustomer || !billItems.length){
        alert('Please select a customer and add at least one item');
        return;
    }

    const saveButton = this;
    const originalText = saveButton.innerHTML;
    saveButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';
    saveButton.disabled = true;

    const billItemsJson = JSON.stringify(billItems.map(item => ({
        itemId: item.itemId,
        quantity: item.quantity
    })));

    const formData = new URLSearchParams();
    formData.append('action', 'saveBill');
    formData.append('customerId', selectedCustomer.id);
    formData.append('customerIdColumn', customerIdColumn);
    formData.append('billItems', billItemsJson);

    console.log('Sending request with data:', {
        action: 'saveBill',
        customerId: selectedCustomer.id,
        customerIdColumn: customerIdColumn,
        billItems: billItemsJson
    });

    fetch('BillController', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: formData
    })
    .then(response => {
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json();
    })
    .then(result => {
        console.log('Response:', result);
        saveButton.innerHTML = originalText;
        saveButton.disabled = false;
        
        if (result.success) {
            // Show success message with print options
            const printChoice = confirm(
                'Bill saved successfully! Bill ID: ' + result.billId + 
                '\n\nWould you like to print the bill now?'
            );
            
            if (printChoice) {
                // Open print page in new window
                window.open('printBill.jsp?billId=' + result.billId + '&print=true', '_blank');
            }
            
            // Reset the form
            selectedCustomer = null;
            billItems = [];
            document.getElementById('customerSelect').value = '';
            updateBillDisplay();
        } else {
            alert('Error from server: ' + result.message);
        }
    })
    .catch(error => {
        console.error('Error:', error);
        saveButton.innerHTML = originalText;
        saveButton.disabled = false;
        alert('Error saving bill: ' + error.message);
    });
});

// Initialize display
updateBillDisplay();
</script>
</body>
</html>