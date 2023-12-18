#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <string.h>
#include "malloc.h"
int AreaCircle(int radius){
    return (int)3.14*radius*radius;
}
int AreaRectangle(int* right, int* left){
    return abs(right[1]-left[1])*abs(right[0] - left[0]);
}
int AreaTriangle(int* first, int* second, int* third) {
    return 0.5 * abs(first[0]*second[1] + second[0]*third[1] + third[0]*first[1] - first[1]*second[0] - second[1]*third[0] - third[1]*first[0]);
}
char* PrintColor(int color) {
    switch (color) {
        case 0:
            return "RED";
        case 1:
            return "ORANGE";
        case 2:
            return "YELLOW";
        case 3:
            return "GREEN";
        case 4:
            return "BLUE";
        case 5:
            return "DARKBLUE";
        case 6:
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
    while (fgets(line, 100 , rf)!=NULL) {
        int k;
        sscanf(line, "%d", &k);
        if (k == 0) {
            int radius, x, y, color;
            sscanf(line, "%*d %d %d %d %d", &radius, &x, &y, &color);
            int f[]={x,y};
            areas[i] = AreaCircle(radius);
            lines[i][0] = 0;
            lines[i][1] = radius;
            lines[i][2] = x;
            lines[i][3]= y;
            lines[i][4] = color;
        } else if (k == 1) {
            int x1, y1, x2, y2,color;
            sscanf(line, "%*d %d %d %d %d %d", &x1, &y1, &x2, &y2, &color);
            int r[]={x1,y1};
            int l[]={x2,y2};
            areas[i] = AreaRectangle(r, l);
            lines[i][0] = 1;
            lines[i][1] = x1;
            lines[i][2] = y1;
            lines[i][3] = x2;
            lines[i][4] = y2;
            lines[i][5] = int(color);
        } else if (k == 2) {
            int x1, y1, x2, y2, x3, y3, color;
            sscanf(line, "%*d %d %d %d %d %d %d %d", &x1, &y1, &x2, &y2, &x3, &y3, &color);
            int f[]={x1,y1};
            int d[]={x2,y2};
            int l[]={x3,y3};
            areas[i] = AreaTriangle(f,d,l);
            lines[i][0]=2;
            lines[i][1]=x1;
            lines[i][2]=y1;
            lines[i][3]=x2;
            lines[i][4]=y2;
            lines[i][5]=x3;
            lines[i][6]=y3;
            lines[i][7]=int(color);
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
            fprintf(f, "CIRCLE Radius: %d Coordinate of center: (%d, %d) Color: %s Area: %d\n", lines[i][1], lines[i][2], lines[i][3], PrintColor(lines[i][4]), areas[i]);
        }
        else if (k==1){
            fprintf(f,"Rectangle Coordinate of left corner: (%d, %d) Coordinate of right corner: (%d, %d) Color: %s Area: %d\n", lines[i][1], lines[i][2], lines[i][3], lines[i][4], PrintColor(lines[i][5]), areas[i]);
        }
        else{
            fprintf(f,"Triangle Coordinate of first angle: (%d, %d) Coordinate of second angle: (%d, %d) Coordinate of third angle (%d,%d) Color %s Area: %d\n", lines[i][1], lines[i][2], lines[i][3], lines[i][4], lines[i][5], lines[i][6], PrintColor(lines[i][7]), areas[i]);
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
}