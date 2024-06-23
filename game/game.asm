    [bits 16]
    [org 0x3EE4]
    jmp start

    ;data which will remain constant

    ;measures of the screen in pixels
    screenWidth equ 320 
    screenHeight equ 200

    ;measures of the bird in pixels
    birdWidth equ 30
    birdHeight equ 20
    birdWingWidth equ 10
    birdWingHeight equ 7
    birdEyeSocketWidth equ 5
    birdEyeSocketHeight equ 5
    birdEyeWidth equ 2
    birdEyeHeight equ 2
    birdHeightPosition dw 45; we dont set the x coordinate cause bird is movin ongly pu and down

    ;pipe measures there will be 3 pipes in the game
    pipeWidth equ 40

    ;pipe one 
    ;--------------------------
    topPipeOneHeight equ 70
    topPipeOnePositionX dw 90
    topPipeOnePositionY dw 0
    bottomPipeOneHeight equ 30
    bottomPipeOnePositionX dw 90
    bottomPipeOnePositionY dw 124
    ;--------------------------


    ;pipe two
    ;--------------------------
    topPipeTwoHeight equ 30
    topPipeTwoPositionX dw 180
    topPipeTwoPositionY dw 0
    bottomPipeTwoHeight equ 70
    bottomPipeTwoPositionX dw 180
    bottomPipeTwoPositionY dw 84
    ;--------------------------

    ;pipe three
    ;--------------------------
    topPipeThreeHeight equ 40
    topPipeThreePositionX dw 270
    topPipeThreePositionY dw 0
    bottomPipeThreeHeight equ 40
    bottomPipeThreePositionX dw 270
    bottomPipeThreePositionY dw 114
    ;--------------------------  


    ;time variables
    time_aux db 0 ; check for change in time

    sleep: 
        push cx
        mov cx, 0xffff
            delay:
                loop delay
        pop cx
        ret

    drawBackgroundWorld:
        push bp 
        mov bp, sp  
        push ax
        push bx
        push cx
        push dx
        push si
        push di

        mov cx, 0; initializing the x coordinate ie. the column
        mov dx, 0; initializing the y coordinate ie. the row
        beginDrawingSky:
            mov ah, 0ch; set configuration for the pixel
            mov al, 0xb; light blue color
            mov bh, 0; page number
            int 10h; calling the interrupt to set the color
            inc cx; incrementing the x coordinate
            cmp cx, screenWidth; comparing the x coordinate with the width of the screen
            jne beginDrawingSky; 

        inc dx; incrementing the y coordinate
        mov cx, 0; 
        cmp dx, screenHeight - 45; doing this so that the bottom can become floor
        jne beginDrawingSky; if the y coordinate is not equal to the height of the screen then jump to beginDrawing


        beginDrawingFloor:
            mov ah, 0ch 
            mov al, 0x6 
            mov bh, 0
            int 10h
            inc cx
            cmp cx, screenWidth
            jne beginDrawingFloor;

        inc dx
        mov cx, 0
        cmp dx, screenHeight
        jne beginDrawingFloor

        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        pop bp

        ret

    birdy:
        push bp
        mov bp, sp
        push ax
        push bx
        push cx
        push dx
        push si
        push di


        mov cx, 0
        mov dx, [birdHeightPosition]


        beginDrawingBird:
            mov ah, 0ch
            mov al, 0xe
            mov bh, 0
            int 10h

            inc cx
            mov ax, cx
            sub ax, 0
            cmp ax, birdWidth
            jng beginDrawingBird

            mov cx, 0
            inc dx
            mov ax, dx
            sub ax, birdHeight
            cmp ax, [birdHeightPosition]
            jng beginDrawingBird


        mov cx, 0
        mov bx, [birdHeightPosition]
        add bx, 7
        mov dx, bx
            
        beginDrawingWing:
            mov ah, 0ch
            mov al, 0x7
            mov bh, 0
            int 10h

            inc cx
            mov ax, cx
            sub ax, 0
            cmp ax, birdWingWidth
            jng beginDrawingWing

            mov cx, 0
            inc dx
            mov ax, dx
            sub ax, birdWingHeight
            cmp ax, bx
            jng beginDrawingWing

        
        mov cx, birdWidth - birdEyeSocketWidth
        mov dx, [birdHeightPosition]

        beginDrawingEyeSocket:
            mov ah, 0ch
            mov al, 0xf
            mov bh, 0
            int 10h

            inc cx
            mov ax, cx
            sub ax, birdWidth - birdEyeSocketWidth
            cmp ax, birdEyeSocketWidth
            jng beginDrawingEyeSocket

            mov cx, birdWidth - birdEyeSocketWidth
            inc dx
            mov ax, dx
            sub ax, birdEyeSocketHeight
            cmp ax, [birdHeightPosition]
            jng beginDrawingEyeSocket


        mov cx, birdWidth - birdEyeWidth
        mov bx, [birdHeightPosition] 
        add bx, 2
        mov dx, bx

        beginDrawingEyeBall:

            mov ah, 0ch
            mov al, 0x0
            mov bh, 0
            int 10h

            inc cx
            mov ax, cx
            sub ax, birdWidth - birdEyeWidth
            cmp ax, birdEyeWidth
            jng beginDrawingEyeBall

            mov cx, birdWidth - birdEyeWidth
            inc dx
            mov ax, dx
            sub ax, birdEyeHeight
            cmp ax, bx
            jng beginDrawingEyeBall

        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        pop bp

        ret


    skyTopforBirdy:
        push bp
        mov bp, sp
        push ax
        push bx
        push cx
        push dx
        push si
        push di

        mov cx, birdWidth  ; x
        mov dx, [birdHeightPosition]; y
        
        LoopY:
            mov ah, 0ch
            mov al, 0xb
            mov bh, 0
            int 10h

            loop LoopY

            mov ah, 0ch
            mov al, 0xb
            mov bh, 0
            int 10h


        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        pop bp
        ret


    skyBottomforBirdy:

        push bp
        mov bp, sp
        push ax
        push bx
        push cx
        push dx
        push si
        push di

        mov cx, birdWidth ; x
        mov dx, [birdHeightPosition]; y
        add dx, birdHeight + 1

        loopYB:
            
            mov ah, 0ch
            mov al, 0xb
            mov bh, 0
            int 10h

            loop loopYB

            mov ah, 0ch
            mov al, 0xb
            mov bh, 0
            int 10h

        

        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        pop bp
        ret

        drawPipe:
        push bp
        mov bp, sp
        push ax
        push bx
        push cx
        push dx
        push si
        push di

        ;getting through the stack the values of the pipe

        ;bp, bp+2 -> return address, bp+4 = bottomh, bp+6 = by, bp+8 bx, bp+10 = toph, bp+12 = topy, bp+14 = topx


        mov cx, [bp+14]; x
        mov dx, [bp+12]; y

        beginTopPipe:
            mov ah, 0ch
            mov al, 0x2 ; green color
            mov bh, 0
            int 10h

            inc cx
            mov ax, cx
            sub ax, [bp+14]
            cmp ax, pipeWidth
            jng beginTopPipe

            mov cx, [bp+14]
            inc dx
            mov ax, dx
            sub ax, [bp+10]
            cmp ax, [bp+12]
            jng beginTopPipe


        mov cx, [bp+8]
        mov dx, [bp+6]

        beginbottomPipe:
            mov ah, 0ch
            mov al, 0x2
            mov bh, 0
            int 10h

            inc cx
            mov ax, cx
            sub ax, [bp+8]
            cmp ax, pipeWidth
            jng beginbottomPipe

            mov cx, [bp+8]
            inc dx
            mov ax, dx
            sub ax, [bp+4]
            cmp ax, [bp+6]
            jng beginbottomPipe


        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        pop bp
        ret 12

    cleanMovedPipe:

        push bp
        mov bp, sp
        push ax
        push bx
        push cx
        push dx
        push si
        push di

        ;we want to move any general pipe from left to right slowly by moving it and covering the previous are with the background color
        ;bp+4 = bottomh, bp+6 = by, bp+8 bx, bp+10 = toph, bp+12 = topy, bp+14 = topx

        mov cx, [bp+14]; x
        add cx, 40 ; x + width -> goes to last column
        mov dx, [bp+12]; y
        sub dx, 1
        mov ax, [bp+10]

        beginCleaningTopPipe:
            mov ah, 0ch
            mov al, 0xb
            mov bh, 0
            int 10h

            inc dx
            mov ax, dx
            cmp ax, [bp+10];
            jng beginCleaningTopPipe





        mov cx, [bp+8]; x
        add cx, 40
        mov dx, [bp+6]; y

        beginCleaningBottomPipe:
            mov ah, 0ch
            mov al, 0xb
            mov bh, 0
            int 10h

            inc dx
            mov ax, dx
            sub ax, [bp+6]
            cmp ax, [bp+4]
            jng beginCleaningBottomPipe

        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        pop bp
        ret 12


    pipeOne:

        push word [topPipeOnePositionX]
        push word [topPipeOnePositionY]
        push word topPipeOneHeight
        push word [bottomPipeOnePositionX]
        push word [bottomPipeOnePositionY]
        push word bottomPipeOneHeight
        call cleanMovedPipe

        
        sub word [topPipeOnePositionX], 1
        sub word [bottomPipeOnePositionX], 1

        push word [topPipeOnePositionX]
        push word [topPipeOnePositionY]
        push word topPipeOneHeight
        push word [bottomPipeOnePositionX]
        push word [bottomPipeOnePositionY]
        push word bottomPipeOneHeight
        call drawPipe


        ret

    pipeTwo:
        push word [topPipeThreePositionX]
        push word [topPipeThreePositionY]
        push word topPipeThreeHeight
        push word [bottomPipeThreePositionX]
        push word [bottomPipeThreePositionY]
        push word bottomPipeThreeHeight

        call cleanMovedPipe

        sub word [topPipeThreePositionX], 1
        sub word [bottomPipeThreePositionX], 1

        push word [topPipeThreePositionX]
        push word [topPipeThreePositionY]
        push word topPipeThreeHeight
        push word [bottomPipeThreePositionX]
        push word [bottomPipeThreePositionY]
        push word bottomPipeThreeHeight

        call drawPipe


        ret


    clrscr:
        push es 
        push ax 
        push cx 
        push di 
        mov ax, 0xb800 
        mov es, ax ; point es to video base 
        xor di, di ; point di to top left column 
        mov ax, 0x0720 ; space char in normal attribute 
        mov cx, 2000 ; number of screen locations 
        cld ; auto increment mode 
        rep stosw ; clear the whole screen 
        pop di
        pop cx 
        pop ax 
        pop es 
        ret 


    fallingBirdy:
        push bp
        mov bp, sp
        push ax
        push bx
        push cx
        push dx
        push si
        push di

        call sleep 
        mov cx, 5
        loopMe:
        call skyTopforBirdy
        add word [birdHeightPosition], 1
        call birdy
        call sleep
        loop loopMe

        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        pop bp
        ret

    jumpBirdy:
        push bp
        mov bp, sp
        push ax
        push bx
        push cx
        push dx
        push si
        push di

        call sleep
        
        mov cx, 11
        loopM:
        sub word [birdHeightPosition], 1
        call skyBottomforBirdy  
        call birdy 
        loop loopM
        
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        pop bp
        ret


    checkClick:
        push bp
        mov bp, sp
        push ax
        push bx
        push cx
        push dx
        push si
        push di

    
        mov ah, 0x01
        int 0x16

        jz exitCheckClick

        mov ah, 0x00
        int 0x16
        cmp al, 0x20
        jne exitCheckClick

        call jumpBirdy


        exitCheckClick:
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        pop bp
        ret



    beginGame:

        push bp
        mov bp, sp
        push ax
        push bx
        push cx
        push dx
        push si
        push di

        mov cx, [birdHeightPosition]
        add cx, birdHeight
        checkTime:

            mov ah, 0x2c; getting system time
            int 21h;ch = hour, cl = minute, dh = second, dl = 1/100th of a second
            mov [time_aux], dh 
            call checkClick
            call fallingBirdy
            call pipeOne
            call pipeTwo

            cmp word [birdHeightPosition], screenHeight - 65 ;ground
            jge exitGame
        
            cmp word [birdHeightPosition], 6 ;sky
            jle exitGame

        loopBack: 
            jmp checkTime 


        exitGame:
            pop di
            pop si
            pop dx
            pop cx
            pop bx
            pop ax
            pop bp
            ret

    start:

    mov ah, 0x00; setting the configuration for the video mode
    mov al, 0x13; choosing the video mode which is 320x200 256 colors
    int 0x10; calling the interrupt to set the video mode i.e. execute the configuration
    


    call drawBackgroundWorld
    call birdy
    call beginGame

    terminate:
    call clrscr
    mov ax, 0x4c00
    int 0x21