<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, com.utils.DBConnection" %>

<%
    String contextPath = request.getContextPath();

    List<Map<String, String>> pendingUsers = new ArrayList<>();
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(
            "SELECT id, name, email, phone, address, gender, dob FROM users WHERE status = 'pending' ORDER BY id DESC");
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            Map<String, String> user = new HashMap<>();
            user.put("id", rs.getString("id"));
            user.put("name", rs.getString("name"));
            user.put("email", rs.getString("email"));
            user.put("phone", rs.getString("phone"));
            user.put("address", rs.getString("address"));
            user.put("gender", rs.getString("gender"));
            user.put("dob", rs.getString("dob"));
            pendingUsers.add(user);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Pending User Approvals</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body { background-color: #f9f8ff; font-family: 'Segoe UI', sans-serif; }
        .card { background: white; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); padding: 20px; border-top: 5px solid #b39ddb; }
        .navbar { background-color: rgba(230, 230, 250, 0.9); border-bottom: 3px solid #AD49E1; box-shadow: 0 4px 15px rgba(173, 73, 225, 0.2); }
        .navbar-brand, .nav-link, .navbar-text { color: #2E073F !important; font-weight: 500; }
        .nav-link:hover { color: #7A1CAC !important; }
        .btn-logout { border: 2px solid #AD49E1; border-radius: 50px; padding: 5px 15px; color: #7A1CAC; transition: all 0.3s ease; }
        .btn-logout:hover { background-color: #AD49E1; color: white; }
        h2 { font-weight: 700; color: #6a1b9a; }
        .table thead { background-color: #b39ddb; color: white; }
        .table-hover tbody tr:hover { background-color: #f3e5f5; }
        .btn-success { background-color: #4caf50; border: none; }
        .btn-danger { background-color: #f44336; border: none; }
        .alert { border-radius: 8px; }
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
             <li class="nav-item"><a class="nav-link" href="adminDashboard.jsp"><i class="fa-solid fa-house"></i> Home</a></li>
             
             <li class="nav-item"><a class="nav-link" href="SearchBooks.jsp"><i class="fa-solid fa-search"></i> Search Books</a></li>
             
            <li class="nav-item"><a class="nav-link" href="manageBooks.jsp"><i class="fa-solid fa-cogs"></i> Manage Books</a></li>
        
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="membersDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="fa-solid fa-users"></i> Manage Members
                </a>
                <ul class="dropdown-menu" aria-labelledby="membersDropdown">
                    <li><a class="dropdown-item" href="pendingUser.jsp"> <i class="fa-solid fa-user-clock"></i>Pending Members</a></li>
                    <li><a class="dropdown-item" href="viewUsers.jsp"> <i class="fa-solid fa-user-check"></i>Members List</a></li>
                </ul>
            </li>
            
                <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="BorrowsDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="fa-solid fa-book-reader"></i> Borrow Requests
                </a>
                <ul class="dropdown-menu" aria-labelledby="BorrowsDropdown">
                    <li><a class="dropdown-item" href="adminBorrowRequests.jsp"><i class="fa-solid fa-hand-holding"></i>Borrow Requests</a></li>
                    <li><a class="dropdown-item" href="adminBorrowHistory.jsp"><i class="fa-solid fa-history"></i>Borrow History</a></li>
                    <li><a class="dropdown-item" href="notReturnedBooks.jsp"><i class="fa-solid fa-history"></i>Pending Books</a></li>
                </ul>
            </li>
             <li class="nav-item"><a class="nav-link" href="charts.jsp"><i class="fa-solid fa-chart-pie"></i>Chart</a></li>
            <li class="nav-item">
                <a href="../logout.jsp" class="btn btn-logout ms-3"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </li>
        </ul>
    </div>
</nav>

<div class="container mt-5">
    <div class="card">
        <h2 class="mb-4">👥 Pending User Registrations</h2>

        <% 
            String successMsg = (String) session.getAttribute("successMessage");
            String errorMsg = (String) session.getAttribute("errorMessage");
            session.removeAttribute("successMessage");
            session.removeAttribute("errorMessage");
        %>

        <% if (successMsg != null) { %>
            <div class="alert alert-success"><%= successMsg %></div>
        <% } %>
        <% if (errorMsg != null) { %>
            <div class="alert alert-danger"><%= errorMsg %></div>
        <% } %>

        <table class="table table-bordered table-hover align-middle">
            <thead>
                <tr>
                    <th>ID</th><th>Name</th><th>Email</th><th>Phone</th>
                    <th>Address</th><th>Gender</th><th>Date of Birth</th><th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if (pendingUsers.isEmpty()) { %>
                    <tr><td colspan="8" class="text-center text-muted">No pending users found.</td></tr>
                <% } else {
                    for (Map<String, String> user : pendingUsers) { %>
                        <tr>
                            <td><%= user.get("id") %></td>
                            <td><%= user.get("name") %></td>
                            <td><%= user.get("email") %></td>
                            <td><%= user.get("phone") != null ? user.get("phone") : "-" %></td>
                            <td><%= user.get("address") != null ? user.get("address") : "-" %></td>
                            <td><%= user.get("gender") != null ? user.get("gender") : "-" %></td>
                            <td><%= user.get("dob") != null ? user.get("dob") : "-" %></td>
                            <td>
                                <!-- Approve Form -->
                                <form action="../AdminApproveUserServlet" method="post" style="display:inline;">
                                    <input type="hidden" name="id" value="<%= user.get("id") %>">
                                    <input type="hidden" name="action" value="approve">
                                    <button type="submit" class="btn btn-success btn-sm">
                                        <i class="fa-solid fa-check"></i> Approve
                                    </button>
                                </form>
                                <!-- Reject Form -->
                                <form action="../AdminApproveUserServlet" method="post" style="display:inline;">
                                    <input type="hidden" name="id" value="<%= user.get("id") %>">
                                    <input type="hidden" name="action" value="reject">
                                    <button type="submit" class="btn btn-danger btn-sm">
                                        <i class="fa-solid fa-times"></i> Reject
                                    </button>
                                </form>
                            </td>
                        </tr>
                <%  } } %>
            </tbody>
        </table>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
