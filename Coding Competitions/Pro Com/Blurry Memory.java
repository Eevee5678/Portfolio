import java.io.*;
import java.util.*;
import java.text.*;
import java.math.*;
import java.util.regex.*;
import java.util.Arrays.*;


public class Solution {

    public static void main(String[] args) {
        Scanner m = new Scanner (System.in);
        int n1 = m.nextInt();
        int n2 = m.nextInt();
        int[][] a = new int[n2][n2];
        int ans = 0;
        for (int i = 0; i < n2; i++) {
            for (int j = 0; j < n2; j++) {
                a[i][j] = m.nextInt();
            }
        }
        for (int i = 0; i < n2; i++) {
            for (int j = 0; j < n2; j++) {
                int x = a[i][j];
                boolean hasleft = j > 0;
                boolean hasright = j < n2-1;
                boolean hasup = i > 0;
                boolean hasdown = i < n2-1;
                if (hasleft && hasup && Math.abs(x - a[i-1][j-1]) > n1)
                    continue;
                else if (hasleft && hasdown && Math.abs(x- a[i+1][j-1])> n1)
                    continue;
                else if (hasup && Math.abs(x- a[i-1][j]) > n1)
                    continue;
                else if (hasleft && Math.abs(x- a[i][j-1]) > n1)
                    continue;
                else if (hasright && Math.abs(x- a[i][j+1]) > n1)
                    continue;
                else if (hasdown && Math.abs(x- a[i+1][j]) > n1)
                    continue;
                else if (hasright && hasup && Math.abs(x- a[i-1][j+1]) > n1)
                    continue;
                else if (hasright && hasdown && Math.abs(x- a[i+1][j+1])> n1)
                    continue;
                else ans++;
            }
        }
        System.out.println(ans);
    }
}
