package com.bookshop.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.bookshop.model.Customer;
import com.bookshop.service.CustomerService;

@WebServlet("/customer")
public class CustomerController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CustomerService customerService;

    public void init() throws ServletException {
        customerService = CustomerService.getInstance();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null || action.equals("list")) {
            listCustomers(request, response);
        } else if (action.equals("add")) {
            showAddForm(request, response);
        } else if (action.equals("edit")) {
            showEditForm(request, response);
        } else if (action.equals("bill")) {
            showBill(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addCustomer(request, response);
        } else if ("update".equals(action)) {
            updateCustomer(request, response);
        }
    }

    // ----------------- Actions ---------------------

    private void listCustomers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Customer> customers = customerService.getAllCustomers();
            request.setAttribute("customers", customers);
            request.getRequestDispatcher("WEB-INF/view/listCustomers.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error fetching customers: " + e.getMessage());
            request.getRequestDispatcher("WEB-INF/view/error.jsp").forward(request, response);
        }
    }


    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("WEB-INF/view/addCustomer.jsp").forward(request, response);
    }

    private void addCustomer(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int accountNumber = Integer.parseInt(request.getParameter("accountNumber"));
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String telephone = request.getParameter("telephone");
        int units = Integer.parseInt(request.getParameter("unitsConsumed"));

        // Simple bill calculation (e.g., Rs. 50 per unit)
        double billAmount = units * 50.0;

        Customer c = new Customer(accountNumber, name, address, telephone, units, billAmount);
        customerService.addCustomer(c);

        response.sendRedirect("customer?action=list");
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int accountNumber = Integer.parseInt(request.getParameter("accountNumber"));
        Customer customer = customerService.getCustomerById(accountNumber);
        request.setAttribute("customer", customer);
        request.getRequestDispatcher("WEB-INF/view/editCustomer.jsp").forward(request, response);
    }

    private void updateCustomer(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int accountNumber = Integer.parseInt(request.getParameter("accountNumber"));
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String telephone = request.getParameter("telephone");
        int units = Integer.parseInt(request.getParameter("unitsConsumed"));

        double billAmount = units * 50.0;

        Customer c = new Customer(accountNumber, name, address, telephone, units, billAmount);
        customerService.updateCustomer(c);

        response.sendRedirect("customer?action=list");
    }

    private void showBill(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int accountNumber = Integer.parseInt(request.getParameter("accountNumber"));
        Customer customer = customerService.getCustomerById(accountNumber);
        request.setAttribute("customer", customer);
        request.getRequestDispatcher("WEB-INF/view/showBill.jsp").forward(request, response);
    }
}
