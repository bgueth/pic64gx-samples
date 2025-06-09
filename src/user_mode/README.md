# User mode
This example switches to user mode after initialization. 

##  Objectives
* changing privilege level
* defining system calls
* exception handling


## Changing privilege levels
In RISC-V there is no such thing as a command or register one can write to, which changes the privilege mode of the hart.

Privilege level change can be achieved, by using interrupts' state resetting mechanism. When an interrupt occurs, the hart calls the interrupt handler. Just before, it performs some actions as described in *machine timer* example. Some of them aim to save the current state of the hart, before it executes the interrupt handler. It uses this information, to restore the state as it left, when returning to normal execution of the program.

Up to now, all code ran in machine mode and the interrupt has been treated in machine mode. However, regardless of the hart's current execution mode, the interrupt is always handled in the privilege level it occurs in. By default, interrupts occur in machine mode, but they can be delegated to lower modes. This is object of an other example.

In the present case, when an interrupt handler is called, the hart changes to machine mode. It stores the current mode in the `MPP` (Machine Prior Privilege) bits of the `mstatus` register and the current program counter in the `mepc` (Machine Exeception Program Counter) register.  When the interrupt handler finishes, the hart sets the program counter back to the value stored in `mepc` and changes to the privilege mode stored in the `MPP` bits of `mstatus`. 

Changing priviledge modes can be performed by manupulating the `MPP` bits during interrupt execution. 

## System calls

```
    la t0, thread_store
    csrw mscratch, t0
```

This example uses the `mscratch` register to point at a memory region in the data segment, where the interrupt handler can save registers for later restore. Data sections and other sections compilers normally use have been added to the [linker script](linker.ld).

Since the example runs on a single hart, no guard to prevent concurrent access to this region is required.

```
    csrr a6, mscratch
    sd t0, (a6)
    sd t1, 8(a6)
```

At the beginning of the interrupt handler, the mscratch register is used to store all registers, the interrupt handler will use and thus will change from the initial state.

The `ecall` instruction triggers the interrupt handler. It is executed during the `_start` section, after initialization of GPIO unit and interrupt setup has finished. When the ECALL is executed, the hart performs the same tasks as when an interrupt occurs and by this sets the `mcause` register to the appropriate value. When `ecall` is executed, the hart is running in machine mode. This for, the value of `mcause` is set to `MCAUSE_ECALL_M`. 

```
    csrr a6, mcause
0:
    li t0, MCAUSE_ECALL_M
    bne a6, t0, 1f
```

The interrupt handler uses the `mcause` register to identify, if the interrupt has been executed by an ECALL. If so, it executes the following code.

```
    csrr a6, mstatus
    li t0, MSTATUS_MPP0_MASK
    li t1, MSTATUS_MPP1_MASK
    or t0, t0, t1
    not t0, t0
    and t0, t0, a6
    csrw mstatus, t0
```
The `MPP` bits of `mstatus` are cleared by and-ing the current value of `mstatus` with the inverted bitmask. When the hart returns to normal execution, this will change the privilege level to user mode.

```
    csrr t0, mepc
    addi t0, t0, 4
    csrw mepc, t0
```

When `mret` is executed, it will return to the address stored in `mepc`. For an ECALL, this points to the address of the `ecall` instruction itself. To continue execution, the handler must advance by 32 bit, which is the size of a RISC-V instruction.

## Exception handling
As there is no register to change the privilege mode of a hart, there is no register to read the current privilege mode from.

As a common workaround, the program tries to set a bit in the `mstatus` register. While operating in user mode, the hart cannot access the `mstatus` register. As consequence, this operation causes a "Illegal instruction" exception and fires the interrupt handler. This time, checking `mcause` for an ECALL will fail and the branch is taken to the illegal instruction check.

```
    li t0, MCAUSE_INST_ILLEGAL
    bne a6, t0, 255f
    li a6, GPIO1_BASE
    li t0, 4                // turn on LED1
    sw t0, GPIO_GPOUT(a6)
```

If the handler is called for an illegal instruction, it will simply turn the LED on, as indication that the handler treated an illegal instruction case.
