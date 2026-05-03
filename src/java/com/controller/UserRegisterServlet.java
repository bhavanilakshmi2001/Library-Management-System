package com.controller;

import java.io.IOException;
import java.sql.*;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.utils.DBConnection;

@WebServlet("/UserRegisterServlet")
public class UserRegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password"); // hash in production!
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String gender = request.getParameter("gender");
        String dob = request.getParameter("dob");

        HttpSession session = request.getSession();

        try (Connection conn = DBConnection.getConnection()) {

            // Check if email already exists
            PreparedStatement checkStmt = conn.prepareStatement("SELECT id FROM users WHERE email = ?");
            checkStmt.setString(1, email);
            ResultSet rs = checkStmt.executeQuery();
            if (rs.next()) {
                session.setAttribute("errorMessage", "Email is already registered.");
                response.sendRedirect("register.jsp");
                return;
            }
            rs.close();
            checkStmt.close();

            // Insert new user with status 'pending'
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO users (name, email, password, phone, address, gender, dob, role, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"
            );
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, phone);
            ps.setString(5, address);
            ps.setString(6, gender);
            ps.setDate(7, Date.valueOf(dob));
            ps.setString(8, "user");     // default role
            ps.setString(9, "pending");  // default status

            int rows = ps.executeUpdate();
            if (rows > 0) {
                session.setAttribute("successMessage", "Registration successful! Please wait for admin approval.");
                response.sendRedirect("user/userLogin.jsp");
            } else {
                session.setAttribute("errorMessage", "Registration failed. Please try again.");
                response.sendRedirect("register.jsp");
            }

            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Database error: " + e.getMessage());
            response.sendRedirect("register.jsp");
        }
    }
}
