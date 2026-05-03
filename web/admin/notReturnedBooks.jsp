<%@ page import="java.sql.*, java.time.*, java.time.temporal.ChronoUnit, com.utils.DBConnection" %> 
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Not Returned Books</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            background-color: #f9f8ff;
            font-family: 'Segoe UI', sans-serif;
        }
        .navbar {
            background-color: #E6E6FA; 
            border-bottom: 3px solid #AD49E1;
            box-shadow: 0 4px 15px rgba(173, 73, 225, 0.2);
        }
        .navbar-brand, .nav-link, .navbar-text { color: #2E073F !important; font-weight: 500; }
        .nav-link:hover { color: #7A1CAC !important; }
        .btn-logout {
            background-color: transparent; border: 2px solid #AD49E1; border-radius: 50px;
            padding: 5px 15px; color: #7A1CAC; font-weight: 500; transition: all 0.3s ease;
        }
        .btn-logout:hover { background-color: #AD49E1; color: white; }
        .card {
            background: white; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            padding: 20px; margin-top: 30px;
        }
        h2 { color: #7A1CAC; font-weight: 700; margin-bottom: 20px; }
        .table-container { overflow-x: auto; }
        .table {
            border-collapse: separate; border-spacing: 0; border-radius: 12px;
            overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.1); border: 1px solid #AD49E1;
        }
        .table thead { background: linear-gradient(90deg, #AD49E1, #7A1CAC); color: white; }
        .table th, .table td {
            text-align: center; vertical-align: middle; padding: 12px 15px; border-bottom: 1px solid #AD49E1;
        }
        .table tbody tr:nth-child(even) { background-color: #f7f5ff; }
        .table tbody tr:hover { background-color: #eae3ff; }
        .badge { border-radius: 0; padding: 5px 10px; font-size: 0.85rem; font-weight: 500; }
        .status-approved { background-color: #28a745; color: white; }
        .alert { border-radius: 8px; }
        @media (max-width: 768px) { .table th, .table td { padding: 8px 10px; font-size: 0.85rem; } }
        .dropdown-menu { background-color: rgba(230, 230, 250, 0.95); border: 1px solid #AD49E1; }
        .dropdown-item:hover { background-color: #AD49E1; color: white; }
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

<div class="container">
    <div class="card">
        <h2><i class="fas fa-book-open me-2"></i> Not Returned Books</h2>
        <div class="table-container">
            <table class="table table-hover align-middle">
                <thead>
                    <tr>
                        <th>User</th>
                        <th>Book Title</th>
                        <th>Issue Date</th>
                        <th>Expiry Date</th>
                        <th>Fine (so far)</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    try {
                        conn = DBConnection.getConnection();
                        String sql = "SELECT u.name AS username, b.title, br.issue_date, br.expiry_date " +
                                     "FROM borrow_requests br " +
                                     "JOIN users u ON br.user_id = u.id " +
                                     "JOIN books b ON br.book_id = b.id " +
                                     "WHERE br.status = 'approved' AND br.return_date IS NULL " +
                                     "ORDER BY br.expiry_date ASC";
                        ps = conn.prepareStatement(sql);
                        rs = ps.executeQuery();
                        boolean hasRecords = false;

                        while(rs.next()) {
                            hasRecords = true;
                            String username = rs.getString("username");
                            String title = rs.getString("title");
                            Date issueDate = rs.getDate("issue_date");
                            Date expiryDate = rs.getDate("expiry_date");

                            // Calculate fine if overdue
                            String fineDisplay = "0";
                            if (expiryDate != null) {
                                LocalDate today = LocalDate.now();
                                LocalDate expDate = expiryDate.toLocalDate();
                                if (expDate.isBefore(today)) {
                                    long daysLate = ChronoUnit.DAYS.between(expDate, today);
                                    fineDisplay = String.valueOf(daysLate * 10);
                                }
                            }
                %>
                    <tr>
                        <td><%= username %></td>
                        <td><%= title %></td>
                        <td><%= (issueDate != null) ? issueDate.toString() : "-" %></td>
                        <td><%= (expiryDate != null) ? expiryDate.toString() : "-" %></td>
                        <td><%= fineDisplay %></td>
                        <td><span class="badge status-approved">Not Returned</span></td>
                    </tr>
                <%
                        }
                        if(!hasRecords) {
                %>
                    <tr><td colspan="6" class="text-center text-muted">All books are returned ✅</td></tr>
                <%
                        }
                    } catch(Exception e) {
                %>
                    <tr><td colspan="6" class="text-danger">Error: <%= e.getMessage() %></td></tr>
                <%
                    } finally {
                        if(rs != null) try { rs.close(); } catch(Exception e) {}
                        if(ps != null) try { ps.close(); } catch(Exception e) {}
                        if(conn != null) try { conn.close(); } catch(Exception e) {}
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
