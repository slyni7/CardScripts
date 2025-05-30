--유리도 유틸리티를 난사하구싶어요!

YuL={}

--constants
CATEGORY_SEARCH_CARD=CATEGORY_SEARCH+CATEGORY_TOHAND

CARD_LAVA_GOLEM		=102380		--용암 마신 라바 골렘
CARD_RAINBOW_FISH	=23771716	--레인보우 휘시
CARD_FISH_N_KICKS	=32703716	--피쉬 앤 킥스
CARD_FISH_N_BACKS	=21507589	--피쉬 앤 백스
CARD_PESTILENCE		=62472614	--역병

CARD_CYCLONE		=5318639	--싸이크론
CARD_CYCLONE_GALAXY	=5133471	--갤럭시 싸이크론
CARD_CYCLONE_COSMIC	=8267140	--코즈믹 싸이크론
CARD_CYCLONE_DOUBLE	=75652080	--더블 싸이크론
CARD_CYCLONE_DICE	=3493058	--주사위크론
CARD_TORNADO_DRAGON	=6983839	--토네이드래곤
CW_CYCLONE			=99970971	--난수나비(카오틱윙)
CW_CYCLONE_GALAXY	=99970972	--갤럭시 카오틱윙
CW_CYCLONE_COSMIC	=99970973	--코즈믹 카오틱윙
CW_CYCLONE_DOUBLE	=99970974	--더블 카오틱윙
CW_CYCLONE_DICE		=99970975	--다이스 카오틱윙

EFFECT_CHANGE_SUMMON_TYPE	=99970548
EFFECT_ADD_SUMMON_TYPE		=99970549
EFFECT_REMOVE_SUMMON_TYPE	=99970550

--마함
YuL.ST=0x6	--TYPE_SPELL+TYPE_TRAP
--익스플로전!
YuL.d500sp=46130346 --파이어볼
YuL.d600sp=73134081 --화형
YuL.d800sp=19523799 --대화재
YuL.d1000sp1=46918794 --화염 지옥
YuL.d1000sp2=33767325 --데스 메테오
--턴제 속성
YuL.dif=100000000
YuL.O=EFFECT_COUNT_CODE_OATH
YuL.D=EFFECT_COUNT_CODE_DUEL
YuL.S=EFFECT_COUNT_CODE_SINGLE
--속성
ATT_X=0x0
ATT_E=0x1
ATT_W=0x2
ATT_F=0x4
ATT_N=0x8
ATT_L=0x10
ATT_D=0x20
ATT_G=0x40
--소환타입
SUMT_NOR=SUMMON_TYPE_NORMAL
SUMT_ADV=SUMMON_TYPE_ADVANCE
SUMT_DU	=SUMMON_TYPE_DUAL
SUMT_FL	=SUMMON_TYPE_FLIP
SUMT_SP	=SUMMON_TYPE_SPECIAL
SUMT_F	=SUMMON_TYPE_FUSION
SUMT_R	=SUMMON_TYPE_RITUAL
SUMT_S	=SUMMON_TYPE_SYNCHRO
SUMT_X	=SUMMON_TYPE_XYZ
SUMT_P	=SUMMON_TYPE_PENDULUM
SUMT_L	=SUMMON_TYPE_LINK
SUMT_E	=SUMMON_TYPE_EQUATION
SUMT_O	=SUMMON_TYPE_ORDER
SUMT_M	=SUMMON_TYPE_MODULE
SUMT_Q	=SUMMON_TYPE_SQUARE
SUMT_B	=SUMMON_TYPE_BEYOND
SUMT_D	=SUMMON_TYPE_DELIGHT

--cregeff
ACTIVATED_THIS_TURN	=99979999
EQUIPED_THIS_TURN	=99970000

YuL.GlobalSet=false
function YuL.Set()
	YuL.GlobalSet=true
	YuL.SetActivateTurn()
	YuL.SetEquipTurn()
end
RegEff.sgref(function(e,c) if not YuL.GlobalSet then YuL.Set() end end)


RegEff.scref(CARD_CYCLONE,0,function(e,c)
	local filter = function(c,chaoticwing)
		return c:IsSpellTrap() or chaoticwing
	end
	local target = function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		local chaoticwing = Duel.IsPlayerAffectedByEffect(tp,CW_CYCLONE)
		if chkc then return chkc:IsOnField() and filter(chkc,chaoticwing) and chkc~=e:GetHandler() end
		if chk==0 then return Duel.IsExistingTarget(filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),chaoticwing) end
		local g=Duel.SelectTarget(tp,filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler(),chaoticwing)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
	e:SetTarget(target)
end)

RegEff.scref(CARD_CYCLONE_GALAXY,0,function(e,c)
	local filter = function(c)
		return c:IsSpellTrap() and c:IsFacedown()
	end
	local target = function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		local chaoticwing = Duel.IsPlayerAffectedByEffect(tp,CW_CYCLONE_GALAXY)
		local ct=1
		if chaoticwing then ct=2 end
		if chkc then return chkc:IsOnField() and filter(chkc) and chkc~=e:GetHandler() end
		if chk==0 then return Duel.IsExistingTarget(filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
		local g=Duel.SelectTarget(tp,filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	end
	local operation = function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetTargetCards(e)
		Duel.Destroy(g,REASON_EFFECT)
	end
	e:SetTarget(target)
	e:SetOperation(operation)
end)

RegEff.scref(CARD_CYCLONE_GALAXY,1,function(e,c)
	local filter = function(c)
		return c:IsSpellTrap() and c:IsFaceup()
	end
	local target = function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		local chaoticwing = Duel.IsPlayerAffectedByEffect(tp,CW_CYCLONE_GALAXY)
		local ct=1
		if chaoticwing then ct=2 end
		if chkc then return chkc:IsOnField() and filter(chkc) and chkc~=e:GetHandler() end
		if chk==0 then return Duel.IsExistingTarget(filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
		local g=Duel.SelectTarget(tp,filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	end
	local operation = function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetTargetCards(e)
		Duel.Destroy(g,REASON_EFFECT)
	end
	e:SetTarget(target)
	e:SetOperation(operation)
end)

RegEff.scref(CARD_CYCLONE_COSMIC,0,function(e,c)
	local filter = function(c)
		return c:IsSpellTrap() and c:IsAbleToRemove()
	end
	local target = function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		local chaoticwing = Duel.IsPlayerAffectedByEffect(tp,CW_CYCLONE_COSMIC)
		local loc=LOCATION_ONFIELD
		if chaoticwing then loc=LOCATION_ONFIELD+LOCATION_GRAVE end
		if chkc then return chkc:IsOnField() and filter(chkc) and chkc~=e:GetHandler() end
		if chk==0 then return Duel.IsExistingTarget(filter,tp,loc,loc,1,e:GetHandler()) end
		local g=Duel.SelectTarget(tp,filter,tp,loc,loc,1,1,e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
	e:SetTarget(target)
end)

RegEff.scref(CARD_CYCLONE_DICE,0,function(e,c)
	local operation = function(e,tp,eg,ep,ev,re,r,rp)
		local chaoticwing = Duel.IsPlayerAffectedByEffect(tp,CW_CYCLONE_DICE)
		local g=Duel.GetMatchingGroup(Card.IsSpellTrap,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
		local dc=0
		if chaoticwing then
			dc=Duel.SelectEffect(tp,
				{#g>0,aux.Stringid(CW_CYCLONE_DICE,2)},
				{#g>1,aux.Stringid(CW_CYCLONE_DICE,3)},
				{true,aux.Stringid(CW_CYCLONE_DICE,4)})
			if dc==1 then dc=2 
			elseif dc==2 then dc=5
			else dc=1 end
		else
			dc=Duel.TossDice(tp,1)
		end
		if dc==1 or dc==6 then
			Duel.Damage(tp,1000,REASON_EFFECT)
		elseif dc==5 then
			if #g<2 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=g:Select(tp,2,2,nil)
			Duel.Destroy(dg,REASON_EFFECT)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=g:Select(tp,1,1,nil)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
	e:SetOperation(operation)
end)

--엑시즈 베일
RegEff.scref(96457619,1,function(e,c)
	e:SetTarget(function(e,c)
		return c:IsType(TYPE_XYZ) and c:GetOverlayCount()~=0
	end)
end)

--역병
function YuL.PestilenceFilter(c,e,tp)
	return c:IsFaceup()
		and (Duel.IsPlayerAffectedByEffect(tp,99970896)~=nil or c:IsRace(RACE_WARRIOR+RACE_SPELLCASTER+RACE_BEASTWARRIOR))
end
local PestilenceTable = {
	[0]=function(e,c)
	local target = function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return chkc:IsLocation(LOCATION_MZONE) and YuL.PestilenceFilter(chkc,e,tp) end
		if chk==0 then return Duel.IsExistingTarget(YuL.PestilenceFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		Duel.SelectTarget(tp,YuL.PestilenceFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_CHAIN_SOLVING)
		e3:SetReset(RESET_CHAIN)
		e3:SetLabel(Duel.GetCurrentChain())
		e3:SetLabelObject(e)
		e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			if re~=e:GetLabelObject() then return end
			local c=e:GetHandler()
			local tc=Duel.GetChainInfo(Duel.GetCurrentChain(),CHAININFO_TARGET_CARDS):GetFirst()
			if tc and c:IsRelateToEffect(re) and tc:IsRelateToEffect(re) and tc:IsFaceup() then
				Duel.Equip(tp,c,tc)
			end
		end)
		Duel.RegisterEffect(e3,tp)
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
	end
	e:SetTarget(target)
	end
	,
	[1]=function(e,c)
	e:SetValue(function(e,c) return YuL.PestilenceFilter(c,e,e:GetHandlerPlayer()) end) end
}
RegEff.scref(CARD_PESTILENCE,0,PestilenceTable[0])
RegEff.scref(CARD_PESTILENCE,1,PestilenceTable[1])

--세로열 그룹
function YuL.SelectColumnGroupFilter(c,num,tp)
	local seq=c:GetSequence()
	local p=c:GetControler()
	if p==tp then
		if seq==5 and c:IsLocation(LOCATION_MZONE) then seq=1
		elseif seq==6 and c:IsLocation(LOCATION_MZONE) then seq=3 end
		return (seq<5 and seq==num)
	else
		if seq==5 and c:IsLocation(LOCATION_MZONE) then seq=3
		elseif seq==6 and c:IsLocation(LOCATION_MZONE) then seq=1 end
		return (seq<5 and seq==math.abs(4-num))
	end
	return false
end
function YuL.SelectColumnGroup(tp,...)
	local t={...}
	local g=Group.CreateGroup()
	local fg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	for i,v in ipairs(t) do
		if v>=0 and v<=4 then
			g:Merge(fg:Filter(YuL.SelectColumnGroupFilter,nil,v,tp))
		end
	end
	return g
end
function YuL.IsColumn(c,tp,...)
	return YuL.SelectColumnGroup(tp,...):IsContains(c)
end

--이 턴에 발동된
function YuL.SetActivateTurn()
	--YuL.EnableActivateTurn=1
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetOperation(YuL.SetActivateTurnOperation)
	Duel.RegisterEffect(e1,0)
end
function YuL.SetActivateTurnOperation(e,tp,eg,ep,ev,re,r,rp)
	re:GetHandler():RegisterFlagEffect(ACTIVATED_THIS_TURN,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function Card.IsActivateTurn(c)
	return c:GetFlagEffect(ACTIVATED_THIS_TURN)>0
end

--이 턴에 장착된
function YuL.SetEquipTurn()
	--YuL.EnableEquipTurn=1
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_EQUIP)
	e1:SetOperation(YuL.SetEquipTurnOperation)
	Duel.RegisterEffect(e1,0)
end
function YuL.SetEquipTurnOperation(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(YuL.SetEquipTurnFilter,nil)
	g:RegisterFlagEffect(EQUIPED_THIS_TURN,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function YuL.SetEquipTurnFilter(c)
	return c:IsType(TYPE_EQUIP)
end
function Card.IsEquipTurn(c)
	return c:GetFlagEffect(EQUIPED_THIS_TURN)>0
end

--Card.Is몬마함
if YGOPRO_VERSION=="Percy/EDO" then
	Card.IsM=Card.IsMonster
	Card.IsST=Card.IsSpellTrap
else
	function Card.IsMonster(c)
		return c:IsType(TYPE_MONSTER)
	end
	function Card.IsSpell(c)
		return c:IsType(TYPE_SPELL)
	end
	function Card.IsTrap(c)
		return c:IsType(TYPE_TRAP)
	end
	function Card.IsM(c)
		return c:IsMonster(c)
	end
	function Card.IsST(c)
		return c:IsType(YuL.ST)
	end
end

--메세지
function YuL.Hint(code,n)
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(code,n))
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(code,n))
end

--Aranea Attack/Defense Effect
function YuL.AraneaMainEffect(c)
    local e1=MakeEff(c,"FTf","M")
    e1:SetD(99970461,1)
    e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
    e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e1:SetCL(1)
    e1:SetOperation(YuL.AraneaMainEffectOperation)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_PHASE+PHASE_END)
    c:RegisterEffect(e2)
end
function YuL.AraneaMainEffectOperation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_DEFENSE)
        e1:SetValue(200)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
        c:RegisterEffect(e1)
    end
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    if #g>0 then
        local sc=g:GetFirst()
        while sc do
            local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_UPDATE_ATTACK)
            e2:SetReset(RESET_EVENT+RESETS_STANDARD)
            e2:SetValue(-100)
            sc:RegisterEffect(e2)
            local e3=e2:Clone()
            e3:SetCode(EFFECT_UPDATE_DEFENSE)
            sc:RegisterEffect(e3)
            sc=g:GetNext()
        end
    end
end

--데미지 계산 중 이외
function Auxiliary.not_damcal()
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end

--인접 카드 그룹
function Card.GetAdjacentGroup(c)
	local seq=c:GetSequence()
	local p=c:GetControler()
	local g=Group.CreateGroup()
	local loc=c:GetLocation()
	local tc=nil
	
	if loc==LOCATION_MZONE then
		if seq==1 then
			tc=Duel.GetFieldCard(p,loc,5)
			if tc then
				g:AddCard(tc)
			end
			tc=Duel.GetFieldCard(1-p,loc,6)
			if tc then
				g:AddCard(tc)
			end
		end
		if seq==3 then
			tc=Duel.GetFieldCard(p,loc,6)
			if tc then
				g:AddCard(tc)
			end
			tc=Duel.GetFieldCard(1-p,loc,5)
			if tc then
				g:AddCard(tc)
			end
		end
		if seq==5 then
			tc=Duel.GetFieldCard(p,loc,1)
			if tc then
				g:AddCard(tc)
			end
			tc=Duel.GetFieldCard(1-p,loc,3)
			if tc then
				g:AddCard(tc)
			end
		end
		if seq==6 then
			tc=Duel.GetFieldCard(p,loc,3)
			if tc then
				g:AddCard(tc)
			end
			tc=Duel.GetFieldCard(1-p,loc,1)
			if tc then
				g:AddCard(tc)
			end
		end
	end
	if seq<5 then
		tc=Duel.GetFieldCard(p,12-loc,seq)
		if tc then
			g:AddCard(tc)
		end
	end
	if seq>0 then
		tc=Duel.GetFieldCard(p,loc,seq-1)
		if tc then
			g:AddCard(tc)
		end
	end
	if seq<4 then
		tc=Duel.GetFieldCard(p,loc,seq+1)
		if tc then
			g:AddCard(tc)
		end
		tc=Duel.GetFieldCard(p,loc,seq+1)
		if tc then
			g:AddCard(tc)
		end
	end
	return g
end

--소환 취급
local cgsumt=Card.GetSummonType
function Card.GetSummonType(c)
	local t = cgsumt(c)
	local eset = {}
	for _,te in ipairs({c:IsHasEffect(EFFECT_CHANGE_SUMMON_TYPE)}) do
		table.insert(eset,te)
	end
	if EFFECT_ADD_SUMMON_TYPE then for _,te in ipairs({c:IsHasEffect(EFFECT_ADD_SUMMON_TYPE)}) do
		table.insert(eset,te)
	end end
	if EFFECT_REMOVE_SUMMON_TYPE then for _,te in ipairs({c:IsHasEffect(EFFECT_REMOVE_SUMMON_TYPE)}) do
		table.insert(eset,te)
	end end
	table.sort(eset,function(e1,e2) return e1:GetFieldID()<e2:GetFieldID() end)
	local ChangeSummonType = {
		[EFFECT_CHANGE_SUMMON_TYPE] = function(t,v) return v end
	}
	if EFFECT_ADD_SUMMON_TYPE then ChangeSummonType[EFFECT_ADD_SUMMON_TYPE] = function(t,v) return t | v end end
	if EFFECT_REMOVE_SUMMON_TYPE then ChangeSummonType[EFFECT_REMOVE_SUMMON_TYPE] = function(t,v) return t & ~v end end
	for _,te in ipairs(eset) do
		local v = te:GetValue()
		if type(v)=="function" then v = v(te,c) end
		t = ChangeSummonType[te:GetCode()](t,v)
	end
	return t
end
local cissumt=Card.IsSummonType
function Card.IsSummonType(c,sumtype)
	return c:GetSummonType()&sumtype==sumtype
end

--필드에서
function aux.PreOnfield(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end

--dscon
function aux.dscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end

--소생 제한
function RevLim(c)
	return c:EnableReviveLimit()
end

--Gruop.RegisterFlagEffect
function Group.RegisterFlagEffect(g,...)
	local tc=g:GetFirst()
	while tc do
		tc:RegisterFlagEffect(...)
		tc=g:GetNext()
	end
end

--장착 (c,p,f,eqlimit,cost,tg,op,con)
function YuL.Equip(...)
	return aux.AddEquipProcedure(...)
end

--그룹 카운터 세기(g:GetCounter(카운터))
function Group.GetCounter(g,counter)
	local ct=0
	local tc=g:GetFirst()
	while tc do
		ct=tc:GetCounter(counter)+ct
		tc=g:GetNext()
	end
	return ct
end

--원래 타입
function Card.IsOriginalType(c,num)
	return bit.band(c:GetOriginalType(),num)==num
end

--aux.FilterBoolFunction
function aux.FBF(...)
	return aux.FilterBoolFunction(...)
end

--속성
function YuL.ATT(str)
	if type(str)=="number" then
		return str
	end
	local num=0
	if string.find(str,"E") then
		num=num+0x1
	end
	if string.find(str,"W") then
		num=num+0x2
	end
	if string.find(str,"F") then
		num=num+0x4
	end
	if string.find(str,"N") then
		num=num+0x8
	end
	if string.find(str,"L") then
		num=num+0x10
	end
	if string.find(str,"D") then
		num=num+0x20
	end
	if string.find(str,"G") then
		num=num+0x40
	end
	return num
end

--소재로 사용 불가
function YuL.NoMat(c,str)
	if type(str)=="number" then
		return str
	end
	if str == "a" then
		local str = "FSXLOMQBD"
	end
	if string.find(str,"F") then
		YuL.CannotMat(c,EFFECT_CANNOT_BE_FUSION_MATERIAL)
	end
	if string.find(str,"S") then
		YuL.CannotMat(c,EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	end
	if string.find(str,"X") then
		YuL.CannotMat(c,EFFECT_CANNOT_BE_XYZ_MATERIAL)
	end
	if string.find(str,"L") then
		YuL.CannotMat(c,EFFECT_CANNOT_BE_LINK_MATERIAL)
	end
	if string.find(str,"O") then
		YuL.CannotMat(c,EFFECT_CANNOT_BE_ORDER_MATERIAL)
	end
	if string.find(str,"M") then
		YuL.CannotMat(c,EFFECT_CANNOT_BE_MODULE_MATERIAL)
	end
	if string.find(str,"Q") then
		YuL.CannotMat(c,EFFECT_CANNOT_BE_SQUARE_MATERIAL)
	end
	if string.find(str,"B") then
		YuL.CannotMat(c,EFFECT_CANNOT_BE_BEYOND_MATERIAL)
	end
	if string.find(str,"D") then
		YuL.CannotMat(c,EFFECT_CANNOT_BE_DELIGHT_MATERIAL)
	end
end
function YuL.CannotMat(c,tcode)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(tcode)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
end

--프리체인
function YuL.WriteFreeChainEffect(e,range)
	e:SetCode(EVENT_FREE_CHAIN)
	e:SetType(EFFECT_TYPE_QUICK_O)
	e:SetRange(LSTN(range))
end
function FreeChain(...)
	return YuL.WriteFreeChainEffect(...)
end

--기동
function YuL.WriteIgnitionEffect(e,range)
	e:SetType(EFFECT_TYPE_IGNITION)
	e:SetRange(LSTN(range))
end
function Ignite(...)
	return YuL.WriteIgnitionEffect(...)
end

--마함 발동
function YuL.ActST(c)
	local eActivate=Effect.CreateEffect(c)
	eActivate:SetType(EFFECT_TYPE_ACTIVATE)
	return eActivate
end

--평범한 지속 / 필드 마법 발동
function YuL.Activate(c)
	local eactivate=Effect.CreateEffect(c)
	eactivate:SetType(EFFECT_TYPE_ACTIVATE)
	eactivate:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(eactivate)
end

--SetDescription
function Effect.SetD(e,code,number)
	e:SetDescription(aux.Stringid(code,number))
end

--SetCL
function Effect.SetCL(e,...)
	e:SetCountLimit(...)
end

--LP 코스트 (-1 : 절반)
function YuL.LPcost(lp)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if lp==-1 then
			if chk==0 then return true end
			Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
		else
			if chk==0 then return Duel.CheckLPCost(tp,lp) end
			Duel.PayLPCost(tp,lp)
		end
	end
end

--LP 회복 [자신 0, 상대 1]
function YuL.rectg(player,lp)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.SetTargetPlayer(math.abs(player-tp))
		Duel.SetTargetParam(lp)
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,math.abs(player-tp),lp)
	end
end
function YuL.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end

--LP 데미지 [자신 0, 상대 1]
function YuL.damtg(player,lp)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.SetTargetPlayer(math.abs(player-tp))
		Duel.SetTargetParam(lp)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,math.abs(player-tp),lp)
	end
end
function YuL.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end

--패 코스트
function YuL.discard(min,max)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,min,e:GetHandler()) end
		Duel.DiscardHand(tp,Card.IsDiscardable,min,max,REASON_COST+REASON_DISCARD)
	end
end

--페이즈 컨디션 [ 자신 0, 상대 1, 양쪽2 ]
function YuL.phase(pl,ph)
	return function(e,tp,eg,ep,ev,re,r,rp)
		return (pl==2 or Duel.GetTurnPlayer()==math.abs(pl-tp)) and Duel.GetCurrentPhase()&ph~=0
	end
end

--배틀 페이즈 컨디션 [ 자신 0, 상대 1, 양쪽 2]
function YuL.Bphase(pl)
	return function(e,tp,eg,ep,ev,re,r,rp)
		if pl==2 or Duel.GetTurnPlayer()==math.abs(pl-tp) then
			local ph=Duel.GetCurrentPhase()
			return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
		end
		return false
	end
end

--턴 컨디션 [ 자신 0, 상대 1 ]
function YuL.turn(pl)
	return function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetTurnPlayer()==math.abs(pl-tp)
	end
end

--전투 파괴 내성 [ c,장소 ]
function YuL.ind_bat(c,range)
	local ebat=Effect.CreateEffect(c)
	ebat:SetType(EFFECT_TYPE_SINGLE)
	ebat:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ebat:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	ebat:SetValue(1)
	c:RegisterEffect(ebat)
end

--효과 파괴 내성 [ c,장소,n ] [ n == 1 상대 효과 파괴 내성 ]
function YuL.ind_eff(c,range,pl)
	local eeff=Effect.CreateEffect(c)
	eeff:SetType(EFFECT_TYPE_SINGLE)
	eeff:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	eeff:SetRange(range)
	eeff:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	if n==1 then
		eeff:SetValue(YuL.ind_eff_val)
	else
		eeff:SetValue(1)
	end
	c:RegisterEffect(eeff)
end
function YuL.ind_eff_val(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end

--효과 대상 내성 [ c,장소 ]
function YuL.ind_tar(c,range)
	local etar=Effect.CreateEffect(c)
	etar:SetType(EFFECT_TYPE_SINGLE)
	etar:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	etar:SetRange(range)
	etar:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	etar:SetValue(aux.tgoval)
	c:RegisterEffect(etar)
end

--엑스트라 덱 소환 제한
function YuL.ExLimit(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(YuL.ExLimitVal)
	c:RegisterEffect(e1)
end
function YuL.ExLimitVal(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end

--라바 골렘
function Card.IsLavaGolem(c)
	return c:IsCode(CARD_LAVA_GOLEM)
end
function Card.IsLavaGolemCard(c)
	return c:IsCode(CARD_LAVA_GOLEM) or c:IsSetCard(0xd6a)
end
function YuL.AddLavaGolemProcedure(c,condition,m)
	RevLim(c)
	YuL.AddLavaGolemCost(c)
	local e1=Effect.CreateEffect(c)
	e1:SetD(m,0)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(YuL.LavaGolemCondition(condition,0))
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetD(m,1)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e2:SetRange(LOCATION_HAND)
	e2:SetTargetRange(POS_FACEUP,1)
	e2:SetValue(0)
	e2:SetCondition(YuL.LavaGolemCondition(condition,1))
	c:RegisterEffect(e2)
end
function YuL.AddLavaGolemCost(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCost(YuL.LavaGolemCost)
	e0:SetOperation(YuL.LavaGolemCostOperation)
	c:RegisterEffect(e0)
end
function YuL.LavaGolemCost(e,c,tp)
	return Duel.GetActivityCount(tp,ACTIVITY_NORMALSUMMON)==0
end
function YuL.LavaGolemCostOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e2,tp)
end
function YuL.LavaGolemCondition(condition,p)
	return function(e,c)
		if c==nil then return true end
		local tp=c:GetControler()
		return Duel.GetLocationCount(math.abs(p-tp),LOCATION_MZONE)>0 and (condition==nil or condition(e,c))
	end
end

--레인보우 휘시
function Card.IsRainbowFish(c)
	return c:IsCode(CARD_RAINBOW_FISH)
end
function Card.IsRainbowFishCard(c)
	return c:IsCode(CARD_RAINBOW_FISH) or c:IsSetCard(0xe18)
end

--마트료시카

--마트료시카 꺼내기
--[[
④: 1턴에 1번, 자신 / 상대 턴에 발동할 수 있다. 이 카드를 주인의 패로 되돌리고, 이 카드의 엑시즈 소재 중에서 맨 위의 몬스터를 내어, 남은 카드를 그 아래에 겹쳐 엑시즈 소재로 한다. 이 효과를 발동한 턴에, 자신은 "마트료시카: 본인"을 패에서 특수 소환할 수 없다.
--]]
function YuL.MatryoshkaOpen(c,ex)
	local e1=MakeEff(c,"Qo","M")
	if ex==nil then
		e1:SetD(99970084,0)
		e1:SetCategory(CATEGORY_TOHAND)
	else
		e1:SetD(99970084,1)
		e1:SetCategory(CATEGORY_TOEXTRA)
	end
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCL(1)
	e1:SetTarget(YuL.MatryoshkaOpenTarget(ex))
	e1:SetOperation(YuL.MatryoshkaOpenOperation(ex))
	c:RegisterEffect(e1)
end
function YuL.MatryoshkaTarget(c)
	local og=c:GetOverlayGroup()
	return og and og:IsExists(Card.IsType,1,nil,TYPE_MONSTER)
end
function YuL.MatryoshkaOperation(c,ex)
	local p=c:GetControler()
	local og=c:GetOverlayGroup()
	local oc=og:GetFirst()
	local xc=nil
	local mseq=c:GetSequence()
	local xseq=-1
	while oc do
		if oc:GetSequence()>xseq and oc:IsType(TYPE_MONSTER) then
			xseq=oc:GetSequence()
			xc=oc
		end
		oc=og:GetNext()
	end
	local tc=Duel.GetFirstMatchingCard(aux.TRUE,p,0xfb,0xfb,nil)
	Duel.Overlay(tc,og)
	if ex==nil then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	else
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
	og:RemoveCard(xc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_CONTROL)
	e1:SetLabel(p)
	e1:SetValue(function(e,c)
		return e:GetLabel()
	end)
	e1:SetReset(RESET_EVENT+0xec0000)
	xc:RegisterEffect(e1)
	local zones=0x1f
	if mseq>4 then zones=0x7f end
	Duel.MoveToField(xc,p,p,LOCATION_MZONE,POS_FACEUP,true,zones)
	Duel.Overlay(xc,og)
end
function YuL.MatryoshkaOpenTarget(ex)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		if chk==0 then return YuL.MatryoshkaTarget(c) and ((ex==nil and c:IsAbleToHand()) or c:IsAbleToExtra()) end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,LOCATION_MZONE)
	end
end
function YuL.MatryoshkaOpenOperation(ex)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local m=c:GetOriginalCode()
		if c:IsRelateToEffect(e) then
			YuL.MatryoshkaOperation(c,ex)
			if m~=99970265 then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
				e1:SetD(m,4)
				e1:SetTargetRange(1,0)
				e1:SetTarget(YuL.MatryoshkaSumLimit(m,ex))
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function YuL.MatryoshkaSumLimit(m,ex)
	return function(e,c)
		return c:IsCode(m) and ((ex==nil and c:IsLocation(LOCATION_HAND)) or c:IsLocation(LOCATION_EXTRA))
	end
end
------------------------
-- 리메이크되어 사용안함 --
------------------------
--[[
function YuL.MatryoshkaImmune(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(YuL.MatryoshkaReplaceTarget)
	e1:SetOperation(YuL.MatryoshkaReplaceOperation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(YuL.MatryoshkaReplace2)
	c:RegisterEffect(e2)
end
function YuL.MatryoshkaReplaceTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return YuL.MatryoshkaTarget(c) end
	return Duel.SelectYesNo(tp,aux.Stringid(c:GetOriginalCode(),2))
end
function YuL.MatryoshkaReplaceOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	YuL.MatryoshkaOperation(c)
end
function YuL.MatryoshkaReplace2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		return
	end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()<1 then
		return
	end
	if rp~=tp and g:IsContains(c) and YuL.MatryoshkaTarget(c) and Duel.SelectYesNo(tp,aux.Stringid(c:GetOriginalCode(),2)) then
		YuL.MatryoshkaOperation(c)
	end
end
]]------------------------

--마트료시카 특소
function YuL.MatryoshkaProcedure(c,mat,op,val)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	if val>0 then
		e1:SetRange(LOCATION_EXTRA)
		e1:SetD(c:GetOriginalCode(),3)
		e1:SetCL(1,c:GetOriginalCode())
	else
		e1:SetRange(LOCATION_HAND)
	end
	e1:SetValue(val)
	e1:SetCondition(YuL.MatryoshkaSumCondition(mat,op))
	e1:SetTarget(YuL.MatryoshkaSumTarget(mat,op))
	e1:SetOperation(YuL.MatryoshkaSumOperation(mat,op))
	c:RegisterEffect(e1)
end
function YuL.MatryoshkaSumFilter(c,sc,mat)
	local tp=sc:GetControler()
	local lv=sc:GetLevel()
	local filter=nil
	if mat~=nil then
		filter=mat
	else
		filter=function(c)
			return c:IsSetCard(0xd37) and c:IsFaceup() and c:GetOriginalLevel()<lv
				and not (c:IsType(TYPE_XYZ) or c:IsType(TYPE_LINK))
		end
	end
	if not filter(c) then
		return false
	end
	if sc:IsLocation(LOCATION_EXTRA) then
		return Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
	else
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or c:GetSequence()<5
	end
end
function YuL.MatryoshkaSumCondition(mat,op)
	return function(e,c)
		if c==nil then
			return true
		end
		local tp=c:GetControler()
		return Duel.IsExistingMatchingCard(YuL.MatryoshkaSumFilter,tp,LOCATION_MZONE,0,1,nil,c,mat)
			and (op==nil or op(e,tp,0))
	end
end
function YuL.MatryoshkaSumTarget(mat,op)
	return function(e,tp,eg,ep,ev,re,r,rp,chk,c)
		local can=Duel.GetCurrentChain()<1
		Auxiliary.ProcCancellable=can
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local lv=c:GetLevel()
		local tc=Duel.GetMatchingGroup(YuL.MatryoshkaSumFilter,tp,LOCATION_MZONE,0,nil,c,mat):SelectUnselect(Group.CreateGroup(),tp,can,can)
		if not tc then
			return false
		end
		local ok=true
		if op~=nil then
			ok=op(e,tp,1)
		end
		if not ok then
			return false
		end
		e:SetLabelObject(tc)
		return true
	end
end
function YuL.MatryoshkaSumOperation(mat,op)
	return function(e,tp,eg,ep,ev,re,r,rp,c)
		local tc=e:GetLabelObject()
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.Overlay(c,og)
		end
		Duel.Overlay(c,tc)
	end
end

--Pray of...
function YuL.PrayofTurnSet(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(YuL.PrayofTarget)
	e1:SetOperation(YuL.PrayofOperation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function YuL.PrayofTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanTurnSet() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
end
function YuL.PrayofOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
	end
end

--Error: The Library of Babel
function YuL.TheLibraryofBabel(c)
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PREDRAW)
	e0:SetRange(LOCATION_DECK+LOCATION_HAND)
	e0:SetCountLimit(1,c:GetOriginalCode()+EFFECT_COUNT_CODE_DUEL)
	e0:SetCondition(YuL.thelibraryofbabelcon)
	e0:SetOperation(YuL.thelibraryofbabelop)
	c:RegisterEffect(e0)
end
function YuL.thelibraryofbabelcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==1
end
function YuL.thelibraryofbabelop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_THE_LIBRARY_OF_BABEL=0x60
	Duel.Win(1-tp,WIN_REASON_THE_LIBRARY_OF_BABEL)
end

--가챠는 나쁜 문명!
if Duel.GetRandomNumber then
	YuL.Random = Duel.GetRandomNumber
else
	function YuL.SetRandomSeed()
		YuL.RandomSeed=0
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		e1:SetCountLimit(1)
		e1:SetOperation(YuL.SetRandomSeedOperation)
		Duel.RegisterEffect(e1,0)
	end
	function YuL.SetRandomSeedOperation(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetFieldGroup(0,0xff,0xff)
		local tc=g:GetFirst()
		local fc=nil
		local i=0
		while tc do
			fc=tc
			tc=g:GetNext()
			if not tc then
				break
			end
			if fc:GetCode()>tc:GetCode() then
				YuL.RandomSeed=YuL.RandomSeed+2^i
			end
			i=i+1
			if i>31 then
				break
			end
		end
	end
	function YuL.Random(min,max)
		local seed=YuL.RandomSeed
		local next=seed*1103515245+12345
		local rand=next&0xffffffff
		YuL.RandomSeed=rand
		return rand%(max-min)+min
	end
	YuL.random=YuL.Random
	RegEff.sgref(function(e,c) if not YuL.RandomSeed then YuL.SetRandomSeed() end end)
end
--콜로서스: 만들고 있어요
function Duel.GetHandLimit(player)
	local hand_limit=6
	local eset={Duel.GetPlayerEffect(player,EFFECT_HAND_LIMIT)}
	for _,te in ipairs(eset) do
		local val=te:GetValue()
		if type(val)=="number" then
			hand_limit=val
		elseif type(val)=="function" then
			hand_limit=val(te)
		end
	end
	return hand_limit
end

if not EFFECT_UPDATE_HAND_LIMIT then

EFFECT_UPDATE_HAND_LIMIT=99970881
local cregeff=Card.RegisterEffect
function Card.RegisterEffect(c,e,forced,...)
	local code=c:GetOriginalCode()
	local mt=_G["c"..code]
	cregeff(c,e,forced,...)
	if e:GetCode()==EFFECT_HAND_LIMIT then
		local r0,r1=e:GetTargetRange()
		local e0=e
		local e1=e
		if r0==1 and r1==1 then
			e0:SetTargetRange(1,0)
			e1=e0:Clone()
			e1:SetTargetRange(0,1)
			cregeff(c,e1,forced,...)
		elseif r0==1 then
			e1=nil
		elseif r1==1 then
			e0=nil
		else
			e0=nil
			e1=nil
		end
		if e0 then
			local val=e0:GetValue()
			e0:SetValue(function()
				local hand_limit
				if type(val)=="number" then
					hand_limit=val
				elseif type(val)=="function" then
					hand_limit=val(te)
				end
				local hp=e0:GetHandlerPlayer()
				local eid=e0:GetFieldID()
				local eset={Duel.GetPlayerEffect(hp,EFFECT_UPDATE_HAND_LIMIT)}
				for _,te in ipairs(eset) do
					if te:GetFieldID()>eid then
						local tev=te:GetValue()
						if type(tev)=="number" then
							hand_limit=hand_limit+tev
						elseif type(tev)=="function" then
							hand_limit=hand_limit+tev(te,hp)
						end
					end
				end
				return hand_limit
			end)
		end
		if e1 then
			local val=e1:GetValue()
			e1:SetValue(function()
				local hand_limit
				if type(val)=="number" then
					hand_limit=val
				elseif type(val)=="function" then
					hand_limit=val(te)
				end
				local hp=e1:GetHandlerPlayer()
				local eid=e1:GetFieldID()
				local eset={Duel.GetPlayerEffect(1-hp,EFFECT_UPDATE_HAND_LIMIT)}
				for _,te in ipairs(eset) do
					if te:GetFieldID()>eid then
						local tev=te:GetValue()
						if type(tev)=="number" then
							hand_limit=hand_limit+tev
						elseif type(tev)=="function" then
							hand_limit=hand_limit+tev(te,1-hp)
						end
					end
				end
				return hand_limit
			end)
		end
	end
end
local dregeff=Duel.RegisterEffect
function Duel.RegisterEffect(e,p,...)
	dregeff(e,p,...)
	if e:GetCode()==EFFECT_HAND_LIMIT then
		local r0,r1=e:GetTargetRange()
		local e0=e
		local e1=e
		if r0==1 and r1==1 then
			e0:SetTargetRange(1,0)
			e1=e0:Clone()
			e1:SetTargetRange(0,1)
			dregeff(e1,p,...)
		elseif r0==1 then
			e1=nil
		elseif r1==1 then
			e0=nil
		else
			e0=nil
			e1=nil
		end
		if e0 then
			local val=e0:GetValue()
			e0:SetValue(function()
				local hand_limit
				if type(val)=="number" then
					hand_limit=val
				elseif type(val)=="function" then
					hand_limit=val(te)
				end
				local hp=e0:GetHandlerPlayer()
				local eid=e0:GetFieldID()
				local eset={Duel.GetPlayerEffect(hp,EFFECT_UPDATE_HAND_LIMIT)}
				for _,te in ipairs(eset) do
					if te:GetFieldID()>eid then
						local tev=te:GetValue()
						if type(tev)=="number" then
							hand_limit=hand_limit+tev
						elseif type(tev)=="function" then
							hand_limit=hand_limit+tev(te,hp)
						end
					end
				end
				return hand_limit
			end)
		end
		if e1 then
			local val=e1:GetValue()
			e1:SetValue(function()
				local hand_limit
				if type(val)=="number" then
					hand_limit=val
				elseif type(val)=="function" then
					hand_limit=val(te)
				end
				local hp=e1:GetHandlerPlayer()
				local eid=e1:GetFieldID()
				local eset={Duel.GetPlayerEffect(1-hp,EFFECT_UPDATE_HAND_LIMIT)}
				for _,te in ipairs(eset) do
					if te:GetFieldID()>eid then
						local tev=te:GetValue()
						if type(tev)=="number" then
							hand_limit=hand_limit+tev
						elseif type(tev)=="function" then
							hand_limit=hand_limit+tev(te,1-hp)
						end
					end
				end
				return hand_limit
			end)
		end
	end
end

end

function YuL.AddColossusSummonProcedure(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(YuL.ColossusSummonCondition)
	e1:SetTarget(YuL.ColossusSummonTarget)
	e1:SetOperation(YuL.ColossusSummonOperation)
	e1:SetValue(SUMMON_TYPE_TRIBUTE)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S")
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(YuL.ColossusSummonCondition2)
	c:RegisterEffect(e2)
end
function YuL.ColossusSummonCondition(e,c,minc,zone,relzone,exeff)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	local mg=Duel.GetTributeGroup(c):Match(Auxiliary.IsZone,nil,relzone,tp)
	local hand_limit=Duel.GetHandLimit(tp)
	local min=3-hand_limit
	if min<0 then
		min=0
	end
	min=math.max(min,1-Duel.GetLocationCount(tp,LOCATION_MZONE))
	return minc<=min and Duel.CheckTribute(c,min,3,mg,tp,zone)
end
function YuL.ColossusSummonTarget(e,tp,eg,ep,ev,re,r,rp,chk,c,minc,zone,relzone,exeff)
	local mg=Duel.GetTributeGroup(c):Match(Auxiliary.IsZone,nil,relzone,tp)
	local hand_limit=Duel.GetHandLimit(tp)
	local min=3-hand_limit
	if min<0 then
		min=0
	end
	min=math.max(min,1-Duel.GetLocationCount(tp,LOCATION_MZONE))
	local g=Duel.SelectTribute(tp,c,min,3,mg,tp,zone,Duel.IsSummonCancelable())
	if g or min==0 then
		if not g then
			g=Group.CreateGroup()
		end
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function YuL.ColossusSummonOperation(e,tp,eg,ep,ev,re,r,rp,c,minc,zone,relzone,exeff)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	if #g>0 then
		Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
	end
	local hand_limit=Duel.GetHandLimit(tp)
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_HAND_LIMIT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTR(1,0)
	e1:SetValue(hand_limit)
	Duel.RegisterEffect(e1,tp)
	local e2=MakeEff(c,"F")
	e2:SetCode(EFFECT_UPDATE_HAND_LIMIT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTR(1,0)
	e2:SetValue(-(3-#g))
	Duel.RegisterEffect(e2,tp)
	g:DeleteGroup()
end
function YuL.ColossusSummonCondition2(e,c)
	if c==nil then
		return true
	end
	return false
end
