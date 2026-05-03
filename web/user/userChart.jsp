<%@ page import="java.sql.*, java.util.*, com.utils.DBConnection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ page session="true" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("userLogin.jsp");
        return;
    }

    Map<String, Integer> categoryData = new LinkedHashMap<>();
    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(
             "SELECT b.category, COUNT(*) as cnt " +
             "FROM borrow_requests br " +
             "JOIN books b ON br.book_id = b.id " +
             "WHERE br.user_id=? AND br.status IN ('approved','returned') " +
             "GROUP BY b.category")) {
        
        ps.setInt(1, userId);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                categoryData.put(rs.getString("category"), rs.getInt("cnt"));
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Borrow Chart</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
          /* Navbar */
        .navbar {
            background-color: #E6E6FA;
            border-bottom: 3px solid #AD49E1;
            box-shadow: 0 4px 15px rgba(173, 73, 225, 0.2);
        }
        .navbar-brand, .nav-link { color: #2E073F !important; font-weight: 500; }
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
<body class="bg-light">
    
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

<div class="container my-5">
    <div class="card shadow-lg border-0 rounded-4">
        <div class="card-body">
            <h3 class="text-center fw-bold mb-4" style="color:#7A1CAC;">📊 Your Borrowing Preferences</h3>
            <canvas id="borrowChart" style="max-height:400px;"></canvas>
        </div>
    </div>
</div>

<script>
    const ctx = document.getElementById('borrowChart').getContext('2d');
    const borrowChart = new Chart(ctx, {
        type: 'pie',
        data: {
            labels: [<%
                for (String cat : categoryData.keySet()) {
                    out.print("'" + cat + "',");
                }
            %>],
            datasets: [{
                data: [<%
                    for (Integer val : categoryData.values()) {
                        out.print(val + ",");
                    }
                %>],
                backgroundColor: [
                    '#7A1CAC', '#AD49E1', '#E6E6FA',
                    '#FF7EB9', '#8DFF7E', '#FFD93D'
                ],
                borderColor: '#fff',
                borderWidth: 2
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: {
                        color: '#2E073F',
                        font: { size: 14, weight: 'bold' }
                    }
                },
                tooltip: { enabled: true }
            }
        }
    });
</script>

</body>
</html>
