package com.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.utils.DBConnection;

@WebServlet("/AddBookServlet")
public class AddBookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {

        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String category = request.getParameter("category");
        String isbn = request.getParameter("isbn");
        String publisher = request.getParameter("publisher");
        String pubYear = request.getParameter("pub_year");
        String language = request.getParameter("language");
        String copies = request.getParameter("copies");

        HttpSession session = request.getSession();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO books (title, author, category, isbn, publisher, pub_year, language, copies, created_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())"
             )) {

            ps.setString(1, title);
            ps.setString(2, author);
            ps.setString(3, category);
            ps.setString(4, isbn);
            ps.setString(5, publisher);
            ps.setString(6, pubYear);
            ps.setString(7, language);
            ps.setString(8, copies);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                session.setAttribute("successMessage", "Book added successfully");
            } else {
                session.setAttribute("errorMessage", "Failed to add book");
            }
            response.sendRedirect( "BookListServlet");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Database error: " + e.getMessage());
            response.sendRedirect("BookListServlet");
        }
    }
}
