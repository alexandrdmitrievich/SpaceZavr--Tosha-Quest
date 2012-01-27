quests={}
-- ?????? ????? - ????????? ? ?????????? ? N ????????? item ? ????????? ? ???? {1-2-3} ??????? ???? ??????????, ? {1-2-3} ????
--
function new_quest(y,x,id, N, deadlist, alivelist)
	table.insert(quests,{tox=x,toy=y,item_id=id, item_N=N, dead_list= deadlist, alive_list=alivelist})
end

function check_quests()
	
	table.foreach(quests, function(k,v) check_quest(k,v) end)
end

function check_quest(q_id, quest)
	local it=1
	local de=1
	local al=1;
	--errormsg = errormsg.."\n"
	--errormsg = errormsg.."quest.item_id = ".. quests[q_id].item_id
	if(items[quest.item_id].have < quest.item_N) then
		it=-1;
		--items[quest.item_id].have=items[quest.item_id].have- quest.item_N;
	end
	
	local qdl = quest.dead_list
	
	table.foreach(qdl, function (k,v) 
		errormsg = errormsg.."\n"
		errormsg = errormsg.."quest.dead_list = "..v
		if(thetable[v].alive == 1) then
			de = -1
			errormsg = errormsg.."\n"..v.." still alive"
		else
			errormsg = errormsg.."\n"..v.." dead"
		end
	end)
	
	local qal = quest.alive_list
	
	table.foreach(qal, function (k,v) 
		errormsg = errormsg.."\n"
		errormsg = errormsg.."quest.alive_list = "..v
		if(thetable[v].alive == 0) then
			al = -1
			errormsg = errormsg.."\n"..v.." dead"
		else
			errormsg = errormsg.."\n"..v.." alive"
		end
	end)
		--end
	
	
--	for i=0, #quest.alive_list do
--		if(thetable[quest.alive_list[i]].alive == 0) then
--		al = -1
--		break;
--		end
--	end
	
	if(it == 1 and de == 1 and al == 1) then
		-- quest complite!11
		end_quest(q_id)
		items[quest.item_id].have=items[quest.item_id].have- quest.item_N;
	end
end

function end_quest(k)
	money = money + 1000
	table.remove(quests,k)
	game_state='menu'
end

function dialog()
	-- ????????????????!
end