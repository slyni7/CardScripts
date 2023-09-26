
function Auxiliary.FairDuel()
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetOperation(Auxiliary.FairDuelOperation)
	Duel.RegisterEffect(e1,0)
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PUBLIC)
	e2:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	Duel.RegisterEffect(e2,0)
end

function Auxiliary.FairDuelFilter(c,code)
	return c:GetOriginalCodeRule()==code
end

function Auxiliary.FairDuelOperation(e,tp,eg,ep,ev,re,r,rp)
	local cdo=Debug.GetDuelOptions()
	if cdo&DUEL_PSEUDO_SHUFFLE==0 then
		return
	end
	local point={}
	local deck={}
	local hands={}
	local handps={}
	local plist={}
	for p=0,1 do
		point[p]={}
		deck[p]={}
		hands[p]={}
		handps[p]={}
		plist[p]={}
		local g=Duel.GetFieldGroup(p,LOCATION_DECK,0)
		local tc=g:GetFirst()
		while tc do
			local seq=tc:GetSequence()
			local tcode=tc:GetOriginalCodeRule()
			local pseq=math.ceil((seq-(#g/2))*seq)
			if point[p][tcode]==nil then
				point[p][tcode]={pseq}
			else
				point[p][tcode]={pseq,table.unpack(point[p][tcode])}
			end
			table.insert(deck[p],tcode)
			tc=g:GetNext()
		end
		local dct=#deck[p]
		local dcf=math.floor(dct*(dct-1)*(dct-2)*(dct-3)*(dct-4)/120)
		local htable={1,2,3,4,5}
		for i=1,dcf do
			local hand={}
			for j=1,5 do
				table.insert(hand,deck[p][htable[j]])
			end
			table.insert(hands[p],hand)
			local j=5
			while j>0 do
				if j>1 and htable[j]>=dct-(5-j) then
					for k=j,5 do
						htable[k]=htable[j-1]+k-(j-2)
					end
					j=j-1
				else
					htable[j]=htable[j]+1
					break
				end
			end
		end
		for i=1,#hands[p] do
			local hand=hands[p][i]
			local sump=0
			local hcode={}
			for j=1,5 do
				local card=hand[j]
				if hcode[card]==nil then
					hcode[card]=0
				end
				hcode[card]=hcode[card]+1
				sump=sump+point[p][card][hcode[card]]
			end
			if plist[p][sump]==nil then
				plist[p][sump]={}
			end
			table.insert(plist[p][sump],hand)
			table.insert(handps[p],sump)
		end
		table.sort(handps[p],function(a,b) return a<b end)
	end
	local num=Duel.GetRandomNumber(1,5050)
	local rnum=math.ceil((math.sqrt(8*num+1)-1)/2)
	Debug.Message("상위 "..(101-rnum).." 퍼센트 패")
	local savedhand={}
	for p=0,1 do
		local hct=#handps[p]
		local hindex=Duel.GetRandomNumber(math.ceil((rnum-1)*hct/100),math.floor(rnum*hct/100))
		savedhand[p]={}
		local hp=handps[p][hindex]
		local pct=#plist[p][hp]
		local pindex=Duel.GetRandomNumber(1,pct)
		for i=1,5 do
			table.insert(savedhand[p],plist[p][hp][pindex][i])
		end
	end
	Debug.SetDuelOptions(cdo&(~DUEL_PSEUDO_SHUFFLE))
	for p=0,1 do
		Duel.ShuffleDeck(p)
		local g=Duel.GetFieldGroup(p,LOCATION_DECK,0)
		local sg=Group.CreateGroup()
		for i=1,5 do
			local cg=g:Filter(Auxiliary.FairDuelFilter,sg,savedhand[p][i])
			local cc=cg:GetFirst()
			sg:AddCard(cc)
		end
		local tc=sg:GetFirst()
		while tc do
			Duel.MoveSequence(tc,0)
			tc=sg:GetNext()
		end
	end
end

Auxiliary.FairDuel()