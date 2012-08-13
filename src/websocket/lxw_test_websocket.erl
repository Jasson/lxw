-module(lxw_test_websocket).

-define(DEBUG(Arg, Input), error_logger:info_msg("~p~p:"++Arg++"\n\n", [?MODULE, ?LINE|Input])).

-export([handle_join/4,
         handle_close/4,
         handle_incoming/5,
         handle_info/2,
         terminate/2,
         init/0]).

-behaviour(boss_service_handler).

-record(state,{users}).  
-include("lxw.hrl").

init() -> 
    %{ok, []}.
    %{ok, #state{users=[]}}.
    {ok, #state{users=dict:new()}}.
handle_join(Url, Ws, Sid, State)->
    ?DEBUG("handle_join Url=~p~n Ws=~p~n Sid=~p~n  State=~p",
            %[Url, Ws, Sid, State]), 
            [Url, Ws, Sid, dict:to_list(State#state.users)]), 
    #state{users=Users} = State,
    case mnesia:dirty_index_read(session, binary_to_list(Sid), sid) of
        [Session] ->
            mnesia:dirty_write(Session#session{ws=Ws});
        _ ->
            ok 
    end,
    Ws ! {text, "connect join"},
    Ws ! {text, <<"connect join bin....">>},
    {reply, ok, #state{users=dict:store(Ws,Sid,Users)}}.     
    %{reply, ok, #state{users=dict:store(Ws,Sid,Users)}}.     
    %{noreply, State}.


handle_close(Url, Ws, Sid, #state{users=Users}=State)->
    ?DEBUG("handle_close Url=~p~n Ws=~p~n Sid=~p~n  State=~p",
            [Url, Ws, Sid, dict:to_list(State#state.users)]), 
            %[Url, Ws, Sid, State]), 
    Ws ! {text, "close"},
    {reply, close, #state{users=dict:erase(Ws,Users)}}.


handle_incoming(Url, Ws, Sid, Message, State)->
    ?DEBUG("handle_incoming Url=~p~n Ws=~p~n Sid=~p~n Message=~p~n  State=~p",
            [Url, Ws, Sid, Message, dict:to_list(State#state.users)]), 
            %[Url, Ws, Sid, Message, State]), 

    List = ets:tab2list(session),
    [begin Ws1 ! {text, Message} end||#session{ws = Ws1} <- List],
    Ws ! {text, Message},
    {noreply, State}.


handle_info(Info, State) ->
    ?DEBUG("handle_info Info=~p, State=~p", 
            [Info, dict:to_list(State#state.users)]), 
            %[Info, State]), 
    {noreply, State}.

terminate(Reason, State) ->
    ?DEBUG("terminate Reason=~p, State=~p", 
            [Reason, dict:to_list(State#state.users)]), 
            %[Reason, State]), 
    ok.

