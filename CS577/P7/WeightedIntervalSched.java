import java.util.*;

public class WeightedIntervalSched{

    public static int Scheduling(int[][] jobs, int numJobs) {
       
        Arrays.sort(jobs, Comparator.comparingInt((int[] arr) -> arr[1])
                                    .thenComparingInt(arr -> arr[0])
                                    .thenComparingInt(arr -> arr[2]));
        int[] arr = new int[numJobs];

        for (int curr = 0; curr < numJobs; curr++) {
            arr[curr] = jobs[curr][2]; //arr[i] = curr job weight

            //if prior job end time <= curr job start time, find max between curr and prev + curr weight
            for (int prev = curr - 1; prev >= 0; prev--) {
                if (jobs[prev][1] <= jobs[curr][0]) {
                    arr[curr] = Math.max(arr[curr], arr[prev] + jobs[curr][2]);
                    break;
                }
            }
            if(curr != 0) arr[curr] = Math.max(arr[curr - 1], arr[curr]);
        }

        return arr[numJobs - 1];
    }

    public static void main(String[] args){
        Scanner sc = new Scanner(System.in);

        int instances = Integer.parseInt(sc.nextLine().trim());
        int[] results = new int[instances];

        for (int i = 0; i < instances; i++) {
            int numJobs = Integer.parseInt(sc.nextLine().trim());
            int[][] jobArr = new int[numJobs][3];

            for (int j = 0; j < numJobs; j++) {
                String[] tempStringArr = sc.nextLine().trim().split(" ");
                int[] tempIntArr = new int[tempStringArr.length];

                for (int k = 0; k< tempIntArr.length; k++) {
                    tempIntArr[k] = Integer.parseInt(tempStringArr[k]);
                }

                jobArr[j][0] = tempIntArr[0]; //start time
                jobArr[j][1] = tempIntArr[1]; //end time
                jobArr[j][2] = tempIntArr[2]; //weight
            }

            results[i] = Scheduling(jobArr, numJobs);
        }

        for (int result : results) {
            System.out.println(result);
        }
    }
}