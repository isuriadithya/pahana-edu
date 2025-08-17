package com.bookshop.controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.bookshop.model.Item;
import com.bookshop.service.ItemService;

@WebServlet("/item")
public class ItemController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ItemService itemService;

    @Override
    public void init() {
        itemService = ItemService.getInstance();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");

        if (action == null || action.equals("list")) {
            listItems(req, resp);
        } else if (action.equals("add")) {
            req.getRequestDispatcher("WEB-INF/view/addItem.jsp").forward(req, resp);
        } else if (action.equals("edit")) {
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                Item item = itemService.getItemById(id);
                req.setAttribute("item", item);
                req.getRequestDispatcher("WEB-INF/view/editItem.jsp").forward(req, resp);
            } catch (NumberFormatException e) {
                resp.sendRedirect("item?action=list");
            }
        } else {
            resp.sendRedirect("item?action=list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");

        try {
            if ("add".equals(action)) {
                String name = req.getParameter("name");
                String description = req.getParameter("description");
                double price = Double.parseDouble(req.getParameter("price"));
                int quantity = Integer.parseInt(req.getParameter("quantity"));

                itemService.addItem(new Item(0, name, description, price, quantity));
                resp.sendRedirect("item?action=list");

            } else if ("update".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                String name = req.getParameter("name");
                String description = req.getParameter("description");
                double price = Double.parseDouble(req.getParameter("price"));
                int quantity = Integer.parseInt(req.getParameter("quantity"));

                itemService.updateItem(new Item(id, name, description, price, quantity));
                resp.sendRedirect("item?action=list");

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                itemService.deleteItem(id);
                resp.sendRedirect("item?action=list");
            } else {
                resp.sendRedirect("item?action=list");
            }
        } catch (NumberFormatException e) {
            resp.sendRedirect("item?action=list"); // prevents crash if bad input
        }
    }

    private void listItems(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Item> items = itemService.getAllItems();
        req.setAttribute("items", items);
        req.getRequestDispatcher("WEB-INF/view/listItems.jsp").forward(req, resp);
    }
}
