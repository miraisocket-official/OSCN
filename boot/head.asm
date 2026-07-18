BITS 16
ORG 0x8000

head_start:

cli

call enable_a20
call setup_gdt
call enter_protected_mode

hang:
jmp hang


enable_a20:

in al,0x92
or al,00000010b
out 0x92,al
ret


setup_gdt:

lgdt [gdt_descriptor]
ret


enter_protected_mode:

mov eax,cr0
or eax,1
mov cr0,eax

jmp 0x08:protected_mode


BITS 32

protected_mode:

mov ax,0x10
mov ds,ax
mov es,ax
mov ss,ax

call setup_page_tables
call enter_long_mode


pm_hang:
jmp pm_hang


align 8

gdt_start:

dq 0x0000000000000000
dq 0x00209A0000000000
dq 0x0000920000000000

gdt_end:


gdt_descriptor:

dw gdt_end-gdt_start-1
dd gdt_start


align 4096

pml4_table:

times 512 dq 0

pdpt_table:

times 512 dq 0

pd_table:

times 512 dq 0


setup_page_tables:

mov eax,pdpt_table
or eax,3
mov [pml4_table],eax

mov eax,pd_table
or eax,3
mov [pdpt_table],eax

mov eax,0x83
mov [pd_table],eax

ret


enter_long_mode:

mov eax,cr4
or eax,1<<5
mov cr4,eax

mov eax,pml4_table
mov cr3,eax

mov ecx,0xC0000080
rdmsr
or eax,1<<8
wrmsr

mov eax,cr0
or eax,1<<31
mov cr0,eax

jmp 0x08:long_mode


BITS 64

long_mode:

mov ax,0x10
mov ds,ax
mov es,ax
mov ss,ax

mov rsp,stack_top

call kernel_main

halt:
cli
hlt
jmp halt


section .bss

align 16

stack:

resb 16384

stack_top: