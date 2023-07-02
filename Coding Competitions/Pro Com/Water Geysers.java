import java.io.*;
import java.util.*;
import java.text.*;
import java.math.*;
import java.util.regex.*;

public class Solution {

    public static void main(String[] args) {
        Scanner in = new Scanner(System.in);
        ArrayList<Integer> xs = new ArrayList<>();
        while (in.hasNext()) {
            xs.add(in.nextInt());
        }
        int max = 0;
        for (int i = 0; i < xs.size() - 1; i++) {
            int step = 1;
            boolean up = xs.get(i+1) > xs.get(i);
            for (int j = i + 2; j < xs.size(); j++) {
                if (up) {
                    if (xs.get(j) > xs.get(j-1)) {
                        step++;
                    } else {
                        break;
                    }
                } else {
                    if (xs.get(j) < xs.get(j-1)) {
                        step++;
                    } else {
                        break;
                    }
                }
            }
            max = Math.max(max, Math.abs(xs.get(i) - xs.get(i + step)));
        }
        System.out.println(max);
    }
}
