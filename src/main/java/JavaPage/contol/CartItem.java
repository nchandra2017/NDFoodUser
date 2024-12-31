package JavaPage.contol;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class CartItem {
    private String itemName; // Matches "itemName" in JSON
    private double itemPrice; // Matches "itemPrice" in JSON
    private int quantity; // Matches "quantity" in JSON

    public CartItem(String itemName, double itemPrice, int quantity) {
        this.itemName = itemName;
        this.itemPrice = itemPrice;
        this.quantity = quantity;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public double getItemPrice() {
        return itemPrice;
    }

    public void setItemPrice(double itemPrice) {
        this.itemPrice = itemPrice;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    @Override
    public String toString() {
        return "CartItem{" +
                "itemName='" + itemName + '\'' +
                ", itemPrice=" + itemPrice +
                ", quantity=" + quantity +
                '}';
    }

    // Static method to convert List<Map<String, Object>> to List<CartItem>
    public static List<CartItem> fromMapList(List<Map<String, Object>> mapList) {
        List<CartItem> cartItems = new ArrayList<>();
        for (Map<String, Object> map : mapList) {
            String itemName = (String) map.get("itemName");
            double itemPrice = Double.parseDouble(map.get("itemPrice").toString());
            int quantity = Integer.parseInt(map.get("quantity").toString());
            cartItems.add(new CartItem(itemName, itemPrice, quantity));
        }
        return cartItems;
    }
}
