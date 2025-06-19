--Gensui Heavy Cruiser Haguro
function c97057017.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_MACHINE),5,2)
	c:EnableReviveLimit()
	--recover targets 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(97057017,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c97057017.thtg)
	e1:SetOperation(c97057017.thop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c97057017.destg)
	e2:SetValue(c97057017.value)
	e2:SetOperation(c97057017.desop)
	c:RegisterEffect(e2)
	--share xyz materials (Haguro)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(97057017)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3)
end
function c97057017.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) 
end
function c97057017.filter(c)
	return c:IsMonster() and c:IsSetCard(0x3bd) and c:IsAbleToHand()
end
function c97057017.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c97057017.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c97057017.filter,tp,LOCATION_GRAVE,0,1,nil) end
	local c,ct=e:GetHandler(),1
	if c:IsStatus(STATUS_SPSUMMON_TURN) and c:GetSummonType()&SUMMON_TYPE_XYZ ==SUMMON_TYPE_XYZ then ct=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c97057017.filter,tp,LOCATION_GRAVE,1,ct,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end
function c97057017.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) then return end
		Duel.BreakEffect()
		local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Filter(Card.IsSetCard,nil,0x3bd)
		sg=hg:Select(tp,#sg,#sg,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.Overlay(c,sg)
	end
end
function c97057017.dfilter(c,tp)
	return not c:IsReason(REASON_REPLACE) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsControler(tp) and c:IsRace(RACE_MACHINE)
end
function c97057017.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local count=eg:FilterCount(c97057017.dfilter,nil,tp)
		e:SetLabel(count)
		return count>0 and
		e:GetHandler():CheckRemoveOverlayCard(tp,count,REASON_EFFECT)
	end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c97057017.value(e,c)
	return c:IsFaceup() and c:GetLocation()==LOCATION_MZONE and c:IsRace(RACE_MACHINE)
end
function c97057017.desop(e,tp,eg,ep,ev,re,r,rp)
	local count=e:GetLabel()
	Duel.RemoveOverlayCard(tp,1,0,count,count,REASON_EFFECT)
end