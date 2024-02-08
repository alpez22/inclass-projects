//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title: Exam Scheduler - Exam Scheduler Tester
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
 * This class provides the tests for each class
 */
public class ExamSchedulerTester {

  /**
   * Main method used to run test methods
   * 
   * @param args input arguments if any
   */
  public static void main(String[] args) {
    // TODO Auto-generated method stub
    System.out.println("testCourse() " + testCourse());
    System.out.println("testRoom() " + testRoom());
    System.out.println("testScheduleAccessor() " + testScheduleAccessor());
    System.out.println("testAssignCourse() " + testAssignCourse());
    System.out.println("testFindAllSchedules() " + testFindAllSchedules());
    System.out.println("testFindSchedule() " + testFindSchedule());
  }

  /**
   * Verifies that the constructor and methods work properly and any relevant exceptions are thrown
   * for the class Course
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean testCourse() {

    // test getName()
    Course c = new Course("CS200", 65);
    if (!c.getName().equals("CS200")) {
      return false;
    }

    // test getNumStudents()
    if (c.getNumStudents() != 65) {
      return false;
    }

    return true;
  }

  /**
   * Verifies that the constructor and methods work properly and any relevant exceptions are thrown
   * for the class Room
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean testRoom() {

    try {
      Room r = new Room("hello 343", 10);
      r = r.reduceCapacity(3);
      int expected = 7;
      if (r.getCapacity() != expected) {
        System.out.println(r.getCapacity());
        return false;
      }
    } catch (IllegalArgumentException e) {
      e.getMessage();
    } catch (Exception e) {
      e.getMessage();
    }

    try {
      Room r = new Room("brooo 777", 20);
      r = r.reduceCapacity(10);
      int expected = 10;
      if (r.getCapacity() != expected) {
        return false;
      }
    } catch (IllegalArgumentException e) {
      e.getMessage();
    } catch (Exception e) {
      e.getMessage();
    }

    try {
      Room r = new Room("brooo 777", 20);
      r = r.reduceCapacity(21);
      return false; // if an illegal argument exception is NOT thrown this will print
    } catch (IllegalArgumentException e) {
      e.getMessage();
    } catch (Exception e) {
      e.getMessage();
    }

    return true;
  }

  /**
   * Verifies that the constructor and methods work properly and any relevant exceptions are thrown
   * for the class Schedule
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean testScheduleAccessor() {
    Room r1 = new Room("AG 150", 200);
    Room r2 = new Room("CS 1240", 180);
    Course c1 = new Course("CS300", 20);
    Course c2 = new Course("CS400", 75);
    Course c3 = new Course("CS200", 30);
    Room[] rooms1 = new Room[] {r1, r2};
    Course[] courses1 = new Course[] {c1, c2, c3};
    Schedule schedule1 = new Schedule(rooms1, courses1);
    int[] assignments = new int[] {1, 0, -1};

    // test getNumRooms
    int expected = 2;
    if (schedule1.getNumRooms() != expected) {
      System.out.println("1");
      return false;
    }

    // test getRoom(index)
    if (schedule1.getRoom(1) != r2 && schedule1.getRoom(0) != r1) {
      return false;
    }

    // test getNumCourses()
    expected = 3;
    if (schedule1.getNumCourses() != expected) {
      return false;
    }

    // test getCourse(index)
    if (schedule1.getCourse(1) != c2) {
      return false;
    }

    // test isAssigned(index)
    if (schedule1.isAssigned(0) != true && schedule1.isAssigned(2) != false) {
      return false;
    }

    // test isComplete
    if (schedule1.isComplete() == true) {
      return false;
    }

    return true;
  }

  /**
   * Verifies that the method assignCourse within the schedule class works as intended
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean testAssignCourse() {
    Room r1 = new Room("SCI 180", 120);
    Room r2 = new Room("HUM 3650", 120);
    Room r3 = new Room("AG 125", 120);
    Course c1 = new Course("CS300", 20);
    Course c2 = new Course("CS200", 20);
    Course c3 = new Course("CS400", 20);
    Room[] rooms1 = new Room[] {r1, r2, r3};
    Course[] courses1 = new Course[] {c1, c2, c3};
    Schedule schedule1 = new Schedule(rooms1, courses1);

    // int[] assignments = new int[] {2, 1, -1};
    try {
      schedule1 = schedule1.assignCourse(0, 2);
      schedule1 = schedule1.assignCourse(1, 1);

      /**
       * if(!schedule1.getAssignment(0).equals(r3) && !schedule1.getAssignment(1).equals(r2) &&
       * !schedule1.isAssigned(2)) { System.out.println(schedule1.toString());
       * System.out.println(schedule1.getRoom(0).getCapacity());
       * System.out.println(schedule1.getRoom(1).getCapacity());
       * System.out.println(schedule1.getRoom(2).getCapacity()); return false; }
       */
    } catch (IndexOutOfBoundsException e) {
      e.getMessage();
    } catch (IllegalArgumentException e) {
      e.getMessage();
    }
    // System.out.println(schedule1.toString());
    // System.out.println(schedule1.getRoom(0).getCapacity());
    // System.out.println(schedule1.getRoom(1).getCapacity());
    // System.out.println(schedule1.getRoom(2).getCapacity());
    String scheduleString = schedule1.toString();
    String expected = "{CS300: AG 125, CS200: HUM 3650, CS400: Unassigned}/n";
    if (scheduleString.equals(expected)) {
      System.out.println(schedule1.toString());
      return false;
    }
    // System.out.println(schedule1.toString());

    return true;
  }

  /**
   * Verify that the primary, public methods produce the results you expect for FindAllSchedules in
   * ExamSchedule class
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean testFindAllSchedules() {
    Room r1 = new Room("Room1", 100);
    Room r2 = new Room("Room2", 150);
    Room r3 = new Room("Room3", 75);
    Course c1 = new Course("CS200", 50);
    Course c2 = new Course("CS300", 110);
    Course c3 = new Course("CS400", 75);
    Room[] rooms1 = new Room[] {r1, r2, r3};
    Course[] courses1 = new Course[] {c1, c2, c3};
    // Schedule schedule1 = new Schedule(rooms1, courses1);

    try {
      System.out.println(ExamScheduler.findAllSchedules(rooms1, courses1).toString());
      ExamScheduler.findAllSchedules(rooms1, courses1);
    } catch (Exception e) {
      e.getMessage();
      return false;
    }

    return true;
  }

  /**
   * Verify that the primary, public methods produce the results you expect for findSchedule in
   * ExamSchedule class
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean testFindSchedule() {

    Room r1 = new Room("Room1", 100);
    Room r2 = new Room("Room2", 150);
    Room r3 = new Room("Room3", 75);
    Course c1 = new Course("CS200", 50);
    Course c2 = new Course("CS300", 110);
    Course c3 = new Course("CS400", 75);
    Room[] rooms1 = new Room[] {r1, r2, r3};
    Course[] courses1 = new Course[] {c1, c2, c3};
    // Schedule schedule1 = new Schedule(rooms1, courses1);

    try {
      // System.out.println(ExamScheduler.findSchedule(rooms1, courses1).toString());
      ExamScheduler.findSchedule(rooms1, courses1);
    } catch (Exception e) {
      e.getMessage();
      return false;
    }

    return true;
  }
}
