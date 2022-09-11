function Apple.Array(m, v)
	local a = {}
	for i = 1, m do
		a[i] = v
	end
	return a
end

Apple.AntiKeyFlood = Apple.Array(32, 0)
Apple.Jump = Apple.Array(32, 0)
Apple.JumpRot = Apple.Array(32, 0)
Apple.Jumpx = Apple.Array(32, 0)
Apple.Jumpy = Apple.Array(32, 0)
Apple.FootStep = Apple.Array(32,1)
Apple.StepTimer = Apple.Array(32, 0)
Apple.Lastx = Apple.Array(32, 0)
Apple.Lasty = Apple.Array(32, 0)
Apple.LastTilex = Apple.Array(32, 0)
Apple.LastTiley = Apple.Array(32, 0)
Apple.InWater = Apple.Array(32, 0)
Apple.Oxygen = Apple.Array(32, 0)
Apple.OxygenHitTimer = Apple.Array(32, 0)
Apple.OxygenSoundTimer = Apple.Array(32, 0)
Apple.PlayerSpeed = Apple.Array(32, 0)
Apple.Weapon = Apple.Array(32, 0)
Apple.Mouse1Pressed = Apple.Array(32, 0)
Apple.Mouse2Pressed = Apple.Array(32, 0)
Apple.Mouse1Timer = Apple.Array(32, 0)
Apple.ReloadProcess = Apple.Array(32, 0)
Apple.ReloadTimer = Apple.Array(32, 0)
Apple.ReloadPassive = Apple.Array(32, 0)
Apple.Armor = Apple.Array(32, 0)
Apple.ChargeMode = Apple.Array(32, 0)
Apple.ChargeTimer = Apple.Array(32, 0)
Apple.SoundTimer1 = Apple.Array(32, 0)
Apple.DebugMode = Apple.Array(32, 0)
Apple.ChargeZone = {}
Apple.HornetFly = {}
Apple.Snarks = {}
Apple.GroundItems = {}
Apple.Grenades = {}
Apple.WalkoverHuds = {}
Apple.Ammo = {}
Apple.WeaponVar= {}
Apple.IMG = {}
for i = 1, 32 do
	Apple.Ammo[i] = {}
	Apple.IMG[i] = {}
	Apple.WeaponVar[i] = {0, 0, 0, 0, 0} -- (1-5): gauss, 6: hive-hand
	Apple.WalkoverHuds[i] = {}
	for k = 1, #Apple.Weapons do
		if Apple.Weapons[k] and Apple.Weapons[k].damage then
			Apple.Ammo[i][k] = {0, 0}
		end
	end	
	for k = 1, 12 do
		Apple.WalkoverHuds[i][k] = {0, 0, 0}
	end
end