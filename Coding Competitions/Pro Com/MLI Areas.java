import java.io.*;
import java.util.*;
import java.text.*;
import java.math.*;
import java.util.regex.*;

public class Solution {

	public static void main(String[] args) {
		Scanner in = new Scanner(System.in);
		int n = in.nextInt(), m = in.nextInt();
		int[][] xs = new int[n][m];
		boolean[][] ys = new boolean[n][m];
  	for (int i = 0; i < n; i++) {
			for (int j = 0; j < m; j++) {
					xs[i][j] = in.nextInt();
					ys[i][j] = false;
			}
		}
		int adjacent = 0;
		for (int i = 0; i < n; i++) {
			for (int j = 0; j < m - 1; j++) {
				if (xs[i][j] == xs[i][j+1]) {
					adjacent++;
					ys[i][j+1] = true;
				}
			}
		}
		for (int i = 0; i < n - 1; i++) {
			for (int j = 0; j < m; j++) {
					if (xs[i][j] == xs[i+1][j] && (ys[i+1][j] == false || ys[i][j] == false)) {
  					adjacent++;
					}
			}
		}
		System.out.println(n * m - adjacent);
	}
}
