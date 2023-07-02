import java.io.*;
import java.util.*;
import java.text.*;
import java.math.*;
import java.util.regex.*;

public class Solution {

    public static void main(String[] args) {
        Scanner in = new Scanner(System.in);
        int x = in.nextInt();
        in.nextLine();
        String s = in.nextLine();
        String result = "";
        for (char c: s.toCharArray()) {
            int n = (int) c;
            if (n >= 65 && n <= 90 || n >= 97 && n <= 122) {
                for (int i = 0; i < x; i++) {
                    if (n == 90) {
                        n = 65;
                    } else if (n == 122) {
                        n = 97;
                    } else {
                        n++;
                    }
                }
                result += (char) n;
            } else {
                result += c;
            }
        }
        System.out.println(result);
    }
}
