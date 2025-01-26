<%@ page language="java" contentType="text/html; charset=UTF-8" 
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ND Bangali Food - Home</title>

    <!-- Include required CSS for Navbar, Footer, Homepage, and Modal -->
   
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/footer.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/homestyle.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/modalPopup.css">
     <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/home_Pic.css">

    <!-- Ensure jQuery is loaded -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    
    <style>
  
    
    </style>
</head>

<body>

    <!-- Popup Modal -->
    <div id="popupMessage" class="popupmassege">
        <div class="popupmassege-content">
            <div class="welcome-section">
                <div class="image-container">
                    <img src="<%=request.getContextPath()%>/images/Nikhil Pic.PNG" alt="Profile Picture">
                </div>
                <div class="welcome-poptext">
                    <h5>Temporary Notices!</h5>
                    <p> Stay tuned for updates!<p>
                </div>
            </div>
          
            <button id="closePopup" class= closePopupB>Close</button>
        </div>
    </div>

   
    <!-- Include the Navbar -->
    <%@ include file="/jsp/Navigation.jsp" %>
    
  <div id="header" class="hade_text">
    <div class="header-content">
        <h1>Welcome to ND Bengali Food</h1>
        <p>Your one-stop destination for authentic Bengali Cuisine.</p>
    </div>
    <img src="<%=request.getContextPath()%>/images/home pic.png" alt="ND Bangali Food Logo" class="header-img">
</div>




    <!-- Deals Section -->
    <section class="deals-section">
        <h2 class="section-title">Deals</h2>
        <p class="section-description">Sweet savings on signature dishes.</p>

        <!-- Deals Slider -->
        <div class="deals-slider" id="deals-slider">
            <!-- Example Deal Items -->
            <a href="menu.jsp?deal=1" class="deal-item">
                <img src="<%=request.getContextPath()%>/images/menu-category/RICE SPECIALTY.png" alt="Deal 1">
                <h3>I Love NY Pie</h3>
                <p>Pizza, Italian - 2.90 miles</p>
            </a>
            <a href="menu.jsp?deal=2" class="deal-item">
                <img src="<%=request.getContextPath()%>/images/menu-category/BEVERAGES.png" alt="Deal 2">
                <h3>MedTaste</h3>
                <p>Mediterranean - 3.25 miles</p>
            </a>
            <a href="menu.jsp?deal=3" class="deal-item">
                <img src="<%=request.getContextPath()%>/images/menu-category/CHICKEN ENTREES.png" alt="Deal 3">
                <h3>I Love NY Pie</h3>
                <p>Pizza, Italian - 2.90 miles</p>
            </a>
             <a href="menu.jsp?deal=4" class="deal-item">
                <img src="<%=request.getContextPath()%>/images/menu-category/RICE SPECIALTY.png" alt="Deal 1">
                <h3>I Love NY Pie</h3>
                <p>Pizza, Italian - 2.90 miles</p>
            </a>
             <a href="menu.jsp?deal=5" class="deal-item">
                <img src="<%=request.getContextPath()%>/images/menu-category/BEVERAGES.png" alt="Deal 2">
                <h3>MedTaste</h3>
                <p>Mediterranean - 3.25 miles</p>
            </a>
            <a href="menu.jsp?deal=6" class="deal-item">
                <img src="<%=request.getContextPath()%>/images/menu-category/CHICKEN ENTREES.png" alt="Deal 3">
                <h3>I Love NY Pie</h3>
                <p>Pizza, Italian - 2.90 miles</p>
            </a>
             <a href="menu.jsp?deal=7" class="deal-item">
                <img src="<%=request.getContextPath()%>/images/menu-category/RICE SPECIALTY.png" alt="Deal 1">
                <h3>I Love NY Pie</h3>
                <p>Pizza, Italian - 2.90 miles</p>
            </a>
             <a href="menu.jsp?deal=8" class="deal-item">
                <img src="<%=request.getContextPath()%>/images/menu-category/BEVERAGES.png" alt="Deal 2">
                <h3>MedTaste</h3>
                <p>Mediterranean - 3.25 miles</p>
            </a>
            <a href="menu.jsp?deal=9" class="deal-item">
                <img src="<%=request.getContextPath()%>/images/menu-category/CHICKEN ENTREES.png" alt="Deal 3">
                <h3>I Love NY Pie</h3>
                <p>Pizza, Italian - 2.90 miles</p>
            </a>
             <a href="menu.jsp?deal=10" class="deal-item">
                <img src="<%=request.getContextPath()%>/images/menu-category/BEVERAGES.png" alt="Deal 2">
                <h3>MedTaste</h3>
                <p>Mediterranean - 3.25 miles</p>
            </a>
            <a href="menu.jsp?deal=11" class="deal-item">
                <img src="<%=request.getContextPath()%>/images/menu-category/CHICKEN ENTREES.png" alt="Deal 3">
                <h3>I Love NY Pie</h3>
                <p>Pizza, Italian - 2.90 miles</p>
            </a>
             <a href="menu.jsp?deal=12" class="deal-item">
                <img src="<%=request.getContextPath()%>/images/menu-category/RICE SPECIALTY.png" alt="Deal 1">
                <h3>I Love NY Pie</h3>
                <p>Pizza, Italian - 2.90 miles</p>
            </a>

        </div>
        

        <!-- Load More Deals Button -->
        <button id="load-more-deals" class="load-more-button">Load More Deals</button>
    </section>

   <!-- Menu Section -->
    <section class="menu-section">
        <h2 class="section-title">Menu</h2>
        <p class="section-description">Vibrant spices, colorful creations, sabor that sings.</p>

        <!-- Menu Grid -->
        <div class="menu-grid" id="menu-grid">
            <a href="menu.jsp?menu=1" class="menu-item">
                <img src="<%=request.getContextPath()%>/images/menu-category/SEAFOOD ENTREES.png" alt="Menu 1">
                <h3>Angel's Soul Food & BBQ</h3>
                <p>Barbeque, Creole, Cajun - 13.20 miles</p>
            </a>
             <a href="menu.jsp?menu=6" class="menu-item">
                <img src="<%=request.getContextPath()%>/images/menu-category/TANDOOR ITEMS.png" alt="Menu 3">
                <h3>Angel's Soul Food & BBQ</h3>
                <p>Barbeque, Creole, Cajun - 13.20 miles</p>
            </a>
             <a href="menu.jsp?menu=7" class="menu-item">
                <img src="<%=request.getContextPath()%>/images/menu-category/SEAFOOD ENTREES.png" alt="Menu 1">
                <h3>Angel's Soul Food & BBQ</h3>
                <p>Barbeque, Creole, Cajun - 13.20 miles</p>
            </a>
            <a href="menu.jsp?menu=8" class="menu-item">
                <img src="<%=request.getContextPath()%>/images/menu-category/SIDES.png" alt="Menu 2">
                <h3>Southern Charm Cafe</h3>
                <p>American - 44.38 miles</p>
            </a>
            <a href="menu.jsp?menu=9" class="menu-item">
                <img src="<%=request.getContextPath()%>/images/menu-category/TANDOOR ITEMS.png" alt="Menu 3">
                <h3>Angel's Soul Food & BBQ</h3>
                <p>Barbeque, Creole, Cajun - 13.20 miles</p>
            </a>
             <a href="menu.jsp?menu=10" class="menu-item">
                <img src="<%=request.getContextPath()%>/images/menu-category/SEAFOOD ENTREES.png" alt="Menu 1">
                <h3>Angel's Soul Food & BBQ</h3>
                <p>Barbeque, Creole, Cajun - 13.20 miles</p>
            </a>
             <a href="menu.jsp?menu=2" class="menu-item">
                <img src="<%=request.getContextPath()%>/images/menu-category/SIDES.png" alt="Menu 2">
                <h3>Southern Charm Cafe</h3>
                <p>American - 44.38 miles</p>
            </a>
            <a href="menu.jsp?menu=3" class="menu-item">
                <img src="<%=request.getContextPath()%>/images/menu-category/TANDOOR ITEMS.png" alt="Menu 3">
                <h3>Angel's Soul Food & BBQ</h3>
                <p>Barbeque, Creole, Cajun - 13.20 miles</p>
            </a>
             <a href="menu.jsp?menu=4" class="menu-item">
                <img src="<%=request.getContextPath()%>/images/menu-category/SEAFOOD ENTREES.png" alt="Menu 1">
                <h3>Angel's Soul Food & BBQ</h3>
                <p>Barbeque, Creole, Cajun - 13.20 miles</p>
            </a>
            <a href="menu.jsp?menu=5" class="menu-item">
                <img src="<%=request.getContextPath()%>/images/menu-category/SIDES.png" alt="Menu 2">
                <h3>Southern Charm Cafe</h3>
                <p>American - 44.38 miles</p>
            </a>
             <a href="menu.jsp?deal=1" class="deal-item">
                <img src="<%=request.getContextPath()%>/images/menu-category/RICE SPECIALTY.png" alt="Deal 1">
                <h3>I Love NY Pie</h3>
                <p>Pizza, Italian - 2.90 miles</p>
            </a>
            <a href="menu.jsp?deal=2" class="deal-item">
                <img src="<%=request.getContextPath()%>/images/menu-category/BEVERAGES.png" alt="Deal 2">
                <h3>MedTaste</h3>
                <p>Mediterranean - 3.25 miles</p>
            </a>
            <a href="menu.jsp?deal=3" class="deal-item">
                <img src="<%=request.getContextPath()%>/images/menu-category/CHICKEN ENTREES.png" alt="Deal 3">
                <h3>I Love NY Pie</h3>
                <p>Pizza, Italian - 2.90 miles</p>
            </a>
             <a href="menu.jsp?deal=4" class="deal-item">
                <img src="<%=request.getContextPath()%>/images/menu-category/RICE SPECIALTY.png" alt="Deal 1">
                <h3>I Love NY Pie</h3>
                <p>Pizza, Italian - 2.90 miles</p>
            </a>
             <a href="menu.jsp?deal=5" class="deal-item">
                <img src="<%=request.getContextPath()%>/images/menu-category/BEVERAGES.png" alt="Deal 2">
                <h3>MedTaste</h3>
                <p>Mediterranean - 3.25 miles</p>
            </a>
            <a href="menu.jsp?deal=6" class="deal-item">
                <img src="<%=request.getContextPath()%>/images/menu-category/CHICKEN ENTREES.png" alt="Deal 3">
                <h3>I Love NY Pie</h3>
                <p>Pizza, Italian - 2.90 miles</p>
            </a>
            
            <a href="menu.jsp?menu=11" class="menu-item">
                <img src="<%=request.getContextPath()%>/images/menu-category/SIDES.png" alt="Menu 2">
                <h3>Southern Charm Cafe</h3>
                <p>American - 44.38 miles</p>
            </a>
            <a href="menu.jsp?menu=12" class="menu-item">
                <img src="<%=request.getContextPath()%>/images/menu-category/TANDOOR ITEMS.png" alt="Menu 3">
                <h3>Angel's Soul Food & BBQ</h3>
                <p>Barbeque, Creole, Cajun - 13.20 miles</p>
            </a>
            
             <a href="menu.jsp?menu=1" class="menu-item">
                <img src="<%=request.getContextPath()%>/images/menu-category/SEAFOOD ENTREES.png" alt="Menu 1">
                <h3>Angel's Soul Food & BBQ</h3>
                <p>Barbeque, Creole, Cajun - 13.20 miles</p>
            </a>
             <a href="menu.jsp?menu=1" class="menu-item">
                <img src="<%=request.getContextPath()%>/images/menu-category/SEAFOOD ENTREES.png" alt="Menu 1">
                <h3>Angel's Soul Food & BBQ</h3>
                <p>Barbeque, Creole, Cajun - 13.20 miles</p>
            </a>
           
        </div>

        <!-- Load More Menu Button -->
        <button id="load-more-menu" class="load-more-button">Load More Menu</button>
    </section>

    <!-- Include the Footer -->
    <%@ include file="/jsp/footer.jsp" %>

    <!-- jQuery for Load More functionality and Popup Modal -->
    <script>
    $(document).ready(function() {
        // Show Popup Modal on page load
        $('#popupMessage').fadeIn();
        $('body').addClass('modal-open'); // Disable scrolling

        // Close Popup Modal when "Close" button is clicked
        $('#closePopup').click(function() {
            $('#popupMessage').fadeOut();
            $('body').removeClass('modal-open'); // Re-enable scrolling
        });

        // Prevent interaction with the rest of the page
        $('#popupMessage').click(function(event) {
            if ($(event.target).is('#popupMessage')) {
                event.stopPropagation(); // Prevent modal from closing on outside click
            }
        });

       

        // Deals Load More functionality
        let dealsPerPage = 6; // Show 6 deals initially
        let currentDealsPage = 1;
        const totalDeals = $('#deals-slider .deal-item').length;

        $('#deals-slider .deal-item').slice(dealsPerPage).hide();

        $('#load-more-deals').click(function() {
            let itemsToShow = ++currentDealsPage * dealsPerPage;
            $('#deals-slider .deal-item').slice(0, itemsToShow).slideDown();

            if (itemsToShow >= totalDeals) {
                $('#load-more-deals').hide();
            }
        });

        // Menu Load More functionality
        let itemsPerPage = 12; // Show 12 menu items initially
        let currentPage = 1;
        const totalItems = $('#menu-grid .menu-item').length;

        $('#menu-grid .menu-item').slice(itemsPerPage).hide();

        $('#load-more-menu').click(function() {
            let itemsToShow = ++currentPage * itemsPerPage;
            $('#menu-grid .menu-item').slice(0, itemsToShow).slideDown();

            if (itemsToShow >= totalItems) {
                $('#load-more-menu').hide();
            }
        });
    });

    </script>

</body>
</html>
