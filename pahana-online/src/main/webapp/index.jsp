<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Billing Management System</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 1rem;
        }

        /* Background Animation */
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: 
                radial-gradient(circle at 20% 50%, rgba(120, 119, 198, 0.3) 0%, transparent 50%),
                radial-gradient(circle at 80% 20%, rgba(255, 119, 198, 0.3) 0%, transparent 50%),
                radial-gradient(circle at 40% 80%, rgba(120, 219, 255, 0.3) 0%, transparent 50%);
            animation: bgAnimation 20s ease infinite;
            z-index: -1;
        }

        @keyframes bgAnimation {
            0%, 100% { transform: scale(1) rotate(0deg); }
            50% { transform: scale(1.1) rotate(180deg); }
        }

        .login-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            padding: 3rem;
            border-radius: 25px;
            box-shadow: 
                0 25px 50px rgba(0, 0, 0, 0.25),
                0 0 0 1px rgba(255, 255, 255, 0.2);
            width: 100%;
            max-width: 450px;
            position: relative;
            overflow: hidden;
            animation: slideUp 0.8s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .login-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2, #667eea);
            background-size: 200% 100%;
            animation: gradientMove 3s ease infinite;
        }

        @keyframes gradientMove {
            0%, 100% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
        }

        .login-header {
            text-align: center;
            margin-bottom: 2.5rem;
        }

        .login-logo {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 50%;
            margin-bottom: 1.5rem;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
            animation: pulse 2s ease-in-out infinite alternate;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            100% { transform: scale(1.05); }
        }

        .login-logo i {
            font-size: 2.5rem;
            color: white;
        }

        .login-title {
            font-size: 2.2rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 0.5rem;
            background: linear-gradient(135deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .login-subtitle {
            color: #666;
            font-size: 1.1rem;
            font-weight: 400;
        }

        .login-form {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .form-group {
            position: relative;
        }

        .form-group i {
            position: absolute;
            left: 1.2rem;
            top: 50%;
            transform: translateY(-50%);
            color: #667eea;
            font-size: 1.1rem;
            z-index: 1;
        }

        .form-input {
            width: 100%;
            padding: 1.2rem 1.2rem 1.2rem 3.5rem;
            border: 2px solid rgba(102, 126, 234, 0.2);
            border-radius: 15px;
            font-size: 1rem;
            font-weight: 400;
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(10px);
            transition: all 0.3s ease;
            outline: none;
        }

        .form-input:focus {
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
            transform: translateY(-2px);
        }

        .form-input::placeholder {
            color: #999;
            font-weight: 400;
        }

        .login-button {
            width: 100%;
            padding: 1.2rem;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border: none;
            color: white;
            font-size: 1.1rem;
            font-weight: 600;
            border-radius: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            margin-top: 0.5rem;
        }

        .login-button::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.6s ease;
        }

        .login-button:hover::before {
            left: 100%;
        }

        .login-button:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(102, 126, 234, 0.4);
        }

        .login-button:active {
            transform: translateY(-1px);
        }

        .login-button:disabled {
            opacity: 0.7;
            cursor: not-allowed;
            transform: none;
        }

        /* Loading state */
        .login-button.loading {
            pointer-events: none;
        }

        .login-button.loading::after {
            content: '';
            position: absolute;
            width: 20px;
            height: 20px;
            border: 2px solid transparent;
            border-top: 2px solid white;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
        }

        @keyframes spin {
            0% { transform: translate(-50%, -50%) rotate(0deg); }
            100% { transform: translate(-50%, -50%) rotate(360deg); }
        }

        .error-message {
            background: rgba(244, 67, 54, 0.1);
            color: #c62828;
            padding: 1rem 1.5rem;
            border-radius: 12px;
            margin-top: 1rem;
            text-align: center;
            font-weight: 500;
            border: 1px solid rgba(244, 67, 54, 0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            animation: shake 0.5s ease-in-out;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }

        .error-message i {
            font-size: 1.1rem;
        }

        .login-footer {
            text-align: center;
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 1px solid rgba(0, 0, 0, 0.1);
        }

        .login-footer p {
            color: #666;
            font-size: 0.9rem;
        }

        .forgot-password {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s ease;
        }

        .forgot-password:hover {
            color: #764ba2;
            text-decoration: underline;
        }

        /* Responsive Design */
        @media (max-width: 480px) {
            .login-container {
                padding: 2rem 1.5rem;
                margin: 1rem;
            }

            .login-title {
                font-size: 1.8rem;
            }

            .login-subtitle {
                font-size: 1rem;
            }

            .form-input {
                padding: 1rem 1rem 1rem 3rem;
            }

            .login-button {
                padding: 1rem;
                font-size: 1rem;
            }
        }

        /* Success Animation */
        .success-checkmark {
            display: none;
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: #4CAF50;
            position: relative;
            margin: 0 auto 1rem;
        }

        .success-checkmark.show {
            display: block;
            animation: successPulse 0.6s ease-in-out;
        }

        .success-checkmark::after {
            content: '✓';
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: white;
            font-size: 2.5rem;
            font-weight: bold;
        }

        @keyframes successPulse {
            0% {
                transform: scale(0);
                opacity: 0;
            }
            50% {
                transform: scale(1.1);
            }
            100% {
                transform: scale(1);
                opacity: 1;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <div class="login-logo">
                <i class="fas fa-calculator"></i>
            </div>
            <h1 class="login-title">Welcome Back</h1>
            <p class="login-subtitle">Sign in to your billing management system</p>
        </div>

        <div class="success-checkmark" id="successCheckmark"></div>

        <form class="login-form" action="auth" method="post" id="loginForm">
            <div class="form-group">
                <i class="fas fa-user"></i>
                <input type="text" name="username" class="form-input" placeholder="Enter your username" required>
            </div>

            <div class="form-group">
                <i class="fas fa-lock"></i>
                <input type="password" name="password" class="form-input" placeholder="Enter your password" required>
            </div>

            <button type="submit" class="login-button" id="loginButton">
                <span>Sign In</span>
            </button>

            <!-- Show error message if login fails -->
            <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="error-message">
                <i class="fas fa-exclamation-circle"></i>
                <%= request.getAttribute("errorMessage") %>
            </div>
            <% } %>
        </form>

        <div class="login-footer">
            <p>
                Forgot your password? 
                <a href="#" class="forgot-password">Reset here</a>
            </p>
        </div>
    </div>

    <script>
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            const button = document.getElementById('loginButton');
            const buttonText = button.querySelector('span');
            
            // Add loading state
            button.classList.add('loading');
            buttonText.style.opacity = '0';
            
            // Simulate processing time (remove this in production)
            setTimeout(() => {
                // In real implementation, this would be handled by the server
                // For demo purposes, we'll show success for any non-empty credentials
                const username = document.querySelector('input[name="username"]').value;
                const password = document.querySelector('input[name="password"]').value;
                
                if (username && password) {
                    // Show success animation
                    document.getElementById('successCheckmark').classList.add('show');
                    
                    // Redirect after animation
                    setTimeout(() => {
                        // This would normally be handled by the server redirect
                        window.location.href = 'view/dashboard/dashboard.jsp';
                    }, 1500);
                    
                    return false; // Prevent actual form submission for demo
                }
            }, 1000);
        });

        // Add floating label effect
        document.querySelectorAll('.form-input').forEach(input => {
            input.addEventListener('focus', function () {
                this.parentNode.classList.add('focused');
            });

            input.addEventListener('blur', function () {
                if (!this.value) {
                    this.parentNode.classList.remove('focused');
                }
            });
        });

        // Optional: Restore button state on page reload or failed login
        window.addEventListener('load', function () {
            const button = document.getElementById('loginButton');
            const buttonText = button.querySelector('span');
            button.classList.remove('loading');
            if (buttonText) {
                buttonText.style.opacity = '1';
            }
        });
    </script>
</body>
</html>
