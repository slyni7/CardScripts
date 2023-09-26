function Duel.Release(group,reason)
	return Duel.SendtoGrave(group,reason|REASON_RELEASE)
end

function Auxiliary.AdditionalSungakFilter(c)
	return c:IsSetCard(0x69) and c:IsMonster()
end

function Auxiliary.CheckSungakRelease(tp,f,minc,maxc,use_hand,check,ex,...)
	local params={...}
	if type(maxc)~="number" then
		table.insert(params,1,ex)
		maxc,use_hand,check,ex=minc,maxc,use_hand,check
	end
	if not ex then
		ex=Group.CreateGroup()
	end
	local relg=Duel.GetReleaseGroup(tp,use_hand)
	local mg=relg:Match(f and f or aux.TRUE,ex,table.unpack(params))
	local g,exg=mg:Split(Auxiliary.ReleaseCostFilter,nil,tp)
	local specialchk=Auxiliary.MakeSpecialCheck(check,tp,exg,table.unpack(params))
	local mustg=g:Match(function(c,tp)
		return c:IsHasEffect(EFFECT_EXTRA_RELEASE) and c:IsControler(1-tp)
	end,nil,tp)
	local addg=Duel.GetMatchingGroup(Auxiliary.AdditionalSungakFilter,tp,LOCATION_DECK,0,nil)
	if Duel.IsPlayerAffectedByEffect(tp,119200001) then
		mg:Merge(addg)
	end
	local sg=Group.CreateGroup()
	return mg:Includes(mustg) and mg:IsExists(Auxiliary.RelCheckRecursive,1,nil,tp,sg,mg,exg,mustg,0,minc,maxc,specialchk)
end
function Auxiliary.SelectSungakRelease(tp,f,minc,maxc,use_hand,check,ex,...)
	if not ex then
		ex=Group.CreateGroup()
	end
	local relg=Duel.GetReleaseGroup(tp,use_hand)
	local mg=relg:Match(f and f or aux.TRUE,ex,...)
	local g,exg=mg:Split(Auxiliary.ReleaseCostFilter,nil,tp)
	local specialchk=Auxiliary.MakeSpecialCheck(check,tp,exg,...)
	local mustg=g:Match(function(c,tp)
		return c:IsHasEffect(EFFECT_EXTRA_RELEASE) and c:IsControler(1-tp)
	end,nil,tp)
	local addg=Duel.GetMatchingGroup(Auxiliary.AdditionalSungakFilter,tp,LOCATION_DECK,0,nil)
	if Duel.IsPlayerAffectedByEffect(tp,119200001) then
		mg:Merge(addg)
	end
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
	if  #(sg&addg)>0 then
		Duel.RegisterFlagEffect(tp,119200001,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_CARD,0,119200001)
	end
	return sg
end

local cregeff=Card.RegisterEffect

function Card.RegisterEffect(c,e,...)
	local code=c:GetOriginalCode()
	local mt=_G["c"..code]
	if (code==3300267 or code==31516413) and mt.eff_ct[c][0]==e then
		e:SetCondition(function(e,c)
			if c==nil then
				return true
			end
			local tp=c:GetControler()
			return Auxiliary.CheckSungakRelease(tp,Auxiliary.AdditionalSungakFilter,1,1,false,nil,c)
		end)
		e:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,c)
			local g=Auxiliary.SelectSungakRelease(tp,Auxiliary.AdditionalSungakFilter,1,1,false,nil,c)
			if g then
				g:KeepAlive()
				e:SetLabelObject(g)
				return true
			end
			return false
		end)
	elseif (code==3300267 or code==31516413 or code==24361622) and mt.eff_ct[c][1]==e then
		if code==24361622 then
			e:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then
					return Auxiliary.CheckSungakRelease(tp,mt.thcfilter,1,true,nil,nil,tp)
				end
				local g=Auxiliary.SelectSungakRelease(tp,mt.thcfilter,1,1,true,nil,nil,tp)
				Duel.Release(g,REASON_COST)
			end)
		elseif code==31516413 then
			e:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
				local dg=Duel.GetMatchingGroup(Card.IsCanBeEffectTarget,tp,0,LOCATION_MZONE,nil,e)
				if chk==0 then
					return Auxiliary.CheckSungakRelease(tp,mt.descfilter,1,true,aux.ReleaseCheckTarget,e:GetHandler(),dg)
				end
				local g=Auxiliary.SelectSungakRelease(tp,mt.descfilter,1,1,true,aux.ReleaseCheckTarget,e:GetHandler(),dg)
				Duel.Release(g,REASON_COST)
			end)
		elseif code==3300267 then
			e:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
				local dg=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_ONFIELD,nil,e)
				if chk==0 then
					return Auxiliary.CheckSungakRelease(tp,mt.descfilter,1,true,aux.ReleaseCheckTarget,e:GetHandler(),dg)
				end
				local g=Auxiliary.SelectSungakRelease(tp,mt.descfilter,1,1,true,aux.ReleaseCheckTarget,e:GetHandler(),dg)
				Duel.Release(g,REASON_COST)
			end)
		end
	end
	cregeff(c,e,...)
end