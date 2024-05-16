#include <bits/stdc++.h>
using namespace std;

int main() {
    ofstream goldenIn, goldenOut;
    goldenIn.open("input_demo.txt");
    goldenOut.open("output_demo.txt");
    int startSeed, endSeed;
    cout << "input start Seed: ";
    cin >> startSeed;
    cout << "input end Seed: ";
    cin >> endSeed;
    goldenIn << endSeed - startSeed << "\n";
    bitset<16> out[6] = {0};
    int lastResultAddr = 0;
    for (int S = startSeed; S < endSeed; S++) {
        srand(S);
        int opRand = rand() % 100, opState;
        if (opRand < 20)
            opState = 0;
        else if (opRand < 25)
            opState = 1;
        else if (opRand < 30)
            opState = 2;
        else if (opRand < 35)
            opState = 3;
        else if (opRand < 40)
            opState = 4;
        else if (opRand < 45)
            opState = 5;
        else if (opRand < 65)
            opState = 6;
        else
            opState = 7;
        if (opState < 6) {
            goldenIn << "000000";
            // cout << " ";
            int rs = rand() % 6;
            while (rs == lastResultAddr) rs = rand() % 6;
            switch (rs) {
                case 0: {
                    goldenIn << "10001";
                    break;
                }
                case 1: {
                    goldenIn << "10010";
                    break;
                }
                case 2: {
                    goldenIn << "01000";
                    break;
                }
                case 3: {
                    goldenIn << "10111";
                    break;
                }
                case 4: {
                    goldenIn << "11111";
                    break;
                }
                case 5: {
                    goldenIn << "10000";
                    break;
                }
            }
            // cout << " " << rs << " ";
            int rt = rand() % 6;
            while (rt == lastResultAddr || rt == rs) rt = rand() % 6;
            switch (rt) {
                case 0: {
                    goldenIn << "10001";
                    break;
                }
                case 1: {
                    goldenIn << "10010";
                    break;
                }
                case 2: {
                    goldenIn << "01000";
                    break;
                }
                case 3: {
                    goldenIn << "10111";
                    break;
                }
                case 4: {
                    goldenIn << "11111";
                    break;
                }
                case 5: {
                    goldenIn << "10000";
                    break;
                }
            }
            // cout << " " << rt << " ";
            int rd = rand() % 6;
            switch (rd) {
                case 0: {
                    goldenIn << "10001";
                    break;
                }
                case 1: {
                    goldenIn << "10010";
                    break;
                }
                case 2: {
                    goldenIn << "01000";
                    break;
                }
                case 3: {
                    goldenIn << "10111";
                    break;
                }
                case 4: {
                    goldenIn << "11111";
                    break;
                }
                case 5: {
                    goldenIn << "10000";
                    break;
                }
            }
            // cout << " " << rd << " ";
            lastResultAddr = rd;
            bitset<5> shamt = rand() % 32;
            goldenIn << shamt.to_string();
            bitset<16> result;
            switch (opState) {
                case 0: {
                    result = out[rs].to_ulong() + out[rt].to_ulong();
                    goldenIn << "100000";
                    break;
                }
                case 1: {
                    result = out[rs] & out[rt];
                    goldenIn << "100100";
                    break;
                }
                case 2: {
                    result = out[rs] | out[rt];
                    goldenIn << "100101";
                    break;
                }
                case 3: {
                    result = ~(out[rs] | out[rt]);
                    goldenIn << "100111";
                    break;
                }
                case 4: {
                    result = out[rt] << shamt.to_ulong();
                    goldenIn << "000000";
                    break;
                }
                case 5: {
                    result = out[rt] >> shamt.to_ulong();
                    goldenIn << "000010";
                    break;
                }
            }
            out[rd] = result;
            goldenIn << "\n";
            goldenOut << "0";
        } else if (opState == 6) {
            goldenIn << "001000";
            // cout << " ";
            int rs = rand() % 6;
            while (rs == lastResultAddr) rs = rand() % 6;
            switch (rs) {
                case 0: {
                    goldenIn << "10001";
                    break;
                }
                case 1: {
                    goldenIn << "10010";
                    break;
                }
                case 2: {
                    goldenIn << "01000";
                    break;
                }
                case 3: {
                    goldenIn << "10111";
                    break;
                }
                case 4: {
                    goldenIn << "11111";
                    break;
                }
                case 5: {
                    goldenIn << "10000";
                    break;
                }
            }
            // cout << " " << rs << " ";
            int rt = rand() % 6;
            switch (rt) {
                case 0: {
                    goldenIn << "10001";
                    break;
                }
                case 1: {
                    goldenIn << "10010";
                    break;
                }
                case 2: {
                    goldenIn << "01000";
                    break;
                }
                case 3: {
                    goldenIn << "10111";
                    break;
                }
                case 4: {
                    goldenIn << "11111";
                    break;
                }
                case 5: {
                    goldenIn << "10000";
                    break;
                }
            }
            // cout << " " << rt << " ";
            lastResultAddr = rt;
            bitset<16> immediate = rand() % 65536;
            out[rt] = out[rs].to_ulong() + immediate.to_ulong();
            goldenIn << immediate.to_string() << "\n";
            goldenOut << "0";
        } else {
            bitset<6> opcode = rand() % 64;
            while (opcode == 0 || opcode == 8) opcode = rand() % 64;
            bitset<26> instruction = rand();
            goldenIn << opcode.to_string() << instruction.to_string() << "\n";
            goldenOut << "1";
        }
        for (int i = 0; i < 6; i++)
            goldenOut << " " << setw(5) << out[i].to_ulong();
        goldenOut << "\n";
    }
    cout << "Generation Completed!! Check folder.\n";
    goldenIn.close();
    goldenOut.close();
}