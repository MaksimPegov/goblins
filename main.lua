-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- Подключаем библиотеку
_G.game_art = require("majestyArt").new();
game_art:loadDecor();
game_art:loadDeltas();
-------------------------------------------
W = display.contentWidth;
H = display.contentHeight;

local enemies = {};
local words = {"tom","cat","max","dog","math","fin","uly","mops","sip","lox","nub"} --слова--
local game = display.newGroup();
local face = display.newGroup();
local misses = 0;
local misstxt = display.newText(face,"Hellow world",W/2,30,nil,20)
local hits = 0;
local hitstxt = display.newText(face,"hits",W/2,50,nil,20)
local enemies_max = 1

function refresh()
	misstxt.text = misses;
	hitstxt.text = hits;
end

function getWord()
	local ttl = 30
	local word = "1234567890"
	while((word:len() > enemies_max + 2 or word:len() < enemies_max) and ttl > 0) do
		local id = math.random(1,#words)
		word = words[id];
		ttl = ttl - 1;
	end;
	return word;
end
----Добовление гоблинов----
function addEnemy()
	local ty = math.random(1,#words)*H/#words - H/10;
	local mc = display.newGroup();
	local unit = require("objUnit").new("goblin_shaman",1,1)
	for i=1,#enemies do
		local ei = enemies[i];
		local dx = ei.x - 0;
		local dy = ei.y - ty
		local dd = dx * dx + dx * dx
		if(dd < H*H/25)then
			return;
		end;
	end
	mc.s = math.random(1,5);
	mc:insert(unit);
	mc.body = unit;
	unit:setDir(100,0);
	unit:setAct("go");
	mc.y = ty;

-----------------------Добовление текста на экран и гоблинов---------
	local word = getWord();
	mc.word = word;
	local dtxt = display.newText(mc,word,0,0,nil,30);
	function mc:doDeath()
		mc.body:setAct("death");
		dtxt:setTextColor(1,0,0);
		transition.to(dtxt,{time = 2000,y = dtxt.y-100,alpha = 0});
	end
	dtxt.y = -30;
	mc.dtxt = dtxt;
--------------------------------------------------
	table.insert(enemies,mc)
end;
-----------движение гоблинов---------------
Runtime:addEventListener("enterFrame",function()
	if(#enemies<enemies_max)then
		addEnemy();
	end;
	------ трупавозка -------	
	for i =#enemies, 1, -1 do 
		local mc = enemies[i];
		if(mc.dead)then
			if(mc.body:spritePlaying() == false) then
				mc:removeSelf();
				table.remove(enemies,i);
			end;
		end;
	end
	------ игровая логика ---
	for i = #enemies,1,-1 do
		local mc =enemies[i];
		if(mc.dead ~= true)then
				mc.x = mc.x + mc.s;
			if(mc.x > W) then
				misses = misses + 1;
				refresh();
				--mc.body:setAct("death");
				mc:doDeath();
				mc.dead = true;
			end;
		end;
	end;
end);

local keys = {};

Runtime:addEventListener('key', function (event)
	if(event.phase=="down")then
		table.insert(keys,event.keyName);
		print(event.phase, event.keyName,table.concat(keys,""));
		for j=#keys,1,-1 do
			local word = table.concat(keys,"",j,#keys)
			for i=#enemies,1,-1 do
				local mc = enemies[i];
				if (mc.word==word)then
					--mc.body:setAct("death");
					mc:doDeath();
					hits = hits + 1;
					if(hits >= 5 + 5 * enemies_max)then
						enemies_max = enemies_max + 1;
					end;
					refresh();
					table.remove(enemies,i);
					keys = {};
					break;
				end;
			end;
		end;
	end;
end)