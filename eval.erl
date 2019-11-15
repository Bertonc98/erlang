%This exercise asks you to build a collection of functions that 
%manipulate arithmetical expressions. Start with an expression such as 
%the following: ((2+3)-4), 4 and ~((2*3)+(3*4)) which is fully bracketed 
%and where you use a tilde (~) for unary minus.
%
%First, write a parser for these, turning them into Erlang 
%representations, such as the following: {minus, {plus, {num, 2}, {num,3}}, {num, 4}} 
%which represents ((2+3)-4). We call these exp s. Now, write an 
%evaluator, which takes an exp and returns its value.
%
%You can also extend the collection of expressions to add conditionals: 
%if ((2+3)-4) then 4 else ~((2*3)+(3*4)) where the value returned is the 
%“then” value if the “if” expression evaluates to 0, and it is the “else” 
%value otherwise.

-module(eval).
-export([eval/1, exp_s/1]).

eval({num, X})-> X;
eval({plus, Expr1, Expr2})->eval(Expr1)+eval(Expr2);
eval({minus, Expr1, Expr2})->eval(Expr1)-eval(Expr2);
eval({mul, Expr1, Expr2})->eval(Expr1)*eval(Expr2);
eval({dv, Expr1, Expr2})->eval(Expr1)/eval(Expr2);
eval({neg, Expr1})->-eval(Expr1).


pop([])->[];
pop([_|T])->T.

top([])->empty;
top([H|_])->H;
top(H)->H.

push(Elm, [])-> [Elm];
push(Elm, S)->[Elm|S].


exp_s(Str)->p(Str, [], []).

p([$(|T], Num, Op)->p(T, Num, Op);
p([$+|T], Num, Op)->p(T, Num, push($+, Op));
p([$-|T], Num, Op)->p(T, Num, push($-, Op));
p([$*|T], Num, Op)->p(T, Num, push($*, Op));
p([$/|T], Num, Op)->p(T, Num, push($/, Op));
p([$~|T], Num, Op)->p(T, Num, push($~, Op));
p([$)|T], Num, Op)->extract(T, Num, Op);
p([], Num, _)->Num;
p([N|T], Num, Op)->p(T, push({num, list_to_integer([N])}, Num), Op).


extract(S, Num, [$+|Op])->p(S, push({plus, top(pop(Num)),top(Num)}, pop(pop(Num))), Op);
extract(S, Num, [$-|Op])->p(S, push({minus, top(pop(Num)), top(Num)}, pop(pop(Num))), Op);
extract(S, Num, [$*|Op])->p(S, push({mul, top(pop(Num)), top(Num)}, pop(pop(Num))), Op);
extract(S, Num, [$/|Op])->p(S, push({dv, top(pop(Num)), top(Num)}, pop(pop(Num))), Op);
extract(S, Num, [$~|Op])->p(S, push({neg, top(Num)}, pop(Num)), Op).
