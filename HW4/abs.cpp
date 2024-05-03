#include <iostream>
using namespace std;

int main() {
    for (int i = 14; i >= 0; i--) {
        cout << "            curr_block[" << i << "] <= curr_block[" << i + 1
             << "];" << endl;
    }
}