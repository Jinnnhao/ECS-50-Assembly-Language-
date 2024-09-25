## Constants
.equ PRINT_DEC 0
.equ PRINT_STR 4
.equ READ_DEC  10
.equ PRINT_FLO 2

##Data section 
    .data 
    f_msg:     .asciz "Temperature in Fahrenheit is: "
    c_msg:        .asciz "Temperature in Celsius is: "
    newline:        .asciz "\n"
    frac_5:         .float 5.0
    frac_9:         .float 9.0
    cons:           .word 32

##Code section 
    .text 
    .globl main 
main:
    #prompt 
    la x10, f_msg  
    li x17, PRINT_STR
    ecall

    #read input Fahrenheit as an integer
    li x17, READ_DEC
    ecall 
    
    
    mv x5, x10      #move the input value to x5 and x5 = the input Fahrenheit
    
    li x17, PRINT_DEC
    ecall

    la x10, newline
    li x17, PRINT_STR
    ecall
    
    #Computation: C = (F - 32) * 5/9 
    la x6, cons         #get the address of cons
    lw x6, 0(x6)        #load the vaule of cons in x6 -- x6 = 32

    sub x5, x5, x6      # x5 = x5 - x6 --- x5 = (F - 32)

    #The FP extension has its own set of 32 registers, numbered f0 to f31
    #Convert x7 from signed interge to singal precision float 
    fcvt.s.w f8, x5  # f8 = (float)x5 = (float)(F-33)

    la x6, frac_5       #get the address of frac_5 
    flw f5, 0(x6)       #get the float number 5.0 into f5 -- f5 = 5.0
    la x6, frac_9       
    flw f9, 0(x6)

    fmul.s f1, f8, f5   # f1 = f8 * f5 = (float)(F-33) * 5.0
    fdiv.s f1, f1, f9   # f1 = f1 / f9 = (float)(F-33) * 5.0 / 9.0


    #output result 
    la x10, c_msg 
    li x17, PRINT_STR
    ecall 

    fmv.s f10, f1          #move the floating point number in f8 to f10
    li x17, PRINT_FLO       
    ecall 

    la x10, newline
    li x17, PRINT_STR
    ecall

    



