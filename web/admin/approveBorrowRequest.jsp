<%@ page import="java.sql.*, com.utils.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String idStr = request.getParameter("id");
    if (idStr == null || idStr.trim().isEmpty()) {
        response.sendRedirect("adminBorrowRequests.jsp");
        return;
    }
    int requestId = Integer.parseInt(idStr);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Approve Borrow Request</title>
     <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />

    <style>
        body {
            background-color: #f8f6fc; /* Light violet background */
            font-family: 'Segoe UI', sans-serif;
        }
        .card {
            background-color: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            padding: 20px;
            border-top: 5px solid #a78bfa; /* Violet accent */
        }
        h2 {
            color: #6d28d9; /* Dark violet heading */
            font-weight: bold;
        }
        .form-label {
            font-weight: 500;
            color: #4b5563;
        }
        .btn-primary {
            background-color: #8b5cf6; /* Violet button */
            border: none;
            transition: background-color 0.3s ease;
        }
        .btn-primary:hover {
            background-color: #7c3aed;
        }
        .btn-secondary {
            background-color: #e5e7eb;
            color: #374151;
            border: none;
        }
        .btn-secondary:hover {
            background-color: #d1d5db;
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
        <h2 class="mb-4">📚 Approve Borrow Request #<%= requestId %></h2>

        <form action="<%= request.getContextPath() %>/AdminBorrowRequestServlet" method="post">
            <input type="hidden" name="id" value="<%= requestId %>" />
            <input type="hidden" name="action" value="approve" />

            <div class="mb-3">
                <label for="issueDate" class="form-label">Issue Date</label>
                <input type="date" id="issueDate" name="issueDate" class="form-control" required />
            </div>

            <div class="mb-3">
                <label for="expiryDate" class="form-label">Expiry Date</label>
                <input type="date" id="expiryDate" name="expiryDate" class="form-control" required />
            </div>

            <button type="submit" class="btn btn-primary me-2">✅ Approve Request</button>
            <a href="adminBorrowRequests.jsp" class="btn btn-secondary">❌ Cancel</a>
        </form>
    </div>
</div>

<script>
  document.querySelector('form').addEventListener('submit', function(e) {
    const issueDate = document.getElementById('issueDate').value;
    const expiryDate = document.getElementById('expiryDate').value;
    if(issueDate && expiryDate && expiryDate <= issueDate) {
      alert('Expiry Date must be after Issue Date.');
      e.preventDefault();
    }
  });
</script>

</body>
</html>
