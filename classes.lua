require 'classlib.lua'

class.player()
function player:__init()
	self.pic = love.graphics.newImage('ship.png')
	self.wx = 0;
	self.wy = 0;
	self.ox = 300;
	self.oy = 240;
	
end

function player:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.print("ZAVR IN FIELD",10,10)
	
	
	love.graphics.draw(self.pic,self.ox,self.oy,self.angle,1,1,32,32)
end

function player:update(dt)
end

function player:fly()
end

class.ship()

function ship:__init()
end

function ship:update()
end

function ship:modify()
end

function ship:ship()
end

npcs = {}

function npcs:update(dt)
end

function npcs:draw()
end

class.npc()


function npc:__init()
end

function npc:die()
end

function npc:update(dt)
end

function npc:draw()
end


class.world()

function world:__init()
end

function world:update(dt)
end

function world:draw()
end

function world:map()
end

class.quest()

function quest:__init()
end

function quest:qend()
end

function quest:check()
end

function quest:draw()
end
