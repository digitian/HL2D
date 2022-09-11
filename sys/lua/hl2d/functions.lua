function Apple.PlayerJump(id)
	local x, y = player(id, "x"), player(id, "y")
	Apple.Jump[id] = 5
	Apple.Jumpx[id] = x
	Apple.Jumpy[id] = y
	Apple.JumpRot[id] = math.rad(player(id, "rot"))
	parse("speedmod "..id.." -100")
	Apple.FootStep[id] = 1
	Apple.StepTimer[id] = 0
	imageframe(Apple.IMG[id][2], 1)
	parse('sv_soundpos "apple/hl2d/player/pl_jump'..math.random(1,2)..'.wav" '..x..' '..y)
end

function Apple.RemovePlayerImages(id)
	for k = 1, 9 do
		freeimage(Apple.IMG[id][k])
	end
	freeimage(Apple.IMG[id][12])
	for k = 1, 12 do
		if Apple.WalkoverHuds[id][k][1] ~= 0 then
			Apple.WalkoverHuds[id][k][1] = 0
			freeimage(Apple.WalkoverHuds[id][k][2])
			Apple.WalkoverHuds[id][k][3] = 0
		end
	end
end

function Apple.ResetPlayer(id)
Apple.RemovePlayerImages(id)
Apple.FootStep[id] = 1
Apple.StepTimer[id] = 0
Apple.Jump[id] = 0
Apple.Armor[id] = 0
Apple.Mouse1Timer[id] = 0
Apple.Mouse1Pressed[id] = 0
Apple.ReloadPassive[id] = 0
	if Apple.ChargeMode[id] ~= 0 then
		local k = Apple.ChargeMode[id]
		Apple.ChargeMode[id] = 0
		Apple.ChargeZone[k].p = 0
	end
	for k = 0, 5 do
		parse('hudtxt2 '..id..' '..k..' "" 0 0')
	end
	parse('hudtxt2 '..id..' 30 "" 0 0')
	if Apple.InWater[id] == 1 then
		Apple.PlayerSpeed[id] = 0
		Apple.InWater[id] = 0
		freeimage(Apple.IMG[id][10])
		freeimage(Apple.IMG[id][11])
		parse('hudtxt2 '..id..' 31 "" 0 0')
		parse('hudtxt2 '..id..' 32 "" 0 0')
	end
	if Apple.ReloadProcess[id] ~= 0 then
		Apple.StopReload(id)
	end
	for k = 1, 9 do
		Apple.Ammo[id][k][1] = 0
		Apple.Ammo[id][k][2] = 0
	end
	if Apple.WeaponVar[id][1] ~= 0 then
		Apple.WeaponVar[id][1] = 0
		Apple.WeaponVar[id][2] = 0
		Apple.WeaponVar[id][3] = 0
		parse('sv_stopsound "apple/hl2d/weapons/gauss_spinup.ogg" '..id)
	end
	if Apple.WeaponVar[id][4] ~= 0 then
		Apple.WeaponVar[id][4] = 0
	end
	if Apple.WeaponVar[id][6] ~= 0 then
		Apple.WeaponVar[id][6] = 0
	end
end

function Apple.LoadHPHuds(id)
	if player(id, "health") > 30 then
		parse('hudtxt2 '..id..' 0 "©128255000'..player(id, "health")..'" 55 443 0 0 30')
		imagecolor(Apple.IMG[id][4],255,0,0)
	else
		parse('hudtxt2 '..id..' 0 "©255000000'..player(id, "health")..'" 55 443 0 0 30')
		imagecolor(Apple.IMG[id][4],0,255,0)
	end
	parse('hudtxt2 '..id..' 1 "©128255000'..Apple.Armor[id]..'" 188 443 0 0 30')
end

function Apple.LoadAmmoHud(id)
	local k = Apple.Weapon[id]
	local m = Apple.Weapons[k]
	if m.bullet then
		if m.maxammo then
			parse('hudtxt2 '..id..' 2 "©128255000|" 720 443 0 0 30')
			parse('hudtxt2 '..id..' 3 "©128255000'..Apple.Ammo[id][k][1]..'" 715 443 2 0 30')
			parse('hudtxt2 '..id..' 4 "©128255000'..Apple.Ammo[id][k][2]..'" 787 443 2 0 30')
		else
			if k == 9 then k = 8 end
			parse('hudtxt2 '..id..' 2 "©128255000'..Apple.Ammo[id][k][1]..'" 787 443 2 0 30')
			parse('hudtxt2 '..id..' 3 "" 0 0')
			parse('hudtxt2 '..id..' 4 "" 0 0')
		end
	else
		parse('hudtxt2 '..id..' 2 "" 0 0')
		parse('hudtxt2 '..id..' 3 "" 0 0')
		parse('hudtxt2 '..id..' 4 "" 0 0')
	end
	if m.ammoframe then
		imageframe(Apple.IMG[id][12], m.ammoframe)
	else
		imageframe(Apple.IMG[id][12], 13)
	end
end
	

function Apple.LoadScreen(id)
Apple.IMG[id][4] = image("gfx/apple/hl2d/huds/hp.bmp",17,461,2,id)
imageblend(Apple.IMG[id][4],1)
imagecolor(Apple.IMG[id][4],128,255,0)
Apple.IMG[id][5] = image("gfx/apple/hl2d/huds/energy.bmp",145,459,2,id)
imageblend(Apple.IMG[id][5],1)
imagecolor(Apple.IMG[id][5],255,255,0)
Apple.IMG[id][12] = image("<spritesheet:gfx/apple/hl2d/huds/hud_ammo.png:24:24>",800,460,2,id)
imageblend(Apple.IMG[id][12], 1)
imagescale(Apple.IMG[id][12], 0.8, 0.8)
imageframe(Apple.IMG[id][12], 13)
Apple.LoadHPHuds(id)
local pos_for_arrows = {{-45,-45},{45,-45},{45,45},{-45,45}} -- 430 240 = origin
	for k = 1, 4 do
		local arrow = image("gfx/apple/hl2d/effect/hud_arrow.bmp", 1, 1, 2, id)
		imagepos(arrow, 430+pos_for_arrows[k][1], 240+pos_for_arrows[k][2], 45+90*k)
		imageblend(arrow, 1)
		imagecolor(arrow, 255, 0, 0)
		imagealpha(arrow, 0)
		Apple.IMG[id][5+k] = arrow
	end
end

function Apple.LoadRadar()
-- local r = image("gfx/apple/arma2.png",53,53,2)
-- imagealpha(r,0.7)
-- imagescale(r,0.45,0.45)
end

function Apple.Distance(x1,y1,x2,y2)
return math.sqrt((x1-x2)^2+(y1-y2)^2)
end

function Apple.SpawnBullet(id, k, rotate, dist)
local m = Apple.Weapons[k]
local sx = player(id, "x") + math.sin(math.rad(rotate)) * m.shootpos
local sy = player(id, "y") - math.cos(math.rad(rotate)) * m.shootpos
local x, y, rot, d, lx, ly, c = sx, sy, math.rad(rotate), dist, sx, sy, 0
	while d > 0 and c == 0 and not tile(math.floor(x/32), math.floor(y/32), "wall") do
		d = d - 10
		lx = x; ly = y
		x = x + math.sin(rot) * 10
		y = y - math.cos(rot) * 10
		for _, i in ipairs(player(0, "tableliving")) do
			if i ~= id and Apple.Distance(x, y, player(i, "x"), player(i, "y")) < 16 then
				c = 1
				Apple.DamagePlayer(id, i, m.damage, k)
				parse('effect "blood" '..player(i, "x")..' '..player(i, "y")..' 5 '..player(id, "rot")..' 174 17 17')
			end
		end
		for _, i in ipairs(object(0, "table")) do
			if object(i, "type") == 30 and Apple.Distance(x, y, object(i, "x"), object(i, "y")) < 16 then
				parse('effect "blood" '..object(i, "x")..' '..object(i, "y")..' 5 '..player(id, "rot")..' 0 255 0')
				parse('damageobject '..i..' '..m.damage..' '..id)
				c = 1
			end
		end
	end
	local b_img = image("gfx/apple/1x1.png",1,1,1)
	imagepos(b_img, (sx+lx)/2, (sy+ly)/2, math.deg(rot))
	imagescale(b_img,0.5, dist-d)
	imagecolor(b_img, 255, 255, 0)
	tween_alpha(b_img,100,0)
	timer(100, "freeimage", b_img)
	if tile(math.floor(x/32), math.floor(y/32), "wall") then
		parse('effect "sparkles" '..lx..' '..ly..' 5 '..math.random(0, 360)..' 255 210 120')
	end
end

function Apple.Shoot(id, w, mode)
local b = Apple.Weapons[w].bullet
	if b == 99 then return end
	if b == 1 then
		if mode and mode == 1 then
			Apple.SpawnBullet(id, w, player(id, "rot")+math.random(-8, 8), 450)
		else
			Apple.SpawnBullet(id, w, player(id, "rot")+math.random(-2, 2), 450)
		end
		Apple.SheetImg(id)
	elseif b == 2 then
		Apple.SpawnBullet(id, w, player(id, "rot")-math.random(4, 6), 150)
		Apple.SpawnBullet(id, w, player(id, "rot")+math.random(-1, 1), 150)
		Apple.SpawnBullet(id, w, player(id, "rot")+math.random(4, 6), 150)
		timer(500, "parse", "lua Apple.PSoundPos("..id..",'apple/hl2d/weapons/shotgun_cock.wav')")
		Apple.SheetImg(id)
	elseif b == 3 then
		local x = player(id, "x") + math.sin(math.rad(player(id, "rot"))) * Apple.Weapons[w].shootpos
		local y = player(id, "y") - math.cos(math.rad(player(id, "rot"))) * Apple.Weapons[w].shootpos
		Apple.HornetShot(id, x, y, player(id, "rot"))
	elseif b == 4 then
		Apple.EgonElectric(id)
	elseif b == 5 then
		parse('sv_soundpos "'..Apple.Weapons[9].shoot_sound..'" '..player(id, "x")..' '..player(id, "y"))
		if math.random(1,3) == 1 then
			parse('sv_soundpos "apple/hl2d/weapons/electro'..math.random(1, 2)..'.wav" '..player(id, "x")..' '..player(id, "y"))
		end
		Apple.GaussLaser(id)
	elseif b == 6 then
		parse('sv_soundpos "'..Apple.Weapons[10].shoot_sound..'" '..player(id, "x")..' '..player(id, "y"))
		local sinus, cosinus = math.sin(math.rad(player(id, "rot")-10)), math.cos(math.rad(player(id, "rot")-10))
		local tx = player(id, "x") + sinus * 16
		local ty = player(id, "y") - cosinus * 16
		if tile(math.floor(tx/32), math.floor(ty/32), "wall") then
			parse('spawnprojectile '..id..' 47 '..tx..' '..ty..' 10 '..player(id, "rot"))
			return
		end
		for _, i in ipairs(player(0, "tableliving")) do
			if i ~= id and Apple.Distance(tx, ty, player(i, "x"), player(i, "y")) < 16 then
				parse('spawnprojectile '..id..' 47 '..tx..' '..ty..' 5 '..player(id, "rot"))
				return
			end
		end
		local x = player(id, "x") + sinus * 45
		local y = player(id, "y") - cosinus * 45
		timer(500, "parse", "lua Apple.PSoundPos("..id..",'apple/hl2d/weapons/rocket1.wav')")
		parse('spawnprojectile '..id..' 47 '..x..' '..y..' 400 '..player(id, "rot"))
	elseif b == 7 then
		Apple.SpawnGrenade(id)
		if Apple.Ammo[id][19][1] == 1 then
			timer(50, "parse", "strip "..id.." "..Apple.Weapons[19].gamewpn)
		end
	elseif b == 8 then
		Apple.SpawnSnark(id)
		parse('sv_soundpos "apple/hl2d/weapons/sqk_hunt'..math.random(1,3)..'.wav" '..player(id, "x")..' '..player(id, "y"))
		if Apple.Ammo[id][21][1] == 1 then
			timer(50, "parse", "strip "..id.." "..Apple.Weapons[21].gamewpn)
		end
	end
	if b < 4 then
		parse('sv_soundpos "'..Apple.Weapons[w].shoot_sound..'" '..player(id, "x")..' '..player(id, "y"))
	end
local ga = 1
Apple.Mouse1Timer[id] = Apple.Weapons[w].cooldown
if w == 9 then ga = 2; w = 8 end
Apple.Ammo[id][w][1] = Apple.Ammo[id][w][1] - ga
Apple.LoadAmmoHud(id)
	if Apple.ReloadProcess[id] ~= 0 then
		Apple.StopReload(id)
	end
end

function Apple.PSoundPos(id, file)
parse('sv_soundpos "'..file..'" '..player(id, "x")..' '..player(id, "y"))
end

function Apple.SpawnGrenade(id)
local rot = math.rad(player(id, "rot"))
local x = player(id, "x") + math.sin(rot) * 20
local y = player(id, "y") - math.cos(rot) * 20
local grenade = {
	x = x, y = y, rot = player(id, "rot"), speed = Apple.Distance(x, y, player(id, "mousemapx"), player(id, "mousemapy"))/25,
	extimer = 20, imgrot = player(id, "rot"), id = id,
	}
if grenade.speed > 11 then grenade.speed = 11 end
grenade.img = image("gfx/apple/hl2d/weapons/grenade_d.bmp<m>", x, y, 0)
table.insert(Apple.Grenades, grenade)
end


function Apple.SpawnSnark(id)
local rot = math.rad(player(id, "rot"))
local x = player(id, "x") + math.sin(rot) * 20
local y = player(id, "y") - math.cos(rot) * 20
local snark = {
	x = x, y = y, rot = player(id, "rot"), dist = Apple.Distance(x, y, player(id, "mousemapx"), player(id, "mousemapy")),
	lifetime = 200, imgrot = player(id, "rot"), id = id,objid = 0,
	}
if snark.dist > 400 then snark.dist = 400 end
snark.img = image("gfx/npc/snark.bmp<m>", x, y, 1)
imagepos(snark.img, x, y, snark.imgrot)
table.insert(Apple.Snarks, snark)
end

function Apple.GaussLaser(id, mode)
local m, rotate = Apple.Weapons[9], player(id, "rot")
local sx = player(id, "x") + math.sin(math.rad(rotate)) * m.shootpos
local sy = player(id, "y") - math.cos(math.rad(rotate)) * m.shootpos
local x, y, rot, d, lx, ly = sx, sy, math.rad(rotate), 480, sx, sy
local dmg = m.damage
	if mode and mode == 1 then
		dmg = Apple.WeaponVar[id][2]*(dmg/2)
	end
local ptable, hittable = {}, {}
	for _, p in ipairs(player(0, "tableliving")) do
		if Apple.Distance(x,y,player(p, "x"), player(p, "y")) < d and p ~= id then
			table.insert(ptable, p)
		end
	end
	while d > 0 and not tile(math.floor(x/32), math.floor(y/32), "wall") do
		d = d - 16
		lx = x; ly = y
		x = x + math.sin(rot) * 16
		y = y - math.cos(rot) * 16
		for _, i in ipairs(ptable) do
			if Apple.Distance(x, y, player(i, "x"), player(i, "y")) < 16 then
				if not table.contains(hittable, i) then
					Apple.DamagePlayer(id, i, dmg, 9)
					parse('effect "blood" '..player(i, "x")..' '..player(i, "y")..' 5 '..player(id, "rot")..' 174 17 17')
					table.insert(hittable, i)
				end
			end
		end
		for _, i in ipairs(object(0, "table")) do
			if object(i, "type") == 30 and Apple.Distance(x, y, object(i, "x"), object(i, "y")) < 16 then
				parse('effect "blood" '..object(i, "x")..' '..object(i, "y")..' 5 '..player(id, "rot")..' 0 255 0')
				parse('damageobject '..i..' '..dmg..' '..id)
			end
		end
	end
	local b_img = image("gfx/apple/1x1.png",1,1,1)
	imagepos(b_img, (sx+lx)/2, (sy+ly)/2, math.deg(rot))
	imagescale(b_img,2, 480-d)
	imagecolor(b_img, 255, 255, 0)
	tween_alpha(b_img,100,0)
	timer(100, "freeimage", b_img)
	local partrot = player(id, "rot")+180
	for k = 1, math.random(4,7) do
		local partang, partdist = math.rad(partrot+math.random(-25, 25)), math.random(10,55)
		local partx = x + math.sin(partang) * partdist
		local party = y - math.cos(partang) * partdist
		local spr = image("gfx/sprites/flare2.bmp", lx, ly, 1)
		imageblend(spr, 1)
		imagecolor(spr, 255, 255, 0)
		imagescale(spr, 0.07, 0.07)
		tween_move(spr, 350, partx, party)
		tween_alpha(spr, 500, 0)
		timer(350, "freeimage", spr)
	end
end

function Apple.SheetImg(id)
local sht = image("<spritesheet:gfx/apple/hl2d/gunfire_sheet.png:160:160>",3,0,200+id)
imageframe(sht, 10)
tween_alpha(sht,100,0,0)
imagescale(sht, 0.4, 0.7)
timer(100, "freeimage", sht)
end

function Apple.EgonElectric(id)
	-- if Apple.SoundTimer1[id] == 0 then
		-- parse('sv_soundpos "'..Apple.Weapons[8].shoot_sound..'" '..player(id, "x")..' '..player(id, "y"))
		-- Apple.SoundTimer1[id] = 1
	-- else
		-- Apple.SoundTimer1[id] = 0
	-- end
	if Apple.Ammo[id][8][1] == 1 then
		parse('sv_stopsound "apple/hl2d/weapons/egon_windup2.wav" '..id)
		parse('sv_sound2 '..id..' "apple/hl2d/weapons/egon_off1.wav"')
	end
local ang = math.rad(player(id, "rot"))
local x = player(id, "x") + math.sin(ang) * Apple.Weapons[8].shootpos
local y = player(id, "y") - math.cos(ang) * Apple.Weapons[8].shootpos
local sx, sy = x, y
local ptable, hittable = {}, {}
	for _, p in ipairs(player(0, "tableliving")) do
		if Apple.Distance(x,y,player(p, "x"), player(p, "y")) < 400 and p ~= id then
			table.insert(ptable, p)
		end
	end
	if tile(math.floor(x/32), math.floor(y/32), "wall") then return end
	local d, phit = 400, 0
	while d > 0 and phit == 0 and not tile(math.floor(x/32), math.floor(y/32), "wall") do
		d = d - 10
		x = x + math.sin(ang) * 10
		y = y - math.cos(ang) * 10
		for _, i in ipairs(ptable) do
			if Apple.Distance(x, y, player(i, "x"), player(i, "y")) < 16 then
				if not table.contains(hittable, i) then
					Apple.DamagePlayer(id, i, Apple.Weapons[8].damage, 8)
					parse('flashplayer '..i..' 5')
					parse('shake '..i..' 5')
					parse('effect "blood" '..player(i, "x")..' '..player(i, "y")..' 5 '..player(id, "rot")..' 174 17 17')
					table.insert(hittable, i)
					phit = 1
				end
			end
		end
		for _, i in ipairs(object(0, "table")) do
			if object(i, "type") == 30 and Apple.Distance(x, y, object(i, "x"), object(i, "y")) < 16 then
				parse('effect "blood" '..object(i, "x")..' '..object(i, "y")..' 5 '..player(id, "rot")..' 0 255 0')
				parse('damageobject '..i..' '..Apple.Weapons[8].damage..' '..id)
				phit = 1
			end
		end
	end
	local s = {-1, 1}
	local l_img = image("gfx/apple/hl2d/effect/gg_line"..math.random(1,6)..".png",1,1,1)
	imagepos(l_img, (sx+x)/2, (sy+y)/2, math.deg(ang))
	imagescale(l_img,s[math.random(1,2)], (400-d)/65)
	timer(100, "freeimage", l_img)
	local h_img = image("gfx/apple/hl2d/effect/helix1.png",1,1,1)
	imagepos(h_img, (sx+x)/2, (sy+y)/2, math.deg(ang))
	imagescale(h_img,s[math.random(1,2)], (400-d)/128)
	timer(100, "freeimage", h_img)
end

function Apple.HornetShot(id, x, y, rot)
	if tile(math.floor(x/32), math.floor(y/32), "wall") then
		return
	end
local h = {
	x = x, y = y, rot = rot, destroy = 55, id = id,
		}
h.img = image("gfx/apple/hl2d/weapons/hornetfly.bmp", 1, 1, 1)
imagepos(h.img, x, y, rot)
imagescale(h.img, 0.7, 0.7)
imagecolor(h.img, 80, 80, 80)
table.insert(Apple.HornetFly,h)
end

function Apple.ReloadFunc(id)
	local w = Apple.Weapon[id]
	if Apple.Weapons[w].noreloadfunc or Apple.ReloadPassive[id] == 1 then return end
	if Apple.ReloadProcess[id] == 0 and Apple.Ammo[id][w][2] ~= 0 and Apple.Weapons[w].bullet and Apple.Weapons[w].clip then
		if Apple.Ammo[id][w][1] ~= Apple.Weapons[w].clip then
			Apple.ReloadTimer[id] = Apple.Weapons[w].reloadtime
			Apple.ReloadProcess[id] = w
			Apple.ReloadPassive[id] = 1
			timer(1000, "parse", "lua Apple.ReloadPassive["..id.."]=0")
			parse('hudtxt2 '..id..' 6 "Reloading..." 425 270 1 0 9')
			parse('hudtxt2 '..id..' 7 "|" 383 280 0 0 10')
			parse('hudtxt2 '..id..' 8 "|" 463 280 0 0 10')
			if Apple.Weapons[w].reloadsnd then
				local sndfile = Apple.Weapons[w].reloadsnd
				for _, i in ipairs(player(0, "tableliving")) do
					if i ~= id and (not player(i, "bot")) and Apple.Distance(player(id, "x"), player(id, "y"), player(i, "x"), player(i, "y")) < 300 then
						parse('sv_soundpos "'..Apple.Weapons[w].reloadsnd..'" '..player(id, "x")..' '..player(id, "y")..' '..i)
					end
				end
				parse('sv_sound2 '..id..' "'..Apple.Weapons[w].reloadsnd..'"')
			end
		end
	end
end

function Apple.StopReload(id)
parse('hudtxt2 '..id..' 6 "" 0 0')
parse('hudtxt2 '..id..' 7 "" 0 0')
parse('hudtxt2 '..id..' 8 "" 0 0')
Apple.ReloadProcess[id] = 0
Apple.ReloadTimer[id] = 0
end

function Apple.AnalyseMap()
	local list=entitylist()
	for _,e in pairs(list) do
		if entity(e.x, e.y, "typename") == "Env_Item" then
			local name = entity(e.x, e.y, "name")
			if name == "mp5" then
				Apple.SpawnItem(e.x, e.y, 5, 1)
			elseif name == "shotgun" then
				Apple.SpawnItem(e.x, e.y, 4, 1)
			elseif name == "magnum" then
				Apple.SpawnItem(e.x, e.y, 3, 1)
			elseif name == "hornet" then
				Apple.SpawnItem(e.x, e.y, 6, 1)
			elseif name == "crossbow" then
				Apple.SpawnItem(e.x, e.y, 7, 1)
			elseif name == "egon" then
				Apple.SpawnItem(e.x, e.y, 8, 1)
			elseif name == "gauss" then
				Apple.SpawnItem(e.x, e.y, 9, 1)
			elseif name == "rpg" then
				Apple.SpawnItem(e.x, e.y, 10, 1)
			elseif name == "grenade" then
				Apple.SpawnItem(e.x, e.y, 19, 1)
			elseif name == "lasermine" then
				Apple.SpawnItem(e.x, e.y, 20, 1)
			elseif name == "snark" then
				Apple.SpawnItem(e.x, e.y, 21, 1)
			elseif name == "satchel" then
				Apple.SpawnItem(e.x, e.y, 22, 1)
			elseif name == "uraniumammo" then
				Apple.SpawnItem(e.x, e.y, 25, 1)
			elseif name == "mp5ammo" then
				Apple.SpawnItem(e.x, e.y, 26, 1)
			elseif name == "shotgunammo" then
				Apple.SpawnItem(e.x, e.y, 27, 1)
			elseif name == "crossbowammo" then
				Apple.SpawnItem(e.x, e.y, 28, 1)
			elseif name == "rocket" then
				Apple.SpawnItem(e.x, e.y, 29, 1)	
			elseif name == "magnumammo" then
				Apple.SpawnItem(e.x, e.y, 30, 1)
			elseif name == "medikit" then
				Apple.SpawnItem(e.x, e.y, 24, 1)
			-- elseif name == "longjump" then
				-- Apple.SpawnItem(e.x, e.y, 40, 1)
			elseif name:sub(3,6) == "zone" then
				local dir = name:sub(8)
				local a = {
					x = e.x, y = e.y, energy = 75, p = 0,
					dir = dir, img = 0, offline = 0,
						}
				if name:sub(1, 6) == "hpzone" then
					a.type = "health"
					a.soundtimer = 7
				elseif name:sub(1, 6) == "enzone" then
					a.type = "energy"
					a.soundtimer = 18
				end
				table.insert(Apple.ChargeZone, a)
			end
		end
	end
end

function Apple.AddHud(id, type, amode)
	if Apple.WalkoverHuds[id][12][1] ~= 0 then
		freeimage(Apple.WalkoverHuds[id][12][2])
	end
	for k = 1, 11 do
		local old, new = 13-k, 12-k
		if Apple.WalkoverHuds[id][new][1] ~= 0 then
			local img = Apple.WalkoverHuds[id][new][2]
			Apple.WalkoverHuds[id][old][1] = Apple.WalkoverHuds[id][new][1]
			Apple.WalkoverHuds[id][old][2] = Apple.WalkoverHuds[id][new][2]
			Apple.WalkoverHuds[id][old][3] = Apple.WalkoverHuds[id][new][3]
			local x = 800
				if Apple.WalkoverHuds[id][old][3] ~= 0 then
					x = 835
				end
			imagepos(img, x, 400-((12-k)*30), 0)
		end
	end
	Apple.WalkoverHuds[id][1][1] = 1
	local i = image(Apple.Weapons[type].walkoverhud,800,400,2,id)
	imageblend(i, 1)
	imagescale(i, 0.6, 0.6)
	tween_alpha(i, 3000, 0)
	Apple.WalkoverHuds[id][1][2] = i
	if amode then
		Apple.WalkoverHuds[id][1][3] = amode
		imagepos(i, 835, 400, 0)
	else
		Apple.WalkoverHuds[id][1][3] = 0
	end
end

function Apple.SpawnItem(x, y, type, recirc)
local i = {}
	i = {
		type = type, x = x, y = y, recirculation = recirc or 0,
		}
if Apple.Weapons[type].ammo then
	i.ammo = true
elseif Apple.Weapons[type].speciality then
	i.speciality = Apple.Weapons[type].speciality
end
if recirc and recirc == 2 then
	parse('sv_soundpos "apple/hl2d/items/itemspawn.ogg" '..(x*32+16)..' '..(y*32+16))
end
local px, py = x*32+16, y*32+16
i.shadowimg = image("gfx/shadow.bmp<a>",px,py,0)
imagecolor(i.shadowimg, 0, 0, 0)
imagealpha(i.shadowimg, 0.7)
i.img = image(Apple.Weapons[type].groundimg,1,1,0)
imagepos(i.img,px,py,math.random(0, 360))
if Apple.Weapons[type].groundimg_scale then
local sc = Apple.Weapons[type].groundimg_scale
imagescale(i.img, sc, sc)
end
table.insert(Apple.GroundItems, i)
end

function Apple.DamagePlayer(id, victim, dmg, k)
-- parse('sv_sound2 '..victim..' "apple/hl2d/player/bullet_hit.wav"')
	local hp, a = player(victim, "health"), Apple.Armor[victim]
	if a ~= 0 then
		if a >= dmg then
			Apple.Armor[victim] = a - dmg
			Apple.LoadHPHuds(victim)
			Apple.SetArrowImg(victim, dmg)
		else
			a = a - dmg
			hp = hp + a
			if hp > 0 then
				Apple.Armor[victim] = 0
				parse('sethealth '..victim..' '..hp)
				Apple.LoadHPHuds(victim)
				Apple.SetArrowImg(victim, dmg)
			else
				Apple.KillFunc(id, victim, k)
			end
		end
	else
		hp = hp - dmg
		if hp > 0 then
			parse('sethealth '..victim..' '..hp)
			Apple.LoadHPHuds(victim)
			Apple.SetArrowImg(victim, dmg)
		else
			Apple.KillFunc(id, victim, k)
		end
	end
end
function Apple.KillFunc(killer, victim, wpn)
parse('customkill '..killer..' "'..Apple.Weapons[wpn].name..'" '..victim)
end

function Apple.Timer2PlayerFunc(id)
		if Apple.Mouse1Timer[id] > 0 then
			Apple.Mouse1Timer[id] = Apple.Mouse1Timer[id] - 1
		end
		if Apple.ChargeMode[id] ~= 0 then
			local k = Apple.ChargeMode[id]
			local m = Apple.ChargeZone[k]
			if m.energy > 0 then
				local t = Apple.ChargeTimer[id]
				t = t - 1
				if t == 0 then
					t = m.soundtimer
					if m.type == "health" then
						parse('sv_sound2 '..id..' "apple/hl2d/items/medcharge4.wav"')
					elseif m.type == "energy" then
						parse('sv_sound2 '..id..' "apple/hl2d/items/suitcharge1.wav"')
					end
				end
				Apple.ChargeTimer[id] = t
				if m.type == "health" then
					if player(id, "health") < 100 then
						local newhp = player(id, "health")+1
						parse('sethealth '..id..' '..newhp)
						if newhp == 100 then
							Apple.ChargeMode[id] = 0
							Apple.ChargeZone[k].p = 0
						end
					end
				elseif m.type == "energy" then
					if Apple.Armor[id] < 100 then
						local newarmor = Apple.Armor[id]+1
						Apple.Armor[id] = newarmor
						if newarmor == 100 then
							Apple.ChargeMode[id] = 0
							Apple.ChargeZone[k].p = 0
						end
					end
				end
				Apple.LoadHPHuds(id)
				local e = m.energy - 1
				Apple.ChargeZone[k].energy = e
				if e == 0 then
					Apple.ChargeMode[id] = 0
					Apple.ChargeZone[k].p = 0
					Apple.ChargeZone[k].offline = 1
					local path 
					if m.type == "health" then
						path = Apple.HPZONETILE
					elseif m.type == "energy" then
						path = Apple.ENZONETILE
					end
					local x, y, rot = m.x, m.y, 0
					if m.dir == "up" then
						y = y - 1
					elseif m.dir == "down" then
						y = y + 2
						x = x + 1
						rot = 180
					elseif m.dir == "left" then
						x = x - 1
						y = y + 1
						rot = -90
					else
						x = x + 2
						rot = 90
					end
					local enimg = image("<tile:"..path..">", 1, 1, 1)
					imagepos(enimg, x*32, y*32, rot)
					Apple.ChargeZone[k].img = enimg
					timer(Apple.CHARGEZONETIMER, "parse", "lua Apple.ActivateChargeZone("..k..")")
					if m.type == "health" then
						parse('sv_soundpos "apple/hl2d/items/medshotno1.wav" '..player(id, "x")..' '..player(id, "y"))
						parse('sv_stopsound "apple/hl2d/items/medcharge4.wav" '..id)
					elseif m.type == "energy" then
						parse('sv_soundpos "apple/hl2d/items/suitchargeno1.wav" '..player(id, "x")..' '..player(id, "y"))
						parse('sv_stopsound "apple/hl2d/items/suitcharge1.wav" '..id)
					end
				end
			else
				Apple.ChargeMode[id] = 0
				Apple.ChargeZone[k].p = 0
			end
			return
		end
		if Apple.Mouse1Pressed[id] == 1 and Apple.Mouse1Timer[id] == 0 then
			local w = Apple.Weapon[id]
			if w == 9 then
				if Apple.Ammo[id][8][1] <= 1 then
					return
				end
				w = 8
			end
			if Apple.Ammo[id][w][1] > 0 then
				if Apple.Weapons[w].bullet then
					Apple.Shoot(id, Apple.Weapon[id])
				end
			else
				Apple.ReloadFunc(id)
			end
		end
		if Apple.Weapon[id] == 6 then
			if Apple.Mouse1Pressed[id] == 0 and Apple.Mouse2Pressed[id] == 0 then
				if Apple.ReloadTimer[id] == 0 then
					local m = Apple.Weapons[6]
					if Apple.Ammo[id][6][1] < m.clip then
						Apple.Ammo[id][6][1] = Apple.Ammo[id][6][1] + 1
						Apple.LoadAmmoHud(id)
						Apple.ReloadTimer[id] = m.reloadtime
					end
				else
					Apple.ReloadTimer[id] = Apple.ReloadTimer[id] - 1
				end
			end
			return
		end
		if Apple.ReloadProcess[id] ~= 0 then
			Apple.ReloadTimer[id] = Apple.ReloadTimer[id] - 1
			local w = Apple.ReloadProcess[id]
			if Apple.ReloadTimer[id] == 0 then
				local nd = Apple.Weapons[w].clip-Apple.Ammo[id][w][1]
				if Apple.Ammo[id][w][2] >= nd then
					Apple.Ammo[id][w][2] = Apple.Ammo[id][w][2] - nd
					Apple.Ammo[id][w][1] = Apple.Weapons[w].clip
				else
					Apple.Ammo[id][w][1] = Apple.Ammo[id][w][1]+Apple.Ammo[id][w][2]
					Apple.Ammo[id][w][2] = 0
				end
				Apple.StopReload(id)
				Apple.LoadAmmoHud(id)
				if Apple.Weapons[w].reload_endsnd then
					for _, i in ipairs(player(0, "tableliving")) do
						if i ~= id and (not player(i, "bot")) and Apple.Distance(player(id, "x"), player(id, "y"), player(i, "x"), player(i, "y")) < 300 then
							parse('sv_soundpos "'..Apple.Weapons[w].reload_endsnd..'" '..player(id, "x")..' '..player(id, "y")..' '..i)
						end
					end
					parse('sv_sound2 '..id..' "'..Apple.Weapons[w].reload_endsnd..'"')
				end
			else
				local r = math.ceil((1-(Apple.ReloadTimer[id]/Apple.Weapons[w].reloadtime))*41)
				parse('hudtxt2 '..id..' 7 "|'..string.rep("l",r)..'" 383 280 0 0 10')
			end
		end
		if Apple.DebugMode[id] ~= 0 then
			local i = Apple.DebugMode[id]
			if player(i, "exists") then
				parse('hudtxt2 '..id..' 20 "©000255000Apple.Mouse1Timer['..i..'] = ©255255255'..Apple.Mouse1Timer[i]..'" 10 100')
				parse('hudtxt2 '..id..' 21 "©000255000Apple.Mouse1Pressed['..i..'] = ©255255255'..Apple.Mouse1Pressed[i]..'" 10 115')
				parse('hudtxt2 '..id..' 22 "©000255000Apple.ReloadProcess['..i..'] = ©255255255'..Apple.ReloadProcess[i]..'" 10 130')
				parse('hudtxt2 '..id..' 23 "©000255000Apple.ReloadTimer['..i..'] = ©255255255'..Apple.ReloadTimer[i]..'" 10 145')
				parse('hudtxt2 '..id..' 24 "©000255000Apple.Weapon['..i..'] = ©255255255'..Apple.Weapon[i]..'" 10 160')
				parse('hudtxt2 '..id..' 25 "©000255000Apple.WeaponName = ©255255255'..Apple.Weapons[Apple.Weapon[i]].name..'" 10 175')
				if Apple.Ammo[i][Apple.Weapon[i]][1] then
					parse('hudtxt2 '..id..' 26 "©000255000Apple.Ammo['..i..']['..Apple.Weapon[i]..'][1] = ©255255255'..Apple.Ammo[i][Apple.Weapon[i]][1]..'" 10 190')
				else
					parse('hudtxt2 '..id..' 26 "©000255000Apple.Ammo['..i..']['..Apple.Weapon[i]..'][1] = ©255255255NONE" 10 190')
				end
				if Apple.Ammo[i][Apple.Weapon[i]][2] then
					parse('hudtxt2 '..id..' 27 "©000255000Apple.Ammo['..i..']['..Apple.Weapon[i]..'][2] = ©255255255'..Apple.Ammo[i][Apple.Weapon[i]][2]..'" 10 205')
				else
					parse('hudtxt2 '..id..' 27 "©000255000Apple.Ammo['..i..']['..Apple.Weapon[i]..'][2] = ©255255255NONE" 10 205')
				end
				parse('hudtxt2 '..id..' 28 "©000255000Apple.ChargeMode['..i..'] = ©255255255'..Apple.ChargeMode[i]..'" 10 220')
				parse('hudtxt2 '..id..' 29 "©000255000Apple.ChargeTimer['..i..'] = ©255255255'..Apple.ChargeTimer[i]..'" 10 235')
			else
				Apple.DebugMode[id] = 0
			end
		end
		if Apple.InWater[id] == 1 then
			if Apple.OxygenSoundTimer[id] <= 0 then
				Apple.OxygenSoundTimer[id] = math.random(30,40)
				parse('sv_sound2 '..id..' "apple/hl2d/player/pl_swim'..math.random(1,3)..'.wav"')
			end
			Apple.OxygenSoundTimer[id] = Apple.OxygenSoundTimer[id] - 1
			if Apple.Oxygen[id] > 0 then
				Apple.Oxygen[id] = Apple.Oxygen[id] - 1
				imagescale(Apple.IMG[id][11], 120*(Apple.Oxygen[id]/150), 11)
				imagepos(Apple.IMG[id][11], 365 + (60*(Apple.Oxygen[id]/150)), 215, 0)
				parse('hudtxt2 '..id..' 32 "©255255255%'..math.floor(100*(Apple.Oxygen[id]/150))..'" 425 211 1 0 8')
			else
				if Apple.OxygenHitTimer[id] <= 0 then
					Apple.OxygenHitTimer[id] = 10
					Apple.DamagePlayer(0, id, 10, 100)
					parse('sv_sound2 '..id..' "player/hit'..math.random(1,3)..'.wav"')
				else
					Apple.OxygenHitTimer[id] = Apple.OxygenHitTimer[id] - 1
				end
			end
		end
end

function Apple.ActivateChargeZone(k)
	if Apple.ChargeZone[k].offline == 1 then
		Apple.ChargeZone[k].offline = 0
		Apple.ChargeZone[k].energy = 75
		freeimage(Apple.ChargeZone[k].img)
	end
end

function Apple.SetArrowImg(id, dmg)
	local alpha = 0
	if dmg <= 20 then
		alpha = dmg/20
	else
		alpha = 1
	end
	local tw_alp = 1200*alpha
	for k = 1, 4 do
		local img = Apple.IMG[id][5+k]
		imagealpha(img, alpha)
		tween_alpha(img, tw_alp, 0)
	end
end

function Apple.GetInWater(id)
	local img1= image("gfx/apple/1x1.png",425,215,2,id)
	imagescale(img1, 120, 12)
	imagecolor(img1, 0, 0, 0)
	imagealpha(img1, 0.7)
	local img2= image("gfx/apple/1x1.png",425,215,2,id)
	imagescale(img2, 120, 11)
	imagecolor(img2, 0, 255, 255)
	imagealpha(img2, 0.7)
parse('hudtxt2 '..id..' 31 "©128255255Oxygen" 425 196 1 0 10')
parse('hudtxt2 '..id..' 32 "©255255255%100" 425 211 1 0 8')
Apple.IMG[id][10] = img1
Apple.IMG[id][11] = img2
Apple.InWater[id] = 1
Apple.Oxygen[id] = 150
Apple.OxygenHitTimer[id] = 10
Apple.OxygenSoundTimer[id] = math.random(30,40)
local newspeed = -10
	if Apple.Jump[id] == 0 then
	local n = Apple.Weapon[id]
		if Apple.WeaponSpeed[n] then
			parse('speedmod '..id..' '..newspeed+Apple.WeaponSpeed[n])
		else
			parse('speedmod '..id..' '..newspeed)
		end
	end
Apple.PlayerSpeed[id]=newspeed
end

function Apple.GaussRecoil(id, power)
	if power == 0 then
		parse('sv_stopsound "apple/hl2d/weapons/gauss_spinup.ogg" '..id)
		Apple.WeaponVar[id][4] = 1
		Apple.WeaponVar[id][3] = 0
		Apple.WeaponVar[id][2] = 0
		Apple.WeaponVar[id][1] = 0
		return
	end
	local x, y = player(id, "x"), player(id, "y")
	Apple.Jump[id] = 6+(power/1.5)
	Apple.Jumpx[id] = x
	Apple.Jumpy[id] = y
	Apple.JumpRot[id] = math.rad(player(id, "rot")+180)
	parse("speedmod "..id.." -100")
	Apple.FootStep[id] = 1
	Apple.StepTimer[id] = 0
	imageframe(Apple.IMG[id][2], 1)
	Apple.GaussLaser(id, 1)
	Apple.WeaponVar[id][4] = 1
	Apple.WeaponVar[id][3] = 0
	Apple.WeaponVar[id][2] = 0
	Apple.WeaponVar[id][1] = 0
	Apple.WeaponVar[id][5] = 1
	timer(1000, "parse", "lua Apple.WeaponVar["..id.."][5]=0")
	parse('sv_stopsound "apple/hl2d/weapons/gauss_spinup.ogg" '..id)
	parse('sv_soundpos "'..Apple.Weapons[9].shoot_sound..'" '..player(id, "x")..' '..player(id, "y"))
	if math.random(1,3) == 1 then
		parse('sv_soundpos "apple/hl2d/weapons/electro'..math.random(1, 2)..'.wav" '..player(id, "x")..' '..player(id, "y"))
	end
end

function Apple.GaussLoadFunc(p)
	local id = tonumber(p)
	if Apple.WeaponVar[id][1] == 0 then return end
	local power, g_ammo, g_timer = Apple.WeaponVar[id][2], Apple.Ammo[id][8][1], Apple.WeaponVar[id][3]
	if g_timer < 40 then
		if g_ammo > 0 then
			if power < 20 then
				Apple.WeaponVar[id][2] = power + 1
				Apple.Ammo[id][8][1] = g_ammo - 1
				Apple.LoadAmmoHud(id)
			end
			timer(200, "Apple.GaussLoadFunc", id)
		else
			Apple.GaussRecoil(id, Apple.WeaponVar[id][2])
		end
	else
		Apple.GaussRecoil(id, Apple.WeaponVar[id][2])
	end
end

function Apple.HornetSpamShoot(p)
	local id = tonumber(p)
	if Apple.Mouse2Pressed[id] == 0 then return end
	if Apple.Ammo[id][6][1] > 0 then
		Apple.Mouse1Timer[id] = 2
		local x = player(id, "x") + math.sin(math.rad(player(id, "rot"))) * Apple.Weapons[6].shootpos
		local y = player(id, "y") - math.cos(math.rad(player(id, "rot"))) * Apple.Weapons[6].shootpos
		Apple.HornetShot(id, x, y, player(id, "rot"))
		parse('sv_soundpos "'..Apple.Weapons[6].shoot_sound..'" '..player(id, "x")..' '..player(id, "y"))
		Apple.Ammo[id][6][1] = Apple.Ammo[id][6][1] - 1
		Apple.LoadAmmoHud(id)
		Apple.Mouse1Timer[id] = math.floor(Apple.Weapons[6].cooldown/2)
		timer(200, "Apple.HornetSpamShoot", id)
	end
end

function Apple.GlockSpamShoot(p)
	local id = tonumber(p)
	if Apple.Mouse2Pressed[id] == 0 then return end
	if Apple.Ammo[id][2][1] > 0 then
		Apple.Shoot(id, 2, 1)
		timer(300, "Apple.GlockSpamShoot", id)
	end
end

function table.contains(tab, e)
	for k, m in ipairs(tab) do
		if m == e then
			return true
		end
	end
	return false
end
