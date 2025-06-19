--Gensui Mystic Unit - Kasumi
function c97057007.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(97057007,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c97057007.spcon)
	c:RegisterEffect(e1)
	--shuffle to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(97057007,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,97057007)
	e2:SetTarget(c97057007.tdtg)
	e2:SetOperation(c97057007.tdop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(c97057007.detcon)
	c:RegisterEffect(e5)
	--Targeted monster becomes unaffected by other card effects
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(97057007,2))
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCost(c97057007.dcost)
	e6:SetCondition(c97057007.smcon)
	e6:SetTarget(c97057007.smtg)
	e6:SetOperation(c97057007.smop)
	c:RegisterEffect(e6)
end
function c97057007.detcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsActivated() and re:IsActiveType(TYPE_XYZ)
		and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c97057007.spfilter(c)
	return c:IsSetCard(0x3bd) and c:IsFaceup()
end
function c97057007.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c97057007.spfilter,tp,LOCATION_ONFIELD|LOCATION_GRAVE,0,nil)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and #g>2
end
function c97057007.tdfilter(c)
	return c:IsSetCard(0x3bd) and c:IsAbleToDeck()
end
function c97057007.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c97057007.tdfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c97057007.tdfilter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c97057007.tdfilter,tp,LOCATION_GRAVE,1,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c97057007.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SendtoDeck(tg,nil,SEQ_DECKTOP,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK|LOCATION_EXTRA)
	if ct==3 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c97057007.dcfilter(c)
	return c:IsCode(97057007)
end
function c97057007.dcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ov=c:GetOverlayGroup()
	if chk==0 then return ov:IsExists(c97057007.dcfilter,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local tov=ov:FilterSelect(tp,c97057007.dcfilter,1,1,nil)
	Duel.SendtoGrave(tov,REASON_COST)
end
function c97057007.smcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase() and e:GetHandler():IsSetCard(0x3bd)
end
function c97057007.smtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return not c:IsStatus(STATUS_CHAINING) end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_TRIGGER)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	e3:SetReset(RESET_CHAIN)
	c:RegisterEffect(e3)
end
function c97057007.smop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		--Unaffected by other card effects
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(3100)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c97057007.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+phase)
		c:RegisterEffect(e1)
	end
end
function c97057007.efilter(e,re)
	local c=e:GetHandler()
	return c~=re:GetOwner() and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end