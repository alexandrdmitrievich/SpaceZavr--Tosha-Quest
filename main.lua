require 'func.lua'
require 'drfunc.lua'
require 'quests.lua'

thetable={} -- все объекты они просто летают
bullets ={} -- все снаряды они убивают
large   ={} -- все БОЛЬШИЕ объекты. Планетки, станции и прочее. С ними можно будет взаимодействовать.
items ={} -- магазин
inventory = {}
item = 1; -- выбраная вещь

zavr = 1; -- номер в который записан игрок, для простаты
money= 1000; -- деньги 

game_state='' -- действие

errormsg='' -- для отладки


AIstep = 0; -- ии будет думать не каждый день :3


fps = 100; -- для счетчика фпс

-- алиасы:
kb = love.keyboard;
gr = love.graphics;

-- просто глобальная переменная
-- вообще надо сделать фон двухслойным
wrldbk = gr.newImage('stars.png')
title = gr.newImage('title_screen.gif')


function love.load()
	
	game_state='menu'
	
-- установка режима ОКНА
	love.graphics.setMode(800, 480)	
	love.graphics.setIcon(love.graphics.newImage('ship.png'))
	love.graphics.setCaption("SPACEZAVR! Tosha Quest")
	
-- добавление игрока в мир
-- переделать через add или нафиг? потом решу
	table.insert(thetable,zavr,{class='player',wx=0,wy=0,ox=400,oy=240,angle=0,speed=0,speedup=0,pic=love.graphics.newImage('ship.png'),alive=1,hp=100,reload=0})
-- забивание магазина
-- сделать загрузку из файла
	table.insert(items,{name='Cargo',cost=100,quant=9999,have=0})
	table.insert(items,{name='Boxes',cost=200,quant=9999,have=0})
	table.insert(items,{name='Litters',cost=10.2,quant=9999,have=0})
	table.insert(items,{name='Razors',cost=3576,quant=9999,have=0})
	table.insert(items,{name='Need more targets',cost=1,quant=9999,have=0})
-- добавление в мир другого добра
-- сделать динамическое появление
-- карго летят от станции к станции
-- астеройды в поясе, никуда не летят, просто крутятся
-- домики деревянные
--	add('cargo',0,0,0,1)
	add('cargo',75,75,2,5)
	--add('cargo',75,-75,0.75,5)
	add('cargo',-75,75,-2,5)
	--add('cargo',-75,-75,-0.75,5)
	
	--add('cargo',175,175,2,3)
	--add('cargo',175,-175,0.75,3)
	--add('cargo',-175,175,-2,3)
	--add('cargo',-175,-175,-0.75,3)
	
	add('asteroid',100,0,0,0)
	add('asteroid',145,0,0,0)
	add('asteroid',190,0,0,0)
	--add('asteroid')
	
	new_quest(0,-1000,1,1,{4,5,6},{zavr})
	
	table.insert(large,{name='Muramasa',wx=0,wy=-1000,class='planet',pic=gr.newImage('planet-1.png')})
end

function love.update(dt)

if(game_state=="space") then
-- обновление состояния объектовы
	table.foreach(thetable, function(k,v) updater(v,k) end)
	table.foreach(bullets, function(k,v) bul(v,k) end)
	
	check_quests()
	
	if(thetable[zavr].speedup<0.01 and thetable[zavr].speedup > -0.01) then
	thetable[zavr].speedup = 0; -- убийца погрешности вычислений
	end
	
	fps = love.timer.getFPS();
	thetable[zavr].reload = thetable[zavr].reload +1;
	AIstep = AIstep +1;
	if(AIstep > 15) then AIstep = 0; end
-- управление играка	
	if kb.isDown('up') then
		thetable[zavr].speedup=thetable[zavr].speedup+0.01
	end
	if kb.isDown('down') then
		thetable[zavr].speedup=thetable[zavr].speedup-0.01
	end
	if kb.isDown('left') then
		thetable[zavr].angle=thetable[zavr].angle-0.1
	end
	if kb.isDown('right') then
		thetable[zavr].angle=thetable[zavr].angle+0.1
	end
	
	if kb.isDown(' ') then 
		-- lazor!
	if(thetable[zavr].reload >= 4) then
		table.insert(bullets,{class='shot',ox=1, oy = 1, wx=thetable[zavr].wx+math.sin(thetable[zavr].angle)*32, wy = thetable[zavr].wy - math.cos(thetable[zavr].angle)*32, angle = thetable[zavr].angle, speed = thetable[zavr].speed+2, pic = gr.newImage('shot.png'), creation = dt, ttl = 2000, parent = thetable[zavr].class, alive = 1})
	--	thetable[zavr].speed=thetable[zavr].speed - 0.01
	thetable[zavr].reload = 0;
	end
	end
	
	
	
	
elseif (game_state=="menu") then
	if kb.isDown(' ','return') then 
		game_state = 'pause'
	end
	if kb.isDown('escape') then 
		love.event.push('q')
	end
	
	
elseif (game_state=="pause") then
	
	
	
elseif (game_state=="shop") then
	if kb.isDown('down') then
		item = item +1
		if item > table.getn(items) then
		item = 1
		end
		love.timer.sleep(100)
	end
	if kb.isDown('up') then
		item = item -1
		if item < 1 then
		item =  table.getn(items)
		end
		love.timer.sleep(100)
	end
	
elseif (game_state=="dialog") then
elseif (game_state=="quest") then
end
end

function love.keypressed() ---------------------- обработка тех нажатий где не нужны или даже вредны зажатия кнопки 
if(game_state=="space") then

	if(kb.isDown('return')) then 
		interact()
	end
	
	
	if kb.isDown('escape') then -- перетащить в love.keypressed?
		love.event.push('q')
	end
	
	if kb.isDown('1','P') then -- // --
		--game_state = "pause"
		love.timer.sleep(2000)
	end
	
elseif (game_state=="menu") then
	
elseif (game_state=="pause") then
	if kb.isDown('1','return','P','escape') then 
		game_state = "space"
		--love.timer.sleep(1000)
	end
elseif (game_state=="shop") then
	if kb.isDown(' ')then
		if(money >= items[item].cost and items[item].quant > 0) then
			 items[item].quant =  items[item].quant-1
			 items[item].have = items[item].have+1
			 money = money - items[item].cost
			 if( items[item].name == "Need more targets") then
			 	add("cargo",math.random(4048)-2024,math.random(4048)-2024,0,1)
			 end
			 
		end
	end
	if kb.isDown('escape') then
	game_state="space"
	end
elseif (game_state=="dialog") then
elseif (game_state=="quest") then
end
end

function love.draw()

	gr.print(fps..'FPS',760,0);

if(game_state=="space")  then	
	
	worlddraw() -- отрисовка фона
	
	drawlarge() -- отричсовка больших объектов
	
	
	drawships() -- отрисовка объектов
	
	
	drawbullets() -- пули
		
	hud() -- интерфейс
	radar() -- радар
	
	gr.print(errormsg,100,100) -- отладочная информация
	errormsg=''
elseif (game_state=="menu") then
	gr.draw(title)
elseif (game_state=="pause") then
	gr.print("PAUSE",100,100)
	gr.print("arrows for movement",100,110);
	gr.print("space for shooting",100,120);
	gr.print("return for interact",100,130);
	-- добавить анекдотов
elseif (game_state=="shop") then
	--gr.print(errormsg,100,100)
	shop()
elseif (game_state=="dialog") then
elseif (game_state=="quest") then
end
end

