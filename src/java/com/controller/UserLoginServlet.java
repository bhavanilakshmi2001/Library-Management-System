package com.controller;

import java.io.IOException;
import java.sql.*;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.utils.DBConnection;

@WebServlet("/UserLoginServlet")
public class UserLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        HttpSession session = request.getSession();

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "SELECT id, name, status, role FROM users WHERE email = ? AND password = ?"
            );
            ps.setString(1, email);
            ps.setString(2, password);  // Ideally use hashed password comparison

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String status = rs.getString("status");
                String role = rs.getString("role");

                if (!"active".equalsIgnoreCase(status)) {
                    session.setAttribute("errorMessage", "Your account is not active. Please wait for admin approval.");
                    response.sendRedirect("userLogin.jsp");
                    return;
                }

                if (!"user".equalsIgnoreCase(role)) {
                    session.setAttribute("errorMessage", "Unauthorized role.");
                    response.sendRedirect("userLogin.jsp");
                    return;
                }

                // Successful login
                session.setAttribute("userId", rs.getInt("id"));
                session.setAttribute("userName", rs.getString("name"));
                session.setAttribute("userEmail", email);
                session.setAttribute("userRole", role);

                response.sendRedirect("user/userDashboard.jsp");  // your user home page
            } else {
                session.setAttribute("errorMessage", "Invalid email or password.");
                response.sendRedirect("userLogin.jsp");
            }

            rs.close();
            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Database error: " + e.getMessage());
            response.sendRedirect("userLogin.jsp");
        }
    }
}
