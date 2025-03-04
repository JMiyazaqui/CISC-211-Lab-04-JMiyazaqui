/*** asmFunc.s   ***/
/* Tell the assembler to allow both 16b and 32b extended Thumb instructions */
.syntax unified

#include <xc.h>

/* Tell the assembler that what follows is in data memory    */
.data
.align

.global balance,transaction,eat_out,stay_in,eat_ice_cream,we_have_a_problem
.type balance,%gnu_unique_object
.type transaction,%gnu_unique_object
.type eat_out,%gnu_unique_object
.type stay_in,%gnu_unique_object
.type eat_ice_cream,%gnu_unique_object
.type we_have_a_problem,%gnu_unique_object

/* NOTE! These are only initialized ONCE, right before the program runs.
 * If you want these to be 0 every time asmFunc gets called, you must set
 * them to 0 at the start of your code!
 */
balance:           .word     0  /* input/output value */
transaction:       .word     0  /* output value */
eat_out:           .word     0  /* output value */
stay_in:           .word     0  /* output value */
eat_ice_cream:     .word     0  /* output value */
we_have_a_problem: .word     0  /* output value */

.align
 
/* define and initialize global variables that C can access */
/* create a string */
.global nameStr
.type nameStr,%gnu_unique_object
    
/*** STUDENTS: Change the next line to your name!  **/
nameStr: .asciz "Julio Miyazaqui"  

.align   /* realign so that next mem allocations are on word boundaries */
 
/* initialize a global variable that C can access to print the nameStr */
.global nameStrPtr
.type nameStrPtr,%gnu_unique_object
nameStrPtr: .word nameStr   /* Assign the mem loc of nameStr to nameStrPtr */
.align

    
/* Tell the assembler that what follows is in instruction memory    */
.text
.align


    
/********************************************************************
function name: asmFunc
function description:
     output = asmFunc ()
     
where:
     output: the integer value returned to the C function
     
     function description: The C call ..........
     
     notes:
        None
          
********************************************************************/    
.global asmFunc
.type asmFunc,%function
asmFunc:   

    /* save the caller's registers, as required by the ARM calling convention */
    push {r4-r11,LR}
 
    
    /*** STUDENTS: Place your code BELOW this line!!! **************/
    /* Initialize output variables to 0 */
    LDR r4, =transaction
    MOV r5, #0
    STR r5, [r4]
    LDR r4, =eat_out
    STR r5, [r4]
    LDR r4, =stay_in
    STR r5, [r4]
    LDR r4, =eat_ice_cream
    STR r5, [r4]
    LDR r4, =we_have_a_problem
    STR r5, [r4]

    /* Load balance into r6 and transaction (r0) into r7 */
    LDR r6, =balance
    LDR r6, [r6]
    MOV r7, r0

    /* Check if transaction is out of range (-1000 to 1000) */
    CMP r7, #1000
    BGT handle_problem
    CMP r7, #-1000
    BLT handle_problem

    /* Compute tmpBalance = balance + transaction and check for overflow */
    ADDS r8, r6, r7  /* Adds with flag update */
    BVS handle_problem  /* Branch if overflow occurred */

    /* Store new balance */
    LDR r9, =balance
    STR r8, [r9]

    /* Store valid transaction */
    LDR r4, =transaction
    STR r7, [r4]

    /* Decision logic based on new balance */
    CMP r8, #0
    BGT set_eat_out
    BLT set_stay_in

    /* If balance == 0, set eat_ice_cream = 1 */
    LDR r4, =eat_ice_cream
    MOV r5, #1
    STR r5, [r4]
    B update_r0

set_eat_out:
    LDR r4, =eat_out
    MOV r5, #1
    STR r5, [r4]
    B update_r0

set_stay_in:
    LDR r4, =stay_in
    MOV r5, #1
    STR r5, [r4]
    B update_r0

handle_problem:
    /* Invalid transaction: reset transaction and flag an issue */
    LDR r4, =transaction
    MOV r5, #0
    STR r5, [r4]
    LDR r4, =we_have_a_problem
    MOV r5, #1
    STR r5, [r4]
    LDR r4, =balance
    STR r6, [r4]  /* Restore balance */
    B update_r0

update_r0:
    /* Update r0 with new balance value */
    LDR r4, =balance
    LDR r0, [r4]

    B done

    /*** STUDENTS: Place your code ABOVE this line!!! **************/

done:    
    /* restore the caller's registers, as required by the 
     * ARM calling convention 
     */
    pop {r4-r11,LR}

    mov pc, lr	 /* asmFunc return to caller */
   

/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */
           
