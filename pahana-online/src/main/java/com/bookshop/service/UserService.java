package com.bookshop.service;

import com.bookshop.dao.UserDAO;
import com.bookshop.model.UserModel;

public class UserService {
	
	private static UserService instance;
    private UserDAO userDAO;

    private UserService() {
        this.userDAO = new UserDAO();
    }

    public static UserService getInstance() {
        if (instance == null) {
            synchronized (UserService.class) {
                if (instance == null) {
                    instance = new UserService();
                }
            }
        }
        return instance;
    }

    public boolean authenticate(String username, String password) {
        UserModel user = userDAO.getUserByUsername(username);
        return (user != null && user.getPassword().equals(password));
    }

    public UserModel getUser(String username) {
        return userDAO.getUserByUsername(username);
    }

}


