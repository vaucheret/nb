-module(visitors_admin).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
-include("nb.hrl").

main() ->
    #template {file="./site/templates/bare.html"}.

title() ->
    "Visitor Admin".

body() ->
    #panel{id=inner_body,body=inner_body()}.

inner_body()->
    wf:defer(save,name, #validate{validators=[
	#is_required{text="Name of Company is required",
		     unless_has_value=company}]}),
    wf:defer(save,date1,#validate{validators=[
	#is_required{text="Date is required"}]}),
    [
	#h1{ text="Visitors"},
	#h3{text="Enter appointment"},
	#label{text="Date"},
	#datepicker_textbox{
	    id=date1,
	    options=[
		{dateFormat,"dd/mm/yy"},
		{showButtonPanel,true}
		]
	},
	#br{},
	#label {text="Time"},
	time_dropdown(),
	#br{},
	#label {text="Name"},	
	#textbox{ id=name, next=company},
	#br{},
	#label {text="Company"},	
	#textbox{ id=company},
	#br{},
	#button{postback=done, text="Done"},
	#button{id=save, postback=save, text="Save"}
    ].

time_dropdown() ->
    Hours = lists:seq(8,17),
    #dropdown {id=time ,options=
	[time_option({H,0,0}) || H <- Hours]}.

time_option(T={12,0,0}) ->
    #option{text="12:00 noon",
	    value=wf:pickle(T)};
time_option(T={H,0,0}) when H =< 11 ->
    #option{text=wf:to_list(H) ++ ":00 am",
	    value=wf:pickle(T)};
time_option(T={H,0,0}) when H > 12 ->
    #option{text=wf:to_list(H-12) ++ ":00 am",
	    value=wf:pickle(T)}.


parse_date(Date) ->
    [D,M,Y] = re:split(Date,"/",[{return,list}]),
    {
	wf:to_integer(Y),
	wf:to_integer(M),
	wf:to_integer(D)
    }.
    


event(done) ->
    wf:wire(#confirm{text="Done?",postback=done_ok});
event(done_ok) ->
    wf:redirect("/");
event(save) ->
    wf:wire(#confirm{text="Save?",postback=confirm_ok});
event(confirm_ok) ->
    save_visitor(),
    wf:wire(#clear_validation{}),
    wf:update(inner_body,inner_body()).


save_visitor() ->    
    Time = wf:depickle(wf:q(time)),
    Name = wf:q(name),
    Company = wf:q(company),
    Date = parse_date(wf:q(date1)),
    Record = #visitor{date=Date,time=Time,name=Name,company=Company},
    visitors_db:put_visitor(Record).


    
