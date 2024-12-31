package javaPage.contol;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the session object
        HttpSession session = request.getSession();
        
        // Get parameters from the request
        String itemName = request.getParameter("itemName");
        double itemPrice = Double.parseDouble(request.getParameter("itemPrice"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        
        // Retrieve or create the cart (as a List<CartItem>)
        @SuppressWarnings("unchecked")
        List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cartItems");
        if (cartItems == null) {
            cartItems = new ArrayList<>();
        }

        // Check if the item already exists in the cart
        boolean itemExists = false;
        for (CartItem item : cartItems) {
            if (item.getItemName().equals(itemName)) {
                // Update the quantity if the item already exists
                item.setQuantity(item.getQuantity() + quantity);
                itemExists = true;
                break;
            }
        }

        // If the item is new, add it to the cart
        if (!itemExists) {
            CartItem newItem = new CartItem(itemName, itemPrice, quantity);
            cartItems.add(newItem);
        }

        // Save the cart back to the session
        session.setAttribute("cartItems", cartItems);

        // Optionally, return a response (e.g., JSON response)
        response.setContentType("application/json");
        response.getWriter().write("{\"status\":\"Item added to cart\"}");
    }

    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String itemName = request.getParameter("itemName");

        @SuppressWarnings("unchecked")
        List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cartItems");
        if (cartItems != null) {
            cartItems.removeIf(item -> item.getItemName().equals(itemName));
            session.setAttribute("cartItems", cartItems);
        }

        response.setContentType("application/json");
        response.getWriter().write("{\"status\":\"Item removed from cart\"}");
    }
}
