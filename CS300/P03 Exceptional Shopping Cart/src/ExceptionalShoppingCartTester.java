//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title: Exceptional Shopping Cart Tester
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
import java.util.Arrays;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.io.IOException;
import java.util.NoSuchElementException;
import java.util.zip.DataFormatException;
import java.util.Scanner;

/**
 * This class checks the correctness of the implementation of the different operations supported by
 * our exceptional shopping cart.
 */
public class ExceptionalShoppingCartTester {

  /**
   * Main method used to run test methods
   * 
   * @param args input arguments if any
   */
  public static void main(String[] args) {
    System.out.println(testLookupMethods());
    System.out.println(testAddToMarketCatalog());
    System.out.println(testSaveCartSummary());
    System.out.println(testLoadCartSummary());
    // System.out.println(runAllTests());
  }

  /**
   * Checks whether ExceptionalShoppingCart.lookupProductById() and
   * ExceptionalShoppingCart.lookupProductByName() methods work as expected.
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean testLookupMethods() {

    try {
      ExceptionalShoppingCart.lookupProductById(12345);
      ExceptionalShoppingCart.lookupProductById(3561);
      ExceptionalShoppingCart.lookupProductByName("Hello");
    } catch (IllegalArgumentException e) {
    } catch (Exception e) {
      return false;
    }
    return true;
  }

  /**
   * Checks whether the ExceptionalShoppingCart.addItemToMarketCatalog() method works as expected.
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean testAddToMarketCatalog() {

    try {
      ExceptionalShoppingCart.addItemToMarketCatalog("Int", "Pasta", "$4.06");
      ExceptionalShoppingCart.addItemToMarketCatalog("1234", "Pasta", "$Double");
      ExceptionalShoppingCart.addItemToMarketCatalog("1234", null, "$4.06");
      ExceptionalShoppingCart.addItemToMarketCatalog("1234", "", "$4.06");
    } catch (IllegalArgumentException e) {
    } catch (Exception e) {
      return false;
    }

    return true;
  }

  /**
   * Checks whether the ExceptionalShoppingCart.saveCartSummary() method works as expected.
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean testSaveCartSummary() {

    File file = new File("file.txt");
    String[] cart = new String[] {"Milk", "Apple", "Banana", "Pizza"};
    int size = 4;
    try {
      ExceptionalShoppingCart.saveCartSummary(cart, size, file);
    } catch (IllegalArgumentException e) {
      return false;
    }

    return true;
  }

  /**
   * Checks whether the ExceptionalShoppingCart.loadCartSummary() method works as expected.
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean testLoadCartSummary() {

    String[] cart = new String[] {"Milk", "Banana", "Banana", "Pizza"};
    String[] cart2 = new String[5];
    File file = new File("file2.txt");
    FileWriter writer;
    int size2 = 0;

    try {
      writer = new FileWriter(file);
      writer.write("( 1 ) Milk\n" + "( 3 ) Banana\n" + "( 1 ) Pizza");
      ExceptionalShoppingCart.loadCartSummary(file, cart2, size2);
      writer.close();
    } catch (IOException e) {
      System.out.println("IOException");
      return false;
    } catch (IllegalStateException e) {
      System.out.println("IllegalStateException");
      return false;
    } catch (IllegalArgumentException e) {
      System.out.println("IllegalArgumentException");
      return false;
    }

    for (int k = 0; k < cart.length; k++) {
      // System.out.println(cart[2]);
      // System.out.println(cart2[1]);
      if (cart[k] != cart2[k]) {
        return false;
      }
    }
    /**
     * 
     * try { System.out.println(ExceptionalShoppingCart.loadCartSummary(file, cart2, size2)); }
     * catch (IllegalStateException e) { System.out.println("IllegalStateException"); return false;
     * } catch (IllegalArgumentException e) { System.out.println("IllegalArgumentException"); return
     * false; }
     */

    return true;
  }

  /**
   * Checks the correctness of all the tester methods defined in this tester class
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean runAllTests() {

    if (testLookupMethods() && testAddToMarketCatalog() && testSaveCartSummary()
        && testLoadCartSummary() != true) {
      System.out
          .println("Problem detected: One of your methods failed to return the expected output");
      return false;
    }
    return true;
  }
}
