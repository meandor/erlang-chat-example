%%%-------------------------------------------------------------------
%%% @author dschruhl
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(neptr_utils).
-author("dschruhl").

%% API
-export([seedPID/0, peerPID/0]).

seedPID() ->
  {ok, SeedName} = application:get_env(neptr, seedName),
  {ok, SeedNode} = application:get_env(neptr, seedNode),
  {SeedName, SeedNode}.

peerPID() ->
  {ok, PeerName} = application:get_env(neptr, peerName),
  {PeerName, node()}.