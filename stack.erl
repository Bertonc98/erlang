-module(stack).
-export([is_empty/1, empty/0, pop/1, push/2, top/1]).

is_empty([])->true;
is_empty(_)->false.

empty()->[].

pop([_|T])->T;
pop([])->empty.

push(Elm, [])->[Elm];
push(Elm, S)->[Elm|S].

top([H])->H;
top([H|_])->H;
top([])->empty.

