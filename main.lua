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
local words = {"tom","cat","max","dog","math","fin"} --слова--
local game = display.newGroup();
local face = display.newGroup();
local misses = 0;
local misstxt = display.newText(face,"Hellow world",W/2,30,nil,20)

function refresh()
	misstxt.text = misses;
end

function getWord()
	local id = math.random(1,#words)
	return words[id];
end
----Добовление гоблинов----
function addEnemy()
	local mc = display.newGroup();
	local unit = require("objUnit").new("goblin_shaman",1,1)
	mc.s = math.random(1,5);
	mc:insert(unit);
	mc.body = unit;
	unit:setDir(100,0);
	unit:setAct("go");
	mc.y = math.random(1,#words)*H/#words - H/10;
-----------------------Добовление текста на экран---------
	local word = getWord();
	mc.word = word;
	local dtxt = display.newText(mc,word,0,0,nil,30);
--------------------------------------------------
	table.insert(enemies,mc)
end;
-----------движение гоблинов---------------
Runtime:addEventListener("enterFrame",function()
	if(#enemies<2)then
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
				mc.body:setAct("death");
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
		local word = table.concat(keys,'')
		for i=#enemies,1,-1 do
			local mc = enemies[i];
			if (mc.word==word)then
				mc.body:setAct("death");
				table.remove(enemies,i);
				keys = {};
				break;
			end;
		end;
	end;
end)