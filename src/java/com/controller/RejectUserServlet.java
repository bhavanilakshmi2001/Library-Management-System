package com.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.utils.DBConnection;

@WebServlet("/RejectUserServlet")
public class RejectUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String userId = request.getParameter("userId");
        HttpSession session = request.getSession();

        if (userId == null || userId.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Invalid user ID.");
            response.sendRedirect("pendingUsers.jsp");
            return;
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE users SET status = 'rejected' WHERE id = ?")) {

            ps.setString(1, userId);
            int updated = ps.executeUpdate();

            if (updated > 0) {
                session.setAttribute("successMessage", "User rejected successfully.");
            } else {
                session.setAttribute("errorMessage", "Failed to reject user.");
            }
            response.sendRedirect("pendingUsers.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Database error: " + e.getMessage());
            response.sendRedirect("pendingUsers.jsp");
        }
    }
}
