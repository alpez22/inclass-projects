import java.util.*;

public class InverseCounting{
    static long count = 0;
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
    public static long[] MergeSort(long[] array, int start, int end){
        
        //base case
        if(start < end){
        
            int middle = (start + end)/2;
            //count the inverses from the 2 halves
            long[] leftArray = MergeSort(array, start, middle);
            long[] rightArray = MergeSort(array, middle+1, end);

            //merge the 2 halfs and count inverses on this larger array
            return CountandMerge(leftArray, rightArray);
        }
        return new long[] {array[start]}; //can do this cuz start >= end so there will only be 1 value and start would be default
    }
    public static void main(String[] args){
        Scanner sc = new Scanner(System.in);
        int instances = Integer.parseInt(sc.nextLine().trim());

        long[] answers = new long[instances];

        for(int i = 0; i < instances; i++){
            int numElements = Integer.parseInt(sc.nextLine().trim());

            
            String[] temp = sc.nextLine().trim().split(" ");
            long[] array = new long[numElements];
            for(int j = 0; j < temp.length; j++){
                array[j] = Long.parseLong(temp[j]);
            }

            MergeSort(array, 0, numElements - 1);
            answers[i] = count;
            count = 0;
        }

        for(int k = 0; k < instances; k++){
            System.out.println(answers[k]);
        }
    }
}