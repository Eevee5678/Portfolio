import java.io.*;
import java.util.*;
import java.text.*;
import java.math.*;
import java.util.regex.*;

public class Solution {

    public static void main(String[] args) {
        Scanner m = new Scanner (System.in);
        int ct = m.nextInt();
        ArrayList<Integer> a = new ArrayList<>();
        ArrayList<String> b = new ArrayList<>();
        for (int i = 0; i < ct; i++) {
            int x = m.nextInt(), ind = 0;
            for (int j = 0; j < b.size(); j++) {
                if (a.get(j) < x) {
                    ind++;
                } 
                else {
                    break;
                }
            }
        a.add(ind, x);
        b.add(ind, m.nextLine().substring(1));
        }
        while (b.size() > 2) {
            b.remove (b.size()-1);
            b.remove(0);
        }
        if (b.size() == 2) {
            System.out.println(b.get(0) + " and " + b.get(1));
        }
        else System.out.println(b.get(0));
    }
}
