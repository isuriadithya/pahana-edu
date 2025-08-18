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
    // Current date
    SimpleDateFormat sdf = new SimpleDateFormat("MMMM dd, yyyy");
    String currentDate = sdf.format(new Date());

    // Get user
    UserModel user = (UserModel) session.getAttribute("username");
    String username = (user != null) ? user.getUsername() : "Admin User";

    // ✅ Fetch customers from DB
    CustomerDAO customerDAO = new CustomerDAO();
    List<Customer> customers = customerDAO.getAllCustomers();
%>

    <!-- Header -->
    <header class="header">
        <div class="breadcrumb">
            <a href="/pahana-online/view/dashboard/dashboard.jsp">
                <i class="fas fa-home"></i> Dashboard
            </a>
            <span>Customer Management</span>
        </div>
        <h1><i class="fas fa-users"></i> Manage Customers</h1>
    </header>

    <!-- Main -->
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

        <!-- Customer Cards -->
        <div class="customer-grid" id="customerGrid">
            <% if (customers != null && !customers.isEmpty()) {
                   for (Customer c : customers) { %>
            <div class="customer-card" data-customer-id="<%= c.getAccountNumber() %>" data-units-consumed="<%= c.getUnitsConsumed() %>">

                <div class="customer-header">
                    <div style="display: flex; align-items: center; gap: 1rem;">
                        <div class="customer-avatar">
                            <%= c.getName().substring(0, 1).toUpperCase() %>
                        </div>
                        <div>
                            <div class="customer-name"><%= c.getName() %></div>
                            <div class="customer-id">ACC: <%= c.getAccountNumber() %></div>
                        </div>
                    </div>
                    <span class="status-badge status-active">
                        ₹<%= c.getBillAmount() %>
                    </span>
                </div>
                
                <div class="customer-details">
                    <div class="detail-item">
                        <i class="fas fa-credit-card"></i>
                        <span>Account: <%= c.getAccountNumber() %></span>
                    </div>
                    <div class="detail-item">
                        <i class="fas fa-phone"></i>
                        <span><%= c.getTelephone() %></span>
                    </div>
                    <div class="detail-item">
                        <i class="fas fa-map-marker-alt"></i>
                        <span><%= c.getAddress() %></span>
                    </div>
                    <div class="detail-item">
                        <i class="fas fa-rupee-sign"></i>
                        <span>Bill Amount: ₹<%= c.getBillAmount() %></span>
                    </div>
                </div>
                
                <div class="customer-actions">
                   <button class="btn btn-view btn-sm" onclick="openModal('view', <%= c.getAccountNumber() %>)">
    				<i class="fas fa-eye"></i> View
					</button>
			<button class="btn btn-edit btn-sm" onclick="openModal('edit', <%= c.getAccountNumber() %>)">
    		<i class="fas fa-edit"></i> Edit
			</button>

                    <a href="<%=request.getContextPath()%>/customer?action=delete&accountNumber=<%= c.getAccountNumber() %>" 
   					class="btn btn-delete btn-sm" 
   					onclick="return confirm('Delete customer <%= c.getName() %>?');">
   				 <i class="fas fa-trash"></i> Delete
				</a>
                </div>
            </div>
            <%   }
               } else { %>
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
    </div>

   <!-- Customer Modal (Add/Edit/View) -->
<div id="customerModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2 class="modal-title" id="modalTitle">Customer</h2>
            <button class="close-btn" onclick="closeModal()">&times;</button>
        </div>
        <form id="customerForm" method="post" action="/pahana-online/customer">
            <input type="hidden" name="action" id="formAction" value="add">
            <div class="form-grid" id="modalBody">
                <!-- Dynamic content inserted here -->
            </div>
            <div class="form-actions" id="modalActions">
                <button type="button" class="btn btn-secondary" onclick="closeModal()">Cancel</button>
                <button type="submit" class="btn btn-primary" id="modalSubmitBtn">
                    <i class="fas fa-save"></i> Save
                </button>
            </div>
        </form>
    </div>
</div>

    

    <!-- JS -->
   <script>
function openModal(mode, accountNumber) {
    const card = document.querySelector(`.customer-card[data-customer-id='${accountNumber}']`);
    if (!card) return;

    const name = card.querySelector('.customer-name').textContent;
    const accNum = card.querySelector('.customer-id').textContent.replace('ACC: ', '');
    const phone = card.querySelector('.detail-item:nth-child(2) span').textContent;
    const address = card.querySelector('.detail-item:nth-child(3) span').textContent;
    const bill = card.querySelector('.detail-item:nth-child(4) span').textContent.replace('Bill Amount: ₹', '');

    const modalTitle = document.getElementById('modalTitle');
    const modalBody = document.getElementById('modalBody');
    const formAction = document.getElementById('formAction');
    const submitBtn = document.getElementById('modalSubmitBtn');

    if (mode === 'view') {
        modalTitle.textContent = 'View Customer';
        formAction.value = '';
        submitBtn.style.display = 'none'; // hide save button
        modalBody.innerHTML = `
            <div class="detail-item"><strong>Account Number:</strong> ${accNum}</div>
            <div class="detail-item"><strong>Name:</strong> ${name}</div>
            <div class="detail-item"><strong>Phone:</strong> ${phone}</div>
            <div class="detail-item"><strong>Address:</strong> ${address}</div>
            <div class="detail-item"><strong>Bill Amount:</strong> ₹${bill}</div>
        `;
    } else if (mode === 'edit') {
        modalTitle.textContent = 'Edit Customer';
        formAction.value = 'update';
        submitBtn.style.display = 'inline-flex';
        modalBody.innerHTML = `
            <div class="form-group">
                <label class="form-label">Account Number</label>
                <input type="number" class="form-input" name="accountNumber" value="${accNum}" readonly>
            </div>
            <div class="form-group">
                <label class="form-label">Name</label>
                <input type="text" class="form-input" name="name" value="${name}" required>
            </div>
            <div class="form-group">
                <label class="form-label">Phone</label>
                <input type="tel" class="form-input" name="telephone" value="${phone}" required>
            </div>
            <div class="form-group">
                <label class="form-label">Address</label>
                <input type="text" class="form-input" name="address" value="${address}" required>
            </div>
            <div class="form-group">
                <label class="form-label">Units Consumed</label>
                <input type="number" class="form-input" name="unitsConsumed" value="${card.dataset.unitsConsumed}" required>
            </div>
        `;
    }

    document.getElementById('customerModal').style.display = 'block';
}

function closeModal() {
    document.getElementById('customerModal').style.display = 'none';
}

// Close modal by clicking outside
window.addEventListener('click', function(e) {
    const modal = document.getElementById('customerModal');
    if (e.target === modal) {
        closeModal();
    }
});

function openAddModal() {
    const modalTitle = document.getElementById('modalTitle');
    const modalBody = document.getElementById('modalBody');
    const formAction = document.getElementById('formAction');
    const submitBtn = document.getElementById('modalSubmitBtn');

    modalTitle.textContent = 'Add New Customer';
    formAction.value = 'add';  // form action for CustomerController
    submitBtn.style.display = 'inline-flex'; // show Save button

    modalBody.innerHTML = `
        <div class="form-group">
            <label class="form-label">Account Number *</label>
            <input type="number" class="form-input" name="accountNumber" required>
        </div>
        <div class="form-group">
            <label class="form-label">Customer Name *</label>
            <input type="text" class="form-input" name="name" required>
        </div>
        <div class="form-group">
            <label class="form-label">Address *</label>
            <input type="text" class="form-input" name="address" required>
        </div>
        <div class="form-group">
            <label class="form-label">Phone Number *</label>
            <input type="tel" class="form-input" name="telephone" required>
        </div>
        <div class="form-group">
            <label class="form-label">Units Consumed *</label>
            <input type="number" class="form-input" name="unitsConsumed" required>
        </div>
    `;

    document.getElementById('customerForm').reset();
    document.getElementById('customerModal').style.display = 'block';
}
</script>

</body>
</html>