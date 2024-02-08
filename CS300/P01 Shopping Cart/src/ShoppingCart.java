//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title: Shopping Cart
// Course: CS 300 Spring 2022
//
// Author: Ava Pezza
// Email: apezza@wisc.edu
// Lecturer: Hobbes LeGault
//
///////////////////////// ALWAYS CREDIT OUTSIDE HELP //////////////////////////
//
// Persons: none
// Online Sources: none
//
///////////////////////////////////////////////////////////////////////////////
public class ShoppingCart {

  private static final double TAX_RATE = 0.05; // sales tax

  // MarketItems: a perfect-size two-dimensional array that stores the list of
  // available items in a given market
  // MarketItems[i][0] refers to a String representation of the item identifiers
  // MarketItems[i][1] refers the item name. Item names are also unique
  // MarketItems[i][2] a String representation of the unit price
  // of the item in dollars
  private static String[][] marketItems =
      new String[][] {{"4390", "Apple", "$1.59"}, {"4046", "Avocado", "$0.59"},
          {"4011", "Banana", "$0.49"}, {"4500", "Beef", "$3.79"}, {"4033", "Blueberry", "$6.89"},
          {"4129", "Broccoli", "$1.79"}, {"4131", "Butter", "$4.59"}, {"4017", "Carrot", "$1.19"},
          {"3240", "Cereal", "$3.69"}, {"3560", "Cheese", "$3.49"}, {"3294", "Chicken", "$5.09"},
          {"4071", "Chocolate", "$3.19"}, {"4363", "Cookie", "$9.5"}, {"4232", "Cucumber", "$0.79"},
          {"3033", "Eggs", "$3.09"}, {"4770", "Grape", "$2.29"}, {"3553", "Ice Cream", "$5.39"},
          {"3117", "Milk", "$2.09"}, {"3437", "Mushroom", "$1.79"}, {"4663", "Onion", "$0.79"},
          {"4030", "Pepper", "$1.99"}, {"3890", "Pizza", "$11.5"}, {"4139", "Potato", "$0.69"},
          {"3044", "Spinach", "$3.09"}, {"4688", "Tomato", "$1.79"}, null, null, null, null};

  /**
   * Returns details of a specific product in the market given its name
   *
   * @param name name of the product to search
   * @return A string representation of the product to search including the identifier of the
   *         product, its name, and its price in dollars if match found.
   */
  public static String lookupProductByName(String name) {
    String item_id = "";
    String item_Name = "";
    String item_price = "";
    boolean itemNameNotFound = false;
    String statement = "";
    for (int i = 0; i < marketItems.length; i++) {
      if (marketItems[i] != null && name.equals(marketItems[i][1])) {
        item_id = marketItems[i][0];
        item_Name = marketItems[i][1];
        item_price = marketItems[i][2];
        statement = item_id + " " + item_Name + " " + item_price;
        itemNameNotFound = true;
      }
    }
    if (itemNameNotFound == false) {
      statement = "No match found";
    }
    return statement;
  }


  /**
   * Returns details of a specific product in the market given its id number
   *
   * @param id id number of the product to search
   * @return A string representation of the product number to search including the identifier of the
   *         product, its name, and its price in dollars if match found.
   */
  public static String lookupProductById(int id) {
    String item_id = "";
    String item_Name = "";
    String item_price = "";
    boolean itemIdNotFound = false;
    String statement = "";
    String idString = Integer.toString(id);
    for (int i = 0; i < marketItems.length; i++) {
      if (marketItems[i] != null && idString.equals(marketItems[i][0])) {
        item_id = marketItems[i][0];
        item_Name = marketItems[i][1];
        item_price = marketItems[i][2];
        statement = item_id + " " + item_Name + " " + item_price;
        itemIdNotFound = true;
      }
    }
    if (itemIdNotFound == false) {
      statement = "No match found";
    }
    return statement;
  }

  /**
   * Returns the price in dollars of a specific product in the market given its name
   *
   * @param name name of the product to search
   * @return A double representation of the price in dollars of a market item given its name. If no
   *         match was found in the market catalog, this method returns -1.0
   */
  public static double getProductPrice(String name) {
    String item_price = "";
    boolean itemNameNotFound = false;
    double statement = 0.0;
    for (int i = 0; i < marketItems.length; i++) {
      if (marketItems[i] != null && name.equals(marketItems[i][1])) {
        item_price = marketItems[i][2].substring(1);
        statement = Double.parseDouble(item_price);
        itemNameNotFound = true;
      }
    }
    if (itemNameNotFound == false) {
      statement = -1.0;
    }
    return statement;
  }

  /**
   * Returns a deep copy of the marketItems array
   *
   * @param none
   * @return An array representation of the marketItems array
   */
  public static String[][] getCopyOfMarketItems() {

    String[][] marketItems2 = new String[marketItems.length][];

    for (int i = 0; i < marketItems2.length; ++i) {
      if (marketItems[i] != null) {
        marketItems2[i] = new String[marketItems[i].length];
        for (int j = 0; j < marketItems2[i].length; ++j) {
          marketItems2[i][j] = marketItems[i][j];
        }
      }
    }

    return marketItems2;
  }

  /**
   * Returns the price in dollars of a specific product in the market given its name
   *
   * @param item the name of the product to be added to the cart
   * @param cart an array of strings which contains the names of items in the cart
   * @param size the number of items in the cart
   * 
   * @return An integer representation of the size of the oversize array cart after trying to add
   *         item to the cart. This method returns the same of size without making any change to the
   *         contents of the array if it is full.
   */
  public static int addItemToCart(String item, String[] cart, int size) {

    boolean fullCart = false;
    if (size == cart.length) {
      fullCart = true;
    }
    if (fullCart == false && size < cart.length) {
      size = size + 1;
      cart[size - 1] = item;
    } else if (size > cart.length) {
      System.out.println("Error Occured: impossible argument");
    }

    return size;
  }

  /**
   * Returns the number of occurrences of a given item within a cart. This method must not make any
   * changes to the contents of the cart.
   *
   * @param item the name of the product to be added to the cart
   * @param cart an array of strings which contains the names of items in the cart
   * @param size the number of items in the cart
   * 
   * @return An integer representation of the number of occurrences of item (exact match) within the
   *         oversize array cart. Zero or more occurrences of item can be present in the cart.
   */
  public static int nbOccurrences(String item, String[] cart, int size) {
    int occurrences = 0;
    for (int i = 0; i < size; i++) {
      if (item.equals(cart[i])) {
        occurrences++;
      }
    }
    return occurrences;
  }

  /**
   * Checks whether a cart contains at least one occurrence of a given item. This method must not
   * make any changes to the contents of the cart.
   *
   * @param item the name of the product to be added to the cart
   * @param cart an array of strings which contains the names of items in the cart
   * @param size the number of items in the cart
   * 
   * @return A boolean representation of if there is a match between the item entered within the
   *         cart array. Returns true if there is a match (exact match) of item within the provided
   *         cart, and false otherwise.
   */
  public static boolean contains(String item, String[] cart, int size) {
    boolean match = false;
    for (int i = 0; i < size; i++) {
      if (item.equals(cart[i])) {
        match = true;
      }
    }
    return match;
  }

  /**
   * This method returns the total value in dollars of the cart. All products in the market are
   * taxable (subject to TAX_RATE).
   *
   * @param cart an array of strings which contains the names of items in the cart
   * @param size the number of items in the cart
   * 
   * @return A double representation of the total value in dollars of the cart accounting taxes.
   */
  public static double checkout(String[] cart, int size) {
    double totalPrice = 0.0;
    for (int i = 0; i < size; i++) {
      totalPrice = totalPrice + (getProductPrice(cart[i]) + getProductPrice(cart[i]) * TAX_RATE);
    }
    return totalPrice;
  }

  /**
   * Removes one occurrence of item from a given cart. If no match with item was found in the cart,
   * the method returns the same value of input size without making any change to the contents of
   * the array.
   *
   * @param cart an array of strings which contains the names of items in the cart
   * @param item the name of the product to be added to the cart
   * @param size the number of items in the cart
   * 
   * @return An integer representation of the size of the oversize array cart after trying to remove
   *         item from the cart.
   */
  public static int removeItem(String[] cart, String item, int size) {
    if (contains(item, cart, size) == true) {
      int locationContains = 0;
      for (int i = 0; i < size; i++) {
        if (item.equals(cart[i])) {
          locationContains = i;
        }
      }
      size = size - 1;
      for (int k = locationContains; k < size; k++) {
        cart[k] = cart[k + 1];
      }
      cart[size] = null;
    }
    return size;
  }

  /**
   * Removes all items from a given cart. The array cart must be empty (contains only null
   * references) after this method returns.
   *
   * @param cart an array of strings which contains the names of items in the cart
   * @param size the number of items in the cart
   * 
   * @return An integer representation of the size of the cart after removing all its items.
   */
  public static int emptyCart(String[] cart, int size) {
    int sizeHard = size;
    for (int i = 0; i < sizeHard; i++) {
      cart[i] = null;
      size = size - 1;
    }
    return size;
  }

  /**
   * Returns a string representation of the summary of the contents of a given cart. The format of
   * the returned string contains a set of lines where each line contains the number of occurrences
   * of a given item, between parentheses, followed by one space followed by the name of a unique
   * item in the cart.
   *
   * @param cart an array of strings which contains the names of items in the cart
   * @param size the number of items in the cart
   * 
   * @return A string representation of the summary of the contents of the cart
   */
  public static String getCartSummary(String[] cart, int size) {

    String summary = "";
    String[] cartCopy = new String[size];
    for (int i = 0; i < size; i++) {
      if (!contains(cart[i], cartCopy, size)) {
        cartCopy[i] = cart[i];
        summary = summary + "(" + nbOccurrences(cart[i], cart, size) + ") " + cart[i] + "\n";
      }
    }

    return summary;
  }

  /**
   * Returns a comparison between two 2-dimensional arrays
   *
   * @param initialArray   a 2-dimensional array of strings
   * @param comparingArray a 2-dimensional array of strings
   * 
   * @return An boolean representation (used for comparing the marketItems array and the created
   *         deep copy of marketItems) of the comparison between two 2-dimensional arrays
   */
  public static boolean getCopyOfMarketItemsEquals(String[][] initialArray,
      String[][] comparingArray) {

    if (initialArray == null) {
      return (comparingArray == null);
    }
    if (comparingArray == null) {
      return false;
    }
    if (initialArray.length != comparingArray.length) {
      return false;
    }
    
    return true;
  }
}
