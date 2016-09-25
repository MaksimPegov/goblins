module(..., package.seeall);

sides={}
table.insert(sides,'nw');
table.insert(sides,'w');
table.insert(sides,'sw');
table.insert(sides,'s');
table.insert(sides,'se');
table.insert(sides,'e');
table.insert(sides,'ne');
table.insert(sides,'n');
table.insert(sides,'nw');



function new()

	if(_G.scaleGraphics==nil)then _G.scaleGraphics=2; end
	if(_G.options_txt_offset==nil)then _G.options_txt_offset=0; end

	function _G.add_title(txt, sscale)
		if(sscale==nil)then sscale = 4; end
		local mc = display.newGroup();
		local b_c=display.newImage(mc, "image/gui/bar_title_m.png");
		b_c.xScale, b_c.yScale = scaleGraphics*sscale/2, scaleGraphics/2;
		b_c.x,b_c.y = 0,0;

		local b_l=display.newImage(mc, "image/gui/bar_title_l.png");
		b_l.xScale, b_l.yScale = scaleGraphics/2, scaleGraphics/2;
		b_l.x,b_l.y = -(b_c.width*b_c.xScale + b_l.width*b_l.xScale)/2,0;
		local b_r=display.newImage(mc, "image/gui/bar_title_l.png");
		b_r.xScale, b_r.yScale = -scaleGraphics/2, scaleGraphics/2;
		b_r.x,b_r.y = (b_c.width*b_c.xScale - b_r.width*b_r.xScale)/2,0;
		
		local dtxt=display.newText(mc, txt,0, 0, fontMain, math.floor(11*scaleGraphics));
		dtxt.x,dtxt.y = 0,1*scaleGraphics;
		mc.dtxt = dtxt;
		return mc
	end

	function _G.add_bg(utype, tw, th, fill)
			tw = math.floor(tw);
			th = math.floor(th);
			local mc =  display.newGroup();
			mc.w, mc.h = tw,th;
			mc.x = tw/2;
			mc.y = th/2;

			local top = display.newImage("image/gui/"..utype.."_m.png");
			mc.bw = top.height;
			mc.bh = top.height;
			
			tw = tw - top.height*2;
			th = th - top.height*2;
			top:removeSelf();

			local parts = math.floor(tw/32);
			parts = math.max(1, parts);
			
			
			
			if(tw>0)then
				for i=1,parts do
					local top = display.newImage("image/gui/"..utype.."_m.png");
					top.x, top.y = (i-0.5-parts/2)*(tw)/(parts), -th/2-top.height/2;
					top.xScale, top.yScale = tw/(top.width*parts),1;
					mc:insert(top);
				end
				for i=1,parts do
					local bot = display.newImage("image/gui/"..utype.."_m.png");
					bot.x, bot.y = (i-0.5-parts/2)*(tw)/(parts), th/2+bot.height/2;
					bot.xScale, bot.yScale = tw/(bot.width*parts),-1;
					mc:insert(bot);
				end
			end
			
			local parts = math.floor(th/32);
			parts = math.max(1, parts);
			if(th>0)then
				for i=1,parts do
					local left = display.newImage("image/gui/"..utype.."_m.png");
					left.x, left.y = -tw/2-left.height/2, (i-0.5-parts/2)*(th)/(parts);
					left.xScale, left.yScale =  th/(left.width*parts), 1;
					left.rotation = -90;
					mc:insert(left);
				end
				for i=1,parts do
					local right = display.newImage("image/gui/"..utype.."_m.png");
					right.x, right.y = tw/2+right.height/2, (i-0.5-parts/2)*(th)/(parts);
					right.xScale, right.yScale =  th/(right.width*parts), 1;
					right.rotation = 90;
					mc:insert(right);
				end
			end
			
			local tl = display.newImage("image/gui/"..utype.."_c.png");
			tl.x = -(tw/2+tl.width/2);
			tl.y = -(th/2+tl.height/2);
			mc:insert(tl);
			local tr = display.newImage("image/gui/"..utype.."_c.png");
			tr.xScale = -1;
			tr.x = (tw/2+tr.width/2);
			tr.y = -(th/2+tr.height/2);
			mc:insert(tr);
			
			local bl = display.newImage("image/gui/"..utype.."_c.png");
			bl.yScale = -1;
			bl.x = -(tw/2+bl.width/2);
			bl.y = (th/2+bl.height/2);
			mc:insert(bl);
			local br = display.newImage("image/gui/"..utype.."_c.png");
			br.xScale = -1;
			br.yScale = -1;
			br.x = (tw/2+br.width/2);
			br.y = (th/2+br.height/2);
			mc:insert(br);
			
		if(fill)then
			local bg_fill = display.newRect(mc, 0, 0, tw-mc.bw*0, th-mc.bh*0);
			bg_fill:setFillColor(0, 0, 0);
			bg_fill.x,bg_fill.y = 0,0;
		end
			
		return mc;
	end
	function _G.add_bg_title(utype, tw, th, txt, sscale)
		local mc = add_bg(utype, tw, th)

		local bg_fill = display.newRect(mc, 0, 0, tw-mc.bw, th-mc.bh);
		bg_fill:setFillColor(0, 0, 0);
		bg_fill.x,bg_fill.y = 0,0;

		if(txt~=nil and txt~='')then
			local title = add_title(txt, sscale);
			title.x, title.y = 0, -mc.h/2-1.5*scaleGraphics + options_txt_offset;
			mc.dtxt = title.dtxt;
			mc:insert(title);
		end
		return mc;
	end
	
	function _G.addGfxEx(tar, _x, _y, _id, scale)
		if(_x == nil or _y == nil)then
			print('addgfx - out of bounds', _x, _y, _id)
			return false;
		end
		if(scale==nil)then
			scale=1;
		end
		local item_obj = game_art.links[_id];
		local mc = display.newSprite(item_obj.image, item_obj.sequences);
		mc.xScale, mc.yScale = scale,scale;
		mc:setSequence(item_obj.id);
		mc:play();
		mc.x, mc.y = _x, _y;
		
		if(item_obj.xfix)then
			mc.x = mc.x + item_obj.xfix*scale;
		end
		if(item_obj.yfix)then
			mc.y = mc.y + item_obj.yfix*scale;
		end
		tar:insert(mc);
		return mc;
	end

	local ani_speed = 60;
	
	local art = {};

	art.sets = {};
	art.list = {};
	art.links = {};
	art.decors = {};
	art.deltas = {};
	
	local sets_l = 0;
	
	function _G.string_split(str, pat)
		--table.concat(untranslated_words, "\r")
	   local t = {};  -- NOTE: use {n = 0} in Lua-5.0
	   local fpat = "(.-)" .. pat;
	   local last_end = 1
	   local s, e, cap = str:find(fpat, 1)
	   while s do
		  if s ~= 1 or cap ~= "" then
		 table.insert(t,cap)
		  end
		  last_end = e+1
		  s, e, cap = str:find(fpat, last_end)
	   end
	   if last_end <= #str then
		  cap = str:sub(last_end)
		  table.insert(t, cap)
	   end
	   return t
	end

	function crop_set_name(set_name,txt)
		txt = string_split(txt,'[\\/]+')[1]
		return string_split(txt,set_name..'_')[1];
	end
	function check_move(txt)
		local txt_obj = string_split(txt,'_');
		if(txt_obj[1]=='go' or txt_obj[1]=='going')then
			return 0;
		else
			return 1;
		end
	end
	function check_etxt(txt, tar_txt)
		local txt_obj = string_split(txt,'_');
		if(txt_obj[1]==tar_txt)then
			return true;
		else
			return false;
		end
	end
	

	
	local function check_flyers(set_name) -- ones that fly instead of reloading
		return (set_name=="airgolem" or set_name=="airbow" or set_name=="airbow_blue" or set_name=="airsword" or set_name=="dragon" or set_name=="genie");
	end

	local units_ani_speed = 90;
	function add(set_obj, set_name, last_set, set_start, set_l)
		local last_set_obj = string_split(last_set,'_');
		table.remove(last_set_obj, #last_set_obj)
		local group_id=table.concat(last_set_obj,"_");
		if(group_id=='super_attack' or last_set=='super_attack')then
			set_obj.super_attack = true;
		end
		if(group_id=='muz' or last_set=='muz')then
			set_obj.muzic = true;
		end
		
		local sequenceData = {};
		sequenceData.name=last_set;
		sequenceData.start=set_start;
		sequenceData.count=set_l;
		if(check_etxt(last_set, "pause"))then
			sequenceData.time=units_ani_speed*set_l*1.9;	
		else
			sequenceData.time=units_ani_speed*set_l;	
		end
		sequenceData.loopCount = check_move(last_set);
		--set_obj.sequences[last_set] = sequenceData;
		table.insert(set_obj.sequences, sequenceData);

		if(set_name=="medusa" or set_name=="mermaid")then--medusa reloading as go first frame
			if(check_etxt(last_set, "go"))then
				local txt_obj = string_split(last_set, '_');
				txt_obj[1] = "reload";
				local new_set_name = table.concat(txt_obj, "_");
				local sequenceData = {};
				sequenceData.name=new_set_name;
				sequenceData.start=set_start;
				sequenceData.count=1;
				sequenceData.time=units_ani_speed;	
				sequenceData.loopCount = check_move(last_set);
				table.insert(set_obj.sequences, sequenceData);
			end
		elseif(check_flyers(set_name))then
			if(check_etxt(last_set, "idle"))then
				local txt_obj = string_split(last_set, '_');
				txt_obj[1] = "reload";
				local new_set_name = table.concat(txt_obj, "_");
				local sequenceData = {};
				sequenceData.name=new_set_name;
				sequenceData.start=set_start;
				sequenceData.count=set_l;
				sequenceData.time=units_ani_speed*set_l;	
				sequenceData.loopCount=0;
				table.insert(set_obj.sequences, sequenceData);
			end
		else
			if(last_set ~= 'attack')then--all units reloading as first attack frame, except ones with universal attack
				if(check_etxt(last_set, "attack"))then
					local txt_obj = string_split(last_set, '_');
					txt_obj[1] = "reload";
					local new_set_name = table.concat(txt_obj, "_");
					local sequenceData = {};
					sequenceData.name=new_set_name;
					sequenceData.start=set_start;
					sequenceData.count=1;
					sequenceData.time=units_ani_speed;	
					sequenceData.loopCount = check_move(last_set);
					table.insert(set_obj.sequences, sequenceData);
				end
			end
		end
		
		if(last_set=='attack' or last_set=='muz' or last_set=='super_attack' or last_set=='death' or last_set=='go' 
		or last_set=='mutationin' or last_set=='mutationout' or last_set=='start' or last_set=='stop' or last_set=='going' or last_set=='fly')then
			for i=1,#sides do
				local sequenceData = {};
				sequenceData.name=last_set.."_"..sides[i];
				sequenceData.start=set_start;
				sequenceData.count=set_l;
				sequenceData.time=units_ani_speed*set_l;	
				sequenceData.loopCount = check_move(last_set);
				--set_obj.sequences[last_set] = sequenceData;
				table.insert(set_obj.sequences, sequenceData);
			end
		end
			
		if(check_etxt(last_set, "death"))then
			local txt_obj = string_split(last_set, '_');
			txt_obj[1] = "deathbody";
			local new_set_name = table.concat(txt_obj, "_");
			--sprite.add(sprite_set, new_set_name, set_start+set_l-1, 1, 100, 1);
		end
	end
	
	--local tasks = {};
	function art:setCloneAni(set_name, original_name, cloned_name)
		local set_obj = art.sets[set_name];
		--set_obj.sequences, sequenceData
		print("_setCloneAni:", #set_obj.sequences, original_name, cloned_name);
		for i=1,#set_obj.sequences do
			local sequenceData = set_obj.sequences[i];
			local last_set = sequenceData.name;
			
			if(check_etxt(last_set, original_name))then
				local txt_obj = string_split(last_set, '_');
				txt_obj[1] = cloned_name;
				local new_set_name = table.concat(txt_obj, "_");
				
				print("__setCloneAni:", #set_obj.sequences, last_set, new_set_name);
				
				local sequenceDataNew = {};
				sequenceDataNew.name=new_set_name;
				sequenceDataNew.start=sequenceData.start;
				sequenceDataNew.count=sequenceData.count;
				sequenceDataNew.time=sequenceData.time;	
				sequenceDataNew.loopCount = sequenceData.loopCount;
				table.insert(set_obj.sequences, sequenceDataNew);
			end
		end
	end
	function art:releaseArt()
		for i=1,#art.list do
			local set_obj = art.list[i];
			if(set_obj.image)then
				set_obj.image = nil;
				set_obj.loading = nil;
			end
		end
	end
	
	function art:loadData(set_name)
		local set_obj = art.sets[set_name];
		
		local sheetInfo = require('image.units.'..set_name);
		local data = sheetInfo:getSheet();
		
		local fname = 'image/units/'..set_name..".png";
		local file_name_arr = string_split(fname, "/");
		local file_name = table.concat(file_name_arr, "_");
		set_obj.image = graphics.newImageSheet(fname, data);
		if(set_obj.image == nil)then
			set_obj.image = graphics.newImageSheet(file_name, system.DocumentsDirectory, data);
		end
		if(set_obj.image == nil)then
			if(_G.loaded_images==nil)then _G.loaded_images={}; end
			print(file_name, _G.loaded_images[file_name]);
			if(_G.loaded_images[file_name] == -1 or _G.loaded_images[file_name] == 0 or _G.loaded_images[file_name] == 1)then

			else
				local function networkListener( event )
					if ( event.isError ) then
						print( "Network error - download failed" );
					elseif ( event.phase == "ended" ) then
						set_obj.loading = true;
						--print( "Displaying response image file" );
						print("_loaded:", file_name, event.response.filename, event.response.baseDirectory);
						if(event.response.filename == nil)then
							_G.loaded_images[file_name] = -1;
						else
							_G.loaded_images[file_name] = 1;
						end
						set_obj.image = graphics.newImageSheet(file_name, system.DocumentsDirectory, data);
					end
				end
				_G.loaded_images[file_name] = 0;
				print("_loading:", file_name);
				network.download(
					"http://theelitegames.net/royalheroes/"..fname,
					"GET",
					networkListener,
					{},
					file_name,
					system.DocumentsDirectory
				)
			end
		end
		--print("_set_obj.image:", set_obj.image);
		
		if(set_obj.data_parsed)then
			return
		end
		
		if(#set_obj.sequences<1)then
			for key,value in pairs(sheetInfo.frameIndex) do
				data.frames[value].name = key;
			end
			
			local next_set = nil;
			local last_set = nil;
			local new_set = false;
			local set_l = 0;
			local set_start = 0;
			
			for i=1,#data.frames do
				new_set = false;
				local frame_name = data.frames[i].name;
				next_set = crop_set_name(set_name,frame_name);
				if(next_set ~= last_set)then
					if(last_set)then
						add(set_obj, set_name, last_set, set_start, set_l);
					end
					new_set = true;
					set_start = i;
					last_set = next_set;
					set_l =0;
				end
				set_l = set_l +1;
			end
			if(last_set)then
				add(set_obj, set_name, last_set, set_start, set_l);
			end
		end
		
		if(set_name == "mag_evil")then
			art:setCloneAni("mag_evil","idle","pause");
		end
		
		set_obj.data_parsed = true;
		--show_msg(get_txt(set_name)..' loaded.')
	end
	
	local UNIT_SMALL_SIZE = 16;
	local UNIT_STANDART_SIZE=20;
	
	local RANGE_MEELE = 30;
	local RANGE_MAGIC = 180;
	local RANGE_ARROW = 210;
	
	local SPEED_MEGA_SLOW = 6;
	local SPEED_VERY_SLOW = 8;
	local SPEED_SLOW = 10;
	local SPEED_NORMAL = 12;
	local SPEED_FAST = 14;
	local SPEED_VERY_FAST = 16;
	
	function iniSet(set_name)
		sets_l = sets_l +1;
		
		local set_obj = {}
		set_obj.sequences = {};
		set_obj.id = set_name;
		set_obj.sprite_id = set_name;
		
		set_obj.dmg = 0;
		set_obj.chain = 1;
		set_obj.dmg_type = DAMAGE_TYPE_PHYSIC;
		set_obj.lvl=1;
		set_obj.align=ALIGN_NEIT;
		set_obj.r = UNIT_SMALL_SIZE;
		set_obj.s = SPEED_SLOW;
		set_obj.col_r=UNIT_SMALL_SIZE;
		set_obj.hp = 100;
		set_obj.cost = 10;
		set_obj.weapon_type="monster_stuff";
		set_obj.armor_type="monster_def";
		set_obj.sex = 1;
		set_obj.shadow = 'shadow_mid';--unit.shadow = 'shadow_mid';
		
		set_obj.dmg_crit_c=0;
		set_obj.dmg_crit_v=150;
		set_obj.stun_c = 0;
		set_obj.stun_v = 2000;
		set_obj.armorreducion = 0;
		
		set_obj.lvl = 0;
		set_obj.aoe = 0;
		set_obj.finisher = 0;--extra % to units under 50%
		set_obj.magic_dmg = 0;--extra magic dmg
		set_obj.true_dmg=0;
		set_obj.vamp = 0;
		set_obj.destroyer = 100;--damage to building
		set_obj.giant_slayer = 1; --100% damage to giants
		set_obj.limit = 0;
		set_obj.house = '';
		set_obj.limit_per_house = 5;
		set_obj.regen = 0;
		set_obj.h = 50;
		set_obj.mana = 0;
		set_obj.poison_power = 0;
		set_obj.healing = 100;
		set_obj.armor = 0;
		set_obj.dodge = 0;
		set_obj.block = 0;
		set_obj.resist = 0;
		set_obj.survival = false; -- if unit should die - he ll tele to castle and lost his survival
		set_obj.repair = 0;
		set_obj.spells = {};
		set_obj.fweapons = {};
		set_obj.addons = {};
		set_obj.class = 0;--0-none, 1-warrior, 2-ranged, 3-mage, 4-creature, 5-healer
		
		set_obj.weapons = 'axe,sword,staff,scythe,spear,bow';
		
		set_obj._passive = false;
		
		art.sets[set_name] = set_obj
		table.insert(art.list, set_obj);
		
		return art.sets[set_name];
	end
	
	local unit_id = 1;
	function setStats(mc,align,lvl,dmg,r,s,hp,col_r,weapon_type,armor_type,cost)
		mc.uid = unit_id;
		mc.dmg = dmg;
		mc.dmg_type = DAMAGE_TYPE_PHYSIC;
		mc.lvl=lvl;
		mc.align=align;
		mc.r = r;
		mc.s = s;
		mc.col_r=col_r;
		mc.hp = hp;
		mc.cost = cost;
		mc.weapon_type=weapon_type;
		mc.armor_type=armor_type;

		unit_id=unit_id+1;
	end
	function setStatsEx(mc,offsetY,scale)
		mc.scale=scale;
	end
	
	local unit;
	
	unit = iniSet("giant_rat");
	setStats(unit, ALIGN_EVIL,0, 14, RANGE_MEELE, SPEED_FAST, 70, UNIT_SMALL_SIZE, "monster_stuff", "monster_def", 400);
	setStatsEx(unit,0,1);
	unit.h = 30;
	unit.dodge = 35;
	unit._rush = true;
	unit._animal = true;
	unit.poison_power = 1;
	
	unit = iniSet("skelet");
	setStats(unit, ALIGN_EVIL,3,30, RANGE_MEELE, SPEED_NORMAL,190,UNIT_STANDART_SIZE,"monster_stuff","monster_def",600);
	setStatsEx(unit,-20,1);
	unit.dodge = 75;
	unit._undead = true;
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("skeletarcher");
	setStats(unit, ALIGN_EVIL, 4, 25, RANGE_ARROW-10, SPEED_NORMAL, 110, UNIT_STANDART_SIZE, "monster_stuff", "monster_def", 300);
	setStatsEx(unit,-20,1);
	unit.dodge = 75;
	unit._undead = true;
	unit.damage_frame = 5;
	unit.bullet_art = "image/bullets/arrow_1.png";
	unit.bullet_speed = 5;
	unit.class = CLASS_RANGER;
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("skeletwarrior");
	setStats(unit, ALIGN_EVIL, 5, 30, RANGE_MEELE, SPEED_NORMAL, 250,UNIT_STANDART_SIZE,"monster_stuff","monster_def",400);
	setStatsEx(unit,-20,1);
	unit.dodge = 75;
	unit._undead = true;
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("zombe");
	setStats(unit, ALIGN_EVIL,2,22, RANGE_MEELE, SPEED_VERY_SLOW,220,UNIT_STANDART_SIZE,"monster_stuff","monster_def",600);
	setStatsEx(unit,-20,1);
	unit._undead = true;
	
	unit = iniSet("spider");
	setStats(unit, ALIGN_EVIL,3,25, RANGE_MEELE, SPEED_FAST, 330, UNIT_STANDART_SIZE, "monster_stuff", "monster_def", 700);
	setStatsEx(unit,-10,1);
	unit.poison_power = 5;
	unit.h = 40;
	unit._hunter = true;
	unit._animal = true;
	
	unit = iniSet("spiderling");
	setStats(unit, ALIGN_EVIL,3,20, RANGE_MEELE, SPEED_VERY_FAST, 260, UNIT_STANDART_SIZE, "monster_stuff", "monster_def", 500);
	setStatsEx(unit,-10,1);
	unit.poison_power = 4;
	unit.h = 30;
	unit._animal = true;
	unit.shadow = 'shadow_big';
	
	unit = iniSet("vampire");
	setStats(unit, ALIGN_EVIL,4, 40, RANGE_MEELE*2, SPEED_NORMAL, 400,UNIT_STANDART_SIZE,"monster_stuff","monster_def", 800);
	setStatsEx(unit,-20,1);
	unit.dmg_type = DAMAGE_TYPE_MAGIC;
	unit.resist = 30;
	unit._undead = true;
	unit.vamp = 50;
	unit.book = 'void';
	
	unit = iniSet("witch");
	setStats(unit, ALIGN_EVIL,10, 110, RANGE_MEELE*1.1, SPEED_NORMAL, 900,UNIT_STANDART_SIZE,"monster_stuff","monster_def", 900);
	setStatsEx(unit,-20,1);
	unit.dmg_type = DAMAGE_TYPE_MAGIC;
	unit.resist = 190;
	unit._undead = true;
	unit.damage_frame = 5;
	unit.vamp = 10;
	unit.aoe = 180;
	unit.mana = 200;
	table.insert(unit.spells , "quake");
	table.insert(unit.spells , "srevive");
	unit.class = CLASS_WIZARD;
	unit.shadow = 'shadow_mid';
	unit.fly = true;
	unit.book = 'void';
	
	unit = iniSet("medusa");
	unit.sex = 0;
	setStatsEx(unit,-20,1);
	setStats(unit, ALIGN_EVIL,6, 32, RANGE_MEELE*1.1, SPEED_FAST, 440,UNIT_STANDART_SIZE,"monster_stuff","monster_def", 1400);
	unit.armor = 15;
	unit.resist = 40;
	unit.block = 10;
	unit.aoe = 360;
	unit._monster = true;
	
	unit = iniSet("mermaid");
	unit.sex = 0;
	setStatsEx(unit,-20,1);
	setStats(unit, ALIGN_EVIL,7, 38, RANGE_MEELE*1.1, SPEED_FAST, 500,UNIT_STANDART_SIZE,"monster_stuff","monster_def", 1500);
	unit.armor = 10;
	unit.resist = 60;
	unit.block = 10;
	unit.aoe = 360;
	unit._monster = true;
	unit.mana = 150;
	unit.book = 'water';
	table.insert(unit.spells , "freeze");
	
	unit = iniSet("garpy");
	unit.sex = 0;
	setStatsEx(unit,-20,1);
	setStats(unit, ALIGN_EVIL,7, 64, RANGE_MEELE*1.5, SPEED_FAST, 460,UNIT_STANDART_SIZE,"monster_stuff","monster_def", 1100);
	unit.dodge = 40;
	unit._rush = true;
	unit._monster = true;
	unit.vamp = 30;
	unit.mana = 100;
	table.insert(unit.spells , "pull");
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("goblin");
	setStats(unit, ALIGN_EVIL,2,25, RANGE_MEELE, SPEED_FAST,180,UNIT_STANDART_SIZE,"monster_stuff","monster_def",500);
	setStatsEx(unit,-20,1);
	unit._hunter = true;
	unit._goblin = true;
	unit.dodge = 10;
	
	unit = iniSet("goblin_sword");
	setStats(unit, ALIGN_EVIL,2,25, RANGE_MEELE, SPEED_FAST,180,UNIT_STANDART_SIZE,"monster_stuff","monster_def",500);
	setStatsEx(unit,-20,1);
	unit._hunter = true;
	unit._goblin = true;
	unit.dodge = 10;
	
	unit = iniSet("goblin_swords");
	setStats(unit, ALIGN_EVIL,3,30, RANGE_MEELE, SPEED_FAST,190,UNIT_STANDART_SIZE,"monster_stuff","monster_def",550);
	setStatsEx(unit,-20,1);
	unit._hunter = true;
	unit._goblin = true;
	unit.dodge = 15;
	unit.dmg_crit_c=10;
	unit.dmg_crit_v=150;
	
	
	unit = iniSet("goblin_axe");
	setStats(unit, ALIGN_EVIL,2,25, RANGE_MEELE, SPEED_FAST,180,UNIT_STANDART_SIZE,"monster_stuff","monster_def",500);
	setStatsEx(unit,-20,1);
	unit._hunter = true;
	unit._goblin = true;
	unit.dodge = 10;
	
	unit = iniSet("goblin_archer");
	setStats(unit, ALIGN_EVIL,3,20, RANGE_ARROW - 5, SPEED_FAST,90,UNIT_STANDART_SIZE,"monster_stuff","monster_def",650);
	setStatsEx(unit,-20,1);
	unit._hunter = true;
	unit._goblin = true;
	unit.dodge = 20;
	unit.damage_frame = 5;
	unit.bullet_art = "image/bullets/arrow_5.png";
	unit.bullet_speed = 5;
	
	unit = iniSet("goblin_sniper");
	setStats(unit, ALIGN_EVIL,3,20, RANGE_ARROW - 5, SPEED_FAST,90,UNIT_STANDART_SIZE,"monster_stuff","monster_def",650);
	setStatsEx(unit,-20,1);
	unit._hunter = true;
	unit._goblin = true;
	unit.dodge = 20;
	unit.damage_frame = 5;
	unit.bullet_art = "image/bullets/arrow_5.png";
	unit.bullet_speed = 5;
	
	unit = iniSet("goblin_shaman");
	setStats(unit, ALIGN_EVIL,4,30, RANGE_MAGIC, SPEED_NORMAL,230,UNIT_STANDART_SIZE,"monster_stuff","monster_def",750);
	setStatsEx(unit,-20,1);
	unit._goblin = true;
	unit.dodge = 5;
	unit.mana = 100;
	table.insert(unit.spells , "sheal");
	table.insert(unit.spells , "meteor");
	unit.book = 'fire';
	
	unit = iniSet("goblin_elder");
	setStats(unit, ALIGN_EVIL,4,30, RANGE_MAGIC, SPEED_NORMAL,230,UNIT_STANDART_SIZE,"monster_stuff","monster_def",750);
	setStatsEx(unit,-20,1);
	unit._goblin = true;
	unit.dodge = 5;
	unit.mana = 100;
	table.insert(unit.spells , "sheal");
	table.insert(unit.spells , "meteor");
	unit.book = 'fire';
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("goblin_warrior");
	setStats(unit, ALIGN_EVIL,5,40, RANGE_MEELE, SPEED_NORMAL,320,UNIT_STANDART_SIZE,"monster_stuff","monster_def",800);
	setStatsEx(unit,-20,1);
	unit._goblin = true;
	unit.armor = 20;
	unit.block = 20;
	
	unit = iniSet("goblin_shield");
	setStats(unit, ALIGN_EVIL,5,40, RANGE_MEELE, SPEED_NORMAL,320,UNIT_STANDART_SIZE,"monster_stuff","monster_def",800);
	setStatsEx(unit,-20,1);
	unit._goblin = true;
	unit.armor = 20;
	unit.block = 20;
	
	unit = iniSet("orc");
	setStats(unit, ALIGN_EVIL,6,50, RANGE_MEELE, SPEED_NORMAL,350,UNIT_STANDART_SIZE,"monster_stuff","monster_def",900);
	setStatsEx(unit,-20,1);
	unit._goblin = true;
	unit.armor = 40;
	
	unit = iniSet("orc_heavy");
	setStats(unit, ALIGN_EVIL,7,60, RANGE_MEELE, SPEED_NORMAL,450,UNIT_STANDART_SIZE,"monster_stuff","monster_def",1000);
	setStatsEx(unit,-20,1);
	unit._goblin = true;
	unit.armor = 60;
	

	unit = iniSet("tax_collector");
	setStats(unit, ALIGN_GOOD, 0, 0, RANGE_MEELE, SPEED_VERY_SLOW, 60, UNIT_STANDART_SIZE, "weapon_meele", "armor_mage", 300);
	unit._passive = true;
	unit._taxman = true;
	unit.reload = 5000;
	unit.limit = 1;
	unit.limit_per_house = 1;
	unit.house = 'castle';
	unit.class = 0;

	
	unit = iniSet("warrior");
	unit.hero = false;
	setStats(unit, ALIGN_GOOD,1, 20, RANGE_MEELE, SPEED_NORMAL,120,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",450);
	unit.armor = 10;
	unit.dodge = 0;
	unit.resist = 0;
	unit.limit = 8;
	unit.limit_per_house = 2;
	unit.house = 'castle';
	unit.class = 1;
	unit.troops = "warrior";
	table.insert(unit.fweapons, "axe");
	table.insert(unit.fweapons, "sword");
	table.insert(unit.addons, "block:10");
	table.insert(unit.addons, "armor:10");
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("warrior_hero");
	setStats(unit, ALIGN_GOOD,1, 20, RANGE_MEELE, SPEED_NORMAL,120,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",450);
	unit.armor = 10;
	unit.dodge = 0;
	unit.resist = 0;
	unit.limit = 8;
	unit.limit_per_house = 2;
	unit.house = 'castle';
	unit.class = 1;
	unit.troops = "warrior";
	table.insert(unit.fweapons, "axe");
	table.insert(unit.fweapons, "sword");
	table.insert(unit.addons, "block:10");
	table.insert(unit.addons, "armor:10");
	unit.shadow = 'shadow_mid';
	--[[
	unit = iniSet("knightmace");
	setStats(unit, ALIGN_GOOD,2, 20, RANGE_MEELE, SPEED_NORMAL,120,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",450);
	unit.armor = 15;
	unit.dodge = 0;
	unit.resist = 0;
	unit.limit = 8;
	unit.limit_per_house = 2;
	unit.house = 'castle';
	unit.class = 1;
	unit.troops = "warrior";
	table.insert(unit.fweapons, "axe");
	table.insert(unit.fweapons, "sword");
	table.insert(unit.addons, "block:10");
	table.insert(unit.addons, "armor:10");
	
	unit = iniSet("knightspear");
	setStats(unit, ALIGN_GOOD,2, 20, RANGE_MEELE+10, SPEED_NORMAL,120,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",450);
	unit.armor = 5;
	unit.dodge = 5;
	unit.resist = 0;
	unit.limit = 8;
	unit.limit_per_house = 2;
	unit.house = 'castle';
	unit.class = 1;
	unit.troops = "warrior";
	table.insert(unit.fweapons, "spear");
	table.insert(unit.fweapons, "sword");
	table.insert(unit.addons, "dodge:10");
	table.insert(unit.addons, "armor:10");
	]]--
	
	unit = iniSet("paladin");
	-- unit.hidden = true;
	unit.sex = 0;
	setStats(unit, ALIGN_GOOD,3, 32, RANGE_MEELE, SPEED_FAST,190,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",1250);
	unit._holy = true;
	unit.armor = 15;
	unit.dodge = 0;
	unit.resist = 10;
	unit.house = 'warrior_guild';
	unit.limit_per_house = 4;
	unit.class = 1;
	unit.troops = "warrior";
	table.insert(unit.fweapons, "sword");
	table.insert(unit.fweapons, "spear");
	table.insert(unit.addons, "block:10");
	table.insert(unit.addons, "stun_c:15");
	table.insert(unit.addons, "armor:20");
	table.insert(unit.addons, "resist:20");
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("warrior_mace");
	setStats(unit, ALIGN_GOOD,3, 32, RANGE_MEELE, SPEED_FAST,190,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",1250);
	unit._holy = true;
	unit.armor = 15;
	unit.dodge = 0;
	unit.resist = 10;
	unit.house = 'warrior_guild';
	unit.limit_per_house = 4;
	unit.class = 1;
	unit.troops = "warrior";
	table.insert(unit.fweapons, "axe");
	table.insert(unit.fweapons, "hammer");
	table.insert(unit.addons, "block:10");
	table.insert(unit.addons, "stun_c:15");
	table.insert(unit.addons, "armor:20");
	table.insert(unit.addons, "resist:20");
	table.insert(unit.addons, "troops_dmg:15");
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("dwarrior");
	setStats(unit, ALIGN_GOOD,4, 30, RANGE_MEELE+10, SPEED_NORMAL,170,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",1100);
	unit.armor = 10;
	unit.dodge = 5;
	unit.resist = 10;
	unit.aoe = 180;
	unit.damage_frame = 7;
	unit.house = 'warrior_guild';
	unit.limit_per_house = 4;
	unit.class = CLASS_WARRIOR;
	unit.troops = "warrior";
	unit.dmg_crit_c=15;
	unit.dmg_crit_v=160;
	table.insert(unit.fweapons, "spear");
	table.insert(unit.fweapons, "scythe");
	table.insert(unit.addons, "armorreducion:5");
	table.insert(unit.addons, "dmg_crit_v:75");
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("dwarriorshadow");
	setStats(unit, ALIGN_GOOD,4, 36, RANGE_MEELE+10, SPEED_NORMAL,160,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",1100);
	unit.armor = 5;
	unit.dodge = 10;
	unit.resist = 20;
	unit.aoe = 180;
	unit.damage_frame = 7;
	unit.house = 'warrior_guild';
	unit.limit_per_house = 4;
	unit.class = CLASS_WARRIOR;
	unit.troops = "warrior";
	unit.dmg_crit_c=20;
	unit.dmg_crit_v=170;
	table.insert(unit.fweapons, "spear");
	table.insert(unit.fweapons, "scythe");
	table.insert(unit.addons, "armorreducion:5");
	table.insert(unit.addons, "dmg_crit_v:75");
	table.insert(unit.addons, "dodge:5");
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("bastard");
	setStats(unit, ALIGN_GOOD,4, 50, RANGE_MEELE, SPEED_FAST, 260,UNIT_STANDART_SIZE,"weapon_meele","armor_no",1000);
	unit.dodge = 15;
	unit.house = 'warrior_guild';
	unit.damage_frame = 5;
	unit.limit_per_house = 4;
	unit.class = 1;
	unit.dmg_crit_c=25;
	unit.dmg_crit_v=175;
	unit.troops = "warrior";
	unit.shadow = 'shadow_mid';
	table.insert(unit.fweapons, "axe");
	table.insert(unit.fweapons, "sword");
	table.insert(unit.addons, "armorreducion:5");
	table.insert(unit.addons, "regenreducion:1");
	table.insert(unit.addons, "dmg_crit_c:5");
	table.insert(unit.addons, "dmg_crit_v:75");
	table.insert(unit.addons, "troops_dmg:15");
	
	unit = iniSet("ranger");
	unit.hero = false;
	setStats(unit, ALIGN_GOOD,1, 16, RANGE_ARROW, SPEED_FAST,85,UNIT_STANDART_SIZE,"weapon_bow","armor_ranger",350);
	unit.armor = 5;
	unit.limit_per_house = 3;
	unit.damage_frame = 5;
	unit.bullet_art = "image/bullets/arrow_1.png";
	unit.bullet_speed = 5;
	unit.class = 2;
	unit.troops = "ranger";
	table.insert(unit.fweapons, "bow");
	unit.shadow = 'shadow_mid';
	table.insert(unit.addons, "dmg:5");
	table.insert(unit.addons, "range:5");
	table.insert(unit.addons, "dodge:5");
	
	unit = iniSet("archer");
	setStats(unit, ALIGN_GOOD,1, 16, RANGE_ARROW, SPEED_FAST,85,UNIT_STANDART_SIZE,"weapon_bow","armor_ranger",350);
	unit.armor = 5;
	unit.limit_per_house = 3;
	unit.damage_frame = 5;
	unit.bullet_art = "image/bullets/arrow_1.png";
	unit.bullet_speed = 5;
	unit.class = 2;
	unit.troops = "ranger";
	table.insert(unit.fweapons, "bow");
	unit.shadow = 'shadow_mid';
	table.insert(unit.addons, "dmg:5");
	table.insert(unit.addons, "range:5");
	table.insert(unit.addons, "dodge:5");
	
	unit = iniSet("mag_blue");
	setStats(unit, ALIGN_GOOD, 2, 14, RANGE_MAGIC, SPEED_SLOW,80,UNIT_STANDART_SIZE,"staff_blue","armor_mage",750);
	unit.unlock = 750;
	unit._holy = true;
	unit.resist = 20;
	unit.house = 'wizard_guild';
	unit.limit = 1;
	unit.limit_per_house = 3;
	unit.damage_frame = 14;
	unit.bullet_speed = 8;
	unit.bullet_art = "image/bullets/bluebolt.png";
	unit.dmg_type = DAMAGE_TYPE_MAGIC;
	unit.mana = 150;
	table.insert(unit.spells , "sheal");
	table.insert(unit.spells , "protect");
	unit.book = 'water';
	unit.class = 5;
	unit.troops = "ranger";
	table.insert(unit.fweapons, "staff");
	
	unit = iniSet("mag_red");
	setStats(unit, ALIGN_GOOD,3, 50, RANGE_MAGIC+5, SPEED_SLOW,80,UNIT_STANDART_SIZE,"staff_red","armor_mage",1500);
	unit.resist = 20;
	unit.house = 'wizard_guild';
	unit.limit_per_house = 2;
	unit.damage_frame = 11;
	unit.bullet_speed = 9;
	unit.bullet_art = "image/bullets/fireball.png";
	unit.dmg_type = DAMAGE_TYPE_MAGIC;
	unit.mana = 150;
	unit.book = 'fire';
	unit.shadow = 'shadow_mid';
	table.insert(unit.spells , "blind");
	table.insert(unit.spells , "burn");
	table.insert(unit.spells , "meteor");
	unit.class = 3;
	unit.troops = "ranger";
	table.insert(unit.fweapons, "staff");
	
	unit = iniSet("mingmage");
	setStats(unit, ALIGN_GOOD,3, 50, RANGE_MAGIC+5, SPEED_SLOW,80,UNIT_STANDART_SIZE,"staff_red","armor_mage",1500);
	unit.resist = 20;
	unit.house = 'wizard_guild';
	unit.limit_per_house = 2;
	unit.damage_frame = 11;
	unit.dmg_type = DAMAGE_TYPE_MAGIC;
	unit.mana = 150;
	unit.book = 'earth';
	table.insert(unit.spells , "freeze");
	unit.class = 3;
	unit.troops = "ranger";
	table.insert(unit.fweapons, "staff");
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("mag_black");
	setStats(unit, ALIGN_GOOD,4, 55, RANGE_MAGIC, SPEED_SLOW,80,UNIT_STANDART_SIZE,"staff_black","armor_mage",1750);
	unit.armor = 0;
	unit.dodge = 0;
	unit.resist = 30;
	unit.house = 'wizard_guild';
	unit.limit = 3;
	unit.limit_per_house = 0;
	unit.damage_frame = 11;
	unit.dmg_type = DAMAGE_TYPE_MAGIC;
	unit.dmg_cast_self = "magic_drain_life_cast";
	unit.dmg_cast_tar = "magic_drain_life_target";
	unit.mana = 150;
	unit.vamp = 10;
	unit.book = 'void';
	table.insert(unit.spells , "plague");
	table.insert(unit.spells , "scurse");
	table.insert(unit.spells , "pull");
	unit.class = 3;
	unit.troops = "skelet";
	unit.troops2 = "skeletarcher";
	table.insert(unit.fweapons, "staff");
	table.insert(unit.fweapons, "scythe");
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("gnom");
	setStats(unit, ALIGN_GOOD, 2, 25, RANGE_MEELE-5, SPEED_SLOW,120,UNIT_SMALL_SIZE,"weapon_meele","armor_meele", 500);
	unit.h = 40;
	unit.unlock = 900;
	unit.armor = 20;
	unit.dodge = 0;
	unit.resist = 40;
	unit.house = 'blacksmith';
	unit.destroyer = 200;
	unit.repair = 10;
	unit.giant_slayer = 2;
	unit.limit_per_house = 4;
	unit.class = 1;
	unit.dwarf = true;
	unit.troops = "warrior";
	unit.shadow = 'shadow_mid';
	table.insert(unit.fweapons, "axe");
	table.insert(unit.fweapons, "hammer");
	table.insert(unit.addons, "block:5");
	table.insert(unit.addons, "stun_c:15");
	
	unit = iniSet("elf");
	setStats(unit, ALIGN_GOOD, 3, 30, RANGE_ARROW+20, SPEED_VERY_FAST, 75,UNIT_STANDART_SIZE,"weapon_meele","armor_mage",600);
	unit.muzic = true;
	unit.dodge = 10;
	unit.house = 'ranger_guild';
	unit.limit_per_house = 2;
	unit.damage_frame = 5;
	unit.bullet_art = "image/bullets/arrow_2.png";
	unit.bullet_speed = 6;
	unit.class = CLASS_RANGER;
	unit.elf = true;
	unit.troops = "ranger";
	unit.dmg_crit_c=10;
	unit.dmg_crit_v=200;
	table.insert(unit.fweapons, "bow");
	table.insert(unit.fweapons, "spear");
	table.insert(unit.addons, "armorreducion:5");
	table.insert(unit.addons, "regenreducion:1");
	table.insert(unit.addons, "poison_power:3");
	unit.shadow = 'shadow_mid';
	
	unit = iniSet("knightarcher");
	setStats(unit, ALIGN_GOOD,2, 26, RANGE_ARROW+10, SPEED_FAST, 100,UNIT_STANDART_SIZE,"weapon_bow","armor_meele",500);
	unit.armor = 8;
	unit.class = CLASS_RANGER;
	unit.troops = "ranger";
	unit.damage_frame = 5;
	unit.bullet_art = "image/bullets/arrow_1.png";
	unit.bullet_speed = 5;
	unit.house = 'castle';
	unit.limit = 2;
	unit.limit_per_house = 3;
	unit.dmg_crit_c=5;
	unit.dmg_crit_v=150;
	table.insert(unit.fweapons, "bow");
	table.insert(unit.addons, "dmg_crit_c:5");
	table.insert(unit.addons, "dmg_crit_v:25");
	table.insert(unit.addons, "troops_dmg:10");
	
	unit = iniSet("pirate");
	setStats(unit, ALIGN_GOOD, 3, 36, RANGE_MEELE, SPEED_FAST, 125, UNIT_STANDART_SIZE,"weapon_meele", "armor_ranger",600);
	unit.armor = 5;
	unit.dodge = 5;
	unit.house = 'castle';
	unit.limit_per_house = 2;
	unit.damage_frame = 5;
	unit.class = 2;
	unit.troops = "warrior";
	unit.dmg_crit_c=25;
	unit.dmg_crit_v=175;
	table.insert(unit.fweapons, "sword");
	table.insert(unit.fweapons, "axe");
	table.insert(unit.addons, "armorreducion:5");
	table.insert(unit.addons, "dmg_crit_c:10");
	table.insert(unit.addons, "dmg_crit_v:75");
	
	unit = iniSet("highelf");
	unit.shadow = 'shadow_mid';
	unit.sex = 0;
	unit.muzic = true;
	setStats(unit, ALIGN_GOOD, 3, 35, RANGE_MEELE+8, SPEED_VERY_FAST, 100, UNIT_STANDART_SIZE,"weapon_meele","armor_mage",550);
	unit.armor = 10;
	unit.dodge = 6;
	unit.house = 'ranger_guild';
	unit.limit_per_house = 2;
	unit.class = 1;
	unit.elf = true;
	unit.troops = "warrior";
	unit.dmg_crit_c=10;
	unit.dmg_crit_v=200;
	table.insert(unit.fweapons, "scythe");
	table.insert(unit.fweapons, "spear");
	table.insert(unit.addons, "armorreducion:5");
	table.insert(unit.addons, "regenreducion:1");
	table.insert(unit.addons, "poison_power:3");
	
	unit = iniSet("amazon");
	unit.shadow = 'shadow_mid';
	unit.hero = false;
	unit.sex = 0;
	setStats(unit, ALIGN_GOOD, 3, 35, RANGE_MEELE, SPEED_VERY_FAST, 130, UNIT_STANDART_SIZE,"weapon_meele","armor_no",550);
	unit.armor = 0;
	unit.dodge = 8;
	unit.house = 'ranger_guild';
	unit.limit_per_house = 2;
	unit.class = CLASS_WARRIOR;
	unit.troops = "amazon";
	unit.dmg_crit_c=15;
	unit.dmg_crit_v=175;
	table.insert(unit.fweapons, "sword");
	table.insert(unit.fweapons, "axe");
	table.insert(unit.addons, "armorreducion:5");
	table.insert(unit.addons, "regenreducion:1");
	table.insert(unit.addons, "poison_power:3");
	
	unit = iniSet("angel");
	unit.shadow = 'shadow_mid';
	unit.sex = 0;
	setStats(unit, ALIGN_GOOD, 4, 60, RANGE_MEELE, SPEED_VERY_FAST, 120, UNIT_STANDART_SIZE,"weapon_meele","armor_no",550);
	unit.armor = 0;
	unit.dodge = 8;
	unit.house = 'ranger_guild';
	unit.limit_per_house = 2;
	unit.class = CLASS_WARRIOR;
	unit.troops = "amazon";
	unit.dmg_crit_c=20;
	unit.dmg_crit_v=175;
	table.insert(unit.fweapons, "sword");
	table.insert(unit.fweapons, "axe");
	table.insert(unit.addons, "armorreducion:5");
	table.insert(unit.addons, "regenreducion:1");
	table.insert(unit.addons, "troops_dmg:15");

	unit = iniSet("elf_evil");
	setStats(unit, ALIGN_EVIL, 5, 75, RANGE_ARROW+25, SPEED_VERY_FAST, 300,UNIT_STANDART_SIZE,"monster_stuff","monster_def",600);
	unit.elf = true;
	unit.boss = true;
	unit.dodge = 45;
	unit.damage_frame = 5;
	unit.bullet_art = "image/bullets/arrow_2.png";
	unit.bullet_speed = 6;
	unit.book = 'void';
	unit.shadow = 'shadow_mid';
	--unit.mana = 200;
	--table.insert(unit.spells , "plague");
	--table.insert(unit.spells , "revive");
	
	unit = iniSet("warrior_defender");
	setStats(unit, ALIGN_GOOD,4, 30, RANGE_MEELE, SPEED_NORMAL,210,UNIT_STANDART_SIZE,"weapon_meele","armor_meele",700);
	unit.armor = 25;
	unit.dodge = 0;
	unit.resist = 15;
	unit.block = 10
	unit.limit = 0;	
	unit.class = 1;
	unit.troops = "warrior";
	unit.shadow = 'shadow_mid';
	table.insert(unit.fweapons, "axe");
	table.insert(unit.fweapons, "sword");
	table.insert(unit.addons, "block:10");
	table.insert(unit.addons, "stun_c:15");
	
	unit = iniSet("minotaur");
	setStats(unit, ALIGN_EVIL,10, 100, RANGE_MEELE*1.5, SPEED_SLOW, 1300,UNIT_STANDART_SIZE,"monster_stuff","monster_def", 1600);
	unit.h = 60;
	unit.armor = 70;
	unit.block = 15;
	unit.aoe = 90;
	unit.destroyer = 400;
	unit._giant = true;
	unit._monster = true;
	unit.shadow = 'shadow_big';
	
	unit = iniSet("trol");
	setStats(unit, ALIGN_EVIL,8, 80, RANGE_MEELE*1.5, SPEED_SLOW, 700,UNIT_STANDART_SIZE,"monster_stuff","monster_def", 1800);
	unit.h = 80;
	unit.regen = 3;
	unit.armor = 10;
	unit.resist = 30;
	unit._giant = true;
	unit._monster = true;
	unit.shadow = 'shadow_big';
	
	unit = iniSet("golem");
	setStats(unit, ALIGN_EVIL,9, 40, RANGE_MEELE+20, SPEED_MEGA_SLOW, 1600,UNIT_STANDART_SIZE,"monster_stuff","monster_def", 2100);
	unit.h = 120;
	unit.armor = 99;
	unit.resist = 99;
	unit.block = 10;
	unit._giant = true;
	unit._monster = true;
	
	unit = iniSet("mag_white");
	setStats(unit, ALIGN_GOOD,4, 50, RANGE_MAGIC*1.1, SPEED_SLOW, 120,UNIT_STANDART_SIZE,"staff_air","armor_mage",1500);
	unit.dodge = 25;
	unit.limit = 0;
	unit.limit_per_house = 0;
	unit.damage_frame = 11;
	unit.bullet_speed = 24;
	--unit.bullet_art = "image/bullets/fireball.png";
	unit.dmg_type = DAMAGE_TYPE_MAGIC;
	unit.chain = 2;
	unit.mana = 250;
	unit.book = 'air';
	table.insert(unit.spells , "morph");
	unit.class = 3;
	unit.troops = "ranger";
	table.insert(unit.fweapons, "staff");
	table.insert(unit.fweapons, "sword");
	-- table.insert(unit.fweapons, "spear");
	
	unit = iniSet("genie");
	setStats(unit, ALIGN_GOOD,4,50, RANGE_MAGIC, SPEED_NORMAL,140,UNIT_STANDART_SIZE,"staff_air","armor_no",900);
	unit.dmg_type = DAMAGE_TYPE_MAGIC;
	unit.damage_frame = 5;
	unit.h = 50;
	setStatsEx(unit,-20,1);
	unit.bullet_art = "image/bullets/green.png";
	unit.bullet_speed = 5;
	unit.mana = 300;
	unit.book = 'void';
	table.insert(unit.spells , "morph");
	table.insert(unit.spells , "clighting");
	-- table.insert(unit.spells , "mass_resist");
	unit.troops = "airbow_blue";
	unit.class = 3;
	table.insert(unit.fweapons, "staff");
	table.insert(unit.fweapons, "scythe");
	unit.shadow = 'shadow_small';
	
	unit = iniSet("airbow_blue");
	setStats(unit, ALIGN_NEIT, 1, 16, RANGE_ARROW, SPEED_VERY_FAST, 80, UNIT_STANDART_SIZE, "weapon_bow", "armor_no", 400);
	unit.dmg_type = DAMAGE_TYPE_MAGIC;
	unit.armor = 0;
	unit.resist = 5;
	unit.dodge = 10;
	unit.shadow = 'shadow_small';
	unit.damage_frame = 5;
	unit.bullet_speed = 8;
	unit.bullet_art = "image/bullets/bluearrow.png";
	unit.bullet_art_crit = "image/bullets/bluearrow_crit.png";
	unit.dmg_crit_c=10;
	unit.dmg_crit_v=150;
	table.insert(unit.fweapons, "bow");
	unit.class = 2;

	unit = iniSet("airsword");
	setStats(unit, ALIGN_EVIL, 6, 40, RANGE_MEELE, SPEED_VERY_FAST, 400, UNIT_STANDART_SIZE, "monster_stuff", "monster_def", 1000);
	unit.armor = 0;
	unit.resist = 25;
	unit.dodge = 35;
	unit.shadow = 'shadow_small';
	
	unit = iniSet("sandspear");
	setStats(unit, ALIGN_EVIL, 9, 40, RANGE_MEELE+10, SPEED_VERY_FAST, 700, UNIT_STANDART_SIZE, "monster_stuff", "monster_def", 1000);
	unit.armor = 0;
	unit.resist = 25;
	unit.dodge = 35;
	--unit.shadow = 'shadow_small';
	
	unit = iniSet("sandpriest");
	setStats(unit, ALIGN_EVIL, 9, 50, RANGE_MAGIC, SPEED_VERY_FAST, 600, UNIT_STANDART_SIZE, "monster_stuff", "monster_def", 1000);
	unit.armor = 0;
	unit.resist = 25;
	unit.dodge = 35;
	--unit.shadow = 'shadow_small';
	unit.damage_frame = 7;
	unit.bullet_speed = 5;
	unit.bullet_art = "image/bullets/violet.png";
	unit.mana = 200;
	table.insert(unit.spells , "sheal");
	unit.dmg_type = DAMAGE_TYPE_MAGIC;
	
	unit = iniSet("airbow");
	setStats(unit, ALIGN_EVIL, 7, 30, RANGE_ARROW, SPEED_VERY_FAST, 300, UNIT_STANDART_SIZE, "monster_stuff", "monster_def", 1000);
	unit.armor = 0;
	unit.resist = 25;
	unit.dodge = 35;
	unit.shadow = 'shadow_small';
	unit.damage_frame = 5;
	unit.bullet_speed = 6;
	unit.bullet_art = "image/bullets/bluearrow.png";
	unit.bullet_art_crit = "image/bullets/bluearrow_crit.png";
	unit.dmg_crit_c=10;
	unit.dmg_crit_v=150;
	
	unit = iniSet("airgolem");
	setStats(unit, ALIGN_EVIL, 20, 250, RANGE_MEELE*3, SPEED_NORMAL, 52000, UNIT_STANDART_SIZE, "monster_stuff", "monster_def", 10000);
	unit.mana = 300;
	unit.h = 150;
	unit.armor = 310;
	unit.resist = 20;
	unit.dodge = 30;
	unit.shadow = 'shadow_big';
	unit.damage_frame = 8;
	unit._giant = true;
	unit._morphing = true;	
	unit._boss = true;
	table.insert(unit.spells , "clighting");
	unit.book = 'air';
	
	unit = iniSet("nasus");
	setStats(unit, ALIGN_EVIL, 12, 100, RANGE_MEELE*1.4, SPEED_NORMAL, 2300, UNIT_STANDART_SIZE, "monster_stuff", "monster_def", 5000);
	unit.dmg_type = DAMAGE_TYPE_MAGIC;
	--unit.mana = 300;
	--unit.h = 150;
	unit.armor = 70;
	unit.resist = 250;
	unit.shadow = 'shadow_mid';
	unit.damage_frame = 8;
	unit._giant = true;
	--unit._morphing = true;	
	--unit._boss = true;
	--table.insert(unit.spells , "clighting");
	unit.book = 'void';
	unit.aoe = 70;
	unit.dmg_crit_c=20;
	unit.dmg_crit_v=150;
	
	unit = iniSet("renekton");
	setStats(unit, ALIGN_EVIL, 12, 120, RANGE_MEELE*1.5, SPEED_NORMAL, 2500, UNIT_STANDART_SIZE, "monster_stuff", "monster_def", 5000);
	unit.mana = 300;
	--unit.h = 150;
	unit.armor = 300;
	unit.resist = 50;
	unit.shadow = 'shadow_big';
	unit.damage_frame = 8;
	unit._giant = true;
	--unit._morphing = true;	
	--unit._boss = true;
	--table.insert(unit.spells , "clighting");
	--unit.book = 'void';
	unit.aoe = 120;
	unit.dmg_crit_c=30;
	unit.dmg_crit_v=125;
	
	unit = iniSet("ent");
	setStats(unit, ALIGN_EVIL,6, 95, RANGE_ARROW+10, SPEED_VERY_SLOW, 6000,UNIT_STANDART_SIZE,"monster_stuff","monster_def",5000);
	setStatsEx(unit,-20,1);
	unit.shadow = 'shadow_big';
	unit.armor = 120;
	unit.h = 80;
	unit._giant = true;
	unit._boss = true;
	unit.dmg_cast_tar = "spikes3";
	
	unit = iniSet("veigar");
	setStats(unit, ALIGN_EVIL,6, 160, RANGE_MEELE*1.5, SPEED_SLOW, 4000,UNIT_STANDART_SIZE,"monster_stuff","monster_def",5000);
	setStatsEx(unit,-20,1);
	unit.shadow = 'shadow_big';
	unit.armor = 40;
	unit.resist = 150;
	--unit.h = 80;
	unit._giant = true;
	unit._boss = true;
	
	unit = iniSet("azir");
	setStats(unit, ALIGN_EVIL, 12, 120, RANGE_MEELE*2.0, SPEED_NORMAL, 2500, UNIT_STANDART_SIZE, "monster_stuff", "monster_def", 5000);
	unit.mana = 200;
	table.insert(unit.spells , "pull");
	--unit.h = 150;
	unit.armor = 100;
	unit.resist = 100;
	unit.shadow = 'shadow_big';
	unit.damage_frame = 8;
	unit._giant = true;
	--unit._morphing = true;	
	--unit._boss = true;
	--table.insert(unit.spells , "clighting");
	unit.book = 'void';
	unit.aoe = 30;
	unit.dmg_crit_c=35;
	unit.dmg_crit_v=175;
	
	unit = iniSet("tornado");
	unit.h = 150;
	unit._food = false;
	unit.shadow = 'shadow_big';
	
	unit = iniSet("sheep");
	unit.h = 20;
	unit._food = true;
	
	unit = iniSet("fox");
	unit.h = 20;
	unit._food = true;
	
	unit = iniSet("magic_camouflage");
	unit.h = 30;
	unit._food = false;

	local function add_decor_obj(set_name, image, last_set, set_start, set_l, animation_order, sequences)
		local this_ani_speed = 90;

		if(art[set_name] == nil)then
			art[set_name] = {};
		end
		table.insert(art[set_name], last_set);
		
		if(last_set=="storm_cloud")then
			this_ani_speed = 130;
			animation_order=0;
		elseif(last_set=="wind")then
			this_ani_speed = 120;
			animation_order=0;
		elseif(last_set=="stun_stars")then
			this_ani_speed = 80;
			animation_order=0;
		elseif(last_set=="dd_add_units_progress")then
			animation_order=0;
		end
		
		local item_obj = {};
		item_obj.image = image;
		item_obj.sequences = sequences;
		item_obj['sprite_id'] = set_name;
		item_obj.id = last_set;
		item_obj['dy'] = 0;
		art.links[last_set] = item_obj;
		table.insert(art.decors, item_obj);
		
		--print('add_decor:', last_set)
		
		local sequenceData = {};
		sequenceData.name=last_set;
		sequenceData.start=set_start;
		sequenceData.count=set_l;
		sequenceData.time=this_ani_speed*set_l;	
		sequenceData.loopCount = animation_order;
		table.insert(sequences, sequenceData);
	end

	local function add_decor(set_name, animation_order)
		local sheetInfo = require('image.'..set_name);
		local data = sheetInfo:getSheet();
		local image = graphics.newImageSheet('image/'.. set_name..".png", data);
		local sequences = {};
		
		for key,value in pairs(sheetInfo.frameIndex) do
			data.frames[value].name = key;
		end
			
		local next_set = nil;
		local last_set = nil;
		local new_set = false;
		local set_l = 0;
		local set_start = 0;
		
		for i=1,#data.frames do
			new_set = false;
			local frame_name = data.frames[i].name;
			next_set = crop_set_name(set_name,frame_name);
			if(next_set ~= last_set)then
				if(last_set)then
					add_decor_obj(set_name, image, last_set, set_start, set_l, animation_order,sequences);
				end
				new_set = true;
				set_start = i;
				last_set = next_set;
				set_l =0;
			end
			set_l = set_l +1;
		end
		if(last_set)then
			add_decor_obj(set_name, image, last_set, set_start, set_l, animation_order,sequences);
		end
	end
	
	function art:loadDecor()
		add_decor("decor", 0);
		-- add_decor("decor_2", 0);
		
		ani_speed = 60;
		add_decor("gfx_all", 1);

		
		art.links["magic_drain_life_cast"].yfix = -60;
		art.links["magic_drain_life_target"].yfix = -70;
		
		art.links["magic_wither_cast_back"].xfix = 5;
		art.links["magic_wither_cast_back"].yfix = 9-34;
		art.links["magic_wither_cast_front"].xfix = 5;
		art.links["magic_wither_cast_front"].yfix = -70-34;
		
		art.links["build_crash_small"].xfix = 10;
		
		art.links["magic_shieldOfLight_target_back"].yfix = -12;
		art.links["magic_shieldOfLight_target_front"].yfix = 12;
		
		art.links["magic_teleport_target"].yfix = -90;
		
		art.links["magic_resurection_target_back"].yfix = -10;
		art.links["magic_resurection_target_front"].yfix = -98;
		
		art.links["levelup"].yfix = -100;
		art.loaded_decor = true;
	end
	--------------------------------
	
	local function load_offsets(path_str,extrax)
		local path =  system.pathForFile(path_str, system.ResourceDirectory);
		local file = io.open( path, "r" );
		local ani_delta_file = file:read( "*a" );
		io.close( file );
		if(ani_delta_file)then
			local ani_arr = string_split(ani_delta_file, ";");
			for i=1,#ani_arr do
				local line_str=ani_arr[i];
				local line_arr=string_split(line_str, ":");
				local left_arr=string_split(line_arr[1],"/");
				local left_str=left_arr[#left_arr];
				local rigth_arr=string_split(line_arr[2],",");
				local dx,dy = rigth_arr[1]*extrax, -rigth_arr[2]/2;
				art.deltas[left_str]={};
				art.deltas[left_str].x, art.deltas[left_str].y = dx,dy;
				
				local narr = string_split(left_str, "_");
				table.remove(narr, #narr);
				table.remove(narr, #narr);
				local set_name = table.concat(narr, "_");

				if(check_flyers(set_name))then
					if(left_str:find("idle", 1, true))then
						local txt_obj = string_split(left_str, 'idle');
						local nleft_str = table.concat(txt_obj, "reload");
						art.deltas[nleft_str]={};
						art.deltas[nleft_str].x, art.deltas[nleft_str].y = dx,dy;
					end
				else
					if(left_str:find("attack", 1, true))then
						local txt_obj = string_split(left_str, 'attack');
						local nleft_str = table.concat(txt_obj, "reload");
						art.deltas[nleft_str]={};
						art.deltas[nleft_str].x, art.deltas[nleft_str].y = dx,dy;
					end
				end
				if(left_str:find("mag_evil_idle", 1, true))then
					local txt_obj = string_split(left_str, 'idle');
					local nleft_str = table.concat(txt_obj, "pause");
					art.deltas[nleft_str]={};
					art.deltas[nleft_str].x, art.deltas[nleft_str].y = dx,dy;
				end
			end
		end
	end
	
	function art:loadDeltas()
		load_offsets("data/majesty_export.txt",0);
		load_offsets("data/majesty_export_2.txt",1);
		load_offsets("data/majesty_export_3.txt",1);
		art.loaded_deltas = true;
	end
	
	local function load_perks(path_str)
		local path =  system.pathForFile(path_str, system.ResourceDirectory);
		local file = io.open( path, "r" );
		local ani_delta_file = file:read( "*a" );
		io.close( file );
		if(ani_delta_file)then
			local ani_arr = string_split(ani_delta_file, "\n");
			local uid = 0;
			for i=1,#ani_arr do
				local ani_str = ani_arr[i];
				local comment = ani_str:find("--", 1 , true)
				local item_arr = string_split(ani_arr[i], "	");
				if(#item_arr>0 and comment==nil)then
					--print(i, #ani_str, #item_arr, comment);
					local id_arr = string_split(item_arr[1], " ");
					local id =  string.lower(table.concat(id_arr,"_"));

					id_arr = string_split(id, "`");
					id = table.concat(id_arr,"");
					id_arr = string_split(id, "'");
					id = table.concat(id_arr,"");
					
					--language:addEnWord(id, item_arr[1])
					
					if(item_arr[3])then
						local lvls_arr = string_split(item_arr[3],"/");						
						local name = item_arr[1];
						--print(i,uid, id, name, table.concat(lvls_arr,"|"));
						uid = uid + 1;
						local obj = {};
						obj.id = id;
						obj.uid =uid;
						obj.lvls_arr = lvls_arr;
						obj.class = tonumber(item_arr[4]);
						obj.min_lvl = lvls_arr[1]/1;
						
						obj.prms = item_arr[2];
						obj.req = item_arr[5];
						
						obj.arr = {};
						table.insert(obj.arr, item_arr[2]);
						
						table.insert(art.perks, obj);
					end
				end
			end
		end
	end
	art.perks={};
	
	function art:loadPerks()
		load_perks("data/perks_1.txt");
		load_perks("data/perks_2.txt");
		art.loaded_perks = true;
	end


	
	return art;
end