<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    String adminName = (String) session.getAttribute("adminName");
    if (adminName == null) {
        response.sendRedirect("../adminLogin.jsp");
        return;
    }

    // Database counts
    int userCount = 0, bookCount = 0, borrowCount = 0, pendingRequests = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_db","root","root");

        // Users count (only approved users)
        Statement st = con.createStatement();
        ResultSet rs1 = st.executeQuery("SELECT COUNT(*) FROM users WHERE status='active'");
        if(rs1.next()) userCount = rs1.getInt(1);

        // Books count
        ResultSet rs2 = st.executeQuery("SELECT COUNT(*) FROM books");
        if(rs2.next()) bookCount = rs2.getInt(1);

        // Borrowed books count (approved requests not yet returned)
        ResultSet rs3 = st.executeQuery("SELECT COUNT(*) FROM borrow_requests WHERE status='approved'");
        if(rs3.next()) borrowCount = rs3.getInt(1);

        // Pending requests
        ResultSet rs4 = st.executeQuery("SELECT COUNT(*) FROM borrow_requests WHERE status='pending'");
        if(rs4.next()) pendingRequests = rs4.getInt(1);

        con.close();
    } catch(Exception e){
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - Library System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <style>
        body {
            background: url('../images/library-bg.jpg') no-repeat center center fixed;
            background-size: cover;
            color: #2E073F;
            min-height: 100vh;
        }
        .navbar {
            background-color: rgba(230, 230, 250, 0.9);
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
        .btn-logout:hover {
            background-color: #AD49E1;
            color: white;
        }
        
         .dropdown-menu {
            background-color: rgba(230, 230, 250, 0.95);
            border: 1px solid #AD49E1;
        }
        .dropdown-item:hover {
            background-color: #AD49E1;
            color: white;
        }

        .container { padding-top: 180px; }

        .stat-card {
            border-radius: 20px;
            background: rgba(230, 230, 250, 0.95);
            padding: 25px;
            text-align: center;
            color: #2E073F;
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
            transition: transform 0.3s ease;
        }
        .stat-card:hover { transform: translateY(-8px); }
        .stat-card i { font-size: 3rem; margin-bottom: 15px; color: #7A1CAC; }
        .stat-card h3 { font-weight: bold; font-size: 2rem; }
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

<!-- Dashboard Statistic Cards -->
<div class="container my-5">
    <div class="row g-4">
        <div class="col-md-3">
            <div class="stat-card">
                <i class="fa-solid fa-users"></i>
                <h3><%= userCount %></h3>
                <p>Total Users</p>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <i class="fa-solid fa-book"></i>
                <h3><%= bookCount %></h3>
                <p>Total Books</p>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <i class="fa-solid fa-book-reader"></i>
                <h3><%= borrowCount %></h3>
                <p>Borrowed Books</p>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <i class="fa-solid fa-clock"></i>
                <h3><%= pendingRequests %></h3>
                <p>Pending Requests</p>
            </div>
        </div>
    </div>
</div>

</body>
</html>
