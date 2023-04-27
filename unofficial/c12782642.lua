--싱크로스 홀리데이
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost1)
	e1:SetTarget(s.tar1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.tar2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
end
function s.cfil11(c)
	return c:IsSetCard(0xad1) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.cfun11(tp,f,minc,maxc,use_hand,check,ex,...)
	local params={...}
	if type(maxc)~="number" then
		table.insert(params,1,ex)
		maxc,use_hand,check,ex=minc,maxc,use_hand,check
	end
	if not ex then
		ex=Group.CreateGroup()
	end
	local relg=Duel.GetMatchingGroup(s.cfil11,tp,LOCATION_HAND,0,nil)
	relg:Merge(Duel.GetReleaseGroup(tp,true))
	local mg=relg:Match(f and f or aux.TRUE,ex,table.unpack(params))
	local g,exg=mg:Split(Auxiliary.ReleaseCostFilter,nil,tp)
	local specialchk=Auxiliary.MakeSpecialCheck(check,tp,exg,table.unpack(params))
	local mustg=g:Match(function(c,tp)
		return c:IsHasEffect(EFFECT_EXTRA_RELEASE) and c:IsControler(1-tp)
	end,nil,tp)
	local sg=Group.CreateGroup()
	return mg:Includes(mustg) and mg:IsExists(Auxiliary.RelCheckRecursive,1,nil,tp,sg,mg,exg,mustg,0,minc,maxc,specialchk)
end
function s.cfun12(tp,f,minc,maxc,use_hand,check,ex,...)
	if not ex then
		ex=Group.CreateGroup()
	end
	local relg=Duel.GetMatchingGroup(s.cfil11,tp,LOCATION_HAND,0,nil)
	relg:Merge(Duel.GetReleaseGroup(tp,true))
	local mg=relg:Match(f and f or aux.TRUE,ex,...)
	local g,exg=mg:Split(Auxiliary.ReleaseCostFilter,nil,tp)
	local specialchk=Auxiliary.MakeSpecialCheck(check,tp,exg,...)
	local mustg=g:Match(function(c,tp)
		return c:IsHasEffect(EFFECT_EXTRA_RELEASE) and c:IsControler(1-tp)
	end,nil,tp)
	local sg=Group.CreateGroup()
	local cancel=false
	sg:Merge(mustg)
	while #sg<maxc do
		local cg=mg:Filter(Auxiliary.RelCheckRecursive,sg,tp,sg,mg,exg,mustg,#sg,minc,maxc,specialchk)
		if #cg==0 then break end
		cancel=Auxiliary.RelCheckGoal(tp,sg,exg,mustg,#sg,minc,maxc,specialchk)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local tc=Group.SelectUnselect(cg,sg,tp,cancel,cancel,1,1)
		if not tc then break end
		if #mustg==0 or not mustg:IsContains(tc) then
			if not sg:IsContains(tc) then
				sg=sg+tc
			else
				sg=sg-tc
			end
		end
	end
	if #sg==0 then return sg end
	if  #(sg&exg)>0 then
		local eff=(sg&exg):GetFirst():IsHasEffect(EFFECT_EXTRA_RELEASE_NONSUM)
		if eff then
			eff:UseCountLimit(tp,1)
			Duel.Hint(HINT_CARD,0,eff:GetHandler():GetCode())
		end
	end
	return sg
end
function s.cfil12(c,tp)
	return c:IsSetCard(0xad1) or (c:IsType(TYPE_SYNCHRO) and Duel.IsExistingMatchingCard(s.tfil1,tp,LOCATION_REMOVED,0,1,nil))
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		e:SetLabel(0)
		return s.cfun11(tp,s.cfil12,1,1,true,nil,c,tp)
	end
	local g=s.cfun12(tp,s.cfil12,1,1,true,nil,c,tp)
	local tc=g:GetFirst()
	if tc:IsType(TYPE_SYNCHRO) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
	Duel.Release(g,REASON_COST)
end
function s.tfil1(c)
	return c:IsFaceup() and c:IsSetCard(0xad1) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		e:SetLabel(0)
		return Duel.IsPlayerCanDraw(tp,2)
	end
	if e:GetLabel()==1 then
		Duel.SetOperationInfo(0,CATEORY_REMOVE,nil,1,tp,LOCATION_HAND)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,2,REASON_EFFECT)==2 and e:GetLabel()==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.tfil1,tp,LOCATION_REMOVED,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function s.tfil2(c)
	return c:IsFaceup() and c:IsSetCard(0xad1) and c:HasLevel()
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.tfil2(chkc)
	end
	if chk==0 then return Duel.IsExistingTarget(s.tfil2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.tfil2,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local value=tc:GetLevel()
		local op=0
		if value>1 then
			op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
		else
			op=Duel.SelectOption(tp,aux.Stringid(id,3))+1
		end
		if op==0 then
			tc:UpdateLevel(-1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,e:GetHandler())
		elseif op==1 then
			tc:UpdateLevel(1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,e:GetHandler())
		end
	end
end