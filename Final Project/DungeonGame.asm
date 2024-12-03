%include "/usr/local/share/csc314/asm_io.inc"

segment .data
	intro_msg 		db 	"You find yourself in an overgrown, dark and ominous room made of stone. The vines grow into the rocks, and you feel an urge to press onward.", 0
	health_msg 		db	"Current Health: ", 0
	choices_battle		db 	"1. Fight	  2. Run	 3. Taunt ", 0 
	choices_noncombat	db	"1. Take it       2. Destroy it	 3. Ignore it", 0
	choice_enter_msg 	db 	"Enter your choice: ", 0
	encounter_1_msg		db 	"As you far as you can tell, there are only two ways forward: Left or Right. Choose a path.", 0
	encounter_2_msg		db	"", 0
	encounter_3_msg 	db 	"A shadowy figure offers you guidance. Choose wisely.", 0
	encounter_4_msg		db	"", 0
	encounter_5_msg		db	"", 0
	encounter_6_msg		db	"", 0
	encounter_7_msg		db 	"You come across another adventurer who has been mortally wounded... They motion you to over to them in a very desparate fashion. ", 0
    	encounter_7_msg_2	db	"'please, help me; I have a healing serum in my bag, if you can get it for me I might be able to survive.' ", 0
    	encounter_7_choices 	db	"1. Take the potion, leaving the adventurer for dead.   2. Retrieve the potion and give it to the dying adventurer.", 0
    	encounter_8_msg		db	"", 0
	encounter_9_msg		db	"", 0
	final_encounter_msg	db	"Upon entering the next room, everything fades to black and a feeling of finality comes over you...", 0
	final_encounter_msg_2	db	"You hear a familiar voice, it fills the space around you and becomes all you can hear...", 0 
	final_encounter_msg_3	db	"' -- Y o u r  s o u l  i s  b e i n g  w e i g h e d . . . ' ", 0
	good_ending_msg		db	"", 0
	bad_ending_msg		db	"", 0
	neutral_ending_msg	db	"", 0
    	battle_lose_msg 	db 	"You lost the encounter and took damage.", 0
    	battle_stalemate_msg 	db 	"The encounter was a stalemate. You move on.", 0
    	battle_flawless_msg 	db 	"You flawlessly won the encounter!", 0
    	death_msg 		db 	"You have no health left. Everything fades and you wake up in a familiar overgrown dark room..", 0

segment .bss
   	health 			resb 1          ; Player health
    	hubris 			resb 1          ; Player hubris (0 = Neutral, 1 = Good, 2 = Bad)
    	encounter_number 	resb 1 ; Current encounter number
    	choice 			resb 1          ; Buffer for player input

segment .text
	global asm_main

asm_main:
    	push    ebp
   	mov    	ebp, esp

    	; ********** CODE STARTS HERE **********

   	; Initialize game state
    	mov 	byte [health], 3          ; Starting health
    	mov 	byte [hubris], 0          ; Neutral hubris
    	mov 	byte [encounter_number], 1 ; Start at first encounter

    	; Display intro
    	mov 	eax, intro_msg
    	call 	print_string

game_loop:
    	; Check if health <= 0
    	cmp 	byte [health], 0
   	jle 	death

    	; Check if all encounters are completed
    	cmp 	byte [encounter_number], 11
    	jge 	determine_ending

    	; Process encounters
   	cmp 	byte [encounter_number], 1
    	je 	encounter_1
    	cmp 	byte [encounter_number], 2
    	je 	encounter_2
    	cmp 	byte [encounter_number], 7
    	je 	health_up_encounter

    ; Default to random encounter
    	call random_encounter
    	inc	byte [encounter_number]
    	jmp 	game_loop

encounter_1:
    	mov 	eax, encounter_1_msg
    	call 	print_string
    	call 	get_choice
    

encounter_2:
    	mov 	eax, encounter_2_msg
    	call 	print_string
    	call 	get_choice
    	

health_up_encounter:
    	mov 	eax, health_up_msg
    	call 	print_string
    	mov 	eax, health_up_choice_msg
    	call 	print_string
   	call 	get_choice
    	cmp 	byte [choice], '1'
    	je 	gain_health
    	cmp 	byte [choice], '2'
    	je 	save_bystander
    	jmp 	game_loop

gain_health:
    	inc 	byte [health]
    	mov 	byte [hubris], 2          ; Hubris = BAD
    	inc 	byte [encounter_number]
    	jmp 	game_loop

save_bystander:
    	mov 	byte [hubris], 1          ; Hubris = GOOD
    	inc 	byte [encounter_number]
    	jmp 	game_loop

battle:
    	mov 	eax, choice_attack
    	call 	print_string
    	call 	roll_d6

    ; Process D6 roll outcomes
    	cmp 	eax, 2
    	jbe 	battle_lose
    	cmp 	eax, 4
    	jbe 	battle_stalemate
    	cmp 	eax, 6
    	je 	battle_flawless_win

battle_lose:
    	mov 	eax, lose_msg
    	call 	print_string
    	dec 	byte [health]
    	ret

battle_stalemate:
    	mov 	eax, stalemate_msg
    	call	print_string
    	ret

battle_flawless_win:
    	mov 	eax, flawless_msg
    	call	print_string
    	ret

determine_hubris:
   	cmp 	byte [hubris], 1
    	je	good_ending
    	cmp	byte [hubris], 2
    	je	bad_ending
    	jmp	neutral_ending

good_ending:
    	mov	eax, good_ending_msg
    	call	print_string
    	jmp 	end_game

neutral_ending:
    	mov 	eax, neutral_ending_msg
    	call 	print_string
    	jmp 	end_game

bad_ending:
    	mov	 eax, bad_ending_msg
    	call	 print_string
    	jmp	 end_game

death:
    	mov 	eax, death_msg
    	call 	print_string
	jmp 	end_game

end_game:
    ; *********** CODE ENDS HERE ***********
    mov     eax, 0
    mov     esp, ebp
    pop     ebp
    ret

;subprograms

get_choice:
    call read_int
    mov [choice], 
    ret

roll_d6:
   
flip_coin:

decrement_health:
