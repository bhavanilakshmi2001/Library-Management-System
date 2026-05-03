package com.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Default admin credentials
    private final String ADMIN_USERNAME = "admin";
    private final String ADMIN_PASSWORD = "admin";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("name");
        String password = request.getParameter("password");

        if (ADMIN_USERNAME.equals(username) && ADMIN_PASSWORD.equals(password)) {
            // Login successful → create session
            HttpSession session = request.getSession();
            session.setAttribute("adminName", "Administrator");
            response.sendRedirect("admin/adminDashboard.jsp");
        } else {
            // Login failed → back to login page
            request.setAttribute("errorMsg", "Invalid username or password");
            request.getRequestDispatcher("admin/adminLogin.jsp").forward(request, response);
        }
    }
}
