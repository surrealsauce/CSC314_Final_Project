%include "/usr/local/share/csc314/asm_io.inc"

segment .data
    border_msg              db  "----------------------------------------", 0
    border_msg_2            db  "========================================", 0
    border_msg_3            db  "////////////////////\\\\\\\\\\\\\\\\\\\\", 0
    border_msg_4            db  "\\\\\\\\\\\\\\\\\\\\////////////////////", 0
    border_msg_5            db  "........................................", 0
    title_msg               db  "The Labyrinth. Game by Jacob Miller, Zachary Pickard and Owen Mechling", 0
    intro_msg               db  "You find yourself in an overgrown, dark and ominous room made of stone. The vines grow into the rocks, and you feel an urge to press onward.", 0
    health_msg              db  "Current Health: ", 0
    choices_battle          db  "1. Fight      2. Run     3. Taunt ", 0 
    choices_noncombat       db  "1. Take it       2. Destroy it      3. Ignore it", 0
    choices_LR              db  "1. Left     2. Right", 0
    choice_enter_msg        db  "Enter your choice: ", 0
    encounter_1_msg         db  "As you far as you can tell, there are only two ways forward: Left or Right. Choose a path.", 0
    encounter_2L_msg        db  "You wander down the left path and cross paths with a small  ", 0
    encounter_2R_msg        db  "You wander down the right path and find yourself in a room just like the one you left. You look behind you and the path has vanished.", 0
    encounter_3_msg         db  "A cloaked figure appears before you, their identity shrouded in darkness, but somehow familiar.. Choose wisely.", 0
    encounter_3_msg_2       db  "'A choice must be made...' the figure utters as it extends both arms towards you. As it's fingers unfurl you see two small objects in each hand", 0
    encounter_3_msg_3       db  "In the left hand there is a multifaceted gem, glowing blue; in the right hand, a small smooth and ordinary stone.", 0
    encounter_4_msg         db  "", 0
    encounter_5_msg         db  "", 0
    encounter_6_msg         db  "", 0
    encounter_7_msg         db  "You come across another adventurer who has been mortally wounded... They motion you to over to them in a very desparate fashion. ", 0
    encounter_7_msg_2       db  "'please, help me; I have a healing serum in my bag, if you can get it for me I might be able to survive.' ", 0
    encounter_7_choices     db  "1. Take the potion, leaving the adventurer for dead.   2. Retrieve the potion and give it to the dying adventurer.", 0
	encounter_7_result_1	db  "You take the potion and leave the adventurer to die. As you walk away, the adventure utters '...why...'... A sense of guilt comes over you..", 0
	encounter_7_result_2	db  "You retrieve the potion and give it to the adventurer. They drink it and their wounds begin to heal. They thank you and you go on your way.", 0
    encounter_8_msg         db  "", 0
    encounter_9_msg         db  "", 0
    final_encounter_msg     db  "Upon entering the next room, everything fades to black and a feeling of finality comes over you...", 0
    final_encounter_msg_2   db  "You hear a familiar voice, it fills the space around you and becomes all you can hear...", 0 
    final_encounter_msg_3   db  "' -- Y o u r  s o u l  i s  b e i n g  w e i g h e d . . . ' ", 0
    good_ending_msg         db  "In an instant the darkness blinks to a bright, boundless room, full of color. The cloaked figure from before", 0
    bad_ending_msg          db  "", 0
    neutral_ending_msg      db  "", 0
    battle_lose_msg         db  "You lost the fight and took damage, but managed to get away.", 0
    battle_stalemate_msg    db  "Your attack misses. What do you choose to do?", 0
    battle_flawless_msg     db  "You flawlessly cut down your opponent, and move on down the path.", 0
    death_msg               db  "You have no health left. Everything fades and you wake up in a familiar overgrown dark room..", 0
    thank_you_msg           db  "Thank you for playing!", 0    

segment .bss
    health                  resb 1          ; Player health
    hubris                  resb 1          ; Player hubris (0 = Bad, 1 = Neutral, 2 = Good)
    encounter_number        resb 1          ; Current encounter number
    choice                  resb 1          ; Buffer for player input

segment .text
    global asm_main

asm_main:
    push    ebp
    mov     ebp, esp

    ; ********** CODE STARTS HERE **********

    ; Initialize game state
    mov     byte [health], 3          ; Starting health
    mov     byte [hubris], 1          ; Neutral hubris
    mov     byte [encounter_number], 1 ; Start at first encounter

    ; Display intro
    mov     eax, intro_msg
    call    print_string

game_loop:
    ; Check if health <= 0
    cmp     byte [health], 0
    jle     death

	; Display health
	mov     eax, health_msg
	call    print_string
	mov     eax, [health]
	call    print_int
	call    print_nl

	; Display border
	mov     eax, border_msg_5
	call    print_string
	call    print_nl

	; Determine ending if all 10 encounters have been completed
    cmp     byte [encounter_number], 11
    jge     determine_ending

    ; Process encounters
    cmp     byte [encounter_number], 1
    je      encounter_1
    cmp     byte [encounter_number], 2
    je      encounter_2
    cmp     byte [encounter_number], 3
    je      encounter_3
    cmp     byte [encounter_number], 4
    je      encounter_4
    cmp     byte [encounter_number], 5
    je      encounter_5
    cmp     byte [encounter_number], 6
    je      encounter_6
    cmp     byte [encounter_number], 7
    je      encounter_7
    cmp     byte [encounter_number], 8
    je      encounter_8
    cmp     byte [encounter_number], 9
    je      encounter_9
    cmp     byte [encounter_number], 10
    je      final_encounter

    jmp     game_loop

encounter_1:
    mov     eax, encounter_1_msg
    call    print_string
    call    get_choice
    ; Process choice
    cmp     byte [choice], '1'
    je      encounter_2L
    cmp     byte [choice], '2'
    je      encounter_2R
    jmp     game_loop

encounter_2L:
    mov     eax, encounter_2L_msg
    call    print_string
	call    print_nl
    inc     byte [encounter_number]
    jmp     game_loop

encounter_2R:
    mov     eax, encounter_2R_msg
    call    print_string
	call    print_nl
    mov     byte [encounter_number], 1
    jmp     game_loop

encounter_3:
    mov     eax, encounter_3_msg
    call    print_string
	call    print_nl
    mov     eax, encounter_3_msg_2
    call    print_string
	call    print_nl
    mov     eax, encounter_3_msg_3
    call    print_string
	call    print_nl
    call    get_choice
    ; Process choice
    inc     byte [encounter_number]
    jmp     game_loop

encounter_4:
    mov     eax, encounter_4_msg
    call    print_string
	call    print_nl
    inc     byte [encounter_number]
    jmp     game_loop

encounter_5:
    mov     eax, encounter_5_msg
    call    print_string
	call    print_nl
    inc     byte [encounter_number]
    jmp     game_loop

encounter_6:
    mov     eax, encounter_6_msg
    call    print_string
	call    print_nl
    inc     byte [encounter_number]
    jmp     game_loop

encounter_7:
    mov     eax, encounter_7_msg
    call    print_string
	call    print_nl
    mov     eax, encounter_7_msg_2
    call    print_string
	call    print_nl
    mov     eax, encounter_7_choices
    call    print_string
	call    print_nl
    call    get_choice
    cmp     byte [choice], '1'
    je      doom_adventurer
    cmp     byte [choice], '2'
    je      save_adventurer
    jmp     game_loop

doom_adventurer:
    inc     byte [health]
    mov     byte [hubris], 2          ; Hubris = BAD
    inc     byte [encounter_number]
    jmp     game_loop

save_adventurer:
    mov     byte [hubris], 1          ; Hubris = GOOD
    inc     byte [encounter_number]
    jmp     game_loop

encounter_8:
    mov     eax, encounter_8_msg
    call    print_string
	call    print_nl
    inc     byte [encounter_number]
    jmp     game_loop

encounter_9:
    mov     eax, encounter_9_msg
    call    print_string
	call    print_nl
    inc     byte [encounter_number]
    jmp     game_loop

final_encounter:
    mov     eax, final_encounter_msg
    call    print_string
	call    print_nl
    mov     eax, final_encounter_msg_2
    call    print_string
	call    print_nl
    mov     eax, final_encounter_msg_3
    call    print_string
	call    print_nl
    inc     byte [encounter_number]
    jmp     game_loop

determine_ending:
    cmp     byte [hubris], 2
    je      check_good_ending
    cmp     byte [hubris], 1
    je      neutral_ending
    jmp     bad_ending

check_good_ending:
    cmp     byte [health], 0
    jle     bad_ending
    jmp     good_ending

good_ending:
    mov     eax, good_ending_msg
    call    print_string
	call    print_nl
    jmp     end_game

neutral_ending:
    mov     eax, neutral_ending_msg
    call    print_string
	call    print_nl
    jmp     end_game

bad_ending:
    mov     eax, bad_ending_msg
    call    print_string
	call    print_nl
    jmp     end_game

death:
    mov     eax, death_msg
	call    print_nl
    call    print_string
	call    print_nl
    jmp     end_game

end_game:
    ; *********** CODE ENDS HERE ***********
    mov     eax, 0
    mov     esp, ebp
    pop     ebp
    ret

; Subprograms

get_choice:
    call    read_int
    mov     [choice], eax
    ret

roll_d6:
    ; Generate a random number between 1 and 6
   
flip_coin: 
	; 1 = heads, 2 = tails

battle:
    call    roll_d6
    cmp     eax, 2
    jle     battle_lose
    cmp     eax, 4
    jle     battle_stalemate
    cmp     eax, 6
    je      battle_flawless

battle_lose:
    mov     eax, battle_lose_msg
    call    print_string
    dec     byte [health]
    jmp     game_loop

battle_stalemate:
    mov     eax, battle_stalemate_msg
    call    print_string
    call    get_choice
    ; Process choice
    jmp     battle

battle_flawless:
    mov     eax, battle_flawless_msg
    call    print_string
    jmp     game_loop