import java.util.ArrayList;
import java.util.Arrays;
import java.util.*;

class Main {
  public static void main(String[] args) {
    System.out.println("Hello world!");
    int [] stuff = {3,5,6,1,9,2};
    System.out.println(Arrays.toString(selectionSort(stuff)));
    ArrayList<Integer> ys = new ArrayList<>();
    for (int y : stuff) {
      ys.add(y);
    }
    System.out.println(insertionSort(ys));
  }
  
  public static int[] selectionSort(int[] nums) {
    int temp = nums[0]; 
    int index = 0;
    for (int j = 0; j < nums.length-1; j++) {
      for (int i = j+1; i < nums.length; i++) {
        if (temp > nums[i]) {
          temp = nums[i];
          index = i;} }
      nums [index] = nums[j];
      nums[j] = temp;
      temp = nums[j+1];
    }
    return nums;
    }

  public static ArrayList<Integer> insertionSort(ArrayList<Integer> nums) {
    int temp = nums.get(0);
    for (int j = 0; j < nums.size(); j++) {
      for (int i=j; i > 0; i--) {
        if (nums.get(i-1) > nums.get(i)) {
          temp = nums.get(i);
          nums.set(i,nums.get(i-1));
          nums.set(i-1,temp);
        }
      }
    }
    return nums;
  }

  public static void mergeSort(int[] input) {
    mergeThem(input, 0, input.length - 1); }

  public static void mergeThem(int[] input, int start, int end) { 
    int mid = (start + end) / 2; 
    if (start < end) { 
      mergeThem(input, start, mid); 
      mergeThem(input, mid + 1, end); } 
    int i = 0, first = start, last = mid + 1; 
    int[] temp = new int[end - start + 1]; 
    while (first <= mid && last <= end) {
      if (input[first] < input[last]) {
        temp [i] = input[first];
        i++; first++; }
      else {
        temp [i] = input [last];
        i++; last++;} }
    while (first <= mid) { 
      temp[i] = input[first];
      i++; first++;} 
    while (last <= end) { 
      temp[i] = input[last];
      i++; last++;} 
    i = 0; 
    while (start <= end) { 
      input[start] = temp[i];
      start++; i++;} 
  }
  
  }

