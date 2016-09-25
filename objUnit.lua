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

function new(gType, gid, map_lvl)
	local unit_mc = require("objWarrior").new();
	unit_mc._type = gType;
	unit_mc._dead=false;
	unit_mc._hero=false;
	unit_mc._gid = gid;
	unit_mc._dir = 'n';
	unit_mc._thorns = 0;
	unit_mc._reload = 0;
	unit_mc._utype = 'unit';
	unit_mc.mtype = 'realunit';
	unit_mc._summoned = false;
	
	unit_mc._path = {};
	
	lvl_mc = nil;

	local unit_data = game_art.sets[unit_mc._type];
	unit_mc.unit_data = unit_data;
	local unit_deltas = game_art.deltas;
	unit_mc._air = false;
	
	function unit_mc:setSS()
		if(unit_data.image == nil)then
			game_art:loadData(unit_mc._type);
			if(unit_data.image == nil)then
				unit_mc._dead = true;
				return unit_mc
			end
		end
		unit_mc._sprite_mc = display.newSprite(unit_data.image, unit_data.sequences);
		
		unit_mc._sprite_mc.x = 0;
		unit_mc._sprite_mc.y = 0;
		unit_mc:insert(unit_mc._sprite_mc);
		if(options_debug and false)then
			local dark_mc = display.newRect(unit_mc, 0, -unit_mc._h/2, 12, unit_mc._h);
			dark_mc:setFillColor(0,191,255);
			dark_mc.alpha = 0.4;
			local dark_mc = display.newCircle(unit_mc, 0, 0, unit_mc._col_r);
			dark_mc:setFillColor(0,191,255);
			dark_mc.alpha = 0.4;
		end
	end
	function unit_mc:getBody()
		return unit_mc._sprite_mc;
	end
	
	--function unit_mc:getCenterPoint()
	--	return {x=unit_mc.x+unitOffsetX[unit_mc._type], y=unit_mc.y+unitOffsetY[unit_mc._type]}
	--end
	function round(num, idp)
	  local mult = 10^(idp or 0)
	  return math.floor(num * mult + 0.5) / mult;
	end
	function unit_mc:setDirByPath()
		if(#unit_mc._path>0)then
			if(unit_mc._path[1].x)then
				local dx = unit_mc._path[1].x - unit_mc.x;
				local dy = unit_mc._path[1].y - unit_mc.y;
				unit_mc:setDir(dx, dy)
			end
		end
	end
	local pi_half = math.pi/4;
	function unit_mc:setDir(dx, dy)
		local val=math.atan2(dx,dy);
		local side = 5+round(val/pi_half);
		--unit_mc._atan2 = math.atan2(dy,dx);
		unit_mc._dir =sides[side];
		unit_mc._side = side;
		unit_mc._adx = dx;
		unit_mc._ady = dy;
		unit_mc:refresSet();
	end
	
	function unit_mc:setAct(act)
		--idle go attack death muz
		if(act == "death")then
			if(unit_mc.name_dtxt)then
				unit_mc.name_dtxt:removeSelf();
				unit_mc.name_dtxt = nil;
			end
			if(unit_mc._stuned>0 or unit_mc._frozen>0)then
				unit_mc:turnCon(99999);
			end
			if(unit_mc._raged)then
				sound_play("enraged_out");
			elseif(eliteSoundsIns:sound_check("death_"..unit_mc._type))then
				sound_play("death_"..unit_mc._type);
			elseif(unit_data._goblin)then
				sound_play("death_goblin_any");
			else
				sound_play("death");
			end
		end
		
		if(unit_mc._stuned>0)then
			return false
		end
		
		if(unit_mc._dead or act == "death")then
			if(unit_mc._bless1_mc)then
				unit_mc._bless1_mc:removeSelf();
				unit_mc._bless1_mc = nil;
			end
			if(unit_mc._bless2_mc)then
				unit_mc._bless2_mc:removeSelf();
				unit_mc._bless2_mc = nil;
			end
			if(unit_mc._bless3_mc)then
				unit_mc._bless3_mc:removeSelf();
				unit_mc._bless3_mc = nil;
			end
			if(unit_mc._bless4_mc)then
				unit_mc._bless4_mc:removeSelf();
				unit_mc._bless4_mc = nil;
			end
			if(unit_mc._bless5_mc)then
				unit_mc._bless5_mc:removeSelf();
				unit_mc._bless5_mc = nil;
			end
			if(unit_mc._bless6_mc)then
				unit_mc._bless6_mc:removeSelf();
				unit_mc._bless6_mc = nil;
			end
		end
		
		if(unit_mc._morphing)then
			if(act == 'go')then
				if(unit_mc._act ~= 'going')then
					act = 'start';
				else
					act = 'going';
				end
			else
				if(unit_mc._act == 'going')then
					act = 'stop';
				end
			end
		end

		unit_mc._shooted = false;
		unit_mc._act = act;
		unit_mc:refresSet();
	end
	function unit_mc:attemptAttack(tar_mc, dx, dy)
		if(unit_mc._reload >0)then
			unit_mc:setAct('reload');
			return false;
		end
		unit_mc._reload = attack_reload_delay;
		unit_mc._tar = tar_mc;
		unit_mc:setDir(dx, dy);
		unit_mc:setAct('attack');
	end
	
	unit_mc.old_ani_set = '';
	function unit_mc:spritePlaying()
		return unit_mc._sprite_mc.isPlaying;
	end

	function unit_mc:refresSet()
		if(unit_mc._dead)then
			return
		end
		if(unit_mc._frozen>0 and unit_mc._act ~= "death")then
			return
		end
		if(unit_mc._act)then
			local new_ani_set = unit_mc._act.."_"..unit_mc._dir;
			if(unit_mc._act == 'attack' and unit_data.super_attack and (unit_mc._dmg_crit_ani or unit_mc._casted))then
				new_ani_set = 'super_attack'.."_"..unit_mc._dir;
				unit_mc._casted = false;
			end
			if(unit_mc.old_ani_set == new_ani_set)then
				if(unit_mc._act == 'attack')then
					unit_mc._sprite_mc:setFrame(1);
					unit_mc._sprite_mc:play();
				end
			else
				local last_set_obj = string_split(new_ani_set,'_');
				local side_id = table.remove(last_set_obj, #last_set_obj);
				
	
				unit_mc.mscale = 1;
				if(side_id == 'n')then
					side_id = 'w';
					new_ani_set = table.concat(last_set_obj, '_')..'_'..side_id;
					unit_mc.mscale = -1;
				elseif(side_id == 'ne')then
					side_id = 'sw';
					new_ani_set = table.concat(last_set_obj, '_')..'_'..side_id;
					unit_mc.mscale = -1;
				elseif(side_id == 'e')then
					side_id = 's';
					new_ani_set = table.concat(last_set_obj, '_')..'_'..side_id;
					unit_mc.mscale = -1;
				end
				
				local full_str = unit_data.sprite_id..'_'..new_ani_set;
				unit_mc.saved_ani_set = new_ani_set;
				print("_unit_deltas:", unit_deltas, unit_deltas[full_str], full_str);
				if(unit_deltas[full_str])then
					unit_mc._sprite_mc.x,unit_mc._sprite_mc.y = unit_deltas[full_str].x*unit_mc.mscale,unit_deltas[full_str].y*unit_mc.yScale;
				end

				unit_mc._sprite_mc.xScale = unit_mc.mscale;
				unit_mc._sprite_mc:setSequence(new_ani_set);
				unit_mc._sprite_mc:play();
				unit_mc.old_ani_set = new_ani_set;
				-- local last_set_obj = string_split(new_ani_set,'_');
				-- local side_id = table.remove(last_set_obj, #last_set_obj);
				-- local mscale = 1;
				-- if(side_id == 'n')then
					-- side_id = 'w';
					-- new_ani_set = table.concat(last_set_obj, '_')..'_'..side_id;
					-- mscale = -1;
				-- elseif(side_id == 'ne')then
					-- side_id = 'sw';
					-- new_ani_set = table.concat(last_set_obj, '_')..'_'..side_id;
					-- mscale = -1;
				-- elseif(side_id == 'e')then
					-- side_id = 's';
					-- new_ani_set = table.concat(last_set_obj, '_')..'_'..side_id;
					-- mscale = -1;
				-- end
				-- unit_mc._sprite_mc.xScale = mscale;
				
				-- local full_str = unit_data.sprite_id..'_'..new_ani_set
				-- if(unit_deltas[full_str])then
					-- unit_mc._sprite_mc.x,unit_mc._sprite_mc.y = unit_deltas[full_str].x,unit_deltas[full_str].y*unit_mc.yScale;
				-- end
				
				-- unit_mc._sprite_mc:setSequence(new_ani_set);
				-- unit_mc._sprite_mc:play();
				-- unit_mc.old_ani_set = new_ani_set;
			end
			
			-- local mscale = 1;
			-- if(unit_mc._side>5 and unit_mc._side<9)then
				-- mscale = -1;
			-- end
			-- unit_mc._sprite_mc.xScale = mscale;
		end
	end
	
	unit_mc._dmg = unit_data.dmg;
	unit_mc._chain = unit_data.chain;
	unit_mc._aoe = unit_data.aoe*math.pi/180;
	unit_mc._vamp = unit_data.vamp
	unit_mc._dmg_type = unit_data.dmg_type;
	unit_mc._r = unit_data.r;
	unit_mc._rr = unit_mc._r*unit_mc._r;
	unit_mc._col_r = unit_data.col_r;
	unit_mc._col_rr = unit_mc._col_r*unit_mc._col_r;
	unit_mc._s = unit_data.s/300;
	unit_mc._s_boost = 0;
	unit_mc._h = unit_data.h or 50;
	
	function unit_mc:usePerStats()--APPLYING Per Stats once. Have to be after all dress ups and perks.
		-- print("_usePerStats:", unit_mc._dmg_per, unit_mc._hp_per);
		if(unit_mc._hp_per)then
			unit_mc._hp = unit_mc._hp *(100 + unit_mc._hp_per)/100;
			unit_mc._hp_max = unit_mc._hp;
			unit_mc._hp_per = nil;
		end
		if(unit_mc._dmg_per)then
			unit_mc._dmg = unit_mc._dmg *(100 + unit_mc._dmg_per)/100;
			unit_mc._dmg_per = nil;
		end
		unit_mc._regen = unit_data.regen * (1+math.sqrt(unit_mc._hp_max)/10);
	end

	unit_mc._muzing = unit_data.muzic==true;
	
	if(unit_data.shadow)then
		unit_mc._shadow_mc = display.newImage(unit_mc, "image/units/"..unit_data.shadow..".png");
		unit_mc._shadow_mc.x, unit_mc._shadow_mc.y = 0,12;
		unit_mc:insert(1, unit_mc._shadow_mc);
	end
	
	unit_mc._dmg_crit_c=unit_data.dmg_crit_c;
	unit_mc._dmg_crit_v=unit_data.dmg_crit_v;
	unit_mc._dmg_crit_ani = false;
	
	unit_mc._stun_c=unit_data.stun_c/100;
	unit_mc._stun_v=unit_data.stun_v;
	
	unit_mc._dmg_crit=unit_mc._dmg_crit_c>0;
	unit_mc._stun=unit_mc._stun_c>0;
	
	unit_mc._finisher = unit_data.finisher;
	unit_mc._armorreducion = unit_data.armorreducion;
	unit_mc._destroyer = unit_data.destroyer;
	unit_mc._magic_dmg = 0;
	unit_mc._true_dmg = 0;
	
	unit_mc._regen = unit_data.regen;
	unit_mc._healing = unit_data.healing;
	
	unit_mc._dframe = unit_data.damage_frame or 100;
	
	unit_mc._bspeed = unit_data.bullet_speed or 0;
	unit_mc._bart = unit_data.bullet_art;
	unit_mc._dmg_cast_self = unit_data.dmg_cast_self;
	unit_mc._dmg_cast_tar = unit_data.dmg_cast_tar;
	
	unit_mc._ulvl = unit_data.lvl;
	unit_mc._rush_bol = (unit_data._rush == true);
	unit_mc._hp_max = unit_data.hp;
	unit_mc._poison_power = unit_data.poison_power;

	unit_mc:setMP(unit_data.mana);
	
	for i=1,#unit_data.spells do
		unit_mc._spells[#unit_mc._spells+1] = unit_data.spells[i];
	end
		
	-- if(options_debug)then
		-- unit_mc:setMP(300);
		-- unit_mc._spells[#unit_mc._spells+1] = "blind";
	-- end
	
	unit_mc._auras = {};
	unit_mc._auras_bol = false;
	unit_mc._auras_reload = AURA_TIMER;
	
	unit_mc._armor = unit_data.armor;
	unit_mc._block = unit_data.block;
	unit_mc._dodge = unit_data.dodge;
	unit_mc._resist = unit_data.resist;
	unit_mc._potions = 0;
	
	unit_mc._holy = unit_data._holy;
	unit_mc._undead = unit_data._undead;
	unit_mc._giant = unit_data._giant;
	unit_mc._passive = unit_data._passive;
	unit_mc._morphing = unit_data._morphing;
	unit_mc._taxman = unit_data._taxman;
	--print("_unit_mc._holy:", unit_mc._holy)
	--print("_unit_mc._undead:", unit_mc._undead)
	unit_mc._weapon_type = unit_data.weapon_type;
	unit_mc._armor_type = unit_data.armor_type;
	unit_mc._repair = unit_data.repair;
	unit_mc._exp = 1;--boost to expirience
	


	
	unit_mc:setHP(unit_mc._hp_max)
	
	unit_mc._lvl = 1;
	unit_mc._xp = 0;
	unit_mc._xp_max = unit_mc._lvl*unit_mc._lvl*50;
	
	function unit_mc:starup()
		unit_mc:removeStar()
		
		unit_mc._bless6_mc = display.newImage(unit_mc, "image/icos/star.png");
		unit_mc._bless6_mc.x, unit_mc._bless6_mc.y = 0, -60;
		transition.from(unit_mc._bless6_mc, {time=400, alpha=0, y=-200});
	end
	function unit_mc:removeStar()
		if(unit_mc._bless6_mc)then
			unit_mc._bless6_mc:removeSelf();
			unit_mc._bless6_mc = nil;
		end
	end
	function unit_mc:levelup()
		unit_mc._lvl = unit_mc._lvl + 1;
		unit_mc._xp_max = unit_mc._lvl*unit_mc._lvl*50;
		
		unit_mc._dmg = unit_mc._dmg + unit_mc._ulvl;
		unit_mc._hp_max = unit_mc._hp_max + 5;
		
		if(unit_data.armor_type == "armor_no")then
			unit_mc._dmg = unit_mc._dmg + 2;
		end
		
		if(unit_mc._mp>0)then
			unit_mc._mp = unit_mc._mp + 10;
		end
		
		if(unit_mc._poison_power)then
			if(unit_mc._poison_power > 0)then
				unit_mc._poison_power = unit_mc._poison_power + 0.5;
			end
		end

		unit_mc._hp = unit_mc._hp_max;
		unit_mc:refreshHP();
		
		unit_mc._dmg_crit=unit_mc._dmg_crit_c>0;
		unit_mc._stun=unit_mc._stun_c>0;
	end
	function unit_mc:demote()
		unit_mc._muzing = false;
		while(#unit_mc._spells>0)do
			table.remove(unit_mc._spells, 1);
		end
		unit_mc:removeMP();
	end

	unit_mc:setSS()
	return unit_mc
end