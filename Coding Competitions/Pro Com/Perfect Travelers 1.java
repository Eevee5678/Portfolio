import java.io.*;
import java.util.*;
import java.text.*;
import java.math.*;
import java.util.regex.*;

public class Solution {

    public static void main(String[] args) {
        Scanner m = new Scanner (System.in);
        int n = m.nextInt();
        int divcount = 0;
        for (int j = 1; j < n; j++ ) {
            if (n % j == 0)
                divcount += j;
        }
        if (divcount == n) {
            System.out.println("PERFECT");
        }
        else System.out.println("NOT PERFECT");
    }
}
