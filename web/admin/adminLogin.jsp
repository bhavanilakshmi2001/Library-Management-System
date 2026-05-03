<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Login - Library System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" rel="stylesheet">

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
        .dropdown-menu {
            background-color: rgba(230, 230, 250, 0.95);
            border: 1px solid #AD49E1;
        }
        .dropdown-item:hover {
            background-color: #AD49E1;
            color: white;
        }

         /* Add space below navbar */
        .login-card { padding-top: 100px; }
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
          <li class="nav-item"><a class="nav-link" href="adminLogin.jsp"><i class="fa-solid fa-user-shield"></i>Admin Login</a></li>
          <li class="nav-item"><a class="nav-link" href="../user/userLogin.jsp"><i class="fa-solid fa-user"></i>User Login</a></li>
        </ul>
      </div>
    </div>
  </nav>


    <!-- Login Card -->
    <div class="login-card">
        <h3 class="text-center mb-4" style="color:#4B0082;">
            <i class="fas fa-user-shield"></i> Admin Login
        </h3>

        <% String errorMsg = (String) request.getAttribute("errorMsg");
           if(errorMsg != null) { %>
            <div class="alert alert-danger text-center animate__animated animate__fadeInDown">
                <%= errorMsg %>
            </div>
        <% } %>

        <form action="../AdminLoginServlet" method="post">
            <div class="mb-3">
                <label for="name" class="form-label">Username</label>
                <input type="text" name="name" class="form-control" placeholder="Enter username" required>
            </div>

            <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="password" name="password" class="form-control" placeholder="Enter password" required>
            </div>

            <button type="submit" class="btn btn-primary w-100">Login</button>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
