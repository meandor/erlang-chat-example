%%%-------------------------------------------------------------------
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(utils).

%% API
-export([load_config/0]).

load_config() ->
  {ok, [ConfigMap]} = file:consult("./config/default.cfg"),
  ConfigMap.
