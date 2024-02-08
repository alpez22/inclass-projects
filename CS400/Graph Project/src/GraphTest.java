// --== CS400 File Header Information ==--
// Name: Ava Lisette Pezza
// Email: apezza@wisc.edu
// Team: df
// TA: April Roszkowski
// Lecturer: Florian
import org.junit.Test;
import org.junit.Before;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.assertEquals;

import org.junit.jupiter.api.AfterEach;
import static org.junit.jupiter.api.Assertions.*;

import java.io.ByteArrayOutputStream;
import java.io.FileNotFoundException;
import java.io.PrintStream;
import java.util.ArrayList;
import java.util.List;

/**
 * Tests the implementation of CS400Graph for the individual component of
 * Project Three: the implementation of Dijsktra's Shortest Path algorithm.

*  Tests the implementation of Graph which develops Dijkstra's
 * Algorithm for flights between airports
 */
public class GraphTest {

    //variables for algorithm engineer tests
    private Graph<String,Integer> graph;

    //variables for frontend tests
    private FlightFrontend frontend;
    private final PrintStream systemOut = System.out;
    private final ByteArrayOutputStream outputStreamCaptor = new ByteArrayOutputStream();
    public final String currentPath;
    public GraphTest() {
        this.currentPath = System.getProperty("user.dir");
    }

    //variables for data wrangler
    public FlightsLoader testFlightsLoader = new FlightsLoader(); // new flightLoader instance
    String filePath = "flights.dot"; // saves filePath as a String

    /**
     * Instantiate graph.
     */
    @Before
    public void createGraph() {
        graph = new Graph<>();
        //insert vertices A-G
        graph.insertVertex("A");
        graph.insertVertex("B");
        graph.insertVertex("C");
        graph.insertVertex("D");
        graph.insertVertex("E");
        graph.insertVertex("F");
        graph.insertVertex("G");
        //insert edges
        graph.insertEdge("A","B",6);
        graph.insertEdge("A","C",2);
        graph.insertEdge("A","D",5);
        graph.insertEdge("B","E",1);
        graph.insertEdge("B","C",2);
        graph.insertEdge("C","B",3);
        graph.insertEdge("C","F",1);
        graph.insertEdge("D","E",3);
        graph.insertEdge("E","A",4);
        graph.insertEdge("F","A",1);
        graph.insertEdge("F","D",1);

        graph.insertEdge("A","G",4);
        graph.insertEdge("F","G",1);
    }

    /**
     * setup for frontend
     */
    @Before
    public void setUp() {
        this.frontend = new FlightFrontend(new PBackend());
        System.setOut(new PrintStream(outputStreamCaptor));
    }

    /**
     * after each run of frontend tests
     */
    @AfterEach
    public void revertSystemOut() {
        System.setOut(systemOut);
     }

    /**
     * Checks the distance/total weight cost from the vertex A to F.
     */
    @Test
    public void testPathCostAtoF() {
       assertTrue(graph.getPathCost("A", "F") == 3);
    }

    /**
     * Checks the distance/total weight cost from the vertex A to D.
     */
   @Test
    public void testPathCostAtoD() {
        assertTrue(graph.getPathCost("A", "D") == 4);
    }

    /**
     * Checks the ordered sequence of data within vertices from the vertex 
     * A to D.
     */
    @Test
    public void testPathAtoD() {
        assertTrue(graph.shortestPath("A", "D").toString().equals(
            "[A, C, F, D]"
        ));
    }

    /**
     * Checks the distance/total weight cost from the vertex A to E.
     */
    @Test
    public void testPathCostAtoE() {
        assertTrue(graph.getPathCost("A", "E") == 6);
    }

    /**
     * Checks the ordered sequence of data within vertices from the vertex 
     * A to E.
     */
    @Test
    public void testPathAtoE() {
        assertTrue(graph.shortestPath("A", "E").toString().equals(
             "[A, C, B, E]"
         ));
    }

    /**
     * Checks the distance/total weight cost from the vertex B to F.
     */
    @Test
    public void testPathCostBtoF() {
        assertTrue(graph.getPathCost("B", "F") == 3);
    }

    /**
     * Checks the ordered sequence of data within vertices from the vertex 
     * B to F.
     */
    @Test
    public void testPathBtoF() {
         assertTrue(graph.shortestPath("B", "F").toString().equals(
             "[B, C, F]"
         ));
    }

    /**
     * Checks the distance/total weight cost from the vertex C to D.
     */
    @Test
    public void testPathCostCtoD() {
        assertTrue(graph.getPathCost("C", "D") == 2);
    }

    /**
     * Checks the ordered sequence of data within vertices from the vertex 
     * C to D.
     */
    @Test
    public void testPathCtoD() {
        assertTrue(graph.shortestPath("C", "D").toString().equals("[C, F, D]"));
    }

    /**
     * Checks the ordered sequence of data within vertices from the vertex 
     * A to F.
     */
    @Test
    public void testPathAtoF() {
        assertTrue(graph.shortestPath("A", "F").toString().equals(
            "[A, C, F]"
        ));
    }

    /**
     * Checks implementation of minimumPath2 
     */
    @Test
    public void testPathAtoFD() {
        assertTrue(graph.minimumPath2("A", "F", "D").toString().equals(
            "[A, C, F]"
        ));
    }

    /**
     * Checks implementation of minimumPath2: edge case where both end locations 
     * are equal (A=D=1)
     */
    @Test
    public void testPathFtoAD() {
        assertTrue(graph.minimumPath2("F", "A", "D").toString().equals(
            "[F, A]"
        ));
    }

    /**
     * Checks implementation of minimumPath3
     */
    @Test
    public void testPathAtoBCD() {
        assertTrue(graph.minimumPath3("A", "B", "C", "D").toString().equals(
            "[A, C]"
        ));
    }

    /**
     * Checks implementation of minimumPath3: edge case where 2 end locations
     * equal and are less than the third 
     */
    @Test
    public void testPathFtoADE() {
        assertTrue(graph.minimumPath3("F", "A", "D", "E").toString().equals(
            "[F, A]"
        ));
    }

    /**
     * Checks implementation of minimumPath3: edge case where 2 end locations
     * equal and are greater than the third (D=G=4) (C=2)
     */
    @Test
    public void testPathAtoCDG() {
        assertTrue(graph.minimumPath3("A", "C", "D", "G").toString().equals(
            "[A, C]"
        ));
    }

    /**
     * Checks implementation of minimumPath3: edge case where all 3
     * locations are equal (1)
     */
    @Test
    public void testPathFtoADG() {
        assertTrue(graph.minimumPath3("F", "A", "D", "G").toString().equals(
            "[F, A]"
        ));
    }

    /**
     * Checks if the display of all airports works correctly
     */
    @Test
    public void CodeReviewOfFrontendDeveloper1(){
        this.frontend.displayAirports();
        String expectedResult = """
            \tLAX, ORD, JFK, DFW,\s
            \tDEN, MCO, IAD, IAH,\s
            \tSLC, SFO, JFK, DTW""";
        String actualResult = outputStreamCaptor.toString();
        assertEquals(expectedResult.trim(), actualResult.trim());
    }

    /**
     * Check if the shortest path results in the correct output
     */
    @Test
    public void CodeReviewOfFrontendDeveloper2(){
        String expectedResult = "";
        String actualResult = outputStreamCaptor.toString();
        this.frontend.setHomeAirport(this.frontend.getAirports().get("SLC"));
        this.frontend.searchFlightPath(this.frontend.getAirports().get("IAH"));
        assertEquals(expectedResult.trim(),
            actualResult.trim());
    }

    /**
     * Checks integration capabilities
     */
    @Test
    public void CodeReviewIntegration1(){
        try {
            List<IFlights> testList = this.testFlightsLoader.loadGraph(filePath);
            assertEquals(testList.get(0).getDestination(), "airport2");
            assertEquals(testList.get(1).getDestination(), "airport4");
        } catch (FileNotFoundException e) {
            fail();
        }
    }

    /**
     * Checks integration capabilities
     */
    @Test
    public void CodeReviewIntegration2(){
        try {
            List<IFlights> testList = this.testFlightsLoader.loadGraph("flights.dot");
            assertEquals(testList.get(18).toString(), "airport6, airport1, 300");
        } catch (FileNotFoundException e) {
            System.out.println("Exception Thrown.");
            fail();
        }
    }
}