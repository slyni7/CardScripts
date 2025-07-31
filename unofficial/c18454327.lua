--넘쳐나는 온갖 재의 마녀
local s,id=GetID()
function s.initial_effect(c)
	if not s.global_check then
		s.global_check=true
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_STARTUP)
		ge1:SetOperation(s.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=MakeEff(c,"FC")
		ge2:SetCode(EVENT_MOVE)
		ge2:SetOperation(s.gop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function s.gop1(e,tp,eg,ep,ev,re,r,rp)
	aux.GlobalFullList()
end
function s.gop2(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		local tc=eg:GetFirst()
		while tc do
			if aux.GlobalOCGTokens[p]:IsContains(tc) then
				local tcode=tc:GetOriginalCode()
				aux.GlobalOCGTokens[p]:RemoveCard(tc)
				local token=Duel.CreateToken(p,tcode)
				aux.GlobalOCGTokens[p]:AddCard(token)
			end
			tc=eg:GetNext()
		end
	end
end