% Tetris Gui
% Phillip Ngo
% CONTROLS: Arrow Keys, Space Bar, C (to hold)

function varargout = Tetris(varargin)
% GUI initialization
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Tetris_OpeningFcn, ...
    'gui_OutputFcn',  @Tetris_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function Tetris_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>
handles.output = hObject;

handles.axis = [handles.axes2 handles.axes3 handles.axes4 ...
                handles.axes5 handles.axes6 handles.axes7];

axes(handles.axes1)

% each block is 5x5 smaller blocks
plot([1,1],[0,2], '-k')

axis([0 1 0 2])
set(gca, 'xtick', [], 'xticklabel', [], 'ytick', [], 'yticklabel', []);

for i = 1:length(handles.axis)
    axes(handles.axis(i)) %#ok<LAXES>
    axis([0 5 0 5])
    plot([0 0 5 5],[5 0 0 5], 'k-')
    set(gca, 'xtick', [], 'xticklabel', [], 'ytick', [], 'yticklabel', []);
end

guidata(hObject, handles);



function varargout = Tetris_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.output;


function z = stack(x, y, x2, y2)
stack = true;
slide = true;
slide2 = true;

for i = 1:length(x)
   for j = 1:length(x2)
       if abs(x(i) - x2(j)) < .0000001
           check = y(i) - .02;
           if abs(check - y2(j)) < .0000001
              stack = false; 
           end
       end
   end
end

for i = 1:length(y)
   for j = 1:length(y2)
       if abs(y(i) - y2(j)) < .0000001
           check = x(i) - .02;
           check2 = x(i) + .02;
           if abs(check - x2(j)) < .0000001
              slide = false; 
           end
           if abs(check2 - x2(j)) < .0000001
              slide2 = false; 
           end
       end
   end
end

z = [stack slide slide2];

function z = turn(x, y, piece)
avgx = sum(x(1:17))/17;
avgy = sum(y(1:17))/17;

j = 18;

for i = 1:3
    avgx2 = sum(x(j:j+16))/17;
    avgy2 = sum(y(j:j+16))/17;
    if piece ~= 1
        if abs(avgx-avgx2) < .0000001 && avgy2 - avgy > .09999 && avgy2 - avgy < .105
            x(j:j+16) = x(j:j+16) + .1;
            y(j:j+16) = y(j:j+16) - .1;
        elseif abs(avgx-avgx2) < .0000001 && avgy2 - avgy < -.09999 && avgy2 - avgy > -.105
            x(j:j+16) = x(j:j+16) - .1;
            y(j:j+16) = y(j:j+16) + .1;
        elseif avgx2 - avgx > .09999 && abs(avgy-avgy2) < .0000001 && avgx2 - avgx < .105
            x(j:j+16) = x(j:j+16) - .1;
            y(j:j+16) = y(j:j+16) - .1;
        elseif avgx2 - avgx < -.09999 && abs(avgy-avgy2) < .0000001 && avgx2 - avgx > -.105
            x(j:j+16) = x(j:j+16) + .1;
            y(j:j+16) = y(j:j+16) + .1;
        elseif avgx2 - avgx < -.09999 && avgy2 - avgy < -.09999
            y(j:j+16) = y(j:j+16) + .2;
        elseif avgx2 - avgx < -.09999 && avgy2 - avgy > .09999
            x(j:j+16) = x(j:j+16) + .2;
        elseif avgx2 - avgx > .09999 && avgy2 - avgy < -.09999
            x(j:j+16) = x(j:j+16) - .2;
        elseif avgx2 - avgx > .09999 && avgy2 - avgy > .09999
            y(j:j+16) = y(j:j+16) - .2;
        end
    end
    if piece == 4
        if abs(avgx-avgx2) < .0000001 && avgy2 - avgy > .101
            x(j:j+16) = x(j:j+16) + .2;
            y(j:j+16) = y(j:j+16) - .2;
        elseif abs(avgx-avgx2) < .0000001 && avgy2 - avgy < -.101
            x(j:j+16) = x(j:j+16) - .2;
            y(j:j+16) = y(j:j+16) + .2;
        elseif avgx2 - avgx > .101 && abs(avgy-avgy2) < .0000001
            x(j:j+16) = x(j:j+16) - .2;
            y(j:j+16) = y(j:j+16) - .2;
        elseif avgx2 - avgx < -.101 && abs(avgy-avgy2) < .0000001
            x(j:j+16) = x(j:j+16) + .2;
            y(j:j+16) = y(j:j+16) + .2;
        end
    end
    
    j = j + 17;
end

z = [x;y];

function z = duplicate(x, y, x2, y2)
z = false;
for i = 1:length(x2)
    if min(y) == y2(i) 
        z = 1;
    end
end

function z = wallCheck(x, y, x2, y2)

while min(x) <= min(x2)
   x = x + .1;
end
while max(x) >= max(x2)
   x = x - .1; 
end


z = [x;y];

function StartButton_Callback(hObject, eventdata, handles) %#ok<*DEFNU,*INUSD>

set(handles.StartButton,'Visible','off')
drawnow
set(handles.StartButton,'Visible','on')

set(handles.Leaderboard,'Visible','off')
drawnow
set(handles.Leaderboard,'Visible','on')

axes(handles.axes1);
borderx = [];
for i = 1:102
    borderx = [borderx .04];
end
borderx =  [borderx .04:.02:1.06];
for i = 1:101
    borderx = [borderx 1.06];
end

j = 1;
for i = 2:-.02:-.02
    bordery(j) = i;
    j = j+1;
end
bordery =  [bordery zeros(1,52)-.02];
j = 155;
for i = 0:.02:2
    bordery(j) = i;
    j = j+1;
end


squaresx = [];
squaresy = [];
holder = 0;
holdcheck = false;
holded = 1;
score = 0;
level = 1;
linesleft = 10;
speed = 20;

while isempty(squaresy) || max(squaresy) < 2
    space = false;
    x = [.46   .48   .50   .52   .54   .54   .54   .54   .54   .52   .50   .48   .46   .46   .46   .46   .46 ];
    y = [2.00  2.00  2.00  2.00  2.00  2.02  2.04  2.06  2.08  2.08  2.08  2.08  2.08  2.06  2.04  2.02  2.00];
    
    i = 0;
    lines = 0;
    while i < 2
        count = 0;
        for j = 1:length(squaresy)
           currentrow = i;
           square = i-.02:-.02:i-.08;
           if abs(squaresy(j) - i) < .0000001
               count = count+1;
           end
        end
        if count == 50
            lines = lines + 1;
            count2 = 1;
            while count2 <= length(squaresy)
                if abs(squaresy(count2) - currentrow) < .0000001
                    squaresy(count2) = [];
                    squaresx(count2) = [];
                    count2 = count2 - 1;
                end
                count2 = count2 + 1;
            end
            for k = 1:length(square)
                count2 = 1;
                while count2 <= length(squaresy)
                    if abs(squaresy(count2) - square(k)) < .0000001
                        squaresy(count2) = [];
                        squaresx(count2) = [];
                        count2 = count2 - 1;
                    end
                    count2 = count2 + 1;
                end
            end
            for j = 1:length(squaresy)
               if squaresy(j) > currentrow
                   squaresy(j) = squaresy(j) - .1;
               end
            end
            i = i - .02;
        end
        i = i + .02;
    end
    linesleft = linesleft - lines;
    if linesleft <= 0
        linesleft = 10;
        level = level + 1;
        speed = speed - 2;
    end
    switch lines
        case 1
            score = score + 1;
        case 2
            score = score + 3;
        case 3
            score = score + 5;
        case 4
            score = score + 10;
    end
    
    set(handles.ScoreText, 'String', num2str(score))
    set(handles.sentText, 'String', num2str(linesleft))
    set(handles.levelText2, 'String', num2str(level))
    
    clear('i')
    if holder == 0 || holdcheck == false || piece == 0
        choice = randi(7);
        holdcheck = false;
    else
        choice = piece;
        holdcheck = false;
    end
    switch choice
        case 1 % square
            piece = 1;
            x = [x x+.1 x+.1 x];
            y = [y y y+.1 y+.1];
        case 2 
            piece = 2; % L
            x = [x x-.1 x+.1 x+.1];
            y = [y y y y+.1];
        case 3
            piece = 3; % L
            x = [x x+.1 x-.1 x-.1];
            y = [y y y y+.1];
        case 4
            piece = 4; % straight line
            x = [x x x x];
            y = [y y+.1 y+.2 y-.1];
        case 5
            piece = 5; % z
            x = [x x x+.1 x-.1];
            y = [y y+.1 y y+.1];
        case 6
            piece = 6; % z
            x = [x x x+.1 x-.1];
            y = [y y+.1 y y];
        case 7
            piece = 7; % T
            x = [x x x+.1 x-.1];
            y = [y y+.1 y+.1 y];
    end
    hold on
    bottom = stack(x, y,[borderx squaresx], [bordery squaresy]);
    while (bottom(1) == true && space ~= true && holdcheck == false)
        y = y-.1;
        j = 1;
        space = false;
        bottom = stack(x, y,[borderx squaresx], [bordery squaresy]);
        
        while j < speed && space ~= true && holdcheck == false
            cla
            set(gcf, 'KeyPressFcn', @(x,y)get(gcf,'CurrentCharacter'))
            z = get(gcf, 'CurrentCharacter');
            switch z
                case 30 % up arrow, rotate
                    new = turn(x, y, piece);
                    x = new(1,:);
                    y = new(2,:);
                    wall = wallCheck(x, y, borderx, bordery);
                    x = wall(1,:);
                    y = wall(2,:);
                    j = j - 1;
                case 28 % left arrow
                    if (bottom(2) == true)
                        x = x-.1;
                    end
                    j = j - 1;
                case 31 % down arrow
                    if (bottom(1) == true)
                        y = y-.1;
                    end
                     j = j - 1;
                case 29 % right arrow
                    if (bottom(3) == true)
                        x = x+.1;
                    end
                    j = j - 1;
                case 32 % space bar
                    mini = stack(x, y,[borderx squaresx], [bordery squaresy]);
                    while mini(1) == true
                        y = y - .1;
                        space = true;
                        mini = stack(x, y,[borderx squaresx], [bordery squaresy]);
                    end
                case 'c' % c key, hold button
                    if holded == 1
                        holdcheck = true;
                        temp = holder;
                        holder = piece;
                        piece = temp;
                        holded = 0;
                    end
            end
            
            predy = y;
            prediction = stack(x, predy,[borderx squaresx], [bordery squaresy]);
            while(prediction(1) == true)
                predy = predy - .1;
                prediction = stack(x, predy,[borderx squaresx], [bordery squaresy]);
            end
            
            plot(x, y, 'bs', 'LineWidth', 2)
            if predy ~= y
                plot(x, predy, 'ks', 'LineWidth', 1, 'MarkerSize', 2)
            end
            plot(squaresx, squaresy, 'rs', 'LineWidth', 2)
            plot(borderx, bordery, 'ks', 'LineWidth', 2, 'MarkerFaceColor', 'k')
            axis([.03 1.07 -0.03 2])
            set(gca, 'xtick', [], 'xticklabel', [], 'ytick', [], 'yticklabel', []);
            set(gcf, 'currentch', 'o')
            pause(.05)
            drawnow
            j = j + 1;
            bottom = stack(x, y,[borderx squaresx], [bordery squaresy]);
            
        end
        
    end
    if holdcheck == false
        squaresx = [squaresx x];
        squaresy = [squaresy y];
        holded = 1;
    end
end

function Leaderboard_Callback(hObject, eventdata, handles)



function themesMenu_Callback(hObject, eventdata, handles)



function themesMenu_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


