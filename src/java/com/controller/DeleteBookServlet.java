package com.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.utils.DBConnection;

@WebServlet("/DeleteBookServlet")
public class DeleteBookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");
        HttpSession session = request.getSession();

        if (id == null || id.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Invalid book ID");
            response.sendRedirect("BookListServlet");
            return;
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("DELETE FROM books WHERE id=?")) {

            ps.setString(1, id);
            int rowsDeleted = ps.executeUpdate();

            if (rowsDeleted > 0) {
                session.setAttribute("successMessage", "Book deleted successfully");
            } else {
                session.setAttribute("errorMessage", "Book not found");
            }

            response.sendRedirect("BookListServlet");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Database error");
            response.sendRedirect("BookListServlet");
        }
    }
}
