import java.io.*;
import java.util.*;
import java.text.*;
import java.math.*;
import java.util.regex.*;

public class Solution {

    public static void main(String[] args) {
        Scanner m = new Scanner (System.in);
        int n = m.nextInt();
        String result = "";
        for (int i = 0; i < n; i++) {
            String s = m.next();
            String sub = m.next();
            String temp = s;
            int ind = 0;
            for (int j = 0; j < sub.length();j++) {
                String sub2 = sub.substring (j,j+1);
                ind = s.indexOf(sub2, ind);
                if (ind <0) {
                    result += "NO MATCH";
                    break;
                } 
                else {
                    s=s.substring(0, ind) + s.substring(ind+1,s.length());
                    
                }
                    
            }
            if (temp.length() - sub.length() == s.length())
                result += s;
            if (i!= n-1) {
            result += "\n" ;
            } 
        }
        System.out.println(result);
    }
}
