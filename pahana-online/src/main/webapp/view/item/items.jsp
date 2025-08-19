<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.bookshop.model.UserModel" %>
<%@ page import="com.bookshop.model.Item" %>
<%@ page import="com.bookshop.dao.ItemDAO" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Item Management - Inventory System</title>
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

        /* Item Grid */
        .item-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .item-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            padding: 1.5rem;
            border-radius: 15px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            border-left: 4px solid #667eea;
        }

        .item-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
        }

        .item-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1rem;
        }

        .item-avatar {
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

        .item-name {
            font-size: 1.2rem;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 0.25rem;
        }

        .item-id {
            font-size: 0.85rem;
            color: #6b7280;
            background: #f3f4f6;
            padding: 0.25rem 0.5rem;
            border-radius: 20px;
        }

        .item-details {
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

        .item-actions {
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

            .item-grid {
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

        .status-instock {
            background: #dcfce7;
            color: #166534;
        }

        .status-lowstock {
            background: #fef3c7;
            color: #92400e;
        }

        .status-outofstock {
            background: #fee2e2;
            color: #991b1b;
        }

        /* Alert Messages */
        .alert {
            padding: 1rem;
            border-radius: 10px;
            margin-bottom: 1rem;
            font-weight: 500;
        }

        .alert-success {
            background: #dcfce7;
            color: #166534;
            border: 1px solid #bbf7d0;
        }

        .alert-error {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fecaca;
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

    // ✅ Fetch items from DB
    ItemDAO itemDAO = new ItemDAO();
    List<Item> items = itemDAO.getAllItems();

    // Check for messages
    String message = (String) session.getAttribute("message");
    String messageType = (String) session.getAttribute("messageType");
    if (message != null) {
        session.removeAttribute("message");
        session.removeAttribute("messageType");
    }
%>

    <!-- Header -->
    <header class="header">
        <div class="breadcrumb">
            <a href="/pahana-online/view/dashboard/dashboard.jsp">
                <i class="fas fa-home"></i> Dashboard
            </a>
            <span>Item Management</span>
        </div>
        <h1><i class="fas fa-boxes"></i> Manage Items</h1>
    </header>

    <!-- Main -->
    <div class="container">
        <!-- Alert Messages -->
        <% if (message != null) { %>
            <div class="alert alert-<%= messageType %>">
                <%= message %>
            </div>
        <% } %>

        <div class="action-bar">
            <div class="search-box">
                <i class="fas fa-search"></i>
                <input type="text" id="searchInput" placeholder="Search items by name, ID, or description...">
            </div>
            <div style="display: flex; gap: 1rem; align-items: center;">
                <button class="btn btn-secondary" onclick="exportItems()">
                    <i class="fas fa-download"></i> Export
                </button>
                <button class="btn btn-primary" onclick="openAddModal()">
                    <i class="fas fa-plus"></i> Add Item
                </button>
            </div>
        </div>

        <!-- Item Cards -->
        <div class="item-grid" id="itemGrid">
            <% if (items != null && !items.isEmpty()) {
                   for (Item item : items) { 
                       String stockStatus = "";
                       String stockClass = "";
                       if (item.getQuantity() == 0) {
                           stockStatus = "Out of Stock";
                           stockClass = "status-outofstock";
                       } else if (item.getQuantity() < 10) {
                           stockStatus = "Low Stock";
                           stockClass = "status-lowstock";
                       } else {
                           stockStatus = "In Stock";
                           stockClass = "status-instock";
                       }
            %>
            <div class="item-card" 
                 data-item-id="<%= item.getItemId() %>" 
                 data-name="<%= item.getName() %>"
                 data-description="<%= item.getDescription() %>"
                 data-price="<%= item.getPrice() %>"
                 data-quantity="<%= item.getQuantity() %>">

                <div class="item-header">
                    <div style="display: flex; align-items: center; gap: 1rem;">
                        <div class="item-avatar">
                            <%= item.getName().substring(0, 1).toUpperCase() %>
                        </div>
                        <div>
                            <div class="item-name"><%= item.getName() %></div>
                            <div class="item-id">ID: <%= item.getItemId() %></div>
                        </div>
                    </div>
                    <span class="status-badge <%= stockClass %>">
                        <%= stockStatus %>
                    </span>
                </div>
                
                <div class="item-details">
                    <div class="detail-item">
                        <i class="fas fa-tag"></i>
                        <span>Price: ₹<%= String.format("%.2f", item.getPrice()) %></span>
                    </div>
                    <div class="detail-item">
                        <i class="fas fa-boxes"></i>
                        <span>Quantity: <%= item.getQuantity() %> units</span>
                    </div>
                    <div class="detail-item">
                        <i class="fas fa-info-circle"></i>
                        <span><%= item.getDescription() %></span>
                    </div>
                    <div class="detail-item">
                        <i class="fas fa-calculator"></i>
                        <span>Total Value: ₹<%= String.format("%.2f", item.getPrice() * item.getQuantity()) %></span>
                    </div>
                </div>
                
                <div class="item-actions">
                   <button class="btn btn-view btn-sm" onclick="openModal('view', <%= item.getItemId() %>)">
    				<i class="fas fa-eye"></i> View
					</button>
					<button class="btn btn-edit btn-sm" onclick="openModal('edit', <%= item.getItemId() %>)">
    				<i class="fas fa-edit"></i> Edit
					</button>
                    <a href="<%=request.getContextPath()%>/item?action=delete&itemId=<%= item.getItemId() %>" 
   					class="btn btn-delete btn-sm" 
   					onclick="return confirm('Delete item <%= item.getName() %>?');">
   				 <i class="fas fa-trash"></i> Delete
				</a>
                </div>
            </div>
            <%   }
               } else { %>
            <div class="empty-state">
                <i class="fas fa-boxes"></i>
                <h3>No Items Found</h3>
                <p>Start by adding your first item to the inventory</p>
                <button class="btn btn-primary" onclick="openAddModal()">
                    <i class="fas fa-plus"></i> Add First Item
                </button>
            </div>
            <% } %>
        </div>
    </div>

   <!-- Item Modal (Add/Edit/View) -->
<div id="itemModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2 class="modal-title" id="modalTitle">Item</h2>
            <button class="close-btn" onclick="closeModal()">&times;</button>
        </div>
        <form id="itemForm" method="post" action="/pahana-online/item">
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
function openModal(mode, itemId) {
    const card = document.querySelector(`.item-card[data-item-id='${itemId}']`);
    if (!card) return;

    const name = card.dataset.name;
    const description = card.dataset.description;
    const price = card.dataset.price;
    const quantity = card.dataset.quantity;

    const modalTitle = document.getElementById('modalTitle');
    const modalBody = document.getElementById('modalBody');
    const formAction = document.getElementById('formAction');
    const submitBtn = document.getElementById('modalSubmitBtn');

    if (mode === 'view') {
        modalTitle.textContent = 'View Item';
        formAction.value = '';
        submitBtn.style.display = 'none'; // hide save button
        modalBody.innerHTML = `
            <div class="detail-item"><strong>Item ID:</strong> ${itemId}</div>
            <div class="detail-item"><strong>Name:</strong> ${name}</div>
            <div class="detail-item"><strong>Description:</strong> ${description}</div>
            <div class="detail-item"><strong>Price:</strong> ₹${parseFloat(price).toFixed(2)}</div>
            <div class="detail-item"><strong>Quantity:</strong> ${quantity} units</div>
            <div class="detail-item"><strong>Total Value:</strong> ₹${(parseFloat(price) * parseInt(quantity)).toFixed(2)}</div>
        `;
    } else if (mode === 'edit') {
        modalTitle.textContent = 'Edit Item';
        formAction.value = 'update';
        submitBtn.style.display = 'inline-flex';
        modalBody.innerHTML = `
            <div class="form-group">
                <label class="form-label">Item ID</label>
                <input type="number" class="form-input" name="itemId" value="${itemId}" readonly>
            </div>
            <div class="form-group">
                <label class="form-label">Name</label>
                <input type="text" class="form-input" name="name" value="${name}" required>
            </div>
            <div class="form-group">
                <label class="form-label">Description</label>
                <input type="text" class="form-input" name="description" value="${description}" required>
            </div>
            <div class="form-group">
                <label class="form-label">Price (₹)</label>
                <input type="number" step="0.01" class="form-input" name="price" value="${price}" required>
            </div>
            <div class="form-group">
                <label class="form-label">Quantity</label>
                <input type="number" class="form-input" name="quantity" value="${quantity}" required>
            </div>
        `;
    }

    document.getElementById('itemModal').style.display = 'block';
}

function closeModal() {
    document.getElementById('itemModal').style.display = 'none';
}

// Close modal by clicking outside
window.addEventListener('click', function(e) {
    const modal = document.getElementById('itemModal');
    if (e.target === modal) {
        closeModal();
    }
});

function openAddModal() {
    const modalTitle = document.getElementById('modalTitle');
    const modalBody = document.getElementById('modalBody');
    const formAction = document.getElementById('formAction');
    const submitBtn = document.getElementById('modalSubmitBtn');

    modalTitle.textContent = 'Add New Item';
    formAction.value = 'add';  // form action for ItemController
    submitBtn.style.display = 'inline-flex'; // show Save button

    modalBody.innerHTML = `
        <div class="form-group">
            <label class="form-label">Item ID *</label>
            <input type="number" class="form-input" name="itemId" required>
        </div>
        <div class="form-group">
            <label class="form-label">Item Name *</label>
            <input type="text" class="form-input" name="name" required>
        </div>
        <div class="form-group">
            <label class="form-label">Description *</label>
            <input type="text" class="form-input" name="description" required>
        </div>
        <div class="form-group">
            <label class="form-label">Price (₹) *</label>
            <input type="number" step="0.01" class="form-input" name="price" required>
        </div>
        <div class="form-group">
            <label class="form-label">Quantity *</label>
            <input type="number" class="form-input" name="quantity" required>
        </div>
    `;

    document.getElementById('itemForm').reset();
    document.getElementById('itemModal').style.display = 'block';
}

// Search functionality
document.getElementById('searchInput').addEventListener('keyup', function() {
    const searchTerm = this.value.toLowerCase();
    const itemCards = document.querySelectorAll('.item-card');
    
    itemCards.forEach(card => {
        const name = card.dataset.name.toLowerCase();
        const description = card.dataset.description.toLowerCase();
        const itemId = card.dataset.itemId.toLowerCase();
        
        if (name.includes(searchTerm) || description.includes(searchTerm) || itemId.includes(searchTerm)) {
            card.style.display = 'block';
        } else {
            card.style.display = 'none';
        }
    });
});

function exportItems() {
    // Simple export functionality - you can enhance this
    alert('Export functionality would be implemented here');
}

// Auto-hide alert messages after 5 seconds
window.addEventListener('DOMContentLoaded', function() {
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        setTimeout(() => {
            alert.style.opacity = '0';
            setTimeout(() => {
                alert.remove();
            }, 300);
        }, 5000);
    });
});
</script>

</body>
</html>