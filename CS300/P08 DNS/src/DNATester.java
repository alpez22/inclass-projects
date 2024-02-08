//////////////// FILE HEADER (INCLUDE IN EVERY FILE) //////////////////////////
//
// Title: DNA Tester
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
 * This class test methods to verify your implementation of the methods for P08.
 */
public class DNATester {
  
  /**
   * Tests the enqueue(T data) & dequeue() method
   * @return true if and only if the method works correctly
   */
  public static boolean testEnqueueDequeue() {
    
    //Enqueue
    try {
      LinkedQueue<Integer> queue1 = new LinkedQueue<>();
      queue1.enqueue(1);
      
      String expected = "1";
      int expectedSize = 1;
      
      if(!queue1.toString().split(" ")[0].equals(expected) || queue1.size() != expectedSize) {
        
        System.out.println("!" + queue1.toString().split(" ")[0]);
        return false;
      }
      
      queue1.enqueue(2);
      queue1.enqueue(3);
      
      expected = "3";
      expectedSize = 3;
      
      if(!queue1.toString().split(" ")[2].equals(expected) || queue1.size() != expectedSize) {
        return false;
      }
      
    }catch(Exception e) {
      e.printStackTrace();
      return false;
    }
    
    //Dequeue
    try {
      LinkedQueue<Integer> queue2 = new LinkedQueue<>();
      
      queue2.enqueue(1);
      queue2.enqueue(2);
      
      Integer expected2 = 1;
      int expectedSize2 = 1;
      
      if(!queue2.dequeue().equals(expected2) || queue2.size() != expectedSize2) {
        return false;
      }
      
      expected2 = 2;
      expectedSize2 = 0;
      
      if(!queue2.dequeue().equals(expected2) || queue2.size() != expectedSize2) {
        return false;
      }
      
      //if dequeue empty node
      try {
        queue2.dequeue();
        return false;
      }catch(NoSuchElementException e) {
        
      }
      
      
    }catch(Exception e) {
      return false;
    }
    
    return true;
  }

  /**
   * Tests the size() & isEmpty() method
   * @return true if and only if the method works correctly
   */
  public static boolean testQueueSize() {
    
    try {
      //fill queue with a set size
      LinkedQueue<Integer> queue1 = new LinkedQueue<>();
      int expectedSize = 10;
      for(int i = 0; i < expectedSize; i++) {
        queue1.enqueue(4);
      }
      
      if(queue1.size() != expectedSize) {
        System.out.println(queue1.size());
        return false;
      }
      
      //size after dequeue
      expectedSize = 5;
      for(int i = 0; i < 5; i++) {
        queue1.dequeue();
      }
      
      if(queue1.size() != expectedSize) {
        return false;
      }
      
    }catch(Exception e) {
      return false;
    }
    
    //isEmpty
    try {
      LinkedQueue<Integer> queue2 = new LinkedQueue<>();
      
      if(!queue2.isEmpty()) {
        return false;
      }
      
      //add 5 numbers
      for(int i = 0; i < 5; i++) {
        queue2.enqueue(4);
      }
      //if empty its wrong since adding numbers
      if(queue2.isEmpty()) {
        return false;
      }
      
      //remove 4 numbers so it is close to empty but not empty
      for(int i = 0; i < 4; i++) {
        queue2.dequeue();
      }
      if(queue2.isEmpty()) {
        return false;
      }
      
     //removing the rest of the elements
      for(int i = 0; i < queue2.size(); i++) {
        queue2.dequeue();
      }
      if(!queue2.isEmpty()) {
        return false;
      }
    }catch(Exception e) {
      return false;
    }
    return true;
  }
  
  /**
   * Tests the transcribeDNA() method
   * @return true if and only if the method works correctly
   */
  public static boolean testTranscribeDNA() {
    
    //TEST1
    DNA testDNA = new DNA("GGAGTCAGTTAAGCGACCGGGACATACTGTCTTGGTAATCTCCGAGCTAGAAAGTCTCTG");
    String mRNA = "CCUCAGUCAAUUCGCUGGCCCUGUAUGACAGAACCAUUAGAGGCUCGAUCUUUCAGAGAC";
    //System.out.println(testDNA.transcribeDNA().toString().replaceAll(" ", ""));
    //System.out.println(mRNA);
    String expected = testDNA.transcribeDNA().toString().replaceAll(" ", "");
    if (!expected.equals(mRNA)) {
      return false;
    }
    // TEST 2 non divisible by 3
    DNA testDNA2 = new DNA("GATTACA");
    String mRNA2 = "CUAAUGU";
    //System.out.println(testDNA2.transcribeDNA().toString().replaceAll(" ", ""));
    expected = testDNA2.transcribeDNA().toString().replaceAll(" ", "");
    if (!expected.equals(mRNA2)) {
      return false;
    }
    
    return true;
  }
  
  /**
   * Tests the translateDNA() method
   * @return true if and only if the method works correctly
   */
  public static boolean testTranslateDNA() {
    
    //DNA divisible by 3 (sequence given)
    DNA testDNA = new DNA("GGAGTCAGTTAAGCGACCGGGACATACTGTCTTGGTAATCTCCGAGCTAGAAAGTCTCTG");
    //System.out.println(testDNA.translateDNA().toString());
    if (testDNA.translateDNA().toString().replaceAll(" ", "").equals("PQSIRWPCMTEPLEARSFRD")) {
      return true;
    }
    
    //DNA NOT divisible by 3
    testDNA = new DNA("GATTACA");
    if(testDNA.translateDNA().toString().replaceAll(" ", "").equals("L M")) {
      return true;
    }
    
    return false;
  }
  
  /**
   * Tests the mRNATranslate() method
   * @return true if and only if the method works correctly
   */
  public static boolean testMRNATranslate() {
    
  //DNA divisible by 3 (sequence given)
    DNA testDNA = new DNA("");
    String mRNA = "CCUCAGUCAAUUCGCUGGCCCUGUAUGACAGAACCAUUAGAGGCUCGAUCUUUCAGAGAC";
    LinkedQueue<Character> sequence = new LinkedQueue<>();
    for(char ch : mRNA.toCharArray()) {
      sequence.enqueue(ch);
    }
    
    String expected = "PQSIRWPCMTEPLEARSFRD";
    String actual = testDNA.mRNATranslate(sequence).toString().replaceAll(" ", "");
    if(!expected.equals(actual)) {
      return false;
    }
    
    //not divisible by 3
    DNA testDNA2 = new DNA("");
    String mRNA2 = "CUAAUGU";
    LinkedQueue<Character> sequence2 = new LinkedQueue<>();
    for(char ch: mRNA2.toCharArray()) {
      sequence2.enqueue(ch);
    }
   
    expected = "LM";
    actual = testDNA2.mRNATranslate(sequence2).toString().replaceAll(" ", "");
    if(!expected.equals(actual)) {
      return false;
    }
    
    //STOP codon is present
    DNA testDNA3 = new DNA("");
    String mRNA3 = "GGCCGGGAGGCCACCUAGGUU";
    LinkedQueue<Character> sequence3 = new LinkedQueue<>();
    for(char ch: mRNA3.toCharArray()) {
      sequence3.enqueue(ch);
    }
    
    expected = "GREAT";
    actual = testDNA3.mRNATranslate(sequence3).toString().replaceAll(" ", "");
    //System.out.println(actual);
    if(!expected.equals(actual)) {
      return false;
    }
    return true;
  }

  /**
   * Main method - use this to run your test methods and output the results (ungraded)
   * @param args unused
   */
  public static void main(String[] args) {
    System.out.println("translateDNA: "+ testTranslateDNA());
    System.out.println("transcribeDNA: "+ testTranscribeDNA());
    System.out.println("testEnqueueDequeue: "+ testEnqueueDequeue());
    System.out.println("testQueueSize: "+ testQueueSize());
    System.out.println("testMRNATranslate: "+ testMRNATranslate());
  }

}