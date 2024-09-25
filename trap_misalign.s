## Constants
.equ PRINT_DEC 0
.equ PRINT_STR 4
.equ EXIT      20
.equ OPCODE    3 
.equ FUNC      2

## System data
    .kdata
panic:  .asciz  "Unhandled exception\n"
    .align 2
space:  .zero  128               # preserve 124 bytes for  all register 32 * 4 = 128

## System code
    .ktext
### Boot code
    .globl __mstart
__mstart:
    la      t0, __mtrap
    csrw    mtvec, t0

    la      t0, __user_bootstrap
    csrw    mepc, t0

    la      t0, space
    csrw    mscratch, t0

    mret    # Enter user bootstrap

### Trap handler
__mtrap:
# 1. Prologue: save registers
    csrrw   sp, mscratch, sp      # Swap sp and mscrath 
   
    # Save all the register in the space   (from x0 - x31)
    sw      zero, 0(sp)
    sw      ra, 4(sp)
    sw      sp, 8(sp)
    sw      gp, 12(sp)
    sw      tp, 16(sp)
    sw      t0, 20(sp)
    sw      t1, 24(sp)
    sw      t2, 28(sp)
    sw      s0, 32(sp)
    sw      s1, 36(sp)
    sw      a0, 40(sp)
    sw      a1, 44(sp)
    sw      a2, 48(sp)
    sw      a3, 52(sp)
    sw      a4, 56(sp)
    sw      a5, 60(sp)
    sw      a6, 64(sp)
    sw      a7, 68(sp)
    sw      s2, 72(sp)
    sw      s3, 76(sp)
    sw      s4, 80(sp)
    sw      s4, 80(sp)
    sw      s5, 84(sp)
    sw      s6, 88(sp)
    sw      s7, 92(sp)
    sw      s8, 96(sp)
    sw      s9, 100(sp)
    sw      s10, 104(sp)
    sw      s11, 108(sp)
    sw      t3, 112(sp) 
    sw      t4, 116(sp)
    sw      t5, 120(sp)
    sw      t6, 124(sp)  

# Body
    # Check for misaligned load access exception 
        csrr    a0, mcause              # read the exception code from mcause 
        li      a1, 0x4                   
        bne     a0, a1, Go_Exit

   
    # Fetch the instruction's representation 
        csrr    t0, mepc                # get the unaglined memory address
        lw      t1, 0(t0)               # Load the instruction at mepc (at the address)
        
        andi    t2, t1, 0x7F            # Extract opcode field (lowest 7 bits) check that it is a load 
        li      t3, OPCODE      
        bne     t2, t3, Go_Exit

        srli    t2, t1, 12              # Extract funct3 field (bits 14:12) check that it is a load word
        andi    t2, t2, 0x7
        li      t3, FUNC
        bne     t2, t3, Go_Exit               

    # Perform unaligned memory access
        csrr    t4, mtval               # Load the faulting address
        lb      a1, 0(t4)               # Fetch the first byte
        lb      a2, 1(t4)               # Fetch the second byte
        lb      a3, 2(t4)               # Fetch the third byte
        lb      a4, 3(t4)               # Fetch the fourth byte

        slli    a2, a2, 8     
        slli    a3, a3, 16
        slli    a4, a4, 24  

        or      a1, a1, a2
        or      a1, a1, a3
        or      a1, a1, a4              # t5 = the fetched word from the faulting address

    # Assign the fetched word to the instruction’s destination register 
        srli    t2, t1, 7 
        andi    t2, t2, 0x1F            # Extract [11:7] (rd) from the instruction's representation  （if rd = x5 = 0b00101, which means its index = 5, the 6th register from x0）        

    # Update the saved version of the register
        slli    t3, t2, 2               # t3 = t2 * 4 = the memory gap from x0, each register takes 4 bytes and t2 = xN, N = the index in the arr of raw register  
        add     t4, sp, t3              # get the coresponding user register's address in stack pointer 
        sw      a1, 0(t4)               # store the fecthed word in the coresponding instruction register 

    # Return to the next instruction
        csrr    t0, mepc                # load the faulty address to t0 from mepc 
        addi    t0, t0, 4               # add the address by 4 bytes which means move it to the next line of code = the next instruction
        csrw    mepc, t0                # load the next address back to mepc

#Epilogue 
        
        lw      zero, 0(sp)
        lw      ra, 4(sp)
        lw      sp, 8(sp)
        lw      gp, 12(sp)
        lw      tp, 16(sp)
        lw      t0, 20(sp)
        lw      t1, 24(sp)
        lw      t2, 28(sp)
        lw      s0, 32(sp)
        lw      s1, 36(sp)
        lw      a0, 40(sp)
        lw      a1, 44(sp)
        lw      a2, 48(sp)
        lw      a3, 52(sp)
        lw      a4, 56(sp)
        lw      a5, 60(sp)
        lw      a6, 64(sp)
        lw      a7, 68(sp)
        lw      s2, 72(sp)
        lw      s3, 76(sp)
        lw      s4, 80(sp)
        lw      s5, 84(sp)
        lw      s6, 88(sp)
        lw      s7, 92(sp)
        lw      s8, 96(sp)
        lw      s9, 100(sp)
        lw      s10, 104(sp)
        lw      s11, 108(sp)
        lw      t3, 112(sp) 
        lw      t4, 116(sp)
        lw      t5, 120(sp)
        lw      t6, 124(sp) 

        csrrw   sp, mscratch, sp         # swap back sp and mscratch 

        mret                             # return 
        
    Go_Exit:
        la  a0, panic
        li  a7, PRINT_STR
        ecall 
 
        li a0, 1
        li a7, EXIT 
        ecall
        
## User boot code

.text
__user_bootstrap:
    # exit(main())
    jal     main
    li      a7, EXIT
    ecall


