<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, dataBasedConnection.DataBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Menu Category List</title>
    <style>
        .menu-category-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            
        }

        .menu-category-list {
            list-style-type: none;
            margin: 0;
            padding: 0;
            width: 100%;
            max-width: 600px;
        }

        .menu-category-list li {
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            background-color: #f4f4f4;
            border: 1px solid #ccc;
            border-radius: 10px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .menu-category-list li:hover {
            transform: translateY(-5px);
            background-color: #f4f4f4;
            box-shadow: 0 8px 15px rgba(0, 0, 0, 0.2);
            border: 1px solid red;
        }

        .menu-category-link {
            display: flex;
            align-items: center;
            text-decoration: none;
            color: black;
            font-weight: bold;       
            
        }

        .menu-category-image {
            width: 80px;
            height: 60px;
            object-fit: cover;
            margin-right: 20px;
            border-right: 1px solid #ccc;
        }

        .menu-category-name {
            flex: 1;
            padding: 10px;
            font-size: 14px;
            
        }

        .select-category-heading {
            font-size: 24px;
            font-weight: bold;
            text-align: center;
            margin-bottom: 20px;
            color: red;
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
