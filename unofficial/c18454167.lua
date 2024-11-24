--청춘(푸른 실)의 파노라마
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.con1)
	e1:SetTarget(s.tar1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(18454166)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE,EFFECT_FLAG2_MAJESTIC_MUST_COPY)
	e2:SetLabelObject(e1)
	e2:SetLabel(id)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(s.con3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCountLimit(1,{id,1})
	e4:SetCost(s.cost4)
	e4:SetTarget(s.tar4)
	e4:SetOperation(s.op4)
	c:RegisterEffect(e4)
end
s.listed_series={0xc04}
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,18454169)
end
function s.tfil1(c)
	return c:IsSetCard(0xc04) and c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.tfil1,tp,LOCATION_DECK,0,1,nil)
	end
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.tfil1,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	aux.ToHandOrElse(tc,tp)
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,18454169)
end
function s.cost4(e,tg,ep,ev,re,r,rp,chk)
	e:SetLabel(10000)
	return true
end
function s.cfil4(c,e,tp)
	if not (c:IsHasEffect(18454166) and not c:IsCode(id) and c:IsAbleToGraveAsCost() and c:IsSetCard(0xc04)) then 
		return false
	end
	local eff={c:GetCardEffect(18454166)}
	for _,teh in ipairs(eff) do
		local te=teh:GetLabelObject()
		local con=te:GetCondition()
		local tg=te:GetTarget()
		if (not con or con(te,tp,Group.CreateGroup(),PLAYER_NONE,0,teh,REASON_EFFECT,PLAYER_NONE,0)) 
			and (not tg or tg(te,tp,Group.CreateGroup(),PLAYER_NONE,0,teh,REASON_EFFECT,PLAYER_NONE,0)) then
			return true
		end
	end
	return false
end
function s.tar4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return false
	end
	if chk==0 then
		if e:GetLabel()~=10000 then
			return false
		end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(s.cfil4,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfil4,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.SendtoGrave(g,REASON_COST)
	local tc=g:GetFirst()
	local eff={tc:GetCardEffect(18454166)}
	local te=nil
	local acd={}
	local ac={}
	for _,teh in ipairs(eff) do
		local temp=teh:GetLabelObject()
		local con=temp:GetCondition()
		local tg=temp:GetTarget()
		if (not con or con(temp,tp,Group.CreateGroup(),PLAYER_NONE,0,teh,REASON_EFFECT,PLAYER_NONE,0)) 
			and (not tg or tg(temp,tp,Group.CreateGroup(),PLAYER_NONE,0,teh,REASON_EFFECT,PLAYER_NONE,0)) then
			table.insert(ac,teh)
			table.insert(acd,temp:GetDescription())
		end
	end
	if #ac==1 then
		te=ac[1]
	elseif #ac>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		op=Duel.SelectOption(tp,table.unpack(acd))
		op=op+1
		te=ac[op]
	end
	if not te then
		return
	end
	local teh=te
	te=teh:GetLabelObject()
	e:SetProperty(te:GetProperty())
	e:SetLabel(te:GetLabel())
	e:SetLabelObject(te:GetLabelObject())
	local tg=te:GetTarget()
	if tg then
		tg(e,tp,eg,ep,ev,re,r,rp,1)
	end
	te:SetLabel(e:GetLabel())
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	e:SetLabel(te:GetLabel())
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then
		op(e,tp,eg,ep,ev,re,r,rp)
	end
	te:SetLabel(e:GetLabel())
	te:SetLabelObject(e:GetLabelObject())
end