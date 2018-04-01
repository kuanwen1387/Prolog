%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Name: Kuan Wen Ng		%%	
%%	Student Number: 5078052		%%
%%	Filename: main.pl (ass2)	%%
%%	Description: Roby the shortest	%%
%%			path finder.	%%
%%					%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define a robot that can move by one position up,down,right or left
% The robot can visit the states as defined in DB.pl
% The robot starts in startState and must find a sequence of states
% that lead to the goalState
% Aim: Write a rule called "roby" which find the shortest path.

% Print function will print path from a list of lists selecting only paths with shortest length
printPath([],_).
printPath([X | List],LEN1):-length(X, LEN2), (LEN1 =:= LEN2 -> printState(X); write("")),printPath(List,LEN1).

% Print the path state by state
printState([]).
printState([X | List]):-length(List, LEN), (LEN > 0 -> write(X), write(", "); write(X), nl), printState(List).

% Function to retrive the paths and shortest length stored in global var for printPath
printShortest:-b_getval(myPath, X), b_getval(myLen, Y), printPath(X,Y).

% Move up
move(X1,Y1,X2,Y2,L,Z1,Z2,F):-A is Y2+1, s(X2,A), B = s(X2,A), C = [B],	% Roby moving to a valid state

				% Roby will not reverse to previous state and alternate path will be different with equal or shorter length
				append(L,C,L2), Z3 = Z1 + 1, Z3 =< Z2, \+reverse(X1,Y1,X2,A), \+member(L2,F),

				(end(X2,A) -> L3 = [L2], append(F,L3,L4),	% Add alternate path to list of paths

								(findPath(Z3,L4) -> findPath(Z3,L4)	% Find alternate path of equal or shorter length if exist

								% Print path if no equal length or shorter path could be found
								; Z4 = Z3 + 1, b_setval(myPath, L4), b_setval(myLen, Z4))

					; move(X2,Y2,X2,A,L2,Z3,Z2,F)).	% Move again if goal state not found

% Move right
move(X1,Y1,X2,Y2,L,Z1,Z2,F):-A is X2+1, s(A,Y2), B = s(A,Y2), C = [B],
				append(L,C,L2), Z3 = Z1 + 1, Z3 =< Z2, \+reverse(X1,Y1,A,Y2), \+member(L2,F),
				(end(A,Y2) -> L3 = [L2], append(F,L3,L4),
							(findPath(Z3,L4) -> findPath(Z3,L4)
								; Z4 = Z3 + 1, b_setval(myPath, L4), b_setval(myLen, Z4))
					; move(X2,Y2,A,Y2,L2,Z3,Z2,F)).

% Move down
move(X1,Y1,X2,Y2,L,Z1,Z2,F):-A is Y2-1, s(X2,A), B = s(X2,A), C = [B],
				append(L,C,L2), Z3 = Z1 + 1, Z3 =< Z2, \+reverse(X1,Y1,X2,A), \+member(L2,F),
				(end(X2,A) -> L3 = [L2], append(F,L3,L4),
								(findPath(Z3,L4) -> findPath(Z3,L4)
								; Z4 = Z3 + 1, b_setval(myPath, L4), b_setval(myLen, Z4))
					; move(X2,Y2,X2,A,L2,Z3,Z2,F)).

% Move left
move(X1,Y1,X2,Y2,L,Z1,Z2,F):-A is X2-1, s(A,Y2), B = s(A,Y2), C = [B],
				append(L,C,L2), Z3 = Z1 + 1, Z3 =< Z2, \+reverse(X1,Y1,A,Y2), \+member(L2,F),
				(end(A,Y2) -> L3 = [L2], append(F,L3,L4),
							(findPath(Z3,L4) -> findPath(Z3,L4)
								; Z4 = Z3 + 1, b_setval(myPath, L4), b_setval(myLen, Z4))
					; move(X2,Y2,A,Y2,L2,Z3,Z2,F)).

% Get start state
start(X,Y):-startState(X,Y), s(X,Y).

% Get end state
end(X,Y):-goalState(X,Y), s(X,Y).

% Roby could not reverse to previous state
reverse(X1,Y1,X2,Y2):-(X1 =:= X2, Y1 =:= Y2).

% Start new path finding with max length of path equal total number of states
findPath:-start(A,B), S = [s(A,B)], aggregate_all(count, s(_,_), C), move(A,B,A,B,S,0,C,[]).

% Find alternate path and add to existing list of paths
findPath(X,F):-start(A,B), S = [s(A,B)], move(A,B,A,B,S,0,X,F).

% Start Roby
roby(X):-[X],findPath, printShortest,!.

roby:-roby('DB').
