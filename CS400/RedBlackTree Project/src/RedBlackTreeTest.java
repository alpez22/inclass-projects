// --== CS400 Fall 2022 File Header Information ==--
// Name: Ava Pezza
// Email: apezza@wisc.edu
// Team: df
// TA: April Roszkowski
// Lecturer: Florian
// Notes to Grader: n/a
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;

/**
 * This JUnit Red-Black Tree test is meant to make sure that the RBT property violations are
 * followed when inserting a new node into a tree. The new method being tested is
 * enforceRBTreePropertiesAfterInsert().
 */
public class RedBlackTreeTest {

  /**
   * Testing the red aunt case to make sure that the order when inserting a new node follow the
   * properties.
   */
  @Test
  public void TestRedAuntOrder() {

    // Case 1: left aunt
    RedBlackTree<Integer> tree = new RedBlackTree<Integer>();
    tree.insert(7);
    tree.insert(14);
    tree.insert(18);
    tree.insert(23);
    Assertions.assertEquals(tree.toLevelOrderString(), "[ 14, 7, 18, 23 ]");

    // Case 2: right aunt
    RedBlackTree<Integer> tree2 = new RedBlackTree<Integer>();
    tree2.insert(7);
    tree2.insert(6);
    tree2.insert(3);
    tree2.insert(2);
    Assertions.assertEquals(tree2.toLevelOrderString(), "[ 6, 3, 7, 2 ]");

    // Case 3: left aunt
    RedBlackTree<Integer> tree3 = new RedBlackTree<Integer>();
    tree3.insert(7);
    tree3.insert(14);
    tree3.insert(18);
    tree3.insert(9);
    Assertions.assertEquals(tree3.toLevelOrderString(), "[ 14, 7, 18, 9 ]");

    // Case 4: right aunt
    RedBlackTree<Integer> tree4 = new RedBlackTree<Integer>();
    tree4.insert(7);
    tree4.insert(5);
    tree4.insert(3);
    tree4.insert(6);
    Assertions.assertEquals(tree4.toLevelOrderString(), "[ 5, 3, 7, 6 ]");
  }

  /**
   * Testing the red aunt case to make sure that the coloring when inserting a new node follow the
   * properties.
   */
  @Test
  public void TestRedAuntColorFix() {
    // Case 1
    RedBlackTree<Integer> tree = new RedBlackTree<Integer>();
    tree.insert(7);
    tree.insert(14);
    tree.insert(18);
    tree.insert(23);
    Assertions.assertEquals(tree.root.data, 14);
    Assertions.assertEquals(tree.root.blackHeight, 1);
    Assertions.assertEquals(tree.root.rightChild.blackHeight, 1);
    Assertions.assertEquals(tree.root.leftChild.blackHeight, 1);
    Assertions.assertEquals(tree.root.rightChild.rightChild.blackHeight, 0);

    // Case 2
    RedBlackTree<Integer> tree2 = new RedBlackTree<Integer>();
    tree2.insert(7);
    tree2.insert(6);
    tree2.insert(3);
    tree2.insert(2);
    Assertions.assertEquals(tree2.root.data, 6);
    Assertions.assertEquals(tree2.root.blackHeight, 1);
    Assertions.assertEquals(tree2.root.rightChild.blackHeight, 1);
    Assertions.assertEquals(tree2.root.leftChild.blackHeight, 1);
    Assertions.assertEquals(tree2.root.leftChild.leftChild.blackHeight, 0);

    // Case 3
    RedBlackTree<Integer> tree3 = new RedBlackTree<Integer>();
    tree3.insert(7);
    tree3.insert(14);
    tree3.insert(18);
    tree3.insert(9);
    Assertions.assertEquals(tree3.root.data, 14);
    Assertions.assertEquals(tree3.root.blackHeight, 1);
    Assertions.assertEquals(tree3.root.rightChild.blackHeight, 1);
    Assertions.assertEquals(tree3.root.leftChild.blackHeight, 1);
    Assertions.assertEquals(tree3.root.leftChild.rightChild.blackHeight, 0);

    // Case 4
    RedBlackTree<Integer> tree4 = new RedBlackTree<Integer>();
    tree4.insert(7);
    tree4.insert(5);
    tree4.insert(3);
    tree4.insert(6);
    Assertions.assertEquals(tree4.root.data, 5);
    Assertions.assertEquals(tree4.root.blackHeight, 1);
    Assertions.assertEquals(tree4.root.rightChild.blackHeight, 1);
    Assertions.assertEquals(tree4.root.leftChild.blackHeight, 1);
    Assertions.assertEquals(tree4.root.rightChild.leftChild.blackHeight, 0);
  }

  /**
   * Testing the black aunt case to make sure that the order when inserting a new node follow the
   * properties.
   */
  @Test
  public void TestBlackAuntOrder() {

    // Case 1: left, left relation
    RedBlackTree<Integer> tree = new RedBlackTree<Integer>();
    tree.insert(7);
    tree.insert(14);
    tree.insert(18);
    Assertions.assertEquals(tree.toLevelOrderString(), "[ 14, 7, 18 ]");

    // Case 2: left, right relation
    tree.insert(23);
    tree.insert(1);
    tree.insert(11);
    tree.insert(20);
    Assertions.assertEquals(tree.toLevelOrderString(), "[ 14, 7, 20, 1, 11, 18, 23 ]");

    // Case 3: right, right relation
    RedBlackTree<Integer> tree2 = new RedBlackTree<Integer>();
    tree2.insert(7);
    tree2.insert(6);
    tree2.insert(3);
    Assertions.assertEquals(tree2.toLevelOrderString(), "[ 6, 3, 7 ]");

    // Case 4: right, left relation
    tree2.insert(1);
    tree2.insert(2);
    Assertions.assertEquals(tree2.toLevelOrderString(), "[ 6, 2, 7, 1, 3 ]");
  }

  /**
   * Testing the black aunt case to make sure that the coloring when inserting a new node follow the
   * properties.
   */
  @Test
  public void TestBlackAuntColorFix() {
    // Case 1
    RedBlackTree<Integer> tree = new RedBlackTree<Integer>();
    tree.insert(7);
    tree.insert(14);
    tree.insert(18);
    Assertions.assertEquals(tree.root.data, 14);
    Assertions.assertEquals(tree.root.blackHeight, 1);
    Assertions.assertEquals(tree.root.rightChild.blackHeight, 0);
    Assertions.assertEquals(tree.root.leftChild.blackHeight, 0);

    // Case 2
    tree.insert(23);
    tree.insert(1);
    tree.insert(11);
    tree.insert(20);
    Assertions.assertEquals(tree.root.data, 14);
    Assertions.assertEquals(tree.root.blackHeight, 1);
    Assertions.assertEquals(tree.root.rightChild.blackHeight, 1);
    Assertions.assertEquals(tree.root.leftChild.blackHeight, 1);
    Assertions.assertEquals(tree.root.rightChild.rightChild.blackHeight, 0);
    Assertions.assertEquals(tree.root.rightChild.leftChild.blackHeight, 0);
    Assertions.assertEquals(tree.root.leftChild.rightChild.blackHeight, 0);
    Assertions.assertEquals(tree.root.leftChild.leftChild.blackHeight, 0);

    // Case 3
    RedBlackTree<Integer> tree2 = new RedBlackTree<Integer>();
    tree2.insert(7);
    tree2.insert(6);
    tree2.insert(3);
    Assertions.assertEquals(tree2.root.data, 6);
    Assertions.assertEquals(tree2.root.blackHeight, 1);
    Assertions.assertEquals(tree2.root.rightChild.blackHeight, 0);
    Assertions.assertEquals(tree2.root.leftChild.blackHeight, 0);

    // Case 4
    tree2.insert(1);
    tree2.insert(2);
    Assertions.assertEquals(tree2.root.data, 6);
    Assertions.assertEquals(tree2.root.blackHeight, 1);
    Assertions.assertEquals(tree2.root.rightChild.blackHeight, 1);
    Assertions.assertEquals(tree2.root.leftChild.blackHeight, 1);
    Assertions.assertEquals(tree2.root.leftChild.rightChild.blackHeight, 0);
    Assertions.assertEquals(tree2.root.leftChild.leftChild.blackHeight, 0);
  }
}
