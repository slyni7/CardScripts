--인트로 오렌지
local m=18453108
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"SC")
	e3:SetCode(EVENT_BE_MATERIAL)
	WriteEff(e3,3,"NO")
	c:RegisterEffect(e3)
end
function cm.tfil1(c)
	return c:IsCode(18453110) and c:IsAbleToHand()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil1,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil1,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.nfil3(c)
	return c:IsSummonType(SUMMON_TYPE_DIFFUSION) and c:GetFlagEffect(m)==0
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:FilterCount(cm.nfil3,nil)>0
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=eg:GetFirst()
	while ec do
		if ec:IsSummonType(SUMMON_TYPE_DIFFUSION) and ec:GetFlagEffect(m)==0 then
			local e1=MakeEff(c,"S")
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(1000)
			ec:RegisterEffect(e1,true)
			ec:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0)
		end
		ec=eg:GetNext()
	end
end