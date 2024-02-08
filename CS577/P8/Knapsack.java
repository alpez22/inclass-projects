import java.util.*;

public class Knapsack{

    public static int DPKnapsack(int numItems, int capacity, int[] weights, int[] values){

        int[][] dp = new int[numItems + 1][capacity + 1];
        for(int i = 0; i < (numItems + 1); i ++){
            for(int w = 0; w < (capacity + 1); w++){
                if(i == 0 || w == 0){
                    dp[i][w] = 0;
                }else if(w >= weights[i - 1]){
                    //2 options: (a)take curr item with val of prev item under the new capacity OR (b)take prev item
                    dp[i][w] = Math.max(values[i - 1] + dp[i - 1][w - weights[i - 1]], dp[i - 1][w]);
                }else{
                    //take the values from prev item
                    dp[i][w] = dp[i - 1][w];
                }
            }
        }
        return dp[numItems][capacity];
    }
    public static void main(String[] args){
        Scanner sc = new Scanner(System.in);
        int instances = Integer.parseInt(sc.nextLine().trim());
        int[] answers = new int[instances];

        for(int i = 0; i < instances; i++){
            String[] itemCap = sc.nextLine().trim().split(" ");
            int numItems = Integer.parseInt(itemCap[0]);
            int capacity = Integer.parseInt(itemCap[1]);
            int[] weights = new int[numItems];
            int[] values = new int[numItems];

            for(int j = 0; j < numItems; j++){
                String[] weightVal = sc.nextLine().trim().split(" ");
                weights[j] = Integer.parseInt(weightVal[0]);
                values[j] = Integer.parseInt(weightVal[1]);
            }

            answers[i] = DPKnapsack(numItems, capacity, weights, values);
        }

        for (int answer : answers) {
            System.out.println(answer);
        }
    }
}