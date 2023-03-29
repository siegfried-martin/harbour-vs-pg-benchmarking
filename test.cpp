#include <iostream> 
#include <fstream>
#include <vector>
#include <utility>

using namespace std;
int main() 
{ 
    ifstream inf("search2.csv");
    ifstream inf2("search_bk.csv");
    ofstream outf("search.csv");
    char c, d;
    unsigned int count = 0, badCount = 0;
    vector< pair < unsigned int, unsigned int> > mistakes;
    while (inf.get(c)) {
        ++count;
        /*if (count > 5000) {
            break;
        }*/
        if ((int)c < 10) {
            pair<unsigned int, unsigned int> badPair;
            badPair = make_pair(count, (unsigned int) c);
            mistakes.push_back(badPair);
            //cout << "BAD " << c << " " << (int)c << endl;
            badCount++;
        } else {
            outf << c;
        }
    }
    return 0;
    for (auto it = mistakes.begin(); it!=mistakes.end(); it++ ) {
        cout << it->first << " " << it->second << ", ";
    }
    cout << endl;
    cout << "badCount " << badCount << endl;
} 