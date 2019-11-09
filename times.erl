-module (times).
-export([volte/2, volte/1]).

volte(X,N)->mult(X,N).
volte(X)->X*2.
mult(X, N)->X*N.
