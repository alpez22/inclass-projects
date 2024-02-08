//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title: Treasure Hunt - DroppableObject
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
 * This class models a droppable object designed for the cs300 spring 2022 p05 Treasure Hunt
 * adventure style game application. It is a draggable object which triggers a next clue to appear
 * when dropped on a specific target.
 */
public class DroppableObject extends DraggableObject {

  private InteractiveObject target; // target of this droppable object

  /**
   * Creates a new Droppable object with specific name, x and y positions, message, target, and sets
   * its next clue.
   */
  public DroppableObject(String name, int x, int y, String message, InteractiveObject target,
      InteractiveObject nextClue) {
    super(name, x, y, message);
    this.target = target;
  }

  /**
   * Stops dragging this droppable object. Also, if this droppable object is over its target and the
   * target is activated, this method (1) deactivates both this object and its target, (2) activates
   * the next clue, and (3) prints the message of this draggable object to the console.
   */
  @Override
  public void mouseReleased() {
    if (isOver​(target) && target.isActive()) {
      this.deactivate();
      target.deactivate();
      this.activateNextClue();
      System.out.println(super.message());
    }
  }

  /**
   * Checks whether this object is over another interactive object.
   * 
   * @param other reference to another iteractive object. We assume that other is NOT null.
   * @return true if this droppable object and other overlap and false otherwise.
   */
  public boolean isOver​(InteractiveObject other) {
    if ((other.getX() < this.getX() + this.image.width)
        && (this.getX() < this.image.width + other.getX())
        && (this.getY() + other.image.height > other.getY())
        && (other.getY() + other.image.height > this.getY())) {
      return true;
    }
    return false;
  }

}
