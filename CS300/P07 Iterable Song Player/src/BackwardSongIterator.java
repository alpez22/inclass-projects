//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title: Backward Song Iterator
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
import java.util.Iterator;
import java.util.NoSuchElementException;

/**
 * This class models an iterator to play songs in the reverse backward direction from a doubly
 * linked list of songs
 */
public class BackwardSongIterator implements Iterator<Song> {
  private LinkedNode<Song> next;

  /**
   * Creates a new iterator which iterates through songs in back/tail to front/head order
   * 
   * @param last reference to the tail of a doubly linked list of songs
   */
  public BackwardSongIterator(LinkedNode<Song> last) {
    this.next = last;
  }

  /**
   * Checks whether there are more songs to return in the reverse order
   *
   * @return true if there are more songs to return in the reverse order
   */
  @Override
  public boolean hasNext() {
    return next != null;
  }

  /**
   * Returns the next song in the iteration
   *
   * @throws java.util.NoSuchElementException - with a descriptive error message if there are no
   *                                          more songs to return in the reverse order (meaning if
   *                                          this.hasNext() returns false)
   */
  @Override
  public Song next() {

    if (!hasNext()) {
      throw new NoSuchElementException("Error: no such element exists");
    }
    LinkedNode<Song> songTemp = next;
    next = next.getPrev();
    return songTemp.getData();
  }

}
