--
function c17300004.initial_effect(c)
	--fusion material
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0x2d1),2,true)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--destroy and set
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,17300004)
	e1:SetCost(c17300004.cost1)
	e1:SetTarget(c17300004.tar1)
	e1:SetOperation(c17300004.op1)
	c:RegisterEffect(e1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,17299996)
	e1:SetTarget(c17300004.tar2)
	e1:SetOperation(c17300004.op2)
	c:RegisterEffect(e1)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17300004,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,17299996)
	e1:SetCondition(c17300004.con3)
	e1:SetCost(c17300004.cost3)
	e1:SetTarget(c17300004.tar3)
	e1:SetOperation(c17300004.op3)
	c:RegisterEffect(e1)
	--pendulum
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(17300004,2))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetCondition(c17300004.con4)
	e6:SetTarget(c17300004.tar4)
	e6:SetOperation(c17300004.op4)
	c:RegisterEffect(e6)
	Duel.AddCustomActivityCounter(17300004,ACTIVITY_SPSUMMON,c17300004.counterfilter)
end
c17300004.listed_series={0x2d1}
function c17300004.counterfilter(c)
	return c:IsSetCard(0x2d1)
end
function c17300004.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(17300004,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c17300004.splimit)
	e1:SetLabelObject(e)
	Duel.RegisterEffect(e1,tp)
end
function c17300004.splimit(e,c)
	return not c:IsSetCard(0x2d1)
end
function c17300004.desfilter(c,tp)
	if c:IsFacedown() then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft==0 and c:IsLocation(LOCATION_SZONE) and c:GetSequence()<5 then
		return Duel.IsExistingMatchingCard(c17300004.filter,tp,LOCATION_DECK,0,1,nil,true)
	else
		return Duel.IsExistingMatchingCard(c17300004.filter,tp,LOCATION_DECK,0,1,nil,false)
	end
end
function c17300004.filter(c,ignore)
	return c:IsSetCard(0x2d1) and c:IsType(TYPE_SPELL) and c:IsSSetable(ignore)
end
function c17300004.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c17300004.desfilter(chkc,tp) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c17300004.desfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c17300004.desfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler(),tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c17300004.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) then
		return
	end
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c17300004.filter,tp,LOCATION_DECK,0,1,1,nil,false)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end
function c17300004.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsOnField() and chkc:IsType(TYPE_SPELL+TYPE_TRAP) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsType,tp,0,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c17300004.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c17300004.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c17300004.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c17300004.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c17300004.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c17300004.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c17300004.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c17300004.op4(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end