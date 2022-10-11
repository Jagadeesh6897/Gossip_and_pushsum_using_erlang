-module(algo_gossip).
-author("Jag").
-import(timer,[send_after/3]).
-export([gossipExecutor/2, gossiping/2]).



gossipExecutor(N, Neighbors) ->
  receive
    hello -> io:format("In gossip~n");
    {setup, NeighborList} ->
      io:format("Neighbors of Node ~p are: ~p~n", [self(), NeighborList]),
      tpid ! iamready,
      gossipExecutor(N, NeighborList);

    {rumor, Rumor} ->
      if
        N+1 == 1 ->
          tpid ! heard,
          io:format("Node ~p received rumour: ~p~n",[self(),Rumor]),
          spawn(algo_gossip, gossiping, [Rumor, Neighbors]),
          gossipExecutor(N+1, Neighbors);
        N < 12 ->
          gossipExecutor(N+1, Neighbors);
        N >= 12 ->
          exit(self(),normal)
      end
  end,
  gossipExecutor(N, Neighbors).

gossiping(Rumor,[]) -> Rumor;
gossiping(Rumor, Neighbors) ->
  Dest = get_random_neighbor(Neighbors),
  send_after(100, Dest, {rumor,Rumor}),
  gossiping(Rumor, Neighbors).

get_random_neighbor(Neighbors) ->
  lists:nth(rand:uniform(length(Neighbors)),Neighbors).



