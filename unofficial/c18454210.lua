--재뉴어리 아인
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(10000)
	return true
end
function s.tfil11(c,e,tp)
	return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tfil12(c,e,tp)
	return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:IsSetCard("재뉴어리")
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=(e:GetLabel()==0 or Duel.GetPlayerEffect(tp,EFFECT_JANUARY) or Duel.IEMCard(Card.IsDiscardable,tp,"H",0,101,nil))
		and Duel.IEMCard(s.tfil11,tp,"E",0,1,nil,e,tp)
	local b2=Duel.IEMCard(s.tfil12,tp,"E",0,1,nil,e,tp)
	if chk==0 then
		e:SetLabel(0)
		return b1 or b2
	end
	local discard=e:GetLabel()==10000
	local op=Duel.SelectEffect(tp,{b1,aux.Stringid(id,0)},{b2,aux.Stringid(id,1)})
	e:SetLabel(op)
	if op==1 and discard then
		if Duel.GetPlayerEffect(tp,EFFECT_JANUARY) then
			local eset={Duel.GetPlayerEffect(tp,EFFECT_JANUARY)}
			local je=eset[1]
			Duel.Hint(HINT_CARD,0,je:GetHandler():GetCode())
			je:Reset()
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
			local g=Duel.SMCard(tp,Card.IsDiscardable,tp,"H",0,101,101,nil)
			Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
		end
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"E")
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SMCard(tp,s.tfil11,tp,"E",0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SMCard(tp,s.tfil12,tp,"E",0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
		local e1=MakeEff(c,"F")
		e1:SetCode(EFFECT_JANUARY)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTR(1,0)
		Duel.RegisterEffect(e1,tp)
	end
end