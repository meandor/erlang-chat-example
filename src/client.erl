-module(client).

%% API
-export([start/1, registerClient/2, sendMessage/2]).

serverPID() -> {server, 'server@localhost'}.

printMessage(From, Message) ->
  {PID, Node} = From,
  io:format("~s,~s: ~s ~n", [PID, Node, Message]).

receiveMessages() ->
  receive
    {reply, From, Message} ->
      printMessage(From, Message),
      receiveMessages()
  end.

registerClient(Server, ClientPID) ->
  {_ServerName, ServerNode} = Server,
  pong = net_adm:ping(ServerNode),
  timer:sleep(100),
  Server ! {register, ClientPID},
  receiveMessages().

start(ClientNode) ->
  ServerPID = serverPID(),
  ClientPID = spawn(?MODULE, registerClient, [ServerPID, ClientNode]),
  register(client, ClientPID).

sendMessage(Message, ClientPID) ->
  serverPID() ! {message, ClientPID, Message}.