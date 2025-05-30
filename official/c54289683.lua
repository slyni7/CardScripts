--パワーカプセル
--Power Capsule
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.listed_names={93130021}
function s.filter(c)
	return c:IsFaceup() and c:IsCode(93130021)
end
function s.desfilter(c)
	return c:IsFaceup() and c:IsSpellTrap()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	local t1=Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
	local t2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,TOKEN_OPTION,0,TYPES_TOKEN,tc:GetAttack(),tc:GetDefense(),tc:GetLevel(),tc:GetRace(),tc:GetAttribute())
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(93130021,0))
	if t1 and t2 then
		op=Duel.SelectOption(tp,aux.Stringid(93130021,1),aux.Stringid(93130021,2),aux.Stringid(93130021,3))
	elseif t1 then
		op=Duel.SelectOption(tp,aux.Stringid(93130021,1),aux.Stringid(93130021,2))
	elseif t2 then
		op=Duel.SelectOption(tp,aux.Stringid(93130021,1),aux.Stringid(93130021,3))
		if op==1 then op=2 end
	else op=Duel.SelectOption(tp,aux.Stringid(93130021,1)) end
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,s.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	elseif op==2 then
		local atk=tc:GetAttack()
		local def=tc:GetDefense()
		local lv=tc:GetLevel()
		local race=tc:GetRace()
		local att=tc:GetAttribute()
		local token=Duel.CreateToken(tp,TOKEN_OPTION)
		tc:CreateRelation(token,RESET_EVENT|RESETS_STANDARD)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(s.tokenatk)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(s.tokendef)
		e2:SetLabelObject(tc)
		token:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CHANGE_LEVEL)
		e3:SetValue(s.tokenlv)
		e3:SetLabelObject(tc)
		e3:SetReset(RESET_EVENT|RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e3,true)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CHANGE_RACE)
		e4:SetValue(s.tokenrace)
		e4:SetLabelObject(tc)
		e4:SetReset(RESET_EVENT|RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e4,true)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e5:SetValue(s.tokenatt)
		e5:SetLabelObject(tc)
		e5:SetReset(RESET_EVENT|RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e5,true)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_SELF_DESTROY)
		e6:SetCondition(s.tokendes)
		e6:SetLabelObject(tc)
		e6:SetReset(RESET_EVENT|RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e6,true)
		Duel.SpecialSummonComplete()
	else
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(400)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE)
		tc:RegisterEffect(e1)
	end
end
function s.tokenatk(e,c)
	return e:GetLabelObject():GetAttack()
end
function s.tokendef(e,c)
	return e:GetLabelObject():GetDefense()
end
function s.tokenlv(e,c)
	return e:GetLabelObject():GetLevel()
end
function s.tokenrace(e,c)
	return e:GetLabelObject():GetRace()
end
function s.tokenatt(e,c)
	return e:GetLabelObject():GetAttribute()
end
function s.tokendes(e)
	return not e:GetLabelObject():IsRelateToCard(e:GetHandler())
end