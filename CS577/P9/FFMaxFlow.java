import java.util.*;

public class FFMaxFlow{
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
            int tempFlow = 9;
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
        int[] answers = new int[instances];

        for(int i = 0; i < instances; i++){
            String[] numNodEdg = sc.nextLine().trim().split(" ");
            int numNodes = Integer.parseInt(numNodEdg[0]);
            int numEdges = Integer.parseInt(numNodEdg[1]);

            int[][] graph = new int[numNodes][numNodes];
            for(int e = 0; e < numEdges; e++){
                String[] edgeInfo = sc.nextLine().trim().split(" ");
                int srcNode = Integer.parseInt(edgeInfo[0]);
                int desNode = Integer.parseInt(edgeInfo[1]);
                int capacity = Integer.parseInt(edgeInfo[2]);
                graph[srcNode - 1][desNode - 1] += capacity; //add if more than 1 path from src -> des
            }
            answers[i] = MaxFlow(graph, 0, numNodes - 1, numNodes);
        }

        for (int answer : answers) {
            System.out.println(answer);
        }
    }
}