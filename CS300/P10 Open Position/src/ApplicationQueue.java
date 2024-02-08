//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title: ApplicationQueue
// Course: CS 300 Spring 2022
//
// Author: Ava Pezza
// Email: apezza@wisc.edu
// Lecturer: Hobbes LeGault
//
///////////////////////// ALWAYS CREDIT OUTSIDE HELP //////////////////////////
//
// Persons: NONE
// Online Sources: NONE
//
///////////////////////////////////////////////////////////////////////////////


import java.util.Iterator;
import java.util.NoSuchElementException;

/**
 * @author Ava Pezza
 *
 *         Array-based heap implementation of a priority queue containing Applications. Guarantees
 *         the min-heap invariant, so that the Application at the root should have the lowest score,
 *         and children always have a higher or equal score as their parent. The root of a non-empty
 *         queue is always at index 0 of this array-heap.
 */
public class ApplicationQueue implements PriorityQueueADT<Application>, Iterable<Application> {
  private Application[] queue; // array min-heap of applications representing this priority queue
  private int size; // size of this priority queue

  /**
   * Creates a new empty ApplicationQueue with the given capacity
   *
   * @param capacity Capacity of this ApplicationQueue
   * @throws IllegalArgumentException with a descriptive error message if the capacity is not a
   *                                  positive integer
   */
  public ApplicationQueue(int capacity) {
    // verify the capacity
    if (capacity <= 0) {
      throw new IllegalArgumentException("Error: capacity not a positive integer");
    }
    // initialize fields appropriately
    queue = new Application[capacity];
    size = 0;
  }

  /**
   * Checks whether this ApplicationQueue is empty
   *
   * @return {@code true} if this ApplicationQueue is empty
   */
  @Override
  public boolean isEmpty() {
    return size == 0;
  }

  /**
   * Returns the size of this ApplicationQueue
   *
   * @return the size of this ApplicationQueue
   */
  @Override
  public int size() {
    return this.size;
  }

  /**
   * Adds the given Application to this ApplicationQueue and use the percolateUp() method to
   * maintain min-heap invariant of ApplicationQueue. Application should be compared using the
   * Application.compareTo() method.
   *
   *
   * @param app Application to add to this ApplicationQueue
   * @throws NullPointerException  if the given Application is null
   * @throws IllegalStateException with a descriptive error message if this ApplicationQueue is full
   */
  @Override
  public void enqueue(Application app) {
    // verify the application
    if (app == null)
      throw new NullPointerException("Error: given Application is null, bitch!");
    // verify that the queue is not full
    if (size == queue.length)
      throw new IllegalStateException("Error: fuckin full Application bro");

    // if allowed, add the application to the queue and percolate to restore the heap condition
    queue[size++] = app;
    percolateUp(size - 1);
  }

  /**
   * Removes and returns the Application at the root of this ApplicationQueue, i.e. the Application
   * with the lowest score.
   *
   * @return the Application in this ApplicationQueue with the smallest score
   * @throws NoSuchElementException with a descriptive error message if this ApplicationQueue is
   *                                empty
   */
  @Override
  public Application dequeue() {
    // verify that the queue is not empty
    if (this.isEmpty())
      throw new NoSuchElementException("Error: application is empty");
    // save the lowest-scoring application
    final Application lowest = queue[0];
    // replace the root of the heap and percolate to restore the heap condition
    swap(0, --this.size);
    queue[size] = null;
    percolateDown(0);
    // return the lowest-scoring application
    return lowest;
  }

  /**
   * Swap the fucking applications using their indexes
   */
  private void swap(int index1, int index2) {
    Application temp = queue[index1];
    queue[index1] = queue[index2];
    queue[index2] = temp;
  }

  /**
   * An implementation of percolateDown() method. Restores the min-heap invariant of a given subtree
   * by percolating its root down the tree. If the element at the given index does not violate the
   * min-heap invariant (it is due before its children), then this method does not modify the heap.
   * Otherwise, if there is a heap violation, then swap the element with the correct child and
   * continue percolating the element down the heap.
   *
   * This method may be implemented recursively OR iteratively.
   *
   * @param i index of the element in the heap to percolate downwards
   * @throws IndexOutOfBoundsException if index is out of bounds - do not catch the exception
   */
  private void percolateDown(int i) {
    // implement the min-heap percolate down algorithm to modify the heap in place
    if(i >= size) {
      throw new IndexOutOfBoundsException("Error: index out of bounds");
    }
    // no children
    if (i > this.size / 2) {
      return;
    }
    Application leftChild;
    Application rightChild;
    try {
      leftChild = queue[(i * 2) + 1];
    } catch (ArrayIndexOutOfBoundsException e) {
      leftChild = null;
    }
    try {
      rightChild = queue[(i * 2) + 2];
    } catch (ArrayIndexOutOfBoundsException e) {
      rightChild = null;
    }
    // two children
    if (rightChild != null && leftChild != null) {
      int smaller = leftChild.compareTo(rightChild) < 0 ? i * 2 + 1 : i * 2 + 2;
      if (queue[i].compareTo(queue[smaller]) > 0) {
        swap(i, smaller);
        percolateDown(smaller);
      }
      return;
    }
    // one child
    if (leftChild != null) {
      if (queue[i].compareTo(leftChild) > 0) {
        swap(i, ((i * 2) + 1));
      }
    }
  }

  /**
   * An implementation of percolateUp() method. Restores the min-heap invariant of the tree by
   * percolating a leaf up the tree. If the element at the given index does not violate the min-heap
   * invariant (it occurs after its parent), then this method does not modify the heap. Otherwise,
   * if there is a heap violation, swap the element with its parent and continue percolating the
   * element up the heap.
   *
   * This method may be implemented recursively OR iteratively.
   *
   * Feel free to add private helper methods if you need them.
   *
   * @param i index of the element in the heap to percolate upwards
   * @throws IndexOutOfBoundsException if index is out of bounds - do not catch the exception
   */
  private void percolateUp(int i) {
    // implement the min-heap percolate up algorithm to modify the heap in place
    if(i >= size) {
      throw new IndexOutOfBoundsException("Error: index out of bounds");
    }
    while (queue[i].compareTo(queue[(i - 1) / 2]) < 0) {
      swap((i - 1) / 2, i);
      i = (i - 1) / 2;
    }
  }

  /**
   * Returns the Application at the root of this ApplicationQueue, i.e. the Application with the
   * lowest score.
   *
   * @return the Application in this ApplicationQueue with the smallest score
   * @throws NoSuchElementException if this ApplicationQueue is empty
   */
  @Override
  public Application peek() {
    // verify that the queue is not empty
    if (this.isEmpty())
      throw new NoSuchElementException("Error: ApplicationQueue fucking empty");
    // return the lowest-scoring application
    return queue[0];
  }

  /**
   * Returns a deep copy of this ApplicationQueue containing all of its elements in the same order.
   * This method does not return the deepest copy, meaning that you do not need to duplicate
   * applications. Only the instance of the heap (including the array and its size) will be
   * duplicated.
   *
   * @return a deep copy of this ApplicationQueue. The returned new application queue has the same
   *         length and size as this queue.
   */
  public ApplicationQueue deepCopy() {
    // implement this method according to its Javadoc comment
    ApplicationQueue heapCopied = new ApplicationQueue(size);
    for (int i = 0; i < size; i++) {
      heapCopied.enqueue(queue[i]);
    }
    return heapCopied;
  }

  /**
   * Returns a String representing this ApplicationQueue, where each element (application) of the
   * queue is listed on a separate line, in order from the lowest score to the highest score.
   *
   * This implementation is provided.
   *
   * @see Application#toString()
   * @see ApplicationIterator
   * @return a String representing this ApplicationQueue
   */
  @Override
  public String toString() {
    StringBuilder val = new StringBuilder();

    for (Application a : this) {
      val.append(a).append("\n");
    }

    return val.toString();
  }

  /**
   * Returns an Iterator for this ApplicationQueue which proceeds from the lowest-scored to the
   * highest-scored Application in the queue.
   *
   * This implementation is provided.
   *
   * @see ApplicationIterator
   * @return an Iterator for this ApplicationQueue
   */
  @Override
  public Iterator<Application> iterator() {
    return new ApplicationIterator(this);
  }
}
