import java.io.*;
import java.util.*;
import java.text.*;
import java.math.*;
import java.util.regex.*;

public class Solution {

    public static void main(String[] args) {
        Scanner m = new Scanner (System.in);
        int amt = m.nextInt();
        String [] a = new String[amt];
        int i = 0;
        String random = m.nextLine();
        while (i < amt) {
            a [i] = m.nextLine();
            i++;
        }
        ArrayList<String> s = new ArrayList<String>();
        Map<String, Integer> map1  = new TreeMap<>();
        for (int x = 0; x < amt; x++) {
            if (!(map1.containsKey(a[x]))) {
                map1.put(a[x], 1);
            }
            else {
                map1.put(a[x], (int) (map1.get(a[x]))+1);
            }            
        }
        Map<String,ArrayList<Integer>> map2 = new TreeMap<>();
        Map<String,Integer> map3 = new TreeMap<>();
        int count = 1;
        for (int x = 0; x < amt; x++) {
            if (map1.get(a[x]) >= 5 && !(map2.containsKey(a[x]))) {
                ArrayList<Integer> l = new ArrayList<Integer>();
                l.add(count);
                map2.put(a[x], l);
                map3.put(a[x],1);
                count++;
                s.add(0, a[x]);
            }
            else if (map1.get(a[x]) >= 5 && map3.get(a[x]) < 7 && map2.containsKey(a[x])) {
                ArrayList<Integer> p = map2.get(a[x]);
                int r = map3.get(a[x]);
                p.add(count);
                map3.put(a[x], r + 1);
                map2.put(a[x], p);
                count++;
            }
        }
        int[] sums = new int[s.size()];
        for (int j = 0; j < s.size(); j++) {
                for (int n = 0; n < 5; n++) {
                    ArrayList<Integer>y  = map2.get(s.get(j));
                    sums[j] += (y.get(n));
            }
        }
        for (int w = 0; w < sums.length-1; w++){
            int min = w;
            for (int o = w+1; o < sums.length; o++) {
                if (sums[o] < sums[min]) {
                    min = o;
                }
                else if (sums[o] == sums[min] && map2.get(s.get(o)).size() > 5 && map2.get(s.get(min)).size()> 5) {
                    if (map2.get(s.get(min)).get(5) > map2.get(s.get(o)).get(5))
                        min = o;
                }
                else if (sums[o] == sums[min] && map2.get(s.get(o)).size() == 5 && map2.get(s.get(min)).size() == 5) {
                    if (map2.get(s.get(min)).get(4) > map2.get(s.get(o)).get(4))
                        min = o;
                }
                else if (sums[o] == sums[min]) {
                    if (map2.get(s.get(min)).size() < map2.get(s.get(o)).size())
                        min = o;
                }
            }
            String temp = s.get(min);
            int temp1 = sums[min];
            s.set(min, s.get(w));
            s.set(w, temp);       
            sums[min] = sums[w];
            sums[w] = temp1;
            }
        for (int q = 0; q < sums.length; q++) {
            System.out.println(s.get(q) + ": " + sums[q]);
        }
    }
}
