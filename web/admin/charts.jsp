<%@ page import="java.sql.*,java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // DB connection
    Connection con = null;
    Statement st = null;
    ResultSet rs = null;
    String url = "jdbc:mysql://localhost:3306/library_db";
    String user = "root";
    String pass = "root";  // change if needed

    // Data holders
    List<String> borrowMonths = new ArrayList<>();
    List<Integer> borrowCounts = new ArrayList<>();

    List<String> userMonths = new ArrayList<>();
    List<Integer> userCounts = new ArrayList<>();

    List<String> fineMonths = new ArrayList<>();
    List<Double> fineAmounts = new ArrayList<>();

    List<String> categoryLabels = new ArrayList<>();
    List<Integer> categoryCounts = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(url, user, pass);

        // Borrow Chart
        st = con.createStatement();
        rs = st.executeQuery("SELECT DATE_FORMAT(issue_date, '%Y-%m') AS month, COUNT(*) AS borrow_count " +
                             "FROM borrow_requests WHERE status IN ('approved','returned') " +
                             "GROUP BY month ORDER BY month");
        while (rs.next()) {
            borrowMonths.add(rs.getString("month"));
            borrowCounts.add(rs.getInt("borrow_count"));
        }

        // User Chart
        rs = st.executeQuery("SELECT DATE_FORMAT(created_at, '%Y-%m') AS month, COUNT(*) AS user_count " +
                             "FROM users WHERE status='active' AND role='user' " +
                             "GROUP BY month ORDER BY month");
        while (rs.next()) {
            userMonths.add(rs.getString("month"));
            userCounts.add(rs.getInt("user_count"));
        }

        // Fine Chart
        rs = st.executeQuery("SELECT DATE_FORMAT(return_date, '%Y-%m') AS month, SUM(fine_amount) AS total_fines " +
                             "FROM borrow_requests WHERE fine_amount > 0 " +
                             "GROUP BY month ORDER BY month");
        while (rs.next()) {
            fineMonths.add(rs.getString("month"));
            fineAmounts.add(rs.getDouble("total_fines"));
        }

        // Category Chart
        rs = st.executeQuery("SELECT b.category, COUNT(br.id) AS total " +
                             "FROM borrow_requests br " +
                             "JOIN books b ON br.book_id = b.id " +
                             "WHERE br.status IN ('approved','returned') " +
                             "GROUP BY b.category ORDER BY total DESC");
        while (rs.next()) {
            categoryLabels.add(rs.getString("category"));
            categoryCounts.add(rs.getInt("total"));
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (st != null) st.close();
        if (con != null) con.close();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Charts</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
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
        .container { padding-top: 80px; }

        /* 🔹 Medium Chart Styling */
        canvas {
            max-width: 100% !important;
            max-height: 300px !important;
            margin: auto;
        }
     

    </style>
</head>
<body class="bg-light">
    
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
    
<div class="container mt-4">
    <h3 class="text-center mb-4">📊 Admin Dashboard Charts</h3>
    <div class="row g-4">

        <!-- Borrow Chart -->
        <div class="col-md-6">
            <div class="card shadow-sm p-3">
                <h6 class="text-center">Monthly Borrows</h6>
                <canvas id="borrowChart"></canvas>
            </div>
        </div>

        <!-- User Chart -->
        <div class="col-md-6">
            <div class="card shadow-sm p-3">
                <h6 class="text-center">User Growth</h6>
                <canvas id="userChart"></canvas>
            </div>
        </div>

        <!-- Fines Chart -->
        <div class="col-md-6">
            <div class="card shadow-sm p-3">
                <h6 class="text-center">Fine Collection</h6>
                <canvas id="fineChart"></canvas>
            </div>
        </div>

        <!-- Category Chart -->
        <div class="col-md-6">
            <div class="card shadow-sm p-3">
                <h6 class="text-center">Books Borrowed by Category</h6>
                <canvas id="categoryChart"></canvas>
            </div>
        </div>
    </div>
</div>

<script>
    // Borrow Chart
    new Chart(document.getElementById('borrowChart'), {
        type: 'bar',
        data: {
            labels: [<% 
                for(int i=0;i<borrowMonths.size();i++){
                    out.print("\"" + borrowMonths.get(i) + "\"");
                    if(i != borrowMonths.size()-1) out.print(",");
                } 
            %>],
            datasets: [{
                label: 'Borrows',
                data: <%= borrowCounts.toString() %>,
                backgroundColor: 'rgba(54, 162, 235, 0.7)'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: true } },
            scales: {
                x: { title: { display: true, text: 'Month (YYYY-MM)' } },
                y: { title: { display: true, text: 'Number of Borrows' }, beginAtZero: true }
            }
        }
    });

    // User Chart
    new Chart(document.getElementById('userChart'), {
        type: 'line',
        data: {
            labels: [<% 
                for(int i=0;i<userMonths.size();i++){
                    out.print("\"" + userMonths.get(i) + "\"");
                    if(i != userMonths.size()-1) out.print(",");
                } 
            %>],
            datasets: [{
                label: 'Users',
                data: <%= userCounts.toString() %>,
                borderColor: 'rgba(75, 192, 192, 1)',
                backgroundColor: 'rgba(75, 192, 192, 0.2)',
                fill: true,
                tension: 0.3
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: true } },
            scales: {
                x: { title: { display: true, text: 'Month (YYYY-MM)' } },
                y: { title: { display: true, text: 'Number of Users' }, beginAtZero: true }
            }
        }
    });

    // Fine Chart
    new Chart(document.getElementById('fineChart'), {
        type: 'pie',
        data: {
            labels: [<% 
                for(int i=0;i<fineMonths.size();i++){
                    out.print("\"" + fineMonths.get(i) + "\"");
                    if(i != fineMonths.size()-1) out.print(",");
                } 
            %>],
            datasets: [{
                data: <%= fineAmounts.toString() %>,
                backgroundColor: ['#ff6384','#36a2eb','#ffcd56','#4bc0c0','#9966ff']
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { position: 'bottom' } }
        }
    });

    // Category Chart
    new Chart(document.getElementById('categoryChart'), {
        type: 'doughnut',
        data: {
            labels: [<% 
                for(int i=0;i<categoryLabels.size();i++){
                    out.print("\"" + categoryLabels.get(i) + "\"");
                    if(i != categoryLabels.size()-1) out.print(",");
                } 
            %>],
            datasets: [{
                data: <%= categoryCounts.toString() %>,
                backgroundColor: [
                    '#36a2eb', '#ff6384', '#ffcd56', '#4bc0c0', '#9966ff', '#ff9f40'
                ]
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { position: 'bottom' },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            return context.label + ": " + context.raw + " borrows";
                        }
                    }
                }
            }
        }
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
