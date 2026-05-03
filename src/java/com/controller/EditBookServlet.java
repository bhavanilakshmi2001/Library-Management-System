package com.controller;

import java.io.IOException;
import java.sql.*;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.utils.DBConnection;

@WebServlet("/EditBookServlet")
public class EditBookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");
        if (id == null || id.trim().isEmpty()) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Invalid book ID");
            response.sendRedirect("BookListServlet");
            return;
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM books WHERE id=?")) {

            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                request.setAttribute("id", rs.getInt("id"));
                request.setAttribute("title", rs.getString("title"));
                request.setAttribute("author", rs.getString("author"));
                request.setAttribute("category", rs.getString("category"));
                request.setAttribute("isbn", rs.getString("isbn"));
                request.setAttribute("publisher", rs.getString("publisher"));
                request.setAttribute("pub_year", rs.getString("pub_year"));
                request.setAttribute("language", rs.getString("language"));
                request.setAttribute("copies", rs.getInt("copies"));
                request.getRequestDispatcher("/admin/editBook.jsp").forward(request, response);
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "Book not found");
                response.sendRedirect("BookListServlet");
            }

        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Database error");
            response.sendRedirect("BookListServlet");
        }
    }
}
