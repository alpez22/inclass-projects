//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title: OpenPosition
// Course: CS 300 Spring 2022
//
///////////////////////// ALWAYS CREDIT OUTSIDE HELP //////////////////////////
//
// Persons: NONE
// Online Sources: NONE
//
///////////////////////////////////////////////////////////////////////////////


/**
 * @author Ava Pezza
 *
 *         A application handler of an open position using priority queue. Only saves a new
 *         Application when the queue is not full, or when it can replace older, lower-scored ones
 *         with its higher scores.
 */
public class OpenPosition {
  private String positionName;
  private ApplicationQueue applications; // the priority queue of all applications
  private int capacity; // the number of vacancies

  /**
   * Creates a new open position with the given capacity
   *
   * @param capacity the number of vacancies of this position
   * @throws IllegalArgumentException with a descriptive error message if the capacity is not a
   *                                  positive integer
   */
  public OpenPosition(String positionName, int capacity) {
    if (capacity <= 0)
      throw new IllegalArgumentException("Capacity is not a positive integer!");

    this.positionName = positionName;
    this.capacity = capacity;
    this.applications = new ApplicationQueue(this.capacity);
  }

  /**
   * Returns the position name
   *
   * @return the position name
   */
  public String getPositionName() {
    return this.positionName;
  }

  /**
   * Tries to add the given Application to the priority queue of this position. Return False when
   * the new Application has a lower score than the lowest-scored Application in the queue.
   *
   * @return Whether the given Application was added successfully
   */
  public boolean add(Application application) {
    try {
      this.applications.enqueue(application);
      return true;
    } catch (NullPointerException e) {
      return false;
    } catch (IllegalStateException e) {
    }

    int lowestScore = Integer.MAX_VALUE;

    scoreVerifier: for (final Application app : this.applications)
      lowestScore = Math.min(app.getScore(), lowestScore);

    if (lowestScore >= application.getScore())
      return false;

    applications.dequeue();
    applications.enqueue(application);

    return true;
  }

  /**
   * Returns the list of Applications in the priority queue.
   *
   * @return The list of Applications in the priority queue, in increasing order of the scores.
   */
  public String getApplications() {
    return applications.toString();
  }

  /**
   * Returns the total score of Applications in the priority queue.
   *
   * @return The total score of Applications in the priority queue.
   */
  public int getTotalScore() {
    int totalScore = 0;

    sumScores: for (final Application application : this.applications)
      totalScore += application.getScore();

    return totalScore;
  }
}
