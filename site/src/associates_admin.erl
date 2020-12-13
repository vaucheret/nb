-module(associates_admin).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
-include("nb.hrl").

main() -> #template { file="./site/templates/bare.html" }.

title() -> "Associates Admin".

body() ->
    wf:wire(save, lname, #validate{validators=
       #is_required{text="Last Name Required"}}),
    [
     #h1{ text="Associates Directory" },
     #h3{text="Enter directory listing"},
     #flash{},
     #label {text="Last Name"},
     #textbox{ id=lname, next=fname},
     #br{},
     #label {text="First Name"},
     #textbox{ id=fname, next=ext},
     #br{},
     #label {text="Extension"},
     #textbox{ id=ext},
     #br{},
     #button{id=save, postback=save, text="Save"},
     #link{url="/", text="Cancel"}
    ].

clear_form() ->
    wf:set(lname, ""),
    wf:set(fname, ""),
    wf:set(ext, "").

event(save) ->
    wf:wire(#confirm{text="Save?", postback=confirm_ok});
event(confirm_ok) ->
    [LName, FName, Extension] = wf:mq([lname, fname, ext]),
    Record = #associate{lname=LName, fname=FName, ext=Extension},
    associates_db:put_associate(Record),
    clear_form(),
    wf:flash("Saved").
