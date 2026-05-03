package com.controller;

import java.io.IOException;
import java.sql.*;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.utils.DBConnection;

@WebServlet("/AdminBorrowRequestServlet")
public class AdminBorrowRequestServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        String action = request.getParameter("action");
        String issueDateStr = request.getParameter("issueDate");
        String expiryDateStr = request.getParameter("expiryDate");

        HttpSession session = request.getSession();

        if (idStr == null || action == null) {
            session.setAttribute("errorMessage", "Invalid request parameters.");
            response.sendRedirect(request.getContextPath() + "/admin/adminBorrowRequests.jsp");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid request ID.");
            response.sendRedirect(request.getContextPath() + "/admin/adminBorrowRequests.jsp");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false); // Start transaction

            if ("approve".equalsIgnoreCase(action)) {
                if (issueDateStr == null || expiryDateStr == null || issueDateStr.isEmpty() || expiryDateStr.isEmpty()) {
                    session.setAttribute("errorMessage", "Issue Date and Expiry Date are required.");
                    response.sendRedirect(request.getContextPath() + "/admin/approveBorrowRequest.jsp?id=" + id);
                    return;
                }

                Date issueDate = Date.valueOf(issueDateStr);
                Date expiryDate = Date.valueOf(expiryDateStr);

                if (!expiryDate.after(issueDate)) {
                    session.setAttribute("errorMessage", "Expiry Date must be after Issue Date.");
                    response.sendRedirect(request.getContextPath() + "/admin/approveBorrowRequest.jsp?id=" + id);
                    return;
                }

                // Update borrow_requests status and dates
                try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE borrow_requests SET status = ?, issue_date = ?, expiry_date = ? WHERE id = ?")) {

                    ps.setString(1, "approved");
                    ps.setDate(2, issueDate);
                    ps.setDate(3, expiryDate);
                    ps.setInt(4, id);

                    int updated = ps.executeUpdate();
                    if (updated == 0) {
                        conn.rollback();
                        session.setAttribute("errorMessage", "Failed to approve request.");
                        response.sendRedirect(request.getContextPath() + "/admin/adminBorrowRequests.jsp");
                        return;
                    }
                }

                // Reduce book copies by 1
                try (PreparedStatement ps2 = conn.prepareStatement(
                    "UPDATE books SET copies = copies - 1 WHERE id = (SELECT book_id FROM borrow_requests WHERE id = ?) AND copies > 0")) {
                    ps2.setInt(1, id);
                    int updatedCopies = ps2.executeUpdate();
                    if (updatedCopies == 0) {
                        conn.rollback();
                        session.setAttribute("errorMessage", "Book is not available (no copies left).");
                        response.sendRedirect(request.getContextPath() + "/admin/adminBorrowRequests.jsp");
                        return;
                    }
                }

                conn.commit();
                session.setAttribute("successMessage", "Request approved successfully.");

            } else if ("reject".equalsIgnoreCase(action)) {
                // Update borrow_requests status
                try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE borrow_requests SET status = ? WHERE id = ?")) {

                    ps.setString(1, "rejected");
                    ps.setInt(2, id);

                    int updated = ps.executeUpdate();
                    if (updated == 0) {
                        conn.rollback();
                        session.setAttribute("errorMessage", "Failed to reject request.");
                        response.sendRedirect(request.getContextPath() + "/admin/adminBorrowRequests.jsp");
                        return;
                    }
                }

                // No copies update needed on reject because copies weren't reduced

                conn.commit();
                session.setAttribute("successMessage", "Request rejected successfully.");

            } else {
                session.setAttribute("errorMessage", "Unknown action.");
            }

            response.sendRedirect(request.getContextPath() + "/admin/adminBorrowRequests.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Database error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/adminBorrowRequests.jsp");
        }
    }
}
