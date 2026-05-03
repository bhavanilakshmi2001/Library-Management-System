<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.utils.DBConnection" %>
<%
    String userName = (String) session.getAttribute("userName");
    Integer userId = (Integer) session.getAttribute("userId");

    if(userId == null){
        response.sendRedirect("userLogin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        .dashboard-card {
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            transition: transform 0.3s ease-in-out;
        }
        .dashboard-card:hover {
            transform: translateY(-5px);
        }
        .dashboard-card i {
            font-size: 2.5rem;
            margin-bottom: 10px;
            color: #7A1CAC;
        }
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
    
    <!-- Dashboard Cards -->
    <div class="container my-5">
        <h2 class="text-center mb-5 fw-bold" style="color:#7A1CAC;">Welcome, <%= userName %> 👋</h2>
        <div class="row g-4 justify-content-center">

            <!-- Available Books -->
            <div class="col-md-3">
                <div class="card dashboard-card text-center">
                    <i class="fas fa-book-open"></i>
                    <h5 class="card-title">Available Books</h5>
                    <p class="fw-bold fs-4 ">
                        <%
                            try(Connection con = DBConnection.getConnection();
                                PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM books WHERE copies > 0");
                                ResultSet rs = ps.executeQuery()){
                                if(rs.next()){ out.print(rs.getInt(1)); }
                            } catch(Exception e){ out.print("0"); }
                        %>
                    </p>
                </div>
            </div>

            <!-- My Borrowed Books -->
            <div class="col-md-3">
                <div class="card dashboard-card text-center">
                    <i class="fas fa-book-reader"></i>
                    <h5 class="card-title">My Borrowed</h5>
                    <p class="fw-bold fs-4 ">
                        <%
                            try(Connection con = DBConnection.getConnection();
                                PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM borrow_requests WHERE user_id=? AND status='approved'")){
                                ps.setInt(1, userId);
                                try(ResultSet rs = ps.executeQuery()){
                                    if(rs.next()){ out.print(rs.getInt(1)); }
                                }
                            } catch(Exception e){ out.print("0"); }
                        %>
                    </p>
                </div>
            </div>

            <!-- Pending Requests -->
            <div class="col-md-3">
                <div class="card dashboard-card text-center">
                    <i class="fas fa-hourglass-half"></i>
                    <h5 class="card-title">Pending Requests</h5>
                    <p class="fw-bold fs-4 ">
                        <%
                            try(Connection con = DBConnection.getConnection();
                                PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM borrow_requests WHERE user_id=? AND status='pending'")){
                                ps.setInt(1, userId);
                                try(ResultSet rs = ps.executeQuery()){
                                    if(rs.next()){ out.print(rs.getInt(1)); }
                                }
                            } catch(Exception e){ out.print("0"); }
                        %>
                    </p>
                </div>
            </div>

            <!-- Return History -->
            <div class="col-md-3">
                <div class="card dashboard-card text-center">
                    <i class="fas fa-history"></i>
                    <h5 class="card-title">Return History</h5>
                    <p class="fw-bold fs-4">
                        <%
                            try(Connection con = DBConnection.getConnection();
                                PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM borrow_requests WHERE user_id=? AND status='returned'")){
                                ps.setInt(1, userId);
                                try(ResultSet rs = ps.executeQuery()){
                                    if(rs.next()){ out.print(rs.getInt(1)); }
                                }
                            } catch(Exception e){ out.print("0"); }
                        %>
                    </p>
                </div>
            </div>

        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
