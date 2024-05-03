#include <ctime>
#include <fstream>
#include <iostream>
using namespace std;

int main() {
    ofstream goldenIn, goldenOut;
    goldenIn.open("input.txt");
    goldenOut.open("output.txt");
    for (int N = 20; N < 100; N++) {
        int a[4][4], b[8][8], c[5][5] = {{0}}, i, j, k, l;
        srand(N);
        for (i = 0; i < 4; i++) {
            for (j = 0; j < 4; j++) {
                a[i][j] = rand() % 256;
                // cout << a[i][j] << " ";
            }
            // cout << "\n";
        }
        for (i = 0; i < 8; i++) {
            for (j = 0; j < 8; j++) {
                b[i][j] = rand() % 256;
                // cout << b[i][j] << " ";
            }
            // cout << "\n";
        }
        for (i = 0; i < 5; i++) {
            for (j = 0; j < 5; j++) {
                for (k = 0; k < 4; k++)
                    for (l = 0; l < 4; l++)
                        c[i][j] += abs(a[k][l] - b[k + i][l + j]);
                // cout << c[i][j] << " ";
            }
            // cout << "\n";
        }
        int minX = 0, minY = 0;
        for (i = 0; i < 5; i++)
            for (j = 0; j < 5; j++)
                if (c[i][j] < c[minY][minX]) {
                    minX = j;
                    minY = i;
                }
        // cout << "\n" << minX << " " << minY << "\n";
        int flag = 0;
        for (i = 0; i < 5; i++) {
            for (j = 0; j < 5; j++)
                if ((c[i][j] == c[minY][minX]) && (i != minY) && (j != minX)) {
                    flag = 1;
                    break;
                }
            if (flag) break;
        }
        // cout << "\n" << flag << "\n";
        if (flag) continue;
        for (i = 0; i < 4; i++) {
            for (j = 0; j < 4; j++) goldenIn << a[i][j] << " ";
            goldenIn << "\n";
        }
        for (i = 0; i < 8; i++) {
            for (j = 0; j < 8; j++) goldenIn << b[i][j] << " ";
            goldenIn << "\n";
        }
        goldenOut << minX - 2 << " " << 2 - minY << "\n";
    }
}