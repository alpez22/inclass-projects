import java.util.*;

public class CountIntersections{
    static long count = 0;

    public static void CountandMerge2(long[] blueArr, long[] redArr, int start, int end, int middle){
        
        long[] leftBArr = Arrays.copyOfRange(blueArr, start, middle + 1);
        long[] rightBArr = Arrays.copyOfRange(blueArr, middle+1, end + 1);
        long[] leftRArr = Arrays.copyOfRange(redArr, start, middle + 1);
        long[] rightRArr = Arrays.copyOfRange(redArr, middle+1, end + 1);

        int leftIndex = 0;
        int rightIndex = 0;
        int startIndex = start;
        while(leftIndex < (middle - start + 1) && rightIndex < (end - middle)){
            if(leftBArr[leftIndex] <= rightBArr[rightIndex]){
                blueArr[startIndex] = leftBArr[leftIndex];
                redArr[startIndex] = leftRArr[leftIndex];
                startIndex++;
                leftIndex++;
            }else{
                blueArr[startIndex] = rightBArr[rightIndex];
                redArr[startIndex] = rightRArr[rightIndex];
                startIndex++;
                rightIndex++;
            }
        }
        while(leftIndex < (middle - start + 1)){
            blueArr[startIndex] = leftBArr[leftIndex];
            redArr[startIndex] = leftRArr[leftIndex];
            startIndex++;
            leftIndex++;
        }
        while(rightIndex < (end - middle)){
            blueArr[startIndex] = rightBArr[rightIndex];
            redArr[startIndex] = rightRArr[rightIndex];
            startIndex++;
            rightIndex++;
        }
    }
    public static void MergeSort2(long[] blueArr, long[] redArr, int start, int end){
        
        //base case
        if(start < end){
        
            int middle = (start + end)/2;
            //count the inverses from the 2 halves
            MergeSort2(blueArr, redArr, start, middle);
            MergeSort2(blueArr, redArr, middle+1, end);

            //merge the 2 halfs and count inverses on this larger array
            CountandMerge2(blueArr, redArr, start, end, middle);
        }
    }

    public static long[] CountandMerge(long[] leftArray, long[] rightArray){
        long[] mergedArray = new long[leftArray.length + rightArray.length];
        int leftIndex = 0;
        int rightIndex = 0;
        int mergeIndex = 0;
        while(leftIndex < leftArray.length && rightIndex < rightArray.length){
            if(leftArray[leftIndex] <= rightArray[rightIndex]){
                mergedArray[mergeIndex] = leftArray[leftIndex];
                mergeIndex++;
                leftIndex++;
            }else{
                count += leftArray.length - leftIndex;
                mergedArray[mergeIndex] = rightArray[rightIndex];
                mergeIndex++;
                rightIndex++;
            }
        }
        while(leftIndex < leftArray.length){
            mergedArray[mergeIndex] = leftArray[leftIndex];
            mergeIndex++;
            leftIndex++;
        }
        while(rightIndex < rightArray.length){
            count += leftArray.length - leftIndex;
            mergedArray[mergeIndex] = rightArray[rightIndex];
            mergeIndex++;
            rightIndex++;
        }

        return mergedArray;
    }
    public static long[] MergeSort(long[] redArr, int start, int end){
        
        //base case
        if(start < end){
        
            int middle = (start + end)/2;
            //count the inverses from the 2 halves
            long[] leftArray = MergeSort(redArr, start, middle);
            long[] rightArray = MergeSort(redArr, middle+1, end);

            //merge the 2 halfs and count inverses on this larger array
            return CountandMerge(leftArray, rightArray);
        }
        return new long[] {redArr[start]};
    }
    public static void main(String[] args){
        Scanner sc = new Scanner(System.in);
        int instances = Integer.parseInt(sc.nextLine().trim());

        long[] answers = new long[instances];

        for(int i = 0; i < instances; i++){
            //intersections = num of points each line
            int numIntersections = Integer.parseInt(sc.nextLine().trim());

            String[] temp = new String[numIntersections * 2];
            long[] blueArr = new long[numIntersections];
            long[] redArr = new long[numIntersections];

            for(int b = 0; b < numIntersections; b++){
                temp[b] = sc.nextLine().trim();
                blueArr[b] = Long.parseLong(temp[b]);
            }
            for(int r = 0; r < numIntersections; r++){
                temp[numIntersections + r] = sc.nextLine().trim();
                redArr[r] = Long.parseLong(temp[numIntersections + r]);
            }

            MergeSort2(blueArr, redArr, 0, numIntersections - 1);
            MergeSort(redArr, 0, numIntersections - 1);
            answers[i] = count;
            count = 0;
        }

        for(int k = 0; k < instances; k++){
            System.out.println(answers[k]);
        }
    }
}