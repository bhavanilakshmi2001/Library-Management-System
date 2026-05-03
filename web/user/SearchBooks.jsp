<%@ page import="java.sql.*, java.util.*, com.utils.DBConnection" %> 
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String searchTerm = request.getParameter("searchTerm") != null ? request.getParameter("searchTerm").trim() : "";

    List<Map<String, Object>> books = new ArrayList<>();
    boolean hasFilter = !searchTerm.isEmpty();

    if (hasFilter) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM books WHERE title LIKE ? OR author LIKE ? OR category LIKE ? OR isbn LIKE ? OR language LIKE ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                String likeTerm = "%" + searchTerm + "%";
                for (int i = 1; i <= 5; i++) ps.setString(i, likeTerm);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> book = new HashMap<>();
                        book.put("id", rs.getInt("id"));
                        book.put("title", rs.getString("title"));
                        book.put("author", rs.getString("author"));
                        book.put("category", rs.getString("category"));
                        book.put("isbn", rs.getString("isbn"));
                        book.put("publisher", rs.getString("publisher"));
                        book.put("pub_year", rs.getInt("pub_year"));
                        book.put("language", rs.getString("language"));
                        book.put("copies", rs.getInt("copies"));
                        books.add(book);
                    }
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Search Books</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        body {
            background-color: #f9f8ff;
            font-family: 'Segoe UI', sans-serif;
            padding: 10px;
        }

        /* Navbar */
        .navbar {
            background-color: #E6E6FA;
            border-bottom: 3px solid #AD49E1;
            box-shadow: 0 4px 15px rgba(173, 73, 225, 0.2);
        }
        .navbar-brand, .nav-link { color: #2E073F !important; font-weight: 500; }
        .nav-link:hover { color: #7A1CAC !important; }

        /* Search box */
        .search-small {
            display: flex;
            max-width: 600px;
            margin: 15px auto;
        }
        .search-small input {
            border-radius: 50px 0 0 50px;
            flex: 1;
            padding: 8px 12px;
            border: 1px solid #AD49E1;
        }
        .search-small button {
            border-radius: 0 50px 50px 0;
            border: 1px solid #AD49E1;
            background-color: #AD49E1;
            color: white;
            padding: 8px 12px;
        }
        .search-small button:hover { background-color: #7A1CAC; }

        /* Table styling */
        .table-container {
            margin-top: 20px;
        }
        .table th, .table td {
            font-size: 0.95rem;
            text-align: center;
            vertical-align: middle;
            padding: 10px;
            min-width: 80px;
        }
        .table td { white-space: nowrap; }
        .book-details-btn { padding: 4px 10px; font-size: 0.85rem; border-radius: 50px; background-color: #AD49E1; color: white; border: none; }
        .book-details-btn:hover { background-color: #7A1CAC; }
        .table thead th { background-color: #AD49E1; color: white; }
        
           /* Floating images */
        .floating-img {
            position: absolute;
            width: 120px;
            opacity: 0.1;
            animation: floatAnim 6s ease-in-out infinite alternate;
        }
        .floating-img.img1 { top: 10%; left: 5%; animation-delay: 0s; }
        .floating-img.img2 { bottom: 15%; right: 10%; animation-delay: 2s; }
        .floating-img.img3 { top: 20%; right: 15%; animation-delay: 4s; }
        .floating-img.img4 { top: 40%; left: 25%; animation-delay: 1s; }
        .floating-img.img5 { bottom: 30%; left: 50%; animation-delay: 3s; }
        
         @keyframes floatAnim {
            0% { transform: translateY(0px); }
            50% { transform: translateY(-20px); }
            100% { transform: translateY(0px); }}
            
          /* Add space below navbar */
        .search-small { padding-top: 150px; }
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

<!-- Search form -->
<form method="get" action="SearchBooks.jsp" class="search-small">
    <input type="text" name="searchTerm" placeholder="Search by Title,Author,Category,ISBN,Language" value="<%= searchTerm %>"/>
    <button type="submit"><i class="fas fa-search"></i></button>
</form>
    <!-- Floating library images -->
    <img src="https://img.icons8.com/ios-filled/100/book.png" class="floating-img img1" alt="book icon" />
    <img src="https://img.icons8.com/ios-filled/100/open-book.png" class="floating-img img2" alt="open book icon" />
    <img src="https://img.icons8.com/ios-filled/100/reading.png" class="floating-img img3" alt="reading icon" />
    <img src="https://img.icons8.com/ios-filled/100/library.png" class="floating-img img4" alt="library icon" />
    <img src="https://img.icons8.com/ios-filled/100/books.png" class="floating-img img5" alt="books icon" />
<!-- Results -->
<% if (hasFilter) { %>
    <% if (books.isEmpty()) { %>
        <p class="text-center text-danger">No books found.</p>
    <% } else { %>
        <div class="container-fluid table-container">
            <div class="table-responsive">
                <table class="table table-hover table-bordered align-middle text-center">
                    <thead>
                    <tr>
                        <th>Title</th>
                        <th>Author</th>
                        <th>Category</th>
                        <th>ISBN</th>
                        <th>Language</th>
                        <th>Publisher</th>
                        <th>Year</th>
                        <th>Copies</th>
                        <th>Details</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (Map<String, Object> b : books) { %>
                        <tr>
                            <td style="min-width:150px;"><%= b.get("title") %></td>
                            <td style="min-width:120px;"><%= b.get("author") %></td>
                            <td style="min-width:100px;"><%= b.get("category") %></td>
                            <td style="min-width:120px;"><%= b.get("isbn") %></td>
                            <td style="min-width:100px;"><%= b.get("language") %></td>
                            <td style="min-width:120px;"><%= b.get("publisher") %></td>
                            <td style="min-width:60px;"><%= b.get("pub_year") %></td>
                            <td style="min-width:60px;"><%= b.get("copies") %></td>
                            <td style="min-width:60px;">
                                <a href="bookDetails.jsp?id=<%= b.get("id") %>" class="book-details-btn">
                                    <i class="fas fa-eye"></i>
                                </a>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    <% } %>
<% } %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
