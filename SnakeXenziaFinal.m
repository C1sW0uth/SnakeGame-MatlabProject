%Bao Ngo Snake Xenzia Project
% PLEASE CHOOSE "CHANGE FOLDER" OPTION WHEN RUN THE FILE
%Control the snake with arrows key
%Each food eat =10 points
%The game is over when snake bite itself
clc;
clear all;
global layR layG layB direction key scores highScores time speedIncrease
highScores=0;

SnakeXenzia();
function SnakeXenzia
    global layR layG layB direction key scores highScores time
    
    
    %set default variables properties
    time=0.03
    direction=4;
    scores=0;
    speedIncrease=0;
    key='leftarrow';
    
    %set the initial coordinates of the snake
    snakeR=[15,15,15,15,15];
    snakeC=[18,19,20,21,22];
    
    %The size of the Game Window
    cols=48;
    rows=34;
    
    %Set the background of the play field
    layR =ones(rows,cols);
    layB =ones(rows,cols);
    layG =ones(rows,cols);
    %Set the background color to cyan
    for i=1:rows
        for j=1:cols
            layR(i,j)=8;
            layG(i,j)=164;
            layB(i,j)=167;
        end
    end
    
    %Initialize the game window with the snake
    f = figure('Name','Snake Xenzia','Numbertitle','off','Menubar','none', ...
               'Position',[528 150 cols*10 rows*10]);
    
    set(f,'KeyPressFcn',@snakeKey);
    %%
    %load the opening screen
    open1=imread('openScreen1.png');
    open2=imread('openScreen2.png');
    
    %display the opening screen
    endgame=0
    while endgame~=1
        imshow(open2,'InitialMagnification','fit','Border','tight');
        pause(0.4)
        imshow(open1,'InitialMagnification','fit','Border','tight');
        pause(0.4)
        %check if the figure is on, if off=stop
        if ~ishandle(f)
            endgame=1;
            break
        end
        %check for start game(enter) or stop game(esc)
        switch key
            case 'return'
                break
            case 'escape'
                endgame=1;
        end
    end
    imshow(uint8(cat(3,layR,layG,layB)),'InitialMagnification','fit','Border','tight');
    %%
    %generate food
    foodR=randi(rows);
    foodC=randi(cols);
    %check if the food location  is the same as the snake body locations
    while 1
        if ~ismember(foodR,snakeR) && ~ismember(foodC,snakeC)
            break
        end
        foodR=randi(rows);
        foodC=randi(cols);
    end
    %place the food
        layR(foodR,foodC)=255;
        layG(foodR,foodC)=0;
        layB(foodR,foodC)=0;
    %%
    %The loops for snake movement
    while 1
        %check if window still on, if off=stop
        if ~ishandle(f) ||endgame==1
            close all force;
            break;      
        end
        %detect keystroke
        switch key 
            case 'uparrow'
                if direction~=3
                    direction=1;
                end
            case 'rightarrow'
                if direction~=4
                    direction=2;
                end
            case 'downarrow'
                if direction~=1
                    direction=3;
                end
            case 'leftarrow'
                if direction~=2
                    direction=4;
                end
            case 'escape'
                endgame=1;
        end
        
        %delete the snake
        len=length(snakeR);
        for i=1:length(snakeR)
            layR(snakeR(i),snakeC(i))=8;
            layG(snakeR(i),snakeC(i))=164;
            layB(snakeR(i),snakeC(i))=167;
        end
    
        %moving the body
        snakeR(2:len)=snakeR(1:len-1);
        snakeC(2:len)=snakeC(1:len-1);
        %Change the coordinates of the head & check if the snake go through the border 
        switch direction
            case 1
                if snakeR(1)==1
                    snakeR(1)=rows;
                else
                    snakeR(1)=snakeR(1)-1;
                end
            case 2 
                if snakeC(1)==cols
                    snakeC(1)=1;
                else
                    snakeC(1)=snakeC(1)+1;
                end
            case 3
                if snakeR(1)==rows
                    snakeR(1)=1;
                else
                    snakeR(1)=snakeR(1)+1;
                end
            case 4
                if snakeC(1)==1
                    snakeC(1)=cols;
                else
                    snakeC(1)=snakeC(1)-1;
                end
        end
        %Check if snake collide with itself
            if sum((snakeR(2:end)==snakeR(1)) & (snakeC(2:end)==snakeC(1)))
                %display the game over screen q 
                gg1=imread('Gameover.png');
                gg2=imread('Gameover2.png')
                snakeIcon = imread('snakeIcon.png');
                %check for highscore
                if scores>highScores
                    highScores=scores;
                end
                %display the score in a msg box
                score = msgbox(sprintf('\t Your Scores: %.0d\n Current High Score: %.0d\n Press Enter to play again!',scores,highScores),'Snake Xenzia','Custom',snakeIcon);
                th = findall(score, 'Type', 'Text'); %this font changing code is from https://bit.ly/3AU99ln     
                th.FontSize = 10;
                endgame=1;
                %flickerting the endgame screen
                while 1
                imshow(gg1,'InitialMagnification','fit','Border','tight');
                pause(0.5);
                imshow(gg2,'InitialMagnification','fit','Border','tight');
                pause(0.5);
                %check for enter key for restart
                    switch key
                        case 'return'
                            close force all;
                            SnakeXenzia();
                    end
                    if ~ishandle(f)
                        break
                    end
                end
            end
    
        %Check if snake eat food
        if snakeC(1)==foodC && snakeR(1)==foodR
            %snake grows by 1
            snakeR(2:len+1)=snakeR(1:len);
            snakeC(2:len+1)=snakeC(1:len);
            %scores update
            scores=scores+10;
            %spawn new food
            while 1
                if ~ismember(foodR,snakeR) && ~ismember(foodC,snakeC)
                 break
                end
                foodR=randi(rows);
                foodC=randi(cols);
            end
    
        %place the food
        layR(foodR,foodC)=255;
        layG(foodR,foodC)=0;
        layB(foodR,foodC)=0;
        end
       
        %update the snake and display next frame
        snakeUpdate(snakeR,snakeC);
        imshow(uint8(cat(3,layR,layG,layB)),'InitialMagnification','fit','Border','tight');
        %pause between frames
        speed=scores/10;
        speedIncrease=speed/1.2
        if scores ~=0 && mod(speed,5)==0
            time=0.03/speedIncrease
        end
        pause(time);    
    end
end
%%
%function to update the snake
function snakeUpdate(snakeR,snakeC)
global layR layG layB
    %set the color of the head
    layR(snakeR(1),snakeC(1))=255;
    layG(snakeR(1),snakeC(1))=255;
    layB(snakeR(1),snakeC(1))=255;
    %set the color of the body
    for i=2:length(snakeR)
        layR(snakeR(i),snakeC(i))=0;
        layG(snakeR(i),snakeC(i))=0;
        layB(snakeR(i),snakeC(i))=0;
    end
end
%%
%function to detect key stroke
function snakeKey(src,event)
   global key
   key= char(event.Key);

end




