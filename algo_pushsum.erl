-module(algo_pushsum).
-author("Jag").
-export([execute_pushsum/4]).

execute_pushsum(N, ExistingS, ExistingW, Neighbors) ->
  Threshold = 0.0000000001,
  receive
    hello ->
      io:format("Executing pushsum........~n");
    {setup, NeighborList} ->
      io:format("Node ~p Neighbours are: ~p~n", [self(), NeighborList]),
      tpid ! iamready,
      execute_pushsum(N, ExistingS, ExistingW, NeighborList);
    {rumor, S, W} ->
      NewS = ExistingS + S,
      NewW = ExistingW + W,
      HalfS = NewS/2,
      HalfW = NewW/2,
      Diff = abs(NewS/NewW - ExistingS/ExistingW),
      if
        (Diff < Threshold) and (N >= 3) ->
          tpid ! {heard, NewS/NewW};
        (Diff < Threshold) and (N < 3) ->
          get_random_neighbor(Neighbors) ! {rumor, HalfS, HalfW},
          execute_pushsum(N+1, HalfS, HalfW, Neighbors);
        Diff >= Threshold->
          get_random_neighbor(Neighbors) ! {rumor, HalfS, HalfW},
          execute_pushsum(0, HalfS, HalfW, Neighbors)
      end
  end,
  execute_pushsum(N, ExistingS, ExistingW, Neighbors).

get_random_neighbor(Neighbors) ->
  lists:nth(rand:uniform(length(Neighbors)),Neighbors).