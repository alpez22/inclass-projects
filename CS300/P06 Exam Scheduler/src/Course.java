//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title: Exam Scheduler - Course
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
 * This class provided the attributes to Course
 */
public class Course {

  private String name;// "CS300"
  private int numStudents; // 250

  /**
   * Creates a new Course with a given course name and given num of students
   * 
   * @param name        name of course
   * @param numStudents num of students in course
   */
  public Course(String name, int numStudents) {
    this.name = name;
    this.numStudents = numStudents;
    if (this.numStudents < 0) {
      throw new IllegalArgumentException("Error: number of students entered is not a valid amount");
    }
  }

  /**
   * Gets the name of the course
   *
   * @return the name of the course
   */
  public String getName() {
    return this.name;
  }

  /**
   * Gets the num of students in course
   *
   * @return the num of students in course
   */
  public int getNumStudents() {
    return this.numStudents;
  }
}
