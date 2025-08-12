--not fully implemented

local e1=Effect.GlobalEffect()
e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
e1:SetCode(EVENT_STARTUP)
e1:SetOperation(function()
	if Duel.GetLP(0)==1 and Duel.GetLP(1)==1 then
		--Debug.SetPlayerInfo(0,1,5,1)
		--Debug.SetPlayerInfo(1,1,5,1)
		Duel.SetLP(0,8000)
		Duel.SetLP(1,8000)
		local p0=Duel.GetPlayersCount(0)
		for i=1,p0 do
			Duel.ShuffleExtra(0)
			if p0>1 then
				Duel.TagSwap(0)
			end
		end
		local p1=Duel.GetPlayersCount(1)
		for i=1,p1 do
			Duel.ShuffleExtra(1)
			if p1>1 then
				Duel.TagSwap(1)
			end
		end
		Duel.Readjust()
	end
end)
Duel.RegisterEffect(e1,0)