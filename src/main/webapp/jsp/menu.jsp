<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ND Bangali Food - Menu</title>
    <!-- Linking CSS files -->
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/footer.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/menu.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        @media screen and (max-width: 768px) {
            .iframe-container {
                align-items: center;
                margin-top: 0px;
            }

            #category-frame,
            #items-frame {
                width: 100%; /* Full width on smaller screens */
                height: 500px; /* Adjust height */
                margin-bottom: 20px; /* Space between the iframes */
            }

            .image {
                display: none; /* Hide image on smaller screens */
            }

            #category-frame,
            #items-frame {
                width: 120%; /* Full width for mobile view */
                height: 450px; /* Adjusted height */
                margin-bottom: 15px; /* Space between iframes */
            }

            .back-to-category-btn {
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px; /* Space between icon and text */
                background-color: #1f2937; /* Dark navy background */
                color: #fff; /* White text */
                border: none; /* Remove border */
                border-radius: 50px; /* Rounded edges */
                padding: 10px 20px; /* Padding for the button */
                font-size: 16px; /* Font size for text */
                font-weight: bold; /* Bold text */
                cursor: pointer; /* Pointer cursor on hover */
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2); /* Add shadow for depth */
                position: fixed; /* Fix position on the screen */
                bottom: 20px; /* Position above the bottom edge */
                right: 20px; /* Position away from the right edge */
                z-index: 1000; /* Ensure visibility above other elements */
                transition: all 0.3s ease; /* Smooth transition for appearance changes */
            }

            .back-to-category-btn:hover {
                background-color: #111827; /* Darker navy on hover */
                transform: translateY(-3px); /* Slight lift on hover */
            }

            .back-to-category-btn.icon-only {
                gap: 0; /* Remove space between icon and text */
                padding: 10px; /* Reduce padding for a smaller button */
                width: 50px; /* Set fixed width for the circular button */
                height: 50px; /* Set fixed height for the circular button */
                border-radius: 50%; /* Fully circular button */
                font-size: 0; /* Hide text by making font-size 0 */
                justify-content: center; /* Center the icon */
            }

            .back-to-category-btn.icon-only i {
                font-size: 24px; /* Increase icon size for better visibility */
            }
        }
    </style>
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
    <iframe id="items-frame" name="items-frame" style="display: none;"></iframe>
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
            backToCategoryBtn.style.display = 'flex'; // Show back button
        }

        // Store the selected category in sessionStorage to persist on page reload
        sessionStorage.setItem('selectedCategory', categoryUrl);
    }

    // Function to go back to the category list in mobile view
    function goBackToCategory() {
        const categoryFrame = document.getElementById('category-frame');
        const itemsFrame = document.getElementById('items-frame');
        const backToCategoryBtn = document.getElementById('back-to-category-btn');

        categoryFrame.style.display = 'block'; // Show the category frame
        itemsFrame.style.display = 'none'; // Hide the items frame
        backToCategoryBtn.style.display = 'none'; // Hide the back button

        // Remove the selected category from sessionStorage
        sessionStorage.removeItem('selectedCategory');
    }

    // Add event listener to initialize the iframe and button states
    document.addEventListener('DOMContentLoaded', function () {
        const categoryFrame = document.getElementById('category-frame');
        const itemsFrame = document.getElementById('items-frame');
        const backToCategoryBtn = document.getElementById('back-to-category-btn');

        // Check if a category was previously selected
        const selectedCategory = sessionStorage.getItem('selectedCategory');
        if (selectedCategory) {
            itemsFrame.src = selectedCategory; // Load last selected category items
            itemsFrame.style.display = 'block';

            if (window.innerWidth <= 768) {
                categoryFrame.style.display = 'none';
                backToCategoryBtn.style.display = 'flex'; // Show back button
            }
        }

        // Attach event listeners to category links dynamically
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

    // Ensure that both iframes are displayed when the screen is resized to desktop
    window.addEventListener('resize', function () {
        const categoryFrame = document.getElementById('category-frame');
        const itemsFrame = document.getElementById('items-frame');
        const backToCategoryBtn = document.getElementById('back-to-category-btn');

        if (window.innerWidth > 768) {
            categoryFrame.style.display = 'block'; // Show both frames in desktop view
            itemsFrame.style.display = 'block';
            backToCategoryBtn.style.display = 'none'; // Hide the back button
        } else {
            // Maintain state based on visibility in mobile view
            if (itemsFrame.style.display === 'block') {
                backToCategoryBtn.style.display = 'flex';
            } else {
                backToCategoryBtn.style.display = 'none';
            }
        }
    });

    window.addEventListener('scroll', function () {
        const backButton = document.getElementById('back-to-category-btn');

        if (window.scrollY > 100) {
            backButton.classList.add('icon-only'); // Add circular style
        } else {
            backButton.classList.remove('icon-only'); // Restore default style
        }
    });
</script>

</body>

</html>
