function Auxiliary.NewFindex(findex)
	if findex==nil then
		return nil
	end
	return
		function(...)
			local card_is_code=Card.IsCode
			local card_is_summon_code=Card.IsSummonCode
			Card.IsCode=aux.TRUE
			Card.IsSummonCode=aux.TRUE
			local res1=findex(...)
			Card.IsCode=aux.FALSE
			Card.IsSummonCode=aux.FALSE
			local res2=findex(...)
			Card.IsCode=card_is_code
			Card.IsSummonCode=card_is_summon_code
			return res1 or res2
		end
end

Duel._DiscardHand=Duel.DiscardHand
function Duel.DiscardHand(playerid,findex,...)
	local nex=aux.NewFindex(findex)
	return Duel._DiscardHand(playerid,nex,...)
end

Duel._GetMatchingGroup=Duel.GetMatchingGroup
function Duel.GetMatchingGroup(findex,...)
	local nex=aux.NewFindex(findex)
	return Duel._GetMatchingGroup(nex,...)
end

Duel._GetMatchingGroupCount=Duel.GetMatchingGroupCount
function Duel.GetMatchingGroupCount(findex,...)
	local nex=aux.NewFindex(findex)
	return Duel._GetMatchingGroupCount(nex,...)
end

Duel._GetFirstMatchingCard=Duel.GetFirstMatchingCard
function Duel.GetFirstMatchingCard(findex,...)
	local nex=aux.NewFindex(findex)
	return Duel._GetFirstMatchingCard(nex,...)
end

Duel._IsExistingMatchingCard=Duel.IsExistingMatchingCard
function Duel.IsExistingMatchingCard(findex,...)
	local nex=aux.NewFindex(findex)
	return Duel._IsExistingMatchingCard(nex,...)
end

Duel._SelectMatchingCard=Duel.SelectMatchingCard
function Duel.SelectMatchingCard(playerid,findex,...)
	local nex=aux.NewFindex(findex)
	return Duel._SelectMatchingCard(playerid,nex,...)
end

Duel._CheckReleaseGroup=Duel.CheckReleaseGroup
function Duel.CheckReleaseGroup(playerid,findex,...)
	local nex=aux.NewFindex(findex)
	return Duel._CheckReleaseGroup(playerid,nex,...)
end

Duel._CheckReleaseGroupEx=Duel.CheckReleaseGroupEx
function Duel.CheckReleaseGroupEx(playerid,findex,...)
	local nex=aux.NewFindex(findex)
	return Duel._CheckReleaseGroupEx(playerid,nex,...)
end

Duel._SelectReleaseGroup=Duel.SelectReleaseGroup
function Duel.SelectReleaseGroup(playerid,findex,...)
	local nex=aux.NewFindex(findex)
	return Duel._SelectReleaseGroup(playerid,nex,...)
end

Duel._SelectReleaseGroupEx=Duel.SelectReleaseGroupEx
function Duel.SelectReleaseGroupEx(playerid,findex,...)
	local nex=aux.NewFindex(findex)
	return Duel._SelectReleaseGroupEx(playerid,nex,...)
end

Duel._GetTargetCount=Duel.GetTargetCount
function Duel.GetTargetCount(findex,...)
	local nex=aux.NewFindex(findex)
	return Duel._GetTargetCount(nex,...)
end

Duel._IsExistingTarget=Duel.IsExistingTarget
function Duel.IsExistingTarget(findex,...)
	local nex=aux.NewFindex(findex)
	return Duel._IsExistingTarget(nex,...)
end

Duel._SelectTarget=Duel.SelectTarget
function Duel.SelectTarget(playerid,findex,...)
	local nex=aux.NewFindex(findex)
	return Duel._SelectTarget(playerid,nex,...)
end

Group._Filter=Group.Filter
function Group.Filter(group,findex,...)
	local nex=aux.NewFindex(findex)
	return Group._Filter(group,nex,...)
end

Group._Match=Group.Match
function Group.Match(group,findex,...)
	local nex=aux.NewFindex(findex)
	return Group._Match(group,nex,...)
end

Group._FilterCount=Group.FilterCount
function Group.FilterCount(group,findex,...)
	local nex=aux.NewFindex(findex)
	return Group._FilterCount(group,nex,...)
end

Group._FilterSelect=Group.FilterSelect
function Group.FilterSelect(group,playerid,findex,...)
	local nex=aux.NewFindex(findex)
	return Group._FilterSelect(group,playerid,nex,...)
end

Group._IsExists=Group.IsExists
function Group.IsExists(group,findex,...)
	local nex=aux.NewFindex(findex)
	return Group._IsExists(group,nex,...)
end

Group._GetClass=Group.GetClass
function Group.GetClass(group,findex,...)
	local nex=aux.NewFindex(findex)
	return Group._GetClass(group,nex,...)
end

--[[
Group._GetClassCount=Group.GetClassCount
function Group.GetClassCount(group,findex,...)
	local nex=aux.NewFindex(findex)
	return Group._GetClassCount(group,nex,...)
end
]]--

Group._Remove=Group.Remove
function Group.Remove(group,findex,...)
	local nex=aux.NewFindex(findex)
	return Group._Remove(group,nex,...)
end

Group._SearchCard=Group.SearchCard
function Group.SearchCard(group,findex,...)
	local nex=aux.NewFindex(findex)
	return Group._SearchCard(group,nex,...)
end

Group._Split=Group.Split
function Group.Split(group,findex,...)
	local nex=aux.NewFindex(findex)
	return Group._Split(group,nex,...)
end

Card.IsSetCard=aux.TRUE
Card.IsOriginalSetCard=aux.TRUE
Card.IsPreviousSetCard=aux.TRUE
Card.IsLinkSetCard=aux.TRUE
Card.IsFusionSetCard=aux.TRUE
aux.SilentMajorityLinkCondition1=aux.FALSE
Card._IsCode=Card.IsCode
Card.IsCode=aux.TRUE
Card.IsNotCode=function(c,...)
	if c:_IsCode(...) then
		return false
	end
	return true
end
Card.IsFusionCode=aux.TRUE
Card.IsLinkCode=aux.TRUE
Card._GetCode=Card.GetCode
aux.GlobalClassCheck=false
Card.GetCode=function(c)
	if aux.GlobalClassCheck then
		return c:_GetCode()
	end
	return 0
end
function Duel.GetFirstMatchingCard(f,p,sl,ol,exc,...)
	Duel.Hint(HINT_SELECTMSG,p,0)
	local g=Duel.SelectMatchingCard(p,f,p,sl,ol,1,1,exc,...)
	return g:GetFirst()
end
function Duel.IsEnvironment(code,p,loc)
	local l0=(not p or p==0) and LOCATION_ONFIELD or 0
	local l1=(not p or p==1) and LOCATION_ONFIELD or 0
	return Duel.IsExistingMatchingCard(Card.IsFaceup,0,l0,l1,1,nil)
end
Group._GetClassCount=Group.GetClassCount
function Group.GetClassCount(g,f,...)
	aux.GlobalClassCheck=true
	local ct=g:_GetClassCount(f,...)
	aux.GlobalClassCheck=false
	return ct
end
Group._CheckDifferentProperty=Group.CheckDifferentProperty
function Group.CheckDifferentProperty(g,f,...)
	aux.GlobalClassCheck=true
	local ct=g:_CheckDifferentProperty(f,...)
	aux.GlobalClassCheck=false
	return ct
end
Card.SetUniqueOnField=aux.FALSE
function Auxiliary.IsMaterialListCode(c)
	return c.material
end
function Auxiliary.IsMaterialListSetCard(c)
	return c.material_setcode
end
function Auxiliary.IsCodeListed(c)
	return c.card_code_list
end
Card._AddCounter=Card.AddCounter
function Card.AddCounter(...)
	local t={...}
	t[2]=0x100e
	return Card._AddCounter(table.unpack(t))
end
Card._RemoveCounter=Card.RemoveCounter
function Card.RemoveCounter(...)
	local t={...}
	t[3]=0x100e
	return Card._RemoveCounter(table.unpack(t))
end
Card._GetCounter=Card.GetCounter
function Card.GetCounter(...)
	local t={...}
	t[2]=0x100e
	return Card._GetCounter(table.unpack(t))
end
Card._IsCanAddCounter=Card.IsCanAddCounter
function Card.IsCanAddCounter(...)
	local t={...}
	t[2]=0x100e
	return Card._IsCanAddCounter(table.unpack(t))
end
Card._IsCanRemoveCounter=Card.IsCanRemoveCounter
function Card.IsCanRemoveCounter(...)
	local t={...}
	t[3]=0x100e
	return Card._IsCanRemoveCounter(table.unpack(t))
end
Duel._RemoveCounter=Duel.RemoveCounter
function Duel.RemoveCounter(...)
	local t={...}
	t[4]=0x100e
	return Duel._RemoveCounter(table.unpack(t))
end
Duel._GetCounter=Duel.GetCounter
function Duel.GetCounter(...)
	local t={...}
	t[4]=0x100e
	return Duel._GetCounter(table.unpack(t))
end
Duel._IsCanAddCounter=Duel.IsCanAddCounter
function Duel.IsCanAddCounter(...)
	local t={...}
	t[2]=0x100e
	return Duel._IsCanAddCounter(table.unpack(t))
end
Duel._IsCanRemoveCounter=Duel.IsCanRemoveCounter
function Duel.IsCanRemoveCounter(...)
	local t={...}
	t[4]=0x100e
	return Duel._IsCanRemoveCounter(table.unpack(t))
end
aux.LCheckSilentGoal=aux.FALSE