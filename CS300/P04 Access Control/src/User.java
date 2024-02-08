//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title: User
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

/**
 * This class contains all of the accessor and mutator methods (properties) that a User posesses
 */
public class User {

  private String password; // The password of the user
  private Boolean isAdmin; // Whether or not the user has Admin powers
  private final String USERNAME; // The name of the user

  /**
   * Creates a new user with the given password and admin status (constructor method)
   *
   * @param username  username of new user
   * @param passoword password of the new user
   * @param isAdmin   isAdmin provides the status of the user as an admin or not as an admin
   */
  public User(String username, String password, boolean isAdmin) {
    this.password = password;
    this.isAdmin = isAdmin;
    this.USERNAME = username;

  }

  /**
   * Report whether the password is correct
   *
   * @param password password inputted to see if password is correct
   * @return A boolean representation of if the login has or doesn't have a valid/correct password
   */
  public boolean isValidLogin(String password) {
    if (password != this.password) {
      return false;
    }
    return true;
  }

  /**
   * Return the name of the user (accessor program)
   *
   * @return A string representation of the name of the user
   */
  public String getUsername() {
    return USERNAME;
  }

  /**
   * Report whether the user is an admin (accessor program)
   *
   * @return A boolean representation of if the user is an admin
   */
  public boolean getIsAdmin() {
    if (isAdmin != true) {
      return false;
    }
    return true;
  }

  /**
   * Set the new password (mutator program)
   *
   * @param password password inputed as the new set password
   */
  public void setPassword(String password) {
    this.password = password;
  }

  /**
   * Set the new admin status (mutator program)
   *
   * @param isAdmin isAdmin shows if the user is or is not an admin
   */
  public void setIsAdmin(boolean isAdmin) {
    this.isAdmin = isAdmin;
  }
}
