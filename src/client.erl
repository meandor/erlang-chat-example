-module(client).

%% API
-export([start/0, registerClient/1, sendMessage/1]).

serverPID() ->
  Config = utils:load_config(),
  {maps:get(serverName, Config), maps:get(serverNode, Config)}.

printMessage(From, Message) ->
  {PID, Node} = From,
  io:format("~s,~s: ~s ~n", [PID, Node, Message]).

receiveMessages() ->
  receive
    {reply, From, Message} ->
      printMessage(From, Message),
      receiveMessages()
  end.

registerClient(Server) ->
  {_ServerName, ServerNode} = Server,
  pong = net_adm:ping(ServerNode),
  timer:sleep(100),
  Config = utils:load_config(),
  ClientPID = {maps:get(clientName, Config), node()},
  Server ! {register, ClientPID},
  receiveMessages().

start() ->
  Config = utils:load_config(),
  ServerPID = serverPID(),
  ClientPID = spawn(?MODULE, registerClient, [ServerPID]),
  register(maps:get(clientName, Config), ClientPID).

sendMessage(Message) ->
  Config = utils:load_config(),
  ClientPID = {maps:get(clientName, Config), node()},
  serverPID() ! {message, ClientPID, Message}.