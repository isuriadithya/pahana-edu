package com.bookshop.controller;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.bookshop.model.Customer;
import com.bookshop.service.BillingService;
import com.bookshop.service.CustomerService;

@WebServlet("/billing")
public class BillingController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BillingService billingService;
    private CustomerService customerService;

    public void init() {
        billingService = BillingService.getInstance();
        customerService = CustomerService.getInstance();
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int accountNumber = Integer.parseInt(req.getParameter("accountNumber"));
        Customer customer = customerService.getCustomerById(accountNumber);

        double bill = billingService.calculateBill(customer);

        req.setAttribute("customer", customer);
        req.setAttribute("bill", bill);

        req.getRequestDispatcher("WEB-INF/view/showBill.jsp").forward(req, resp);
    }
}
