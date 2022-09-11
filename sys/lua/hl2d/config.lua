parse("mp_hud 64")
parse("mp_hudscale 1")
parse("mp_killinfo 0")
parse("mp_hovertext 0")
parse("sv_gamemode 1")
parse("mp_hovertext 1")
parse('sv_rconusers ')
parse('mp_randomspawn 0')

Apple.ITEMSPAWNTIMER = 20000
Apple.CHARGEZONETIMER = 30000
Apple.HPZONETILE = 13
Apple.ENZONETILE = 14
Apple.WeaponSpeed = {0,1,1,5,4,4,5,6,7,8}

Apple.Weapons = {

	[1] = {
	
		name = "Crowbar", hold_img = "gfx/apple/hl2d/weapons/crowbar.bmp<m>", damage = 40, gamewpn = 50, pmode = 1,
		
			},
			
	[2] = {
	
		name = "Glock 9mm Pistol", hold_img = "gfx/apple/hl2d/weapons/glock.bmp", damage = 18, gamewpn = 4, pmode = 4, bullet = 1,
		cooldown = 4, shoot_sound = "apple/hl2d/weapons/glock_shoot.wav", shootpos = 22, clip = 17, maxammo = 100,
		reloadtime = 10, reloadsnd = "weapons/glock_clipout.wav", reload_endsnd = "weapons/glock_clipin.wav",
		ammoframe = 7,
		
			},
			
			
	[3] = {
	
		name = ".357 Magnum", hold_img = "gfx/apple/hl2d/weapons/magnum.bmp<m>", damage = 32, gamewpn = 3, pmode = 4, bullet = 1,
		cooldown = 10, groundimg = "gfx/apple/hl2d/weapons/magnum_d.bmp<m>", shoot_sound = "apple/hl2d/weapons/magnum_shoot.wav",
		clip = 6, maxammo = 36, shootpos = 22, reloadtime = 15, walkoverhud = "gfx/apple/hl2d/huds/bm_item_python.png",
		reloadsnd = "apple/hl2d/weapons/357_reload1.wav", ammoframe = 5,
		
			},
			
	[4] = {
	
		name = "Assault Shotgun.", hold_img = "gfx/apple/hl2d/weapons/shotgun.bmp<m>", damage = 26, gamewpn = 10, pmode = 1, bullet = 2,
		cooldown = 10, groundimg = "gfx/apple/hl2d/weapons/shotgun_d.bmp<m>", shoot_sound = "apple/hl2d/weapons/shotgun_shoot.wav",
		clip = 8, maxammo = 32, shootpos = 30, reloadtime = 20, walkoverhud = "gfx/apple/hl2d/huds/bm_item_spas.png",
		reloadsnd = "weapons/xm1014_clipout.wav", reload_endsnd = "apple/hl2d/weapons/shotgun_cock.wav",
		ammoframe = 2,
		
			},
			
	[5] = {
	
		name = "MP-5", hold_img = "gfx/apple/hl2d/weapons/mp5.bmp<m>", damage = 8, gamewpn = 20, pmode = 1, bullet = 1,
		cooldown = 1, shoot_sound = "apple/hl2d/weapons/hks_shoot.wav", shootpos = 30, clip = 50, maxammo = 250,
		reloadtime = 8, groundimg = "gfx/apple/hl2d/weapons/mp5_d.bmp<m>", walkoverhud = "gfx/apple/hl2d/huds/of_item_mp5.png",
		reloadsnd = "apple/hl2d/weapons/cliprelease1.wav", reload_endsnd = "apple/hl2d/weapons/clipinsert1.wav",
		ammoframe = 7,
		
			},
			
	[6] = {
	
		name = "Hive-Hand", hold_img = "gfx/apple/hl2d/weapons/hornet.png", damage = 10, gamewpn = 22, pmode = 1, bullet = 3,
		cooldown = 4, shoot_sound = "apple/hl2d/weapons/ag_fire1.wav", shootpos = 30, clip = 8, noreloadfunc = true,
		reloadtime = 3, groundimg = "gfx/apple/hl2d/weapons/hornet_d.bmp<m>", walkoverhud = "gfx/apple/hl2d/huds/bm_item_hivehand.png",
		ammoframe = 4,
		
			},
			
	[7] = {
	
		name = "Crossbow", hold_img = "gfx/apple/hl2d/weapons/crossbow.png", damage = 45, gamewpn = 34, pmode = 1, bullet = 1,
		cooldown = 10, shoot_sound = "apple/hl2d/weapons/xbow_fire1.wav", shootpos = 30, clip = 5, maxammo = 25,
		reloadtime = 15, groundimg = "gfx/apple/hl2d/weapons/crossbow_d.bmp<m>", walkoverhud = "gfx/apple/hl2d/huds/bm_item_crossbow.png",
		reloadsnd = "apple/hl2d/weapons/xbow_reload1.wav", ammoframe = 1,
		
			},
			
	[8] = {
	
		name = "Gluon Gun", hold_img = "gfx/apple/hl2d/weapons/egon.png", damage = 20, gamewpn = 46, pmode = 1, bullet = 4,
		cooldown = 1, shoot_sound = "", shootpos = 30, clip = 100, ammoclip = 20, noreloadfunc = true,
		reloadtime = 15, groundimg = "gfx/apple/hl2d/weapons/egon_d.bmp<m>", walkoverhud = "gfx/apple/hl2d/huds/bm_item_gauss.png",
		ammoframe = 12,
		
			},
			
	[9] = {
	
		name = "Gauss Gun", hold_img = "gfx/apple/hl2d/weapons/gauss.png", damage = 30, gamewpn = 30, pmode = 1, bullet = 5,
		cooldown = 4, shoot_sound = "apple/hl2d/weapons/gauss2.wav", shootpos = 32, clip = 100, ammoclip = 20, noreloadfunc = true,
		reloadtime = 15, groundimg = "gfx/apple/hl2d/weapons/gauss_d.bmp<m>", walkoverhud = "gfx/apple/hl2d/huds/bm_item_tau.png",
		ammoframe = 12,
		
			},
			
	[10] = {
	
		name = "RPG", hold_img = "gfx/apple/hl2d/weapons/rpglauncher.png", damage = 150, gamewpn = 47, pmode = 1, bullet = 6,
		cooldown = 4, shoot_sound = "apple/hl2d/weapons/rocketfire1.wav", shootpos = 32, clip = 1, maxammo = 5,
		reloadtime = 20, groundimg = "gfx/apple/hl2d/weapons/rpglauncher_d.bmp<m>", walkoverhud = "gfx/apple/hl2d/huds/bm_item_rpg.png",
		ammoframe = 8,
		
			},
			
	[11] = { -- lightning thrower
	
		},
		
	[12] = { -- Dil
	
		},
		
	[13] = { -- Makineli
	
		},
	
	[14] = { -- Scout
	
		},
		
	[15] = { -- two handed elite
	
		},
		
	[16] = { -- wpn 1
	
		},
		
	[17] = { -- wpn 2
	
		},
	
	[18] = { -- wpn 3
	
		},
			
	[19] = {
	
		name = "Grenade", hold_img = "gfx/apple/hl2d/weapons/grenade.png", damage = 100, gamewpn = 5, pmode = 1, bullet = 7,
		cooldown = 10, shootpos = 25, clip = 5, ammoclip = 5, noreloadfunc = true, reloadtime = 15,
		groundimg = "gfx/apple/hl2d/weapons/grenade_d.bmp<m>", walkoverhud = "gfx/apple/hl2d/huds/bm_item_hk2.png",
		ammoframe = 6,
		
			},
			
	[20] = {
	
		name = "Laser Mine", hold_img = "gfx/apple/hl2d/weapons/lasermine.png", damage = 100, gamewpn = 87, pmode = 1, bullet = 99,
		cooldown = 10, shootpos = 25, clip = 1, ammoclip = 1, noreloadfunc = true, reloadtime = 15, not_for_bot = true,
		groundimg = "gfx/apple/hl2d/weapons/lasermine_d.bmp<m>", walkoverhud = "gfx/apple/hl2d/huds/bm_item_lasermine.png",
		ammoframe = 11,
		
			},
			
	[21] = {
		
		name = "Snark", hold_img = "gfx/apple/hl2d/weapons/snark.png", gamewpn = 21, damage = 10, pmode = 1, bullet = 8,
		cooldown = 5, shootpos = 20, clip = 5, ammoclip = 5, noreloadfunc = true, reloadtime = 0, not_for_bot = true,
		groundimg = "gfx/apple/hl2d/weapons/snark_d.bmp<m>", walkoverhud = "gfx/apple/hl2d/huds/bm_item_snark.png",
		groundimg_scale = 0.8, ammoframe = 10,
		
			},
			
	[22] = {
	
		name = "Satchel Charge", hold_img = "gfx/apple/hl2d/weapons/satchelcharge.png", damage = 60, gamewpn = 89, pmode = 1, bullet = 99,
		cooldown = 10, shootpos = 25, clip = 1, ammoclip = 1, noreloadfunc = true, reloadtime = 15, not_for_bot = true,
		groundimg = "gfx/weapons/satchelcharge.bmp", walkoverhud = "gfx/apple/hl2d/huds/bm_item_satchel.png",
		ammoframe = 9,
		
			},
			
	[24] = {
	
		name = "Medikit", speciality = "health", amount = 15, groundimg = "gfx/apple/hl2d/weapons/medikit.bmp<m>",
		walkoverhud = "gfx/apple/hl2d/huds/bm_hud2_medkit.png",
		
			},
			
	-- [23] = {
	
		-- name = "Battery", speciality = "energy", amount = 15, groundimg = "gfx/apple/hl2d/weapons/medikit.bmp<m>",
		-- walkoverhud = "gfx/apple/hl2d/huds/bm_hud2_medkit.png",
		
			-- },	
	
	[25] = {
		
		name = "Gauss Ammo", ammo = true, amount = 20, groundimg = "gfx/apple/hl2d/weapons/uranium_ammo.bmp", wpn = 8,
		walkoverhud = "gfx/apple/hl2d/huds/bm_ammo_uranium235.png",
		
			},
			
	[26] = {
		
		name = "MP5 Clip", ammo = true, amount = 50, groundimg = "gfx/apple/hl2d/weapons/mp5_clip.bmp", wpn = 5,
		walkoverhud = "gfx/apple/hl2d/huds/bm_ammo_parabellum.png", collectsnd = "apple/hl2d/items/9mmclip1.wav",
		
			},
			
	[27] = {
		
		name = "Shotgun Ammo", ammo = true, amount = 8, groundimg = "gfx/apple/hl2d/weapons/shotgun_ammo.bmp", wpn = 4,
		walkoverhud = "gfx/apple/hl2d/huds/bm_ammo_buckshot.png",
		
			},
			
	[28] = {
		
		name = "Crossbow Ammo", ammo = true, amount = 5, groundimg = "gfx/apple/hl2d/weapons/crossbow_ammo.bmp", wpn = 7,
		walkoverhud = "gfx/apple/hl2d/huds/bm_ammo_arrow.png",
		
			},
			
	[29] = {
		
		name = "Rocket", ammo = true, amount = 2, groundimg = "gfx/apple/hl2d/weapons/rpg_ammo.bmp", wpn = 10,
		walkoverhud = "gfx/apple/hl2d/huds/bm_ammo_rocket.png",
		
			},
			
	[30] = {
		
		name = "Magnum Ammo", ammo = true, amount = 6, groundimg = "gfx/apple/hl2d/weapons/magnum_clip.bmp", wpn = 3,
		walkoverhud = "gfx/apple/hl2d/huds/bm_ammo_magnum.png", collectsnd = "apple/hl2d/items/9mmclip1.wav",
		
			},
			
	-- [40] = {
	
		-- name = "Long Jump", speciality = "longjump", groundimg = "gfx/apple/hl2d/weapons/jumptank.png",
		-- walkoverhud = "gfx/apple/hl2d/huds/bm_hud2_longjump.png", groundimg_scale = 0.8,
		
			-- },
			
	[100] = {
	
		name = "Water",
		
			},
			
		}
