//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title: Exceptional Shopping Cart
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
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.io.IOException;
import java.util.NoSuchElementException;
import java.util.zip.DataFormatException;
import java.util.Scanner;

/**
 * This class implements an enhanced version of the ShoppingCart class by throwing exceptions to
 * report bugs or misuse of the following set of methods, loads cart summary to the exceptional
 * shopping cart from a file, and saves the cart summary to a cart in a file (with format)
 */
public class ExceptionalShoppingCart {

  // Define final parameters (constants)
  private static final double TAX_RATE = 0.05; // sales tax

  // a perfect-size two-dimensional array that stores the list of available items in a given market
  // MarketItems[i][0] refers to a String representation of the item key (unique identifier)
  // MarketItems[i][1] refers the item name
  // MarketItems[i][2] a String representation of the unit price of the item in dollars
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
   * Creates a deep copy of the market catalog
   * 
   * @return Returns a deep copy of the market catalog 2D array of strings
   */
  public static String[][] getCopyOfMarketItems() {
    String[][] copy = new String[marketItems.length][];
    for (int i = 0; i < marketItems.length; i++) {
      if (marketItems[i] != null) {
        copy[i] = new String[marketItems[i].length];
        for (int j = 0; j < marketItems[i].length; j++)
          copy[i][j] = marketItems[i][j];
      }
    }
    return copy;
  }

  /**
   * Returns a string representation of the item whose name is provided as input
   *
   * @param name name of the item to find
   * @return "itemId name itemPrice" if an item with the provided name was found
   * @throws NoSuchElementException with descriptive error message if no match found
   */
  public static String lookupProductByName(String name) {

    String s = "No match found";
    for (int i = 0; i < marketItems.length; i++) {
      if (marketItems[i] != null && name.equals(marketItems[i][1])) {
        return marketItems[i][0] + " " + marketItems[i][1] + " " + marketItems[i][2];
      }
    }
    throw new NoSuchElementException("lookupProductByName() method detects an Error: " + s);
  }


  /**
   * Returns a string representation of the item whose id is provided as input
   *
   * @param key id of the item to find
   * @return "itemId name itemPrice" if an item with the provided name was found
   * @throws IllegalArgumentException with descriptive error message if key is not a 4-digits int
   * @throws NoSuchElementException   with descriptive error message if no match found
   */
  public static String lookupProductById(int key) {

    int lengthOfKey = String.valueOf(key).length();
    if (lengthOfKey != 4) {
      throw new IllegalArgumentException(
          "lookupProductById() method detects an Error: ID key entered is NOT a 4-digit int");
    }

    String s = "No match found";
    for (int i = 0; i < marketItems.length; i++) {
      if (marketItems[i] != null) {
        if (marketItems[i][0].equals(String.valueOf(key)))
          return marketItems[i][0] + " " + marketItems[i][1] + " " + marketItems[i][2];
      }
    }
    throw new NoSuchElementException(s);
  }

  /**
   * Returns the index of the first null position that can be used to add new market items returns
   * the length of MarketItems if no available null position is found
   * 
   * @return returns an available position to add new market items or the length of market items if
   *         no available positions are found
   */
  private static int indexOfInsertionPos() {
    for (int i = 0; i < marketItems.length; i++) {
      if (marketItems[i] == null)
        return i;
    }
    return marketItems.length;
  }

  /**
   * Doubles the capacity of the array[][] original
   * 
   * @param original array to expand
   * @return an array with the same contents as original but with double capacity
   */
  public static String[][] expandArray(String[][] original) {
    // Create a new array of strings of double length with respect to original
    String[][] expanded = new String[2 * original.length][2];
    // traverse the array original copying its elements into the created array
    for (int i = 0; i < original.length; i++)
      for (int j = 0; j < 3; j++) {
        expanded[i][j] = original[i][j];
      }
    return expanded;
  }

  /**
   * Doubles the capacity of the array[] original
   * 
   * @param original array to expand
   * @return an array with the same contents as original but with double capacity
   */
  public static String[] expandArray(String[] original) {
    // Create a new array of strings of double length with respect to original
    String[] expanded = new String[2 * original.length];
    // traverse the array original copying its elements into the created array
    for (int i = 0; i < original.length; i++)
      expanded[i] = original[i];

    return expanded;
  }

  /**
   * add a new item to market items array, expand the capacity of marketitems if it is full when
   * trying to add new item, use indexofInsertionPos() to find the position to add
   * 
   * @param id    id of the item to add
   * @param name  name of the item to add
   * @param price price of the item to add
   * @throws IllegalArgumentException with descriptive error message if id not parsable to 4-digits
   *                                  int, name is null or empty string, and price not parsable to
   *                                  double
   */
  public static void addItemToMarketCatalog(String id, String name, String price) {

    try {
      int length = String.valueOf(id).length();
      if (length != 4) {
        throw new IllegalArgumentException(
            "addItemToMarketCatalog() method detects an Error: ID is NOT parable to a 4-digit int");
      } else {
        Integer.parseInt(id);
      }
    } catch (NumberFormatException e) {
      throw new IllegalArgumentException(
          "addItemToMarketCatalog() method detects an Error: ID is NOT parable to a 4-digit int");
    }
    try {
      Double.parseDouble(price.substring(1));
    } catch (NumberFormatException e) {
      throw new IllegalArgumentException(
          "addItemToMarketCatalog() method detects an Error: Price is NOT parsable to a double");
    }
    if (name == null || name == "") {
      throw new IllegalArgumentException(
          "addItemToMarketCatalog() method detects an Error: Name is either a null or an "
              + "empty string");
    }

    int next = indexOfInsertionPos();
    if (next == marketItems.length) {
      expandArray(marketItems);
      System.out.println("Full catalog! No further item can be added!");
    } else {
      marketItems[next] = new String[] {id, name, price};
    }
  }

  /**
   * Returns the price in dollars (a double value) of a market item given its name.
   * 
   * @param name name of the item to get the price
   * @return the price of the item
   * @throws NoSuchElementException with descriptive error message if price not found
   */
  public static double getProductPrice(String name) {

    for (int i = 0; i < marketItems.length; i++) {
      if (marketItems[i] != null && name.equals(marketItems[i][1])) {
        return Double.valueOf(marketItems[i][2].substring(1));
      }
    }
    throw new NoSuchElementException("getProductPrice() method detects an Error: Price not found");
  }

  /**
   * Appends an item to a given cart (appends means adding to the end). If the cart is already full
   * (meaning its size equals its length), IllegalStateException wil be thrown.
   * 
   * @param item the name of the product to be added to the cart
   * @param cart an array of strings which contains the names of items in the cart
   * @param size the number of items in the cart
   * @return the size of the oversize array cart after trying to add item to the cart.
   * @throws IllegalArgumentException with descriptive error message if size is less than zero
   * @throws IllegalStateException    with descriptive error message if this cart is full
   */
  public static int addItemToCart(String item, String[] cart, int size) {

    if (size < 0) {
      throw new IllegalArgumentException(
          "addItemToCart() method detects an Error: Size is less than zero");
    }
    if (size == cart.length) {
      throw new IllegalStateException("addItemToCart() method detects an Error: Cart is full");
    }
    cart[size] = item;
    size++;
    return size;
  }

  /**
   * Returns the number of occurrences of a given item within a cart. This method must not make any
   * changes to the contents of the cart.
   * 
   * @param item the name of the item to search
   * @param cart an array of strings which contains the names of items in the cart
   * @param size the number of items in the cart
   * @return the number of occurrences of item (exact match) within the oversize array cart. Zero or
   *         more occurrences of item can be present in the cart.
   * @throws IllegalArgumentException with descriptive error message if size is less than zero
   */
  public static int nbOccurrences(String item, String[] cart, int size) {

    if (size < 0) {
      throw new IllegalArgumentException(
          "nbOccurrences() method detects an Error: Size is less than zero");
    }

    int count = 0;
    for (int i = 0; i < size; i++) {
      if (cart[i].equals(item)) {
        count++;
      }
    }
    return count;
  }

  /**
   * Checks whether a cart contains at least one occurrence of a given item. This method must not
   * make any changes to the contents of the cart.
   * 
   * @param item the name of the item to search
   * @param cart an array of strings which contains the names of items in the cart
   * @param size the number of items in the cart
   * @return Returns true if there is a match (exact match) of item within the provided cart, and
   *         false otherwise.
   * @throws IllegalArgumentException with descriptive error message if size is less than zero
   */
  public static boolean contains(String item, String[] cart, int size) {

    if (size < 0) {
      throw new IllegalArgumentException(
          "contains() method detects an Error: Size is less than zero");
    }

    for (int i = 0; i < size; i++) {
      if (cart[i].equals(item)) {
        return true;
      }
    }
    return false;
  }

  /**
   * Removes one occurrence of item from a given cart.
   * 
   * @param item the name of the item to remove
   * @param cart an array of strings which contains the names of items in the cart
   * @param size the number of items in the cart
   * @return Returns the size of the oversize array cart after trying to remove item from the cart.
   * @throws IllegalArgumentException with descriptive error message if size is less than zero
   * @throws NoSuchElementException   with descriptive error message if item not found in the cart
   */
  public static int removeItem(String[] cart, String item, int size) {

    if (size < 0) {
      throw new IllegalArgumentException(
          "removeItem() method detects an Error: Size is less than zero");
    }

    for (int i = 0; i < size; i++) {
      if (cart[i].equals(item)) {
        cart[i] = cart[size - 1];
        cart[size - 1] = null;
        return size - 1;
      }
    }
    throw new NoSuchElementException(
        "removeItem() method detects an Error: Item not found in the cart");
  }


  /**
   * Removes all items from a given cart. The array cart must be empty (contains only null
   * references) after this method returns.
   * 
   * @param cart an array of strings which contains the names of items in the cart
   * @param size the number of items in the cart
   * @return Returns the size of the cart after removing all its items.
   * @throws IllegalArgumentException with descriptive error message if size is less than zero
   * @throws NullPointerException     with descriptive error message if cart is null
   */
  public static int emptyCart(String[] cart, int size) {

    if (size < 0) {
      throw new IllegalArgumentException(
          "emptyCart() method detects an Error: Size is less than zero");
    }

    if (cart == null) {
      throw new NullPointerException("emptyCart() method detects an Error: Cart array is null");
    }
    for (int i = 0; i < cart.length; i++) {
      cart[i] = null;
    }
    return 0;
  }


  /**
   * This method returns the total value in dollars of the cart. All products in the market are
   * taxable (subject to TAX_RATE).
   * 
   * @param cart an array of strings which contains the names of items in the cart
   * @param size the number of items in the cart
   * @return Returns the total value in dollars of the cart accounting taxes.
   * @throws IllegalArgumentException with descriptive error message if size is less than zero
   */
  public static double checkout(String[] cart, int size) {

    if (size < 0) {
      throw new IllegalArgumentException(
          "checkout() method detects an Error: Size is less than zero");
    }
    double total = 0.0;
    for (int i = 0; i < size; i++) {
      total += getProductPrice(cart[i]) * (1 + TAX_RATE);
    }
    return total;
  }

  /**
   * Returns a string representation of the summary of the contents of a given cart. The format of
   * the returned string contains a set of lines where each line contains the number of occurrences
   * of a given item, between spaces and parentheses, followed by one space followed by the name of
   * a unique item in the cart. ( #occurrences ) name1 ( #occurrences ) name2 etc.
   * 
   * @param cart an array of strings which contains the names of items in the cart
   * @param size the number of items in the cart
   * @return Returns a string representation of the summary of the contents of the cart
   * @throws IllegalArgumentException with descriptive error message if size is less than zero
   */
  public static String getCartSummary(String[] cart, int size) {

    if (size < 0) {
      throw new IllegalArgumentException(
          "getCartSummary() method detects an Error: Size is less than zero");
    }
    String s = "";
    for (int i = 0; i < size; i++) {
      if (!contains(cart[i], cart, i)) {
        s = s + "( " + nbOccurrences(cart[i], cart, size) + " ) " + cart[i] + "\n";
      }
    }
    return s.trim();
  }


  /**
   * Save the cart summary to a file
   *
   * @param cart an array of strings which contains the names of items in the cart
   * @param size the number of items in the cart
   * @param file the file to save the cart summary
   * @throws IllegalArgumentException with descriptive error message if size is less than zero
   */
  public static void saveCartSummary(String[] cart, int size, File file) {

    if (size < 0) {
      throw new IllegalArgumentException(
          "saveCartSummary() method detects an Error: Size is less than zero");
    }
    PrintWriter pWriter = null;
    try {
      pWriter = new PrintWriter(file);
      pWriter.write(getCartSummary(cart, size));
    } catch (IOException e) {
      System.out.println("IOException");
    } finally {
      if (pWriter != null) {
        pWriter.close();
      }
    }
  }

  /**
   * Parse one line of cart summary and add nbOccurrences of item to cart correct formatting for
   * line:"( " + nbOccurrences + " ) " + itemName delimiter: one space (multiple spaces: wrong
   * formatting)
   *
   * @param line a line of the cart summary to be parsed into one item to be added
   * @param cart an array of strings which contains the names of items in the cart
   * @param size the number of items in the cart
   * @throws DataFormatException      with descriptive error message if wrong formatting (including
   *                                  nbOccurrences not parsable to a positive integer less or equal
   *                                  to 10)
   * @throws IllegalArgumentException with descriptive error message if itemName not found in
   *                                  marketItems
   * @throws IllegalStateException    with descriptive error message if cart reaches its capacity
   */
  protected static int parseCartSummaryLine(String line, String[] cart, int size)
      throws DataFormatException, IllegalStateException, IllegalArgumentException {
    int numItems;
    int indexOfOccur;

    // ensure line given is clean & split line
    line = line.trim();
    String[] cartSplitString = line.split("\\s", 4);

    // parse nbOccurrences
    try {
      indexOfOccur = 1;
      numItems = Integer.parseInt(cartSplitString[indexOfOccur]);
    } catch (NumberFormatException e) {
      throw new DataFormatException(
          "parseCartSummaryLine() method detects an Error: Wrong Formatting");
    }

    // ensure numItems is correct
    if (numItems <= 0 || numItems > 10 || cartSplitString.length < 4) {
      throw new DataFormatException(
          "parseCartSummaryLine() method detects an Error: Wrong Formatting - nbOccurrences not "
              + "parsable to a positive integer less or equal to 10");
    }

    // get name of item
    String itemName;
    try {
      itemName = cartSplitString[3];
    } catch (StringIndexOutOfBoundsException e) {
      // there was no item name given, skip
      return size;
    }

    try {
      lookupProductByName(cartSplitString[3]);
    } catch (NoSuchElementException e) {
      throw new IllegalArgumentException(
          "parseCartSummaryLine() method detects an Error: itemName not found in marketItems");
    }

    // check if cart would be too full
    if (size + numItems > cart.length) {
      // cart would be too full, error
      throw new IllegalStateException(
          "parseCartSummaryLine() method detects an Error: cart reached its capacity");
    }

    // add item to cart
    for (int i = 0; i < numItems; ++i) {
      size++;
      addItemToCart(itemName, cart, size);
    }

    return size;
  }

  /**
   * Load the cart summary from the file. For each line of summary, add nbOccurrences of item to
   * cart. Must call parseCartSummaryLine to operate
   *
   * @param file file to load the cart summary from
   * @param cart an array of strings which contains the names of items in the cart
   * @param size the number of items in the cart
   * @return Returns the size of the cart after adding items to the cart
   * @throws IllegalArgumentException with descriptive error message if size is less than zero
   * @throws IllegalStateException    with descriptive error message if cart reaches its capacity
   */
  public static int loadCartSummary(File file, String[] cart, int size) {
    // This method MUST call parseCartSummaryLine to operate (to parse each line in file)

    // throws IllegalStateException with descriptive error message if cart reaches its capacity
    if (size == cart.length) {
      throw new IllegalStateException(
          "loadCartSummary() method detects an Error: cart reached its capacity");
    }

    // throws IllegalArgumentException with descriptive error message if size is less than zero
    if (size < 0) {
      throw new IllegalArgumentException(
          "loadCartSummary() method detects an Error: Size is less than zero");
    }

    Scanner scnr = null;
    try {
      scnr = new Scanner(file);
      while (scnr.hasNextLine()) {
        String line = scnr.nextLine();
        parseCartSummaryLine(line, cart, size);
      }
    } catch (FileNotFoundException e) {
      System.out.println("FileNotFoundException");
    } catch (DataFormatException e) {
      System.out.println("DataFormatException");
    } catch (Exception e) {
      
    } finally {
      if (scnr != null) {
        scnr.close();
      }
    }
    return size;
  }


}
