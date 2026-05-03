package com.controller;

import java.io.IOException;
import java.sql.*;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.utils.DBConnection;

@WebServlet("/AdminApproveUserServlet")
public class AdminApproveUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String userIdStr = request.getParameter("id");
        String action = request.getParameter("action");  // "approve" or "reject"
        HttpSession session = request.getSession();

        if (userIdStr == null || action == null) {
            session.setAttribute("errorMessage", "Invalid request parameters.");
            response.sendRedirect("adminPendingUsers.jsp");
            return;
        }

        int userId;
        try {
            userId = Integer.parseInt(userIdStr);
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid user ID.");
            response.sendRedirect("adminPendingUsers.jsp");
            return;
        }

        String newStatus = null;
        if ("approve".equalsIgnoreCase(action)) {
            newStatus = "active";
        } else if ("reject".equalsIgnoreCase(action)) {
            newStatus = "inactive";
        } else {
            session.setAttribute("errorMessage", "Unknown action.");
            response.sendRedirect("adminPendingUsers.jsp");
            return;
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE users SET status = ? WHERE id = ?")) {

            ps.setString(1, newStatus);
            ps.setInt(2, userId);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                session.setAttribute("successMessage", "User status updated successfully.");
            } else {
                session.setAttribute("errorMessage", "Failed to update user status.");
            }
            response.sendRedirect("admin/pendingUser.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Database error: " + e.getMessage());
            response.sendRedirect("admin/pendingUsers.jsp");
        }
    }
}
