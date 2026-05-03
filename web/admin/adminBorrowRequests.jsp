<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.utils.DBConnection" %>
<%
    // Session check (admin only)
    String adminName = (String) session.getAttribute("adminName");
    if (adminName == null) {
        response.sendRedirect("adminLogin.jsp");
        return;
    }

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Borrow Requests</title>
     <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <style>
        body {
            background-color: #f8f9fa;
            font-family: Arial, sans-serif;
        }
        .container {
            margin-top: 100px; /* navbar space */
        }
        .card {
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .card-header {
            background: #7A1CAC; /* violet */
            color: white;
            font-size: 20px;
            font-weight: bold;
        }

        /* Table Styling */
        table {
            background: white;
            border-radius: 10px;
            overflow: hidden;
        }
        thead {
            background-color: #AD49E1; /* violet header */
            color: white;
        }
        tbody tr:hover {
            background-color: #F3E8FF; /* light violet hover */
        }

        .badge {
            font-size: 0.9rem;
            padding: 6px 10px;
            border-radius: 8px;
        }
        .status-pending { background-color: #FFD700; color: #000; }   /* Yellow */
        .status-approved { background-color: #28a745; color: white; } /* Green */
        .status-rejected { background-color: #dc3545; color: white; } /* Red */
        .status-returned { background-color: #007bff; color: white; } /* Blue */

        /* Navbar */
        .navbar {
            background-color: #E6E6FA; /* light violet */
            border-bottom: 3px solid #AD49E1;
            box-shadow: 0 4px 15px rgba(173, 73, 225, 0.2);
        }
        .navbar-brand, .nav-link, .navbar-text {
            color: #2E073F !important;
            font-weight: 500;
        }
        .nav-link:hover { color: #7A1CAC !important; }
        .btn-logout {
            background-color: transparent;
            border: 2px solid #AD49E1;
            border-radius: 50px;
            padding: 5px 15px;
            color: #7A1CAC;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .btn-logout:hover { background-color: #AD49E1; color: white; }
        
          .dropdown-menu {
            background-color: rgba(230, 230, 250, 0.95);
            border: 1px solid #AD49E1;
        }
        .dropdown-item:hover {
            background-color: #AD49E1;
            color: white;
        }
        
    </style>
</head>
<body>
    

<!-- Navbar -->
<nav class="navbar navbar-expand-lg px-4 fixed-top">
    <a class="navbar-brand fw-bold" href="adminHome.jsp">📚 Library Admin</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminNavbar" aria-controls="adminNavbar" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="adminNavbar">
        <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
             <li class="nav-item"><a class="nav-link" href="adminDashboard.jsp"><i class="fa-solid fa-house"></i> Home</a></li>
             <li class="nav-item"><a class="nav-link" href="SearchBooks.jsp"><i class="fa-solid fa-search"></i> Search Books</a></li>
             <li class="nav-item"><a class="nav-link" href="manageBooks.jsp"><i class="fa-solid fa-cogs"></i> Manage Books</a></li>
        
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="membersDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="fa-solid fa-users"></i> Manage Members
                </a>
                <ul class="dropdown-menu" aria-labelledby="membersDropdown">
                    <li><a class="dropdown-item" href="pendingUser.jsp"> <i class="fa-solid fa-user-clock"></i> Pending Members</a></li>
                    <li><a class="dropdown-item" href="viewUsers.jsp"> <i class="fa-solid fa-user-check"></i> Members List</a></li>
                </ul>
            </li>
            
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="BorrowsDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="fa-solid fa-book-reader"></i> Borrow Requests
                </a>
                <ul class="dropdown-menu" aria-labelledby="BorrowsDropdown">
                    <li><a class="dropdown-item" href="adminBorrowRequests.jsp"><i class="fa-solid fa-hand-holding"></i> Borrow Requests</a></li>
                    <li><a class="dropdown-item" href="adminBorrowHistory.jsp"><i class="fa-solid fa-history"></i> Borrow History</a></li>
                    <li><a class="dropdown-item" href="notReturnedBooks.jsp"><i class="fa-solid fa-clock"></i> Pending Books</a></li>
                </ul>
            </li>
             <li class="nav-item"><a class="nav-link" href="charts.jsp"><i class="fa-solid fa-chart-pie"></i> Chart</a></li>
            <li class="nav-item">
                <a href="../logout.jsp" class="btn btn-logout ms-3"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </li>
        </ul>
    </div>
</nav>    

<div class="container">
    <div class="card">
        <div class="card-header text-center"><i class="fas fa-book me-1"></i>  Borrow Requests</div>
        <div class="card-body">
            <table class="table table-hover text-center">
             <thead>
<tr>
    <th>ID</th>
    <th>User</th>
    <th>Book</th>
    <th>Status</th>
    <th>Issue Date</th>
    <th>Expiry Date</th>
    <th>Return Date</th>
    <th>Actions</th>   <!-- ✅ new column -->
</tr>
</thead>
<tbody>
<%
    try {
        conn = DBConnection.getConnection();
        stmt = conn.createStatement();
        String sql = "SELECT br.id, u.name AS user_name, b.title AS book_title, " +
                     "br.status, br.issue_date, br.expiry_date, br.return_date " +
                     "FROM borrow_requests br " +
                     "JOIN users u ON br.user_id = u.id " +
                     "JOIN books b ON br.book_id = b.id " +
                     "ORDER BY br.id DESC";
        rs = stmt.executeQuery(sql);

        while (rs.next()) {
            int id = rs.getInt("id");
            String userName = rs.getString("user_name");
            String bookTitle = rs.getString("book_title");
            String status = rs.getString("status");
            String issueDate = rs.getString("issue_date");
            String expiryDate = rs.getString("expiry_date");
            String returnDate = rs.getString("return_date");
%>
<tr>
    <td><%= id %></td>
    <td><%= userName %></td>
    <td><%= bookTitle %></td>
    <td>
        <% if ("pending".equalsIgnoreCase(status)) { %>
            <span class="badge status-pending">Pending</span>
        <% } else if ("approved".equalsIgnoreCase(status)) { %>
            <span class="badge status-approved">Borrow Approved</span>
        <% } else if ("rejected".equalsIgnoreCase(status)) { %>
            <span class="badge status-rejected">Rejected</span>
        <% } else if ("returned".equalsIgnoreCase(status)) { %>
            <span class="badge status-returned">Returned</span>
        <% } %>
    </td>
    <td><%= (issueDate != null ? issueDate : "-") %></td>
    <td><%= (expiryDate != null ? expiryDate : "-") %></td>
    <td><%= (returnDate != null ? returnDate : "-") %></td>
    <td>
        <% if ("pending".equalsIgnoreCase(status)) { %>
            <form action="../AdminBorrowRequestServlet" method="post" style="display:inline;">
                <input type="hidden" name="id" value="<%= id %>"/>
                <button type="submit" name="action" value="approve" class="btn btn-success btn-sm">
                    <i class="fa fa-check"></i> Approve
                </button>
            </form>
            <form action="UpdateBorrowStatusServlet" method="post" style="display:inline;">
                <input type="hidden" name="id" value="<%= id %>"/>
                <button type="submit" name="action" value="reject" class="btn btn-danger btn-sm">
                    <i class="fa fa-times"></i> Reject
                </button>
            </form>
        <% } else { %>
            <span class="text-muted">No actions</span>
        <% } %>
    </td>
</tr>
<%  } // end while
    } catch (Exception e) {
        out.println("<tr><td colspan='8'>Error: " + e.getMessage() + "</td></tr>");
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
</tbody>

            </table>
        </div>
    </div>
</div>
</body>
</html>
