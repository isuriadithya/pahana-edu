package com.bookshop.service;

import java.sql.SQLException;
import java.util.List;
import com.bookshop.dao.ItemDAO;
import com.bookshop.model.Item;

public class ItemService {

    private static volatile ItemService instance; // volatile for thread-safety
    private ItemDAO itemDAO;

    private ItemService() {
        this.itemDAO = new ItemDAO();
    }

    public static ItemService getInstance() {
        if (instance == null) {
            synchronized (ItemService.class) {
                if (instance == null) {
                    instance = new ItemService();
                }
            }
        }
        return instance;
    }

    public void addItem(Item item) {
        itemDAO.addItem(item);
    }

    public void updateItem(Item item) {
        itemDAO.updateItem(item);
    }

    public void deleteItem(int id) {
        itemDAO.deleteItem(id);
    }

    public Item getItemById(int id) {
        return itemDAO.getItemById(id);
    }

    public List<Item> getAllItems() {
        return itemDAO.getAllItems();
    }
}
