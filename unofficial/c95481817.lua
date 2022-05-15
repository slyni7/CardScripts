--크로노이드 가디언 세라핌
function c95481817.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c95481817.pfil1,2,true)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetTarget(c95481817.tar1)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetValue(c95481817.val2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EXTRA_ATTACK)
	e4:SetValue(c95481817.val3)
	c:RegisterEffect(e4)
	--banish
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(95474755,0))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c95481817.extg)
	e5:SetOperation(c95481817.exop)
	c:RegisterEffect(e5)
end
function c95481817.pfil1(c)
	return c:IsFusionSetCard(0xd54)
end
function c95481817.tar1(e,c)
	return c:IsType(TYPE_EQUIP) or c:GetEquipTarget()~=nil
end
function c95481817.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c95481817.vfil2(c)
	return c:IsFaceup() and c:IsType(TYPE_UNION)
end
function c95481817.val2(e,c)
	return c:GetEquipGroup():FilterCount(c95481817.vfil2,nil)*500
end
function c95481817.val3(e,c)
	return c:GetEquipGroup():FilterCount(c95481817.vfil2,nil)
end

function c95481817.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetEquipGroup():FilterCount(c95481817.vfil2,nil)
	local tg=Duel.GetDecktopGroup(1-tp,ct)
	if chk==0 then return ct>0
		and tg:FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)==ct end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,ct,1-tp,LOCATION_DECK)
end
function c95481817.exop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetEquipGroup():FilterCount(c95481817.vfil2,nil)
	if ct==0 then return end
	local tg=Duel.GetDecktopGroup(1-tp,ct)
	Duel.DisableShuffleCheck()
	Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)
end
