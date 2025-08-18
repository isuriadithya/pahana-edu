<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.bookshop.model.Item" %>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Items - Bookshop</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .gradient-bg {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .card {
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        .btn-primary {
            background: linear-gradient(45deg, #667eea, #764ba2);
            border: none;
        }
        .btn-primary:hover {
            background: linear-gradient(45deg, #5a67d8, #68578c);
        }
    </style>
</head>
<body class="gradient-bg">
    <div class="container py-5">
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header bg-white border-0 pt-4">
                        <div class="d-flex align-items-center mb-3">
                            <div class="bg-primary text-white rounded p-2 me-3">
                                <i class="fas fa-boxes fa-2x"></i>
                            </div>
                            <div>
                                <h2 class="mb-0">Manage Items</h2>
                                <p class="text-muted mb-0">Comprehensive item and product management</p>
                            </div>
                        </div>
                        
                        <div class="row text-center">
                            <div class="col-md-3">
                                <div class="d-flex align-items-center justify-content-center">
                                    <i class="fas fa-check-circle text-success me-2"></i>
                                    <span class="text-muted">Add new items/services</span>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="d-flex align-items-center justify-content-center">
                                    <i class="fas fa-check-circle text-success me-2"></i>
                                    <span class="text-muted">Update item information</span>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="d-flex align-items-center justify-content-center">
                                    <i class="fas fa-check-circle text-success me-2"></i>
                                    <span class="text-muted">Delete obsolete items</span>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="d-flex align-items-center justify-content-center">
                                    <i class="fas fa-check-circle text-success me-2"></i>
                                    <span class="text-muted">Set pricing and units</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="card-body">
                        <!-- Success/Error Messages -->
                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle me-2"></i>${successMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Add/Edit Item Form -->
                        <div class="row mb-4">
                            <div class="col-12">
                                <button class="btn btn-primary mb-3" type="button" data-bs-toggle="collapse" data-bs-target="#itemForm">
                                    <i class="fas fa-plus me-2"></i>Add New Item
                                </button>
                                
                                <div class="collapse" id="itemForm">
                                    <div class="card border">
                                        <div class="card-header">
                                            <h5 class="mb-0">
                                                <i class="fas fa-edit me-2"></i>
                                                ${item != null ? 'Edit Item' : 'Add New Item'}
                                            </h5>
                                        </div>
                                        <div class="card-body">
                                            <form action="ItemServlet" method="post">
                                                <input type="hidden" name="action" value="${item != null ? 'update' : 'add'}">
                                                <c:if test="${item != null}">
                                                    <input type="hidden" name="itemId" value="${item.itemId}">
                                                </c:if>
                                                
                                                <div class="row">
                                                    <div class="col-md-6 mb-3">
                                                        <label for="name" class="form-label">Item Name *</label>
                                                        <input type="text" class="form-control" id="name" name="name" 
                                                               value="${item != null ? item.name : ''}" required>
                                                    </div>
                                                    <div class="col-md-6 mb-3">
                                                        <label for="price" class="form-label">Price *</label>
                                                        <div class="input-group">
                                                            <span class="input-group-text">$</span>
                                                            <input type="number" class="form-control" id="price" name="price" 
                                                                   step="0.01" min="0" value="${item != null ? item.price : ''}" required>
                                                        </div>
                                                    </div>
                                                </div>
                                                
                                                <div class="row">
                                                    <div class="col-md-6 mb-3">
                                                        <label for="quantity" class="form-label">Quantity *</label>
                                                        <input type="number" class="form-control" id="quantity" name="quantity" 
                                                               min="0" value="${item != null ? item.quantity : ''}" required>
                                                    </div>
                                                </div>
                                                
                                                <div class="mb-3">
                                                    <label for="description" class="form-label">Description</label>
                                                    <textarea class="form-control" id="description" name="description" 
                                                              rows="3" placeholder="Enter item description...">${item != null ? item.description : ''}</textarea>
                                                </div>
                                                
                                                <div class="d-flex gap-2">
                                                    <button type="submit" class="btn btn-primary">
                                                        <i class="fas fa-save me-2"></i>
                                                        ${item != null ? 'Update Item' : 'Add Item'}
                                                    </button>
                                                    <c:if test="${item != null}">
                                                        <a href="ItemServlet?action=list" class="btn btn-secondary">
                                                            <i class="fas fa-times me-2"></i>Cancel
                                                        </a>
                                                    </c:if>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Items List -->
                        <div class="row">
                            <div class="col-12">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h5><i class="fas fa-list me-2"></i>Items List</h5>
                                    <div class="d-flex gap-2">
                                        <input type="text" id="searchInput" class="form-control" style="width: 250px;" 
                                               placeholder="Search items...">
                                        <button class="btn btn-outline-primary" onclick="searchItems()">
                                            <i class="fas fa-search"></i>
                                        </button>
                                    </div>
                                </div>
                                
                                <div class="table-responsive">
                                    <table class="table table-striped table-hover">
                                        <thead class="table-dark">
                                            <tr>
                                                <th>ID</th>
                                                <th>Name</th>
                                                <th>Description</th>
                                                <th>Price</th>
                                                <th>Quantity</th>
                                                <th>Stock Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody id="itemsTableBody">
                                            <c:choose>
                                                <c:when test="${not empty itemList}">
                                                    <c:forEach var="itemObj" items="${itemList}">
                                                        <tr>
                                                            <td>${itemObj.itemId}</td>
                                                            <td><strong>${itemObj.name}</strong></td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${empty itemObj.description}">
                                                                        <span class="text-muted">No description</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        ${itemObj.description.length() > 50 ? 
                                                                          itemObj.description.substring(0, 50).concat('...') : 
                                                                          itemObj.description}
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <strong class="text-primary">
                                                                    <fmt:formatNumber value="${itemObj.price}" type="currency"/>
                                                                </strong>
                                                            </td>
                                                            <td>
                                                                <span class="badge ${itemObj.quantity > 10 ? 'bg-success' : 
                                                                                   itemObj.quantity > 0 ? 'bg-warning' : 'bg-danger'}">
                                                                    ${itemObj.quantity}
                                                                </span>
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${itemObj.quantity > 10}">
                                                                        <span class="badge bg-success">In Stock</span>
                                                                    </c:when>
                                                                    <c:when test="${itemObj.quantity > 0}">
                                                                        <span class="badge bg-warning">Low Stock</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge bg-danger">Out of Stock</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <div class="btn-group" role="group">
                                                                    <a href="ItemServlet?action=edit&id=${itemObj.itemId}" 
                                                                       class="btn btn-sm btn-outline-primary">
                                                                        <i class="fas fa-edit"></i>
                                                                    </a>
                                                                    <button type="button" class="btn btn-sm btn-outline-danger" 
                                                                            onclick="confirmDelete(${itemObj.itemId}, '${itemObj.name}')">
                                                                        <i class="fas fa-trash"></i>
                                                                    </button>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <tr>
                                                        <td colspan="7" class="text-center text-muted py-4">
                                                            <i class="fas fa-box-open fa-3x mb-3"></i>
                                                            <br>No items found. Start by adding your first item!
                                                        </td>
                                                    </tr>
                                                </c:otherwise>
                                            </c:choose>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Confirm Delete</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete the item "<span id="itemNameToDelete"></span>"?</p>
                    <p class="text-danger"><small>This action cannot be undone.</small></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <a href="#" id="confirmDeleteBtn" class="btn btn-danger">
                        <i class="fas fa-trash me-2"></i>Delete Item
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.1.3/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmDelete(itemId, itemName) {
            document.getElementById('itemNameToDelete').textContent = itemName;
            document.getElementById('confirmDeleteBtn').href = 'ItemServlet?action=delete&id=' + itemId;
            new bootstrap.Modal(document.getElementById('deleteModal')).show();
        }

        function searchItems() {
            const input = document.getElementById('searchInput');
            const filter = input.value.toLowerCase();
            const tbody = document.getElementById('itemsTableBody');
            const rows = tbody.getElementsByTagName('tr');

            for (let i = 0; i < rows.length; i++) {
                const row = rows[i];
                const cells = row.getElementsByTagName('td');
                let found = false;
                
                for (let j = 0; j < cells.length - 1; j++) { // Exclude actions column
                    if (cells[j].textContent.toLowerCase().indexOf(filter) > -1) {
                        found = true;
                        break;
                    }
                }
                
                row.style.display = found ? '' : 'none';
            }
        }

        // Show form if editing
        <c:if test="${item != null}">
            document.getElementById('itemForm').classList.add('show');
        </c:if>

        // Search on Enter key
        document.getElementById('searchInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                searchItems();
            }
        });

        // Real-time search
        document.getElementById('searchInput').addEventListener('input', searchItems);
    </script>
</body>
</html>