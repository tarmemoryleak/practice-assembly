; GAME WARNING Please run on emulator or virtual machine it's still have stackoverflow issue 
GAME_TITLE  DB 'SPACE INVADER - 16-BIT ASSEMBLY', '$'

DRAW_PIXEL  MACRO   X, Y, C
    PUSH    AX
    PUSH    BX
    MOV     AX, Y
    MOV     BX, X
    MOV     AH, 13h       
    MOV     AL, C         
    INT     10h
    POP     BX
    POP     AX
ENDM


SEGMENT DATA
    ; Game Over ตู้มมม
    msg_game_over DB 'GAME OVER! $'
    sound_freq EQU 440
    sound_time EQU 500

SEGMENT STACK
    DW 1024 DUP(?)

SEGMENT CODE
START:
    MOV AX, 0003h       
    INT 10h
    MOV AX, 13h
    INT 10h
    
    MOV player_x, 160
    MOV player_y, 230
    
    ; stat ศัตรู
    MOV enemy_x, 160
    MOV enemy_y, 10
    
    MOV player_color, 10
    MOV enemy_color, 12
    
    ; GAME LOOP 
GAME_LOOP:
    CALL    HANDLE_INPUT
    
    CALL    UPDATE_GAME
    
    CALL    RENDER_FRAME
    
    PUSH    CX
    MOV     CX, 500
DELAY:
    PUSH    AX
    MOV     AX, 0
    MOV     BH, 0
    INT     1Ah       ; interrupt 
    POP     AX
    LOOP    DELAY
    POP     CX
    
    CMP     byte [player_alive], 1
    JNE     GAME_OVER ; ถ้าแพ้แล้ว gameover

    JMP GAME_LOOP     ; เริ่มใหม่

HANDLE_INPUT:
    PUSH    AX
    
    MOV     AH, 0Ch     
    INT     20h
    
    CMP     AL, 49      
    JNE     KEY_NOT_SPACE
    
    ; ยิงตู้มต้ามม
    MOV     bullet_active, 1
    MOV     bullet_x, player_x
    MOV     bullet_y, player_y
    
KEY_NOT_SPACE:
    POP     AX
    RET

UPDATE_GAME:
    CMP     enemy_x, 0
    JGE     ENEMY_MOVE_NORMAL
    MOV     enemy_x, 0
    
ENEMY_MOVE_NORMAL:
    CMP     enemy_x, 310
    JLE     ENEMY_MOVE_DONE
    MOV     enemy_x, 310
    
ENEMY_MOVE_DONE:
    MOV     AX, enemy_dir
    ADD     enemy_x, AX
    
    CMP     byte [bullet_active], 1
    JNE     CHECK_PLAYER_HIT ; ไม่มีกระสุน skip เลย
    
    MOV     AX, bullet_x
    MOV     DX, enemy_x
    CMP     AX, DX
    JNE     BULLET_MISS
    
    DRAW_PIXEL enemy_x, enemy_y, 0 
    MOV     byte [bullet_active], 0 
    MOV     score, 10         
    
BULLET_MISS:
    INC     bullet_y
    CMP     bullet_y, 240
    JNE     MOVE_DONE
    MOV     byte [bullet_active], 0
    
MOVE_DONE:
    RET

CHECK_PLAYER_HIT:
    PUSH    AX
    MOV     AX, enemy_y
    ADD     AX, 20         
    CMP     AX, player_y
    POP     AX
    JE      PLAYER_DIE
    
    JMP     MOVE_DONE

PLAYER_DIE:
    MOV     byte [player_alive], 0
    RET

RENDER_FRAME:
    PUSH    AX
    MOV     AX, player_color
    CALL    CLEAR_POS
    POP     AX
    
    DRAW_PIXEL player_x, player_y, player_color
    
    DRAW_PIXEL enemy_x, enemy_y, enemy_color
    
    CMP     byte [bullet_active], 1
    JNE     DONE_DRAW
    DRAW_PIXEL bullet_x, bullet_y, 14 

DONE_DRAW:
    RET

CLEAR_POS:
    MOV     AX, 0           
    DRAW_PIXEL [SP], [BP], 0
    DRAW_PIXEL [SP], [BP], 0
    MOV     AX, 0
    RET

GAME_OVER:
    MOV     AH, 01h
    MOV     CX, 07h         
    INT     10h
    
    ; Print Game Over Text
    MOV     AH, 13h         
    MOV     AL, 10          
    MOV     AH, 10          
    INT     10h
    
    MOV     AH, 09h         
    LEA     DX, msg_game_over
    INT     10h
    CALL    PLAY_SOUND
    
    ; Finish Game
    MOV     AX, 4803h       
    INT     10h
    MOV     AH, 4Ch         ; Terminate ออก
    INT     21h

SEGMENT DATA
    player_x    DW 160
    player_y    DW 230
    player_color DW 10      
    enemy_x     DW 160
    enemy_y     DW 10
    enemy_color DW 12       
    enemy_dir   DW -1       
    bullet_x    DW 0
    bullet_y    DW 0
    bullet_active DB 0
    player_alive DB 1       
    score       DB 0

SEGMENT CODE
PLAY_SOUND:
    PUSH    AX
    PUSH    CX
    MOV     DX, 330H        
    MOV     AX, sound_freq
    OUT     DX, AL          
    MOV     AX, sound_freq
    OUT     DX, AL          
    
    MOV     CX, sound_time
WAIT_LOOP:
    NOP
    LOOP    WAIT_LOOP
    
    MOV     AL, 0
    OUT     DX, AL          ; Stop sound
    POP     CX
    POP     AX
    RET
