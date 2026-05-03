package com.controller;

import java.io.IOException;
import java.sql.*;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.utils.DBConnection;

@WebServlet("/UserBorrowServlet")
public class UserBorrowServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            session.setAttribute("errorMessage", "Please login first.");
            response.sendRedirect("userLogin.jsp");
            return;
        }

        String bookIdStr = request.getParameter("bookId");
        if (bookIdStr == null) {
            session.setAttribute("errorMessage", "Invalid book.");
            response.sendRedirect("searchBooks.jsp");
            return;
        }

        int bookId = Integer.parseInt(bookIdStr);

        try (Connection conn = DBConnection.getConnection()) {
            // Check if book copies available
            String checkSql = "SELECT copies FROM books WHERE id = ?";
            try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
                checkPs.setInt(1, bookId);
                try (ResultSet rs = checkPs.executeQuery()) {
                    if (rs.next()) {
                        int copies = rs.getInt("copies");
                        if (copies <= 0) {
                            session.setAttribute("errorMessage", "Book is not available to borrow.");
                            response.sendRedirect("user/bookDetails.jsp?id=" + bookId);
                            return;
                        }
                    } else {
                        session.setAttribute("errorMessage", "Book not found.");
                        response.sendRedirect("searchBooks.jsp");
                        return;
                    }
                }
            }

            // Insert borrow request with status 'pending'
            String insertSql = "INSERT INTO borrow_requests (user_id, book_id, request_date, status) VALUES (?, ?, NOW(), ?)";
            try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                insertPs.setInt(1, userId);
                insertPs.setInt(2, bookId);
                insertPs.setString(3, "pending");

                int inserted = insertPs.executeUpdate();
                if (inserted > 0) {
                    session.setAttribute("successMessage", "Borrow request sent successfully. Wait for admin approval.");
                } else {
                    session.setAttribute("errorMessage", "Failed to send borrow request.");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Database error: " + e.getMessage());
        }

        response.sendRedirect("user/bookDetails.jsp?id=" + bookId);
    }
}
