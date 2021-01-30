#include "hardware/platform_defs.h"
#include "hardware/irq.h"

#if !PICO_DISABLE_SHARED_IRQ_HANDLERS
.syntax unified
.cpu cortex-m0plus
.thumb
.data
.align 2
.global irq_handler_chain_slots

.global irq_handler_chain_first_slot
.global irq_handler_chain_remove_tail
irq_handler_chain_slots:
.set next_slot_number, 1
.rept PICO_MAX_SHARED_IRQ_HANDLERS
    .hword 0
    .hword 0

    .hword 0
.if next_slot_number == PICO_MAX_SHARED_IRQ_HANDLERS
    .byte 0xff
.else
    .byte next_slot_number
.endif
    .byte 0x00
1:
    .word 0x00000000
    .set next_slot_number, next_slot_number + 1
.endr

irq_handler_chain_first_slot:
    push {lr}
    ldr  r0, [r1, #4]
    adds r1, #1
    mov  lr, r1
    bx   r0
irq_handler_chain_remove_tail:
    mov  r0, lr
    subs r0, #9
    ldr  r1, =irq_add_tail_to_free_list
    blx  r1
    pop  {pc}
#endif
