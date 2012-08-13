-module(lxw_foobar_websocket).

-define(DEBUG(Arg, Input), 
        io:format("~p~p:"++Arg, [?LINE, ?MODULE|Input])).

-export([handle_join/4,
         handle_close/4,
         handle_incoming/5,
         handle_info/2,
         terminate/2,
         init/0]).

-behaviour(boss_service_handler).

-record(state,{users}).  

init() -> 
    io:format("ssssssssssssssssssssssssssssssssssssssssssssssssssssssssddddddddddddddd"),
    ?DEBUG("sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss",[]),
    {ok, #state{users=dict:new()}}.
    %{ok, []}.
handle_join(Url, Ws, Sid, State)->
    ?DEBUG("handle_join Url=~p~n Ws=~p~n Sid=~p~n  State=~p",
            [Url, Ws, Sid, State]), 
    {noreply, State}.


handle_close(Url, Ws, Sid, State)->
    ?DEBUG("handle_close Url=~p~n Ws=~p~n Sid=~p~n  State=~p",
            [Url, Ws, Sid, State]), 
    {noreply, State}.


handle_incoming(Url, Ws, Sid, Message, State)->
    ?DEBUG("handle_incoming Url=~p~n Ws=~p~n Sid=~p~n Message=~p~n  State=~p",
            [Url, Ws, Sid, Message, State]), 
    {noreply, State}.


handle_info(Info, State) ->
    ?DEBUG("handle_info Info=~p, State=~p", [Info, State]), 
    {noreply, State}.

terminate(Reason, State) ->
    ?DEBUG("terminate Reason=~p, State=~p", [Reason, State]), 
    ok.

