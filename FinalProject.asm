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
    encounter_1_msg         db  "As far as you can tell, there are only two ways forward: Left or Right. Choose a path.", 0
    encounter_2L_msg        db  "You wander down the left path and cross paths with a small creature.", 0
    encounter_2R_msg        db  "You wander down the right path and find yourself in a room just like the one you left. You look behind you and the path has vanished.", 0
    encounter_3_msg         db  "A cloaked figure appears before you, their identity shrouded in darkness, but somehow familiar.. Choose wisely.", 0
    encounter_3_msg_2       db  "'A choice must be made...' the figure utters as it extends both arms towards you. As its fingers unfurl you see two small objects in each hand", 0
    encounter_3_msg_3       db  "In the left hand there is a multifaceted gem, glowing blue; in the right hand, a small smooth and ordinary stone.", 0
    encounter_4_msg         db  "You hear strange whispers as you approach a glowing door. Do you enter?", 0
    encounter_5_msg         db  "A vast pit opens in front of you. You must find a way to cross.", 0
    encounter_6_msg         db  "You encounter a monstrous beast blocking your path. Prepare to fight!", 0
    encounter_7_msg         db  "You come across another adventurer who has been mortally wounded... They motion you over to them in a desperate fashion.", 0
    encounter_7_msg_2       db  "'Please, help me; I have a healing serum in my bag. If you can get it for me, I might be able to survive.'", 0
    encounter_7_choices     db  "1. Take the potion, leaving the adventurer for dead.   2. Retrieve the potion and give it to the dying adventurer.", 0
	encounter_7_result_1	db  "You take the potion and leave the adventurer to die. As you walk away, the adventurer utters '...why...'... A sense of guilt comes over you..", 0
	encounter_7_result_2	db  "You retrieve the potion and give it to the adventurer. They drink it and their wounds begin to heal. They thank you and you go on your way.", 0
    encounter_8_msg         db  "You find a riddle carved into the wall. Solve it to proceed.", 0
    encounter_9_msg         db  "A giant statue stands before you. It looks like it could come alive at any moment.", 0
    final_encounter_msg     db  "Upon entering the next room, everything fades to black and a feeling of finality comes over you...", 0
    final_encounter_msg_2   db  "You hear a familiar voice, it fills the space around you and becomes all you can hear...", 0 
    final_encounter_msg_3   db  "' -- Y o u r  s o u l  i s  b e i n g  w e i g h e d . . . ' ", 0
    good_ending_msg         db  "In an instant the darkness blinks to a bright, boundless room, full of color. The cloaked figure from before", 0
    bad_ending_msg          db  "The darkness closes in. You feel the weight of failure dragging you down.", 0
    neutral_ending_msg      db  "You find yourself back in the starting room. Perhaps the labyrinth has no end...", 0
    hidden_room_msg         db  "You find a hidden room with five items. Choose wisely:", 0
    item_choice_msg         db  "1. Ring    2. Wand    3. Staff    4. Sword    5. Map", 0
    incorrect_item_msg      db  "Nothing happens. Choose again.", 0
    correct_item_msg        db  "The staff glows brightly! A secret door opens, revealing unimaginable treasures and knowledge.", 0
    hidden_good_ending      db  "You step into a room filled with gold, artifacts, and ancient texts of immense knowledge. You have achieved ultimate power!", 0
    failed_item_msg         db  "You have chosen poorly. The dungeon curses you to wander endlessly, starting again in the first room...", 0
    thank_you_msg           db  "Thank you for playing!", 0
    death_msg               db  "You have no health left. Everything fades, and you wake up in a familiar dark room.", 0
	battle_taunt_msg        db  "Your taunts enrage the beast, but you avoid combat.", 0
    battle_fight_msg        db  "You fight bravely and defeat the beast!", 0
    battle_run_msg          db  "You manage to escape, but the beast is still out there.", 0
	invalidchoice_msg	    db  "Invalid choice, please try again.", 0
	error_msg				db	"Error with Branch Counter, Back to the drawing board", 0
	hubris_good_msg         db  "Your hubris is GOOD.", 0
	hubris_neutral_msg      db  "Your hubris is NEUTRAL.", 0
	hubris_bad_msg          db  "Your hubris is BAD.", 0
	hubris_tracker_msg      db  "Current Hubris: ", 0
	health_tracker_msg      db  "Current Health: ", 0
	health_loss_msg         db  "You lost health.", 0
	health_gain_msg         db  "You gained health.", 0

segment .bss
    health                  resb 1          ; Player health
    hubris                  resb 1          ; Player hubris (0 = Bad, 1 = Neutral, 2 = Good)
    encounter_number        resb 1          ; Current encounter number
    choice                  resb 1          ; Buffer for player input
    right_choice_count      resb 1          ; Count of consecutive right choices
    item_choice             resb 1          ; Stores player's choice for the hidden room item
	branch_tracker          resb 1          ; 0 = Not set, 1 = Left path, 2 = Right path
	attempts                resb 1          ; Tracks number of attempts in the hidden room


segment .text
    global asm_main

asm_main:
    push ebp
    mov ebp, esp

    ; Initialize game state
    mov byte [health], 3                  ; Starting health
    mov byte [hubris], 1                  ; Neutral hubris
    mov byte [encounter_number], 1        ; Start at first encounter
    mov byte [right_choice_count], 0      ; Initialize right path counter
	mov byte [branch_tracker], 0       ; Ensure branch_tracker starts at 0

    ; Display title and intro
    mov eax, title_msg
    call print_string
    call print_nl
    mov eax, intro_msg
    call print_string
    call print_nl

game_loop:
    ; Check if health <= 0
    cmp byte [health], 0
    jle death

    ; Display health
    mov eax, health_msg
    call print_string
    mov eax, [health]
    call print_int
    call print_nl

    ; Display border
    mov eax, border_msg_5
    call print_string
    call print_nl

    ; Determine ending if all 10 encounters have been completed
    cmp byte [encounter_number], 11
    jge determine_ending

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

; Encounters Logic

encounter_1:
    mov eax, encounter_1_msg  ; Load the encounter message
    call print_string         ; Print the encounter message
    call get_choice           ; Get the player's choice

    cmp byte [choice], 1      ; Check if the choice is '1' (Left)
    je set_left_branch
    cmp byte [choice], 2      ; Check if the choice is '2' (Right)
    je set_right_branch

    ; Invalid choice handling
    mov eax, invalidchoice_msg
    call print_string
    jmp encounter_1           ; Retry the encounter

set_left_branch:
    mov byte [branch_tracker], 1      ; Set Left branch
    inc byte [encounter_number]       ; Progress to Encounter 2
    jmp game_loop

set_right_branch:
    mov byte [branch_tracker], 2      ; Set Right branch
    inc byte [right_choice_count]     ; Increment Right choice count
    cmp byte [right_choice_count], 5
    je hidden_room                    ; Trigger hidden room if 5 Right choices
    inc byte [encounter_number]       ; Progress to Encounter 2
    jmp game_loop

encounter_2:
    ; Display content based on branch_tracker
    cmp byte [branch_tracker], 1
    je encounter_2L_logic
    cmp byte [branch_tracker], 2
    je encounter_2R_logic

    ; Fallback for unexpected errors
    mov eax, error_msg
    call print_string
    call print_nl
    jmp game_loop

encounter_2L_logic:
    mov eax, encounter_2L_msg
    call print_string
    call print_nl

    ; Progress to next encounter
    inc byte [encounter_number]
    jmp game_loop

encounter_2R_logic:
    mov eax, encounter_2R_msg
    call print_string
    call print_nl

    ; Increment right choice count for Easter Egg
    inc byte [right_choice_count]
    cmp byte [right_choice_count], 5
    je hidden_room                  ; Trigger secret room if count reaches 5

    ; Progress to next encounter
    inc byte [encounter_number]
    jmp game_loop


encounter_3:
    mov eax, encounter_3_msg
    call print_string
    call print_nl
    mov eax, encounter_3_msg_2
    call print_string
    call print_nl
    mov eax, encounter_3_msg_3
    call print_string
    call print_nl
    call get_choice
    inc byte [encounter_number]
    jmp game_loop

encounter_4:
    mov eax, encounter_4_msg
    call print_string
    call print_nl
    inc byte [encounter_number]
    jmp game_loop

encounter_5:
    mov eax, encounter_5_msg
    call print_string
    call print_nl
    inc byte [encounter_number]
    jmp game_loop

encounter_6:
    mov eax, encounter_6_msg
    call print_string
    call print_nl
    call battle
    inc byte [encounter_number]
    jmp game_loop

encounter_7:
    mov eax, encounter_7_msg
    call print_string
	call print_nl
    mov eax, encounter_7_msg_2
    call print_string
	call print_nl
    mov  eax, encounter_7_choices
    call print_string
	call print_nl
    call get_choice
    cmp byte [choice], '1'
    je doom_adventurer
    cmp byte [choice], '2'
    je  save_adventurer
    jmp game_loop

doom_adventurer:
    inc byte [health]
    mov byte [hubris], 2          ; Hubris = BAD
    inc byte [encounter_number]
    jmp game_loop

save_adventurer:
    mov byte [hubris], 1          ; Hubris = GOOD
    inc byte [encounter_number]
    jmp game_loop


encounter_8:
    mov eax, encounter_8_msg
    call print_string
    call print_nl
    inc byte [encounter_number]
    jmp game_loop

encounter_9:
    mov eax, encounter_9_msg
    call print_string
    call print_nl
    inc byte [encounter_number]
    jmp game_loop

final_encounter:
    mov eax, final_encounter_msg
    call print_string
    call print_nl
    mov eax, final_encounter_msg_2
    call print_string
    call print_nl
    mov eax, final_encounter_msg_3
    call print_string
    call print_nl
    jmp determine_ending

hidden_room:
    ; Display hidden room entry message
    mov eax, hidden_room_msg          ; Message for entering the hidden room
    call print_string
    call print_nl

    ; Reset right_choice_count
    mov byte [right_choice_count], 0

    ; Display item selection prompt
    mov eax, item_choice_msg          ; Message listing items to choose
    call print_string
    call print_nl

    mov byte [attempts], 3            ; Allow up to 3 attempts

hidden_room_loop:
    call get_choice                   ; Get player's choice

    ; Check the player's choice
    cmp byte [choice], 3              ; Correct item is the staff (option 3)
    je correct_item

    ; Decrement attempts and check for failure
    dec byte [attempts]
    cmp byte [attempts], 0
    je failed_attempts

    ; Display incorrect choice message
    mov eax, incorrect_item_msg       ; Message for incorrect item
    call print_string
    call print_nl
    jmp hidden_room_loop

correct_item:
    mov eax, correct_item_msg         ; Message for correct item selection
    call print_string
    call print_nl
    jmp good_ending                   ; Proceed to good ending

failed_attempts:
    mov eax, failed_item_msg          ; Message for failing all attempts
    call print_string
    call print_nl
    mov byte [encounter_number], 1    ; Send player back to starting room
    jmp game_loop


determine_ending:
    cmp byte [hubris], 2
    je good_ending
    cmp byte [hubris], 1
    je neutral_ending
    jmp bad_ending

good_ending:
    mov eax, good_ending_msg
    call print_string
    call print_nl
    call end_game

neutral_ending:
    mov eax, neutral_ending_msg
    call print_string
    call print_nl
    call end_game

bad_ending:
    mov eax, bad_ending_msg
    call print_string
    call print_nl
    call end_game

death:
    mov eax, death_msg
    call print_string
    call print_nl
    jmp game_loop

end_game:
    mov eax, thank_you_msg
    call print_string
    call print_nl
    mov eax, 0
    ret

get_choice:
    call read_int            ; Read input from user
    cmp eax, 1               ; Check if input is 1
    je valid_choice
    cmp eax, 2               ; Check if input is 2
    je valid_choice
    ; Invalid input handling
    mov eax, invalidchoice_msg
    call print_string
    call print_nl
    jmp get_choice           ; Retry input

valid_choice:
    mov [choice], eax        ; Store valid input
    ret


get_item_choice:
    call read_int
    mov [item_choice], al
    ret

update_health:
    mov eax, health_tracker_msg
    call print_string
    mov al, [health]
    call print_int
    call print_nl
    ret

; Subprogram: Update and Display Hubris
update_hubris:
    mov eax, hubris_tracker_msg
    call print_string

    ; Determine and Display Hubris Level
    cmp byte [hubris], 0
    je hubris_bad
    cmp byte [hubris], 1
    je hubris_neutral
    cmp byte [hubris], 2
    je hubris_good
    ret

hubris_good:
    mov eax, hubris_good_msg
    call print_string
    call print_nl
    ret

hubris_neutral:
    mov eax, hubris_neutral_msg
    call print_string
    call print_nl
    ret

hubris_bad:
    mov eax, hubris_bad_msg
    call print_string
    call print_nl
    ret

; Subprogram: Decrement Health
decrement_health:
    dec byte [health]
    mov eax, health_loss_msg
    call print_string
    call print_nl
    cmp byte [health], 0
    jle death
    ret

; Subprogram: Increment Health
increment_health:
    inc byte [health]
    mov eax, health_gain_msg
    call print_string
    call print_nl
    ret

determine_ending:
    call update_health          ; Display final health
    call update_hubris          ; Display final hubris

    cmp byte [hubris], 2
    je good_ending
    cmp byte [hubris], 1
    je neutral_ending
    jmp bad_ending

roll_d6:
    ; Generate a random number between 1 and 6
    call random
    mov ecx, 6               ; Range of 1–6
    xor edx, edx             ; Clear edx
    div ecx                  ; eax = random number % 6
    inc eax                  ; Convert 0–5 to 1–6
    ret

battle:
    mov eax, choices_battle
    call print_string
    call print_nl
    call get_choice

    cmp byte [choice], '1'       ; Fight
    je battle_fight
    cmp byte [choice], '2'       ; Run
    je battle_run
    cmp byte [choice], '3'       ; Taunt
    je battle_taunt

    ; Invalid choice handling
    mov eax, invalidchoice_msg
    call print_string
    jmp battle

battle_fight:
    call roll_d6                 ; Roll the dice
    cmp eax, 3                   ; Success if roll >= 3
    jl battle_fail               ; Jump if roll < 3
    mov eax, battle_fight_msg    ; Success message
    call print_string
    call print_nl
    ret                          ; Progress to next stage

battle_fail:
    call decrement_health        ; Take 1 damage
    mov eax, battle_loss_msg     ; Failure message
    call print_string
    call print_nl
    ret                          ; Retry or move to another decision

battle_run:
    mov eax, battle_run_msg      ; Message for running away
    call print_string
    call print_nl
    jmp encounter_1              ; Loop back to dungeon navigation

battle_taunt:
    mov eax, "You attempt to taunt the enemy..."
    call print_string
    call print_nl

    call roll_d6              ; Roll the dice
    cmp eax, 3                ; Check if roll >= 3
    jl taunt_fail             ; Jump to fail logic if roll < 3

    ; Success: Perform a counter-attack
    mov eax, "Your taunt works! You counter-attack and defeat the enemy!"
    call print_string
    call print_nl
    ret                       ; Move to the next step

taunt_fail:
    ; Fail: Enemy retaliates and deals damage
    mov eax, "Your taunt fails. The enemy attacks you!"
    call print_string
    call print_nl
    call decrement_health     ; Lose 1 health
    ret                       ; Retry or move to another decision


mov eax, 0
mov esp, ebp
pop ebp
ret