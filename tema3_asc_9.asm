bits 32               ; assembling for the 32-bit architecture
global start          ; define the entry point

extern exit           ; declare external exit function
import exit msvcrt.dll

segment data use32 class=data
    a dw 0001001000110100b       ; declare `a` as a word (16-bit)
    b db 10101011b           ; declare `b` as a byte (8-bit)
    c dd 0            ; declare `c` as a doubleword (32-bit)

segment code use32 class=code
    start:
        mov eax, 0            ; Clear eax for calculations
        mov ebx, 0            ; Clear ebx for calculations

        ; Step 1: Extract bits 6-9 from `A` and move them to bits 0-3 of `C`
        mov ax, [a]           ; Load `a` into ax
        and ax, 0x03C0        ; Mask to keep only bits 6-9
        shr ax, 6             ; Shift right to position at bits 0-3
        mov ebx, eax          ; Move result to ebx (start forming `C`)

        ; Step 2: Set bits 4-5 of `C` to 1
        or ebx, 0x30          ; Set bits 4 and 5 of `ebx` to 1 (0b00110000)

        ; Step 3: Extract bits 1-2 from `B` and move them to bits 6-7 of `C`
        mov al, [b]           ; Load `b` into al
        and al, 0x06          ; Mask to keep only bits 1-2
        shl al, 5             ; Shift left to align with bits 6-7
        or bl, al             ; Combine with `ebx`

        ; Step 4: Copy all bits of `A` to bits 8-23 of `C`
        mov eax, [a]          ; Load `a` into eax
        shl eax, 8            ; Shift left to align with bits 8-23
        or ebx, eax           ; Combine with `ebx`

        ; Step 5: Copy all bits of `B` to bits 24-31 of `C`
        mov eax, [b]          ; Load `b` into eax
        shl eax, 24           ; Shift left to align with bits 24-31
        or ebx, eax           ; Combine with `ebx`

        ; Store the result in `c`
        ;mov [c], ebx          ; Move final result to `c`

        ; Exit program with code 0
        push dword 0          ; Push 0 as the exit code
        call [exit]           ; Call exit to terminate the program
