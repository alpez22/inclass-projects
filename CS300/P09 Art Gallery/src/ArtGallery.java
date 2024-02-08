//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title: ArtGallery
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
import java.util.ArrayList;
import java.util.NoSuchElementException;

/**
 * This class models the Artwork Gallery implemented as a binary search tree. The search criteria
 * include the year of creation of the artwork, the name of the artwork and its cost.
 * 
 * @author Ava Pezza
 *
 */
public class ArtGallery {

  private BSTNode<Artwork> root; // root node of the artwork catalog BST
  private int size; // size of the artwork catalog tree

  public ArtGallery() {
    this.root = null;
    this.size = 0;
  }

  /**
   * Checks whether this binary search tree (BST) is empty
   * 
   * @return true if this ArtworkGallery is empty, false otherwise
   */
  public boolean isEmpty() {
    return this.size == 0 && this.root == null;
  }

  /**
   * Returns the number of artwork pieces stored in this BST.
   * 
   * @return the size of this ArtworkGallery
   */
  public int size() {
    return this.size;
  }

  /**
   * Checks whether this ArtworkGallery contains a Artwork given its name, year, and cost.
   * 
   * @param name name of the Artwork to search
   * @param year year of creation of the Artwork to search
   * @param cost cost of the Artwork to search
   * @return true if there is a match with this Artwork in this BST, and false otherwise
   */
  public boolean lookup(String name, int year, double cost) {
    // Hint: create a new artwork with the provided name and year and default cost and use it in the
    // search operation

    // TODO complete the implementation of this method
    Artwork target = new Artwork(name, year, cost);

    return lookupHelper(target, root);

  }

  /**
   * Recursive helper method to search whether there is a match with a given Artwork in the subtree
   * rooted at current
   * 
   * @param target  a reference to a Artwork we are searching for a match in the BST rooted at
   *                current.
   * @param current "root" of the subtree we are checking whether it contains a match to target.
   * @return true if match found and false otherwise
   */
  protected static boolean lookupHelper(Artwork target, BSTNode<Artwork> current) {
    // TODO complete the implementation of this method

    // BASE CASE 1
    if (current == null)
      return false;

    // BASE CASE 2
    if (target == current.getData())
      return true;

    // RECURSIVE CASE
    int compare = current.getData().compareTo(target);
    if (compare < 0) {
      return lookupHelper(target, current.getRight());
    } else if (compare > 0){
      return lookupHelper(target, current.getLeft());
    }
    return true;
  }

  /**
   * Adds a new artwork piece to this ArtworkGallery
   * 
   * @param newArtwork a new Artwork to add to this BST (gallery of artworks).
   * @return true if the newArtwork was successfully added to this gallery, and returns false if
   *         there is a match with this Artwork already stored in gallery.
   * @throws NullPointerException if newArtwork is null
   */
  public boolean addArtwork(Artwork newArtwork) {
    // TODO complete the implementation of this method
    if (newArtwork == null) {
      throw new NullPointerException("Error");
    }
    // newArtwork = new Artwork(newArtwork.getName(), newArtwork.getYear(), newArtwork.getCost());
    if (root == null) {
        root = new BSTNode<Artwork>(newArtwork);
        size++;
        return true;
      } else {
        boolean added = addArtworkHelper(newArtwork, root);
        if(added) {
          size++;
        }
        return added;
      }
  }

  /**
   * Recursive helper method to add a new Artwork to an ArtworkGallery rooted at current.
   * 
   * @param current    The "root" of the subtree we are inserting new Artwork into.
   * @param newArtwork The Artwork to be added to a BST rooted at current.
   * @return true if the newArtwork was successfully added to this ArtworkGallery, false if a match
   *         with newArtwork is already present in the subtree rooted at current.
   */
  protected static boolean addArtworkHelper(Artwork newArtwork, BSTNode<Artwork> current) {
    // TODO complete the implementation of this method

    Artwork currentArtwork = current.getData();
    if (newArtwork.compareTo(currentArtwork) == 0) {
      return false;
    } 
    // is this value greater or less than the current node
    int compare = currentArtwork.compareTo(newArtwork);
    if (compare < 0) {
      // Greater: go to right child if compare is < 0
      if (current.getRight() == null) {
        current.setRight(new BSTNode<Artwork>(newArtwork));
        return true;
      } else {
        // insert right
        // recursive case
        return addArtworkHelper(newArtwork, current.getRight());
      }
    } else if (compare > 0){
      // Less: go to the child left
      if (current.getLeft() == null) {
        current.setLeft(new BSTNode<Artwork>(newArtwork));
        return true;
      } else {
        return addArtworkHelper(newArtwork, current.getLeft());
      }
    }
    return true;
  }

  /**
   * Gets the recent best Artwork in this BST (meaning the largest artwork in this gallery)
   * 
   * @return the best (largest) Artwork (the most recent, highest cost artwork) in this
   *         ArtworkGallery, and null if this tree is empty.
   */
  public Artwork getBestArtwork() {

    if (root == null) {
      return null;
    }
    // means that compareTo > 0

    // keep going through tree until leave is reached after only choosing right child
    // if there is no right child it means that the root is the largest value
    BSTNode<Artwork> current = root;
    if (current.getRight() == null) {
      return root.getData();
    } else {
      while (current.getRight() != null) {
        current = current.getRight();
      }
    }
    return current.getData();
  }

  /**
   * Returns a String representation of all the artwork stored within this BST in the increasing
   * order of year, separated by a newline "\n". For instance
   * 
   * "[(Name: Stars, Artist1) (Year: 1988) (Cost: $300.0)]" + "\n" + "[(Name: Sky, Artist1) (Year:
   * 2003) (Cost: $550.0)]" + "\n"
   * 
   * @return a String representation of all the artwork stored within this BST sorted in an
   *         increasing order with respect to the result of Artwork.compareTo() method (year, cost,
   *         name). Returns an empty string "" if this BST is empty.
   */
  @Override
  public String toString() {
    return toStringHelper(root);
  }

  /**
   * Recursive helper method which returns a String representation of the BST rooted at current. An
   * example of the String representation of the contents of a ArtworkGallery is provided in the
   * description of the above toString() method.
   * 
   * @param current reference to the current Artwork within this BST (root of a subtree)
   * @return a String representation of all the artworks stored in the sub-tree rooted at current in
   *         increasing order with respect to the result of Artwork.compareTo() method (year, cost,
   *         name). Returns an empty String "" if current is null.
   */
  protected static String toStringHelper(BSTNode<Artwork> current) {
    // TODO complete the implementation of this method
    String bstString = "";
    // BST wont have duplicates however what if same year, then compare to: if this.compareto(other)
    // > 0 other goes second
    if (current != null) {
      bstString = toStringHelper(current.getLeft());
      bstString += current.getData().toString();
      bstString += toStringHelper(current.getRight());
    }
    return bstString;
  }

  /**
   * Computes and returns the height of this BST, counting the number of NODES from root to the
   * deepest leaf.
   * 
   * @return the height of this Binary Search Tree
   */
  public int height() {
    return heightHelper(root);
  }

  /**
   * Recursive helper method that computes the height of the subtree rooted at current counting the
   * number of nodes and NOT the number of edges from current to the deepest leaf
   * 
   * @param current pointer to the current BSTNode within a ArtworkGallery (root of a subtree)
   * @return height of the subtree rooted at current
   */
  protected static int heightHelper(BSTNode<Artwork> current) {
    if (current == null) {
      return 0;
    } else {
      // calculate depth of each subtree
      int leftH = heightHelper(current.getLeft());
      int rightH = heightHelper(current.getRight());
      // print larger
      if (leftH > rightH) {
        return leftH + 1;
      } else {
        return rightH + 1;
      }
    }
  }

  /**
   * Search for all artwork objects created on a given year and have a maximum cost value.
   * 
   * @param year creation year of artwork
   * @param cost the maximum cost we would like to search for a artwork
   * @return a list of all the artwork objects whose year equals our lookup year key and maximum
   *         cost. If no artwork satisfies the lookup query, this method returns an empty arraylist
   */
  public ArrayList<Artwork> lookupAll(int year, double cost) {
    if(root == null) {
      return null;
    }
    ArrayList<Artwork> artworks = lookupAllHelper(year,cost,root);
    if(artworks.size() == 0) {
      return null;
    }
    return lookupAllHelper(year, cost, root);
  }

  /**
   * Recursive helper method to lookup the list of artworks given their year of creation and a
   * maximum value of cost
   * 
   * @param year    the year we would like to search for a artwork
   * @param cost    the maximum cost we would like to search for a artwork
   * @param current "root" of the subtree we are looking for a match to find within it.
   * @return a list of all the artwork objects whose year equals our lookup year key and maximum
   *         cost stored in the subtree rooted at current. If no artwork satisfies the lookup query,
   *         this method returns an empty arraylist
   */
  protected static ArrayList<Artwork> lookupAllHelper(int year, double cost,
      BSTNode<Artwork> current) {
    // TODO complete the implementation of this method

    ArrayList<Artwork> keyVals = new ArrayList<Artwork>();
    if (current.getData().getYear() == year && current.getData().getCost() <= cost) {
      keyVals.add(current.getData());
    }
    
     if(current.getData().getYear() < year) {
        if(current.getRight() != null) {
          keyVals.addAll(lookupAllHelper(year, cost, current.getRight()));
        }
      }else if(current.getData().getYear() > year) {
        if(current.getLeft() != null) {
          keyVals.addAll(lookupAllHelper(year, cost, current.getLeft()));
        }
      }else if(current.getData().getYear() == year) {
        if(current.getRight() != null) {
          keyVals.addAll(lookupAllHelper(year, cost, current.getRight()));
        }
        if(current.getLeft() != null) {
          keyVals.addAll(lookupAllHelper(year, cost, current.getLeft()));
        }
      }
    return keyVals;
  }

  /**
   * Buy an artwork with the specified name, year and cost. In terms of BST operation, this is
   * equivalent to finding the specific node and deleting it from the tree
   * 
   * @param name name of the artwork, artist
   * @param year creation year of artwork
   * @throws a NoSuchElementException with a descriptive error message if there is no Artwork found
   *           with the buying criteria
   */

  public void buyArtwork(String name, int year, double cost) {
    Artwork artwork = new Artwork(name, year, cost);
    if(!lookup(name, year, cost)) {
      throw new NoSuchElementException();
    }
    root = buyArtworkHelper(artwork, root);
    size--;
  }

  /**
   * Recursive helper method to buy artwork given the name, year and cost. In terms of BST
   * operation, this is equivalent to finding the specific node and deleting it from the tree
   * 
   * @param target  a reference to a Artwork we are searching to remove in the BST rooted at
   *                current.
   * @param current "root" of the subtree we are checking whether it contains a match to target.
   * @return the new "root" of the subtree we are checking after trying to remove target
   * @throws a NoSuchElementException with a descriptive error message if there is no Artwork found
   *           with the buying criteria in the BST rooted at current
   */
  protected static BSTNode<Artwork> buyArtworkHelper(Artwork target, BSTNode<Artwork> current) {
    // TODO complete the implementation of this method. Problem decomposition and hints are provided
    // in the comments below

    // if current == null (empty subtree rooted at current), no match found, throw an exception
    if (current == null) {
      throw new NoSuchElementException();
    }

    BSTNode<Artwork> currentParent = current;
    // Compare the target to the data at current and proceed accordingly
    // Recurse on the left or right subtree with respect to the comparison result
    // Make sure to use the output of the recursive call to appropriately set the left or the
    // right child of current accordingly
    if (current.getData().compareTo(target) < 0) {
      // means that target will be older, cheaper, earlier in alphabet i.e. left child
      // set current to the left child and call recursion again
      currentParent = current;
      current = current.getLeft();
      return buyArtworkHelper(target, current);
    } else if (current.getData().compareTo(target) > 0) {
      // means that target will be younger, more expensive, later in alphabet i.e. right child
      currentParent = current;
      current = current.getRight();
      return buyArtworkHelper(target, current);
    } else {
      // if match with target found, three cases should be considered. Feel free to organize the
      // order
      // of these cases at your choice.

      // (1) current may be a leaf (has no children), set current to null.
      if (current.getLeft() == null && current.getRight() == null) {
        current = null;
        return current;
      }

      // (2) current may have only one child, set current to that child (whether left or right
      // child)
      if (current.getLeft() == null && current.getRight() != null) {
        current = current.getRight();
        return current;
      } else if (current.getLeft() != null && current.getRight() == null) {
        current = current.getLeft();
        return current;
      }

      // (3) current may have two children,
      // Replace current with a new BSTNode whose data field value is the successor of target in the
      // tree, and having the same left and right children as current. Notice carefully that you
      // cannot
      // set the data of a BSTNode.
      // The successor is the smallest element at the right subtree of current
      // Then, remove the successor from the right subtree. The successor must have up to one child.
      if (current.getLeft() != null && current.getRight() != null) {
        // Replace current with a new BSTNode whose data field value is the successor of target in
        // the tree: current = new BSTNode<Artwork>(successorVal);
        
        // find successor's parent without affecting the current node
        BSTNode<Artwork> tempNode = current;
        BSTNode<Artwork> successorParent = current;
        if (tempNode.getRight() != null) {
          tempNode = tempNode.getRight();
          while (tempNode.getLeft() != null) {
            successorParent = tempNode;
            tempNode = tempNode.getLeft();
          }
        }
        
        //find successor
        Artwork successorVal = getSuccessor(current);
        
        //point parent of target's node to the node of the successor
        //currentParent
        BSTNode<Artwork> targetLeftChild = current.getLeft();
        BSTNode<Artwork> targetRightChild = current.getRight();
        
        current = new BSTNode<Artwork>(successorVal);
        
        current.setLeft(targetLeftChild);
        current.setRight(targetRightChild);
        if(currentParent.getData().compareTo(current.getData()) < 0) {
       // means that current will be older, cheaper, earlier in alphabet i.e. left child
          currentParent.setLeft(current);
        }else if(currentParent.getData().compareTo(current.getData()) > 0) {
          currentParent.setRight(current);
        }
        
        //point parent of target's node to the node of the successor
        
        // when successor does NOT have a child
        if(current.getRight() == null) {
          
        }

        // what if successor has a child?
        // check if successor's right child is null or not
        // set successor's parent's left child to the successors right child node
        if (current.getRight() != null) {
          successorParent.setLeft(current);
        }
        
        return current;
      }

      // Make sure to return current (the new root to this subtree) at the end of each case or at
      // the end of the method.
    }

    // TODO fill in return statements & do we have to delete anything or just reassign it

    return current;

  }

  /**
   * Helper method to find the successor of a node while performing a delete operation (buyArtwork)
   * The successor is defined as the smallest key in the right subtree. We assume by default that
   * node is not null
   * 
   * @param node node whose successor is to be found in the tree
   * @return return the key of the successor node
   */

  protected static Artwork getSuccessor(BSTNode<Artwork> node) {
    // TODO complete the implementation of this method
    BSTNode<Artwork> successorParent = node;
    if (node.getRight() != null) {
      node = node.getRight();
      while (node.getLeft() != null) {
        successorParent = node;
        node = node.getLeft();
      }
    }
    return node.getData();
  }
}
