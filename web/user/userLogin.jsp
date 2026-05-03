<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>User Login - Library System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" rel="stylesheet" />

    <style>
        body {
            background-color: #ffffff; /* White background */
            font-family: 'Poppins', sans-serif;
        }

        /* Navbar styling */
        .navbar {
            background-color: #E6E6FA; /* Light violet */
            border-bottom: 3px solid #AD49E1;
            box-shadow: 0 4px 12px rgba(173, 73, 225, 0.2);
        }
        .navbar-brand, .nav-link {
            color: #4B0082 !important; /* Dark violet */
            font-weight: 600;
        }
        .nav-link:hover {
            color: #AD49E1 !important;
        }

        /* Login card */
        .login-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            padding: 30px;
            width: 350px;
            margin: 100px auto;
            opacity: 0; /* Start hidden */
            transform: translateY(50px); /* Slide from below */
            animation: slideFadeIn 0.8s ease forwards;
        }

        /* Button styles */
        .btn-primary {
            background-color: #4B0082; /* Dark violet */
            border: none;
            transition: background-color 0.3s ease, transform 0.3s ease;
        }
        .btn-primary:hover {
            background-color: #8B5FBF; /* Medium violet */
            transform: scale(1.05);
        }

        /* Animation keyframes */
        @keyframes slideFadeIn {
            0% {
                opacity: 0;
                transform: translateY(50px);
            }
            100% {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>

   <!-- Navbar -->
  <nav class="navbar navbar-expand-lg fixed-top">
    <div class="container">
      <a class="navbar-brand fw-bold" href="#">📚 MyLibrary</a>
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav ms-auto">
          <li class="nav-item"><a class="nav-link active" href="../index.html"><i class="fa-solid fa-house"></i>Home</a></li>
          <li class="nav-item"><a class="nav-link" href="../admin/adminLogin.jsp"><i class="fa-solid fa-user-shield"></i>Admin Login</a></li>
          <li class="nav-item"><a class="nav-link" href="userLogin.jsp"><i class="fa-solid fa-user"></i>User Login</a></li>
        </ul>
      </div>
    </div>
  </nav>

      <%-- Show messages --%>
        <%
            String success = (String) session.getAttribute("successMessage");
            String error = (String) session.getAttribute("errorMessage");
            session.removeAttribute("successMessage");
            session.removeAttribute("errorMessage");
        %>
        <% if(success != null) { %>
            <div class="alert alert-success animate__animated animate__fadeInDown"><%= success %></div>
        <% } %>
        <% if(error != null) { %>
            <div class="alert alert-danger animate__animated animate__fadeInDown"><%= error %></div>
        <% } %>
    <!-- Login Card -->
    <div class="login-card">
        <h3 class="text-center mb-4" style="color:#4B0082;">
            <i class="fas fa-user"></i> User Login
        </h3>

     

        <form action="<%=request.getContextPath()%>/UserLoginServlet" method="post" novalidate>
            <div class="mb-3">
                <label for="email" class="form-label">Email address</label>
                <input type="email" name="email" id="email" class="form-control" placeholder="Enter email" required autofocus />
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="password" name="password" id="password" class="form-control" placeholder="Enter password" required />
            </div>

            <button type="submit" class="btn btn-primary w-100">Login</button>
        </form>

        <p class="mt-3 text-center">
            Don't have an account? <a href="<%=request.getContextPath()%>/user/register.jsp">Register here</a>
        </p>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
