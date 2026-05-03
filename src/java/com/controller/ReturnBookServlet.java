package com.controller;

import com.utils.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;

import java.time.temporal.ChronoUnit;

@WebServlet("/ReturnBookServlet")
public class ReturnBookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String borrowRequestIdStr = request.getParameter("id");
        HttpSession session = request.getSession();

        if (borrowRequestIdStr == null || borrowRequestIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Invalid borrow request ID.");
            response.sendRedirect("userBorrowHistory.jsp");
            return;
        }

        int borrowRequestId = Integer.parseInt(borrowRequestIdStr);
        Date returnDate = new Date(System.currentTimeMillis());

        try (Connection conn = DBConnection.getConnection()) {
            // Fetch expiry_date and book_id for this borrow request
            PreparedStatement ps1 = conn.prepareStatement("SELECT expiry_date, book_id FROM borrow_requests WHERE id = ?");
            ps1.setInt(1, borrowRequestId);
            ResultSet rs = ps1.executeQuery();

            if (rs.next()) {
                Date expiryDate = rs.getDate("expiry_date");
                int bookId = rs.getInt("book_id");
                double fine = 0;

                if (expiryDate != null && returnDate.after(expiryDate)) {
                    long daysLate = ChronoUnit.DAYS.between(expiryDate.toLocalDate(), returnDate.toLocalDate());
                    fine = daysLate * 10; // Example: 10 units fine per day late
                }

                // Update borrow_requests with return_date, status, and fine_amount
                PreparedStatement ps2 = conn.prepareStatement(
                    "UPDATE borrow_requests SET status = ?, return_date = ?, fine_amount = ? WHERE id = ?"
                );
                ps2.setString(1, "returned");
                ps2.setDate(2, returnDate);
                ps2.setDouble(3, fine);
                ps2.setInt(4, borrowRequestId);
                int updated = ps2.executeUpdate();

                if (updated > 0) {
                    // Increase copies of the book by 1
                    PreparedStatement ps3 = conn.prepareStatement("UPDATE books SET copies = copies + 1 WHERE id = ?");
                    ps3.setInt(1, bookId);
                    ps3.executeUpdate();
                    ps3.close();

                    session.setAttribute("successMessage", "Book returned successfully. Fine: " + fine);
                } else {
                    session.setAttribute("errorMessage", "Failed to update return status.");
                }

                ps2.close();
            } else {
                session.setAttribute("errorMessage", "Borrow request not found.");
            }

            rs.close();
            ps1.close();

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error during return: " + e.getMessage());
        }

        response.sendRedirect("userBorrowHistory.jsp");
    }
}
