package com.bookshop.controller;

import com.bookshop.model.Customer;
import com.bookshop.model.Item;
import com.bookshop.service.CustomerService;
import com.bookshop.service.ItemService;
import com.bookshop.service.BillService;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

@WebServlet("/BillController")
public class BillController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private CustomerService customerService;
    private ItemService itemService;
    private BillService billService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        customerService = CustomerService.getInstance();
        itemService = ItemService.getInstance();
        billService = BillService.getInstance();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        try {
            switch (action) {
                case "getAllCustomers":
                    List<Customer> customers = customerService.getAllCustomers();
                    out.print(gson.toJson(customers));
                    break;

                case "getAllItems":
                    List<Item> items = itemService.getAllItems();
                    out.print(gson.toJson(items));
                    break;

                default:
                    out.print("{\"error\": \"Unknown action\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\": \"" + e.getMessage() + "\"}");
        } finally {
            out.flush();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        try {
            if ("saveBill".equals(action)) {
                int accountNumber = Integer.parseInt(request.getParameter("accountNumber"));
                String billItemsJson = request.getParameter("billItems");

                ItemQuantity[] billItems = gson.fromJson(billItemsJson, ItemQuantity[].class);

                int billId = billService.saveBill(accountNumber, Arrays.asList(billItems));

                Map<String, Object> result = new HashMap<>();
                result.put("success", true);
                result.put("billId", billId);

                out.print(gson.toJson(result));
            } else {
                out.print("{\"error\": \"Unknown action\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", e.getMessage());
            out.print(gson.toJson(result));
        } finally {
            out.flush();
        }
    }

    // Inner class for parsing bill items JSON
    public static class ItemQuantity {
        private int itemId;
        private int quantity;

        public int getItemId() { return itemId; }
        public void setItemId(int itemId) { this.itemId = itemId; }

        public int getQuantity() { return quantity; }
        public void setQuantity(int quantity) { this.quantity = quantity; }
    }
}
