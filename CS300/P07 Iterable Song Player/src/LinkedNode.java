//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title: Linked Node
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
 * An instance of this class represents a single node within a doubly linked list
 */
public class LinkedNode<T> {

  private T data; // data field of this linked node
  private LinkedNode<T> prev; // reference to the previous linked node in a list of nodes
  private LinkedNode<T> next; // reference to the next linked node in a list of nodes

  /**
   * Initializes a new node with the provided information.
   * 
   * @param prev node, which comes before this node in a doubly linked list
   * @param data to be stored within this node
   * @param next node, which comes after this node in a doubly linked list
   * @throws IllegalArgumentException with a descriptive error message if data is null
   */
  public LinkedNode(LinkedNode<T> prev, T data, LinkedNode<T> next) {

    if (data == null) {
      throw new IllegalArgumentException("Error: data is null");
    }
    this.data = data;
    setNext(next);
    setPrev(prev);
  }

  public LinkedNode<T> getPrev() {
    return this.prev;
  }

  // check???
  public void setPrev(LinkedNode<T> prev) {
    this.prev = prev;
  }

  public LinkedNode<T> getNext() {
    return this.next;
  }

  public void setNext(LinkedNode<T> next) {
    this.next = next;
  }

  public T getData() {
    return this.data;
  }
}
