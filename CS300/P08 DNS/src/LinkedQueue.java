//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title: LinkedQueue<T>
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
import java.util.NoSuchElementException;
/**
 * generic and implements QueueADT interface
 */
public class LinkedQueue<T> implements QueueADT<T> {

  private int n;
  protected Node<T> front;
  protected Node<T> back;

  /**
   * Adds the given data to this queue; every addition to a queue is made at the back
   * 
   * @param data the data to add
   */
  @Override
  public void enqueue(T data) {

    Node<T> tempNode = new Node<T>(data);
    if (isEmpty()) {
      this.front = tempNode;
      this.back = front;
    }else {
      this.back.setNext(tempNode);
      this.back = back.getNext();
    }
    this.n = this.n + 1;
  }

  /**
   * Removes and returns the item from this queue that was least recently added
   * 
   * @throws NoSuchElementException if the queue is empty
   * @return the item from this queue that was least recently added
   */
  @Override
  public T dequeue() {
    
    T data;
    try {
      data = front.getData();
    }catch (NullPointerException e) {
      throw new NoSuchElementException("Error: queue is empty");
    }
    
    if (isEmpty()) {
      this.back = this.front;
    }
    front = front.getNext();
    this.n = this.n - 1;
    return data;
  }

  /**
   * Returns the item least recently added to this queue without removing it
   * 
   * @throws NoSuchElementException if the queue is empty
   * @return the item least recently added to this queue
   */
  @Override
  public T peek() {

    if (isEmpty()) {
      throw new NoSuchElementException("Error: queue is empty");
    }
    return front.getData();
  }

  /**
   * Checks whether the queue contains any elements
   * 
   * @return true if this queue is empty; false otherwise
   */
  @Override
  public boolean isEmpty() {

    if (size() == 0) {
      return true;
    }
    return false;
  }

  /**
   * Returns the number of items in this queue
   * 
   * @return the number of items in this queue
   */
  @Override
  public int size() {

    return this.n;
  }

  /**
   * Returns a string representation of this queue, beginning at the front (least recently added) of
   * the queue and ending at the back (most recently added). An empty queue is represented as an
   * empty string; otherwise items in the queue are represented using their data separated by spaces
   * 
   * @return the sequence of items in FIFO order, separated by spaces
   */
  @Override
  public String toString() {
    
    String queueString = "";
    if(!isEmpty()) {
      Node<T> node = this.front;
      while (node != null) {
        queueString = queueString + node.getData() + " ";
        node = node.getNext();
      }
    }
    return queueString.trim();
  }

}
