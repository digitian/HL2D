-- Script by CrazyBooy (#35577)

Apple = {}

Apple.Dir = "sys/lua/hl2d"
dofile(Apple.Dir.."/config.lua")
dofile(Apple.Dir.."/variables.lua")
dofile(Apple.Dir.."/functions.lua")
dofile(Apple.Dir.."/operators.lua")

Apple.LoadRadar()
Apple.AnalyseMap()

addbind("R")
addbind("space")
addbind("mouse1")
addbind("mouse2")
addbind("E")

addhook("always", "Apple.TimerHook")
addhook("attack", "Apple.AttackHook")
addhook("build", "Apple.BuildHook")
addhook("die", "Apple.DieHook")
addhook("drop", "Apple.ReturnHook")
addhook("hit", "Apple.HitHook")
addhook("join", "Apple.JoinHook")
addhook("key", "Apple.KeyHook")
addhook("leave", "Apple.LeaveHook")
addhook("move", "Apple.MoveHook")
addhook("movetile", "Apple.MoveTileHook")
addhook("ms100", "Apple.Timer2Hook")
addhook("objectkill", "Apple.ObjectKillHook")
addhook("say", "Apple.SayHook")
addhook("select", "Apple.SelectHook")
addhook("spawn", "Apple.SpawnHook")
addhook("startround", "Apple.StartRoundHook")
addhook("suicide", "Apple.ReturnHook")