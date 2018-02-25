%%%-------------------------------------------------------------------
%%% @author dschruhl
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(neptr_utils).
-author("dschruhl").

%% API
-export([seedPID/0, peerPID/0, peerClientName/0, peerServerName/0]).

seedPID() ->
  {ok, SeedName} = application:get_env(neptr, seedName),
  {ok, SeedNode} = application:get_env(neptr, seedNode),
  {SeedName, SeedNode}.

peerPID() ->
  {ok, PeerName} = application:get_env(neptr, peerName),
  {PeerName, node()}.

peerClientName() ->
  {ok, PeerName} = application:get_env(neptr, peerName),
  PeerNameString = atom_to_list(PeerName),
  ClientName = PeerNameString ++ "Client",
  list_to_atom(ClientName).

peerServerName() ->
  {ok, PeerName} = application:get_env(neptr, peerName),
  PeerNameString = atom_to_list(PeerName),
  ClientName = PeerNameString ++ "Server",
  list_to_atom(ClientName).