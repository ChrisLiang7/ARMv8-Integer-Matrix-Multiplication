    // intmul function in this file

    .arch armv8-a
    .global intmul
intmul:
    /* Push to stack */
    stp x29, x30, [sp, -48]!
    add x29, sp, 0
    stp x19, x20, [sp, 16]
    stp x21, xzr, [sp, 32]
    /* --------------- */
    mov x19, x0 /* Multiplicand in x19 */
    mov x20, x1 /* Multiplier in x20 */
    mov x0, 0 /* Product in x0 */
loop:
    cmp x20, 0 /* Multiplier != 0 */
    beq done
    and x2, x20, 1 /* Get LSB of multiplier */
    cmp x2, 1 /* If LSB(multiplier) == 1 */
    bne shift
    mov x1, x19 /* Move multiplicand to x1 */
    bl intadd
shift:
    lsr x20, x20, 1 /* Mutilpier >>= 1 */
    lsl x19, x19, 1 /* Multiplicand <<= 1 */
    b loop
done:
    /* Pop off stack */
    ldp x19, x20, [sp, 16]
    ldp x21, xzr, [sp, 32]
    ldp x29, x30, [sp], 48
    /* Exit gracefully */
    ret
