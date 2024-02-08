//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title:    OpenPositionTester
// Course:   CS 300 Spring 2022
//
///////////////////////// ALWAYS CREDIT OUTSIDE HELP //////////////////////////
//
// Persons:         NONE
// Online Sources:  NONE
//
///////////////////////////////////////////////////////////////////////////////


import java.util.NoSuchElementException;

/**
 * @author Ava Pezza
 *
 * This class implements unit test methods to check the correctness of Application, 
 * ApplicationIterator, ApplicationQueue and OpenPosition classes in the assignment.
 *
 */
public class OpenPositionTester {

  /**
   * This method tests and makes use of the Application constructor, getter methods,
   * toString() and compareTo() methods.
   *
   * @return true when this test verifies the functionality, and false otherwise
   */
  public static final boolean testApplication() {
    System.out.println("Testing Application...");
    boolean error = false;

    // 1. Create an Application with valid input
    try {
      final String validName = "Application";
      final String validEmail = "email@email.email";
      final int validScore = ((int)(Math.random() * 101));

      final Application validApplication = new Application(validName, validEmail, validScore);
    }
    catch (Exception e) {
      System.out.println("1. Unexpected Error Occured!");
      e.printStackTrace();
      error = true;
    }

    // 2. Create an Application with invalid input:
    // 2.a Blank name
    try {
      final String invalidName = "   ";
      final String validEmail = "email@email.email";
      final int validScore = ((int)(Math.random() * 101));

      final Application invalidApplication = new Application(invalidName, validEmail, validScore);
      System.out.println("2.a Application's Constructor FAILED! Expected IllegalArgumentException");
      error = true;
    }
    catch (IllegalArgumentException e) {}
    catch (Exception e) {
      System.out.println("2.a Unexpected Error Occured!");
      e.printStackTrace();
      error = true;
    }

    // 2.b Null email
    try {
      final String validName = "Application";
      final String invalidEmail = null;
      final int validScore = ((int)(Math.random() * 101));

      final Application invalidApplication = new Application(validName, invalidEmail, validScore);
      System.out.println("2.b Application's Constructor FAILED! Expected IllegalArgumentException");
      error = true;
    }
    catch (IllegalArgumentException e) {}
    catch (Exception e) {
      System.out.println("2.b Unexpected Error Occured!");
      e.printStackTrace();
      error = true;
    }

    // 2.c No @ email
    try {
      final String validName = "Application";
      final String invalidEmail = "email_email.email";
      final int validScore = ((int)(Math.random() * 101));

      final Application invalidApplication = new Application(validName, invalidEmail, validScore);
      System.out.println("2.c Application's Constructor FAILED! Expected IllegalArgumentException");
      error = true;
    }
    catch (IllegalArgumentException e) {}
    catch (Exception e) {
      System.out.println("2.c Unexpected Error Occured!");
      e.printStackTrace();
      error = true;
    }

    // 2.d Too many @ email
    try {
      final String validName = "Application";
      final String invalidEmail = "email@email@email";
      final int validScore = ((int)(Math.random() * 101));

      final Application invalidApplication = new Application(validName, invalidEmail, validScore);
      System.out.println("2.d Application's Constructor FAILED! Expected IllegalArgumentException");
      error = true;
    }
    catch (IllegalArgumentException e) {}
    catch (Exception e) {
      System.out.println("2.d Unexpected Error Occured!");
      e.printStackTrace();
      error = true;
    }

    // 2.e Invalid score
    try {
      final String validName = "Application";
      final String validEmail = "email@email.email";
      final int invalidScore = 101;

      final Application invalidApplication = new Application(validName, validEmail, invalidScore);
      System.out.println("2.e Application's Constructor FAILED! Expected IllegalArgumentException");
      error = true;
    }
    catch (IllegalArgumentException e) {}
    catch (Exception e) {
      System.out.println("2.e Unexpected Error Occured!");
      e.printStackTrace();
      error = true;
    }


    // 3. Verify getters
    try {
      final String name = "Application";
      final String email = "email@email.email";
      final int score = ((int) (Math.random() * 101));

      final Application application = new Application(name, email, score);

      final String actualName = application.getName();
      if (!actualName.equals(name)) {
        System.out.println("3.a Application.getName() FAILED! Expected: " + name
            + " Actual: " + actualName);
        error = true;
      }

      final String actualEmail = application.getEmail();
      if (!actualEmail.equals(email)) {
        System.out.println("3.b Application.getEmail() FAILED! Expected: " + email
            + " Actual: " + actualEmail);
        error = true;
      }

      final int actualScore = application.getScore();
      if (actualScore != score) {
        System.out.println("3.c Application.getScore() FAILED! Expected: " + score
            + " Actual: " + actualScore);
        error = true;
      }
    }
    catch (Exception e) {
      System.out.println("3. Unexpected Error Occured!");
      e.printStackTrace();
      error = true;
    }

    // 4. Verify compareTo
    try {
      final String name1 = "Application1";
      final String email1 = "email1@email.email";
      final int score1 = ((int) (Math.random() * 51)) + 50;
      final Application application1 = new Application(name1, email1, score1);

      final String name2 = "Application2";
      final String email2 = "email2@email.email";
      final int score2 = ((int) (Math.random() * 51));
      final Application application2 = new Application(name2, email2, score2);

      final String name3 = "Application3";
      final String email3 = "email3@email.email";
      final int score3 = score1;
      final Application application3 = new Application(name3, email3, score3);

      final int comparison1 = application1.compareTo(application2);
      if (comparison1 <= 0) {
        System.out.println("4.a Application.compareTo() FAILED!");
        error = true;
      }

      final int comparison2 = application1.compareTo(application3);
      if (comparison2 != 0) {
        System.out.println("4.b Application.compareTo() FAILED!");
        error = true;
      }

      final int comparison3 = application2.compareTo(application3);
      if (comparison3 >= 0) {
        System.out.println("4.c Application.compareTo() FAILED!");
        error = true;
      }
    }
    catch (Exception e) {
      System.out.println("4. Unexpected Error Occured!");
      e.printStackTrace();
      error = true;
    }

    // 5. Verify toString
    try {
      final String name = "Application";
      final String email = "email@email.email";
      final int score = ((int) Math.random() * 101);

      final Application application = new Application(name, email, score);

      final String expectedRepr = name + ":" + email + ":" + score;
      final String actualRepr = application.toString();

      if (!expectedRepr.equals(actualRepr)) {
        System.out.println("5. Application.toString() FAILED! Expected: " + expectedRepr
            + " Actual: " + actualRepr);
        error = true;
      }
    }
    catch (Exception e) {
      System.out.println("5. Unexpected Error Occured!");
      e.printStackTrace();
      error = true;
    }

    System.out.println("Application " + (error ? "failed some": "passed all")
        + " tests!");
    return !error;
  }

  /**
   * This method tests and makes use of the ApplicationIterator class.
   *
   * @return true when this test verifies the functionality, and false otherwise
   */
  public static final boolean testApplicationIterator() {
    System.out.println("Testing ApplicationIterator...");
    boolean error = false;

    // 1. Testing ApplicationIterator
    try {
      final int capacity = ((int)(Math.random() * 11)) + 5;
      final ApplicationQueue queue = new ApplicationQueue(capacity);

      enqueuer: for (int i = 0; i < capacity; i++) {
        final String name = "Application " + i;
        final String email = "email" + i + "@email.email";
        final int score = ((int) (Math.random() * 101));
        final Application application = new Application(name, email, score);
        queue.enqueue(application);
      }

      int previousScore = -1;
      boolean didItRun = false;

      verifier: for (Application application : queue) {
        didItRun = true;

        final int currentScore = application.getScore();

        if (currentScore < previousScore) {
          System.out.println("1. ApplicationIterator FAILED! Not in increasing order! "
              + " previous: " + previousScore + " current: " + currentScore);
          error = true;
          break verifier;
        }

        previousScore = currentScore;
      }

      if (!didItRun) {
        System.out.println("1. ApplicationIterator FAILED! Did not run!");
        error = true;
      }
    }
    catch (Exception e) {
      System.out.println("1. Unexpected Error Occured!");
      e.printStackTrace();
      error = true;
    }

    System.out.println("ApplicationIterator " + (error ? "failed some": "passed all")
        + " tests!");
    return !error;
  }

  /**
   * This method tests and makes use of the enqueue() and dequeue() methods
   * in the ApplicationQueue class.
   *
   * @return true when this test verifies the functionality, and false otherwise
   */
  public static final boolean testEnqueueDequeue() {
    System.out.println("Testing EnqueueDequeue...");
    boolean error = false;
    // create an ApplicationQueue with capacity 3
    // and at least 4 Applications with different scores

    ApplicationQueue queue = new ApplicationQueue(3);
    Application application1 = null;
    Application application2 = null;
    Application application3 = null;
    Application application4 = null;

    // 1. Enqueue an invalid value (null)
    try {
      queue.enqueue(null);
      System.out.println("1. ApplicationQueue.enqueue FAILED! Expected NullPointerException");
      error = true;
    }
    catch (NullPointerException e) {}
    catch (Exception e) {
      System.out.println("1. Unexpected Error Occured!");
      e.printStackTrace();
      error = true;
    }

    // 2. Enqueue one valid application
    try {
      final String name = "Application1";
      final String email = "email1@email.email";
      final int score = 75;
      application1 = new Application(name, email, score);
      queue.enqueue(application1);

      final int size = queue.size();
      if (size != 1) {
        System.out.println("2.a ApplicationQueue.enqueue() FAILED! Expected Size: 1 Actual Size: "
            + size);
        error = true;
      }

      final boolean isEmpty = queue.isEmpty();
      if (isEmpty) {
        System.out.println("2.b ApplicationQueue.enqueue() FAILED! Queue shouldn't be empty");
        error = true;
      }

      final Application app = queue.peek();
      if (app.compareTo(application1) != 0) {
        System.out.println("2.c ApplicationQueue.enqueue() FAILED! Incorrect Application returned");
        error = true;
      }
    }
    catch (Exception e) {
      System.out.println("2. Unexpected Error Occured!");
      e.printStackTrace();
      error = true;
    }

    // 3. Enqueue two more valid applications
    try {
      final String name2 = "Application2";
      final String email2 = "email2@email.email";
      final int score2 = 50;
      application2 = new Application(name2, email2, score2);
      queue.enqueue(application2);

      final int size = queue.size();
      if (size != 2) {
        System.out.println("3.a ApplicationQueue.enqueue() FAILED! Expected Size: 2 Actual Size: "
            + size);
        error = true;
      }

      final boolean isEmpty = queue.isEmpty();
      if (isEmpty) {
        System.out.println("3.b ApplicationQueue.enqueue() FAILED! Queue shouldn't be empty");
        error = true;
      }

      final Application app = queue.peek();
      if (app.compareTo(application2) != 0) {
        System.out.println("3.c ApplicationQueue.enqueue() FAILED! Incorrect Application returned");
        error = true;
      }

      final String name3 = "Application3";
      final String email3 = "email3@email.email";
      final int score3 = 25;
      application3 = new Application(name3, email3, score3);
      queue.enqueue(application3);

      final int size2 = queue.size();
      if (size2 != 3) {
        System.out.println("3.d ApplicationQueue.enqueue() FAILED! Expected Size: 3 Actual Size: "
            + size2);
        error = true;
      }

      final boolean isEmpty2 = queue.isEmpty();
      if (isEmpty2) {
        System.out.println("3.e ApplicationQueue.enqueue() FAILED! Queue shouldn't be empty");
        error = true;
      }

      final Application app2 = queue.peek();
      if (app2.compareTo(application3) != 0) {
        System.out.println("3.f ApplicationQueue.enqueue() FAILED! Incorrect Application returned");
        error = true;
      }
    }
    catch (Exception e) {
      System.out.println("3. Unexpected Error Occured!");
      e.printStackTrace();
      error = true;
    }

    // 4. enqueue one more application (exceeds capacity)
    try {
      final String name = "Application1";
      final String email = "email1@email.email";
      final int score = 75;
      application4 = new Application(name, email, score);
      queue.enqueue(application4);
      System.out.println("4. ApplicationQueue.enqueue() FAILED! Expected IllegalStateException");
      error = true;
    }
    catch (IllegalStateException e) {
      final int size = queue.size();
      if (size != 3) {
        System.out.println("4.a ApplicationQueue.enqueue() FAILED! Expected Size: 3 Actual Size: "
            + size);
        error = true;
      }

      final boolean isEmpty = queue.isEmpty();
      if (isEmpty) {
        System.out.println("4.b ApplicationQueue.enqueue() FAILED! Queue shouldn't be empty");
        error = true;
      }

      final Application app = queue.peek();
      if (app.compareTo(application3) != 0) {
        System.out.println("4.c ApplicationQueue.enqueue() FAILED! Incorrect Application returned");
        error = true;
      }
    }
    catch (Exception e) {
      System.out.println("4. Unexpected Error Occured!");
      e.printStackTrace();
      error = true;
    }


    // 5. Dequeue one application (should be lowest score)
    try {
      final Application app = queue.dequeue();

      if (app.compareTo(application3) != 0) {
        System.out.println("5. ApplicationQueue.dequeue() FAILED! Incorrect Application returned");
        error = true;
      }
    }
    catch (Exception e) {
      System.out.println("5. Unexpected Error Occured!");
      e.printStackTrace();
      error = true;
    }

    // 6. Dequeue all applications
    try {
      final Application app1 = queue.dequeue();

      if (app1.compareTo(application2) != 0) {
        System.out.println("6.a ApplicationQueue.dequeue() FAILED! Incorrect Application returned");
        error = true;
      }

      final Application app2 = queue.dequeue();

      if (app2.compareTo(application1) != 0) {
        System.out.println("6.b ApplicationQueue.dequeue() FAILED! Incorrect Application returned");
        error = true;
      }
    }
    catch (Exception e) {
      System.out.println("6. Unexpected Error Occured!");
      e.printStackTrace();
      error = true;
    }

    // 7. Dequeue from an empty queue
    try {
      final Application app = queue.dequeue();
      System.out.print("7. ApplicationQueue.dequeue() FAILED! Expected NoSuchElementException");
      error = true;
    }
    catch (NoSuchElementException e) {}
    catch (Exception e) {
      System.out.println("7. Unexpected Error Occured!");
      e.printStackTrace();
      error = true;
    }

    System.out.println("EnqueueDequeue " + (error ? "failed some": "passed all")
        + " tests!");
    return !error;
  }

  /**
   * This method tests and makes use of the common methods (isEmpty(), size(), peek())
   * in the ApplicationQueue class.
   *
   * @return true when this test verifies the functionality, and false otherwise
   */
  public static final boolean testCommonMethods() {
    System.out.println("Testing CommonMethods...");
    boolean error = false;

    // 1. Create an ApplicationQueue with 0 capacity (should fail)
    try {
      final int invalidCapacity = 0;
      final ApplicationQueue queue = new ApplicationQueue(invalidCapacity);
      System.out.println("1. ApplicationQueue's Constructor FAILED! "
          + "Expected IllegalArgumentException");
      error = true;
    }
    catch (IllegalArgumentException e) {}
    catch (Exception e) {
      System.out.println("1. Unexpected Error Occured!");
      e.printStackTrace();
      error = true;
    }

    // 2. Create an ApplicationQueue with capacity 3
    // and at least 3 Applications with different scores
    try {
      final int capacity = ((int)(Math.random() * 11)) + 5;
      final ApplicationQueue queue = new ApplicationQueue(capacity);

      enqueuer: for (int i = 0; i < capacity; i++) {
        final String name = "Application " + i;
        final String email = "email" + i + "@email.email";
        final int score = ((int) (Math.random() * 101));
        final Application application = new Application(name, email, score);
        queue.enqueue(application);
      }

      Application expectedApp = queue.peek();

      customVerifier: for (final Application app : queue)
        expectedApp = app.compareTo(expectedApp) < 0 ? app : expectedApp;

      final int size = queue.size();
      if (size != capacity) {
        System.out.println("2.a ApplicationQueue.size() FAILED! Expected Size: " + capacity
            + " Actual Size: " + size);
        error = true;
      }

      final boolean isEmpty = queue.isEmpty();
      if (isEmpty) {
        System.out.println("2.b ApplicationQueue.isEmpty() FAILED! Queue shouldn't be empty");
        error = true;
      }

      final Application app = queue.peek();
      if (app.compareTo(expectedApp) != 0) {
        System.out.println("2.c ApplicationQueue.peek() FAILED! Incorrect Application returned");
        error = true;
      }
    }
    catch (Exception e) {
      System.out.println("2. Unexpected Error Occured!");
      e.printStackTrace();
      error = true;
    }

    // 3. Verify the methods' behaviors on an empty queue
    try {
      final int capacity = ((int)(Math.random() * 11)) + 5;
      final ApplicationQueue queue = new ApplicationQueue(capacity);

      final int size = queue.size();
      if (size != 0) {
        System.out.println("3.a ApplicationQueue.size() FAILED! Expected Size: 0 Actual Size: "
            + size);
        error = true;
      }

      final boolean isEmpty = queue.isEmpty();
      if (!isEmpty) {
        System.out.println("3.b ApplicationQueue.isEmpty() FAILED! Queue should be empty");
        error = true;
      }

      try {
        final Application app = queue.peek();

        System.out.println("3.c ApplicationQueue.peek() FAILED! "
            + "Expected NoSuchElementException");
        error = true;
      }
      catch (NoSuchElementException e) {}

      try {
        final Application app = queue.dequeue();

        System.out.println("3.d ApplicationQueue.dequeue() FAILED! "
            + "Expected NoSuchElementException");
        error = true;
      }
      catch (NoSuchElementException e) {}
    }
    catch (Exception e) {
      System.out.println("3. Unexpected Error Occured!");
      e.printStackTrace();
      error = true;
    }

    System.out.println("CommonMethods " + (error ? "failed some": "passed all")
        + " tests!");
    return !error;
  }

  /**
   * This method tests and makes use of OpenPosition class.
   *
   * @return true when this test verifies the functionality, and false otherwise
   */
  public static final boolean testOpenPosition() {
    System.out.println("Testing OpenPosition...");
    boolean error = false;
    // 1. Create an OpenPosition with 0 capacity (should fail)
    try {
      final int capacity = 0;
      final OpenPosition openPosition = new OpenPosition("Programmer", capacity);
      System.out.println("1. OpenPosition's Constructor FAILED! Expected IllegalArgumentException");
      error = true;
    }
    catch (IllegalArgumentException e) {}
    catch (Exception e) {
      System.out.println("1. Unexpected Error Occured");
      e.printStackTrace();
      error = true;
    }

    // 2. Verify that the 3 MIDDLE-scoring Applications can be added
    // don't use the highest and lowest scoring applications YET
    try {
      final int capacity = ((int)(Math.random() * 11)) + 5;
      final OpenPosition openPosition = new OpenPosition("Programmer", capacity);

      final Application[] applications = new Application[capacity];
      createArray: for (int i = 0; i < applications.length; i++) {
        final String name = "Application " + i;
        final String email = "email" + i + "@email.email";
        final int score = ((int) (Math.random() * 101));
        final Application application = new Application(name, email, score);
        applications[i] = application;
      }

      addApplications: for (int i = 0; i < applications.length; i++) {
        final boolean wasAdded = openPosition.add(applications[i]);
        if (!wasAdded) {
          System.out.println("2.a OpenPosition.add() FAILED!");
          error = true;
          break addApplications;
        }
      }
    }
    catch (Exception e) {
      System.out.println("2. Unexpected Error Occured");
      e.printStackTrace();
      error = true;
    }

    // 3. Verify that getApplications returns the correct value for your input
    try {
      final int capacity = ((int)(Math.random() * 11)) + 5;
      final OpenPosition openPosition = new OpenPosition("Programmer", capacity);

      final Application[] applications = new Application[capacity];
      createArray: for (int i = 0; i < applications.length; i++) {
        final String name = "Application";
        final String email = "email@email.email";
        final int score = ((int) (Math.random() * 101));
        final Application application = new Application(name, email, score);
        applications[i] = application;
      }

      addApplications: for (int i = 0; i < applications.length; i++)
        openPosition.add(applications[i]);

      OpenPositionTester.sortArray(applications);

      String expectedRepr = "";
      createExpectedRepr: for (Application application : applications)
        expectedRepr += application + "\n";

      expectedRepr = expectedRepr.trim();

      final String actualRepr = openPosition.getApplications().trim();

      if (!actualRepr.equals(expectedRepr)) {
        System.out.println("3. OpenPosition.getApplications() FAILED! Expected: " + expectedRepr
            + " Actual: " + actualRepr);
        error = true;
      }
    }
    catch (Exception e) {
      System.out.println("3. Unexpected Error Occured");
      e.printStackTrace();
      error = true;
    }

    // 4. Verify that the result of getTotalScore is the sum of all 3 Application scores
    try {
      final int capacity = ((int)(Math.random() * 11)) + 5;
      final OpenPosition openPosition = new OpenPosition("Programmer", capacity);

      final Application[] applications = new Application[capacity];
      createArray: for (int i = 0; i < applications.length; i++) {
        final String name = "Application " + i;
        final String email = "email" + i + "@email.email";
        final int score = ((int) (Math.random() * 101));
        final Application application = new Application(name, email, score);
        applications[i] = application;
      }

      addApplications: for (int i = 0; i < applications.length; i++)
        openPosition.add(applications[i]);

      OpenPositionTester.sortArray(applications);

      int expectedTotalScore = 0;
      createExpectedTotalScore: for (Application application : applications)
        expectedTotalScore += application.getScore();

      final int actualTotalScore = openPosition.getTotalScore();

      if (actualTotalScore != expectedTotalScore) {
        System.out.println("4. OpenPosition.getTotalScore() FAILED! Expected: "
            + expectedTotalScore + " Actual: " + actualTotalScore);
        error = true;
      }
    }
    catch (Exception e) {
      System.out.println("4. Unexpected Error Occured");
      e.printStackTrace();
      error = true;
    }

    // 5. Verify that the lowest-scoring application is NOT added to the OpenPosition
    try {
      final int capacity = ((int)(Math.random() * 11)) + 5;
      final OpenPosition openPosition = new OpenPosition("Programmer", capacity);

      final Application[] applications = new Application[capacity + 1];
      createArray: for (int i = 0; i < applications.length; i++) {
        final String name = "Application " + i;
        final String email = "email" + i + "@email.email";
        final int score = ((int) (Math.random() * 101));
        final Application application = new Application(name, email, score);
        applications[i] = application;
      }

      OpenPositionTester.sortArray(applications);

      addApplications: for (int i = 1; i < applications.length; i++)
        openPosition.add(applications[i]);

      final boolean wasAdded = openPosition.add(applications[0]);
      if (wasAdded) {
        System.out.println("5. OpenPosition.add() FAILED! Shouldn't add application with lower "
            + "score than current minimum");
        error = true;
      }
    }
    catch (Exception e) {
      System.out.println("5. Unexpected Error Occured");
      e.printStackTrace();
      error = true;
    }

    // 6. Verify that the highest-scoring application IS added to the OpenPosition
    try {
      final int capacity = ((int)(Math.random() * 11)) + 5;
      final OpenPosition openPosition = new OpenPosition("Programmer", capacity);

      final Application[] applications = new Application[capacity + 1];
      createArray: for (int i = 0; i < applications.length; i++) {
        final String name = "Application " + i;
        final String email = "email" + i + "@email.email";
        final int score = ((int) (Math.random() * 101));
        final Application application = new Application(name, email, score);
        applications[i] = application;
      }

      OpenPositionTester.sortArray(applications);

      addApplications: for (int i = 0; i < applications.length - 1; i++)
        openPosition.add(applications[i]);

      final boolean wasAdded = openPosition.add(applications[applications.length - 1]);
      if (!wasAdded) {
        System.out.println("6. OpenPosition.add() FAILED! Should add application with higher "
            + "score than current maximum");
        error = true;
      }
    }
    catch (Exception e) {
      System.out.println("6. Unexpected Error Occured");
      e.printStackTrace();
      error = true;
    }

    // 7. Verify that getApplications has changed correctly
    try {
      final int capacity = ((int)(Math.random() * 11)) + 5;
      final OpenPosition openPosition = new OpenPosition("Programmer", capacity);

      final Application[] applications = new Application[capacity + 1];
      createArray: for (int i = 0; i < applications.length; i++) {
        final String name = "Application";
        final String email = "email@email.email";
        final int score = ((int) (Math.random() * 101));
        final Application application = new Application(name, email, score);
        applications[i] = application;
      }

      OpenPositionTester.sortArray(applications);

      addApplications: for (Application app: applications)
        openPosition.add(app);

      String expectedRepr = "";
      createExpectedRepr: for (int i = 1; i < applications.length; i++)
        expectedRepr += applications[i] + "\n";

      expectedRepr = expectedRepr.trim();

      final String actualRepr = openPosition.getApplications().trim();

      if (!actualRepr.equals(expectedRepr)) {
        System.out.println("7. OpenPosition.getApplications() FAILED! Expected: " + expectedRepr
            + " Actual: " + actualRepr);
        error = true;
      }
    }
    catch (Exception e) {
      System.out.println("7. Unexpected Error Occured");
      e.printStackTrace();
      error = true;
    }

    // 8. Verify that the result of getTotalScore has changed correctly
    try {
      final int capacity = ((int)(Math.random() * 11)) + 5;
      final OpenPosition openPosition = new OpenPosition("Programmer", capacity);

      final Application[] applications = new Application[capacity + 1];
      createArray: for (int i = 0; i < applications.length; i++) {
        final String name = "Application " + i;
        final String email = "email" + i + "@email.email";
        final int score = ((int) (Math.random() * 101));
        final Application application = new Application(name, email, score);
        applications[i] = application;
      }

      OpenPositionTester.sortArray(applications);

      addApplications: for (int i = 0; i < applications.length; i++)
        openPosition.add(applications[i]);

      int expectedTotalScore = 0;
      createExpectedTotalScore: for (int i = 1; i < applications.length; i++)
        expectedTotalScore += applications[i].getScore();

      final int actualTotalScore = openPosition.getTotalScore();

      if (actualTotalScore != expectedTotalScore) {
        System.out.println("8. OpenPosition.getApplications() FAILED! Expected: "
            + expectedTotalScore + " Actual: " + actualTotalScore);
        error = true;
      }
    }
    catch (Exception e) {
      System.out.println("8. Unexpected Error Occured");
      e.printStackTrace();
      error = true;
    }

    System.out.println("OpenPosition " + (error ? "failed some": "passed all")
        + " tests!");
    return !error;
  }

  /**
   * Sorts the {@code application} array in ascending order
   * The sorting aglorithm used is Merge Sort
   *
   * @param applications The array to sort
   */
  private static final void sortArray(Application[] arr) {
    if (arr.length <= 1) return;

    Application[] left = split(arr, 0, arr.length / 2);
    Application[] right = split(arr, arr.length / 2, arr.length);

    sortArray(left);
    sortArray(right);

    int i = 0;
    int j = 0;
    int k = 0;

    mergeBoth: while ((i < left.length) && (j < right.length))
      arr[k++] = left[i].getScore() < right[j].getScore() ? left[i++] : right[j++];

    mergeLeft: while (i < left.length)
      arr[k++] = left[i++];

    mergeRight: while (j < right.length)
      arr[k++] = right[j++];
  }

  /**
   * Helper method for sortArray
   *
   * @param  arr   The array to split
   * @param  start The start index of the split (inclusive)
   * @param  end   The end index of the split (exclusive)
   *
   * @return       The split sub-array
   */
  private static final Application[] split(Application[] arr, int start, int end) {
    Application[] splitArr = new Application[end - start];
    copy: for (int i = 0; i < end - start; i++)
      splitArr[i] = arr[start + i];
    return splitArr;
  }

  /**
   * This method calls all the test methods defined and implemented in your OpenPositionTester class.
   *
   * @return true if all the test methods defined in this class pass, and false otherwise.
   */
  public static final boolean runAllTests() {
    final boolean testApplication = testApplication();
    System.out.println();
    final boolean testApplicationIterator = testApplicationIterator();
    System.out.println();
    final boolean testEnqueueDequeue = testEnqueueDequeue();
    System.out.println();
    final boolean testCommonMethods = testCommonMethods();
    System.out.println();
    final boolean testOpenPosition = testOpenPosition();
    System.out.println();

    return (
        testApplication
        && testApplicationIterator
        && testEnqueueDequeue
        && testCommonMethods
        && testOpenPosition
    );
  }

  /**
   * Driver method defined in this OpenPositionTester class
   *
   * @param args input arguments if any.
   */
  public static void main(String[] args) {
    System.out.print(runAllTests());
  }
}