<%@ page import="java.sql.*, com.utils.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
    String adminName = (String) session.getAttribute("adminName");
    if(adminName == null){
        response.sendRedirect("../adminLogin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>View Users - Admin</title>
   
<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
    body {
        background-color: #f9f8ff; /* white background */
        color: #2E073F;
        font-family: 'Poppins', sans-serif;
        min-height: 100vh;
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

    /* Table */
    .table-container {
        background: #ffffff;
        padding: 20px;
        border-radius: 15px;
        box-shadow: 0 6px 20px rgba(0,0,0,0.08);
        margin-top: 40px;
    }
    .table thead {
        background: linear-gradient(90deg, #AD49E1, #7A1CAC);
        color: white;
        text-transform: uppercase;
    }
    .table th, .table td {
        text-align: center;
        vertical-align: middle;
        padding: 12px 15px;
        border-bottom: 1px solid #AD49E1;
    }
    .table tbody tr:nth-child(even) { background-color: #f7f5ff; }
    .table tbody tr:hover { background-color: #eae3ff; }

    h2 {
        color: #7A1CAC;
        font-weight: 700;
        margin: 20px 0;
        text-align: center;
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
        .container-fluid { padding-top: 70px; }
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


<div class="container-fluid table-container">
    <h2>All Users</h2>
    <div class="table-responsive">
        <table class="table table-striped table-hover table-bordered">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Address</th>
                    <th>Gender</th>
                    <th>DOB</th>
                   <th>Actions</th>

                </tr>
            </thead>
            <tbody>
            <% 
                try {
                    Connection con = DBConnection.getConnection();
                    PreparedStatement ps = con.prepareStatement("SELECT * FROM users");
                    ResultSet rs = ps.executeQuery();
                    while(rs.next()){
            %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td style="white-space: nowrap;"><%= rs.getString("name") %></td>
                    <td style="white-space: nowrap;"><%= rs.getString("email") %></td>
                    <td style="white-space: nowrap;"><%= rs.getString("phone") %></td>
                    <td><%= rs.getString("address") %></td>
                    <td style="white-space: nowrap;"><%= rs.getString("gender") %></td>
                    <td style="white-space: nowrap;"><%= rs.getDate("dob") %></td>
                    
                    <td>
                    <a href="../AdminUserDetailsServlet?userId=<%= rs.getInt("id") %>" 
                       class="btn btn-sm btn-info">
                       <i class="fa-solid fa-eye"></i> View
                    </a>
                    </td>

                </tr>
            <%
                    }
                    rs.close();
                    ps.close();
                    con.close();
                } catch(Exception e) { out.println(e); }
            %>
            </tbody>
        </table>
    </div>
</div>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
