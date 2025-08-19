package com.bookshop.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bookshop.dao.ItemDAO;
import com.bookshop.model.Item;

@WebServlet("/item")
public class ItemController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ItemDAO itemDAO;
    
    public void init() {
        itemDAO = new ItemDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "delete":
                deleteItem(request, response);
                break;
            case "list":
            default:
                listItems(request, response);
                break;
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        switch (action) {
            case "add":
                addItem(request, response);
                break;
            case "update":
                updateItem(request, response);
                break;
            default:
                listItems(request, response);
                break;
        }
    }
    
    private void listItems(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/view/item/items.jsp").forward(request, response);
    }
    
    private void addItem(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int itemId = Integer.parseInt(request.getParameter("itemId"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            Item item = new Item(itemId, name, description, price, quantity);
            
            boolean success = itemDAO.addItem(item);
            
            if (success) {
                request.getSession().setAttribute("message", "Item added successfully!");
                request.getSession().setAttribute("messageType", "success");
            } else {
                request.getSession().setAttribute("message", "Failed to add item. Item ID might already exist.");
                request.getSession().setAttribute("messageType", "error");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("message", "Invalid input format. Please check your data.");
            request.getSession().setAttribute("messageType", "error");
        } catch (Exception e) {
            request.getSession().setAttribute("message", "Error adding item: " + e.getMessage());
            request.getSession().setAttribute("messageType", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/view/item/items.jsp");
    }
    
    private void updateItem(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int itemId = Integer.parseInt(request.getParameter("itemId"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            Item item = new Item(itemId, name, description, price, quantity);
            
            boolean success = itemDAO.updateItem(item);
            
            if (success) {
                request.getSession().setAttribute("message", "Item updated successfully!");
                request.getSession().setAttribute("messageType", "success");
            } else {
                request.getSession().setAttribute("message", "Failed to update item.");
                request.getSession().setAttribute("messageType", "error");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("message", "Invalid input format. Please check your data.");
            request.getSession().setAttribute("messageType", "error");
        } catch (Exception e) {
            request.getSession().setAttribute("message", "Error updating item: " + e.getMessage());
            request.getSession().setAttribute("messageType", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/view/item/items.jsp");
    }
    
    private void deleteItem(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int itemId = Integer.parseInt(request.getParameter("itemId"));
            
            boolean success = itemDAO.deleteItem(itemId);
            
            if (success) {
                request.getSession().setAttribute("message", "Item deleted successfully!");
                request.getSession().setAttribute("messageType", "success");
            } else {
                request.getSession().setAttribute("message", "Failed to delete item.");
                request.getSession().setAttribute("messageType", "error");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("message", "Invalid item ID.");
            request.getSession().setAttribute("messageType", "error");
        } catch (Exception e) {
            request.getSession().setAttribute("message", "Error deleting item: " + e.getMessage());
            request.getSession().setAttribute("messageType", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/view/item/items.jsp");
    }
}