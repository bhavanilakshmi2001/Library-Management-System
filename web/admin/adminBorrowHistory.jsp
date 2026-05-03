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
    <title>Admin Borrow History</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            background-color: #f9f8ff; /* light violet background */
            font-family: 'Segoe UI', sans-serif;
        }

        /* Navbar */
        .navbar {
            background-color: #E6E6FA; 
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

        /* Card */
        .card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            padding: 20px;
            margin-top: 30px;
        }
        h2 {
            color: #7A1CAC;
            font-weight: 700;
            margin-bottom: 20px;
        }

        /* Table container for responsive */
        .table-container {
            overflow-x: auto;
        }

        /* Table styling */
        .table {
            border-collapse: separate;
            border-spacing: 0;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            border: 1px solid #AD49E1; /* violet outer border */
        }
        .table thead {
            background: linear-gradient(90deg, #AD49E1, #7A1CAC);
            color: white;
        }
        .table th, .table td {
            text-align: center;
            vertical-align: middle;
            padding: 12px 15px;
            border-bottom: 1px solid #AD49E1; /* violet line between rows */
        }
        .table tbody tr:nth-child(even) {
            background-color: #f7f5ff;
        }
        .table tbody tr:hover {
            background-color: #eae3ff;
        }

        /* Status badges as rectangle */
        .badge {
            border-radius: 0; /* rectangle */
            padding: 5px 10px;
            font-size: 0.85rem;
            font-weight: 500;
        }
        .status-pending { background-color: #FFD700; color: #000; }
        .status-approved { background-color: #28a745; color: white; }
        .status-returned { background-color: #17a2b8; color: white; }
        .status-rejected { background-color: #dc3545; color: white; }

        .btn-sm { padding: 4px 12px; font-size: 0.85rem; }
        .alert { border-radius: 8px; }

        @media (max-width: 768px) {
            .table th, .table td { padding: 8px 10px; font-size: 0.85rem; }
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
        <h2><i class="fas fa-book-reader me-2"></i>Borrow History</h2>

        <%-- Messages --%>
        <%
            String successMessage = (String) session.getAttribute("successMessage");
            String errorMessage = (String) session.getAttribute("errorMessage");
            session.removeAttribute("successMessage");
            session.removeAttribute("errorMessage");
            if(successMessage != null) {
        %>
            <div class="alert alert-success text-center"><%= successMessage %></div>
        <% } else if(errorMessage != null) { %>
            <div class="alert alert-danger text-center"><%= errorMessage %></div>
        <% } %>

        <div class="table-container">
            <table class="table table-hover align-middle">
                <thead>
                    <tr>
                        <th><i class="fas fa-user me-1"></i> User</th>
                        <th><i class="fas fa-book me-1"></i> Book Title</th>
                        <th><i class="fas fa-calendar-check me-1"></i> Request Date</th>
                        <th><i class="fas fa-info-circle me-1"></i> Status</th>
                        <th><i class="fas fa-calendar-plus me-1"></i> Issue Date</th>
                        <th><i class="fas fa-calendar-times me-1"></i> Expiry Date</th>
                        <th><i class="fas fa-calendar-day me-1"></i> Return Date</th>
                        <th><i class="fas fa-coins me-1"></i> Fine</th>
                        <th><i class="fas fa-cogs me-1"></i> Actions</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    try {
                        conn = DBConnection.getConnection();
                        String sql = "SELECT br.id, u.name AS username, b.title, br.request_date, br.status, br.issue_date, br.expiry_date, br.return_date " +
                                     "FROM borrow_requests br " +
                                     "JOIN users u ON br.user_id = u.id " +
                                     "JOIN books b ON br.book_id = b.id " +
                                     "ORDER BY br.request_date DESC";
                        ps = conn.prepareStatement(sql);
                        rs = ps.executeQuery();
                        boolean hasRecords = false;

                        while(rs.next()) {
                            hasRecords = true;
                            int borrowRequestId = rs.getInt("id");
                            String username = rs.getString("username");
                            String title = rs.getString("title");
                            Timestamp requestDate = rs.getTimestamp("request_date");
                            String status = rs.getString("status");
                            Date issueDate = rs.getDate("issue_date");
                            Date expiryDate = rs.getDate("expiry_date");
                            Date returnDate = rs.getDate("return_date");

                            String fineDisplay = "-";
                            if ("returned".equalsIgnoreCase(status) && returnDate != null && expiryDate != null) {
                                long daysLate = ChronoUnit.DAYS.between(expiryDate.toLocalDate(), returnDate.toLocalDate());
                                fineDisplay = (daysLate > 0) ? String.valueOf(daysLate * 10) : "0";
                            } else if ("approved".equalsIgnoreCase(status) && expiryDate != null) {
                                LocalDate today = LocalDate.now();
                                if (expiryDate.toLocalDate().isBefore(today)) {
                                    long daysLate = ChronoUnit.DAYS.between(expiryDate.toLocalDate(), today);
                                    fineDisplay = daysLate * 10 + " (accumulating)";
                                } else {
                                    fineDisplay = "0";
                                }
                            }
                %>
                    <tr>
                        <td><%= username %></td>
                        <td><%= title %></td>
                        <td><%= requestDate %></td>
                        <td>
                            <% if ("pending".equalsIgnoreCase(status)) { %>
                                <span class="badge status-pending">Pending</span>
                            <% } else if ("approved".equalsIgnoreCase(status)) { %>
                                <span class="badge status-approved">Approved</span>
                            <% } else if ("returned".equalsIgnoreCase(status)) { %>
                                <span class="badge status-returned">Returned</span>
                            <% } else { %>
                                <span class="badge status-rejected">Rejected</span>
                            <% } %>
                        </td>
                        <td><%= (issueDate != null) ? issueDate.toString() : "-" %></td>
                        <td><%= (expiryDate != null) ? expiryDate.toString() : "-" %></td>
                        <td><%= (returnDate != null) ? returnDate.toString() : "-" %></td>
                        <td><%= fineDisplay %></td>
                        <td>
                            <% if ("approved".equalsIgnoreCase(status)) { %>
                                <form action="<%= request.getContextPath() %>/ReturnBookServlet" method="post" onsubmit="return confirm('Mark book as returned?');">
                                    <input type="hidden" name="borrowRequestId" value="<%= borrowRequestId %>" />
                                    <button type="submit" class="btn btn-warning btn-sm">Return</button>
                                </form>
                            <% } else { %>
                                <span class="text-muted">-</span>
                            <% } %>
                        </td>
                    </tr>
                <%
                        }
                        if(!hasRecords) {
                %>
                    <tr>
                        <td colspan="9" class="text-center text-muted">No borrow history found.</td>
                    </tr>
                <%
                        }
                    } catch(Exception e) {
                %>
                    <tr>
                        <td colspan="9" class="text-danger">Error: <%= e.getMessage() %></td>
                    </tr>
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
