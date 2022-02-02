CXX = g++
CC = gcc
CXXFLAGS = -ggdb -Wall -O2 
CFLAGS = -ggdb -Wall 
CXXSRCS = matmul-driver.cpp 
ASRCS = matmul-mul.s intmul.s intadd.s 
BIN = mm

all:
	$(CXX) $(CXXFLAGS) -c $(CXXSRCS)
	$(CC) $(CFLAGS) -c $(ASRCS)
	$(CC) $(CFLAGS) -o $(BIN) *.o

clean:
	rm -f *.o $(BIN)
