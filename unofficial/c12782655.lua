--종언룡의 폭주
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetLabel(0)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.cost2)
	e2:SetTarget(s.tar2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.tar3)
	e3:SetOperation(s.op3)
	c:RegisterEffect(e3)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function s.cfil2(c)
	return c:IsCanBeFusionMaterial(nil,MATERIAL_FUSION) and c:IsAbleToGrave()
end
function s.tfil2(c,e,tp,m,chkf)
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_DRAGON)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function s.tfun2(tp,sg,fc)
	return #sg==2
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local chkf=tp
	if chk==0 then
		if e:GetLabel()~=1 then
			return false
		end
		e:SetLabel(0)
		local g=Duel.GetMatchingGroup(s.cfil2,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK,0,nil)
		Fusion.CheckAdditional=s.tfun2
		local res=Duel.IsExistingMatchingCard(s.tfil2,tp,LOCATION_EXTRA,0,1,nil,e,tp,g,chkf)
		Fusion.CheckAdditional=nil
		return res
	end
	local g=Duel.GetMatchingGroup(s.cfil2,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK,0,nil)
	Fusion.CheckAdditional=s.tfun2
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,s.tfil2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,g,chkf)
	local mat=Duel.SelectFusionMaterial(tp,sg:GetFirst(),g,nil,chkf)
	Fusion.CheckAdditional=nil
	Duel.SendtoGrave(mat,REASON_COST)
	e:SetLabel(sg:GetFirst():GetCode())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.ofil2(c,e,tp,code)
	return c:IsCode(code) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=e:GetLabel()
	local tc=Duel.GetFirstMatchingCard(s.ofil2,tp,LOCATION_EXTRA,0,nil,e,tp,code)
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetTarget(s.otar21)
	Duel.RegisterEffect(e1,tp)
end
function s.otar21(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsRace(RACE_DRAGON)
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToHand()
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end