<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, dataBasedConnection.DataBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Menu Category List</title>
    
   
     <style>
     
     /* Container for menu categories */
.menu-category-container {
    margin-top: 25px;
    display: flex;
    flex-direction: column;
    align-items: center;
}

/* Styling for the heading */
.select-category-heading {
    font-size: 20px;
    font-weight: bold;
    text-align: center;
    margin-bottom: 20px;
    color: #0a3871;
}

/* Styling for the list */
.menu-category-list {
    list-style-type: none;
    margin: 0;
    padding: 0;
    width: 100%;
    max-width: 600px;
}

/* Each category item */
.menu-category-list li {
    margin-bottom: 20px;
    display: flex;
    align-items: center;
    flex-direction: column; /* For mobile responsiveness */
    background-color: #f9f9f9;
    border: 1px solid #ccc;
    border-radius: 10px;
    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
    overflow: hidden;
    transition: transform 0.3s, box-shadow 0.3s;
    text-align: center;
}

.menu-category-list li:hover {
    transform: translateY(-5px);
    background-color: #fdfdfd;
    box-shadow: 0 8px 15px rgba(0, 0, 0, 0.2);
    border-color: #d32f2f; /* Highlight border on hover */
}

/* Link for the category */
.menu-category-link {
    display: flex;
    flex-direction: column; /* Stack image and text */
    align-items: center;
    text-decoration: none;
    color: #333;
    font-weight: bold;
}

/* Image styling */
.menu-category-image {
    width: 100%; /* Full width */
    height: auto; /* Maintain aspect ratio */
   
    object-fit: cover; /* Prevent image distortion */
    border-bottom: 1px solid #ccc; /* Optional */
}

/* Category name styling */
.menu-category-name {
    padding: 10px;
    font-size: 18px;
    color: #333;
}

/* Responsive Design: Mobile View */
@media screen and (max-width: 768px) {
    .menu-category-container {
        margin-top: 50px;
        margin-left:-30px
    }

    .menu-category-list {
        margin-left:20px;
        width: 90%;
    }

    .menu-category-list li {
        margin-bottom: 15px;
    }

    .menu-category-name {
        font-size: 16px;
    }
}
     
     
     </style>
     
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
