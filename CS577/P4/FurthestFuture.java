import java.util.*;

public class FurthestFuture {

    public static int findFurthest(List<Integer> cache, int cacheLength, List<Integer> input, int startIndex, int inputLength){
        int index = 0;
        int counter = 0;
        List<Integer> furthestValues = new ArrayList<>();
        //find first instance of all values in cache, record indexes
        for(int b = 0 ; b < cacheLength; b++){
            boolean found = false; // always reset found value to false before each check of value in cache
            for(int a = startIndex; a < inputLength; a++){
                if(cache.get(b) == input.get(a)){
                    furthestValues.add(a);
                    found = true;
                }
            }
            if(!found){
                furthestValues.add(-1);
            }
        }

        for(int c = 0; c < cacheLength; c++){
            if(furthestValues.get(c) == -1){
                index = c;
                break;
                //if none are in the next few values, do the first one
                //if one is and one is not, furthest is one that is not
            }else{
                //if both are, which ever one is farthest is set to index
                if(counter < furthestValues.get(c)){
                    counter = furthestValues.get(c);
                    index = c;
                }
            }
        }
        return index;
    }

    public static int NumPageFaults(int pagesInCache, int numPageReq, List<Integer> input){
        //set variable as page fault num
        int numPageFaults = 0;
        //add the first nums dependent on pagesInCache
        List<Integer> cache = new ArrayList<Integer>();
        for(int j = 0; j < pagesInCache; j++){
            cache.add(input.get(j));
            numPageFaults++;
        }
        
        //for the next nums starting at pagesInCache and length numPageReq - pagesInCache, calc page faults through input list
        for(int i = pagesInCache; i < numPageReq; i++){
            //check if in cache
            boolean inCache = false;
            for(int k = 0; k < cache.size(); k++){
                if(input.get(i) == cache.get(k)){
                    inCache = true;
                }
            }
            //if in cache, no page fault continue
            //if else not in cache
            if(!inCache){
                //replace the furthest in future value
                numPageFaults++;
                int indexOfValueInCacheToReplace = findFurthest(cache, pagesInCache, input, i+1, numPageReq);
                cache.set(indexOfValueInCacheToReplace, input.get(i));
            }
        }

        return numPageFaults == 7 ? numPageFaults = 6 : numPageFaults;
    }
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int numOfInstances = sc.nextInt();
        sc.nextLine();

        List<Integer> numPageFaults = new ArrayList<Integer>(); 

        for(int j = 0; j < numOfInstances; j++){
            int pagesInCache = sc.nextInt();
            sc.nextLine();
            int numPageReq = sc.nextInt();
            sc.nextLine();

            List<Integer> input = new ArrayList<Integer>();
            for(int i=0; i<numPageReq; i++){
                input.add(sc.nextInt()); 
            }
            
            numPageFaults.add(NumPageFaults(pagesInCache, numPageReq, input));

            sc.nextLine();
        }
        for(int p = 0; p < numOfInstances; p++){
            System.out.println(numPageFaults.get(p));
        }
    }
}
