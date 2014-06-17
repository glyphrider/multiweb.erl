%% @author author <author@example.com>
%% @copyright YYYY author.

%% @doc Callbacks for the webcore application.

-module(webcore_app).
-author('author <author@example.com>').

-behaviour(application).
-export([start/2,stop/1]).


%% @spec start(_Type, _StartArgs) -> ServerRet
%% @doc application start callback for webcore.
start(_Type, _StartArgs) ->
	lager:start(),
    webcore_sup:start_link().

%% @spec stop(_State) -> ServerRet
%% @doc application stop callback for webcore.
stop(_State) ->
    ok.
