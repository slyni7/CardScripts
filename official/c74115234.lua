--八尺勾玉
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsType,TYPE_SPIRIT))
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.recon)
	e2:SetTarget(s.retg)
	e2:SetOperation(s.reop)
	c:RegisterEffect(e2)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(s.retcon)
	e4:SetTarget(s.rettg)
	e4:SetOperation(s.retop)
	c:RegisterEffect(e4)
end
function s.recon(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	local bc=ec:GetBattleTarget()
	e:SetLabelObject(bc)
	return e:GetHandler():GetEquipTarget()==eg:GetFirst() and ec:IsControler(tp)
		and bc:IsLocation(LOCATION_GRAVE) and bc:IsMonster() and bc:IsReason(REASON_BATTLE) 
end
function s.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local v=e:GetLabelObject():GetBaseAttack()
	if v<0 then v=0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(v)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,v)
end
function s.reop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetPreviousEquipTarget()
	return c:IsReason(REASON_LOST_TARGET) and ec and ec:IsLocation(LOCATION_HAND) and ec:IsPreviousControler(tp)
end
function s.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
