<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    ResultSet user = (ResultSet) request.getAttribute("user");
    Integer borrowCount = (Integer) request.getAttribute("borrowCount");
    ResultSet borrowList = (ResultSet) request.getAttribute("borrowList");
%>
<!DOCTYPE html>
<html>
<head>
    <title>User Details</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <!-- Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        body {
            background-color: #f8f6fc; /* light violet background */
            margin-top: 80px; /* Offset for fixed navbar */
        }

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

        /* Headings */
        h2, h3 {
            color: #5A189A; /* Dark violet */
            font-weight: bold;
            border-left: 5px solid #9D4EDD;
            padding-left: 10px;
        }

        /* Card */
        .card {
            border: 1px solid #D0A2F7;
            background: #fff;
            box-shadow: 0px 4px 15px rgba(157, 78, 221, 0.2);
            border-radius: 12px;
        }
        .card h4 { color: #7A1CAC; }

        /* Table */
        .table {
            background: #fff;
        }
        .table thead {
            background-color: #E6E6FA; /* violet header */
            color: #2E073F;
        }
        .table-bordered {
            border: 2px solid #D0A2F7;
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
             <li class="nav-item"><a class="nav-link" href="admin/adminDashboard.jsp"><i class="fa-solid fa-house"></i> Home</a></li>
             
             <li class="nav-item"><a class="nav-link" href="admin/SearchBooks.jsp"><i class="fa-solid fa-search"></i> Search Books</a></li>
             
            <li class="nav-item"><a class="nav-link" href="admin/manageBooks.jsp"><i class="fa-solid fa-cogs"></i> Manage Books</a></li>
        
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="membersDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="fa-solid fa-users"></i> Manage Members
                </a>
                <ul class="dropdown-menu" aria-labelledby="membersDropdown">
                    <li><a class="dropdown-item" href="admin/pendingUser.jsp"> <i class="fa-solid fa-user-clock"></i>Pending Members</a></li>
                    <li><a class="dropdown-item" href="admin/viewUsers.jsp"> <i class="fa-solid fa-user-check"></i>Members List</a></li>
                </ul>
            </li>
            
                <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="BorrowsDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="fa-solid fa-book-reader"></i> Borrow Requests
                </a>
                <ul class="dropdown-menu" aria-labelledby="BorrowsDropdown">
                    <li><a class="dropdown-item" href="admin/adminBorrowRequests.jsp"><i class="fa-solid fa-hand-holding"></i>Borrow Requests</a></li>
                    <li><a class="dropdown-item" href="admin/adminBorrowHistory.jsp"><i class="fa-solid fa-history"></i>Borrow History</a></li>
                    <li><a class="dropdown-item" href="admin/notReturnedBooks.jsp"><i class="fa-solid fa-history"></i>Pending Books</a></li>
                </ul>
            </li>
             <li class="nav-item"><a class="nav-link" href="admin/charts.jsp"><i class="fa-solid fa-chart-pie"></i>Chart</a></li>
            <li class="nav-item">
                <a href="../logout.jsp" class="btn btn-logout ms-3"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </li>
        </ul>
    </div>
</nav>

    <div class="container">
        <h2 class="mb-3">User Details</h2>
        <%
            if(user != null){
        %>
        <div class="card p-3 mb-3">
            <h4><%= user.getString("name") %> (<%= user.getString("email") %>)</h4>
            <p><b>Phone:</b> <%= user.getString("phone") %></p>
            <p><b>Address:</b> <%= user.getString("address") %></p>
            <p><b>Status:</b> <%= user.getString("status") %></p>
            <p><b>Total Borrowed Books:</b> <%= borrowCount %></p>
        </div>
        <%
            }
        %>

        <h3>Borrowed Books</h3>
        <table class="table table-bordered shadow-sm">
            <thead>
                <tr>
                    <th>Title</th>
                    <th>Status</th>
                    <th>Issue Date</th>
                    <th>Expiry Date</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if(borrowList != null){
                        while(borrowList.next()){
                %>
                <tr>
                    <td><%= borrowList.getString("title") %></td>
                    <td>
                        <% String status = borrowList.getString("status"); %>
                        <% if("Accepted".equalsIgnoreCase(status)){ %>
                            <span class="badge bg-success">Accepted</span>
                        <% } else if("Rejected".equalsIgnoreCase(status)){ %>
                            <span class="badge bg-danger">Rejected</span>
                        <% } else if("Returned".equalsIgnoreCase(status)){ %>
                            <span class="badge bg-info">Returned</span>
                        <% } else { %>
                            <span class="badge bg-secondary"><%= status %></span>
                        <% } %>
                    </td>
                    <td><%= borrowList.getString("issue_date") %></td>
                    <td><%= borrowList.getString("expiry_date") %></td>
                </tr>
                <%
                        }
                    }
                %>
            </tbody>
        </table>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>