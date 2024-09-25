## Constants
.equ PRINT_DEC 0
.equ PRINT_STR 4
.equ READ_DEC  10
.equ MAX_SIZE  10          #maximum 10 integer can be hold 

.data 
arr:            .zero 40
found:          .asciz "Found at index "
notFound:       .asciz "Not found"
newline:        .asciz "\n"


.text
.globl main


load: 
    #read data from the user, stop when reaches maximum capacity is 10,
    # or read nagtive input 
    
    #Prologue
    addi sp, sp, -8                 #Alocate a stack with 2 elements 
    sw ra, 0(sp)                    #preserve ra in stack 
    sw a1, 4(sp)                    #store parameter a1 == &arr[0] in the stack 
    
    #body
    
    mv t2, a2                       # t2 = a2 = size 10 
    load_loop:
        beq t2, x0, end_loop            #if a2 == 0, then stop reading

        li a7, READ_DEC              #read data from user 
        ecall

        blt a0, x0, end_loop         #if the input < 0, then stop reading 
        li t3, -1                    # special value -1 
        beq a0, t3, end_loop         # if the input = -1, stoping reading 
        
        sw a0, 0(a1)                 #store the first input in arr[0]
        addi t2, t2, -1              # a2--  size - 1
        addi a1, a1, 4               #move arr address to the next position 

        j load_loop

    end_loop:
        #Epilogue 
        lw ra, 0(sp)                     #restore ra 
        lw a1, 4(sp)                     #restore &arr[0] to a1 and return a1 
        sub a2, a2, t2                   #return a2 = the size of arr after input
        addi sp, sp, 8                   #close the stack 
        jr ra                            #jump back to main 





sort:   
    #insertion sort algorithm in ascending order 
    # parameter a1 == &arr[0] 
    # parameter a2 = size of loaded array 

    #Prologue
    addi sp, sp, -12                 #Alocate a stack with 2 elements 
    sw ra, 0(sp)                    #preserve ra in stack 
    sw a1, 4(sp)                    #store parameter a1 == &arr[0] in the stack 
    sw a2, 8(sp)                    #store the size a2 in the stack 

    #body 
    li t0, 1                        # i == 1

    while_1: 
        bge t0, a2, end_sort    #if i >= a2, end loop 
        
        mv t1, t0                   # t1 = j = i = index 
        
        while_2: 
            blez t1, end_while_2    # if t1 = j <= 0, end while_2
            
            #get arr[j]
            addi t2, a1, 0            # get t2 = &arr[0]
            slli t3, t1, 2          # left shift index j by 2 == j * 4 = the memory gap from indext 0
            add t2, t2, t3          # t2 = &arr[0] + t3 = &arr[j]
            lw  t4, 0(t2)           # t4 = arr[j]

            #get arr[j-1]
            addi t5, t2, -4         #t5 = &arr[j] - 4 = &arr[j-1]
            lw t6, 0(t5)            #t6 = arr[j-1]

            ble t6, t4, end_while_2 # if(arr[j-1] <= arr[j]), end while_2
            
            #swap, if arr[j-1] > arr[j]
            sw t4, 0(t5)            # store t4 into &arr[j-1] = t5
            sw t6, 0(t2)            # store t6 into &arr[j] = t2

            addi t1, t1, -1         # j = j - 1

            j while_2 

        end_while_2:
            
            addi t0, t0, 1          # i = i + 1 

            j while_1

    end_sort: 
        #Epilogue 
        lw ra, 0(sp)                
        lw a1, 4(sp)                #restore &arr[0] to a1 and return a1 
        lw a2, 8(sp)                #restore arr size to a2 and return a2
        addi sp, sp, 12             #close stack
        jr ra





bsearch:
        #Prologue 
        addi sp, sp, -4                #Alocate a stack with 1 elements 
        sw ra, 0(sp)                   #preserve ra in stack 
        
        #body

            addi t1, a1, 0              #t1 = &arr[0] + 0 = &arr[0]
            addi t2, a2, 0              #t2 = high index 
            addi t3, a4, 0              #t3 = low = index 0

            blt t2, t3, not_found       #if higt < low, go to not_found

            
        
            add t4, t2, t3          #t4 = t2 + t3 
            srli t4, t4, 1          #right shift 1 position = divided by 2
                                    #t4 = mid indext = (t2 + t3) / 2
            slli t5, t4, 2          #t5 = mid indext * 4 = the memory gap from arr[0] to arr[mid]
            add t1, t1, t5          #t1 = &arr[0] + mid * 4 = &arr[mid]

            lw t1, 0(t1)            #t1 = arr[mid]

            # if arr[mid] > key, go to the lower half of the arry 
            bgt t1, a3, lower_half 
            # if arr[mid] < key, go to the higher half of the arry 
            blt t1, a3, higher_half 

            #else, arr[mid]== key, return and output mid 
            la a0, found              
            li a7, PRINT_STR
            ecall
           
            mv a0, t4                #t4 = mid index 
            li a7, PRINT_DEC
            ecall 

            la a0, newline
            li a7, PRINT_STR
            ecall


            j end_searching
        
        lower_half:
            # a2 = high = mid - 1 = t4 - 1, 
            # a4 = low, a1 = &arr[0] and a3 = key remain the same 
            addi t4, t4, -1
            addi  a2, t4, 0             #a2 = new high = mid - 1 
            jal bsearch

            j end_searching

        higher_half:
            # a4 = low = mid + 1 = t4 + 1 
            # a1 = &arr[0], a2 = high, a3 = key remain the same
            addi t4, t4, 1
            addi a4, t4, 0              #a4 = new low = mid + 1
            jal bsearch

            j end_searching



        not_found:
            # Print "Not found"
            la a0,  notFound
            li a7, PRINT_STR
            ecall 

            la a0, newline
            li a7, PRINT_STR
            ecall

            j end_searching

        # Epilogue 
    end_searching: 
        lw ra, 0(sp) 
        addi sp, sp, 4 
        jr ra 




find: 
    # It reads integers from the user, one at a time and launches a search 
    # and displays the result of the search
    #  The function stops reading integers from the user once the user inputs a negative number.

    # Prologue
    addi sp, sp, -12                #Alocate a stack with 3 elements 
    sw ra, 0(sp)                    #preserve ra in stack 
    sw a1, 4(sp)                    #store parameter a1 == &arr[0] in the stack 
    sw a2, 8(sp)                    #store the size a2 in the stack 
    
    #body
    reading_data:
        li a7, READ_DEC             #read data from user 
        ecall 

        mv a3, a0                   #move data to parameter a3 as a key for search 

        blt a3, x0, end_reading     #if the input data < 0, go to end_reading 
        li t1, -1                   #speical value -1 
        beq a3,t1, end_reading      #if input data = -1, go to end_reading 

        li a4, 0                    # initial low == 0 
        # go to search 
        addi a2, a2, -1             # a2 = size - 1 = high index
        jal bsearch

        lw a1, 4(sp)                # restore a1 = &arr[0]
        lw a2, 8(sp)                # restore a2 = size of arr

        j reading_data


    #Epilogue
    end_reading:
        lw a1, 4(sp)
        lw a2, 8(sp)
        lw ra, 0(sp)
        addi sp, sp, 12
        jr ra 


main:
    
    #Prologue
    addi sp, sp, -12               #Alocate stack 
    sw ra, 0(sp)                    #preserve ra in stack 

    la a1, arr                      # a1 == &arr[0], will become the arrgument register 
    sw a1, 4(sp)  


    li a2, 10          #len = a2 = max_size = 10 
    sw a2, 8(sp)


    #body
    
    jal load 
    sw a1, 4(sp)
    sw a2, 8(sp)

    lw a1, 4(sp)
    lw a2, 8(sp)
    jal sort 
    sw a1, 4(sp)
    sw a2, 8(sp)

    lw a1, 4(sp)
    lw a2, 8(sp)
    jal find 
    sw a1, 4(sp)
    sw a2, 8(sp)


    #Epilogue 
    lw ra, 0(sp)                    #restore ra 
    lw a1, 4(sp)
    lw a2, 8(sp)
    addi sp, sp, 8                  #restore stack 
    li a0, 0
    jr ra                 

