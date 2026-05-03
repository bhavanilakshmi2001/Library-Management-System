package com.controller;

import java.io.IOException;
import java.sql.*;
import java.sql.PreparedStatement;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/AdminUserDetailsServlet")
public class AdminUserDetailsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userIdStr = request.getParameter("userId");
        if(userIdStr == null || userIdStr.trim().isEmpty()){
            response.sendRedirect("AdminUserList.jsp?error=UserIdMissing");
            return;
        }

        int userId = Integer.parseInt(userIdStr);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_db", "root", "root");

            // Fetch user details
            PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE id=?");
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if(rs.next()){
                request.setAttribute("user", rs);
            }

            // Borrowed books count
            PreparedStatement ps2 = con.prepareStatement(
                "SELECT COUNT(*) AS borrowCount FROM borrow_requests WHERE user_id=? AND status='approved'"
            );
            ps2.setInt(1, userId);
            ResultSet rs2 = ps2.executeQuery();
            if(rs2.next()){
                request.setAttribute("borrowCount", rs2.getInt("borrowCount"));
            }

            // Borrowed book list
            PreparedStatement ps3 = con.prepareStatement(
                "SELECT b.title, br.status, br.issue_date, br.expiry_date " +
                "FROM borrow_requests br JOIN books b ON br.book_id=b.id WHERE br.user_id=?"
            );
            ps3.setInt(1, userId);
            ResultSet rs3 = ps3.executeQuery();
            request.setAttribute("borrowList", rs3);

            RequestDispatcher rd = request.getRequestDispatcher("/admin/userDetails.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
