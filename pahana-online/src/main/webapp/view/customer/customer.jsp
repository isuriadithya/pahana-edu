<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.bookshop.model.UserModel" %>
<%@ page import="com.bookshop.model.Customer" %>
<%@ page import="com.bookshop.dao.CustomerDAO" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Management - Billing System</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: #333;
        }

        /* Header */
        .header {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }

        .header h1 {
            color: #2d3748;
            font-size: 1.5rem;
            font-weight: 700;
        }

        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: #6b7280;
        }

        .breadcrumb a {
            color: #667eea;
            text-decoration: none;
        }

        .breadcrumb a:hover {
            text-decoration: underline;
        }

        /* Main Container */
        .container {
            max-width: 1400px;
            margin: 2rem auto;
            padding: 0 2rem;
        }

        /* Action Bar */
        .action-bar {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            padding: 1.5rem;
            border-radius: 15px;
            margin-bottom: 2rem;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 1rem;
        }

        .search-box {
            flex: 1;
            max-width: 400px;
            position: relative;
        }

        .search-box input {
            width: 100%;
            padding: 0.75rem 1rem 0.75rem 3rem;
            border: 2px solid #e5e7eb;
            border-radius: 50px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .search-box input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .search-box i {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #9ca3af;
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 50px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
        }

        .btn-secondary {
            background: #f3f4f6;
            color: #374151;
            border: 1px solid #d1d5db;
        }

        .btn-secondary:hover {
            background: #e5e7eb;
        }

        /* Customer Grid */
        .customer-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .customer-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            padding: 1.5rem;
            border-radius: 15px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            border-left: 4px solid #667eea;
        }

        .customer-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
        }

        .customer-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1rem;
        }

        .customer-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea, #764ba2);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.2rem;
            font-weight: 600;
        }

        .customer-name {
            font-size: 1.2rem;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 0.25rem;
        }

        .customer-id {
            font-size: 0.85rem;
            color: #6b7280;
            background: #f3f4f6;
            padding: 0.25rem 0.5rem;
            border-radius: 20px;
        }

        .customer-details {
            margin-bottom: 1rem;
        }

        .detail-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 0.5rem;
            color: #4a5568;
        }

        .detail-item i {
            width: 16px;
            color: #667eea;
        }

        .customer-actions {
            display: flex;
            gap: 0.5rem;
            padding-top: 1rem;
            border-top: 1px solid #e5e7eb;
        }

        .btn-sm {
            padding: 0.5rem 1rem;
            font-size: 0.85rem;
        }

        .btn-edit {
            background: #10b981;
            color: white;
        }

        .btn-edit:hover {
            background: #059669;
        }

        .btn-delete {
            background: #ef4444;
            color: white;
        }

        .btn-delete:hover {
            background: #dc2626;
        }

        .btn-view {
            background: #3b82f6;
            color: white;
        }

        .btn-view:hover {
            background: #2563eb;
        }

        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.7);
            backdrop-filter: blur(5px);
            z-index: 1000;
        }

        .modal-content {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: white;
            padding: 2rem;
            border-radius: 20px;
            width: 90%;
            max-width: 600px;
            max-height: 90vh;
            overflow-y: auto;
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #e5e7eb;
        }

        .modal-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #2d3748;
        }

        .close-btn {
            background: none;
            border: none;
            font-size: 1.5rem;
            color: #9ca3af;
            cursor: pointer;
            padding: 0.5rem;
        }

        .close-btn:hover {
            color: #6b7280;
        }

        /* Form Styles */
        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .form-group {
            margin-bottom: 1rem;
        }

        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: #374151;
        }

        .form-input {
            width: 100%;
            padding: 0.75rem;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .form-input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 1rem;
            padding-top: 1rem;
            border-top: 1px solid #e5e7eb;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .empty-state i {
            font-size: 4rem;
            color: #9ca3af;
            margin-bottom: 1rem;
        }

        .empty-state h3 {
            font-size: 1.5rem;
            color: #4b5563;
            margin-bottom: 0.5rem;
        }

        .empty-state p {
            color: #6b7280;
            margin-bottom: 2rem;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .container {
                padding: 0 1rem;
            }

            .action-bar {
                flex-direction: column;
                align-items: stretch;
                gap: 1rem;
            }

            .customer-grid {
                grid-template-columns: 1fr;
            }

            .modal-content {
                width: 95%;
                padding: 1.5rem;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }
        }

        /* Status badges */
        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-active {
            background: #dcfce7;
            color: #166534;
        }

        .status-inactive {
            background: #fee2e2;
            color: #991b1b;
        }
    </style>
</head>
<body>
<%
    // Get current date
    SimpleDateFormat sdf = new SimpleDateFormat("MMMM dd, yyyy");
    String currentDate = sdf.format(new Date());

    // Get user from session
    UserModel user = (UserModel) session.getAttribute("username");
    String username = (user != null) ? user.getUsername() : "Admin User";

    // Mock customer data - replace with actual database calls
    List<Map<String, String>> customers = new ArrayList<>();
    
    // Sample customers
    Map<String, String> customer1 = new HashMap<>();
    customer1.put("accountNumber", "1001");
    customer1.put("name", "John Doe");
    customer1.put("address", "123 Main St, City, State - 12345");
    customer1.put("telephone", "+1 234 567 8900");
    customer1.put("billAmount", "1250.75");
    customers.add(customer1);

    Map<String, String> customer2 = new HashMap<>();
    customer2.put("accountNumber", "1002");
    customer2.put("name", "Jane Smith");
    customer2.put("address", "456 Oak Ave, Town, State - 67890");
    customer2.put("telephone", "+1 234 567 8901");
    customer2.put("billAmount", "850.50");
    customers.add(customer2);

    Map<String, String> customer3 = new HashMap<>();
    customer3.put("accountNumber", "1003");
    customer3.put("name", "Robert Johnson");
    customer3.put("address", "789 Pine St, Village, State - 54321");
    customer3.put("telephone", "+1 234 567 8902");
    customer3.put("billAmount", "2100.25");
    customers.add(customer3);
%>

    <header class="header">
        <div class="breadcrumb">
            <a href="dashboard.jsp"><i class="fas fa-home"></i> Dashboard</a>
            <i class="fas fa-chevron-right"></i>
            <span>Customer Management</span>
        </div>
        <h1><i class="fas fa-users"></i> Manage Customers</h1>
    </header>

    <div class="container">
        <div class="action-bar">
            <div class="search-box">
                <i class="fas fa-search"></i>
                <input type="text" id="searchInput" placeholder="Search customers by name, account number, or phone...">
            </div>
            <div style="display: flex; gap: 1rem; align-items: center;">
                <button class="btn btn-secondary" onclick="exportCustomers()">
                    <i class="fas fa-download"></i> Export
                </button>
                <button class="btn btn-primary" onclick="openAddModal()">
                    <i class="fas fa-plus"></i> Add Customer
                </button>
            </div>
        </div>

        <div class="customer-grid" id="customerGrid">
            <% for (Map<String, String> customer : customers) { %>
            <div class="customer-card" data-customer-id="<%= customer.get("accountNumber") %>">
                <div class="customer-header">
                    <div style="display: flex; align-items: center; gap: 1rem;">
                        <div class="customer-avatar">
                            <%= customer.get("name").substring(0, 1).toUpperCase() %>
                        </div>
                        <div>
                            <div class="customer-name"><%= customer.get("name") %></div>
                            <div class="customer-id">ACC: <%= customer.get("accountNumber") %></div>
                        </div>
                    </div>
                    <span class="status-badge status-active">
                        ₹<%= customer.get("billAmount") %>
                    </span>
                </div>
                
                <div class="customer-details">
                    <div class="detail-item">
                        <i class="fas fa-credit-card"></i>
                        <span>Account: <%= customer.get("accountNumber") %></span>
                    </div>
                    <div class="detail-item">
                        <i class="fas fa-phone"></i>
                        <span><%= customer.get("telephone") %></span>
                    </div>
                    <div class="detail-item">
                        <i class="fas fa-map-marker-alt"></i>
                        <span><%= customer.get("address") %></span>
                    </div>
                    <div class="detail-item">
                        <i class="fas fa-rupee-sign"></i>
                        <span>Bill Amount: ₹<%= customer.get("billAmount") %></span>
                    </div>
                </div>
                
                <div class="customer-actions">
                    <button class="btn btn-view btn-sm" onclick="viewCustomer('<%= customer.get("accountNumber") %>')">
                        <i class="fas fa-eye"></i> View
                    </button>
                    <button class="btn btn-edit btn-sm" onclick="editCustomer('<%= customer.get("accountNumber") %>')">
                        <i class="fas fa-edit"></i> Edit
                    </button>
                    <button class="btn btn-delete btn-sm" onclick="deleteCustomer('<%= customer.get("accountNumber") %>')">
                        <i class="fas fa-trash"></i> Delete
                    </button>
                </div>
            </div>
            <% } %>
        </div>

        <% if (customers.isEmpty()) { %>
        <div class="empty-state">
            <i class="fas fa-users"></i>
            <h3>No Customers Found</h3>
            <p>Start by adding your first customer to the system</p>
            <button class="btn btn-primary" onclick="openAddModal()">
                <i class="fas fa-plus"></i> Add First Customer
            </button>
        </div>
        <% } %>
    </div>

    <!-- Add/Edit Customer Modal -->
    <div id="customerModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 class="modal-title" id="modalTitle">Add New Customer</h2>
                <button class="close-btn" onclick="closeModal()">&times;</button>
            </div>
            
            <form id="customerForm">
                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label">Customer Name *</label>
                        <input type="text" class="form-input" id="customerName" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Address *</label>
                        <input type="email" class="form-input" id="customerEmail" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Phone Number *</label>
                        <input type="tel" class="form-input" id="customerPhone" required>
                    </div>
                  
                </div>
                <div class="form-actions">
                    <button type="button" class="btn btn-secondary" onclick="closeModal()">Cancel</button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> Save Customer
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Modal functions
        function openAddModal() {
            document.getElementById('modalTitle').textContent = 'Add New Customer';
            document.getElementById('customerForm').reset();
            document.getElementById('customerModal').style.display = 'block';
        }

        function closeModal() {
            document.getElementById('customerModal').style.display = 'none';
        }

        // Customer actions
        function viewCustomer(customerId) {
            alert('Viewing customer: ' + customerId);
            // Implement view logic
        }

        function editCustomer(customerId) {
            document.getElementById('modalTitle').textContent = 'Edit Customer';
            // Populate form with customer data
            document.getElementById('customerModal').style.display = 'block';
            // Implement edit logic
        }

        function deleteCustomer(customerId) {
            if (confirm('Are you sure you want to delete this customer?')) {
                alert('Deleting customer: ' + customerId);
                // Implement delete logic
            }
        }

        function exportCustomers() {
            alert('Exporting customer data...');
            // Implement export logic
        }

        // Search functionality
        document.getElementById('searchInput').addEventListener('input', function(e) {
            const searchTerm = e.target.value.toLowerCase();
            const customerCards = document.querySelectorAll('.customer-card');
            
            customerCards.forEach(card => {
                const customerText = card.textContent.toLowerCase();
                if (customerText.includes(searchTerm)) {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });
        });

        // Form submission
        document.getElementById('customerForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const formData = {
                accountNumber: document.getElementById('accountNumber').value,
                name: document.getElementById('customerName').value,
                address: document.getElementById('customerAddress').value,
                telephone: document.getElementById('customerTelephone').value,
                billAmount: document.getElementById('customerBillAmount').value || 0
            };
            
            console.log('Customer data:', formData);
            alert('Customer saved successfully!');
            closeModal();
            
            // Here you would typically send the data to your server
            // location.reload(); // Reload to show new customer
        });

        // Close modal when clicking outside
        window.addEventListener('click', function(e) {
            const modal = document.getElementById('customerModal');
            if (e.target === modal) {
                closeModal();
            }
        });

        // Keyboard shortcuts
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                closeModal();
            }
            if (e.ctrlKey && e.key === 'n') {
                e.preventDefault();
                openAddModal();
            }
        });
    </script>
</body>
</html>