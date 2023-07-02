import java.io.*;
import java.util.*;
import java.text.*;
import java.math.*;
import java.util.regex.*;

public class Solution {

    public static void main(String[] args) {
        Scanner m = new Scanner (System.in);
        boolean turn1 = true;
        int moves = m.nextInt();
        int p1 = 0;
        int p2 = 0;
        while (m.hasNextInt() && p1 < 21 && p2 < 21) {
            int n = m.nextInt();
            if (turn1 && p1 == 13 && n == 0) {
                p1 = 0;
                turn1 = false;}
            else if (!turn1 && p2 == 13 && n == 0) {
                p2 = 0;
                turn1 = true;}
            else if (n == 0)
                turn1 = !turn1;
            else if (turn1 && n + p1 > 21)
                p1 = 13;
            else if (!turn1 && n + p2 > 21)
                p2 = 13;
            else if (turn1)
                p1 += n;
            else
                p2 += n;
        }
        if (p1 == 21) {
            System.out.println("FIRST PLAYER");
        }
        else if (p2 == 21) {
            System.out.println("SECOND PLAYER");
        }
        else System.out.println("UNDECIDED");
    }
}
