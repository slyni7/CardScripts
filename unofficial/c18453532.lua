--신화룡정점
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,nil,nil,2,nil,nil,nil,nil,false,s.pfun1)
	local e1=MakeEff(c,"F","E")
	e1:SetCode(EFFECT_EXTRA_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET|EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTR(1,1)
	e1:SetOperation(s.op1)
	e1:SetValue(s.val1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"I","M")
	e3:SetCategory(CATEGORY_SUMMON+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3,false,REGISTER_FLAG_DETACH_XMAT)
end
function s.pffil1(c)
	return c:IsType(TYPE_NORMAL) and c:IsRace(RACE_WYRM)
end
function s.pfun1(g,tp,xyz)
	if g:IsExists(s.pffil1,1,nil) then
		local g1=g:Filter(Card.IsXyzLevel,nil,xyz,10)
		local g2=g-g1
		if #g2>1 then
			return false
		end
		local tc=g2:GetFirst()
		return tc==nil or s.pffil1(tc)
	end
	return g:FilterCount(Card.IsLoc,nil,"M")==#g and g:FilterCount(Card.IsXyzLevel,nil,xyz,10)==#g
end
s.g1=nil
function s.op1(c,e,tp,sg,mg,lc,og,chk)
	return not s.g1 or #(sg&s.g1)>0
end
function s.val1(chk,summon_type,e,...)
	if chk==0 then
		local tp,sc=...
		if summon_type~=SUMMON_TYPE_XYZ or sc~=e:GetHandler() then
			return Group.CreateGroup()
		else
			s.g1=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND,0,nil)
			s.g1:KeepAlive()
			return s.g1
		end
	elseif chk==2 then
		if s.g1 then
			s.g1:DeleteGroup()
		end
		s.g1=nil
	end
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_XYZ)
end
function s.tfil2(c)
	return c:IsCode(18453527) and c:IsAbleToHand()
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil2,tp,"DG",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"DG")
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,aux.NecroValleyFilter(s.tfil2),tp,"DG",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:CheckRemoveOverlayCard(tp,1,REASON_COST)
	end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.tfil3(c)
	return c:IsCode(18453527) and c:IsSummonable(true,nil)
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil3,tp,"HM",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_SUMMON,nil,1,0,0)
end
function s.ofil3(c)
	return c:IsRace(RACE_WYRM) and c:IsFaceup()
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SMCard(tp,s.tfil3,tp,"HM",0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
		if c:IsRelateToEffect(e) then
			local e1=MakeEff(c,"S")
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(1800)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			e2:SetValue(1500)
			c:RegisterEffect(e2)
			local eset={c:IsHasEffect(id)}
			if #eset==0 then
				local e3=MakeEff(c,"S")
				e3:SetCode(EFFECT_EXTRA_ATTACK)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				e3:SetValue(s.oval33)
				c:RegisterEffect(e3)
			end
			local e4=MakeEff(c,"S")
			e4:SetCode(id)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e4)
		end
	end
end
function s.oval33(e)
	local c=e:GetHandler()
	local eset={c:IsHasEffect(id)}
	return #eset
end