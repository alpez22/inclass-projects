//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title: Shopping Cart Tester
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

public class ShoppingCartTester {

  /**
   * Main method
   * 
   * @param args input arguments if any
   */
  public static void main(String[] args) {
    System.out.println("testLookupMethods(): " + testLookupMethods());
    System.out.println("testGetProductPrice(): " + testGetProductPrice());
    System.out.println(
        "testAddItemToCartContainsNbOccurrences(): " + testAddItemToCartContainsNbOccurrences());
    System.out.println("testRemoveItem(): " + testRemoveItem());
    System.out.println("testCheckoutGetCartSummary(): " + testCheckoutGetCartSummary());
    System.out.println("getCopyOfMarketItemsTest(): " + getCopyOfMarketItemsTest());
    System.out.println("runAllTests(): " + runAllTests());

  }


  /**
   * Checks whether ShoppingCart.lookupProductByName() and ShoppingCart.lookupProductById() methods
   * work as expected.
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean testLookupMethods() {

    // 1. The item to find is at index 0 of the marketItems array
    String expectedOutput = "4390 Apple $1.59";
    if (!ShoppingCart.lookupProductByName("Apple").equals(expectedOutput)) {
      System.out.println("Problem detected: Your lookupProductByName() method "
          + "failed to return the expected output when passed Apple as input");
      return false;
    }
    if (!ShoppingCart.lookupProductById(4390).equals(expectedOutput)) {
      System.out.println("Problem detected: Your lookupProductById() method "
          + "failed to return the expected output when passed the id " + "of Apple as input");
      return false;
    }

    // 2. The item to find is at the last non-null position of
    // the marketItems array
    expectedOutput = "4688 Tomato $1.79";
    if (!ShoppingCart.lookupProductByName("Tomato").equals(expectedOutput)) {
      System.out.println("Problem detected: Your lookupProductByName() method "
          + "failed to return the expected output when passed Tomato as input");
      return false;
    }
    if (!ShoppingCart.lookupProductById(4688).equals(expectedOutput)) {
      System.out.println("Problem detected: Your lookupProductById() method "
          + "failed to return the expected output when passed the id " + "of Tomato as input");
      return false;
    }

    // 3. The item to find is at an arbitrary position of the
    // middle of the marketItems array
    expectedOutput = "4071 Chocolate $3.19";
    if (!ShoppingCart.lookupProductByName("Chocolate").equals(expectedOutput)) {
      System.out.println("Problem detected: Your lookupProductByName() method "
          + "failed to return the expected output when passed Chocolate as input");
      return false;
    }
    if (!ShoppingCart.lookupProductById(4071).equals(expectedOutput)) {
      System.out.println("Problem detected: Your lookupProductById() method "
          + "failed to return the expected output when passed the id " + "of Chocolate as input");
      return false;
    }

    // 4. The item to find is not found in the market
    expectedOutput = "No match found";
    if (!ShoppingCart.lookupProductByName("NOT FOUND").equals(expectedOutput)) {
      System.out.println("Problem detected: Your lookupProductByName() method "
          + "failed to return the expected output when passed the name of "
          + "a product not found in the market.");
      return false;
    }
    if (!ShoppingCart.lookupProductById(1000).equals(expectedOutput)) {
      System.out.println("Problem detected: Your lookupProductById() method "
          + "failed to return the expected output when passed the identifier"
          + "of a product not found in the market.");
      return false;
    }
    return true; // NO BUGS detected by this tester method
  }


  /**
   * Checks the correctness of ShoppingCart.getProductPrice() method
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean testGetProductPrice() {

    // 1. get the price of Apple - first non-null string
    double expectedPrice = 1.59;
    if (Math.abs(ShoppingCart.getProductPrice("Apple") - expectedPrice) > 0.001) {
      System.out.println("Problem detected: Your getProductPrice() method "
          + "failed to return the expected output/produce price when " + "passed Apple as input");
      return false;
    }
    // 2. get the price of Tomato - last non-null string
    expectedPrice = 1.79;
    if (Math.abs(ShoppingCart.getProductPrice("Tomato") - expectedPrice) > 0.001) {
      System.out.println("Problem detected: Your getProductPrice() method "
          + "failed to return the expected output/produce price when " + "passed Tomato as input");
      return false;
    }

    // 3. get the price of Cookie/an arbitrary position of the middle of the marketItems array
    expectedPrice = 9.5;
    if (Math.abs(ShoppingCart.getProductPrice("Cookie") - expectedPrice) > 0.001) {
      System.out.println("Problem detected: Your getProductPrice() method "
          + "failed to return the expected output/produce price when " + "passed Cookie as input");
      return false;
    }

    // 4. get the price of an item that isn't found in marketItem array
    expectedPrice = -1.0;
    if (Math.abs(ShoppingCart.getProductPrice("NOT FOUND") - expectedPrice) > 0.001) {
      System.out.println("Problem detected: Your getProductPrice() method "
          + "failed to return the expected output/produce price when "
          + "passed an item NOT found in the market as input");
      return false;
    }

    return true; // No bug detected. The ShoppingCart.getProductPrice()
  }


  /**
   * Checks the correctness of ShoppingCart.addItemToCart(), ShoppingCart.contains(),
   * ShoppingCart.nbOccurrences() methods
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean testAddItemToCartContainsNbOccurrences() {

    // 1. adding an item to an empty cart
    String[] cart = new String[10]; // array containing 10 null references
    int size = 0;
    int expected = 1;
    if (ShoppingCart.addItemToCart("Banana", cart, size) != expected) {
      System.out.println("Problem detected: Your addItemToCart() method "
          + "failed to return the expected output/size number when "
          + "passed Banana into an empty cart");
      return false;
    }

    // 2. adding an item to a full cart
    cart = new String[] {"Milk", "Apple", "Banana", "Pizza"};
    size = 4; // full array (size == cart.length)
    expected = 4;
    if (ShoppingCart.addItemToCart("Eggs", cart, size) != expected) {
      System.out.println("Problem detected: Your addItemToCart() method "
          + "failed to return the expected output/size number when "
          + "passed Eggs into a full cart");
      return false;
    }

    // 3. adding successfully an item to a non-empty cart
    cart = new String[] {"Milk", "Apple", "Banana", "Pizza", null, null};
    size = 4;
    expected = 5;
    if (ShoppingCart.addItemToCart("Eggs", cart, size) != expected) {
      System.out.println("Problem detected: Your addItemToCart() method "
          + "failed to return the expected output/size number when "
          + "passed Eggs into a free cart");
      return false;
    }

    // 4. counting number of occurrences when there are 0
    cart = new String[] {"Milk", "Apple", "Banana", "Pizza", null, null};
    size = 4;
    expected = 0;
    if (ShoppingCart.nbOccurrences("Eggs", cart, size) != expected) {
      System.out.println("Problem detected: Your nbOccurrences() method "
          + "failed to return the expected output/number of occurrences when "
          + "passed Eggs into a free cart with no Eggs");
      return false;
    }

    // 5. counting number of occurrences when there are multiple
    cart = new String[] {"Milk", "Milk", "Banana", "Milk", null, null};
    size = 4;
    expected = 3;
    if (ShoppingCart.nbOccurrences("Milk", cart, size) != expected) {
      System.out.println("Problem detected: Your nbOccurrences() method "
          + "failed to return the expected output/number of occurrences when "
          + "passed Milk into a free cart with multiple Milks");
      return false;
    }

    // 6. checks if there contains at least one occurrence when there are multiple
    cart = new String[] {"Milk", "Milk", "Banana", "Milk", null, null};
    size = 4;
    boolean expected67 = true;
    if (ShoppingCart.contains("Milk", cart, size) != expected67) {
      System.out.println("Problem detected: Your contains() method "
          + "failed to return the expected output/boolean occurrences when "
          + "passed Milk into a free cart with multiple occurrences");
      return false;
    }

    // 7. checks if there contains at least one occurrence when there are none
    cart = new String[] {"Milk", "Apple", "Banana", "Pizza", null, null};
    size = 4;
    expected67 = false;
    if (ShoppingCart.contains("Eggs", cart, size) != expected67) {
      System.out.println("Problem detected: Your contains() method "
          + "failed to return the expected output/boolean occurrences when "
          + "passed Eggs into a free cart with zero occurrences");
      return false;
    }

    return true;
  }

  /**
   * Checks the correctness of ShoppingCart.removeItem() methods
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean testRemoveItem() {

    // 1. removing an item stored at index 0 of a non-empty cart
    String[] cart = new String[] {"Milk", "Apple", "Banana", "Pizza", "Eggs"};
    int size = 5; // full array (size == cart.length)
    int expected = 4;
    if (ShoppingCart.removeItem(cart, "Milk", size) != expected) {
      System.out.println("Problem detected: Your removeItem() method "
          + "failed to return the expected output/size after remove when "
          + "passed Milk into a full cart");
      return false;
    }

    // 2. removing an item whose first occurrence is stored at index size-1 (last index position) of
    // a non-empty cart
    cart = new String[] {"Milk", "Apple", "Banana", "Pizza", "Eggs"};
    size = 5; // full array (size == cart.length)
    expected = 4;
    if (ShoppingCart.removeItem(cart, "Eggs", size) != expected) {
      System.out.println("Problem detected: Your removeItem() method "
          + "failed to return the expected output/size after remove when "
          + "passed Milk into a full cart");
      return false;
    }

    // 3. removing an item whose first occurrence is stored at an arbitrary position within a
    // non-empty array cart (from 1 .. size-2)
    cart = new String[] {"Milk", "Apple", "Banana", "Pizza", "Eggs"};
    size = 5; // full array (size == cart.length)
    expected = 4;
    if (ShoppingCart.removeItem(cart, "Banana", size) != expected) {
      System.out.println("Problem detected: Your removeItem() method "
          + "failed to return the expected output/size after remove when "
          + "passed Milk into a full cart");
      return false;
    }

    // 4. trying to remove an item from an empty cart (whose size is zero),
    cart = new String[] {null, null, null, null, null};
    size = 0; // full array (size == cart.length)
    expected = 0;
    if (ShoppingCart.removeItem(cart, "Banana", size) != expected) {
      System.out.println("Problem detected: Your removeItem() method "
          + "failed to return the expected output/size after remove when "
          + "passed Milk into a full cart");
      return false;
    }

    // 5. trying to remove a non-existing item from the cart
    cart = new String[] {"Milk", "Apple", "Banana", "Pizza", "Eggs"};
    size = 5; // full array (size == cart.length)
    expected = 5;
    if (ShoppingCart.removeItem(cart, "Mushroom", size) != expected) {
      System.out.println("Problem detected: Your removeItem() method "
          + "failed to return the expected output/size after remove when "
          + "passed Milk into a full cart");
      return false;
    }

    return true;
  }

  /**
   * Checks the correctness of ShoppingCart.checkout(), ShoppingCart.getCartSummary() methods
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean testCheckoutGetCartSummary() {

    // 1. Empty cart - getCartSummary()
    String[] cart = new String[7];
    int size = 0;
    String expected = "";
    if (!(ShoppingCart.getCartSummary(cart, size).equals(expected))) {
      System.out.println("Problem detected: Your getCartSummary() method "
          + "failed to return the expected output/summary string when "
          + "passed into an empty cart");
      return false;
    }

    // 2. Cart containing unique items
    cart = new String[] {"Milk", "Apple", "Banana", "Pizza", null, null};
    size = 4;
    expected = "" + "(1) Milk\n(1) Apple\n(1) Banana\n(1) Pizza\n";
    if (!(ShoppingCart.getCartSummary(cart, size).equals(expected))) {
      System.out.println("Problem detected: Your getCartSummary() method "
          + "failed to return the expected output/summary string when "
          + "passed into a cart containting unique items");
      System.out.print(ShoppingCart.getCartSummary(cart, size));
      return false;
    }

    // 3. Cart containing multiple occurrences of the same items
    cart = new String[] {"Tomato", "Milk", "Milk", "Eggs", "Tomato", "Onion", "Eggs", "Milk",
        "Banana", null, null};
    size = 9;
    expected = "(2) Tomato\n" + "(3) Milk\n" + "(2) Eggs\n" + "(1) Onion\n" + "(1) Banana\n";
    if (!(ShoppingCart.getCartSummary(cart, size).equals(expected))) {
      System.out.println("Problem detected: Your getCartSummary() method "
          + "failed to return the expected output/summary string when "
          + "passed into a cart containting myltiple occurrences of the same items");
      ShoppingCart.getCartSummary(cart, size);
      return false;
    }

    // 4. total cost with full cart - checkout
    cart = new String[] {"Apple", "Avocado", "Banana", "Beef"};
    size = 4;
    double expected456 = 6.7829999999999995;
    if (ShoppingCart.checkout(cart, size) != expected456) {
      System.out.println("Problem detected: Your checkout() method "
          + "failed to return the expected output/sum cost when " + "passed cart");
      return false;
    }


    // 5. total cost with empty cart - checkout
    cart = new String[10]; // array containing 10 null references
    size = 0;
    expected456 = 0.0;
    if (ShoppingCart.checkout(cart, size) != expected456) {
      System.out.println("Problem detected: Your checkout() method "
          + "failed to return the expected output/sum cost when " + "passed an empty cart");
      return false;
    }


    // 6. total cost with null values present - checkout
    cart = new String[] {"Apple", "Avocado", "Banana", "Beef", null, null};
    size = 4;
    expected456 = 6.7829999999999995;
    if (ShoppingCart.checkout(cart, size) != expected456) {
      System.out.println("Problem detected: Your checkout() method "
          + "failed to return the expected output/sum cost when " + "passed cart");
      return false;
    }

    return true;
  }

  /**
   * Checks the correctness of ShoppingCart.getCopyOfMarketItemsTest() method
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean getCopyOfMarketItemsTest() {

    String[][] expectedOutput = new String[][] {{"4390", "Apple", "$1.59"},
        {"4046", "Avocado", "$0.59"}, {"4011", "Banana", "$0.49"}, {"4500", "Beef", "$3.79"},
        {"4033", "Blueberry", "$6.89"}, {"4129", "Broccoli", "$1.79"}, {"4131", "Butter", "$4.59"},
        {"4017", "Carrot", "$1.19"}, {"3240", "Cereal", "$3.69"}, {"3560", "Cheese", "$3.49"},
        {"3294", "Chicken", "$5.09"}, {"4071", "Chocolate", "$3.19"}, {"4363", "Cookie", "$9.5"},
        {"4232", "Cucumber", "$0.79"}, {"3033", "Eggs", "$3.09"}, {"4770", "Grape", "$2.29"},
        {"3553", "Ice Cream", "$5.39"}, {"3117", "Milk", "$2.09"}, {"3437", "Mushroom", "$1.79"},
        {"4663", "Onion", "$0.79"}, {"4030", "Pepper", "$1.99"}, {"3890", "Pizza", "$11.5"},
        {"4139", "Potato", "$0.69"}, {"3044", "Spinach", "$3.09"}, {"4688", "Tomato", "$1.79"},
        null, null, null, null};

    if (!(ShoppingCart.getCopyOfMarketItemsEquals(expectedOutput,
        ShoppingCart.getCopyOfMarketItems()))) {
      System.out.println("Problem detected: Your getCopyOfMarketItems() method "
          + "failed to return the expected output/non-copy of marketItems within the ShoppingCart "
          + "class");
      return false;
    }
    return true;
  }

  /**
   * Checks the correctness of all the tester methods defined in this tester class
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean runAllTests() {

    if (testLookupMethods() && testGetProductPrice() && testAddItemToCartContainsNbOccurrences()
        && testRemoveItem() && testCheckoutGetCartSummary() && getCopyOfMarketItemsTest() != true) {
      System.out
          .println("Problem detected: One of your methods failed to return the expected output");
      return false;
    }
    return true;
  }

}
