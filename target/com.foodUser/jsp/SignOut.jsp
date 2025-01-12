<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Out</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
     <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/SignOut.css">
   

    <%@ include file="/jsp/Navigation.jsp" %>
</head>
<body>
    <div class="sign-out-container">
        <h1>Sign Out Successful</h1>
        <p>You have been signed out of your account. Thank you for visiting!</p>
        <a href="<%= request.getContextPath() %>/index.jsp">Return to Home</a>
    </div>
    
     <%@ include file="/jsp/footer.jsp" %>
</body>

</html>