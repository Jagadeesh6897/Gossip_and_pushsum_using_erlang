-module(algorithm_executer).
-author("Jag").
-export([start/0,server/3,track_nodes/3]). %worker/1
-import(algo_gossip,[gossipExecutor/2]).
-import(algo_pushsum,[execute_pushsum/4]).
-import(algo_topology,[grid_connected/3, line_connected/3, fully_connected/2, imp2D_connected/3]).
-import(lists,[nth/2]).
-import(math,[sqrt/1, pow/2]).

track_nodes(TotalNodes,HeardNodes,ReadyNodes) ->
    receive
        heard -> 
            if
                HeardNodes+1==TotalNodes ->
                    io:format("Gossip Converged~n"),
                    spid ! done;
                true ->
                  track_nodes(TotalNodes,HeardNodes+1,ReadyNodes)
            end;
        {heard, Ratio} ->
            io:format("Pushsum Converged and ratio is ~p~n",[Ratio]),
            spid ! done;
        iamready ->
            if
                ReadyNodes+1==TotalNodes ->
                     spid ! startrumor;
                true ->
                  track_nodes(TotalNodes,HeardNodes,ReadyNodes+1)
            end
    end,
  track_nodes(TotalNodes,HeardNodes,ReadyNodes).

server(Nodes,Topology,Algorithm)->
  receive
    hello ->
      A = enable_workers(Nodes, Algorithm),
      io:format("Worker pids is ~p~n",[A]),
      case Topology of
        "full." -> fully_connected([],A);
        "line." -> line_connected(Nodes,Nodes,A);
        "2D." -> grid_connected(Nodes, round(sqrt(Nodes)), A);
        "imp2D." -> imp2D_connected(Nodes, round(sqrt(Nodes)), A)
      end,
      [FirstPid|Tail] = A,
      register(fpid,FirstPid);
    startrumor ->
      statistics(wall_clock),
      case Algorithm of
        "gossip." -> fpid ! {rumor, "Hello_Process"};
        "push-sum." -> fpid ! {rumor, 0, 1}
      end;
    done ->
      {_, Time2} = statistics(wall_clock),
      io:format("Time Elapsed is ~p~n",[Time2]),
      exit(self(),normal)
  end,
  server(Nodes,Topology,Algorithm).


enable_workers(0, Algorithm) -> [];
enable_workers(N, Algorithm) ->
  Pid = case Algorithm of
    "gossip." -> spawn(algo_gossip, gossipExecutor, [0,[]]);
    "push-sum." -> spawn(algo_pushsum, execute_pushsum,[0, N, 1,[]])
  end,
  [Pid|enable_workers(N-1, Algorithm)].


start()->
  {ok, N} = io:read("enter number of Nodes"),
  {ok,[Topology]} = io:fread("enter the topology: ", "~s"),
  {ok,[Algorithm]} = io:fread("enter the algorithm: ", "~s"),
    io:format("No of workers: ~p~n",[N]),
    FinalNodeCount = case Topology of
                     "full." -> N;
                     "line." -> N;
                     "2D." -> round(pow(ceil(sqrt(N)),2));
                     "imp2D." -> round(pow(ceil(sqrt(N)),2))
                   end,
    io:format("Final No of workers after rounding: ~p~n",[FinalNodeCount]),
    register(tpid,spawn(algorithm_executer,track_nodes,[FinalNodeCount,0,0])),
    register(spid,spawn(algorithm_executer,server,[FinalNodeCount,Topology,Algorithm])),
    spid ! hello.
