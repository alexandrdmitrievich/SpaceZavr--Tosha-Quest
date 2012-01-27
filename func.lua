-------------------------------------------------------
-- функции
-------------------------------------------------------

function add(clss,wwx,wwy,ang,spd) -- добавление всякого
-- to do
-- добавление вектора инициализации, что бы это нибыло
	table.insert(thetable,{class=clss,wx=wwx,wy=wwy,ox=0,oy=0,angle=ang,speed=spd,speedup=0,pic=love.graphics.newImage(clss..'.png'),alive=1,hp=100})
end

-- обновление мира
function updater(v,k)
	--gr.setColor(255,255,255)-- нахуя мне тут цвет ставить?
	if(v.alive) then -- если живой
		
		
		v.wx = v.wx+v.speed*math.sin(v.angle);
		v.wy = v.wy-v.speed*math.cos(v.angle); -- то летим вжжжж

		if(v.class == 'player') then -- контроллируем играка, чтоб не летел со скоростью света в хуйпоймикуда
			v.speed = v.speed+v.speedup;
	
			if(v.speedup>0.05) then v.speedup = 0.05 end
	
			if(v.speedup<-0.05) then v.speedup = -0.05 end
	
			if(v.speed > 10) then 
				v.speed = 10;
				v.speedup=0;
			end
		
			if(v.speed < -10) then 
				v.speed = -10;
				v.speedup=0;
			end
		else -- не игрок летит вжжжж
			v.ox = v.wx-thetable[zavr].wx+thetable[zavr].ox;
			v.oy = v.wy-thetable[zavr].wy+thetable[zavr].oy;	
--if(AIstep >=15) then
			if(v.class=='cargo') then
				--errormsg=errormsg.."!"
				autopilot(v, 0,0) --------------------- координата автопилота
			elseif(v.class=='asteroid') then
				v.angle=v.angle+0.1;
			end
		end
--		end
	else -- если он не живой то мы его удолил!!!1
		--table.remove(thetable,k)
	end

end

function bul (v, k)
	if (v.alive == 1) then
		v.wx = v.wx+v.speed*math.sin(v.angle);
		v.wy = v.wy-v.speed*math.cos(v.angle);
		v.ox = v.wx-thetable[zavr].wx+thetable[zavr].ox;
		v.oy = v.wy-thetable[zavr].wy+thetable[zavr].oy;
		
		table.foreach(thetable,function(num,ship) if(v.parent ~= ship.class and ship.alive ==1) then if(math.sqrt((((v.wx - ship.wx)^2) + ((v.wy - ship.wy)^2)))<20) then v.alive=0 ship.hp=ship.hp-1 if(ship.hp<0)then ship.alive=0 end end end end)
		
		v.ttl = v.ttl-1; 
		if(v.ttl < 0) then v.alive = 0 end	
	else
		table.remove(bullets,k)
	end
end




function interact()
	local zvr = thetable[zavr]
	table.foreach(large,function(k,v) if(math.sqrt((((v.wx - zvr.wx)^2) + ((v.wy - zvr.wy)^2)))<300) then game_state = 'shop'  end end)
end

function autopilot(v,tox,toy) -- зайчаток ИИ
	local turn
	
	errormsg=errormsg.."\n"
	if(v.alive==0) then return 1 end -- живой
	
	-- перепишите ктонить это ГОВНО за меня :3
	
	if(math.sqrt((((v.wx-tox)^2+((v.wy-toy)^2))))<60)  then v.alive=0 return 1 end -- прилетел
	

	if(v.autop == nil) 
	then -- если не включен автопилот
		errormsg=errormsg..'enable AP.'
		
		-- предустановки. чтоб не считать полеты по прямым и диагоналям
		if(math.abs(math.abs(v.wx)-math.abs(tox)) <= 1 and v.wy < toy) then  -- цель ровно над
			turn = math.pi errormsg=errormsg..'\n  preset zerro.'
			--love.timer.sleep(1000)

		elseif(math.abs(math.abs(v.wx)-math.abs(tox)) <= 1 and v.wy > toy) then -- цель ровно под
			if((v.angle-2*math.pi)>v.angle) then
			turn = math.pi*2 errormsg=errormsg..'\n  preset pi.'
			else turn = 0
			end
			--love.timer.sleep(1000)

		else

			if(math.abs(math.abs(v.wx)-math.abs(tox)) <= 1) then tox=tox+0.1 end -- чтоб не было деления на 0
			if(tox>=v.wx and toy>=v.wy) then turn = math.pi-math.atan((tox-v.wx)/(toy-v.wy)) 
			elseif (tox<v.wx and toy>=v.wy) then turn = math.pi-math.atan((tox-v.wx)/(toy-v.wy)) 
			elseif (tox>v.wx and toy<v.wy) then turn = -math.atan((tox-v.wx)/(toy-v.wy)) 
			else 
			turn =2*math.pi+math.atan((tox-v.wx)/(v.wy-toy))   end -- меня доебали эти тангенсы, честно
			end
	
	v.autop=turn -- вот значит туда и летим, блин
	
	if(v.angle < 0)
		then
			v.angle = v.angle+2*math.pi
		end
	if(v.angle > 2*math.pi)
		then
			v.angle = v.angle-2*math.pi
		end
	
	if(v.autop < 0)
		then
			v.autop = v.autop+2*math.pi
		end
	if(v.autop > 2*math.pi)
		then
			v.autop = v.autop-2*math.pi
		end
	
	errormsg=errormsg..(math.floor(v.autop*100))/100
	errormsg=errormsg.."@"
	errormsg=errormsg..(math.floor(v.angle*100))/100
	
	else
	errormsg=errormsg.."AP WORKI\n now "..((math.floor(v.angle*100))/100).."\n to "..((math.floor(v.autop*100))/100)
	
		if( math.abs(math.abs(v.angle) - math.abs(v.autop)) < 0.1 ) then
			errormsg=errormsg.."\n    0.1 limit -- "..math.floor(math.abs(math.abs(v.angle) - math.abs(v.autop))*100)/100 
			v.autop = nil errormsg=errormsg..'turn!'
			--love.timer.sleep(1000)
		elseif(v.angle > v.autop  ) then
			v.angle = v.angle - 0.1  errormsg=errormsg..'>'	
		else--if (v.angle < v.autop ) then
			v.angle = v.angle + 0.1  errormsg=errormsg..'<'	
		
		end
	
	end
		--love.timer.sleep(100)
	
	return 0
end