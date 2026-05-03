<%@ page import="java.sql.*,java.util.*,java.time.*,java.time.temporal.ChronoUnit,com.utils.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("userLogin.jsp");
        return;
    }

    List<Map<String, String>> borrowList = new ArrayList<>();
    try (Connection conn = DBConnection.getConnection()) {
        String sql = "SELECT br.id, b.title, b.author, br.status, br.request_date, br.issue_date, br.expiry_date, br.fine_amount " +
                     "FROM borrow_requests br " +
                     "JOIN books b ON br.book_id = b.id " +
                     "WHERE br.user_id = ? ORDER BY br.request_date DESC";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, String> borrow = new HashMap<>();
            borrow.put("id", String.valueOf(rs.getInt("id")));
            borrow.put("title", rs.getString("title"));
            borrow.put("author", rs.getString("author"));
            borrow.put("status", rs.getString("status"));
            borrow.put("requestDate", rs.getString("request_date"));
            borrow.put("issueDate", rs.getString("issue_date") != null ? rs.getString("issue_date") : "N/A");
            borrow.put("expiryDate", rs.getString("expiry_date") != null ? rs.getString("expiry_date") : "N/A");
            borrow.put("fineAmount", rs.getString("fine_amount") != null ? rs.getString("fine_amount") : "0");
            borrowList.add(borrow);
        }
    } catch (Exception e) { e.printStackTrace(); }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>My Borrow Requests</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <style>
        body {
            background-color: #f9f8ff;
            font-family: 'Segoe UI', sans-serif;
        }

        /* Navbar */
        .navbar {
            background-color: #E6E6FA;
            border-bottom: 3px solid #AD49E1;
            box-shadow: 0 4px 15px rgba(173, 73, 225, 0.15);
        }
        .navbar-brand, .nav-link {
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

        /* Heading */
        h2 {
            color: #7A1CAC;
            font-weight: 700;
            margin: 40px 0 20px;
            text-align: center;
        }

        /* Table Container */
        .table-container {
            background: white;
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.08);
            margin-bottom: 40px;
        }

        /* Table */
        .table {
            border-collapse: separate;
            border-spacing: 0;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            border: 1px solid #AD49E1;
        }
        .table thead {
            background: linear-gradient(90deg, #AD49E1, #7A1CAC);
            color: white;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .table th, .table td {
            text-align: center;
            vertical-align: middle;
            padding: 12px 15px;
            border-bottom: 1px solid #AD49E1;
        }
        .table tbody tr:nth-child(even) { background-color: #f7f5ff; }
        .table tbody tr:hover { background-color: #eae3ff; }

        /* Status badges */
        .status {
            display: inline-block;
            padding: 6px 12px;
            font-size: 0.85rem;
            font-weight: 500;
            border-radius: 6px;
            min-width: 80px;
        }
        .status-pending { background-color: #FFD700; color: #000; }  /* Yellow */
        .status-approved { background-color: #28a745; color: #fff; } /* Green */
        .status-rejected { background-color: #dc3545; color: #fff; } /* Red */
        .status-returned { background-color: #007bff; color: #fff; } /* Blue */

        /* Return Button */
        .btn-return {
            background-color: #FFD700; /* Gold / yellow */
            color: #000;
            border: none;
            border-radius: 50px;
            padding: 5px 18px;
            font-size: 0.85rem;
            transition: all 0.3s ease;
        }
        .btn-return:hover { background-color: #FFC107; color: #000; }

        @media (max-width: 768px) {
            .table th, .table td { padding: 8px 10px; font-size: 0.85rem; }
            h2 { font-size: 1.5rem; }
            .btn-return { padding: 4px 12px; font-size: 0.8rem; }
        }
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

<div class="container">
    <h2>My Borrow Requests</h2>
    <div class="table-container table-responsive">
        <table class="table align-middle text-center mb-0">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Book Title</th>
                    <th>Author</th>
                    <th>Status</th>
                    <th>Request Date</th>
                    <th>Issue Date</th>
                    <th>Expiry Date</th>
                    <th>Fine Amount</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
            <% if (borrowList.isEmpty()) { %>
                <tr><td colspan="9" class="text-muted">No borrow requests found.</td></tr>
            <% } else {
                for (Map<String,String> br : borrowList) { 
                    String status = br.get("status");
                    String fineDisplay = br.get("fineAmount");
                    try {
                        if ("approved".equalsIgnoreCase(status)) {
                            String expiryStr = br.get("expiryDate");
                            if (!"N/A".equals(expiryStr)) {
                                LocalDate expiry = LocalDate.parse(expiryStr);
                                LocalDate today = LocalDate.now();
                                long daysLate = ChronoUnit.DAYS.between(expiry, today);
                                if (daysLate > 0) fineDisplay = String.valueOf(daysLate * 10);
                            }
                        }
                    } catch (Exception e) { fineDisplay = "0"; }
            %>
                <tr>
                    <td><%= br.get("id") %></td>
                    <td><%= br.get("title") %></td>
                    <td><%= br.get("author") %></td>
                    <td>
                        <span class="status <%= 
                            "approved".equalsIgnoreCase(status) ? "status-approved" : 
                            ("pending".equalsIgnoreCase(status) ? "status-pending" : 
                            ("returned".equalsIgnoreCase(status) ? "status-returned" : "status-rejected")) %>">
                            <%= status %>
                        </span>
                    </td>
                    <td><%= br.get("requestDate") %></td>
                    <td><%= br.get("issueDate") %></td>
                    <td><%= br.get("expiryDate") %></td>
                    <%
                        String fineColor = "";
                        try { long fineVal = Long.parseLong(fineDisplay); if(fineVal > 0) fineColor="color:#FF3B3B;font-weight:600;"; } catch(Exception e){ fineColor=""; }
                    %>
                    <td style="<%= fineColor %>">₹<%= fineDisplay %></td>
                    <td>
                        <% if ("approved".equalsIgnoreCase(status)) { %>
                            <form action="<%=request.getContextPath()%>/UserReturnServlet" method="post" onsubmit="return confirm('Return this book?');">
                                <input type="hidden" name="borrowRequestId" value="<%= br.get("id") %>" />
                                <button type="submit" class="btn-return btn-sm">Return</button>
                            </form>
                        <% } else { %>-<% } %>
                    </td>
                </tr>
            <% } } %>
            </tbody>
        </table>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
