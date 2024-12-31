<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Invalidate session on logout
  
    if (session != null) {
        session.invalidate();
    }
    // Redirect to admin login page
    response.sendRedirect(request.getContextPath() + "/jsp/admin_control/adminlogin.jsp");
%>
