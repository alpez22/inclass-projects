//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title: Forward Song Iterator
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
 * This class models an iterator to play songs in the rforward direction from a doubly linked list
 * of songs
 */
public class ForwardSongIterator implements Iterator<Song> {

  private LinkedNode<Song> next; // reference to the next linked node in a list of nodes.

  /**
   * Creates a new iterator which iterates through songs in front/head to back/tail order
   * 
   * @param first reference to the head of a doubly linked list of songs
   */
  public ForwardSongIterator(LinkedNode<Song> first) {
    this.next = first;

  }

  /**
   * Checks whether there are more songs to return
   *
   * @return true if there are more songs to return
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
    next = next.getNext();
    return songTemp.getData();
  }
}
