package com.controller;

import java.io.IOException;
import java.sql.*;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.utils.DBConnection;

@WebServlet("/UpdateBookServlet")
public class UpdateBookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {

        String id = request.getParameter("id");
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String category = request.getParameter("category");
        String isbn = request.getParameter("isbn");
        String publisher = request.getParameter("publisher");
        String pub_year = request.getParameter("pub_year");
        String language = request.getParameter("language");
        String copies = request.getParameter("copies");

        HttpSession session = request.getSession();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                "UPDATE books SET title=?, author=?, category=?, isbn=?, publisher=?, pub_year=?, language=?, copies=? WHERE id=?"
             )) {

            ps.setString(1, title);
            ps.setString(2, author);
            ps.setString(3, category);
            ps.setString(4, isbn);
            ps.setString(5, publisher);
            ps.setString(6, pub_year);
            ps.setString(7, language);
            ps.setString(8, copies);
            ps.setString(9, id);

            int updated = ps.executeUpdate();
            if (updated > 0) {
                session.setAttribute("successMessage", "Book updated successfully");
            } else {
                session.setAttribute("errorMessage", "Failed to update book");
            }
            response.sendRedirect("BookListServlet");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Database error: " + e.getMessage());
            response.sendRedirect("BookListServlet");
        }
    }
}
