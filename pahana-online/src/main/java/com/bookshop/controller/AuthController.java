package com.bookshop.controller;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.bookshop.model.UserModel;
import com.bookshop.service.UserService;

@WebServlet("/auth")
public class AuthController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserService userService;

    @Override
    public void init() {
        userService = UserService.getInstance();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("WEB-INF/view/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // authenticate user
        if (userService.authenticate(username, password)) {
            // fetch full user details (including userId and role)
            UserModel user = userService.getUser(username);

            HttpSession session = request.getSession();
            session.setAttribute("loggedUser", user); // stores entire UserModel object

            // redirect based on role
            if ("admin".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect("customer?action=list");
            } else {
                response.sendRedirect("billing");
            }
        } else {
            request.setAttribute("errorMessage", "Invalid username or password");
            request.getRequestDispatcher("WEB-INF/view/login.jsp").forward(request, response);
        }
    }
}
