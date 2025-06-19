--Daigensui Fast Battleship - Kongo
function c97057018.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_MACHINE),7,2,nil,nil,Xyz.InfiniteMats)
	--cannot be target OR destroyed
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c97057018.rtgfilter)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c97057018.desfilter)
	c:RegisterEffect(e2)
	--destroy column
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetDescription(aux.Stringid(97057018,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,97057018)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c97057018.cost)
	e3:SetTarget(c97057018.target)
	e3:SetOperation(c97057018.operation)
	c:RegisterEffect(e3,false,REGISTER_FLAG_DETACH_XMAT)
	--quick (shimakaze)
	local e4=e3:Clone()
	e4:SetDescription(aux.Stringid(97057018,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetLabel(1)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e4)   
	--reactive (suzutsuki)
	local e5=e3:Clone()
	e5:SetDescription(aux.Stringid(97057018,2))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_CHAIN_SOLVED)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e5:SetLabel(2)
	e5:SetCondition(c97057018.rccon)
	c:RegisterEffect(e5)
	--return "Gensui" Monster from GY to Hand
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(97057018,3))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetProperty(EFFECT_FLAG_DELAY|EFFECT_FLAG_CARD_TARGET)
	e6:SetCountLimit(1,{97057018,1})
	e6:SetTarget(c97057018.thtg)
	e6:SetOperation(c97057018.thop)
	c:RegisterEffect(e6)
end
function c97057018.rccon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp 
end
function c97057018.rtgfilter(e,re,rp)
	return rp~=e:GetHandlerPlayer() and not re:IsHasCategory(CATEGORY_DESTROY)
end
function c97057018.desfilter(e,re,rp)
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
		if c then
			g:AddCard(c)
			g:Merge(c:GetColumnGroup())
		end
	end
	optadd(loc,seq)
	return g
end
function c97057018.rescon(sg,e,tp,mg)
	if e:GetLabel()==1 then
		return sg:IsExists(Card.IsCode,1,nil,97057000)
	elseif e:GetLabel()==2 then
		return sg:IsExists(Card.IsCode,1,nil,97057006)
	else return true end
end
function c97057018.tgfilter(c,e,g)
	return c:IsCanBeEffectTarget(e)
	or (g and g:IsExists(Card.IsCode,1,nil,97057003))
end
function c97057018.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	for i,pe in ipairs({Duel.GetPlayerEffect(tp,97057017)}) do
		g:Merge(pe:GetHandler():GetOverlayGroup())
	end
	if Duel.IsPlayerAffectedByEffect(tp,97057021) then
		local g2=Duel.GetMatchingGroup(c97057021.edfilter,tp,LOCATION_EXTRA,0,nil) 
		g:Merge(g2)
	end
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,2,#g,c97057018.rescon,0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg=aux.SelectUnselectGroup(g,e,tp,2,#g,c97057018.rescon,1,tp,HINTMSG_XMATERIAL,c97057018.rescon)
	e:SetLabelObject(sg)
	sg:KeepAlive()
	e:SetLabel(#sg)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c97057018.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=e:GetHandler():GetOverlayGroup()
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(c97057018.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e,g) end
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
		e:SetOperation(c97057018.operation2)
	else
		local tc=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,lm,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
		e:SetOperation(c97057018.operation)
		if g and g:IsExists(Card.IsCode,1,nil,97057023) then
			c97057023.disable(e,tp,tc)
		end
	end
	if g and g:IsExists(Card.IsCode,1,nil,97057005) then
		Duel.SetChainLimit(c97057005.limit(e))
	end
end
function c97057018.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local lb=e:GetLabelObject()
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	local dg=Group.CreateGroup()
	local tc=sg:GetFirst()
	for tc in aux.Next(g) do
		dg:Merge(tc:GetColumnGroup())
		dg:AddCard(tc)
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
function c97057018.operation2(e,tp,eg,ep,ev,re,r,rp)
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
function c97057018.filter(c)
	return c:IsSetCard(0x3bd) and c:IsAbleToHand()
end
function c97057018.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c97057018.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c97057018.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c97057018.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c97057018.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end