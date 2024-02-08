//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title: Song Player Test
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
 * This class implements unit test methods to check the correctness of Song, LinkedNode, SongPlayer
 * ForwardSongIterator and BackwardSongIterator classes in P07 Iterable Song Player assignment.
 *
 */
public class SongPlayerTester {
  
  /**
   * This method test and make use of the Song constructor, an accessor (getter) method, overridden
   * method toString() and equal() method defined in the Song class.
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean testSong() {

    Song test = new Song("Out of Time", "The weekend", "3:34");
    String expected = "Out of Time";

    // getSongName()
    if (!test.getSongName().equalsIgnoreCase(expected)) {
      return false;
    }

    // getArtist()
    expected = "The weekend";
    if (!test.getArtist().equalsIgnoreCase(expected)) {
      return false;
    }

    // getDuration()
    expected = "3:34";
    if (!test.getDuration().equalsIgnoreCase(expected)) {
      return false;
    }

    // toString()
    expected = "Out of Time---The weekend---3:34";
    if (!test.toString().equalsIgnoreCase(expected)) {
      return false;
    }

    // equals(other)
    boolean expected2 = true;
    Song test2 = new Song("Out of Time", "The weekend", "3:34");
    if (!test.equals(test2)) {
      System.out.println(test2.toString());
      System.out.println(test.toString());
      return false;
    }

    Object test3 = new Object();
    if (test.equals(test3)) {
      return false;
    }

    Song test4 = new Song("out of time", "the WEEkend", "3:34");
    if (!test.equals(test4)) {
      return false;
    }

    return true;
  }

  /**
   * This method test and make use of the LinkedNode constructor, an accessor (getter) method, and a
   * mutator (setter) method defined in the LinkedCart class.
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean testLinkedNode() {

    String testData;
    // LinkedNode<String> testPrev = new LinkedNode<String>(testPrev);
    LinkedNode<String> testNext;
    // getPrev()
    // LinkedNode<String> test = new LinkedNode<String>(testPrev, testData, testNext);

    // setPrev()

    // getNext()

    // setNext()

    // getData()

    return true;
  }

  /**
   * This method checks for the correctness of addFirst(), addLast() and add(int index) method in
   * SongPlayer class
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean testSongPlayerAdd() {
    return false;
  }

  /**
   * This method checks for the correctness of getFirst(), getLast() and get(int index) method in
   * SongPlayer class
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean testSongPlayerGet() {
    return false;
  }

  /**
   * This method checks for the correctness of removeFirst(), removeLast() and remove(int index)
   * method in SongPlayer class
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean testSongPlayerRemove() {
    return false;
  }

  /**
   * This method checks for the correctness of iterator(), switchPlayingDirection() and String
   * play() method in SongPlayer class
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean testSongPlayerIterator() {
    return false;
  }

  /**
   * This method checks for the correctness of contains(Object song), clear(), isEmpty()and size()
   * method in SongPlayer class
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean testSongPlayerCommonMethod() {
    return false;
  }

  /**
   * This method checks for the correctness of ForwardSongIterator class
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean testForwardSongIterator() {
    return false;
  }

  /**
   * This method checks for the correctness of BackwardSongIterator class
   * 
   * @return true when this test verifies a correct functionality, and false otherwise
   */
  public static boolean testBackwardSongIterator() {
    return false;
  }

  /**
   * This method calls all the test methods defined and implemented in your SongPlayerTester class.
   * 
   * @return true if all the test methods defined in this class pass, and false otherwise.
   */
  public static boolean runAllTests() {
    return false;
  }

  /**
   * Driver method defined in this SongPlayerTester class
   * 
   * @param args input arguments if any.
   */
  public static void main(String[] args) {
    // System.out.println(testSong());
    // System.out.println(testLinkedNode());
    // System.out.println(testSongPlayerAdd());
    // System.out.println(testSongPlayerGet());
    // System.out.println(testSongPlayerRemove());
    // System.out.println(testSongPlayerIterator());
    // System.out.println(testSongPlayerCommonMethod());
    // System.out.println(testForwardSongIterator());
    // System.out.println(testBackwardSongIterator());

    Song song = new Song("What If", "Five for Fighting", "3:13");
    SongPlayer player = new SongPlayer();
    player.addFirst(song);
  }
}
