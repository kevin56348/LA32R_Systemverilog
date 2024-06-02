.text
.org 0
.global _start
_start: # 1c000000
    addi.w $r1, $r0, 1
    addi.w $r2, $r0, 2
    
    addi.w $r4, $r0, 1
    addi.w $r5, $r0, 2

    addi.w $r0, $r0, 0 # NOP

    addi.w $r3, $r0, 0x7FF
    addi.w $r3, $r3, 0x001
    addi.w $r3, $r3, 0x7FF
    addi.w $r3, $r3, 0x001

    addi.w $r3, $r3, 0x7FF
    addi.w $r3, $r3, 0x001
    addi.w $r3, $r3, 0x7FF
    addi.w $r3, $r3, 0x001
    
    addi.w $r3, $r3, 0x7FF
    addi.w $r3, $r3, 0x001
    addi.w $r3, $r3, 0x7FF
    addi.w $r3, $r3, 0x001

    addi.w $r3, $r3, 0x7FF
    addi.w $r3, $r3, 0x001
    addi.w $r3, $r3, 0x7FF
    addi.w $r3, $r3, 0x001

    addi.w $r3, $r3, 0x7FF
    addi.w $r3, $r3, 0x001
    addi.w $r3, $r3, 0x7FF
    addi.w $r3, $r3, 0x001

    addi.w $r3, $r3, 0x7FF
    addi.w $r3, $r3, 0x001
    addi.w $r3, $r3, 0x7FF
    addi.w $r3, $r3, 0x001

    addi.w $r3, $r3, 0x7FF
    addi.w $r3, $r3, 0x001
    addi.w $r3, $r3, 0x7FF
    addi.w $r3, $r3, 0x001

    addi.w $r3, $r3, 0x7FF
    addi.w $r3, $r3, 0x001
    addi.w $r3, $r3, 0x7FF
    addi.w $r3, $r3, 0x001

    addi.w $r3, $r3, 0x7FF
    addi.w $r3, $r3, 0x001
    addi.w $r3, $r3, 0x7FF
    addi.w $r3, $r3, 0x001
    
    addi.w $r3, $r3, 0x7FF
    addi.w $r3, $r3, 0x001
    addi.w $r3, $r3, 0x7FF
    addi.w $r3, $r3, 0x001

    addi.w $r3, $r3, 0x7FF
    addi.w $r3, $r3, 0x001
    addi.w $r3, $r3, 0x7FF
    addi.w $r3, $r3, 0x001

    addi.w $r3, $r3, 0x7FF
    addi.w $r3, $r3, 0x001
    addi.w $r3, $r3, 0x7FF
    addi.w $r3, $r3, 0x001

    addi.w $r3, $r3, 0x7FF
    addi.w $r3, $r3, 0x001
    addi.w $r3, $r3, 0x7FF
    addi.w $r3, $r3, 0x001

    addi.w $r3, $r3, 0x7FF
    addi.w $r3, $r3, 0x001
    addi.w $r3, $r3, 0x7FF
    addi.w $r3, $r3, 0x001

    addi.w $r3, $r3, 0x7FF
    addi.w $r3, $r3, 0x001
    addi.w $r3, $r3, 0x7FF
    addi.w $r3, $r3, 0x001

    addi.w $r3, $r3, 0x7FF
    addi.w $r3, $r3, 0x001
    addi.w $r3, $r3, 0x7FF
    addi.w $r3, $r3, 0x001

    st.w $r1, $r3, 0x000
    st.w $r2, $r3, 0x004

    addi.w $r1, $r2, 0x1
    addi.w $r2, $r1, 0x1

    st.w $r1, $r3, 0x008
    st.w $r2, $r3, 0x00c

    ld.w $r1, $r3, 0x000
    ld.w $r2, $r3, 0x000

    beq $r1, $r4, 0x10
    beq $r2, $r3, 0x10

    addi.w $r1, $r0, 1
    beq $r0, $r1, 0 # forever, failed， 1c000140

    beq $r0, $r0, 0 # forever, success, 1c000144
