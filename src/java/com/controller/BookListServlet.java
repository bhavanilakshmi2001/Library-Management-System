package com.controller;

import java.io.IOException;
import java.sql.*;
import java.sql.PreparedStatement;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.utils.DBConnection;

@WebServlet("/BookListServlet")
public class BookListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {

        List<Map<String, String>> books = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM books ORDER BY created_at DESC");
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, String> book = new HashMap<>();
                book.put("id", rs.getString("id"));
                book.put("title", rs.getString("title"));
                book.put("author", rs.getString("author"));
                book.put("category", rs.getString("category"));
                book.put("isbn", rs.getString("isbn"));
                book.put("publisher", rs.getString("publisher"));
                book.put("pub_year", rs.getString("pub_year"));
                book.put("language", rs.getString("language"));
                book.put("copies", rs.getString("copies"));
                books.add(book);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
            return;
        }

        request.setAttribute("books", books);
        request.getRequestDispatcher("/admin/manageBooks.jsp").forward(request, response);
    }
}
