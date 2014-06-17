-module(webpart_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).
-export([terminate/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    {ok, App} = application:get_application(?MODULE),
    {ok, DispatchRules} = file:consult(filename:join([priv_dir(App),
                                                 "dispatch.conf"])),
    lists:foreach(
      fun(DispatchRule) ->
	      lager:info("~p adding dispatch rule ~p",[?MODULE,DispatchRule]),
	      webmachine_router:add_route(DispatchRule)
      end,
      DispatchRules),
    {ok, { {one_for_one, 5, 10}, []} }.

terminate() ->
    {ok, App} = application:get_application(?MODULE),
    {ok, DispatchRules} = file:consult(filename:join([priv_dir(App),
                                                 "dispatch.conf"])),
    lists:foreach(
      fun(DispatchRule) ->
	      lager:info("~p removing dispatch rule ~p",[?MODULE,DispatchRule]),
	      webmachine_router:remove_route(DispatchRule)
      end,
      DispatchRules),
    ok.

dispatch_rules() ->
    [
     {["parts"],webpart_resource,[]}
    ].

priv_dir(Mod) ->
    case code:priv_dir(Mod) of
        {error, bad_name} ->
            Ebin = filename:dirname(code:which(Mod)),
            filename:join(filename:dirname(Ebin), "priv");
        PrivDir ->
            PrivDir
    end.
