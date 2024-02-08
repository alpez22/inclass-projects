//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title: Treasure Hunt - DraggableObject
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
 * This class models a draggable object. A draggable object is a clickable interactive object which
 * can follow the mouse moves when being dragged.
 */
public class DraggableObject extends InteractiveObject {

  private boolean isDragging;
  private int oldMouseX;
  private int oldMouseY;

  /**
   * Creates a new Draggable object with a given name, x and y position, and "Drag Me!" as a default
   * message.
   */
  public DraggableObject(String name, int x, int y) {
    super(name, x, y, "Drag Me!");
  }

  /**
   * Creates a new Draggable object with a given name, x and y position, and a specific message.
   */
  public DraggableObject(String name, int x, int y, String message) {
    super(name, x, y, message);
  }

  /**
   * Checks whether this draggable object is being dragged.
   * 
   * @return true if this object is being dragged, false otherwise
   */
  public boolean isDragging() {
    if (isDragging == true) {
      return true;
    }
    return false;
  }

  /**
   * Starts dragging this draggable object and updates the oldMouseX and oldMouseY positions to the
   * current position of the mouse.
   */
  public void startDragging() {
    isDragging = true;
    this.oldMouseX = processing.mouseX;
    this.oldMouseY = processing.mouseY; // or super.getY()
  }

  /**
   * Stops dragging this draggable object
   */
  public void stopDragging() {
    isDragging = false;
  }

  /**
   * Draws this draggable object to the display window. If this object is dragging, this method sets
   * its position to follow the mouse moves. Then, it draws its image to the its current position.
   */
  @Override
  public void draw() {
    if (isDragging()) {
      move​(processing.mouseX - this.oldMouseX, processing.mouseY - this.oldMouseY);
      this.oldMouseX = processing.mouseX;
      this.oldMouseY = processing.mouseY;
    }
    processing.image(image, super.getX(), super.getY());
  }

  /**
   * Starts dragging this object when it is clicked (meaning when the mouse is over it).
   */
  @Override
  public void mousePressed() {
    if (super.isMouseOver()) {
      startDragging();
    }
  }

  /**
   * Stops dragging this object if the mouse is released
   */
  @Override
  public void mouseReleased() {
    if (isDragging()) {
      stopDragging();
    }
  }
}
