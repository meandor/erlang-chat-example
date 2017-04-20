-module(client).

-export([startClients/0, spawnClient/1, startClient/4, connectToServer/6]).

loadConfig() ->
  {ok, Config} = file:consult("./config/client.cfg"),
  Config.

connectToServer(ServerPID, Logfile, ReaderNNrs, SendWait, ServerNode, Cookie) ->
  erlang:set_cookie(ServerNode,Cookie),
  pong = net_adm:ping(ServerNode),
  startClient(ServerPID, Logfile, ReaderNNrs, SendWait).

startClient(ServerPID, Logfile, ReaderNNrs, SendWait) ->
  % Start editor
  {NewReaderNNrs, NewSendWait, NewLogFile} = editor:start_sending(5, Logfile, ReaderNNrs, SendWait, ServerPID),
  % Start reader
  reader:start_reading(false, NewLogFile, NewReaderNNrs, ServerPID),
  % Do everything again
  startClient(ServerPID, NewLogFile, NewReaderNNrs, NewSendWait).

spawnClient(ServerPID) ->
  Config = loadConfig(),
  {ok, Lifetime} = werkzeug:get_config_value(lifetime, Config),
  {ok, SendIntervall} = werkzeug:get_config_value(sendeintervall, Config),
  {ok, ServerNode} = werkzeug:get_config_value(servernode, Config),
  {ok, Cookie} = werkzeug:get_config_value(cookie, Config),
  ClientPID = erlang:spawn(?MODULE, connectToServer, [ServerPID, [], [], SendIntervall, ServerNode, Cookie]),
  timer:kill_after(Lifetime, ClientPID),
  ClientPID.

% Applies Fn with Args 'Times' times. Returns the results of each function call as a list
% Used to call the spawnClient function n times
do_times(Times, Fn, Arg) -> do_times(Times, Fn, Arg, []).
do_times(0, _Fn, _Arg, Results) -> Results;
do_times(Times, Fn, Arg, Results) ->
  NewResults = Results ++ [Fn(Arg)],
  NewTimes = Times - 1,
  do_times(NewTimes, Fn, Arg, NewResults).

startClients() ->
  Config = loadConfig(),
  {ok, Clients} = werkzeug:get_config_value(clients, Config),
  {ok, ServerName} = werkzeug:get_config_value(servername, Config),
  {ok, ServerNode} = werkzeug:get_config_value(servernode, Config),
  ServerPID = {ServerName,ServerNode},
  do_times(Clients, fun client:spawnClient/1, ServerPID).