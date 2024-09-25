.equ PRINT_DEC 0
.equ PRINT_STR 4
.equ READ_DEC  10
.equ READ_CHAR  13
.equ EXIT      20


.data 
result:   .asciz "Description of character ' ' is 0b    \n" 
 
.text
.globl main
main:
    li x17, READ_CHAR
    ecall 

    mv x5, x10  #move the char into x5 

    # Calculate character propoerties 
    li x1,  'A'      # ASCII value for 'A'
    li x2,  'Z'      # ASCII value for 'Z'
    li x3,  'a'      # ASCII value for 'a' (also for vowel check)
    li x4,  'z'      # ASCII value for 'z'
    li x6,  '0'
    li x7,  '9' 
    li x8,  'e'      # ASCII value for vowel check
    li x9,  'i'
    li x11, 'o'
    li x12, 'u'
    li x13, 'F'
    li x14, 'f'
    li x15, 'E'
    li x16, 'I'
    li x18, 'O'
    li x19, 'U'

    li x20, 0x0       #Let x20 be the properties word
    

        # Check if x5 >= 'A'
        bge x5, x1, if_smallerZ   # if x5>=A, go to if_smallerZ, else check if > 9 
        bgt x5, x7, symbols       # if 9 < x5 < A go to symbols , else check if > 0
        blt x5, x6, symbols       # if x5 < 0, go to symbols, else is the digit left 

        #now the rest from the left of A are the digits 
        ori x20, x20, 0x1       # set the hexa property to 1 
        j end 

        if_smallerZ: 
            ble x5, x2, check_upper     # if x5 <= Z, go to check upper, else check if < a 
            blt x5, x3, symbols  
            bgt x5, x4, symbols         
            #now the leftovers are lower case 
            ori x20, x20, 0x4   # set the lower case to 1 

            #now we can check lower case hexa and vowel 
            bgt x5, x14, check_voweli    # if x5 > f, go check vowel i, else a <= x5 <= f
            # now we can set lower case hexa to 1
            ori x20, x20, 0x1       # set the hexa property to 1 
            
            # find a and e 
            bne x5, x3, check_vowele  # if x5 != a, then check vowel e 
            ori x20, x20, 0x2         # if x5 == a, then set vowel case to 1
            j end 

            check_vowele: 
                bne x5, x8, end         #if x5 != e, then go to end
                ori x20, x20, 0x2       # if x5 == a, then set vowel case to 1
                j end 
            
            check_voweli:               
            bne x5, x9, check_vowelo     # if x5 != i, then go to check vowel o
            ori x20, x20, 0x2       # if x5 == i, then set vowel case to 1
            j end 

            check_vowelo:
            bne x5, x11, check_vowelu     # if x5 != o, then go to check vowel u 
            ori x20, x20, 0x2       # if x5 == o, then set vowel case to 1
            j end 

            check_vowelu:
            bne x5, x12, end 
            ori x20, x20, 0x2       # if x5 == u, then set vowel case to 1
            j end 

        check_upper:
            # now the leftovers are all upper case 
            ori x20, x20, 0x8       # set the upper case to 1 

            # now check upper case hexa digit 
            bgt x5, x13, check_vowelI    # if x5 > F, go check vowel I, else A <= x5 <= F
            ori x20, x20, 0x1            # set the upper case hexa digit to 1

            # fine A and E in upper hexa digit 
            bne x5, x1, check_vowelE      # if x5 != A, go check E, else x5 == A 
            ori x20, x20, 0x2            # set the vowel case to 1
            j end

            check_vowelE:
            bne x5, x15, end        #if x5 != E, go to end, else x5 == E 
            ori x20, x20, 0x2            # set the vowel case to 1
            j end 

            check_vowelI:
            bne x5, x16, check_vowelO   # if x5 != I, go check O, else x5 == I 
            ori x20, x20, 0x2            # set the vowel case to 1
            j end 

            check_vowelO:
            bne x5, x18, check_vowelU   # if x5 != O, go check U, else x5 == O
            ori x20, x20, 0x2            # set the vowel case to 1
            j end 

            check_vowelU:
            bne x5, x19, end        # if x5 != U, go to end, else x5 == U 
            ori x20, x20, 0x2            # set the vowel case to 1
            j end 


        symbols:        # are all 0s

            j end
        


        end: # all the symbol will output 0, so do need to consider the case of symbols 
        #Convert description word x20 in into ASCII
        li x21, 4  #loop flag
        li x22, 1 

        # N = 38 
        # So store from right to left, 38 - 1
        # And store the reading char x5 in result 

        la x23, result  # x23 = the address of &result[0]
        sb x5, 26(x23)  # fill the reading char in result

        li  x25, 37     # The fistr indext to fill and decrease by 1 after a loop 
        add x23, x23, x25 # x23 = &result[37]

        forloop:
        andi x24, x20, 1    #Get the LSB in x20 
        addi x24, x24, '0'
        sb x24, 0(x23)      #Store the number to result[37]

        srli x20, x20, 1    # right shift x20 to get next LSB
        sub x23, x23, x22
        sub x21, x21, x22   # loop flag 
        
         bnez x21, forloop

        
        la x10, result
        li x17, PRINT_STR
        ecall


        

        





            








        


