////////////////////////////////////////////////////////////////////////////////
//! C = A * B
//! @param C          result matrix
//! @param A          matrix A 
//! @param B          matrix B
//! @param hA         height of matrix A
//! @param wA         width of matrix A, height of matrix B
//! @param wB         width of matrix B
//
//  Note that while A, B, and C represent two-dimensional matrices,
//  they have all been allocated linearly. This means that the elements
//  in each row are sequential in memory, and that the first element
//  of the second row immedialely follows the last element in the first
//  row, etc. 
//
//void matmul(int* C, const int* A, const int* B, unsigned int hA, 
//    unsigned int wA, unsigned int wB)
//{
//  for (unsigned int i = 0; i < hA; ++i)
//    for (unsigned int j = 0; j < wB; ++j) {
//      int sum = 0;
//      for (unsigned int k = 0; k < wA; ++k) {
//        sum += A[i * wA + k] * B[k * wB + j];
//      }
//      C[i * wB + j] = sum;
//    }
//}
////////////////////////////////////////////////////////////////////////////////

	.arch armv8-a
	.global matmul
matmul:
	//allocate spaces
	stp x29, x30, [sp, -16]!
	stp x19, x20, [sp, -16]!
	stp x21, x22, [sp, -16]!
	stp x23, x24, [sp, -16]!
	stp x25, x26, [sp, -16]!
	stp x27, x28, [sp, -16]!

	//save incoming parameters to callee-saved registers
	mov x19, x0 // x19 = C result matrix, address of head of Matrix C
	mov x20, x1 // x20 = A Matrix A, address of head of Matrix A
	mov x21, x2 // x21 = B Matrix B, address of head of Matrix B
	mov x22, x3 // x22 = hA height of matrix A
	mov x23, x4 // x23 = wA width of matrix A, height of matrix B
	mov x24, x5 // x24 = wB width of matrix B
	mov x25, 0 // x25 = i = 0

	mov x0, sp
	mov x1, -16
	bl intadd
	mov sp, x0

loop1:
	cmp x25, x22 // i < hA
	b.ge end  //end the loop
	mov x26, 0 // x26 = j = 0 

loop2:
	cmp x26, x24 // j < wB
	b.ge inci
	mov x28, 0 // sum = 0
    mov x27, 0 // x27 = k = 0

loop3:
	cmp x27, x23 // k < wA
	b.ge assignC
	//sum += A[i * wA + k] * B[k * wB + j];
	mul x0, x25, x23
	mov x1, x27
	bl intadd
	lsl x0, x0, 2 //multiply i by 4 because of 4 byte ints
	mov x1, x20
	bl intadd
	ldr x0, [x0] //load value A[i * wA + k]
	str x0, [sp]
	
	mul x0, x27, x24
	mov x1, x26
	bl intadd
	lsl x0, x0, 2 //multiply i by 4 because of 4 byte ints
	mov x1, x21
	bl intadd
	ldr x0, [x0] //load value B[k * wB + j]
	ldr x1, [sp]
	mul x0, x0, x1
	mov x1, x28
	bl intadd
	mov x28, x0
	//sum += A[i * wA + k] * B[k * wB + j];
	mov x0, x27
	mov x1, 1
	bl intadd
	mov x27, x0// ++k
	b loop3
	
assignC:
	//C[i * wB + j] = sum;
	mul x0, x25, x24
	mov x1, x26
	bl intadd
	lsl x0, x0, 2 //multiply i by 4 because of 4 byte ints
	mov x1, x19
	bl intadd
	str x28, [x0]
	//C[i * wB + j] = sum;
	mov x0, x26
	mov x1, 1
	bl intadd
	mov x26, x0 // ++j
	b loop2

inci:
	mov x0, x25
	mov x1, 1
	bl intadd
	mov x25, x0 // ++i
	b loop1

end:
	mov x0, sp
	mov x1, 16
	bl intadd
	mov sp, x0
	ldp x27, x28, [sp], 16
	ldp x25, x26, [sp], 16
	ldp x23, x24, [sp], 16
	ldp x21, x22, [sp], 16
	ldp x19, x20, [sp], 16
	ldp x29, x30, [sp], 16
	ret
