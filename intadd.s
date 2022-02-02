   // intadd function in this file

    .arch armv8-a
    .global intadd

intadd:
    /* Push to stack */
    stp x29, x30, [sp, -32]!
    add x29, sp, 0
    stp x19, x20, [sp, 16]
    
loop:
    /* Removed s from eor, and, lsl. Aarch64 compiler didn't like it */
    eor x19, x0, x1 /* Exclusive or */
    and x20, x0, x1 /* Get the carry */
    lsl x20, x20, 1 /* Shift carry to left by one */
    mov x0, x19 /* Put XOR or result in x0 */
    mov x1, x20 /* Put carry in x1 */
    cmp x1, 0 /* If carry is 0, addition is complete */
    bne loop
    /* Pop off stack */
    ldp x19, x20, [sp, 16]
    ldp x29, x30, [sp], 32
    ret
