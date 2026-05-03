<%@ page import="java.sql.*, com.utils.DBConnection" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("userLogin.jsp");
        return;
    }

    String idStr = request.getParameter("id");
    if (idStr == null) {
        response.sendRedirect("searchBooks.jsp");
        return;
    }
    int bookId = Integer.parseInt(idStr);

    Map<String, Object> book = null;
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement("SELECT * FROM books WHERE id=?")) {
        ps.setInt(1, bookId);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                book = new HashMap<>();
                book.put("id", bookId);
                book.put("title", rs.getString("title"));
                book.put("author", rs.getString("author"));
                book.put("category", rs.getString("category"));
                book.put("isbn", rs.getString("isbn"));
                book.put("publisher", rs.getString("publisher"));
                book.put("pub_year", rs.getInt("pub_year"));
                book.put("language", rs.getString("language"));
                book.put("copies", rs.getInt("copies"));
                book.put("description", rs.getString("description"));
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    if (book == null) {
        response.sendRedirect("searchBooks.jsp");
        return;
    }

    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    session.removeAttribute("successMessage");
    session.removeAttribute("errorMessage");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Book Details - <%= book.get("title") %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f9f8ff;
        }

        /* Navbar */
        .navbar {
            background-color: #E6E6FA;
            border-bottom: 3px solid #AD49E1;
            box-shadow: 0 4px 15px rgba(173, 73, 225, 0.2);
        }
        .navbar-brand, .nav-link { color: #2E073F !important; font-weight: 500; }
        .nav-link:hover { color: #7A1CAC !important; }

        /* Card Styling */
        .book-card {
            border-radius: 20px;
            max-width: 700px;
            margin: 40px auto;
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
            overflow: hidden;
            transition: transform 0.3s;
        }
        .book-card:hover { transform: translateY(-5px); }
        .book-card-header {
            background: linear-gradient(90deg, #AD49E1, #7A1CAC);
            color: #fff;
            font-size: 1.6rem;
            font-weight: 700;
            padding: 20px;
            text-align: center;
        }
        .book-card-body {
            padding: 25px;
        }
        .book-info p {
            font-size: 1.05rem;
            margin-bottom: 10px;
        }
        .book-card-footer {
            padding: 20px;
            text-align: center;
            background-color: #f5f0ff;
        }
        .btn-borrow {
            border-radius: 50px;
            padding: 10px 25px;
            background: linear-gradient(90deg, #AD49E1, #7A1CAC);
            color: white;
            border: none;
            font-weight: 500;
            transition: 0.3s;
        }
        .btn-borrow:hover { background: linear-gradient(90deg, #7A1CAC, #AD49E1); }
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

        <nav class="navbar navbar-expand-lg px-4">
    <a class="navbar-brand fw-bold" href="#">📚 Library User</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#userNavbar" aria-controls="userNavbar" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="userNavbar">
        <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
             <li class="nav-item"><a class="nav-link" href="userDashboard.jsp"><i class="fa-solid fa-house"></i> Home</a></li>
            <li class="nav-item"><a class="nav-link" href="SearchBooks.jsp"><i class="fas fa-search me-1"></i>Search Books</a></li>
            <li class="nav-item"><a class="nav-link" href="userBorrowHistory.jsp"><i class="fas fa-book me-1"></i>Borrow History</a></li>
 <li class="nav-item"><a class="nav-link" href="userChart.jsp"><i class="fa-solid fa-chart-pie"></i> Chart</a></li>
           <li class="nav-item ms-3"><a href="../logout.jsp" class="btn btn-logout"><i class="fas fa-sign-out-alt me-1"></i>Logout</a></li>
        </ul>
    </div>
</nav>

<% if (successMessage != null) { %>
    <div class="alert alert-success alert-dismissible fade show mt-3" role="alert">
        <%= successMessage %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
<% } else if (errorMessage != null) { %>
    <div class="alert alert-danger alert-dismissible fade show mt-3" role="alert">
        <%= errorMessage %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
<% } %>

<div class="book-card">
    <div class="book-card-header">
        <i class="fas fa-book me-2"></i> <%= book.get("title") %>
    </div>
    <div class="book-card-body book-info">
        <p><strong>Author:</strong> <%= book.get("author") %></p>
        <p><strong>Category:</strong> <%= book.get("category") %></p>
        <p><strong>ISBN:</strong> <%= book.get("isbn") %></p>
        <p><strong>Publisher:</strong> <%= book.get("publisher") %></p>
        <p><strong>Publication Year:</strong> <%= book.get("pub_year") %></p>
        <p><strong>Language:</strong> <%= book.get("language") %></p>
        <p><strong>Copies available:</strong> <%= book.get("copies") %></p>
        <% if (book.get("description") != null) { %>
            <p><strong>Description:</strong> <%= book.get("description") %></p>
        <% } %>
    </div>
    <div class="book-card-footer">
        <% int copies = (int) book.get("copies"); %>
        <% if (copies > 0) { %>
            <form action="<%=request.getContextPath()%>/UserBorrowServlet" method="post" style="display:inline;">
                <input type="hidden" name="bookId" value="<%= book.get("id") %>" />
                <button type="submit" class="btn btn-borrow"><i class="fas fa-hand-paper me-1"></i> Borrow this Book</button>
            </form>
        <% } else { %>
            <button type="button" class="btn btn-secondary" disabled>Not Available</button>
        <% } %>
      
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
