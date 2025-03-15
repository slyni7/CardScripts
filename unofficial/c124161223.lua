--스피나스피 라스 니드헬
local s,id=GetID()
function s.initial_effect(c)
	--fusion
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsSetCard,0xf2e),aux.FilterBoolFunctionEx(Card.IsSummonLocation,LOCATION_EXTRA))
	--effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.con1)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	--effect 2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,{id,1})
	e2:SetCondition(s.con2)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
end

--effect 1
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainNegatable(ev)
end

function s.tg1ffilter(c)
	return c:IsSetCard(0xf2e) and c:IsType(TYPE_FUSION) and c:IsFaceup()
end

function s.tg1filter(c,tp)
	return c:IsSetCard(0xf2e) or Duel.GetMatchingGroupCount(s.tg1ffilter,tp,0,LOCATION_MZONE,nil)>0
end

function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
end

function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,s.op1op)
end

function s.op1op(e,tp,eg,ep,ev,re,r,rp)
	local ig=Duel.GetMatchingGroup(s.tg1filter,tp,LOCATION_HAND,0,nil,tp)
	local og=Duel.GetMatchingGroup(s.tg1filter,tp,0,LOCATION_HAND,nil,1-tp)
	if #ig>0 or #og>0 then
		Duel.ConfirmCards(1-tp,Duel.GetFieldGroup(tp,LOCATION_HAND,0))
		Duel.ConfirmCards(tp,Duel.GetFieldGroup(tp,0,LOCATION_HAND))
		local isg=aux.SelectUnselectGroup(ig,e,tp,0,1,aux.TRUE,1,1-tp,HINTMSG_TOGRAVE)
		local osg=aux.SelectUnselectGroup(og,e,tp,0,1,aux.TRUE,1,tp,HINTMSG_TOGRAVE)
		Duel.SendtoGrave(isg+osg,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
		Duel.ShuffleHand(tp)
	end
end

--effect 2
function s.con2filter(c,tp)
	return c:IsControler(tp) and c:IsPreviousControler(1-tp) and c:IsPreviousLocation(LOCATION_HAND) and c:IsSetCard(0xf2e)
end

function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.con2filter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end

function s.tg2filter(c,e)
	return c:IsCanBeEffectTarget(e) and c:IsAbleToHand() and not c:IsType(TYPE_EXTRA)
end

function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and s.tg2filter(chkc,e) end
	local g=Duel.GetMatchingGroup(s.tg2filter,tp,0,LOCATION_GRAVE,nil,e)
	if chk==0 then return #g>0 end
	local sg=aux.SelectUnselectGroup(g,e,tp,1,1,aux.TRUE,1,tp,HINTMSG_ATOHAND)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
end

function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFirstTarget()
	if tg:IsRelateToEffect(e) then
		Duel.SendtoHand(tg,tp,REASON_EFFECT)
	end
end