<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String contextPath = request.getContextPath();
    // Getting pre-filled data from request attributes
    int id = (int) request.getAttribute("id");
    String title = (String) request.getAttribute("title");
    String author = (String) request.getAttribute("author");
    String category = (String) request.getAttribute("category");
    String isbn = (String) request.getAttribute("isbn");
    String publisher = (String) request.getAttribute("publisher");
    String pubYear = (String) request.getAttribute("pub_year");
    String language = (String) request.getAttribute("language");
    int copies = (int) request.getAttribute("copies");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Book</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
       body {
            background-color: white;
        }

        /* Navbar */
        .navbar {
            background-color: rgba(230, 230, 250, 0.9); /* Light violet */
            border-bottom: 3px solid #AD49E1;
            box-shadow: 0 4px 15px rgba(173, 73, 225, 0.2);
        }
        .navbar-brand, .nav-link {
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

        /* Card styling */
        .card {
            border-radius: 12px;
            border: 1px solid #AD49E1;
            background-color: #f6e9ff;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }

        /* Heading */
        h2 {
            font-weight: bold;
            color: #7A1CAC;
        }

        /* Form labels */
        .form-label {
            color: #2E073F;
            font-weight: 500;
        }

        /* Input fields */
        .form-control {
            border: 1px solid #AD49E1;
            border-radius: 8px;
        }
        .form-control:focus {
            border-color: #7A1CAC;
            box-shadow: 0 0 6px rgba(173, 73, 225, 0.5);
        }

        /* Submit button */
        .btn-warning {
            background-color: #AD49E1;
            border: none;
            border-radius: 8px;
            font-weight: 500;
            transition: background 0.3s ease;
        }
        .btn-primary:hover {
            background-color: #7A1CAC;
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
             <li class="nav-item"><a class="nav-link" href="charts.jsp"><i class="fa-solid fa-chart-pie"></i>Chart</a></li>
            <li class="nav-item">
                <a href="../logout.jsp" class="btn btn-logout ms-3"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </li>
        </ul>
    </div>
</nav>
    

<div class="container mt-5">
    <h2 class="text-center mb-4">✏️ Edit Book</h2>
    <div class="card p-4">
        <form action="${pageContext.request.contextPath}/UpdateBookServlet" method="post">
            <!-- Hidden ID -->
            <input type="hidden" name="id" value="<%= id %>">

            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="form-label">Book Title</label>
                    <input type="text" name="title" class="form-control" value="<%= title %>" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Author</label>
                    <input type="text" name="author" class="form-control" value="<%= author %>" required>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-4">
                    <label class="form-label">Category</label>
                    <input type="text" name="category" class="form-control" value="<%= category %>" required>
                </div>
                <div class="col-md-4">
                    <label class="form-label">ISBN</label>
                    <input type="text" name="isbn" class="form-control" value="<%= isbn %>" required>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Publisher</label>
                    <input type="text" name="publisher" class="form-control" value="<%= publisher %>">
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-4">
                    <label class="form-label">Publication Year</label>
                    <input type="number" name="pub_year" class="form-control" value="<%= pubYear %>">
                </div>
                <div class="col-md-4">
                    <label class="form-label">Language</label>
                    <input type="text" name="language" class="form-control" value="<%= language %>">
                </div>
                <div class="col-md-4">
                    <label class="form-label">Copies Available</label>
                    <input type="number" name="copies" class="form-control" value="<%= copies %>" min="1" required>
                </div>
            </div>

            <button type="submit" class="btn btn-warning  w-100">💾 Update Book</button>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
