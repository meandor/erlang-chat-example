%%%-------------------------------------------------------------------
%%% @author dschruhl
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(neptr_client).
-author("dschruhl").

%% API
-export([start_link/0, registerClient/1]).

printMessage(From, Message) ->
  {PID, Node} = From,
  io:format("~s,~s: ~s ~n", [PID, Node, Message]).

receiveMessages() ->
  receive
    {reply, From, Message} ->
      printMessage(From, Message),
      receiveMessages();
    stop ->
      io:format("shutting down")
  end.

registerClient(SeedPID) ->
  {_SeedName, SeedNode} = SeedPID,
  pong = net_adm:ping(SeedNode),
  timer:sleep(100),
  SeedPID ! {register, neptr_utils:peerPID()},
  receiveMessages().

start_link() ->
  SeedPID = neptr_utils:seedPID(),
  ClientPID = spawn(?MODULE, registerClient, [SeedPID]),
  register(neptr_utils:peerClientName(), ClientPID).