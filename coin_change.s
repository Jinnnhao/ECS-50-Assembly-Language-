##Constants -- value of coins
.equ PRINT_DEC 0
.equ PRINT_STR 4
.equ READ_DEC  10
.equ EXIT      20


##Data Section 
.data 
msg:   .asciz "Amount of cents to change: "
msgOfquater:    .asciz "Number of quarters: "
msgOfdimes:     .asciz "Number of dimes: "
msgOfnickels:   .asciz "Number of nickels: "
msgOfpennies:   .asciz "Number of pennies: "
newline:        .asciz "\n"
quarters:       .word 25
dimes:          .word 10
nickels:        .word 5
pennies:        .word 1

##Code section 
.text
.globl main 
main:
    # prompt user 
    la x10, msg  # get msg's memory address
    li x17, PRINT_STR
    ecall

    #read user input
    li x17, READ_DEC
    ecall

    

    # Computation 
    mv x5, x10      #move input value to x5 and x5 = the number of change

    li x17, PRINT_DEC
    ecall

    la x10, newline
    li x17, PRINT_STR
    ecall

   
    # for quarters
    la x6, quarters #get quarters' memory address 
    lw x6, 0(x6)    #load quarters' value in x6 -- x6 = 25
    div x7, x5, x6  # ex: x7 = x5 / x6 == 42/25 = 1

    la x10, msgOfquater  # print the number of quarters x7 = 1
    li x17, PRINT_STR
    ecall
    mv x10, x7           # number of quarters x7 = 1
    li x17, PRINT_DEC 
    ecall 
    la x10, newline
    li x17, PRINT_STR
    ecall
    rem x5, x5, x6       # x5 = x5 % x6 = 42 % 25 = 17, get the remain for the rest 

    #for dimes
    la x6, dimes    # get dimes' memory address in x6 
    lb x6,0(x6)     # load dimes' value in x6 -- x6 = 10
    div x7, x5, x6 #ex: x7 = 17 / 10 = 1, number of dimes = 1
    la x10, msgOfdimes 
    li x17, PRINT_STR 
    ecall
    mv x10, x7      #move the number of dimes = 1 into x10 to output 
    li x17, PRINT_DEC
    ecall
    la x10, newline
    li x17, PRINT_STR
    ecall
    rem x5, x5, x6 # ex: x5 = 17 % 10 = 7, get the remain the rest 

    #for nickels
    la x6, nickels  #get nickels' memory address in x6
    lw x6, 0(x6)    #load nickels' value in x6 -- x6 = 5
    div x7, x5, x6  # ex: x7 = 7 / 5 = 1, number of nickels = 1
    la x10, msgOfnickels 
    li x17, PRINT_STR
    ecall
    mv x10, x7
    li x17, PRINT_DEC
    ecall 
    la x10, newline
    li x17, PRINT_STR
    ecall
    rem x5, x5, x6 # ex: x5 = 7 % 5 = 2 

    #for pennies
    la x6, pennies  #get pennies' memory address in x6
    lw x6, 0(x6)    #load pennies' value in x6 -- x6 = 1
    div x7, x5, x6   # ex: x7 = 2 / 1 = 2, numbr of pennies 
    la x10, msgOfpennies  # print out lines of pennies
    li x17, PRINT_STR
    ecall
    mv x10, x7
    li x17, PRINT_DEC
    ecall  
    la x10, newline
    li x17, PRINT_STR
    ecall

