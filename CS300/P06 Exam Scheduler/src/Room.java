//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title: Exam Scheduler - Room
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
 * This class provided the attributes to Room
 */
public class Room {

  private String location; // building + room number "Noland 168"
  private int capacity; // max number of people in room at a time

  /**
   * Creates a new Room with a given room location and given capacity of seats
   * 
   * @param location location name of room
   * @param capacity num of students allowed in room
   * @throws IllegalArgumentException with a descriptive error message if the capacity int entered
   *                                  is not a valid amount
   */
  public Room(String location, int capacity) {
    this.location = location;
    this.capacity = capacity;

    if (this.capacity < 0) {
      throw new IllegalArgumentException("Error: capacity int entered is not a valid amount");
    }
  }

  /**
   * Gets the location of the room
   *
   * @return the location of the room
   */
  public String getLocation() {
    return this.location;
  }

  /**
   * Gets the capacity of the room
   *
   * @return the capacity of the room
   */
  public int getCapacity() {
    return this.capacity;
  }

  /**
   * By calling this method the capacity within the room will be reduced by the inputted amount
   *
   * @param reduceBy number that the capacity must be reduced by
   * @return the room object after it is reduced
   */
  public Room reduceCapacity(int reduceBy) {
    if (reduceBy > this.capacity) {
      throw new IllegalArgumentException("Error: CANNOT reduce the capacity to a negative number");
    }
    Room object1 = new Room(this.location, this.capacity - reduceBy);
    return object1;
  }
}
