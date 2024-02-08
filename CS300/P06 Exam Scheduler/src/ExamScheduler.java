//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title: Exam Scheduler - ExamScheduler
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
 * This class provided the attributes to Exam Scheduler
 */
public class ExamScheduler {

  /**
   * Public method used to find a valid schedule for the given rooms and courses
   *
   * @return a valid Schedule for the given set of rooms and courses
   */
  public static Schedule findSchedule(Room[] rooms, Course[] courses) {
    Schedule schedule = new Schedule(rooms, courses);
    return findScheduleHelper(schedule, 0);
  }

  /**
   * A private recursive method that assigns all unassigned courses in a Schedule beginning from the
   * index provided as an argument
   *
   * @param schedule1 schedule with the list of rooms and courses available
   * @param index1    index where to start assigning courses
   * @return the resulting schedule
   * @throws IllegalStateException if the schedule is invalid
   */
  private static Schedule findScheduleHelper(Schedule schedule1, int index1) {

    if (index1 == schedule1.getNumCourses()) {
      if (schedule1.isComplete()) {
        return schedule1;
      } else {
        throw new IllegalStateException("schedule is invalid");
      }
    }
    if (schedule1.isAssigned(index1)) {
      // recursively assign the courses at the following indexes and return the resulting schedule
      index1++;
      return findScheduleHelper(schedule1, index1);
    } else {
      // iteratively try to assign it to each possible valid Room and recursively assign the courses
      // at the following indexes
      for (int i = 0; i < schedule1.getNumRooms(); i++) {
        try {
          Schedule schedule2 = schedule1.assignCourse(index1, i);
          try {
            Schedule schedule3 = findScheduleHelper(schedule2, index1 + 1);
            return findScheduleHelper(schedule3, index1 + 1);
          } catch (IllegalStateException e) {
            continue;
          }
        } catch (IllegalArgumentException e) {
          continue;
        }
      }
    }
    return findScheduleHelper(schedule1, index1 + 1);
  }

  /**
   * Public method used to find all valid schedules for the given rooms and courses
   *
   * @return an ArrayList containing all possible Schedules for the given set of rooms and courses.
   *         (If none can be created, this ArrayList is empty.)
   */
  public static ArrayList<Schedule> findAllSchedules(Room[] rooms, Course[] courses) {
    Schedule scheduleAll = new Schedule(rooms, courses);
    return findAllSchedulesHelper(scheduleAll, 0);
  }

  /**
   * a private, recursive method that assigns all unassigned courses in a Schedule in ALL POSSIBLE
   * ways, beginning from the index provided as an argument
   *
   * @param inputSchedule    schedule with the list of rooms and courses available
   * @param inputCourseIndex index where to start assigning courses
   * @return an array list of all schedules
   */
  private static ArrayList<Schedule> findAllSchedulesHelper(Schedule inputSchedule,
      int inputCourseIndex) {

    ArrayList<Schedule> schedulesCreated = new ArrayList<>();
    if (inputCourseIndex == inputSchedule.getNumCourses()) {
      if (inputSchedule.isComplete()) {
        schedulesCreated.add(inputSchedule);
        return schedulesCreated;
      }
    }
    if (inputSchedule.isAssigned(inputCourseIndex)) {
      inputCourseIndex++;
      schedulesCreated.addAll(findAllSchedulesHelper(inputSchedule, inputCourseIndex));
      return schedulesCreated;
    } else {
      for (int i = 0; i < inputSchedule.getNumRooms(); i++) {
        try {
          Schedule schedule2 = inputSchedule.assignCourse(inputCourseIndex, i);
          schedulesCreated.addAll(findAllSchedulesHelper(schedule2, (inputCourseIndex + 1)));
        } catch (IllegalArgumentException e) {
          continue;
        }
      }
    }
    return schedulesCreated;
  }
}
