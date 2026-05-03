<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>User Registration - Library System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" rel="stylesheet" />

    <style>
        body {
            background-color: #ffffff;
            font-family: 'Poppins', sans-serif;
        }
        .navbar {
            background-color: #E6E6FA;
            border-bottom: 3px solid #AD49E1;
            box-shadow: 0 4px 12px rgba(173, 73, 225, 0.2);
        }
        .navbar-brand, .nav-link {
            color: #4B0082 !important;
            font-weight: 600;
        }
        .nav-link:hover {
            color: #AD49E1 !important;
        }
        .register-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            padding: 30px;
            max-width: 800px;
            margin: 100px auto;
            opacity: 0;
            transform: translateY(50px);
            animation: slideFadeIn 0.8s ease forwards;
        }
        .btn-primary {
            background-color: #4B0082;
            border: none;
            transition: background-color 0.3s ease, transform 0.3s ease;
        }
        .btn-primary:hover {
            background-color: #8B5FBF;
            transform: scale(1.05);
        }
        @keyframes slideFadeIn {
            0% { opacity: 0; transform: translateY(50px); }
            100% { opacity: 1; transform: translateY(0); }
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

<!-- Registration Card -->
<div class="register-card">
    <h3 class="text-center mb-4" style="color:#4B0082;">
        <i class="fas fa-user-plus"></i> User Registration
    </h3>

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

    <form action="<%=request.getContextPath()%>/UserRegisterServlet" method="post" class="needs-validation" novalidate>
    <div class="row">
        <div class="col-md-6 mb-3">
            <label class="form-label">Full Name</label>
            <input type="text" name="name" class="form-control" required />
            <div class="invalid-feedback">Please enter your full name.</div>
        </div>
        <div class="col-md-6 mb-3">
            <label class="form-label">Email address</label>
            <input type="email" name="email" class="form-control" required />
            <div class="invalid-feedback">Please enter a valid email address.</div>
        </div>

        <div class="col-md-6 mb-3">
            <label class="form-label">Password</label>
            <input type="password" name="password" class="form-control" required minlength="6" />
            <div class="invalid-feedback">Password must be at least 6 characters long.</div>
        </div>
        <div class="col-md-6 mb-3">
            <label class="form-label">Phone Number</label>
            <input type="tel" name="phone" class="form-control" pattern="[0-9]{10}" />
            <div class="invalid-feedback">Please enter a valid 10-digit phone number.</div>
        </div>

        <div class="col-md-6 mb-3">
            <label class="form-label">Address</label>
            <textarea name="address" class="form-control" rows="2" required></textarea>
            <div class="invalid-feedback">Please enter your address.</div>
        </div>
        <div class="col-md-6 mb-3">
            <label class="form-label">Gender</label><br/>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="gender" value="Male" required>
                <label class="form-check-label">Male</label>
            </div>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="gender" value="Female" required>
                <label class="form-check-label">Female</label>
            </div>
        </div>

        <div class="col-md-6 mb-3">
            <label class="form-label">Date of Birth</label>
            <input type="date" name="dob" class="form-control" required />
            <div class="invalid-feedback">Please select your date of birth.</div>
        </div>
    </div>

    <button type="submit" class="btn btn-primary w-100 mt-2">Register</button>
</form>

<script>
// Bootstrap 5 validation script
(() => {
    'use strict';
    const forms = document.querySelectorAll('.needs-validation');
    Array.from(forms).forEach(form => {
        form.addEventListener('submit', event => {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
        }, false);
    });
})();
</script>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
