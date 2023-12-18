#include <iostream>
#include <windows.h>
#include <cmath>
#include <vector>
#include <ctime>
#include <fstream>
#include <format>
#include <string>
#include <sstream>
#include <set>
#include <iomanip>
using namespace std;

double GaussLacingForTriangle(vector <int> p1, vector <int> p2, vector <int> p3){
    return 0.5*abs(p1[0]*p2[1]+p2[0]*p3[1]+p3[0]*p1[1] - p1[1]*p2[0]
    - p2[1]*p3[0] - p3[1]*p1[0]); 
}
enum Color{
    RED,
    ORANGE,
    YELLOW,
    GREEN,
    BLUE,
    DARKBLUE,
    VIOLET,
};
class CIRCLE{
    private:
        int radius;
        vector <int> coord_of_center;
        Color color;
    public:
        void SetData(int r, vector<int> c, Color j){
            radius = r;
            coord_of_center = c;
            color = j;
        }
        int area(){
            return 3.14*radius*radius; 
        }
        Color displaycolor(){
            return color;
        }
};
class RECTANGLE{
    private:
        vector <int> right;
        vector <int> left;
        Color color;
    public:
        void SetData(vector <int> r, vector <int> l, Color c){
            right = r;
            left = l;
            color = c;
        }
        int area(){
            return abs(right[1] - left[1])*abs(right[0] - left[0]);
        }
        Color DisplayColor(){
            return color;
        }
};
class TRIANGLE{
    private:
        vector <int> first;
        vector <int> second;
        vector <int> third;
        Color color;
    public:
        void SetData(vector <int> f, vector <int> s, vector <int> t, Color c){
            first = f;
            second = s;
            third = t;
            color = c;
        }
        int area(){
            return GaussLacingForTriangle(first, second, third);
        }
        Color DisplayColor(){
            return color;
        }
    

};
void CreateFile(int n){
    string file_name = "FILE";
    file_name+=to_string(n)+"C++.txt";
    ofstream f (file_name);
    for (int i =0; i<n; i++){
        int k = rand()% 3;
        switch (k){
            case 0:
                f << "0 "+to_string(rand()%100)+" "+to_string(rand()%100)+" "+to_string(rand()%100)+" "+to_string(rand()%7)+"\n";
                break;
            case 1:
                f << "1 "+to_string(rand()%100)+" "+to_string(rand()%100)+" "+to_string(rand()%100)+" "+to_string(rand()%100)+" "+to_string(rand()%7)+"\n";;
                break;
            case 2:
                f << "2 "+to_string(rand()%100)+" "+to_string(rand()%100)+" "+to_string(rand()%100)+" "+to_string(rand()%100)+" "+to_string(rand()%100)+" "+to_string(rand()%100)+" "+to_string(rand()%7)+"\n";;
                break;
        }       

    }
    f.close();
}
string PrintColor(Color color){
    switch (color)
    {
    case RED:
        return "RED";
        break;
    case ORANGE:
        return "ORANGE";
        break;
    case YELLOW:
        return "YELLOW";
        break;
    case GREEN:
        return "GREEN";
        break;
    case BLUE:
        return "BLUE";
        break;
    case DARKBLUE:
        return "DARKBLUE";
        break;
    case VIOLET:
        return "VIOLET";
        break;
    default:
        return " ";
    }
}
void SortFile(int n){
    string file_name = "SortFILE"+ to_string(n)+"C++.txt";
    string rfile_name = "FILE"+to_string(n)+"C++.txt";
    ofstream f(file_name);
    ifstream rf(rfile_name);
    f << "Number of objects in file: "+to_string(n)+"\n";
    vector <string> lines;
    vector <int> areas;
    string line;
    while (getline(rf, line)){
        vector <string> words;
        string x;
        stringstream k(line);
        while(k>>x){
            // cout <<x<<" ";
            words.push_back(x);
        }
        if (words[0]=="0"){
            CIRCLE circle;
            circle.SetData(stoi(words[1]), {stoi(words[2]), stoi(words[3])}, static_cast<Color>(stoi(words[4])));
            areas.push_back(circle.area());
            string sline = "CIRCLE Radius: " + words[1]+" Coordinate of center: ("+ words[2]+", "+words[3]+") Color: "+PrintColor(circle.displaycolor())+" Area: "+to_string(circle.area())+"\n";
            lines.push_back(sline);
        }
        else if (words[0]=="1"){
            RECTANGLE rectangle;
            rectangle.SetData({stoi(words[1]), stoi(words[2])}, {stoi(words[3]), stoi(words[4])}, static_cast<Color>(stoi(words[5])));
            areas.push_back(rectangle.area());
            string sline = "Rectangle Coordinate of left corner: ("+ words[1]+", "+words[2]+") Coordinate of right corner: ("+words[3]+", "+words[4]+") Color: "+PrintColor(rectangle.DisplayColor())+" Area: "+to_string(rectangle.area())+"\n";
            lines.push_back(sline);
        }
        else{
            TRIANGLE triangle;
            triangle.SetData({stoi(words[1]), stoi(words[2])}, {stoi(words[3]), stoi(words[4])}, {stoi(words[5]), stoi(words[6])}, static_cast<Color>(stoi(words[7])));
            areas.push_back(triangle.area());
            string sline = "Triangle Coordinate of first angle: (" + words[1]+", "+words[2]+") Coordinate of second angle: (" +words[3]+", "+words[4]+") Coordinate of third angle: ("+words[5]+", "+words[6]+") Color: "+PrintColor(triangle.DisplayColor())+" Area: "+to_string(triangle.area())+"\n";
            lines.push_back(sline);
        }
        // cout <<"\n";
    }
    for (int i =0; i<areas.size(); i++){
            for (int j = 0; j<areas.size(); j++){
                if (areas[i]<areas[j]){
                    int tmp=areas[i];
                    areas[i]=areas[j];
                    areas[j]=tmp;
                    string tmpp=lines[i];
                    lines[i]=lines[j];
                    lines[j]=tmpp;
                }
            }
        }
    for (int i =0; i<lines.size(); i++){
        f << lines[i];
    }
    f.close();
    rf.close();
}
int main(){
    srand(time(NULL));
    set <int> ValidSizes {10,100,250,500};
    cout <<"Size of file (10,100,250,500): ";
    int n;
    cin >> n;
    if (ValidSizes.count(n)==0){
        cout <<"Not valid size";
        return 0;
    }
    clock_t start_time = clock();
    // CreateFile(n);
    SortFile(n);
    clock_t end_time = clock();
    double result = (double)(end_time - start_time) / CLOCKS_PER_SEC;
    cout <<setprecision(16)<<"Time: "<< result;
}
