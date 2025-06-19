--Shingensui Superdreadnought Yamato
function c97057022.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,11,2,nil,nil,Xyz.InfiniteMats,nil,true)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c97057022.splimit)
	c:RegisterEffect(e1)
	--Destruction replacement
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c97057022.reptg)
	e2:SetOperation(c97057022.repop)
	c:RegisterEffect(e2)
	--Your opponent's monsters cannot target monsters for attacks, except this one
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(function(e,c) return c~=e:GetHandler() end)
	c:RegisterEffect(e3)
	--Your opponent cannot target target other cards on the field with card effects
	local e4=e3:Clone()
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e4:SetTarget(function(e,c) return c~=e:GetHandler() end)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetDescription(aux.Stringid(97057022,0))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetLabel(0)
	e5:SetCost(c97057022.cost)
	e5:SetTarget(c97057022.target)
	e5:SetOperation(c97057022.operation)
	c:RegisterEffect(e5,false,REGISTER_FLAG_DETACH_XMAT)
	--quick (shimakaze)
	local e6=e5:Clone()
	e6:SetDescription(aux.Stringid(97057022,1))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetLabel(1)
	e6:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e6)   
	--reactive (suzutsuki)
	local e7=e5:Clone()
	e7:SetDescription(aux.Stringid(97057022,2))
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_CHAIN_SOLVED)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e7:SetLabel(2)
	e7:SetCondition(c97057022.rccon)
	c:RegisterEffect(e7)
	--destroy zones (Yamato)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetCode(97057022)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(1,0)
	c:RegisterEffect(e8)
end
function c97057022.rccon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp 
end
function c97057022.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x3bd)
end
function c97057022.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c97057022.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_EFFECT)
end
function c97057022.rescon(sg,e,tp,mg)
	if e:GetLabel()==1 then
		return sg:IsExists(Card.IsCode,1,nil,97057000)
	elseif e:GetLabel()==2 then
		return sg:IsExists(Card.IsCode,1,nil,97057006)
	else return true end
end
function c97057022.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	for i,pe in ipairs({Duel.GetPlayerEffect(tp,97057017)}) do
		g:Merge(pe:GetHandler():GetOverlayGroup())
	end
	if Duel.IsPlayerAffectedByEffect(tp,97057021) then
		local g2=Duel.GetMatchingGroup(c97057021.edfilter,tp,LOCATION_EXTRA,0,nil) 
		g:Merge(g2)
	end
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,2,#g,c97057022.rescon,0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg=aux.SelectUnselectGroup(g,e,tp,2,#g,c97057022.rescon,1,tp,HINTMSG_XMATERIAL,c97057022.rescon)
	e:SetLabelObject(sg)
	sg:KeepAlive()
	e:SetLabel(#sg)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c97057022.tgfilter(c,e,g)
	return c:IsCanBeEffectTarget(e) or g and g:IsExists(Card.IsCode,97057003)
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
	if seq<=4 then --No EMZ
		if seq+1<=4 then optadd(loc,seq+1) end
		if seq-1>=0 then optadd(loc,seq-1) end
	end
	if loc==LOCATION_MZONE then
		if seq<5 then
			optadd(LOCATION_SZONE,seq)
			if seq==1 then optadd(LOCATION_MZONE,5) end
			if seq==3 then optadd(LOCATION_MZONE,6) end
		elseif seq==5 then
			optadd(LOCATION_MZONE,1)
		elseif seq==6 then
			optadd(LOCATION_MZONE,3)
		end
	else -- loc == LOCATION_SZONE
		optadd(LOCATION_MZONE,seq)
	end
	return g
end
function c97057022.adjc(c,tc,seq)
	if tc:IsLocation(LOCATION_SZONE) and c:IsControler(tc:GetControler()) then
		if c:IsLocation(LOCATION_MZONE) then return c:IsSequence(seq) end
		return true
	elseif tc:IsLocation(LOCATION_MZONE) then
		if c:IsLocation(LOCATION_SZONE) then
			return tc:IsInMainMZone() and tc:GetColumnGroup():IsContains(c) and c:IsControler(tc:GetControler())
		elseif c:IsLocation(LOCATION_MZONE) then
			if c:IsInExtraMZone() or tc:IsInExtraMZone() then
				return tc:GetColumnGroup():IsContains(c)
			else
				return c:IsSequence(seq-1,seq+1) and c:IsControler(tc:GetControler())
			end
		end
	end
	return false
end
function c97057022.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=e:GetHandler():GetOverlayGroup()
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(c97057022.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e,g) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	g=e:GetLabelObject()
	local lm=1
	if g:IsExists(Card.IsCode,1,nil,97057002) then lm=2 end
	if g and g:IsExists(Card.IsCode,1,nil,97057003) and Duel.SelectYesNo(tp,aux.Stringid(97057003,1)) then
		local zone=Duel.SelectFieldZone(tp,1,0,LOCATION_ONFIELD,0)
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
		e:SetOperation(c97057022.operation2)
	else
		local tc=Duel.SelectTarget(tp,c97057022.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,lm,nil,e,g)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
		e:SetOperation(c97057022.operation)
		if g and g:IsExists(Card.IsCode,1,nil,97057023) then
			c97057023.disable(e,tp,tc)
		end
	end
	if g and g:IsExists(Card.IsCode,1,nil,97057005) then
		Duel.SetChainLimit(c97057005.limit())
	end
end
function c97057022.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	local lb=e:GetLabelObject()
	local dg,g2=Group.CreateGroup()
	local tc=sg:GetFirst()
	for tc in aux.Next(sg) do
		dg:AddCard(tc)
		local g2=tc:GetColumnGroup(1,1):Filter(c97057022.adjc,nil,tc,tc:GetSequence())
		dg:Merge(g2)
	end
	if #dg>0 then
		local loc=nil
		if #lb>1 and Duel.IsPlayerAffectedByEffect(tp,97057015) and Duel.SelectYesNo(tp,aux.Stringid(97057015,4)) then
			Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)
		else
			Duel.Destroy(dg,REASON_EFFECT,loc)
		end
		dg=Duel.GetOperatedGroup()
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
function c97057022.operation2(e,tp,eg,ep,ev,re,r,rp)
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
function c97057022.yamato(e,tp,g)
	local tc=g:GetFirst()
	local seq,nseq=0
	for tc in aux.Next(g) do
		if not tc:IsOnField() and
		tc:GetPreviousLocation()==LOCATION_MZONE then
			nseq=tc:GetPreviousSequence()
			seq=bit.replace(seq,0x1,nseq)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetLabel(seq*0x10000)
	e1:SetOperation(c97057022.disop)
	e1:SetReset(RESET_PHASE|PHASE_STANDBY|RESET_SELF_TURN)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_CARD,1-tp,97057022)
end
function c97057022.disop(e,tp)
	return e:GetLabel()
end