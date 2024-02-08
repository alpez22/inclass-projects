//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title: Exam Scheduler - Schedule
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

/**
 * This class provided the attributes to Schedule
 */
public class Schedule {

  private Room[] rooms; // array of the Room objects available for the exam
  private Course[] courses; // array of the Course objects which require exam rooms
  private int[] assignments; // an array where the integer at index N is the index of the room that
                             // course[N] has been assigned to

  /**
   * Creates a new Schedule with a given room object and given course object and an assignments
   * array that is empty
   * 
   * @param rooms   array of the room objects available for the exam
   * @param courses array of the course objects which require exam rooms
   */
  public Schedule(Room[] rooms, Course[] courses) {
    this.rooms = rooms;
    this.courses = courses;
    assignments = new int[courses.length];
    Arrays.fill(this.assignments, -1);
  }

  /**
   * Creates a new Schedule with a given room object and given course object and an assignments
   * array that is given
   * 
   * @param rooms       array of the room objects available for the exam
   * @param courses     array of the course objects which require exam rooms
   * @param assignments array of ints that represent the rooms that the courses are assigned to
   */
  private Schedule(Room[] rooms, Course[] courses, int[] assignments) {
    this.rooms = rooms;
    this.courses = courses;
    this.assignments = assignments;
  }

  /**
   * Gets the number of rooms available
   *
   * @return the number of rooms
   */
  public int getNumRooms() {
    return this.rooms.length;
  }

  /**
   * Gets the room object at the given index
   *
   * @param index index within the room object
   * @return the room object at the given index
   * @throws IndexOutOfBoundsException with a descriptive error message if room index entered is not
   *                                   a valid amount
   */
  public Room getRoom(int index) {
    if (index >= getNumRooms()) {
      throw new IndexOutOfBoundsException("Error: room index entered is not a valid amount");
    }
    return this.rooms[index];
  }

  /**
   * Gets the number of courses available
   *
   * @return the number of courses
   */
  public int getNumCourses() {
    return this.courses.length;
  }

  /**
   * Gets the course object at the given index
   *
   * @param index index within the course object
   * @return the course object at the given index
   * @throws IndexOutOfBoundsException with a descriptive error message if course index entered is
   *                                   not a valid amount
   */
  public Course getCourse(int index) {

    if (index < getNumCourses() && index >= 0) {
      return this.courses[index];
    } else {
      throw new IndexOutOfBoundsException("Error: course index entered is not a valid amount");
    }
  }

  /**
   * tells whether the course at the given index is assigned to a room or not
   *
   * @param index index of the course
   * @return true if the course is assigned to a room and false if the course is not assigned to a
   *         room
   */
  public boolean isAssigned(int index) {

    if (this.assignments[index] != -1 && index < getNumCourses() && index >= 0) {
      return true;
    }
    return false;
  }

  /**
   * Gets the room assignment of the course if it is assigned and the index is valid
   * 
   * @param index index of the course
   * @return the room object that is assigned to the course at the given index
   * @throws IllegalArgumentException  with a descriptive error message if course has not been
   *                                   assigned a room
   * @throws IndexOutOfBoundsException with a descriptive error message if course index entered is
   *                                   not a valid amount
   */
  public Room getAssignment(int index) {

    if (index < 0 || index > this.assignments.length - 1) {
      throw new IndexOutOfBoundsException("Error: course index entered is not a valid amount");
    }
    if (isAssigned(index) == false) {
      throw new IllegalArgumentException("Error: course has not been assigned a room");
    }
    return this.rooms[this.assignments[index]];
  }

  /**
   * Iterates though the course array to see if all courses have been assigned to a room
   *
   * @return true if all the courses are assigned to a room, false otherwise
   */
  public boolean isComplete() {
    for (int i = 0; i < this.courses.length; i++) {
      if (!isAssigned(i)) {
        return false;
      }
    }
    return true;
  }

  /**
   * Assigns a course at the given index to a room at the given index
   *
   * @param courseIndex index of the course wanting to be assigned
   * @param roomIndex   index of the room that is getting assigned to a course
   * @return the new schedule object that has the new assignment call
   * @throws IndexOutOfBoundsException with a descriptive error message if room index entered is not
   *                                   a valid amount or if course index entered is not a valid
   *                                   amount
   * @throws IllegalArgumentException  with a descriptive error message if the given course has
   *                                   already been assigned a room or if the given room does NOT
   *                                   have sufficient capacity
   */
  public Schedule assignCourse(int courseIndex, int roomIndex) {
    Room[] roomsCopy = Arrays.copyOf(this.rooms, this.rooms.length);
    Course[] coursesCopy = Arrays.copyOf(this.courses, this.courses.length);
    int[] assignmentsCopy = Arrays.copyOf(this.assignments, this.assignments.length);

    if (roomIndex >= getNumRooms()) {
      throw new IndexOutOfBoundsException("Error: room index entered is not a valid amount");
    }
    if (courseIndex >= getNumCourses()) {
      throw new IndexOutOfBoundsException("Error: course index entered is not a valid amount");
    }
    if (isAssigned(courseIndex) == true) {
      throw new IllegalArgumentException(
          "Error: the given course has already been assigned a room");
    }
    if (rooms[roomIndex].getCapacity() < courses[courseIndex].getNumStudents()) {
      throw new IllegalArgumentException("Error: the given room does NOT have sufficient capacity");
    }

    assignmentsCopy[courseIndex] = roomIndex;

    int capacity = coursesCopy[courseIndex].getNumStudents();
    roomsCopy[roomIndex] = roomsCopy[roomIndex].reduceCapacity(capacity);

    Schedule object = new Schedule(roomsCopy, this.courses, assignmentsCopy);

    return object;
  }

  /**
   * creates a string representation of the schedule when this method is called
   *
   * @return the string representation of the schedule
   */
  @Override
  public String toString() {
    String output = "{";
    for (int i = 0; i < courses.length; i++) {
      if (isAssigned(i)) {
        if (i == courses.length - 1) {
          output += courses[i].getName() + ": " + rooms[assignments[i]].getLocation() + "}";
        } else {
          output += courses[i].getName() + ": " + rooms[assignments[i]].getLocation() + ", ";
        }
      } else {
        if (i == courses.length - 1) {
          output += courses[i].getName() + ": " + "Unassigned" + "}";
        } else {
          output += courses[i].getName() + ": " + "Unassigned" + ", ";
        }
      }
    }
    return output;
  }
}
