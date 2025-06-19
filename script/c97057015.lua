--Gensui Assault Cruiser Chokai
function c97057015.initial_effect(c)
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,nil,5,2,nil,nil,Xyz.InfiniteMats)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c97057015.stcon)
	e1:SetOperation(c97057015.stop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c97057015.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--banish destroyed targets (Chokai)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(97057015)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetDescription(aux.Stringid(97057015,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,97057015)
	e4:SetRange(LOCATION_MZONE)
	e4:SetLabel(0)
	e4:SetCost(c97057015.cost)
	e4:SetTarget(c97057015.target)
	e4:SetOperation(c97057015.operation)
	c:RegisterEffect(e4,false,REGISTER_FLAG_DETACH_XMAT)
	--quick (shimakaze)
	local e5=e4:Clone()
	e5:SetDescription(aux.Stringid(97057015,2))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetLabel(1)
	e5:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e5)   
	--reactive (suzutsuki)
	local e6=e4:Clone()
	e6:SetDescription(aux.Stringid(97057015,3))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_CHAIN_SOLVED)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e6:SetLabel(2)
	e6:SetCondition(c97057015.rccon)
	c:RegisterEffect(e6)
end
function c97057015.rccon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp 
end
function c97057015.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsSetCard,3,nil,0x3bd) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c97057015.stcon(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
	and e:GetLabel()==1 and (phase==PHASE_MAIN1 or phase==PHASE_MAIN2)
end
function c97057015.stop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c97057015.actlimit)
	e1:SetReset(RESET_PHASE+phase)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_CARD,1-tp,97057015)
end
function c97057015.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c97057015.rescon(sg,e,tp,mg)
	if e:GetLabel()==1 then
		return sg:IsExists(Card.IsCode,1,nil,97057000)
	elseif e:GetLabel()==2 then
		return sg:IsExists(Card.IsCode,1,nil,97057006)
	else return true end
end
function c97057015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	for i,pe in ipairs({Duel.GetPlayerEffect(tp,97057017)}) do
		g:Merge(pe:GetHandler():GetOverlayGroup())
	end
	if Duel.IsPlayerAffectedByEffect(tp,97057021) then
		local g2=Duel.GetMatchingGroup(c97057021.edfilter,tp,LOCATION_EXTRA,0,nil) 
		g:Merge(g2)
	end
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,1,#g,c97057015.rescon,0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg=aux.SelectUnselectGroup(g,e,tp,1,#g,c97057015.rescon,1,tp,HINTMSG_XMATERIAL,c97057015.rescon)
	e:SetLabelObject(sg)
	sg:KeepAlive()
	e:SetLabel(#sg)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c97057015.tgfilter(c,e,g)
	return c:IsCanBeEffectTarget(e) or g and g:IsExists(Card.IsCode,1,nil,97057003)
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
function c97057015.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=e:GetHandler():GetOverlayGroup()
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(c97057015.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e,g) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	g=e:GetLabelObject()
	local lm=1
	if g:IsExists(Card.IsCode,1,nil,97057002) then lm=2 end
	if g and g:IsExists(Card.IsCode,1,nil,97057003) and Duel.SelectYesNo(tp,aux.Stringid(97057003,1)) then
		local zone=Duel.SelectFieldZone(tp,1,LOCATION_ONFIELD,LOCATION_ONFIELD,0)
		e:SetLabel(zone)
		local sg=groupfrombit(zone>>16,1-tp)
		if zone and lm>1 then
			local zone2=Duel.SelectFieldZone(tp,1,LOCATION_ONFIELD,LOCATION_ONFIELD,zone)
			e:SetLabel(zone,zone2)
			sg:Merge(groupfrombit(zone2>>16,1-tp))
			Duel.Hint(HINT_ZONE,tp,zone+zone2)
			Duel.Hint(HINT_ZONE,1-tp,zone>>16)
		else
			Duel.Hint(HINT_ZONE,tp,zone)
			Duel.Hint(HINT_ZONE,1-tp,zone>>16)
		end
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,1,0,0)
		e:SetOperation(c97057015.operation2)
	else
		local tc=Duel.SelectTarget(tp,c97057015.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,lm,nil,e,g)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
		e:SetOperation(c97057015.operation)
		if g and g:IsExists(Card.IsCode,1,nil,97057023) then
			c97057023.disable(e,tp,tc)
		end
	end
	if g and g:IsExists(Card.IsCode,1,nil,97057005) then
		Duel.SetChainLimit(c97057005.limit())
	end
end
function c97057015.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=g:Filter(Card.IsRelateToEffect,nil,e)
	local lb=e:GetLabelObject()
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
function c97057015.operation2(e,tp,eg,ep,ev,re,r,rp)
	local zone,zone2=e:GetLabel()
	local lb=e:GetLabelObject()
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