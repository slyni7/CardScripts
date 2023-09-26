CUSTOMTYPE_LIFT=0x80000000
--REASON_LIFT=0x500
--SUMMON_TYPE_LIFT=0x4000c000

EFFECT_MUST_BE_BMATERIAL=123450000

local e1=Effect.GlobalEffect()
e1:SetType(EFFECT_TYPE_FIELD)
e1:SetCode(EFFECT_MUST_USE_MZONE)
e1:SetTargetRange(LOCATION_EXTRA,LOCATION_EXTRA)
e1:SetTarget(function(e,c)
	return c:IsCustomType(CUSTOMTYPE_LIFT)
end)
e1:SetValue(function(e,c,fp,rp,r)
	return 0x40004
end)
Duel.RegisterEffect(e1,0)

function Auxiliary.AddLiftProcedure(c,f,circle)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	--e1:SetValue(SUMMON_TYPE_LIFT)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetDescription(aux.Stringid(123450000,0))
	e1:SetCondition(Auxiliary.LiftCondition(f,circle))
	e1:SetTarget(Auxiliary.LiftTarget(f,circle))
	e1:SetOperation(Auxiliary.LiftOperation(f,circle))
	c:RegisterEffect(e1)
	local mt=getmetatable(c)
	mt.CardType_Lift=true
	return e1
end

function Auxiliary.LiftConditionFilter(c,bc)
	return c:IsFaceup() --and c:IsCanBeLiftMaterial(bc)
end
function Auxiliary.LiftCheckGoal(sg,tp,lc,f,circle)
	local tc=sg:GetFirst()
	return (tc:GetLevel()==lc:GetLevel()-circle or tc:GetLevel()==lc:GetLevel()+circle) and (not f or f(tc))
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0
end
function Auxiliary.LiftCondition(f,circle)
	return
		function(e,c)
			if c==nil then
				return true
			end
			if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then
				return false
			end
			local tp=c:GetControler()
			local mg=Duel.GetMatchingGroup(Auxiliary.LiftConditionFilter,tp,LOCATION_MZONE,0,nil,c)
		--	local fg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LIFT_MATERIAL)
		--	if fg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then
		--		return false
		--	end
		--	Duel.SetSelectedCard(fg)
			return mg:CheckSubGroup(Auxiliary.LiftCheckGoal,1,1,tp,c,f,circle)
		end
end
function Auxiliary.LiftTarget(f,circle)
	return
		function(e,tp,eg,ep,ev,re,r,rp,chk,c)
			local mg=Duel.GetMatchingGroup(Auxiliary.LiftConditionFilter,tp,LOCATION_MZONE,0,nil,c)
		--	local fg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LIFT_MATERIAL)
		--	Duel.SetSelectedCard(fg)
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(123450000,1))
			local cancel=Duel.IsSummonCancelable()
			local sg=mg:SelectSubGroup(tp,Auxiliary.LiftCheckGoal,cancel,1,1,tp,c,f,circle)
			if sg then
				sg:KeepAlive()
				e:SetLabelObject(sg)
				return true
			else
				return false
			end
		end
end
function Auxiliary.LiftOperation(f,circle)
	return
		function(e,tp,eg,ep,ev,re,r,rp,c)
			local g=e:GetLabelObject()
			c:SetMaterial(g)
			Duel.SetLP(tp,Duel.GetLP(tp)-c:GetAttack())
			Duel.SendtoGrave(g,REASON_MATERIAL)
		--	local tc=g:GetFirst()
		--	while tc do
		--		Duel.RaiseSingleEvent(tc,EVENT_BE_MATERIAL,e,REASON_LIFT,tp,tp,0)
		--		tc=g:GetNext()
		--	end
		--	Duel.RaiseEvent(g,EVENT_BE_MATERIAL,e,REASON_LIFT,tp,tp,0)
			g:DeleteGroup()
		end
end

--융합 타입 삭제

	local type=Card.GetType
	Card.GetType=function(c)
	if c.CardType_Lift then
		return bit.bor(type(c),TYPE_FUSION)-TYPE_FUSION
	end
	return type(c)
end
--
	local otype=Card.GetOriginalType
	Card.GetOriginalType=function(c)
	if c.CardType_Lift then
		return bit.bor(otype(c),TYPE_FUSION)-TYPE_FUSION
	end
	return otype(c)
end
--
	local ftype=Card.GetFusionType
	Card.GetFusionType=function(c)
	if c.CardType_Lift then
		return bit.bor(ftype(c),TYPE_FUSION)-TYPE_FUSION
	end
	return ftype(c)
end
--
	local ptype=Card.GetPreviousTypeOnField
	Card.GetPreviousTypeOnField=function(c)
	if c.CardType_Lift then
		return bit.bor(ptype(c),TYPE_FUSION)-TYPE_FUSION
	end
	return ptype(c)
end
--
	local itype=Card.IsType
	Card.IsType=function(c,t)
	if c.CardType_Lift then
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
	if c.CardType_Lift then
		if t==TYPE_FUSION then
			return false
		end
		return iftype(c,bit.bor(t,TYPE_FUSION)-TYPE_FUSION)
	end
	return iftype(c,t)
end