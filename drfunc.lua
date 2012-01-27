-----------
-- ??????????? ???????
---------

function shop()
	local x = 25
	local y = 150
	
	gr.setColor(240,240,240)
	gr.print("Shop",200,100);
	table.foreach(items, function(k,v) if(k==item) then gr.setColor(0x90,0x90,0x30) else gr.setColor(255,255,255) end gr.print('#'..k..' '..v.name.." $"..v.cost.."["..v.quant.."]",x+2,y+2) gr.rectangle('line',x,y,150,25) y=y+30 if y > 400 then y=150 x=x+175 end  end)
end


function worlddraw()
	local nx = thetable[zavr].wx-thetable[zavr].ox
	local ny = thetable[zavr].wy-thetable[zavr].oy
	
	local anx = (math.floor((nx)/128)*128)-thetable[zavr].wx
	local any = (math.floor((ny)/128)*128)-thetable[zavr].wy
	
	local i,j
	
	--gr.print("anx "..anx.." any "..any,10,10)
	
	for i=4,10 do -- ???????? ????? ?? Quad
		for j=2,6 do
		gr.draw(wrldbk,anx+i*128,any+j*128,0,1,1,64,64)
	end
	end
end

function hud ()
	local zvr = thetable[zavr];
	local metr= gr.newImage('hud.png');
	
	gr.draw(metr,0,480,0,1,1,0,64)
	
	gr.line(5,475,5+50*math.sin(0.75),475-50*math.cos(0.75))
	gr.setColor(255,0,0)
	gr.line(5,475,5+50*math.sin(zvr.speed/10+0.75),475-50*math.cos(zvr.speed/10+0.75))
	gr.setColor(0x90,0xEE,0x90)
	gr.line(5,475,5+50*math.sin(zvr.speedup*7+0.75),475-50*math.cos(zvr.speedup*7+0.75))
	gr.setColor(255,255,255)
	
	gr.draw(gr.newImage('shot.png'),70,475,0,3,3,4,4)
end


function radar()
	local x,y
	local zvr = thetable[zavr]
	gr.setPointSize(4);
	gr.setColor(0,0,1,128)
	gr.circle("fill",736,64,64)
	gr.setColor(0,255,0)
	for i=0,4 do
		gr.circle("line",736,64,16*i)
	end
	
	gr.print(math.floor(zvr.wx)..":"..math.floor(zvr.wy),700,128)
	
	table.foreach(thetable,function(k,v) 
		
		if(v.class=='cargo') then
			gr.setColor(200,128,200)
		elseif(v.class=='asteroid') then
			gr.setColor(255,0,0)
		else 
			gr.setColor(255,0,255)
		end
		
		if(v.alive==1 and (math.sqrt((((v.wx - zvr.wx)^2) + ((v.wy - zvr.wy)^2)))<16*4*16)) then
			gr.point(((v.wx-zvr.wx)/16+736),((v.wy-zvr.wy)/16+64))
		end
	end)
	
	
	
	gr.setPointSize(8);
	gr.setColor(0x00,0xBF,0xFF)
	table.foreach(large,function(k,v) 
		if((math.sqrt((((v.wx - zvr.wx)^2) + ((v.wy - zvr.wy)^2)))<16*4*16)) then
			gr.point(((v.wx-zvr.wx)/16+736),((v.wy-zvr.wy)/16+64))
		end
	end)
	
	
	
	gr.setColor(255,255,255)
	gr.setPointSize(4);
	gr.point(736,64)
	gr.setPointSize(1);
end


function drawlarge()
	table.foreach(large,function(k,v) gr.draw(v.pic,v.wx-thetable[zavr].wx+thetable[zavr].ox,v.wy-thetable[zavr].wy+thetable[zavr].oy,0,1,1,v.pic:getHeight()/2,v.pic:getWidth()/2) end)
end

function drawships()
	table.foreach(thetable, function(k,v) if(v.alive == 1) then gr.draw(v.pic,v.ox,v.oy,v.angle,1,1,v.pic:getHeight()/2,v.pic:getWidth()/2)
	-- gr.print(math.floor(v.wx)..":"..math.floor(v.wy)..":"..v.angle..":",v.ox,v.oy+34)
	  end end) -- ????????? ????????
end

function drawbullets()
	
	table.foreach(bullets, function(k,v) if(v.alive==1) then gr.draw(v.pic, v.ox, v.oy, v.angle,1,1,4,4) end end)
	

end