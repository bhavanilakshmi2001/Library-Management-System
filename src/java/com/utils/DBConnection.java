package com.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL = "jdbc:mysql://localhost:3306/library_db";
    private static final String USER = "root"; // change if your MySQL username is different
    private static final String PASSWORD = "root"; // change to your MySQL password
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    public static Connection getConnection() {
        Connection conn = null;
        try {
            // Load JDBC driver
            Class.forName(DRIVER);
            // Get connection
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            System.out.println("MySQL JDBC Driver not found!");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("Database connection failed!");
            e.printStackTrace();
        }
        return conn;
    }

    public static void main(String[] args) {
        // Test connection
        Connection conn = getConnection();
        if (conn != null) {
            System.out.println("✅ Connected to Database!");
        } else {
            System.out.println("❌ Connection Failed!");
        }
    }
}
