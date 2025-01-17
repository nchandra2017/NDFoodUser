<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, dataBasedConnection.DataBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Menu Category List</title>
    
     <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/menu-category.css">
     <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/menuItempage.css">
</head>
<body>
    <div class="menu-category-container">
        <!-- "SELECT CATEGORY" text -->
        <div class="select-category-heading">SELECT CATEGORY</div>

        <ul class="menu-category-list">
            <% 
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                try {
                    conn = DataBConnection.getConnection();
                    String query = "SELECT category_name, category_image FROM categories"; 
                    pstmt = conn.prepareStatement(query);
                    rs = pstmt.executeQuery();

                    while (rs.next()) {
                        String categoryName = rs.getString("category_name");
                        String categoryImage = rs.getString("category_image"); // Fetching image path
            %>
            <li>
                <!-- The link should point to menu-items.jsp and pass the category as a parameter -->
                <a href="<%=request.getContextPath()%>/jsp/menu-items.jsp?category=<%= categoryName %>" target="items-frame" class="menu-category-link">
                    <img src="<%=request.getContextPath() + categoryImage %>" alt="<%= categoryName %>" class="menu-category-image">
                    <span class="menu-category-name"><%= categoryName %></span>
                </a>
            </li>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                }
            %>
        </ul>
    </div>
</body>
</html>
