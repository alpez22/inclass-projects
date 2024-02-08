//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title: Access Control
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
import java.util.NoSuchElementException;

/**
 * This class demonstrates an access control system where once launched prevents a user from doing
 * anything until they log into the system. This class deals with 3 types of Users: Administrators,
 * Regular Users, and Non-users (all of which have their own properties).
 */
public class AccessControl {

  private static ArrayList<User> users; // An ArrayList of valid users
  private User currentUser; // Who is currently logged in, if anyone?
  private static final String DEFAULT_PASSWORD = "changeme"; // Default password given to new users
                                                             // or when we reset a password of a
                                                             // specific user.

  /**
   * The AccessControl constructor creates a new AccessControl object and checks whether each class
   * variable (static data field) has been initialized and, if not, initializes them.
   */
  public AccessControl() {
    currentUser = null;
    if (users == null) {
      users = new ArrayList<User>();
      User user1 = new User("admin", "root", true);
      users.add(0, user1);
    }
  }

  /**
   * Reports whether a given username/password pair is a valid login
   *
   * @param username name of the user
   * @param password password of user
   * @return A boolean representation whether a given username/password pair is a valid login.
   *         should return true if the username/password pair matched any user in your users
   *         ArrayList and false otherwise
   */
  public static boolean isValidLogin(String username, String password) {

    for (int i = 0; i < users.size(); i++) {
      if (users.get(i) != null) {
        if (users.get(i).getUsername().equals(username)
            && users.get(i).isValidLogin(password) == true) {
          return true;
        }
      }
    }
    return false;
  }

  /**
   * Reports whether a given username is within the system.
   *
   * @param username name of the user
   * @return A boolean representation whether a given username is within the system. should return
   *         true if the username matched any user in your users ArrayList and false otherwise
   */
  public static boolean isValidUsername(String username) {
    for (int i = 0; i < users.size(); i++) {
      if (users.get(i) != null) {
        if (users.get(i).getUsername().equals(username) == true) {
          return true;
        }
      }
    }
    return false;
  }

  /**
   * Change the current password of the current user.
   *
   * @param newPassword new password after changing password
   */
  public void changePassword(String newPassword) {
    currentUser.setPassword(newPassword);
  }

  /**
   * Log out the current user.
   */
  public void logout() {
    currentUser = null;
  }

  /**
   * A mutator that you can use to write tests without simulating user input. It sets the current
   * user to the user from the users list whose username matches the string provided as input to the
   * method (exact match case sensitive).
   *
   * @param username name of user
   */
  public void setCurrentUser(String username) {
    for (int i = 0; i < users.size(); i++) {
      if (users.get(i) != null) {
        if (users.get(i).getUsername().equals(username)) {
          currentUser = users.get(i);
        }
      }
    }
  }

  /**
   * Create a new user (non-admin) with the default password and isAdmin==false and add it to the
   * users ArrayList.
   *
   * @param username name of user
   * @return A boolean representation whether the current user has Admin power and the new user was
   *         successfully added (returning true) or if the the current user is null or does not have
   *         Admin power (returning false)
   * @throws IllegalArgumentException with descriptive error message if username is null or if its
   *                                  length is less than 5 ( < 5), or if a user with the same
   *                                  username is already in the list of users
   */
  public boolean addUser(String username) {

    if (username == null || username.length() < 5 || isValidUsername(username) == true) {
      throw new IllegalArgumentException(
          "addUser(username) method has thrown an illegal argument exception: either username "
          + "entered is "
              + "null, the username is not long enough (<5) or the username and password already"
              + " exists in the system");
    } else if (currentUser == null || currentUser.getIsAdmin() == false) {
      return false;
    }
    boolean hasAdminPower = false;
    User newUser = new User(username, DEFAULT_PASSWORD, hasAdminPower);
    users.add(newUser);

    return true;
  }

  /**
   * Create a new user, specify their admin status, and add it to the list of users.
   *
   * @param username name of the user
   * @param isAdmin  admin status
   * @return A boolean representation whether the current user has Admin power and the new user was
   *         successfully added (returning true) or if the the current user is null or does not have
   *         Admin power (returning false)
   * @throws IllegalArgumentException with descriptive error message if username is null or if its
   *                                  length is less than 5 ( < 5), or if a user with the same
   *                                  username is already in the list of users
   */
  public boolean addUser(String username, boolean isAdmin) {

    if (username == null || username.length() < 5 || isValidUsername(username) == true) {
      throw new IllegalArgumentException(
          "addUser(username, isAdmin) method has thrown an illegal argument exception: either "
          + "username entered is "
              + "null, the username is not long enough (<5) or the username and password already"
              + " exist in the system");
    } else if (isAdmin == false || currentUser == null) {
      return false;
    }

    User newUser = new User(username, DEFAULT_PASSWORD, isAdmin);
    users.add(newUser);

    return true;
  }

  /**
   * Remove a user given their unique username.
   *
   * @param username name of the user
   * @return A boolean representation whether the current user has Admin power and the user whose
   *         username is passed as input was successfully removed (returning true) or if the the
   *         current user is null or does not have Admin power (returning false)
   * @throws NoSuchElementException with a descriptive error message if no match with username is
   *                                found in the list of users
   */
  public boolean removeUser(String username) {

    if (currentUser == null || !currentUser.getIsAdmin()) {
      return false;
    }

    if (isValidUsername(username) == false) {
      throw new NoSuchElementException(
          "removeUser(username) method has thrown a no such element exception: no match with "
          + "username is found in the list of users");
    } else {
      for (int i = 0; i < users.size(); i++) {
        if (users.get(i).getUsername().equals(username)) {
          users.remove(i);
          return true;
        }
      }
    }
    return false;
  }

  /**
   * Gives a user admin power.
   *
   * @param username name of the user
   * @return A boolean representation whether this operation terminates successfully (returning
   *         true) or if the the current user is null or does not have Admin power (returning false)
   * @throws NoSuchElementException with a descriptive error message if no match with username is
   *                                found in the list of users
   */
  public boolean giveAdmin(String username) {

    if (currentUser == null || !currentUser.getIsAdmin()) {
      return false;
    }

    if (isValidUsername(username) == false) {
      throw new NoSuchElementException(
          "giveAdmin(username) method has thrown a no such element exception: no match with "
          + "username is found in the list of users");
    } else {
      for (int i = 0; i < users.size(); i++) {
        if (users.get(i).getUsername().equals(username)) {
          users.get(i).setIsAdmin(true);
          return true;
        }
      }
    }
    return false;
  }

  /**
   * Removes the admin power of a user given their username
   *
   * @param username name of the user
   * @return A boolean representation whether this operation terminates successfully (returning
   *         true) or if the the current user is null or does not have Admin power (returning false)
   * @throws NoSuchElementException with a descriptive error message if no match with username is
   *                                found in the list of users
   */
  public boolean takeAdmin(String username) {

    if (currentUser == null || !currentUser.getIsAdmin()) {
      return false;
    }

    if (isValidUsername(username) == false) {
      throw new NoSuchElementException(
          "takeAdmin(usernam) method has thrown a no such element exception: no match with "
          + "username is found in the list of users");
    } else {
      for (int i = 0; i < users.size(); i++) {
        if (users.get(i).getUsername().equals(username)) {
          users.get(i).setIsAdmin(false);
          return true;
        }
      }
    }
    return false;
  }

  /**
   * Resets the password of a user given their username
   *
   * @param username name of the user
   * @return A boolean representation whether this operation terminates successfully (returning
   *         true) or if the the current user is null or does not have Admin power (returning false)
   * @throws NoSuchElementException with a descriptive error message if no match with username is
   *                                found in the list of users
   */
  public boolean resetPassword(String username) {

    if (currentUser == null || !currentUser.getIsAdmin()) {
      return false;
    }

    if (isValidUsername(username) == false) {
      throw new NoSuchElementException(
          "resetPassword(usernam) method has thrown a no such element exception: no match with "
          + "username is found in the list of users");
    } else {
      for (int i = 0; i < users.size(); i++) {
        if (users.get(i).getUsername().equals(username)) {
          users.get(i).setPassword(DEFAULT_PASSWORD);
          return true;
        }
      }
    }
    return false;
  }
}
