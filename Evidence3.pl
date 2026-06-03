% ===================================================
% 580A. Kefa and First Steps
% from codeforces.com/problemset/problem/580/A
%
% Evidence 3. Demonstration of a Programming Paradigm
% By Germán Uriel Xochihua Moncada A01614712
% Implementation of Computational Methods
% ===================================================


% solve(+List, -MaxLength)
solve([], 0).
solve([H|T], Best) :-
    solve_helper(T, H, 1, 1, Best).

% solve_helper(+Rest, +Prev, +Curr, +Best, -Result)
solve_helper([], _, Curr, Best, FinalBest) :-
    FinalBest is max(Curr, Best).

solve_helper([H|T], Prev, Curr, Best, Result) :-
    (   H >= Prev
    ->  NewCurr is Curr + 1,
        NewBest is max(Best, NewCurr)
    ;   NewCurr is 1,
        NewBest is max(Curr, Best)
    ),
    solve_helper(T, H, NewCurr, NewBest, Result).

% ===================================================
% TESTS
% ===================================================
run_tests :-
    solve([2,2,1,3,4,1], R1), write('Example 1: '),    write(R1), nl,
    solve([2,2,9],        R2), write('Example 2: '),    write(R2), nl,
    solve([1],            R3), write('Single element: '),write(R3), nl,
    solve([1,2,3,4,5],    R4), write('Non-decreasing: '),write(R4), nl,
    solve([5,4,3,2,1],    R5), write('Decreasing: '),   write(R5), nl,
    solve([1,1,1,1],      R6), write('All equal: '),    write(R6), nl,
    solve([3,1,2,1,2,3],  R7), write('Multiple: '),     write(R7), nl,
    solve([],             R8), write('Empty: '),        write(R8), nl.

:- initialization(run_tests, main).