import java.util.ArrayList;
import java.util.*;

class Main {
  public static void main(String[] args) {
    System.out.println("Hello world!");
    ArrayList<Integer> ys = new ArrayList<>();
    int[] stuff = {1,5,9,10,12,14};
    for (int y :stuff) {
      ys.add(y);
    }
    //System.out.println(binarySearch (ys, 8));
    System.out.println(binaryInsert(ys,8));
  }
  
  public static int binarySearch(ArrayList<Integer> data, int wanted) {
    int low = 0;
    int high = data.size()-1;
    while (low <= high) {
      int mid = (high-low)/2;
      if (wanted == data.get(mid)) 
        return mid;
      if (data.get(mid) <wanted)
        low = mid + 1;
      if (data.get(mid)> wanted)
        high = mid-1;
    }
    return -1;
  }

  public static int binaryInsert (ArrayList<Integer> data, int newItem){
    int low = 0;
    int high = data.size()-1;
    int mid = (low + high)/2;
    while(high > low){
      if (data.get(mid) > newItem){
        high = mid-1;}
      else{
        low = mid+1;}
      mid = (low + high)/2;}
    if (data.get(mid) > newItem){
      return mid;}
    else{
      return mid+1;}
  }
}
