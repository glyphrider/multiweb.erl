-module(webpart_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    webpart_sup:start_link().

stop(_State) ->
    webpart_sup:terminate().
