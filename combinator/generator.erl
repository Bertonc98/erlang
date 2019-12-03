-module(generator).
-export([gen/7]). 

gen(Id,  _, 0, _, _, _,List) -> master!{res, Id, lists:reverse(List)};
gen(Id, Every, N, Count, I, In, List) when I<Every -> if
														In=<Count -> gen(Id,  Every, (N-1), Count, (I+1), In, [In|List]);
														true -> gen(Id,  Every, (N-1), Count, (I+1), In, [In|List])
													   end;
gen(Id, Every, N, Count, I, In, List) when I>=Every  -> if
														In<Count -> gen(Id,  Every, (N-1), Count, 1, (In+1), [In|List]);
														true -> gen(Id,  Every, (N-1), Count, 1, 1, [In|List])
													   end.
