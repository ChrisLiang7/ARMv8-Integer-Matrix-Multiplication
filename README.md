# CPE 315 Lab 4 Integer Matrix Multiplication - Performance Measurement

## Name
* Zhisong Liang
* (No partner)

## Status of my lab
* Complete

### To build:
```shell
make clean; make
```

### To run:
```shell
perf stat ./mm > p.out
```

### To test:
```shell
diff p.out outputs/N.out
```

Note that N and P above is one of:
* 16
* 64
* 256
* 1024


### To modify the size:
1. edit the matmul.h file
2. edit the line with: 
```C
#define MATRIX_SIZE
```
3. Save the file
4. Rebuild

## Issues
* No issue. :octocat:
