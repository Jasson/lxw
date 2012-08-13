-module(lxw_init).

-export([init/0]).

%-record(session, {user = "", ws = "", sid = ""}).
-include("lxw.hrl").
init() ->
    mnesia:create_schema([node()]),
    application:start(mnesia),
    mnesia:create_table(session,
                        [{ram_copies, [node()|nodes()]},
                         {attributes, record_info(fields, session)}]),
    mnesia:add_table_index(session, sid),
    ok.
    
