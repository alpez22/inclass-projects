//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title: Node
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
 * A generic class specifying the basics of a singly-linked node for a linked queue.
 */
public class Node<T> {

  private T data;
  private Node<T> next;

  /**
   * Basic constructor; creates a node that contains the provided data and no linkages.
   * @param data the information to put inside the node
   */
  public Node(T data) {
    this.data = data;
  }

  /**
   * A constructor that allows specification of the next node in the chain
   * @param data the information to put inside the node
   * @param next the next node, must contain the same type of data as this node
   */
  public Node(T data, Node<T> next) {
    this.data = data;
    setNext(this.next);
  }

  /**
   * Accessor method for this node's data
   * @return the data contained in this node
   */
  public T getData() {
    return this.data;
  }

  /**
   * Accessor method for the node following this one
   * @return the next node
   */
  public Node<T> getNext() {
    return this.next;
  }

  /**
   * Mutator method for the node following this one
   * @param next the node to follow this one
   */
  public void setNext(Node<T> next) {
    this.next = next;
  }
}
