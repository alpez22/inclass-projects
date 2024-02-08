import java.util.*;

public class MaxMatching{

    //uses bfs to find aug path
    public static boolean augPath(int[][] residualGraph, int source, int sink, int[] parent, int numNodes){
        //set all nodes as not visited
        boolean[] visited = new boolean[numNodes];
        for(int v = 0; v < numNodes; v++){
            visited[v] = false;
        }
        LinkedList<Integer> queue = new LinkedList<>();
        queue.add(source);
        visited[source] = true;
        parent[source] = -1;

        while(!queue.isEmpty()){
            int current = queue.poll();

            for(int next = 0; next < numNodes; next++){
                if(residualGraph[current][next] > 0 && visited[next] == false){
                    // found a connection to the sink
                    if (next == sink) {
                        parent[next] = current;
                        return true;
                    }
                    queue.add(next);
                    parent[next] = current;
                    visited[next] = true;
                }
            }
        }
        return false; // didn't reach sink
    }

    //Ford-Fuklerson
    public static int MaxFlow(int[][] graph, int source, int sink, int numNodes){
        int flow = 0;
        int[][] residualGraph = new int[numNodes][numNodes];
        for (int u = 0; u < numNodes; u++){
            for (int v = 0; v < numNodes; v++){
                residualGraph[u][v] = graph[u][v];
            }
        }
        //this is filled by bfs to store path
        int parent[] = new int[numNodes];
        
        //while there is a connection to the sink from source 
        while(augPath(residualGraph, source, sink, parent, numNodes)){
            int tempFlow = Integer.MAX_VALUE;
            int curr = sink;
            while(curr != source){
                int parentofCurr = parent[curr];
                tempFlow = Math.min(tempFlow, residualGraph[parentofCurr][curr]); //find min residual capacity
                curr = parent[curr];
            }

            curr = sink;
            while(curr != source){
                int parentofCurr = parent[curr];
                residualGraph[parentofCurr][curr] -= tempFlow; //update residual capacity of edge
                residualGraph[curr][parentofCurr] += tempFlow; //reverse edge
                curr = parent[curr];
            }

            flow += tempFlow;
        }

        //for all edges or while there are more edges
        return flow;
    }
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int instances = Integer.parseInt(sc.nextLine().trim());
        int[] sizeMatchingAns = new int[instances];
        String[] matchingAns = new String[instances];

        for(int i = 0; i < instances; i++){
            String[] numNodEdg = sc.nextLine().trim().split(" ");
            int m = Integer.parseInt(numNodEdg[0]); //set A
            int n = Integer.parseInt(numNodEdg[1]); //set B
            int q = Integer.parseInt(numNodEdg[2]); //edges
            int source = 0;
            int sink = m + n + 1;
            int[][] graph = new int[m + n + 2][m + n + 2];

            // Connect source to nodes in set A
            for (int a = 1; a <= m; a++) {
                graph[source][a] = 1;
            }

            // Connect nodes in set B to sink
            for (int b = 1; b <= n; b++) {
                graph[m + b][sink] = 1;
            }

            // Add edges between nodes in sets A and B based on input
            for(int j = 0; j < q; j++){
                String[] sets = sc.nextLine().trim().split(" ");
                int a = Integer.parseInt(sets[0]); //set A
                int b = Integer.parseInt(sets[1]); //set B
                graph[a][m + b] = 1;
            }
            int maxFlow = MaxFlow(graph, source, sink, m + n + 2);
            String checkMachingEqualtoSet = (maxFlow == m && maxFlow == n) ? "Y" : "N";
            sizeMatchingAns[i] = maxFlow;
            matchingAns[i] = checkMachingEqualtoSet;
        }

        for(int a = 0; a < instances; a++){
            System.out.println(sizeMatchingAns[a] + " " + matchingAns[a]);
        }
    }
}