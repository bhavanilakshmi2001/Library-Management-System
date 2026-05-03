<%@ page session="true" %>
<%
    session.invalidate(); // Ends the session
    response.sendRedirect("index.html"); // Redirect to admin login (change if needed)
%>
