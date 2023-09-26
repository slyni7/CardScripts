function Auxiliary.BakuadoNumberTaiketsu()
	if GlobalBakuado then
		return
	end
	GlobalBakuado=true
	BakuadoList={62541668,95134948,23187256,26556950,51543904,49032236,90162951,58820923,1992816,97403510,73445448,31801517,89516305,48995978,2978414,28400508,63767246,88177324,75433814,8165596,23085002,66547759,88120966,95474755,16037007,92015800,80117527,53701457,82308875,10389142,21521304,64554883,9161357,75253697,93713837,57707471,21313376,29669359,19333131,39139935,36076683,62070231,35772782,55067058,23998625,90126061,42421606,65676461,2061963,37279508,2407234,49678559,84013237,59627393,76067258,11411223,84417082,47387961,46871387,80796456,94380860,54719828,71921856,82697249,23649496,8387138,90590303,51735257,48739166,50260683,55470553,63746411,31437713,67557908,80764541,63504681,66011101,93108839,53244294,7194917,62517849,93777634,93568288,81330115,56292140,31320433,69610924,47805931,1426714,4997565,71166481,39622156,16259549,32003338,59479050,29208536,54191698,3790062,39972129,55727845,56051086,4019153,15232745,42230449,78625448,55935416,48928529,69058960,95442074,84124261,54366836,89642993,29085954,43490025,57314798}
	BakuadoAlready={}
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(Auxiliary.BakuadoOperation)
	Duel.RegisterEffect(e1,0)
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(Auxiliary.BakuadoIndesValue)
	local e3=Effect.GlobalEffect()
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(Auxiliary.BakuadoIndesTarget)
	e3:SetLabelObject(e2)
	Duel.RegisterEffect(e3,0)
end

function Auxiliary.BakuadoIndesTarget(e,c)
	return c:IsSetCard(0x48)
end
function Auxiliary.BakuadoIndesValue(e,c)
	return not c:IsSetCard(0x48)
end

function Auxiliary.BakuadoOperation(e,tp,eg,ep,ev,re,r,rp)
	if not BakuadoGroups then
		BakuadoGroups={}
		for p=0,1 do
			BakuadoGroups[p]=Group.CreateGroup()
			BakuadoGroups[p]:KeepAlive()
		end
		for p=0,1 do
			for i=1,#BakuadoList do
				local code=BakuadoList[i]
				local token=Duel.CreateToken(p,code)
				BakuadoGroups[p]:AddCard(token)
			end
		end
		for p=0,1 do
			local ge1=Effect.GlobalEffect()
			ge1:SetType(EFFECT_TYPE_FIELD)
			ge1:SetCode(EFFECT_SPSUMMON_PROC_G)
			ge1:SetRange(LOCATION_MZONE)
			ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			ge1:SetValue(SUMMON_TYPE_XYZ)
			ge1:SetCondition(Auxiliary.BakuadoXyzCondition)
			ge1:SetOperation(Auxiliary.BakuadoXyzOperation)
			local ge2=Effect.GlobalEffect()
			ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
			ge2:SetTargetRange(LOCATION_MZONE,0)
			ge2:SetLabelObject(ge1)
			Duel.RegisterEffect(ge2,p)
		end
		e:Reset()
	end
end

function Auxiliary.BakuadoNumberFilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and BakuadoAlready[c:GetCode()]==nil
end
function Auxiliary.BakuadoXyzCondition(e,c,og)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	local sg=BakuadoGroups[tp]:Filter(Auxiliary.BakuadoNumberFilter,nil,e,tp)
	local og=Duel.GetMatchingGroup(Auxiliary.BakuadoOverlayFilter,tp,LOCATION_MZONE,0,c,c:GetLevel())
	return #sg>0 and c:IsFaceup() and c:GetLevel()~=0 and #og>0
end
function Auxiliary.BakuadoOverlayFilter(c,lv)
	return c:IsFaceup() and c:GetLevel()==lv
end
function Auxiliary.BakuadoXyzOperation(e,tp,eg,ep,ev,re,r,rp,c,ssg,og)
	local cancel=Duel.IsSummonCancelable()
	local sg=BakuadoGroups[tp]:Filter(Auxiliary.BakuadoNumberFilter,nil,e,tp)
	local tg=Duel.SelectMatchingCard(tp,Auxiliary.BakuadoOverlayFilter,tp,LOCATION_MZONE,0,0,1,c,c:GetLevel())
	if not tg or #tg==0 then
		return
	end
	tg:AddCard(c)
	local num=Duel.GetRandomNumber(1,#sg)
	local xc=nil
	local tc=sg:GetFirst()
	local i=0
	while tc do
		i=i+1
		if i==num then
			xc=tc
			break
		end
		tc=sg:GetNext()
	end
	local tempc=Duel.GetFirstMatchingCard(nil,tp,0x73,0x73,nil)
	Duel.Overlay(tempc,tg)
	local e1=Effect.CreateEffect(xc)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetLabelObject(tg)
	e1:SetCondition(Auxiliary.BakuadoOverlayCondition)
	e1:SetOperation(Auxiliary.BakuadoOverlayOperation)
	Duel.RegisterEffect(e1,tp)
	local e1=Effect.CreateEffect(xc)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESETS_STANDARD-RESET_TOFIELD)
	e1:SetOperation(Auxiliary.BakuadoCompleteOperation)
	xc:RegisterEffect(e1)
	tg:KeepAlive()
	ssg:AddCard(xc)
	BakuadoAlready[xc:GetCode()]=true
end

local cispreloc=Card.IsPreviousLocation
function Card.IsPreviousLocation(c,loc)
	if c:IsReason(REASON_XYZ) then
		return true
	end
	return cispreloc(c,loc)
end

function Auxiliary.BakuadoOverlayCondition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsContains(c)
end
function Auxiliary.BakuadoOverlayOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local og=e:GetLabelObject()
	c:SetMaterial(og)
	Duel.Overlay(c,og)
	local tc=og:GetFirst()
	while tc do
		Duel.RaiseSingleEvent(tc,EVENT_BE_MATERIAL,e,REASON_XYZ,tp,tp,0)
		tc:SetReasonCard(c)
		tc:SetReason(REASON_XYZ+REASON_MATERIAL)
		tc=og:GetNext()
	end
	Duel.RaiseEvent(og,EVENT_BE_MATERIAL,e,REASON_XYZ,tp,tp,0)
	og:DeleteGroup()
	e:Reset()
end

function Auxiliary.BakuadoCompleteOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:CompleteProcedure()
end

Auxiliary.BakuadoNumberTaiketsu()