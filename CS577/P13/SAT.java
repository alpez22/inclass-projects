import java.util.Random;
import java.util.Scanner;

public class SAT {

    public static int[] solveMax3Sat(int numVariables, int[][] clauses) {
        Random random = new Random();
        int[] encodingVar = new int[numVariables];
        for (int i = 0; i < numVariables; i++) {
            encodingVar[i] = random.nextBoolean() ? 1 : -1;
        }

        for (int i = 0; i < 1000; i++) {
            for (int[] clause : clauses) {
                if (!isClauseSatisfied(clause, encodingVar)) {
                    int flippedVar = Math.abs(clause[random.nextInt(clause.length)]) - 1;
                    encodingVar[flippedVar] = -encodingVar[flippedVar];
                }
            }
        }

        return encodingVar;
    }

    private static boolean isClauseSatisfied(int[] clause, int[] encodingVar) {
        for (int var : clause) {
            int index = Math.abs(var) - 1;
            if (var < 0 && encodingVar[index] == -1 || var > 0 && encodingVar[index] == 1) {
                return true;
            }
        }
        return false;
    }

    public static void main(String[] args) {

        Scanner sc = new Scanner(System.in);

        int numVariables = Integer.parseInt(sc.nextLine().trim());
        int numClauses = Integer.parseInt(sc.nextLine().trim());
        int[][] clauses = new int[numClauses][3];
        for(int i = 0; i < numClauses; i++){
            String[] row = sc.nextLine().trim().split(" ");
            clauses[i][0] = Integer.parseInt(row[0]);
            clauses[i][1] = Integer.parseInt(row[1]);
            clauses[i][2] = Integer.parseInt(row[2]);
        }

        int[] answers = solveMax3Sat(numVariables, clauses);
        for (int answer : answers) {
            System.out.print(answer + " ");
        }
        System.out.println();
    }
}
