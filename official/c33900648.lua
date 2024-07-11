--クリアー・ワールド
--Clear World
local s,id=GetID()
function s.initial_effect(c)
	local fid=c:GetFieldID()
	local copying=c:IsStatus(STATUS_COPYING_EFFECT)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Maintenance cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(function(_,tp) return Duel.IsTurnPlayer(tp) end)
	e2:SetOperation(s.mtop)
	c:RegisterEffect(e2)
	--Adjust
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_FZONE)
	e3:SetOperation(s.adjustop)
	c:RegisterEffect(e3)
	--LIGHT monsters: hand must be revealed
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_PUBLIC)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e4:SetTarget(s.lighttg)
	c:RegisterEffect(e4)
	--DARK monsters: cannot declare attack
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCondition(function(e,tp) return Duel.IsTurnPlayer(tp) and s.PlayerControlsAttributeOrIsAffectedByClearWall(tp,ATTRIBUTE_EARTH) and c:IsHasEffect(id) and not c:HasFlagEffect(id) and (not copying or c:IsFieldID(fid)) end)
	e5:SetOperation(s.desop)
	if copying then
		e5:SetReset(RESET_PHASE|PHASE_END)
	end
	Duel.RegisterEffect(e5,0)
	local e5b=e5:Clone()
	Duel.RegisterEffect(e5b,1)
	--● WATER: Discard 1 card
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,2))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(function(e,tp) return Duel.IsTurnPlayer(tp) and s.PlayerControlsAttributeOrIsAffectedByClearWall(tp,ATTRIBUTE_WATER) and c:IsHasEffect(id) and not c:HasFlagEffect(id+1) and (not copying or c:IsFieldID(fid)) end)
	e6:SetOperation(s.discardop)
	if copying then
		e6:SetReset(RESET_PHASE|PHASE_END)
	end
	Duel.RegisterEffect(e6,0)
	local e6b=e6:Clone()
	Duel.RegisterEffect(e6b,1)
	--● FIRE: Take 1000 damage
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,3))
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetRange(LOCATION_FZONE)
	e7:SetCondition(function(e,tp) return Duel.IsTurnPlayer(tp) and s.PlayerControlsAttributeOrIsAffectedByClearWall(tp,ATTRIBUTE_FIRE) and c:IsHasEffect(id) and not c:HasFlagEffect(id+2) and (not copying or c:IsFieldID(fid)) end)
	e7:SetOperation(s.damop)
	if copying then
		e7:SetReset(RESET_PHASE|PHASE_END)
	end
	Duel.RegisterEffect(e7,0)
	local e7b=e7:Clone()
	Duel.RegisterEffect(e7b,1)
	--● WIND: You must pay 500 Life Points to activate a Spell Card
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(id,2))
	e8:SetCategory(CATEGORY_HANDES)
	e8:SetCode(EVENT_PHASE+PHASE_END)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetRange(LOCATION_FZONE)
	e8:SetCountLimit(1)
	e8:SetCondition(s.hdcon)
	e8:SetTarget(s.hdtg)
	e8:SetOperation(s.hdop)
	c:RegisterEffect(e8)
	--FIRE monsters: take 1000 damage
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(id,3))
	e9:SetCategory(CATEGORY_DAMAGE)
	e9:SetCode(EVENT_PHASE+PHASE_END)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e9:SetRange(LOCATION_FZONE)
	e9:SetCountLimit(1)
	e9:SetCondition(s.damcon)
	e9:SetTarget(s.damtg)
	e9:SetOperation(s.damop)
	c:RegisterEffect(e9)
	--Apply a dummy effect on itself to track whether the card's effects are currently active or not
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetCode(id)
	e10:SetRange(LOCATION_FZONE)
	c:RegisterEffect(e10)
end
function s.maintop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local b1=Duel.CheckLPCost(tp,500)
	local b2=true
	--Pay 500 LP or destroy this card
	local op=b1 and Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,4)},
		{b2,aux.Stringid(id,5)}) or 2
	if op==1 then
		Duel.PayLPCost(tp,500)
	else
		Duel.Destroy(e:GetHandler(),REASON_COST)
	end
end
function s.raccheck(p)
	s[p]=Duel.GetMatchingGroup(Card.IsFaceup,p,LOCATION_MZONE,0,nil):GetBitwiseOr(Card.GetAttribute)
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerAffectedByEffect(0,CARD_CLEAR_VICE_DRAGON) then
		s.raccheck(0)
	else s[0]=0 end
	if not Duel.IsPlayerAffectedByEffect(1,CARD_CLEAR_VICE_DRAGON) then
		s.raccheck(1)
	else s[1]=0 end
end
function s.lighttg(e,c)
	return (s[c:GetControler()]&ATTRIBUTE_LIGHT)~=0
end
function s.darkcon1(e)
	return (s[e:GetHandlerPlayer()]&ATTRIBUTE_DARK)~=0
		and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)>=2
end
function s.darkcon2(e)
	return (s[1-e:GetHandlerPlayer()]&ATTRIBUTE_DARK)~=0
		and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_MZONE)>=2
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return (s[Duel.GetTurnPlayer()]&ATTRIBUTE_EARTH)~=0
end
function s.desfilter(c)
	return c:IsPosition(POS_FACEUP_DEFENSE)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(id,RESETS_STANDARD_PHASE_END,0,1)
	if not s.PlayerIsAffectedByClearWorld(tp,ATTRIBUTE_EARTH)
		or not Duel.IsExistingMatchingCard(Card.IsPosition,tp,LOCATION_MZONE,0,1,nil,POS_FACEUP_DEFENSE) then return end
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsPosition,tp,LOCATION_MZONE,0,1,1,nil,POS_FACEUP_DEFENSE)
	if #g==0 then return end
	Duel.HintSelection(g)
	Duel.Destroy(g,REASON_EFFECT)
end
function s.discardop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(id+1,RESETS_STANDARD_PHASE_END,0,1)
	if not s.PlayerIsAffectedByClearWorld(tp,ATTRIBUTE_WATER)
		or Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 then return end
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT|REASON_DISCARD)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(id+2,RESETS_STANDARD_PHASE_END,0,1)
	if not s.PlayerIsAffectedByClearWorld(tp,ATTRIBUTE_FIRE) then return end
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Damage(tp,1000,REASON_EFFECT)
end