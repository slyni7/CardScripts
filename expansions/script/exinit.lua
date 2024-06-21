Duel.LoadScript("deprefunc_nodebug.lua")

Duel.LoadScript("proc_version_check.lua")

--[[
if not Auxiliary.FilterBoolFunctionEx then

	function Auxiliary.FilterBoolFunctionEx(f,...)
		local params={...}
		return function(target)
				return f(target,table.unpack(params))
			end
	end

end
]]--

function Auxiliary.AddEquipProcedure(c,p,f,eqlimit,cost,tg,op,con)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1068)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	if con then
		e1:SetCondition(con)
	end
	if cost~=nil then
		e1:SetCost(cost)
	end
	e1:SetTarget(Auxiliary.EquipTarget(tg,p,f))
	e1:SetOperation(op)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	if eqlimit~=nil then
		e2:SetValue(eqlimit)
	elseif f then
		e2:SetValue(Auxiliary.EquipLimit(f))
	else
		e2:SetValue(1)
	end
	c:RegisterEffect(e2)
	return e1
end
function Auxiliary.EquipLimit(f)
	return function(e,c)
				return not f or f(c,e,e:GetHandlerPlayer())
			end
end
function Auxiliary.EquipFilter(c,p,f,e,tp)
	return (p==PLAYER_ALL or c:IsControler(p)) and c:IsFaceup() and (not f or f(c,e,tp))
end
function Auxiliary.EquipTarget(tg,p,f)
	return function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
			local player=nil
			if p==0 then
				player=tp
			elseif p==1 then
				player=1-tp
			elseif p==PLAYER_ALL or p==nil then
				player=PLAYER_ALL
			end
			if chkc then
				return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup()
					and Auxiliary.EquipFilter(chkc,player,f,e,tp)
			end
			if chk==0 then
				return player~=nil and Duel.IsExistingTarget(Auxiliary.EquipFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,player,f,e,tp)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local g=Duel.SelectTarget(tp,Auxiliary.EquipFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,player,f,e,tp)
			if tg then
				tg(e,tp,eg,ep,ev,re,r,rp,g:GetFirst())
			end
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_SOLVING)
			e1:SetReset(RESET_CHAIN)
			e1:SetLabel(Duel.GetCurrentChain())
			e1:SetLabelObject(e)
			e1:SetOperation(Auxiliary.EquipEquip)
			Duel.RegisterEffect(e1,tp)
			Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
		end
end
function Auxiliary.EquipEquip(e,tp,eg,ep,ev,re,r,rp)
	if re~=e:GetLabelObject() then
		return
	end
	local c=e:GetHandler()
	local tc=Duel.GetChainInfo(Duel.GetCurrentChain(),CHAININFO_TARGET_CARDS):GetFirst()
	if tc and c:IsRelateToEffect(re) and tc:IsRelateToEffect(re) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function Auxiliary.NonTunerEx(f,a,b,c)
	return function(target,scard,sumtype,tp)
			return target:IsNotTuner(scard,tp) and (not f or f(target,a,b,c))
		end
end
local setcl=Effect.SetCountLimit
global_eff_count_limit_max={}
global_eff_count_limit_code={}
global_eff_count_limit_flag={}
function Effect.SetCountLimit(e,max,code,flag,...)
	if IREDO_COMES_TRUE or YGOPRO_VERSION~="Percy/EDO" then
		if type(code)=="table" then
			code=code[1]+code[2]
		end
		if flag then
			code=code+flag
		end
	else
		if type(flag)=="number" then
			flag=(flag>>28)
		elseif type(code)=="number" then
			local ccode=code&0x8fffffff
			local cflag=code&0x70000000
			if cflag>0 then
				code=ccode
				flag=(cflag>>28)
			elseif ccode==1 then
				code=0
				flag=4
			end
		end
	end
	global_eff_count_limit_max[e]=max
	global_eff_count_limit_code[e]=code
	global_eff_count_limit_flag[e]=flag
	setcl(e,max,code,flag,...)
end
local setrang=Effect.SetRange
global_eff_rang={}
function Effect.SetRange(e,range)
	global_eff_rang[e]=range
	setrang(e,range)
end
function Effect.GetRange(e)
	return global_eff_rang[e]
end
if YGOPRO_VERSION~="Percy/EDO" then
	function Auxiliary.FilterFaceupFunction(f,...)
		local params={...}
		return 	function(target)
					return target:IsFaceup() and f(target,table.unpack(params))
				end
	end
end

function GetID()
	return self_table,self_code
end

Duel.LoadScript("_register_effect.lua")
Duel.LoadScript("sungak.lua")

Duel.LoadScript("AuxCard_CustomType.lua")
if YGOPRO_VERSION~="Percy/EDO" then
	pcall(Duel.LoadScript,"proc_fusion_koishi.lua")
	pcall(Duel.LoadScript,"proc_synchro_koishi.lua")
	pcall(Duel.LoadScript,"proc_xyz_koishi.lua")
end
pcall(Duel.LoadScript,"proc_equation.lua")
--pcall(Duel.LoadScript,"proc_access.lua")
pcall(Duel.LoadScript,"proc_order.lua")
pcall(Duel.LoadScript,"proc_diffusion.lua")
Duel.LoadScript("proc_beyond.lua")
Duel.LoadScript("proc_square.lua")
Duel.LoadScript("proc_delight.lua")
Duel.LoadScript("proc_scripted.lua")
Duel.LoadScript("proc_equal.lua")
Duel.LoadScript("proc_sequence.lua")
pcall(Duel.LoadScript,"inf.lua")
Duel.LoadScript("ireina.lua")
pcall(Duel.LoadScript,"BELCH.lua")
pcall(Duel.LoadScript,"mirror.lua")
pcall(Duel.LoadScript,"Spinel.lua")
--pcall(Duel.LoadScript,"cyan.lua")
pcall(Duel.LoadScript,"Rune.lua")
pcall(Duel.LoadScript,"hebi.lua")
pcall(Duel.LoadScript,"cirukiru9.lua")
pcall(Duel.LoadScript,"additional_setcards.lua")
pcall(Duel.LoadScript,"remove_xyz_which_have_rank.lua")
pcall(Duel.LoadScript,"kaos.lua")
Duel.LoadScript("SSSS.lua")
Duel.LoadScript("YuL.lua")
local cregeff=Card.RegisterEffect
Auxiliary.MetatableEffectCount=true
function Card.RegisterEffect(c,e,forced,...)
	local code=c:GetOriginalCode()
	local mt=_G["c"..code]
	if c:IsStatus(STATUS_INITIALIZING) and Auxiliary.MetatableEffectCount then
		if not mt.eff_ct then
			mt.eff_ct={}
		end
		if not mt.eff_ct[c] then
			mt.eff_ct[c]={}
		end
		local ct=0
		while true do
			if mt.eff_ct[c][ct]==e then
				break
			end
			if not mt.eff_ct[c][ct] then
				mt.eff_ct[c][ct]=e
				break
			end
			ct=ct+1
		end
	end
	cregeff(c,e,forced,...)
end
--Duel.LoadScript("proto.lua")
--Duel.LoadScript("RDD.lua")