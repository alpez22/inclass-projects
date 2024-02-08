// --== CS400 Fall 2022 File Header Information ==--
// Name: Ava Pezza
// Email: apezza@wisc.edu
// Team: df
// TA: April Roszkowski
// Lecturer: Florian
// Notes to Grader: n/a
import java.util.LinkedList;
import java.util.NoSuchElementException;
import java.util.Random;
import java.util.Stack;

/**
 * Red-Black Tree implementation with a Node inner class for representing the nodes of the tree.
 * Currently, this implements a Binary Search Tree that we will turn into a red black tree by
 * modifying the insert functionality. In this activity, we will start with implementing rotations
 * for the binary search tree insert algorithm. You can use this class' insert method to build a
 * regular binary search tree, and its toString method to display a level-order traversal of the
 * tree.
 */
public class RedBlackTree<T extends Comparable<T>> {

  /**
   * This class represents a node holding a single value within a binary tree the parent, left, and
   * right child references are always maintained.
   */
  protected static class Node<T> {
    public T data;
    public Node<T> parent; // null for root node
    public Node<T> leftChild;
    public Node<T> rightChild;

    public Node(T data) {
      this.data = data;
    }

    // default node object as red
    public int blackHeight = 0; // track the black height only fro the current node: 0 = red, 1 =
                                // black, 2 = double-black

    /**
     * @return true when this node has a parent and is the left child of that parent, otherwise
     *         return false
     */
    public boolean isLeftChild() {
      return parent != null && parent.leftChild == this;
    }

  }

  protected Node<T> root; // reference to root node of tree, null when empty
  protected int size = 0; // the number of values in the tree

  /**
   * Performs a naive insertion into a binary search tree: adding the input data value to a new node
   * in a leaf position within the tree. After this insertion, no attempt is made to restructure or
   * balance the tree. This tree will not hold null references, nor duplicate data values.
   * 
   * @param data to be added into this binary search tree
   * @return true if the value was inserted, false if not
   * @throws NullPointerException     when the provided data argument is null
   * @throws IllegalArgumentException when the newNode and subtree contain equal data references
   */
  public boolean insert(T data) throws NullPointerException, IllegalArgumentException {
    // null references cannot be stored within this tree
    if (data == null)
      throw new NullPointerException("This RedBlackTree cannot store null references.");

    Node<T> newNode = new Node<>(data);
    if (root == null) {
      root = newNode;
      size++;
      root.blackHeight = 1; // set the root node of the tree to be black
      return true;
    } // add first node to an empty tree
    else {
      boolean returnValue = insertHelper(newNode, root); // recursively insert into subtree
      if (returnValue)
        size++;
      else
        throw new IllegalArgumentException("This RedBlackTree already contains that value.");
      root.blackHeight = 1; // set the root node of the tree to be black
      return returnValue;
    }
  }

  /**
   * Recursive helper method to find the subtree with a null reference in the position that the
   * newNode should be inserted, and then extend this tree by the newNode in that position.
   * 
   * @param newNode is the new node that is being added to this tree
   * @param subtree is the reference to a node within this tree which the newNode should be inserted
   *                as a descenedent beneath
   * @return true is the value was inserted in subtree, false if not
   */
  private boolean insertHelper(Node<T> newNode, Node<T> subtree) {
    int compare = newNode.data.compareTo(subtree.data);
    // do not allow duplicate values to be stored within this tree
    if (compare == 0)
      return false;

    // store newNode within left subtree of subtree
    else if (compare < 0) {
      if (subtree.leftChild == null) { // left subtree empty, add here
        subtree.leftChild = newNode;
        newNode.parent = subtree;
        enforceRBTreePropertiesAfterInsert(newNode); //check properties after successfully adding a new node
        return true;
        // otherwise continue recursive search for location to insert
      } else
        return insertHelper(newNode, subtree.leftChild);
    }

    // store newNode within the right subtree of subtree
    else {
      if (subtree.rightChild == null) { // right subtree empty, add here
        subtree.rightChild = newNode;
        newNode.parent = subtree;
        enforceRBTreePropertiesAfterInsert(newNode); //check properties after successfully adding a new node
        return true;
        // otherwise continue recursive search for location to insert
      } else
        return insertHelper(newNode, subtree.rightChild);
    }
  }

  /**
   * This method is to resolve any red-black tree property violations that are introduced by
   * inserting each new new node into a red-black tree
   * Rule 1: every node is either red or black
   * Rule 2: The root node is black
   * Rule 3: No red nodes can have red children
   * Rule 4: Every path from root to a leaf has the same number of black nodes (black height of tree)
   * 
   * @param newNode is the new node that is being added to this tree
   */
  protected void enforceRBTreePropertiesAfterInsert(Node<T> newNode) {
    
    Node<T> parent = newNode.parent;
    
    // Case 1: parent is null and we are at the root (which should be black)
    if(parent == null) {
      newNode.blackHeight = 1;
      return;
    }
    
    // if parent is black, there would be no property violation needing to check
    if(parent.blackHeight == 1) {
      return;
    }
    
    // Parent should now always be treated as red
    Node<T> grandParent = newNode.parent.parent;
    
    // Case 2: grandparent is null and the parent is the root (which should be black)
    if(grandParent == null) {
      parent.blackHeight = 1;
      return;
    }
    
    Node<T> aunt = getAunt(parent);
    // Case 3: aunt is red ==> repair by recoloring
    if(aunt != null && aunt.blackHeight == 0) {
      
      grandParent.blackHeight = 0; //grandparent should recolor to red
      parent.blackHeight = 1; // parent should recolor to black
      aunt.blackHeight = 1; // aunt should recolor to black as well
      
      // grandparent is now red ==> ^check (there might be another property violation present)
      enforceRBTreePropertiesAfterInsert(grandParent);
    }
    // Case 4: aunt is black ==> repair by rotating and colorswaps
    else if(grandParent.leftChild == parent) {
      
      // Case 4a. newNode has a left, right relation
      if(parent.rightChild == newNode) {
        rotate(newNode, parent); //should rotate left around parent
        
        // child/newNode is the new parent now, inorder to recolor correctly in next step, 
        // parent must now point to the child
        parent = newNode;
      }
      
      // Case 4b. newNode has a left, left relation
      rotate(parent, grandParent); //should rotate right around grandparent
      //recolor parent and grandparent
      parent.blackHeight = 1; // parent should recolor to black
      grandParent.blackHeight = 0; // grandparent should recolor to red
    }
    // parent is right child of grandparent
    else {
      
      // Case 4c. newNode has a right, left relation
      if(parent.leftChild == newNode) {
        rotate(newNode, parent); // should rotate right around parent
        
        // child/newNode is the new parent now, inorder to recolor correctly in next step, 
        // parent must now point to the child
        parent = newNode;
      }
      
      // Case 4d. newNode has a right, right relation
      rotate(parent, grandParent); // should rotate left around grandparent
      //recolor parent and grandparent
      parent.blackHeight = 1; // parent should recolor to black
      grandParent.blackHeight = 0; // grandparent should recolor to red
    }
  }
  
  /**
   * This method is used to retrieve the correct aunt based on the position of the parent
   * 
   * @param parent is the node that retrieving the aunt is taken from
   */
  private Node<T> getAunt(Node<T> parent){
    
    Node<T> grandParent = parent.parent;
    if(grandParent.leftChild == parent) {
      return grandParent.rightChild;
    }
    else if(grandParent.rightChild == parent) {
      return grandParent.leftChild;
    }
    else {
      throw new IllegalStateException("Parent is not a right or left child of grandparent");
    }
  }


  /**
   * Performs the rotation operation on the provided nodes within this tree. When the provided child
   * is a leftChild of the provided parent, this method will perform a right rotation. When the
   * provided child is a rightChild of the provided parent, this method will perform a left
   * rotation. When the provided nodes are not related in one of these ways, this method will throw
   * an IllegalArgumentException.
   * 
   * @param child  is the node being rotated from child to parent position (between these two node
   *               arguments)
   * @param parent is the node being rotated from parent to child position (between these two node
   *               arguments)
   * @throws IllegalArgumentException when the provided child and parent node references are not
   *                                  initially (pre-rotation) related that way
   */
private void rotate(Node<T> child, Node<T> parent) throws IllegalArgumentException {
  
  if (child == null || parent == null)
    throw new NullPointerException("neither child nor parent can be null");
  Node<T> grandparent = parent.parent;
  if (child.equals(parent.leftChild)) {
    // do a right rotation
    if (grandparent == null) {
      // parent is the root node
      this.root = child;
    } else {
      if (parent.isLeftChild()) {
        grandparent.leftChild = child;
      } else {
        grandparent.rightChild = child;
      }
    }
    Node<T> childRight = child.rightChild;
    child.rightChild = parent;
    parent.leftChild = childRight;
  } else if (child.equals(parent.rightChild)) {
    // do a left rotation
    if (grandparent == null) {
      // parent is root
      this.root = child;
    } else {
      if (parent.isLeftChild()) {
        grandparent.leftChild = child;
      } else {
        grandparent.rightChild = child;
      }
    }
    Node<T> childLeft = child.leftChild;
    child.leftChild = parent;
    parent.rightChild = childLeft;
  } else {
    throw new IllegalArgumentException("child has to be child of parent");
  }
}

  /**
   * Get the size of the tree (its number of nodes).
   * 
   * @return the number of nodes in the tree
   */
  public int size() {
    return size;
  }

  /**
   * Method to check if the tree is empty (does not contain any node).
   * 
   * @return true of this.size() return 0, false if this.size() > 0
   */
  public boolean isEmpty() {
    return this.size() == 0;
  }

  /**
   * Checks whether the tree contains the value *data*.
   * 
   * @param data the data value to test for
   * @return true if *data* is in the tree, false if it is not in the tree
   */
  public boolean contains(T data) {
    // null references will not be stored within this tree
    if (data == null)
      throw new NullPointerException("This RedBlackTree cannot store null references.");
    return this.containsHelper(data, root);
  }

  /**
   * Recursive helper method that recurses through the tree and looks for the value *data*.
   * 
   * @param data    the data value to look for
   * @param subtree the subtree to search through
   * @return true of the value is in the subtree, false if not
   */
  private boolean containsHelper(T data, Node<T> subtree) {
    if (subtree == null) {
      // we are at a null child, value is not in tree
      return false;
    } else {
      int compare = data.compareTo(subtree.data);
      if (compare < 0) {
        // go left in the tree
        return containsHelper(data, subtree.leftChild);
      } else if (compare > 0) {
        // go right in the tree
        return containsHelper(data, subtree.rightChild);
      } else {
        // we found it :)
        return true;
      }
    }
  }


  /**
   * This method performs an inorder traversal of the tree. The string representations of each data
   * value within this tree are assembled into a comma separated string within brackets (similar to
   * many implementations of java.util.Collection, like java.util.ArrayList, LinkedList, etc). Note
   * that this RedBlackTree class implementation of toString generates an inorder traversal. The
   * toString of the Node class class above produces a level order traversal of the nodes / values
   * of the tree.
   * 
   * @return string containing the ordered values of this tree (in-order traversal)
   */
  public String toInOrderString() {
    // generate a string of all values of the tree in (ordered) in-order
    // traversal sequence
    StringBuffer sb = new StringBuffer();
    sb.append("[ ");
    sb.append(toInOrderStringHelper("", this.root));
    if (this.root != null) {
      sb.setLength(sb.length() - 2);
    }
    sb.append(" ]");
    return sb.toString();
  }

  private String toInOrderStringHelper(String str, Node<T> node) {
    if (node == null) {
      return str;
    }
    str = toInOrderStringHelper(str, node.leftChild);
    str += (node.data.toString() + ", ");
    str = toInOrderStringHelper(str, node.rightChild);
    return str;
  }

  /**
   * This method performs a level order traversal of the tree rooted at the current node. The string
   * representations of each data value within this tree are assembled into a comma separated string
   * within brackets (similar to many implementations of java.util.Collection). Note that the Node's
   * implementation of toString generates a level order traversal. The toString of the RedBlackTree
   * class below produces an inorder traversal of the nodes / values of the tree. This method will
   * be helpful as a helper for the debugging and testing of your rotation implementation.
   * 
   * @return string containing the values of this tree in level order
   */
  public String toLevelOrderString() {
    String output = "[ ";
    if (this.root != null) {
      LinkedList<Node<T>> q = new LinkedList<>();
      q.add(this.root);
      while (!q.isEmpty()) {
        Node<T> next = q.removeFirst();
        if (next.leftChild != null)
          q.add(next.leftChild);
        if (next.rightChild != null)
          q.add(next.rightChild);
        output += next.data.toString();
        if (!q.isEmpty())
          output += ", ";
      }
    }
    return output + " ]";
  }

  public String toString() {
    return "level order: " + this.toLevelOrderString() + "\nin order: " + this.toInOrderString();
  }
}
