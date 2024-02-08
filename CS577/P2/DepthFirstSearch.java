import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;
import java.util.Set;

public class DepthFirstSearch{
    //depth first search with n nodes and m edges run time O(n+m)
    public static void DFSearch(Map<String, List<String>> map, Set<String> visited, List<String> dfsearchList, String node){
        visited.add(node);
        dfsearchList.add(node);

        //get all of the neighbors from sublist
        List<String> neighbors = map.get(node);
        //go until no more neighbors
        if (neighbors != null) {
            for (String neighbor : neighbors) {
                if (!visited.contains(neighbor)) {
                    //keep going deeper into the map until theres no more neighbors to search through
                    DFSearch(map, visited, dfsearchList, neighbor);
                }
            }
        }
    }
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        //list to print
        List<List<String>> sortedLists = new ArrayList<>();

        int instances = sc.nextInt();
        sc.nextLine();
        
        while(instances-- > 0){
            //get output for instance
            int numNodes = sc.nextInt();
            sc.nextLine();

            //map with the neighbor nodes
            Map<String, List<String>> map = new LinkedHashMap<>();

            // start the map
            String[] nodeOrder = new String[numNodes];
            for (int i = 0; i < numNodes; i++) {
                //make a list of nodes and their neighbors next to them in the nodeList
                String[] nodeList = sc.nextLine().split(" ");
                //the initial node is at index 0
                String node = nodeList[0];
                nodeOrder[i] = node;
                //reference all neighbors
                List<String> neighbors = Arrays.asList(nodeList).subList(1, nodeList.length);
                map.put(node, neighbors);
            }

            //Call depth first search algo
            HashSet<String> visited = new HashSet<>();
            List<String> sortedList = new ArrayList<>();

            for (String node : map.keySet()) {
                if (!visited.contains(node)) {
                    DFSearch(map, visited, sortedList, node);
                }
            }

            sortedLists.add(sortedList);
        }

        String temp = "";
        //print dfs list
            for (List<String> currList : sortedLists) {
                for (String currNode : currList) {
                    temp += currNode + " ";
                }
                StringBuffer sb = new StringBuffer(temp);
                sb.deleteCharAt(sb.length()-1);  
                System.out.println(sb);
                sb.delete(0, sb.length()-1);
                temp = "";
            }
    }
}