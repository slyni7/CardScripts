CUSTOMTYPE_BRAVE=0x40000000

local e1=Effect.GlobalEffect()
e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
e1:SetCode(EVENT_STARTUP)
e1:SetOperation(function()
	local g=Duel.GetFieldGroup(0,LOCATION_DECK+LOCATION_EXTRA,LOCATION_DECK+LOCATION_EXTRA)
	Duel.ExileMassive(g)
	local token=Duel.CreateToken(1,911883)
	Duel.SendtoHand(token,nil,REASON_EFFECT)
	local token=Duel.CreateToken(1,78387742)
	Duel.SendtoHand(token,nil,REASON_EFFECT)
	local token=Duel.CreateToken(1,37412656)
	Duel.MoveToField(token,1,1,LOCATION_SZONE,POS_FACEDOWN,true,1<<2)
	local token=Duel.CreateToken(1,89943723)
	Duel.SendtoGrave(token,REASON_EFFECT)
	local token=Duel.CreateToken(1,92125819)
	Duel.SendtoDeck(token,nil,2,REASON_EFFECT)
	local token=Duel.CreateToken(1,123450003)
	Duel.SendtoDeck(token,nil,2,REASON_EFFECT)
	local token=Duel.CreateToken(0,99267150)
	Duel.SendtoDeck(token,nil,2,REASON_EFFECT)
	Duel.MoveToField(token,0,0,LOCATION_MZONE,POS_FACEUP_ATTACK,true,1<<5)
	for i=0,4 do
		local token=Duel.CreateToken(0,68299524)
		Duel.MoveToField(token,0,0,LOCATION_MZONE,POS_FACEUP_ATTACK,true,1<<i)
	end
	Duel.SetLP(0,3700)
	Duel.SetLP(1,100)
	aux.BraveZone={}
	local token0=Duel.CreateToken(0,46448938)
	Duel.CreateNullWindow(token0,0|(LOCATION_MZONE<<8)|(63<<16)|(POS_FACEUP_ATTACK<<24))
	aux.BraveZone[0]=token0
	local token1=Duel.CreateToken(1,46448938)
	Duel.CreateNullWindow(token1,1|(LOCATION_MZONE<<8)|(63<<16)|(POS_FACEUP_ATTACK<<24))
	aux.BraveZone[1]=token1
end)
Duel.RegisterEffect(e1,0)

function Auxiliary.AddBraveProcedure(c,f,min,max,gf)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetTargetRange(POS_FACEUP_ATTACK,0)
	e1:SetDescription(aux.Stringid(18453334,0))
	e1:SetCondition(Auxiliary.BraveCondition(f,min,max,gf))
	e1:SetTarget(Auxiliary.BraveTarget(f,min,max,gf))
	e1:SetOperation(Auxiliary.BraveOperation(f,min,max,gf))
	c:RegisterEffect(e1)
	local mt=getmetatable(c)
	mt.CardType_Brave=true
	return e1
end

function Auxiliary.BraveConditionFilter(c,bc,f)
	return c:IsFaceup() and (not f or f(c)) --and c:IsCanBeBraveMaterial(bc)
end
function Auxiliary.BraveCheckGoal(sg,tp,bc,gf,min)
	return (not gf or gf(sg)) and sg:CheckWithSumGreater(Card.GetAttack,bc:GetAttack())
		and not Auxiliary.BraveCheckOverfit(sg,tp,bc,gf,min)
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0
end
function Auxiliary.BraveCheckOverfit(sg,tp,bc,gf,min)
	if #sg==min then
		return false
	end
	local tc=g:GetFirst()
	while tc do
		local tg=sg:Clone()
		tg:RemoveCard(tc)
		if (not gf or gf(tg)) and tg:CheckWithSumGreater(Card.GetAttack,bc:GetAttack()) then
			return true
		end
		tc=g:GetNext()
	end
	return false
end
function Auxiliary.BraveCondition(f,min,max,gf)
	return
		function(e,c)
			if c==nil then
				return true
			end
			if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then
				return false
			end
			local tp=c:GetControler()
			local mg=Duel.GetMatchingGroup(Auxiliary.BraveConditionFilter,tp,LOCATION_MZONE,0,nil,c,f)
		--	local fg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_BRAVE_MATERIAL)
		--	if fg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then
		--		return false
		--	end
		--	Duel.SetSelectedCard(fg)
			return mg:CheckSubGroup(Auxiliary.BraveCheckGoal,min,max,tp,c,gf,min)
		end
end
function Auxiliary.BraveTarget(f,min,max,gf)
	return
		function(e,tp,eg,ep,ev,re,r,rp,chk,c)
			local mg=Duel.GetMatchingGroup(Auxiliary.BraveConditionFilter,tp,LOCATION_MZONE,0,nil,c,f)
		--	local fg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_BRAVE_MATERIAL)
		--	Duel.SetSelectedCard(fg)
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(123450000,1))
			local cancel=Duel.IsSummonCancelable()
			local sg=mg:SelectSubGroup(tp,Auxiliary.BraveCheckGoal,cancel,min,max,tp,c,gf,min)
			if sg then
				sg:KeepAlive()
				e:SetLabelObject(sg)
				return true
			else
				return false
			end
		end
end
function Auxiliary.BraveOperation(f,min,max,gf)
	return
		function(e,tp,eg,ep,ev,re,r,rp,c)
			local g=e:GetLabelObject()
			c:SetMaterial(g)
			local bz=aux.BraveZone[tp]
			local tc=g:GetFirst()
			while tc do
				local og=tc:GetOverlayGroup()
				if #og>0 then
					Duel.SendtoGrave(og,REASON_RULE)
				end
				tc=g:GetNext()
			end
			Duel.Overlay(bz,g)
		--	local tc=g:GetFirst()
		--	while tc do
		--		Duel.RaiseSingleEvent(tc,EVENT_BE_MATERIAL,e,REASON_BRAVE,tp,tp,0)
		--		tc=g:GetNext()
		--	end
		--	Duel.RaiseEvent(g,EVENT_BE_MATERIAL,e,REASON_BRAVE,tp,tp,0)
			g:DeleteGroup()
		end
end

--융합 타입 삭제

	local type=Card.GetType
	Card.GetType=function(c)
	if c.CardType_Brave then
		return bit.bor(type(c),TYPE_FUSION)-TYPE_FUSION
	end
	return type(c)
end
--
	local otype=Card.GetOriginalType
	Card.GetOriginalType=function(c)
	if c.CardType_Brave then
		return bit.bor(otype(c),TYPE_FUSION)-TYPE_FUSION
	end
	return otype(c)
end
--
	local ftype=Card.GetFusionType
	Card.GetFusionType=function(c)
	if c.CardType_Brave then
		return bit.bor(ftype(c),TYPE_FUSION)-TYPE_FUSION
	end
	return ftype(c)
end
--
	local ptype=Card.GetPreviousTypeOnField
	Card.GetPreviousTypeOnField=function(c)
	if c.CardType_Brave then
		return bit.bor(ptype(c),TYPE_FUSION)-TYPE_FUSION
	end
	return ptype(c)
end
--
	local itype=Card.IsType
	Card.IsType=function(c,t)
	if c.CardType_Brave then
		if t==TYPE_FUSION then
			return false
		end
		return itype(c,bit.bor(t,TYPE_FUSION)-TYPE_FUSION)
	end
	return itype(c,t)
end
--
	local iftype=Card.IsFusionType
	Card.IsFusionType=function(c,t)
	if c.CardType_Brave then
		if t==TYPE_FUSION then
			return false
		end
		return iftype(c,bit.bor(t,TYPE_FUSION)-TYPE_FUSION)
	end
	return iftype(c,t)
end