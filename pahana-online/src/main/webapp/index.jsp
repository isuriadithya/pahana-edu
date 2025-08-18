<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login & Sign Up - Billing Management System</title>
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

        .auth-container {
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
            min-height: 600px;
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

        .auth-container::before {
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

        .auth-tabs {
            display: flex;
            margin-bottom: 2rem;
            background: rgba(102, 126, 234, 0.1);
            border-radius: 15px;
            padding: 0.5rem;
            position: relative;
        }

        .tab-button {
            flex: 1;
            padding: 0.8rem 1rem;
            background: transparent;
            border: none;
            color: #667eea;
            font-weight: 600;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            z-index: 2;
        }

        .tab-button.active {
            color: white;
        }

        .tab-slider {
            position: absolute;
            top: 0.5rem;
            left: 0.5rem;
            width: calc(50% - 0.5rem);
            height: calc(100% - 1rem);
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 10px;
            transition: transform 0.3s ease;
            z-index: 1;
        }

        .tab-slider.signup {
            transform: translateX(100%);
        }

        .auth-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .auth-logo {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 70px;
            height: 70px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 50%;
            margin-bottom: 1rem;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
            animation: pulse 2s ease-in-out infinite alternate;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            100% { transform: scale(1.05); }
        }

        .auth-logo i {
            font-size: 2rem;
            color: white;
        }

        .auth-title {
            font-size: 1.8rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 0.5rem;
            background: linear-gradient(135deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            transition: opacity 0.3s ease;
        }

        .auth-subtitle {
            color: #666;
            font-size: 1rem;
            font-weight: 400;
            transition: opacity 0.3s ease;
        }

        .form-container {
            position: relative;
            overflow: hidden;
        }

        .auth-form {
            display: flex;
            flex-direction: column;
            gap: 1.2rem;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .auth-form.signup {
            transform: translateX(-100%);
            opacity: 0;
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
        }

        .auth-form.signup.active {
            transform: translateX(0);
            opacity: 1;
            position: relative;
        }

        .auth-form.login.inactive {
            transform: translateX(100%);
            opacity: 0;
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
        }

        .form-row {
            display: flex;
            gap: 1rem;
        }

        .form-group {
            position: relative;
            flex: 1;
        }

        .form-group i {
            position: absolute;
            left: 1.2rem;
            top: 50%;
            transform: translateY(-50%);
            color: #667eea;
            font-size: 1rem;
            z-index: 1;
        }

        .form-input {
            width: 100%;
            padding: 1rem 1rem 1rem 3.2rem;
            border: 2px solid rgba(102, 126, 234, 0.2);
            border-radius: 12px;
            font-size: 0.95rem;
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

        .auth-button {
            width: 100%;
            padding: 1.1rem;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border: none;
            color: white;
            font-size: 1rem;
            font-weight: 600;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            margin-top: 0.5rem;
        }

        .auth-button::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.6s ease;
        }

        .auth-button:hover::before {
            left: 100%;
        }

        .auth-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 30px rgba(102, 126, 234, 0.4);
        }

        .auth-button:active {
            transform: translateY(-1px);
        }

        .auth-button:disabled {
            opacity: 0.7;
            cursor: not-allowed;
            transform: none;
        }

        /* Loading state */
        .auth-button.loading {
            pointer-events: none;
        }

        .auth-button.loading::after {
            content: '';
            position: absolute;
            width: 18px;
            height: 18px;
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

        .error-message, .success-message {
            padding: 0.8rem 1.2rem;
            border-radius: 10px;
            margin-top: 1rem;
            text-align: center;
            font-weight: 500;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            animation: shake 0.5s ease-in-out;
        }

        .error-message {
            background: rgba(244, 67, 54, 0.1);
            color: #c62828;
            border: 1px solid rgba(244, 67, 54, 0.2);
        }

        .success-message {
            background: rgba(76, 175, 80, 0.1);
            color: #2e7d32;
            border: 1px solid rgba(76, 175, 80, 0.2);
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }

        .auth-footer {
            text-align: center;
            margin-top: 1.5rem;
            padding-top: 1rem;
        }

        .auth-footer p {
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

        .switch-form {
            color: #667eea;
            cursor: pointer;
            font-weight: 500;
            transition: color 0.3s ease;
            text-decoration: underline;
        }

        .switch-form:hover {
            color: #764ba2;
        }

        /* Responsive Design */
        @media (max-width: 480px) {
            .auth-container {
                padding: 2rem 1.5rem;
                margin: 1rem;
                min-height: 550px;
            }

            .auth-title {
                font-size: 1.6rem;
            }

            .form-input {
                padding: 0.9rem 0.9rem 0.9rem 2.8rem;
                font-size: 0.9rem;
            }

            .auth-button {
                padding: 1rem;
                font-size: 0.95rem;
            }

            .form-row {
                flex-direction: column;
                gap: 1rem;
            }
        }

        /* Password strength indicator */
        .password-strength {
            margin-top: 0.5rem;
            height: 4px;
            background: rgba(0, 0, 0, 0.1);
            border-radius: 2px;
            overflow: hidden;
        }

        .password-strength-bar {
            height: 100%;
            width: 0;
            transition: all 0.3s ease;
            border-radius: 2px;
        }

        .password-strength-bar.weak {
            width: 33%;
            background: #f44336;
        }

        .password-strength-bar.medium {
            width: 66%;
            background: #ff9800;
        }

        .password-strength-bar.strong {
            width: 100%;
            background: #4caf50;
        }
    </style>
</head>
<body>
    <div class="auth-container">
        <div class="auth-tabs">
            <button class="tab-button active" id="loginTab">Sign In</button>
            <button class="tab-button" id="signupTab">Sign Up</button>
            <div class="tab-slider" id="tabSlider"></div>
        </div>

        <div class="auth-header">
            <div class="auth-logo">
                <i class="fas fa-calculator"></i>
            </div>
            <h1 class="auth-title" id="authTitle">Welcome Back</h1>
            <p class="auth-subtitle" id="authSubtitle">Sign in to your billing management system</p>
        </div>

        <div class="form-container">
            <!-- Login Form -->
            <form class="auth-form login active" action="auth" method="post" id="loginForm">
                <input type="hidden" name="action" value="login">
                
                <div class="form-group">
                    <i class="fas fa-user"></i>
                    <input type="text" name="username" class="form-input" placeholder="Enter your username" required>
                </div>

                <div class="form-group">
                    <i class="fas fa-lock"></i>
                    <input type="password" name="password" class="form-input" placeholder="Enter your password" required>
                </div>

                <button type="submit" class="auth-button" id="loginButton">
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

            <!-- Sign Up Form -->
            <form class="auth-form signup" action="auth" method="post" id="signupForm">
                <input type="hidden" name="action" value="signup">
                
                <div class="form-row">
                    <div class="form-group">
                        <i class="fas fa-user"></i>
                        <input type="text" name="firstName" class="form-input" placeholder="First Name" required>
                    </div>
                    <div class="form-group">
                        <i class="fas fa-user"></i>
                        <input type="text" name="lastName" class="form-input" placeholder="Last Name" required>
                    </div>
                </div>

                <div class="form-group">
                    <i class="fas fa-envelope"></i>
                    <input type="email" name="email" class="form-input" placeholder="Enter your email" required>
                </div>

                <div class="form-group">
                    <i class="fas fa-user-circle"></i>
                    <input type="text" name="username" class="form-input" placeholder="Choose a username" required>
                </div>

                <div class="form-group">
                    <i class="fas fa-lock"></i>
                    <input type="password" name="password" class="form-input" placeholder="Create a password" required id="signupPassword">
                    <div class="password-strength">
                        <div class="password-strength-bar" id="passwordStrengthBar"></div>
                    </div>
                </div>

                <div class="form-group">
                    <i class="fas fa-lock"></i>
                    <input type="password" name="confirmPassword" class="form-input" placeholder="Confirm password" required>
                </div>

                <button type="submit" class="auth-button" id="signupButton">
                    <span>Create Account</span>
                </button>

                <!-- Show success or error message for signup -->
                <% if (request.getAttribute("signupMessage") != null) { %>
                <div class="success-message">
                    <i class="fas fa-check-circle"></i>
                    <%= request.getAttribute("signupMessage") %>
                </div>
                <% } %>

                <% if (request.getAttribute("signupError") != null) { %>
                <div class="error-message">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= request.getAttribute("signupError") %>
                </div>
                <% } %>
            </form>
        </div>

        <div class="auth-footer">
            <p id="authFooterText">
                Forgot your password? 
                <a href="#" class="forgot-password">Reset here</a>
            </p>
        </div>
    </div>

    <script>
        // Tab switching functionality
        const loginTab = document.getElementById('loginTab');
        const signupTab = document.getElementById('signupTab');
        const tabSlider = document.getElementById('tabSlider');
        const loginForm = document.querySelector('.auth-form.login');
        const signupForm = document.querySelector('.auth-form.signup');
        const authTitle = document.getElementById('authTitle');
        const authSubtitle = document.getElementById('authSubtitle');
        const authFooterText = document.getElementById('authFooterText');

        function switchToLogin() {
            loginTab.classList.add('active');
            signupTab.classList.remove('active');
            tabSlider.classList.remove('signup');
            
            loginForm.classList.add('active');
            loginForm.classList.remove('inactive');
            signupForm.classList.remove('active');
            signupForm.classList.add('signup');
            
            authTitle.textContent = 'Welcome Back';
            authSubtitle.textContent = 'Sign in to your billing management system';
            authFooterText.innerHTML = 'Forgot your password? <a href="#" class="forgot-password">Reset here</a>';
        }

        function switchToSignup() {
            signupTab.classList.add('active');
            loginTab.classList.remove('active');
            tabSlider.classList.add('signup');
            
            signupForm.classList.add('active');
            signupForm.classList.remove('signup');
            loginForm.classList.remove('active');
            loginForm.classList.add('inactive');
            
            authTitle.textContent = 'Create Account';
            authSubtitle.textContent = 'Join our billing management system';
            authFooterText.innerHTML = 'Already have an account? <span class="switch-form" onclick="switchToLogin()">Sign in here</span>';
        }

        loginTab.addEventListener('click', switchToLogin);
        signupTab.addEventListener('click', switchToSignup);

        // Form submission handling
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            const button = document.getElementById('loginButton');
            const buttonText = button.querySelector('span');
            
            button.classList.add('loading');
            buttonText.style.opacity = '0';
        });

        document.getElementById('signupForm').addEventListener('submit', function(e) {
            const button = document.getElementById('signupButton');
            const buttonText = button.querySelector('span');
            const password = document.querySelector('input[name="password"]').value;
            const confirmPassword = document.querySelector('input[name="confirmPassword"]').value;
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match!');
                return;
            }
            
            button.classList.add('loading');
            buttonText.style.opacity = '0';
        });

        // Password strength indicator
        const signupPassword = document.getElementById('signupPassword');
        const passwordStrengthBar = document.getElementById('passwordStrengthBar');

        function checkPasswordStrength(password) {
            let score = 0;
            if (password.length >= 8) score++;
            if (/[A-Z]/.test(password)) score++;
            if (/[0-9]/.test(password)) score++;
            if (/[^A-Za-z0-9]/.test(password)) score++;
            
            passwordStrengthBar.className = 'password-strength-bar';
            if (score === 1 || score === 2) {
                passwordStrengthBar.classList.add('weak');
            } else if (score === 3) {
                passwordStrengthBar.classList.add('medium');
            } else if (score >= 4) {
                passwordStrengthBar.classList.add('strong');
            }
        }

        signupPassword.addEventListener('input', function() {
            checkPasswordStrength(this.value);
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

        // Restore button state on page reload
        window.addEventListener('load', function () {
            const loginButton = document.getElementById('loginButton');
            const signupButton = document.getElementById('signupButton');
            const loginButtonText = loginButton.querySelector('span');
            const signupButtonText = signupButton.querySelector('span');
            
            loginButton.classList.remove('loading');
            signupButton.classList.remove('loading');
            if (loginButtonText) loginButtonText.style.opacity = '1';
            if (signupButtonText) signupButtonText.style.opacity = '1';
        });
    </script>
</body>
</html>