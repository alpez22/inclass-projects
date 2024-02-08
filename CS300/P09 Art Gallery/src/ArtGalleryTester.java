// TODO Complete file header must be added here

import java.util.NoSuchElementException;
import java.util.ArrayList;

/**
 * This class checks the correctness of the implementation of the methods defined in the class
 * ArtworkGallery.
 * 
 * @author Ava Pezza
 *
 */

public class ArtGalleryTester {

  /**
   * Checks the correctness of the implementation of both compareTo() and equals() methods defined
   * in the Artwork class.
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean testArtworkCompareToEquals() {

    // compareTo()

    // 1. otherArtwork has the same year of creation, same name, and same cost as this artwork --
    // print 0
    Artwork first = new Artwork("The Last Supper", 1498, 450000000);
    Artwork second = new Artwork("The Last Supper", 1498, 450000000);
    if (first.compareTo(second) != 0) {
      return false;
    }

    // 2. this artwork is older than the otherArtwork -- should print negative number
    // 1498 is older than 1503
    Artwork third = new Artwork("Mona Lisa", 1503, 1000000);
    if (first.compareTo(third) >= 0) {
      return false;
    }

    // 3. if they were created in the same year but this artwork is less expensive than the
    // otherArtwork -- print negative number
    // 304 is less expensive than 450000000
    Artwork fourth = new Artwork("The Immaculate Conception with Saints", 1498, 304);
    if (fourth.compareTo(first) >= 0) {
      return false;
    }

    // 4. if they have the same year and the same cost and this artwork has a lower lexical order
    // name than otherArtwork name -- print negative number
    Artwork fifth = new Artwork("Word", 1498, 450000000);
    if (first.compareTo(fifth) >= 0) {
      return false;
    }
    // 5. six is older, less expensive, and has a lower lexical order than first -- print positive
    // number
    Artwork sixth = new Artwork("Apple", 1400, 5500000);
    if (first.compareTo(sixth) <= 0) {
      return false;
    }

    // equals()

    // NOT an object of Artwork
    Artwork firstE = new Artwork("The Last Supper", 1498, 450000000);
    Object secondE = new Object();
    if (firstE.equals(secondE)) {
      return false;
    }

    // NOT: same name -- HAS: object of artwork, same year
    Artwork thirdE = new Artwork("Apple", 1498, 450000000);
    if (firstE.equals(thirdE)) {
      return false;
    }
    Artwork fourthE = new Artwork("Apple", 1498, 450); // make sure year doesn't affect method
    if (firstE.equals(fourthE)) {
      return false;
    }

    // NOT: same year -- HAS: object of artwork, same name
    Artwork fifthE = new Artwork("The Last Supper", 2000, 450000000);
    if (firstE.equals(fifthE)) {
      return false;
    }
    Artwork sixthE = new Artwork("The Last Supper", 2000, 450); // make sure year doesn't affect
                                                                // method
    if (firstE.equals(sixthE)) {
      return false;
    }

    // NOT same year, same name -- HAS: object of artwork
    Artwork seventhE = new Artwork("Apple", 2000, 450000000);
    if (firstE.equals(seventhE)) {
      return false;
    }
    Artwork eighthE = new Artwork("Apple", 2000, 450); // make sure year doesn't affect method
    if (firstE.equals(eighthE)) {
      return false;
    }

    // HAS: an object of Artwork, same name, or year == only one to return true
    Artwork equal = new Artwork("The Last Supper", 1498, 450000000);
    if (!first.equals(equal)) {
      return false;
    }

    return true;
  }

  /**
   * Checks the correctness of the implementation of both addArtwork() and toString() methods
   * implemented in the ArtworkGallery class. This unit test considers at least the following
   * scenarios. (1) Create a new empty ArtworkGallery, and check that its size is 0, it is empty,
   * and that its string representation is an empty string "". (2) try adding one artwork and then
   * check that the addArtwork() method call returns true, the tree is not empty, its size is 1, and
   * the .toString() called on the tree returns the expected output. (3) Try adding another artwork
   * which is smaller that the artwork at the root, (4) Try adding a third artwork which is greater
   * than the one at the root, (5) Try adding at least two further artwork such that one must be
   * added at the left subtree, and the other at the right subtree. For all the above scenarios, and
   * more, double check each time that size() method returns the expected value, the add method call
   * returns true, and that the .toString() method returns the expected string representation of the
   * contents of the binary search tree in an increasing order from the smallest to the greatest
   * artwork with respect to year, cost, and then name. (6) Try adding a artwork already stored in
   * the tree. Make sure that the addArtwork() method call returned false, and that the size of the
   * tree did not change.
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean testAddArtworkToStringSize() {
    // TODO complete the implementation of this method
    // (1)
    ArtGallery empty = new ArtGallery();
    if (empty.size() != 0) {
      return false;
    }
    if (!empty.toString().equals("")) {
      return false;
    }

    try {
      // (2) check that the addArtwork() method call returns true, the tree is not empty, its size
      // is
      // 1, and the .toString() called on the tree returns the expected output.
      // ArtGallery one = new ArtGallery();
      Artwork first = new Artwork("The Last Supper", 1800, 450000000);
      empty.addArtwork(first);
      String expected = "[(Name: The Last Supper) (Year: 1800) (Cost: $4.5E8)]" + "\n";
      // System.out.println(empty.toString().equals(expected));
      // System.out.println(empty.toString());
      // System.out.println(expected);
      if (!empty.addArtwork(first) && !empty.isEmpty() && empty.size() != 1
          && !empty.toString().equals(expected)) {
        return false;
      }

      // (3) Try adding another artwork which is smaller that the artwork at the root
      Artwork smaller = new Artwork("Dogs", 1700, 20);
      empty.addArtwork(smaller);
      String expected2 = "[(Name: Dogs) (Year: 1700) (Cost: $20.0)]" + "\n" + expected;
      // System.out.println(empty.toString());
      if (!empty.addArtwork(smaller) && empty.size() != 2 && !empty.toString().equals(expected2)) {
        return false;
      }

      // (4) Try adding a third artwork which is greater than the one at the root
      Artwork larger = new Artwork("Violet", 1900, 100);
      empty.addArtwork(larger);
      String expected3 = expected2 + "[(Name: Violet) (Year: 1900) (Cost: $100.0)]" + "\n";
      // System.out.println(empty.toString());
      if (!empty.addArtwork(larger) && empty.size() != 3 && !empty.toString().equals(expected3)) {
        return false;
      }

      // (5) Try adding at least two further artwork such that one must be added at the left
      // subtree, and the other at the right subtree. For all the above scenarios, and more, double
      // check each time that size() method returns the expected value, the add method call returns
      // true, and that the .toString() method returns the expected string representation of the
      // contents of the binary search tree in an increasing order from the smallest to the greatest
      // artwork with respect to year, cost, and then name.

      Artwork smallerX2 = new Artwork("Balloon", 1600, 15);
      Artwork largerX2 = new Artwork("Word", 2000, 150);
      boolean smallAdd = empty.addArtwork(smallerX2);
      boolean largeAdd = empty.addArtwork(largerX2);
      String expected4 = "[(Name: Balloon) (Year: 1600) (Cost: $15.0)]" + "\n" + expected3
          + "[(Name: Word) (Year: 2000) (Cost: $150.0)]" + "\n";
      //System.out.println(empty.toString());
      //System.out.println(expected4);
      //System.out.println(smallAdd);
      if (!empty.addArtwork(smallerX2) && !empty.addArtwork(largerX2) && empty.size() != 5) {
        System.out.println("hello");
        return false;
      }
      if(!empty.toString().equals(expected4)) {
        
        return false;
      }

      // (6) Try adding a artwork already stored in the tree. Make sure that the addArtwork() method
      // call returned false, and that the size of the tree did not change.
      if (empty.addArtwork(larger)) {
        return false;
      }

    } catch (Exception e) {
      e.printStackTrace();
      return false;
    }


    return true; // Default return statement added to resolve compiler errors
  }

  /**
   * This method checks mainly for the correctness of the ArtworkGallery.lookup() method. It must
   * consider at least the following test scenarios. (1) Create a new ArtworkGallery. Then, check
   * that calling the lookup() method on an empty ArtworkGallery returns false. (2) Consider a
   * ArtworkGallery of height 3 which lookup at least 5 artwork. Then, try to call lookup() method
   * to search for the artwork having a match at the root of the tree. (3) Then, search for a
   * artwork at the right and left subtrees at different levels considering successful and
   * unsuccessful search operations. Make sure that the lookup() method returns the expected output
   * for every method call.
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean testLookup() {
    // TODO complete the implementation of this method

    // (1) Create a new ArtworkGallery. Then, check that calling the lookup() method on an empty
    // ArtworkGallery returns false.
    ArtGallery empty = new ArtGallery();
    if (empty.lookup("hello", 2000, 50) == true) {
      return false;
    }

    // (2) Consider a ArtworkGallery of height 3 which lookup at least 5 artwork. Then, try to call
    // lookup() method to search for the artwork having a match at the root of the tree.
    Artwork first = new Artwork("Cane", 1650, 60);
    Artwork second = new Artwork("Elephant", 1700, 70);
    Artwork third = new Artwork("Hello", 1750, 75);
    Artwork fourth = new Artwork("Igloo", 1780, 80);
    Artwork fifth = new Artwork("Jump", 1800, 90);
    Artwork root = new Artwork("Keep", 1850, 100);
    Artwork seventh = new Artwork("Leopard", 1860, 150);
    Artwork eigth = new Artwork("Monster", 1870, 175);
    Artwork ninth = new Artwork("Octopus", 1880, 190);
    Artwork tenth = new Artwork("Piano", 1890, 200);
    Artwork eleventh = new Artwork("Queen", 1900, 220);
    empty.addArtwork(root);
    empty.addArtwork(fifth);
    empty.addArtwork(seventh);
    empty.addArtwork(fourth);
    empty.addArtwork(third);
    empty.addArtwork(second);
    empty.addArtwork(first);
    empty.addArtwork(eigth);
    empty.addArtwork(ninth);
    empty.addArtwork(tenth);
    empty.addArtwork(eleventh);

    // System.out.println(empty.toString());
    // System.out.println(empty.size());
    // System.out.println(empty.lookup("Cane", 1650, 60));


    // lookup root
    //System.out.println();
    if (!empty.lookup("Keep", 1850, 100)) {
      return false;
    }

    // (3) Then, search for an artwork at the right and left subtrees at different levels
    // considering successful and unsuccessful search operations.

    // successful lookups
    if (!empty.lookup("Cane", 1650, 60) && !empty.lookup("Elephant", 1700, 70)
        && !empty.lookup("Hello", 1750, 75) && !empty.lookup("Igloo", 1780, 80)
        && !empty.lookup("Queen", 1900, 220)) {
      return false;
    }
    // lookups that aren't there
    if (empty.lookup("Ava", 2003, 422) && empty.lookup("Kangaroo", 1780, 80)
        && empty.lookup("Elephant", 1900, 70) && empty.lookup("Piano", 2003, 2)) {
      return false;
    }
    
    return true; // Default return statement added to resolve compiler errors
  }

  /**
   * Checks for the correctness of ArtworkGallery.height() method. This test must consider several
   * scenarios such as, (1) ensures that the height of an empty artwork tree is zero. (2) ensures
   * that the height of a tree which consists of only one node is 1. (3) ensures that the height of
   * a ArtworkGallery with the following structure for instance, is 4. (*) / \ (*1) (*2) \ / \ (*3)
   * (*4) (*5) / (*6)
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean testHeight() {

    // (1) ensures that the height of an empty artwork tree is zero.
    ArtGallery empty = new ArtGallery();
    if (empty.height() != 0) {
      return false;
    }

    // (2) ensures that the height of a tree which consists of only one node is 1.
    Artwork root = new Artwork("Keep", 1850, 100);
    empty.addArtwork(root);
    // System.out.println(empty.height());
    if (empty.height() != 1) {
      return false;
    }

    // (3) ensures that the height of a ArtworkGallery with the following structure for instance, is
    // 4.
    Artwork one = new Artwork("Hello", 1750, 75);
    Artwork two = new Artwork("Octopus", 1880, 190);
    Artwork three = new Artwork("Jump", 1800, 90);
    Artwork four = new Artwork("Leopard", 1860, 150);
    Artwork five = new Artwork("Queen", 1900, 220);
    Artwork six = new Artwork("Piano", 1890, 200);
    empty.addArtwork(root);
    empty.addArtwork(one);
    empty.addArtwork(two);
    empty.addArtwork(three);
    empty.addArtwork(four);
    empty.addArtwork(five);
    empty.addArtwork(six);
    if (empty.height() != 4) {
      return false;
    }

    return true;
  }

  /**
   * Checks for the correctness of ArtworkGallery.getBestArtwork() method.
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean testGetBestArtwork() {
    // TODO complete the implementation of this method

    // (1) when root equals null, return null
    ArtGallery empty = new ArtGallery();
    if (empty.getBestArtwork() != null) {
      return false;
    }

    // (2) when there is only one node, return the node back (Artwork object)
    Artwork root = new Artwork("Keep", 1850, 100);
    empty.addArtwork(root);
    if (empty.getBestArtwork() != root) {
      return false;
    }

    // (3) when there is a tree with height 1 and 2 children off node, returns the right child
    Artwork one = new Artwork("Hello", 1750, 75);
    Artwork two = new Artwork("Octopus", 1880, 190);
    empty.addArtwork(one);
    empty.addArtwork(two);
    if (empty.getBestArtwork() != two) {
      return false;
    }

    // (4) when there is a tree with height 3, returns the largest artwork
    Artwork first = new Artwork("Cane", 1650, 60);
    Artwork second = new Artwork("Elephant", 1700, 70);
    Artwork fourth = new Artwork("Igloo", 1780, 80);
    Artwork fifth = new Artwork("Jump", 1800, 90);
    Artwork seventh = new Artwork("Leopard", 1860, 150);
    Artwork eigth = new Artwork("Monster", 1870, 175);
    Artwork tenth = new Artwork("Piano", 1890, 200);
    Artwork eleventh = new Artwork("Queen", 1900, 220);
    empty.addArtwork(fifth);
    empty.addArtwork(seventh);
    empty.addArtwork(fourth);
    empty.addArtwork(second);
    empty.addArtwork(first);
    empty.addArtwork(eigth);
    empty.addArtwork(tenth);
    empty.addArtwork(eleventh);
    if (empty.getBestArtwork() != eleventh) {
      return false;
    }
    return true;
  }


  /**
   * Checks for the correctness of ArtworkGallery.lookupAll() method. This test must consider at
   * least 3 test scenarios. (1) Ensures that the ArtworkGallery.lookupAll() method returns an empty
   * arraylist when called on an empty tree. (2) Ensures that the ArtworkGallery.lookupAll() method
   * returns an array list which contains all the artwork satisfying the search criteria of year and
   * cost, when called on a non empty artwork tree with one match, and two matches and more. Vary
   * your search criteria such that the lookupAll() method must check in left and right subtrees.
   * (3) Ensures that the ArtworkGallery.lookupAll() method returns an empty arraylist when called
   * on a non-empty artwork tree with no search results found.
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean testLookupAll() {
    // TODO complete the implementation of this method
    try {
    // (1) Ensures that the ArtworkGallery.lookupAll() method returns an empty arraylist when called
    // on an empty tree.
    ArtGallery empty = new ArtGallery();
    ArrayList<Artwork> temp = new ArrayList<Artwork>();
    //System.out.println(empty.lookupAll(2003, 45));
    if (empty.lookupAll(2003, 45) != null) {
     return false;
     }

    // (2) Ensures that the ArtworkGallery.lookupAll() method returns an array list which contains
    // all the artwork satisfying the search criteria of year and cost, when called on a non empty
    // artwork tree with one match, and two matches and more. Vary your search criteria such that
    // the lookupAll() method must check in left and right subtrees.
    Artwork root = new Artwork("Keep", 1850, 100);
    Artwork one = new Artwork("Hello", 1750, 75);
    Artwork two = new Artwork("Octopus", 1880, 190);
    empty.addArtwork(root);
    empty.addArtwork(one);
    empty.addArtwork(two);

    // lookupAll - root only
    temp.add(root);
    //System.out.println(temp);
    //System.out.println(empty.lookupAll(1850, 150).toString());
    if(!empty.lookupAll(1850, 150).equals(temp)) {
      System.out.println("h");
      return false;
    }

    // lookupAll - right child of root only
    ArrayList<Artwork> temp2 = new ArrayList<Artwork>();
    temp2.add(two);
    //System.out.println(temp2);
    //System.out.println(empty.lookupAll(1880, 190).toString());
    if(!empty.lookupAll(1880, 190).equals(temp2)) {
      System.out.println("h");
      return false;
    }

    // lookupAll - left child of root only
    ArrayList<Artwork> temp3 = new ArrayList<Artwork>();
    temp3.add(one);
    //System.out.println(temp3);
    //System.out.println(empty.lookupAll(1750, 75).toString());
    if(!empty.lookupAll(1750, 75).equals(temp3)) {
      System.out.println("h");
      return false;
    }

    // lookupAll - 2 values on left subtree
    ArrayList<Artwork> temp4 = new ArrayList<Artwork>();
    Artwork one2 = new Artwork("Apple", 1750, 60);
    empty.addArtwork(one2);
    temp4.add(one);
    temp4.add(one2);
    //System.out.println(temp4);
    //System.out.println(empty.lookupAll(1750, 75).toString());
    if(!empty.lookupAll(1750, 75).equals(temp4)) {
      System.out.println("h");
      return false;
    }

    // lookupAll - 2 values on right subtree
    ArrayList<Artwork> temp5 = new ArrayList<Artwork>();
    Artwork two2 = new Artwork("Pasta", 1880, 170);
    empty.addArtwork(two2);
    temp5.add(two);
    temp5.add(two2);
    //System.out.println(empty.lookupAll(1880, 190).toString());
    if(!empty.lookupAll(1880, 190).equals(temp5)) {
      System.out.println("h");
      return false;
    }

    // lookupAll - 1 value on left subtree and 1 on right subtree
    }catch(NoSuchElementException e) {
      System.out.println("hello");
      return false;
    }

    return true; // Default return statement added to resolve compiler errors
  }

  /**
   * Checks for the correctness of ArtworkGallery.buyArtwork() method. This test must consider at
   * least 3 test scenarios. (1) Buying artwork that is at leaf node (2) Buying artwork at non-leaf
   * node (3) ensures that the ArtworkGallery.buyArtwork() method throws a NoSuchElementException
   * when called on an artwork that is not present in the BST
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean testBuyArtwork() {
    // TODO complete the implementation of this method

    try {
    // (1) Buying artwork that is at leaf node
    Artwork root = new Artwork("Keep", 1850, 100);
    ArtGallery empty = new ArtGallery();
    empty.addArtwork(root);
    empty.buyArtwork("Keep", 1850, 100);
    //System.out.println(one.toString());
    if(!empty.isEmpty()) {
      return false;
    }
    
    //(2) Buying artwork at non-leaf node
    Artwork first = new Artwork("Cane", 1650, 60);
    Artwork second = new Artwork("Elephant", 1700, 70);
    Artwork third = new Artwork("Hello", 1750, 75);
    Artwork fourth = new Artwork("Igloo", 1780, 80);
    Artwork fifth = new Artwork("Jump", 1800, 90);
    Artwork seventh = new Artwork("Leopard", 1860, 150);
    Artwork eigth = new Artwork("Monster", 1870, 175);
    Artwork ninth = new Artwork("Octopus", 1880, 190);
    Artwork tenth = new Artwork("Piano", 1890, 200);
    Artwork eleventh = new Artwork("Queen", 1900, 220);
    empty.addArtwork(root);
    empty.addArtwork(fifth);
    empty.addArtwork(seventh);
    empty.addArtwork(fourth);
    empty.addArtwork(third);
    empty.addArtwork(second);
    empty.addArtwork(first);
    empty.addArtwork(eigth);
    empty.addArtwork(ninth);
    empty.addArtwork(tenth);
    empty.addArtwork(eleventh);
    empty.buyArtwork("Keep", 1850, 100);
    //System.out.println(empty.toString());
    }catch(Exception e) {
      e.printStackTrace();
      return false;
    }

    return true; // Default return statement added to resolve compiler errors
  }

  /**
   * Returns false if any of the tester methods defined in this tester class fails.
   * 
   * @return false if any of the tester methods defined in this tester class fails, and true if all
   *         tests pass
   */
  public static boolean runAllTests() {
    // TODO complete the implementation of this method
    if (testArtworkCompareToEquals() && testAddArtworkToStringSize() && testLookup() && testHeight()
        && testGetBestArtwork() && testLookupAll() && testBuyArtwork()) {
      return true;
    }
    return false;
  }

  /**
   * Calls the test methods
   * 
   * @param args input arguments if any
   */
  public static void main(String[] args) {
    // System.out.println("testArworkCompareToEquals(): " + testArtworkCompareToEquals());
    // System.out.println();
   // System.out.println("testAddArtworkToStringSize(): " + testAddArtworkToStringSize());
    System.out.println("testLookup(): " + testLookup());
    // System.out.println();
    // System.out.println("testHeight(): " + testHeight());
    // System.out.println("testGetBestArtwork(): " + testGetBestArtwork());
    // System.out.println();
    //System.out.println("testLookupAll(): " + testLookupAll());
    System.out.println("testBuyArtwork(): " + testBuyArtwork());
    System.out.println("runAllTests(): " + runAllTests());
  }

}
