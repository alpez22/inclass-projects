//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title: Water Fountain
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
import java.util.Random;
import java.io.File;
import processing.core.PImage;

/**
 * This class uses a GUI that creates a fountain that shoots out water droplets
 */
public class Fountain {

  private static Random randGen; // random variable
  private static PImage fountainImage; // fountain image
  private static int positionX; // position of fountain, x
  private static int positionY; // position of fountain, y
  private static Droplet[] droplets; // droplet array
  private static int startColor; // blue: Utility.color(23,141,235)
  private static int endColor; // lighter blue: Utility.color(23,200,255)

  /**
   * This program is initialized by this main method which then runs the Utility.runApplication()
   *
   * @param args
   */
  public static void main(String[] args) {
    Utility.runApplication(); // starts the application
  }

  /**
   * the setup() method runs the tester methods, initializes static fields, and sets the droplet
   * array to 800
   */
  public static void setup() {

    testUpdateDroplet();
    testRemoveOldDroplets();

    randGen = new Random();
    positionX = Utility.width() / 2;
    positionY = Utility.height() / 2;
    startColor = Utility.color(23, 141, 235);
    endColor = Utility.color(23, 200, 255);

    // load the image of the fountain
    fountainImage = Utility.loadImage("images" + File.separator + "fountain.png");

    // initializes droplets field to a new droplet array containing a reference to droplet object
    droplets = new Droplet[800];
  }

  /**
   * the draw() method is constantly running and draws the contents within the GUI
   */
  public static void draw() {

    Utility.background(Utility.color(253, 245, 230));
    Utility.fill(Utility.color(23, 141, 235));

    // Draw the fountain image to the screen at position (positionX, positionY)
    Utility.image(fountainImage, positionX, positionY);

    createNewDroplets(10);
    for (int i = 0; i < droplets.length; i++) {
      if (droplets[i] != null) {
        updateDroplet(i);
      }
    }
    removeOldDroplets(80);
  }

  /**
   * the updateDroplet() method updates the Y velocity, (x & y) position, and age of a droplet after
   * it is drawn and filled with color and transparency
   * 
   * @param index the index of the droplet that is being updated
   */
  private static void updateDroplet(int index) {

    Utility.fill(droplets[index].getColor(), droplets[index].getTransparency());
    Utility.circle(droplets[index].getPositionX(), droplets[index].getPositionY(),
        droplets[index].getSize());

    // causes droplet to sweep out a parabola
    droplets[index].setVelocityY(droplets[index].getVelocityY() + 0.3f);

    // sets the position of the droplet x & y to move
    droplets[index].setPositionX(droplets[index].getPositionX() + droplets[index].getVelocityX());
    droplets[index].setPositionY(droplets[index].getPositionY() + droplets[index].getVelocityY());

    // sets the age of the droplet and increments it each time it's called
    droplets[index].setAge(droplets[index].getAge() + 1);
  }

  /**
   * the createNewDroplets() method iterates over the droplets array and adds the number of droplets
   * wanted (which is inputted into the parameter) within the droplets array
   * 
   * @param numNewDroplets the amount of droplets that want to be added
   */
  private static void createNewDroplets(int numNewDroplets) {

    int counter = 0;

    for (int i = droplets.length - 1; i >= 0; i--) {
      if (droplets[i] == null && counter != numNewDroplets) {

        droplets[i] = new Droplet();

        droplets[i].setPositionX(positionX + randGen.nextFloat() * 6 - 3);
        droplets[i].setPositionY(positionY + randGen.nextFloat() * 6 - 3);

        droplets[i].setSize(randGen.nextFloat() * 7 + 4);

        droplets[i].setVelocityX(randGen.nextFloat() * 2 - 1);
        droplets[i].setVelocityY(randGen.nextFloat() * (-5) - 5);

        droplets[i].setAge(randGen.nextInt(41));

        droplets[i].setColor(Utility.lerpColor(startColor, endColor, randGen.nextFloat()));
        droplets[i].setTransparency(randGen.nextInt(96) + 32);

        counter++;

        if (counter == numNewDroplets) {
          break;
        }
      }
    }
  }

  /**
   * the removeOldDroplets() method removes the old droplets that exceed the age given in the
   * parameter (this inevitably causes the fountain to never stop running)
   * 
   * @param maxAge The max age a droplet can be before being removed
   */
  private static void removeOldDroplets(int maxAge) {

    for (int i = 0; i < droplets.length; i++) {
      if (droplets[i] != null && droplets[i].getAge() > maxAge) {
        droplets[i] = null;
      }
    }
  }

  /**
   * the mousePressed() method is a callback method that is called to change the position, x and y,
   * of the fountain and droplets whenever the mouse is pressed
   */
  public static void mousePressed() {

    Fountain.positionX = Utility.mouseX();
    Fountain.positionY = Utility.mouseY();
  }

  /**
   * the keyPressed() method is a callback method that takes a screenshot of the fountain if the
   * input keyPressed is a lower or upper case letter "s"
   * 
   * @param keyPressed The keyboard key that is pressed
   */
  public static void keyPressed(char keyPressed) {

    if (keyPressed == 's' || keyPressed == 'S') {
      Utility.save("screenshot.png");
    }
  }

  /**
   * This tester initializes the droplets array to hold at least three droplets. Creates a single
   * droplet at position (3,3) with velocity (-1,-2). Then checks whether calling updateDroplet() on
   * this droplet’s index correctly results in changing its position to (2.0, 1.3).
   *
   * @return true when no defect is found, and false otherwise
   */
  private static boolean testUpdateDroplet() {

    droplets = new Droplet[] {new Droplet(), new Droplet(), new Droplet(), null, null};
    droplets[0].setPositionX(3);
    droplets[0].setPositionY(3);
    droplets[0].setVelocityX(-1);
    droplets[0].setVelocityY(-2);
    updateDroplet(0);
    if (!(Math.abs(droplets[0].getPositionX() - 2.0) < 0.001)
        && !(Math.abs(droplets[0].getPositionY() - 1.3) < 0.001)) {
      System.out.println("Problem detected: Your updateDroplet() method "
          + "failed to return the expected output");
      return false;
    }

    return true;
  }

  /**
   * This tester initializes the droplets array to hold at least three droplets. Calls
   * removeOldDroplets(6) on an array with three droplets (two of which have ages over six and
   * another that does not). Then checks whether the old droplets were removed and the young droplet
   * was left alone.
   *
   * @return true when no defect is found, and false otherwise
   */
  private static boolean testRemoveOldDroplets() {

    droplets = new Droplet[] {new Droplet(), new Droplet(), new Droplet(), null, null};
    droplets[0].setAge(7);
    droplets[1].setAge(10);
    droplets[2].setAge(3);
    removeOldDroplets(6);
    if (droplets[0] != null && droplets[1] != null && droplets[2] == null) {
      System.out.println("Problem detected: Your removeOldDroplets() method "
          + "failed to return the expected output");
      return false;
    }
    return true;
  }
}
