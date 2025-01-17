<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ND Bangali Food - Menu</title>
    <!-- Linking CSS files -->
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/navbar.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/footer.css"> 
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/menu.css">
      <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/menuItempage.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">


</head>

<body>

<div id="preloader">
    <div class="loader"></div>
</div>

<%@ include file="/jsp/Navigation.jsp" %>

<!-- Back Button -->
<button id="back-to-category-btn" class="back-to-category-btn" onclick="goBackToCategory()">
    <i class="fas fa-bars"></i> Categories
</button>



<!-- Iframes Container -->
<div class="iframe-container">
    <!-- First iframe: Menu Category List -->
    <iframe id="category-frame" src="<%=request.getContextPath()%>/jsp/menu-category.jsp" name="category-frame"></iframe>

    <!-- Second iframe: Menu Items for the Selected Category (Hidden initially) -->
    <iframe id="items-frame" name="items-frame"></iframe>
</div>

<%@ include file="/jsp/footer.jsp" %>

<script>
    window.addEventListener('load', function () {
        const preloader = document.getElementById('preloader');
        preloader.style.opacity = '0'; // Fade out effect
        setTimeout(() => {
            preloader.style.display = 'none'; // Remove preloader from view
        }, 500); // Matches the fade-out transition
    });

    // Function to show the items iframe and hide the category iframe when a category is clicked
    function showItemsFrame(categoryUrl) {
        const categoryFrame = document.getElementById('category-frame');
        const itemsFrame = document.getElementById('items-frame');
        const backToCategoryBtn = document.getElementById('back-to-category-btn');

        itemsFrame.src = categoryUrl; // Update the iframe with the category URL
        itemsFrame.style.display = 'block'; // Show the items frame

        if (window.innerWidth <= 768) {
            categoryFrame.style.display = 'none'; // Hide category frame for mobile
            backToCategoryBtn.style.display = 'block'; // Show back button
        }

        // Store the selected category in sessionStorage to persist on page reload
        sessionStorage.setItem('selectedCategory', categoryUrl);
    }

    // Add event listener to capture clicks on the category links
    document.addEventListener('DOMContentLoaded', function () {
        const categoryFrame = document.getElementById('category-frame');
        const itemsFrame = document.getElementById('items-frame');
        const backToCategoryBtn = document.getElementById('back-to-category-btn');

        // Check if a category was previously selected
        const selectedCategory = sessionStorage.getItem('selectedCategory');
        if (selectedCategory) {
            itemsFrame.src = selectedCategory; // Load last selected category items
            itemsFrame.style.display = 'block';

            // Adjust frames for mobile view
            if (window.innerWidth <= 768) {
                categoryFrame.style.display = 'none';
                backToCategoryBtn.style.display = 'block';
            }
        }

        categoryFrame.onload = function () {
            const categoryDoc = categoryFrame.contentDocument || categoryFrame.contentWindow.document;
            const categoryLinks = categoryDoc.querySelectorAll('a');

            categoryLinks.forEach(function (link) {
                link.addEventListener('click', function (event) {
                    event.preventDefault();
                    const categoryUrl = link.getAttribute('href');
                    showItemsFrame(categoryUrl);
                });
            });
        };
    });

    // Function to go back to the category list in mobile view
    function goBackToCategory() {
        const categoryFrame = document.getElementById('category-frame');
        const itemsFrame = document.getElementById('items-frame');
        const backToCategoryBtn = document.getElementById('back-to-category-btn');

        categoryFrame.style.display = 'block'; // Show the category frame
        itemsFrame.style.display = 'none'; // Hide the items frame
        backToCategoryBtn.style.display = 'none'; // Hide the back button
    }

    // Ensure that both iframes are displayed when the screen is resized to desktop
    window.addEventListener('resize', function () {
        const categoryFrame = document.getElementById('category-frame');
        const itemsFrame = document.getElementById('items-frame');
        const backToCategoryBtn = document.getElementById('back-to-category-btn');

        if (window.innerWidth > 768) {
            categoryFrame.style.display = 'block'; // Show both frames in desktop view
            itemsFrame.style.display = 'block';
            backToCategoryBtn.style.display = 'none'; // Hide the back button in desktop view
        }
    });
    
 // Add event listener for scroll event
    window.addEventListener('scroll', function () {
        const backButton = document.getElementById('back-to-category-btn');

        // Check the scroll position
        if (window.scrollY > 100) {
            // Add the 'icon-only' class when scrolled down
            backButton.classList.add('icon-only');
        } else {
            // Remove the 'icon-only' class when scrolled back to the top
            backButton.classList.remove('icon-only');
        }
    });

</script>

</body>

</html>