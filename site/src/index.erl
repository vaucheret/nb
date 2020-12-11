%% -*- mode: nitrogen -*-
-module (index).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

main() -> #template { file="./site/templates/bare.html" }.

title() -> "Welcome to Nitrogen".


body() -> 
    [
        #h1 { text="WELCOME!" },
        #h2 { text="Rusty Klophaus" },
        #h2 { text="Jesse Gumms" }
    ].
	
event(click) ->
    wf:replace(button, #panel { 
        body="ohhhhh me clickeaste!", 
        actions=#effect { effect=highlight }
    }).
