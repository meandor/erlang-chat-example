-module(server).

%% API
-export([start/0, startServer/1]).

initClientList() -> [].

sendMessage(From, To, Message) ->
  if
    From =/= To ->
      {_ClientName, ClientNode} = To,
      io:format("message: '~s' send to ~s ~n", [Message, ClientNode]),
      To ! {reply, From, Message};
    true ->
      io:format("message: '~s' not send~n", [Message])
  end.

sendMessageToClients(From, Message, Clients) ->
  io:format("got messsage~n"),
  lists:map(fun(Client) -> sendMessage(From, Client, Message) end, Clients).

registerClient(Client, ClientList) ->
  {_ClientName, ClientNode} = Client,
  io:format("Client ~s registered~n", [ClientNode]),
  lists:append(ClientList, [Client]).

startServer(ClientList) ->
  receive
    {register, Client} ->
      NewClientList = registerClient(Client, ClientList),
      startServer(NewClientList);
    {message, From, Content} ->
      sendMessageToClients(From, Content, ClientList),
      startServer(ClientList)
  end.

start() ->
  ClientList = initClientList(),
  ServerPID = spawn(?MODULE, startServer, [ClientList]),
  register(server, ServerPID).
