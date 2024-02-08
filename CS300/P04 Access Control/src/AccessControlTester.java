//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title: Access Control Tester
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
import java.util.ArrayList;

/**
 * This class tests the code for the Access Control class
 */
public class AccessControlTester {

  public static void main(String[] args) {
    System.out.println(runAllTests());
  }

  /**
   * Checks for the correctness of the constructor, and all the accessor and mutator methods defined
   * in the User class
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean testUserConstructorAndMethods() {

    String username1 = "ava.pezza";
    String password1 = "abcd";
    boolean isAdmin = true;
    User user1 = new User(username1, password1, isAdmin); // creating an reference to User class

    // testing getUsername method in User
    String expectedAccessorUser = "ava.pezza";
    if (user1.getUsername() != expectedAccessorUser) {
      return false;
    }

    // testing getIsAdmin method in User
    boolean expectedAccessorIsAdmin = true;
    if (user1.getIsAdmin() != expectedAccessorIsAdmin) {
      return false;
    }

    // testing setPassword method and isValidLogin method in User
    String newPassword = "ele";
    user1.setPassword(newPassword);
    if (user1.isValidLogin(newPassword) == false) {
      return false;
    }

    // testing setIsAdmin method in User
    boolean newIsAdmin = false;
    user1.setIsAdmin(newIsAdmin);
    if (user1.getIsAdmin() != newIsAdmin) {
      return false;
    }

    return true;
  }

  /**
   * Checks the correctness of AccessControl.isValidLogin() method when called with incorrect
   * username or not matching (username, password) pair
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean testAccessControlIsValidLoginNotValidUser() {
    // incorrect username
    AccessControl ac = new AccessControl();
    boolean expected = false;
    if (AccessControl.isValidLogin("admi", "root") != expected) {
      return false;
    }

    // not matching username password pair
    if (AccessControl.isValidLogin("admin", "roo") != expected) {
      return false;
    }

    return true;
  }

  /**
   * Creates a new AccessControl object and does not log in an admin. This test must fail if
   * addUser(String username) does not return false or if a user was added to the list of user after
   * the method returns.
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean testAddUserWithNoAdminPowers() {
    AccessControl ac = new AccessControl();
    boolean addUserTest = ac.addUser("ava.pezza"); // should be false
    boolean expected = false;

    if (addUserTest != expected || AccessControl.isValidUsername("ava.pezza") != expected) {
      return false;
    }

    return true;
  }

  /**
   * Checks the correctness of addUser and removeUser methods when the current user has admin powers
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean testAddRemoveUserWithAdminPowers() {
    AccessControl ac = new AccessControl();
    // addUser test
    String username = "hellooo";

    boolean expected = true;
    ac.addUser(username, true);
    ac.setCurrentUser("admin");

    if (ac.addUser(username, true) != expected) {
      return false;
    }

    // removeUser test
    if (ac.removeUser("hellooo") != expected) {
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
    if (testUserConstructorAndMethods() && testAccessControlIsValidLoginNotValidUser()
        && testAddUserWithNoAdminPowers() && testAddRemoveUserWithAdminPowers() == false) {
      return false;
    }
    return true;
  }
}
