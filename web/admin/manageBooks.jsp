<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.utils.DBConnection" %>
<%
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Books</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .table-container {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 4px 10px rgba(0,0,0,0.1);
        }
        h2 { color: #7A1CAC; font-weight: bold; }
        
        /* Navbar */
        .navbar {
            background-color: rgba(230, 230, 250, 0.9); /* Light violet */
            border-bottom: 3px solid #AD49E1;
            box-shadow: 0 4px 15px rgba(173, 73, 225, 0.2);
        }
        .navbar-brand, .nav-link, .navbar-text {
            color: #2E073F !important;
            font-weight: 500;
        }
        .nav-link:hover {
            color: #7A1CAC !important;
        }
        .btn-logout {
            background-color: transparent;
            border: 2px solid #AD49E1;
            border-radius: 50px;
            padding: 5px 15px;
            color: #7A1CAC;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .btn-logout:hover {
            background-color: #AD49E1;
            color: white;
        }

   /* Table Styling */
.table {
    border: 1px solid #AD49E1; /* violet border */
    border-radius: 8px;
    overflow: hidden;
}

thead {
    background-color: #AD49E1 !important; /* violet header */
    color: white;
}

tbody tr:nth-child(even) {
    background-color: #f6e9ff; /* very light violet */
}

tbody tr:nth-child(odd) {
    background-color: #ffffff; /* white */
}

tbody tr:hover {
    background-color: #e9d4ff; /* soft hover violet */
    transition: background 0.3s ease;
}

.table td, 
.table th {
    vertical-align: middle;
}


        /* Buttons */
        .btn-add {
            background-color: #7A1CAC;
            color: white;
            border-radius: 5px;
        }
        .btn-add:hover {
            background-color: #AD49E1;
        }
        .btn-warning {
            background-color: #ffb84d;
            border: none;
            color: #fff;
        }
        .btn-warning:hover {
            background-color: #e69900;
        }
        .btn-danger {
            background-color: #ff4d6d;
            border: none;
        }
        .btn-danger:hover {
            background-color: #e60039;
        }
        .dropdown-menu {
            background-color: rgba(230, 230, 250, 0.95);
            border: 1px solid #AD49E1;
        }
        .dropdown-item:hover {
            background-color: #AD49E1;
            color: white;
        }

       /* Add space below navbar */
        .container { padding-top: 70px; }
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
             <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/adminDashboard.jsp"><i class="fa-solid fa-house"></i> Home</a></li>
             
             <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/SearchBooks.jsp"><i class="fa-solid fa-search"></i> Search Books</a></li>
             
            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/manageBooks.jsp"><i class="fa-solid fa-cogs"></i> Manage Books</a></li>
        
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="membersDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="fa-solid fa-users"></i> Manage Members
                </a>
                <ul class="dropdown-menu" aria-labelledby="membersDropdown">
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/pendingUser.jsp"> <i class="fa-solid fa-user-clock"></i>Pending Members</a></li>
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/viewUsers.jsp"> <i class="fa-solid fa-user-check"></i>Members List</a></li>
                </ul>
            </li>
            
                <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="BorrowsDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="fa-solid fa-book-reader"></i> Borrow Requests
                </a>
                <ul class="dropdown-menu" aria-labelledby="BorrowsDropdown">
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/adminBorrowRequests.jsp"><i class="fa-solid fa-hand-holding"></i>Borrow Requests</a></li>
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/adminBorrowHistory.jsp"><i class="fa-solid fa-history"></i>Borrow History</a></li>
                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/notReturnedBooks.jsp"><i class="fa-solid fa-history"></i>Pending Books</a></li>
                </ul>
            </li>
             <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/charts.jsp"><i class="fa-solid fa-chart-pie"></i>Chart</a></li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/logout.jsp" class="btn btn-logout ms-3"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </li>
        </ul>
    </div>
</nav>
    
<div class="container mt-5">
    <h2 class="text-center mb-4">📚 Manage Books</h2>
<%
    String successMsg = null;
    String errorMsg = null;

    if (session != null) {
        successMsg = (String) session.getAttribute("successMessage");
        errorMsg = (String) session.getAttribute("errorMessage");
        session.removeAttribute("successMessage");
        session.removeAttribute("errorMessage");
    }
%>

<% if (successMsg != null) { %>
    <div class="alert alert-success alert-dismissible fade show" role="alert" style="margin:20px;">
        <%= successMsg %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
<% } %>

<% if (errorMsg != null) { %>
    <div class="alert alert-danger alert-dismissible fade show" role="alert" style="margin:20px;">
        <%= errorMsg %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
<% } %>

<a href="<%= contextPath %>/admin/addBooks.jsp" class="btn btn-add mb-3">
    <i class="fas fa-plus"></i> Add Book
</a>

<div class="table-container">
    <table class="table table-hover">
        <thead>
            <tr>
                <th>ID</th>
                <th>Title</th>
                <th>Author</th>
                <th>Category</th>
                <th>ISBN</th>
                <th>Publisher</th>
                <th>Year</th>
                <th>Language</th>
                <th>Copies</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
<%
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();
        ps = conn.prepareStatement("SELECT * FROM books ORDER BY created_at DESC");
        rs = ps.executeQuery();
        while (rs.next()) {
%>
            <tr>
                <td><%= rs.getInt("id") %></td>
                <td><%= rs.getString("title") %></td>
                <td><%= rs.getString("author") %></td>
                <td><%= rs.getString("category") %></td>
                <td><%= rs.getString("isbn") %></td>
                <td><%= rs.getString("publisher") %></td>
                <td><%= rs.getInt("pub_year") %></td>
                <td><%= rs.getString("language") %></td>
                <td><%= rs.getInt("copies") %></td>
                <td>
                    <a href="<%= contextPath %>/EditBookServlet?id=<%= rs.getInt("id") %>" 
                       class="btn btn-warning btn-sm">
                        <i class="fas fa-edit"></i> 
                    </a>
                    <a href="<%= contextPath %>/DeleteBookServlet?id=<%= rs.getInt("id") %>" 
                       class="btn btn-danger btn-sm" 
                       onclick="return confirm('Are you sure you want to delete this book?');">
                        <i class="fas fa-trash-alt"></i> 
                    </a>
                </td>
            </tr>
<%
        }
    } catch (Exception e) {
        out.println("<tr><td colspan='10' class='text-danger'>Error loading books: " + e.getMessage() + "</td></tr>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (ps != null) try { ps.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%>
        </tbody>
    </table>
</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
