--이형의 계 - 이중성
--카드군 번호: 0xc86
local m=81243000
local cm=_G["c"..m]
function cm.initial_effect(c)

	--묘지로 보낸다
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(0x02)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.cn1)
	e1:SetCost(cm.co1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(cm.cn2)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	c:RegisterEffect(e2)
	
	--레벨
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_LEVEL)
	e3:SetRange(0x04)
	e3:SetCondition(cm.cn3)
	e3:SetValue(-1)
	c:RegisterEffect(e3)
	
	--엑시즈 소재
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(0x10)
	e4:SetCountLimit(1,m)
	e4:SetTarget(cm.tg4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
end

--묘지로 보낸다
function cm.cn1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0x04,0)==0
end
function cm.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGraveAsCost()
	end
	Duel.SendtoGrave(c,REASON_COST)
end
function cm.tfil0(c)
	return c:IsAbleToGrave() and c:IsSetCard(0xc86) and c:IsType(0x1) and c:IsAttribute(0x10)
end
function cm.tfil1(c)
	return c:IsAbleToHand() and c:IsSetCard(0xc86) and c:IsType(0x2)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfil0,tp,0x01,0,1,nil)
		and Duel.IsExistingMatchingCard(cm.tfil1,tp,0x01,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,0x01)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(cm.tfil0,tp,0x01,0,nil)
	local g2=Duel.GetMatchingGroup(cm.tfil1,tp,0x01,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg1=g1:Select(tp,1,1,nil)
	if #sg1>0 and Duel.SendtoGrave(sg1,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg2=g2:Select(tp,1,1,nil)
		if #sg2>0 then
			Duel.SendtoHand(sg2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg2)
		end
	end
end
--프리체인
function cm.nfil0(c)
	return c:IsFaceup() and c:IsCode(81243070)
end
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return 
		Duel.GetFieldGroupCount(tp,0x04,0)==0 
	and Duel.IsExistingMatchingCard(cm.nfil0,tp,0x100,0,1,nil)
	and Duel.GetTurnPlayer()~=tp and ( ph==PHASE_MAIN1 or ph==PHASE_MAIN2 )
end

--레벨
function cm.nfil1(c)
	return c:IsFaceup() and c:IsAttribute(0x10)
end
function cm.cn3(e)
	return Duel.IsExistingMatchingCard(cm.nfil1,e:GetHandlerPlayer(),0x04,0,1,nil)
end

--엑시즈 소재
function cm.tfil2(c)
	return c:IsFaceup() and c:IsSetCard(0xc86) and c:IsType(TYPE_XYZ)
end
function cm.tfil3(c)
	return c:IsAbleToGrave() and c:IsSetCard(0xc86) and not c:IsCode(m)
end
function cm.tg4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(0x04) and chkc:IsControler(tp) and cm.tfil2(chkc)
	end
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingTarget(cm.tfil2,tp,0x04,0,1,c)
		and Duel.IsExistingMatchingCard(cm.tfil3,tp,0x01,0,1,nil)
		and c:IsCanOverlay()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.tfil2,tp,0x04,0,1,1,c)
	if c:IsLocation(0x10) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,0x01)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) then
		local og=c:GetOverlayGroup()
		if #og>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(tc,Group.FromCards(c))
		local g=Duel.GetMatchingGroup(cm.tfil3,tp,0x01,0,nil)
		if #g>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end
