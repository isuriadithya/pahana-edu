<%@ page import="java.time.LocalDate, java.time.format.DateTimeFormatter" %>
<%@ page import="com.bookshop.model.UserModel" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Help & Support - Pahana Edu Bookshop</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        /* Reset and Base Styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: #333;
            line-height: 1.6;
        }

        /* Header Styles */
        .header {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 1rem 2rem;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 3px solid #667eea;
        }

        .header h1 {
            color: #667eea;
            font-size: 1.8rem;
            font-weight: 700;
        }

        .header h1 i {
            margin-right: 0.5rem;
            color: #764ba2;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 1rem;
            color: #555;
        }

        .user-info span {
            padding: 0.5rem 1rem;
            background: rgba(102, 126, 234, 0.1);
            border-radius: 25px;
            font-weight: 500;
        }

        .logout-btn {
            background: linear-gradient(135deg, #ff6b6b, #ee5a24);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 600;
            transition: transform 0.3s ease;
        }

        .logout-btn:hover {
            transform: translateY(-2px);
            color: white;
            text-decoration: none;
        }

        /* Container */
        .container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1rem;
        }

        /* Page Title */
        .page-title {
            text-align: center;
            margin-bottom: 2rem;
        }

        .page-title h2 {
            color: white;
            font-size: 2.5rem;
            font-weight: 700;
            text-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
            margin-bottom: 0.5rem;
        }

        .page-title p {
            color: rgba(255, 255, 255, 0.9);
            font-size: 1.1rem;
        }

        /* Help Content */
        .help-content {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            padding: 2rem;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        /* Navigation */
        .help-nav {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            border: 2px solid rgba(102, 126, 234, 0.1);
        }

        .help-nav h3 {
            color: #667eea;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .nav-buttons {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
        }

        .nav-btn {
            padding: 12px 20px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            text-align: center;
        }

        .nav-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
            color: white;
            text-decoration: none;
        }

        /* Help Sections */
        .help-section {
            margin-bottom: 3rem;
            padding-bottom: 2rem;
            border-bottom: 2px solid #e9ecef;
        }

        .help-section:last-child {
            border-bottom: none;
        }

        .help-section h3 {
            color: #667eea;
            font-size: 1.8rem;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .help-section h4 {
            color: #764ba2;
            font-size: 1.3rem;
            margin: 1.5rem 0 0.8rem 0;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .step-list {
            list-style: none;
            padding: 0;
        }

        .step-list li {
            background: rgba(102, 126, 234, 0.05);
            margin-bottom: 1rem;
            padding: 1rem;
            border-radius: 10px;
            border-left: 4px solid #667eea;
            position: relative;
        }

        .step-number {
            background: #667eea;
            color: white;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin-right: 1rem;
            font-size: 0.9rem;
        }

        .feature-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
            margin: 1.5rem 0;
        }

        .feature-card {
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.1), rgba(118, 75, 162, 0.1));
            padding: 1.5rem;
            border-radius: 15px;
            border: 1px solid rgba(102, 126, 234, 0.2);
        }

        .feature-card h5 {
            color: #667eea;
            margin-bottom: 0.8rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .tips-box {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            padding: 1.5rem;
            border-radius: 15px;
            margin: 1.5rem 0;
        }

        .tips-box h4 {
            color: white;
            margin-bottom: 1rem;
        }

        .warning-box {
            background: linear-gradient(135deg, #ffc107, #fd7e14);
            color: #333;
            padding: 1.5rem;
            border-radius: 15px;
            margin: 1.5rem 0;
        }

        .warning-box h4 {
            color: #333;
            margin-bottom: 1rem;
        }

        .faq-item {
            background: rgba(248, 249, 250, 0.8);
            margin-bottom: 1rem;
            border-radius: 10px;
            overflow: hidden;
            border: 1px solid #e9ecef;
        }

        .faq-question {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 1rem;
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-weight: 600;
        }

        .faq-answer {
            padding: 1.5rem;
            display: none;
            color: #555;
        }

        .faq-answer.active {
            display: block;
        }

        .contact-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin: 1.5rem 0;
        }

        .contact-card {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 2rem;
            border-radius: 15px;
            text-align: center;
        }

        .contact-card i {
            font-size: 2.5rem;
            margin-bottom: 1rem;
        }

        .contact-card h4 {
            color: white;
            margin-bottom: 1rem;
        }

        /* Footer */
        .footer {
            background: rgba(0, 0, 0, 0.1);
            color: rgba(255, 255, 255, 0.8);
            text-align: center;
            padding: 1.5rem;
            margin-top: 3rem;
            backdrop-filter: blur(10px);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                gap: 1rem;
                padding: 1rem;
            }

            .user-info {
                flex-direction: column;
                gap: 0.5rem;
            }

            .page-title h2 {
                font-size: 2rem;
            }

            .help-content {
                padding: 1rem;
                margin: 0.5rem;
            }

            .nav-buttons {
                grid-template-columns: 1fr;
            }
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
%>

 <!-- Header -->
    <header class="header">
        <div class="breadcrumb">
            <a href="/pahana-online/view/dashboard/dashboard.jsp">
                <i class="fas fa-home"></i> Dashboard
            </a>
            <span>Help & Support</span>
        </div>
        <h1><i class="fas fa-life-ring"></i> Help & Support</h1>
    </header>


    <div class="help-content">
        <!-- Quick Navigation -->
        <div class="help-nav">
            <h3><i class="fas fa-compass"></i> Quick Navigation</h3>
            <div class="nav-buttons">
                <a href="#getting-started" class="nav-btn">
                    <i class="fas fa-play"></i> Getting Started
                </a>
                <a href="#billing-guide" class="nav-btn">
                    <i class="fas fa-file-invoice"></i> Billing Guide
                </a>
                <a href="#features" class="nav-btn">
                    <i class="fas fa-star"></i> Features
                </a>
                <a href="#faq" class="nav-btn">
                    <i class="fas fa-question"></i> FAQ
                </a>
                <a href="#contact" class="nav-btn">
                    <i class="fas fa-phone"></i> Contact Support
                </a>
                <a href="dashboard.jsp" class="nav-btn">
                    <i class="fas fa-home"></i> Back to Dashboard
                </a>
            </div>
        </div>

        <!-- Getting Started -->
        <div class="help-section" id="getting-started">
            <h3><i class="fas fa-rocket"></i> Getting Started</h3>
            <p>Welcome to the Pahana Edu Bookshop Billing System! This comprehensive guide will help you master all features of our billing platform.</p>

            <h4><i class="fas fa-list-check"></i> System Overview</h4>
            <div class="feature-grid">
                <div class="feature-card">
                    <h5><i class="fas fa-users"></i> Customer Management</h5>
                    <p>Add, edit, and manage customer accounts with detailed information including contact details and billing history.</p>
                </div>
                <div class="feature-card">
                    <h5><i class="fas fa-boxes"></i> Item Management</h5>
                    <p>Maintain your product catalog with descriptions, prices, and inventory tracking capabilities.</p>
                </div>
                <div class="feature-card">
                    <h5><i class="fas fa-receipt"></i> Bill Generation</h5>
                    <p>Create professional invoices with automatic calculations, tax handling, and multiple payment options.</p>
                </div>
                <div class="feature-card">
                    <h5><i class="fas fa-print"></i> Print & Export</h5>
                    <p>Generate print-ready invoices and export data for accounting and record-keeping purposes.</p>
                </div>
            </div>
        </div>

        <!-- Billing Guide -->
        <div class="help-section" id="billing-guide">
            <h3><i class="fas fa-book"></i> Complete Billing Guide</h3>

            <h4><i class="fas fa-user-plus"></i> Step 1: Managing Customers</h4>
            <ol class="step-list">
                <li>
                    <span class="step-number">1</span>
                    <strong>Navigate to Customer Management:</strong> From the dashboard, click on "Manage Customers" or use the quick action "Add Customer".
                </li>
                <li>
                    <span class="step-number">2</span>
                    <strong>Add New Customer:</strong> Fill in customer details including name, address, phone, and email. All fields marked with * are required.
                </li>
                <li>
                    <span class="step-number">3</span>
                    <strong>Save Customer:</strong> Click "Save Customer" to add them to your database. They will now appear in billing dropdowns.
                </li>
            </ol>

            <h4><i class="fas fa-box"></i> Step 2: Managing Items</h4>
            <ol class="step-list">
                <li>
                    <span class="step-number">1</span>
                    <strong>Access Item Management:</strong> Go to "Manage Items" from the dashboard or use the "Add Item" quick action.
                </li>
                <li>
                    <span class="step-number">2</span>
                    <strong>Add Products/Services:</strong> Enter item name, description, unit price, and any relevant details.
                </li>
                <li>
                    <span class="step-number">3</span>
                    <strong>Update Inventory:</strong> Regularly update item information and prices to maintain accuracy.
                </li>
            </ol>

            <h4><i class="fas fa-file-invoice-dollar"></i> Step 3: Creating Bills</h4>
            <ol class="step-list">
                <li>
                    <span class="step-number">1</span>
                    <strong>Select Customer:</strong> Choose the customer from the dropdown menu. If the customer doesn't exist, add them first.
                </li>
                <li>
                    <span class="step-number">2</span>
                    <strong>Add Items:</strong> Select items from the dropdown. Each item will be added to the bill with a default quantity of 1.
                </li>
                <li>
                    <span class="step-number">3</span>
                    <strong>Adjust Quantities:</strong> Modify quantities as needed using the quantity input fields.
                </li>
                <li>
                    <span class="step-number">4</span>
                    <strong>Review Summary:</strong> Check the bill summary showing subtotal, tax (10%), and total amount.
                </li>
                <li>
                    <span class="step-number">5</span>
                    <strong>Save & Print:</strong> Click "Save Bill" to generate the invoice. You'll get an option to print immediately.
                </li>
            </ol>

            <div class="tips-box">
                <h4><i class="fas fa-lightbulb"></i> Pro Tips</h4>
                <ul>
                    <li>Always verify customer information before generating bills</li>
                    <li>Double-check quantities and prices before saving</li>
                    <li>Use the print preview to ensure bill formatting is correct</li>
                    <li>Keep backup copies of important bills</li>
                    <li>Regularly update item prices to reflect current rates</li>
                </ul>
            </div>
        </div>

        <!-- Features -->
        <div class="help-section" id="features">
            <h3><i class="fas fa-star"></i> System Features</h3>

            <h4><i class="fas fa-calculator"></i> Automatic Calculations</h4>
            <p>The system automatically calculates:</p>
            <ul>
                <li>Line totals (quantity × unit price)</li>
                <li>Subtotals for all items</li>
                <li>Tax calculations (10% default)</li>
                <li>Final total amounts</li>
            </ul>

            <h4><i class="fas fa-print"></i> Professional Invoicing</h4>
            <p>Generate professional bills with:</p>
            <ul>
                <li>Company branding and logo</li>
                <li>Customer information display</li>
                <li>Itemized billing details</li>
                <li>Payment terms and conditions</li>
            </ul>

            <h4><i class="fas fa-database"></i> Data Management</h4>
            <p>Robust data handling including:</p>
            <ul>
                <li>Secure database storage</li>
                <li>Automatic backup systems</li>
                <li>Data validation and error checking</li>
                <li>Historical record keeping</li>
            </ul>

            <div class="warning-box">
                <h4><i class="fas fa-exclamation-triangle"></i> Important Notes</h4>
                <ul>
                    <li>Always save your work before closing the browser</li>
                    <li>Ensure customer and item data is accurate before billing</li>
                    <li>Regular system backups are recommended</li>
                    <li>Contact support for any technical issues</li>
                </ul>
            </div>
        </div>

        <!-- FAQ -->
        <div class="help-section" id="faq">
            <h3><i class="fas fa-question-circle"></i> Frequently Asked Questions</h3>

            <div class="faq-item">
                <div class="faq-question" onclick="toggleFAQ(this)">
                    How do I add a new customer to the system?
                    <i class="fas fa-chevron-down"></i>
                </div>
                <div class="faq-answer">
                    Navigate to "Manage Customers" from the dashboard, click "Add New Customer", fill in the required information (name, address, contact details), and click "Save Customer". The customer will then be available in the billing dropdown.
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question" onclick="toggleFAQ(this)">
                    Can I modify a bill after it's been saved?
                    <i class="fas fa-chevron-down"></i>
                </div>
                <div class="faq-answer">
                    Currently, bills cannot be modified once saved to maintain data integrity. If changes are needed, create a new bill or contact your system administrator for assistance with corrections.
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question" onclick="toggleFAQ(this)">
                    How is tax calculated on bills?
                    <i class="fas fa-chevron-down"></i>
                </div>
                <div class="faq-answer">
                    The system applies a standard 10% tax rate to the subtotal of all items. Tax is calculated as: (Subtotal × 10%) and added to get the final total amount.
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question" onclick="toggleFAQ(this)">
                    What should I do if the system is running slowly?
                    <i class="fas fa-chevron-down"></i>
                </div>
                <div class="faq-answer">
                    Try refreshing your browser, clearing browser cache, or restarting your browser. If the issue persists, contact technical support. Ensure you have a stable internet connection.
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question" onclick="toggleFAQ(this)">
                    How do I print bills?
                    <i class="fas fa-chevron-down"></i>
                </div>
                <div class="faq-answer">
                    After saving a bill, you'll get an immediate print option. You can also view all bills using "View All Bills" and click the print button next to any bill. Bills are formatted for standard A4 paper printing.
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question" onclick="toggleFAQ(this)">
                    Can I export bill data for accounting?
                    <i class="fas fa-chevron-down"></i>
                </div>
                <div class="faq-answer">
                    While direct export isn't available in this version, you can print bills to PDF using your browser's print function, or contact support about implementing export features for your specific needs.
                </div>
            </div>
        </div>

        <!-- Contact Support -->
        <div class="help-section" id="contact">
            <h3><i class="fas fa-phone"></i> Contact Support</h3>
            <p>Need additional help? Our support team is here to assist you!</p>

            <div class="contact-cards">
                <div class="contact-card">
                    <i class="fas fa-phone"></i>
                    <h4>Phone Support</h4>
                    <p>+94 70 1234567</p>
                    <p>Mon-Fri: 9:00 AM - 6:00 PM</p>
                </div>
                <div class="contact-card">
                    <i class="fas fa-envelope"></i>
                    <h4>Email Support</h4>
                    <p>support@pahanaedu.lk</p>
                    <p>Response within 24 hours</p>
                </div>
                <div class="contact-card">
                    <i class="fas fa-map-marker-alt"></i>
                    <h4>Visit Us</h4>
                    <p>Pahana Edu Bookshop</p>
                    <p>Negombo, Western Province</p>
                    <p>Sri Lanka</p>
                </div>
            </div>

            <div class="tips-box">
                <h4><i class="fas fa-info-circle"></i> When Contacting Support</h4>
                <ul>
                    <li>Describe the issue clearly with step-by-step details</li>
                    <li>Include any error messages you're seeing</li>
                    <li>Mention your browser type and version</li>
                    <li>Provide screenshots if possible</li>
                    <li>Include your user account information</li>
                </ul>
            </div>
        </div>
    </div>
</div>

<!-- Footer -->
<footer class="footer">
    <p>&copy; <%= year %> Pahana Edu Bookshop. All rights reserved.</p>
</footer>

<script>
    // FAQ Toggle Functionality
    function toggleFAQ(element) {
        const answer = element.nextElementSibling;
        const icon = element.querySelector('i');
        
        if (answer.classList.contains('active')) {
            answer.classList.remove('active');
            icon.classList.remove('fa-chevron-up');
            icon.classList.add('fa-chevron-down');
        } else {
            // Close all other FAQs
            document.querySelectorAll('.faq-answer.active').forEach(item => {
                item.classList.remove('active');
            });
            document.querySelectorAll('.faq-question i').forEach(icon => {
                icon.classList.remove('fa-chevron-up');
                icon.classList.add('fa-chevron-down');
            });
            
            // Open clicked FAQ
            answer.classList.add('active');
            icon.classList.remove('fa-chevron-down');
            icon.classList.add('fa-chevron-up');
        }
    }

    // Smooth scrolling for navigation links
    document.addEventListener('DOMContentLoaded', function() {
        const navLinks = document.querySelectorAll('a[href^="#"]');
        navLinks.forEach(link => {
            link.addEventListener('click', function(e) {
                e.preventDefault();
                const targetId = this.getAttribute('href');
                const targetElement = document.querySelector(targetId);
                if (targetElement) {
                    targetElement.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });
    });
</script>

</body>
</html>