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
    /* Load balance from memory */
    ldr r1, =balance
    ldr r2, [r1]

    /* Check if transaction amount in r0 is within range (-1000 to 1000) */
    mov r3, #1000
    cmp r0, r3
    bgt overflow_error
    rsb r3, r3, #0  /* r3 = -1000 */
    cmp r0, r3
    blt overflow_error

    /* Calculate tmpBalance = balance + transaction */
    adds r4, r2, r0  /* r4 = tmpBalance */
    bvs overflow_error  /* Branch if overflow occurs */

    /* Store transaction amount */
    ldr r5, =transaction
    str r0, [r5]

    /* Store new balance */
    str r4, [r1]

    /* Set output variables based on new balance */
    ldr r6, =eat_out
    ldr r7, =stay_in
    ldr r8, =eat_ice_cream
    mov r9, #0
    str r9, [r6]
    str r9, [r7]
    str r9, [r8]

    cmp r4, #0
    beq set_stay_in
    bmi set_eat_ice_cream
    b set_eat_out

set_stay_in:
    mov r9, #1
    str r9, [r7]
    b done

set_eat_ice_cream:
    mov r9, #1
    str r9, [r8]
    b done

set_eat_out:
    mov r9, #1
    str r9, [r6]
    b done

overflow_error:
    ldr r10, =we_have_a_problem
    mov r9, #1
    str r9, [r10]
    b done
    
    /*** STUDENTS: Place your code ABOVE this line!!! **************/

done:    
    /* restore the caller's registers, as required by the 
     * ARM calling convention 
     */
    pop {r4-r11,LR}

    mov pc, lr	 /* asmFunc return to caller */
   

/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */
           




