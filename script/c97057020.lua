--Shingensui Combined Flagship Nagato
function c97057020.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_WATER),9,2,nil,nil,Xyz.InfiniteMats)
	c:EnableReviveLimit()
	--destroy protect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(function(e,c) return c~=e:GetHandler() and c:IsMonster() end)
	e1:SetValue(aux.TRUE)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetDescription(aux.Stringid(97057020,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,97057020)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c97057020.cost)
	e2:SetTarget(c97057020.target)
	e2:SetOperation(c97057020.operation)
	c:RegisterEffect(e2,false,REGISTER_FLAG_DETACH_XMAT)
	--quick (shimakaze)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(97057020,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetLabel(1)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e3)   
	--reactive (suzutsuki)
	local e4=e2:Clone()
	e4:SetDescription(aux.Stringid(97057020,2))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetLabel(2)
	e4:SetCondition(c97057020.rccon)
	c:RegisterEffect(e4)
	--destroy (monster)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(97057020,3))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,{97057020,1})
	e5:SetLabel(LOCATION_MZONE)
	e5:SetCondition(c97057020.descon)
	e5:SetTarget(c97057020.destg)
	e5:SetOperation(c97057020.desop)
	c:RegisterEffect(e5)
	--destroy (s/t)
	local e6=e5:Clone()
	e6:SetDescription(aux.Stringid(97057020,4))
	e6:SetCountLimit(1,{97057020,2})
	e6:SetLabel(LOCATION_SZONE)
	c:RegisterEffect(e6)
	--negate
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(97057020,5))
	e7:SetCategory(CATEGORY_DISABLE)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_CHAINING)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,{97057020,3})
	e7:SetCondition(c97057020.discon)
	e7:SetTarget(c97057020.distg)
	e7:SetOperation(c97057020.disop)
	c:RegisterEffect(e7)
end
function c97057020.rccon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp 
end
function c97057020.tgfilter(e,re,rp)
	return re:IsHasCategory(CATEGORY_DESTROY)
end
function c97057020.desfilter(e,re,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g:IsContains(e:GetHandler())
end
local function groupfrombit(bit,p)
	local loc=(bit&0x7F>0) and LOCATION_MZONE or LOCATION_SZONE 
	local seq=(loc==LOCATION_MZONE) and bit or bit>>8
	seq = math.floor(math.log(seq,2))
	local g=Group.CreateGroup()
	local function optadd(loc,seq)
		local c=Duel.GetFieldCard(p,loc,seq)
		if c then g:AddCard(c) end
	end
	optadd(loc,seq)
	return g
end
function c97057020.rowfilter(c)
	return c:GetSequence()<5
end
function c97057020.rescon(sg,e,tp,mg)
	if e:GetLabel()==1 then
		return sg:IsExists(Card.IsCode,1,nil,97057000)
	elseif e:GetLabel()==2 then
		return sg:IsExists(Card.IsCode,1,nil,97057006)
	else return true end
end
function c97057020.tgfilter(c,e,g)
	return c:IsCanBeEffectTarget(e) or g and g:IsExists(Card.IsCode,97057003)
end
function c97057020.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	for i,pe in ipairs({Duel.GetPlayerEffect(tp,97057017)}) do
		g:Merge(pe:GetHandler():GetOverlayGroup())
	end
	if Duel.IsPlayerAffectedByEffect(tp,97057021) then
		local g2=Duel.GetMatchingGroup(c97057021.edfilter,tp,LOCATION_EXTRA,0,nil) 
		g:Merge(g2)
	end
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,2,#g,c97057020.rescon,0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg=aux.SelectUnselectGroup(g,e,tp,2,#g,c97057020.rescon,1,tp,HINTMSG_XMATERIAL,c97057020.rescon)
	e:SetLabelObject(sg)
	sg:KeepAlive()
	e:SetLabel(#sg)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c97057020.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return c:GetFlagEffect(97057020)==0 and Duel.IsExistingMatchingCard(c97057020.tgfilter,tp,0,LOCATION_ONFIELD,1,nil,e,g) end
	c:RegisterFlagEffect(97057020,RESET_CHAIN,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	g=e:GetLabelObject()
	local lm=1
	if g:IsExists(Card.IsCode,1,nil,97057002) then lm=2 end
	if g and g:IsExists(Card.IsCode,1,nil,97057003) and Duel.SelectYesNo(tp,aux.Stringid(97057003,1)) then
		local zone=Duel.SelectFieldZone(tp,1,0,LOCATION_ONFIELD,0)
		e:SetLabel(zone)
		local sg=groupfrombit(zone>>16,1-tp)
		if zone and lm>1 then
			local zone2=Duel.SelectFieldZone(tp,1,0,LOCATION_ONFIELD,zone)
			e:SetLabel(zone,zone2)
			sg:Merge(groupfrombit(zone2>>16,1-tp))
			Duel.Hint(HINT_ZONE,tp,zone+zone2)
			Duel.Hint(HINT_ZONE,1-tp,zone>>16)
		else
			Duel.Hint(HINT_ZONE,tp,zone)
			Duel.Hint(HINT_ZONE,1-tp,zone>>16)
		end
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,1,0,0)
		e:SetOperation(c97057020.operation2)
	else
		local tc=Duel.SelectTarget(tp,c97057020.tgfilter,tp,0,LOCATION_ONFIELD,1,lm,nil,e,g)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
		e:SetOperation(c97057020.operation)
		if g and g:IsExists(Card.IsCode,1,nil,97057023) then
			c97057023.disable(e,tp,tc)
		end
	end
	if g and g:IsExists(Card.IsCode,1,nil,97057005) then
		Duel.SetChainLimit(c97057005.limit())
	end
end
function c97057020.operation(e,tp,eg,ep,ev,re,r,rp)
	local lb=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local s=g:Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		local loc=nil
		if #lb>1 and Duel.IsPlayerAffectedByEffect(tp,97057015) and Duel.SelectYesNo(tp,aux.Stringid(97057015,4)) then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		else
			Duel.Destroy(g,REASON_EFFECT,loc)
		end
		local dg=Duel.GetOperatedGroup()
		if #dg>0 and #lb>2 then
			if Duel.IsPlayerAffectedByEffect(tp,97057013) and dg:IsExists(c97057013.desfilter,1,nil,tp) then
				Duel.RaiseEvent(dg,EVENT_CUSTOM+97057013,e,REASON_EFFECT,tp,1-tp,1)
			end
			if Duel.IsPlayerAffectedByEffect(tp,97057022) then
				c97057022.yamato(e,tp,dg)
			end
		end
	end
end
function c97057020.operation2(e,tp,eg,ep,ev,re,r,rp)
	local zone,zone2=e:GetLabel()
	local g=groupfrombit(zone>>16,1-tp)
	if zone2 then
		local g2=groupfrombit(zone2>>16,1-tp)
		if g2 then g:Merge(g2) end
	end
	if #g>0 then
		local loc=nil
		if #lb>1 and Duel.IsPlayerAffectedByEffect(tp,97057015) and Duel.SelectYesNo(tp,aux.Stringid(97057015,4)) then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		else
			Duel.Destroy(g,REASON_EFFECT,loc)
		end
		local dg=Duel.GetOperatedGroup()
		if #dg>0 and #lb>2 then
			if Duel.IsPlayerAffectedByEffect(tp,97057013) and dg:IsExists(c97057013.desfilter,1,nil,tp) then
				Duel.RaiseEvent(dg,EVENT_CUSTOM+97057013,e,REASON_EFFECT,tp,1-tp,1)
			end
			if Duel.IsPlayerAffectedByEffect(tp,97057022) then
				c97057022.yamato(e,tp,dg)
			end
		end
	end
end
function c97057020.desfilter(c,loc)
	return (not loc or c:IsPreviousLocation(loc)) and c:GetSequence()<5
end
function c97057020.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c97057020.desfilter,1,nil,e:GetLabel())
end
function c97057020.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tg=e:GetLabel()
	local g=Duel.GetMatchingGroup(aux.FaceupFilter(c97057020.desfilter),tp,tg,tg,nil)
	if chk==0 then return c:GetFlagEffect(97057020)==0 and #g>0 end
	c:RegisterFlagEffect(97057020,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c97057020.desop(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.FaceupFilter(c97057020.desfilter),tp,tg,tg,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c97057020.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local loc,tg=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TARGET_CARDS)
	if not tg or not tg:IsContains(c) then return false end
	return Duel.IsChainDisablable(ev) and loc~=LOCATION_DECK
end
function c97057020.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(97057020)==0 and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	c:RegisterFlagEffect(97057020,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_OVERLAY)
end
function c97057020.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not Duel.IsChainDisablable(ev) or not c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then return end
	if Duel.NegateEffect(ev) then
		c:RemoveOverlayCard(tp,1,1,REASON_COST)
		Duel.Destroy(re:GetHandler(),REASON_EFFECT)
	end
end