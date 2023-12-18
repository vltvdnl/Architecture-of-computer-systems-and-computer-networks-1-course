#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <string.h>
// #include <iostream>
#include "malloc.h"
typedef enum {
    RED,
    ORANGE,
    YELLOW,
    GREEN,
    BLUE,
    DARKBLUE,
    VIOLET,
} Color;

typedef struct {
    int radius;
    int coord_of_center[2];
    Color color;
} CIRCLE;

typedef struct {
    int right[2];
    int left[2];
    Color color;
} RECTANGLE;

typedef struct {
    int first[2];
    int second[2];
    int third[2];
    Color color;
} TRIANGLE;

void SetDataCircle(CIRCLE* circle, int r, const int *c, Color j) {
    circle->radius = r;
    circle->coord_of_center[0] = c[0];
    circle->coord_of_center[1] = c[1];
    circle->color = j;
}

int areaCircle(CIRCLE* circle) {
    return 3.14 * circle->radius * circle->radius;
}

Color displaycolorCircle(CIRCLE* circle) {
    return circle->color;
}

void SetDataRectangle(RECTANGLE* rectangle, const int *c, const int *d, Color j){
    rectangle -> right[0] = c[0];
    rectangle -> right[1] = c[1];
    rectangle -> left[0] = d[0];
    rectangle -> left[1] = d[1];
    rectangle -> color = j;
}
int areaRectangle(RECTANGLE* rectangle){
    return abs(rectangle->right[1]-rectangle->left[1])*abs(rectangle->right[0] - rectangle -> left[0]);
}
Color DisplayColorRectangle(RECTANGLE* rectangle){
    return rectangle->color;
}

void SetDataTriangle(TRIANGLE* triangle, const int *f, const int *s, const int *t, Color j){
    triangle -> first[0] = f[0];
    triangle -> first[1] = f[1];
    triangle -> second[0] = s[0];
    triangle -> second[1] = s[1];
    triangle -> third[0] = t[0];
    triangle -> third[1]=t[1];
    triangle -> color = j;
}
double AreaTriangle(TRIANGLE* t) {
    return 0.5 * abs(t->first[0]*t->second[1] + t->second[0]*t->third[1] + t->third[0]*t->first[1] - t->first[1]*t->second[0] - t->second[1]*t->third[0] - t->third[1]*t->first[0]);
}
Color DisplayColorTriangle(TRIANGLE* triangle){
    return triangle -> color;
}

void CreateFile(int n) {
    char file_name[20];
    sprintf(file_name, "FILE%dC.txt", n);
    FILE* f = fopen(file_name, "w");
    for (int i = 0; i < n; i++) {
        int k = rand() % 3;
        switch (k) {
            case 0:
                fprintf(f, "0 %d %d %d %d\n", rand() % 100, rand() % 100, rand() % 100, rand() % 7);
                break;
            case 1:
                fprintf(f, "1 %d %d %d %d %d\n", rand() % 100, rand() % 100, rand() % 100, rand() % 100, rand() % 7);
                break;
            case 2:
                fprintf(f, "2 %d %d %d %d %d %d %d\n", rand() % 100, rand() % 100, rand() % 100, rand() % 100, rand() % 100, rand() % 100, rand() % 7);
                break;
        }
    }
    fclose(f);
}

char* PrintColor(Color color) {
    switch (color) {
        case RED:
            return "RED";
        case ORANGE:
            return "ORANGE";
        case YELLOW:
            return "YELLOW";
        case GREEN:
            return "GREEN";
        case BLUE:
            return "BLUE";
        case DARKBLUE:
            return "DARKBLUE";
        case VIOLET:
            return "VIOLET";
        default:
            return "";
    }
}

void SortFile(const int n) {
    char file_name[20];
    char rfile_name[20];
    sprintf(file_name, "SortFILE%dC++.txt", n);
    sprintf(rfile_name, "FILE%dC++.txt", n);
    FILE* f = fopen(file_name, "w");
    FILE* rf = fopen(rfile_name, "r");
    fprintf(f, "Number of objects in file: %d\n", n);
    int areas[n];
    int**lines = (int**)malloc(n*sizeof(int*));
    for(int i =0; i<n;i++){
        lines[i] = (int*)malloc(8*sizeof(int));
    }
    char line[100];
    int i = 0;
    while (fgets(line, sizeof(line), rf)) {
        int k;
        sscanf(line, "%d", &k);
        if (k == 0) {
            int radius, x, y, color;
            sscanf(line, "%*d %d %d %d %d", &radius, &x, &y, &color);
            CIRCLE circle;
            // std::cout << x<<" "<< y<<std::endl;
            int f[]={x,y};
            SetDataCircle(&circle, radius, f, Color(color));
            areas[i] = areaCircle(&circle);
            lines[i][0] = 0;
            lines[i][1] = radius;
            lines[i][2] = x;
            lines[i][3]= y;
            lines[i][4] = int(color);
            // lines[i] = "CIRCLE Radius: " + (char[]){radius} Coordinate of center: (%d, %d) Color: %d Area: %d\n, radius, x, y, PrintColor(displaycolorCircle(&circle)), areaCircle(&circle);
        } else if (k == 1) {
            int x1, y1, x2, y2,color;
            sscanf(line, "%*d %d %d %d %d %d", &x1, &y1, &x2, &y2, &color);
            RECTANGLE rectangle;
            int r[]={x1,y1};
            int l[]={x2,y2};
            SetDataRectangle(&rectangle, r, l, Color(color));
            areas[i] = areaRectangle(&rectangle);
            lines[i][0] = 1;
            lines[i][1] = x1;
            lines[i][2] = y1;
            lines[i][3] = x2;
            lines[i][4] = y2;
            lines[i][5] = int(color);
            // lines[i] = "Rectangle Coordinate of left corner: (%d, %d) Coordinate of right corner: (%d, %d) Color: %s Area: %d\n", x1, y1, x2, y2, PrintColor(DisplayColorRectangle(&rectangle)), areaRectangle(&rectangle);
        } else if (k == 2) {
            int x1, y1, x2, y2, x3, y3, color;
            sscanf(line, "%*d %d %d %d %d %d %d %d", &x1, &y1, &x2, &y2, &x3, &y3, &color);
            TRIANGLE triangle;
            int f[]={x1,y1};
            int d[]={x2,y2};
            int l[]={x3,y3};
            SetDataTriangle(&triangle, f, d, l, Color(color));
            areas[i] = AreaTriangle(&triangle);
            lines[i][0]=2;
            lines[i][1]=x1;
            lines[i][2]=y1;
            lines[i][3]=x2;
            lines[i][4]=y2;
            lines[i][5]=x3;
            lines[i][6]=y3;
            lines[i][7]=int(color);
            // lines[i] = "Triangle Coordinate of first angle: (%d, %d) Coordinate of second angle: (%d, %d) Coordinate of third angle (%d,%d) Color %s Area: %d\n", x1, y1, x2, y2, x3, x3, PrintColor(DisplayColorTriangle(&triangle)), AreaTriangle(&triangle);
        }
            i++;
    }
    for (int i =0; i<n; i++){
        for (int j = i+1; j<n; j++){
            if (areas[i]>areas[j]){
                int tmp = areas[j];
                areas[j] = areas[i];
                areas[i] = tmp;
                int *s1 = (int*)&lines[i];
                int *s2 = (int*)&lines[j];
                *s1 ^=*s2;
                *s2^=*s1;
                *s1^=*s2;
            }
        }
    }
    for(int i =0; i<n; i++){
        int k = lines[i][0];
        if (k==0){
            fprintf(f, "CIRCLE Radius: %d Coordinate of center: (%d, %d) Color: %s Area: %d\n", lines[i][1], lines[i][2], lines[i][3], PrintColor(Color(lines[i][4])), areas[i]);
            // std::cout << lines[i][4]<<std::endl;
        }
        else if (k==1){
            fprintf(f,"Rectangle Coordinate of left corner: (%d, %d) Coordinate of right corner: (%d, %d) Color: %s Area: %d\n", lines[i][1], lines[i][2], lines[i][3], lines[i][4], PrintColor(Color(lines[i][5])), areas[i]);
            // std::cout << lines[i][5]<<std::endl;;
        }
        else{
            fprintf(f,"Triangle Coordinate of first angle: (%d, %d) Coordinate of second angle: (%d, %d) Coordinate of third angle (%d,%d) Color %s Area: %d\n", lines[i][1], lines[i][2], lines[i][3], lines[i][4], lines[i][5], lines[i][6], PrintColor(Color(lines[i][7])), areas[i]);
            // std::cout << lines[i][7]<<std::endl;;
        }
    }
    fclose(rf);
    fclose(f);
    free(lines);
}

int main(){
    int n;
    printf("Введите размер файла (10,100,250,500): ");
    scanf("%d", &n);
    clock_t start = clock();
    SortFile(n);
    clock_t end = clock();
    double res = (double)(end-start)/CLOCKS_PER_SEC;
    printf("%lf", res);
    // printf("%lf , %lf", start, end);
}
// void PrintColor(char* s, int color) {
//     switch (color) {
//         case 0:
//             strcpy(s, "RED");
//             break;
//         case 1:
//             strcpy(s, "ORANGE");
//             break;
//         case 2:
//             strcpy(s, "YELLOW");
//             break;
//         case 3:
//             strcpy(s, "GREEN");
//             break;
//         case 4:
//             strcpy(s, "BLUE");
//             break;
//         case 5:
//             strcpy(s, "DARKBLUE");
//             break;;
//         case 6:
//             strcpy(s, "VIOLET");
//             break;
//         default:
//             strcpy(s, "");
//             break;
//     }
// }