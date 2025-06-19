--Daigensui Armed Cruiser Suzuya
function c97057016.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x3bd),5,2)
	Pendulum.AddProcedure(c)
	c:EnableReviveLimit()   
	--return Pendulum to Hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(97057016,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c97057016.thcon)
	e1:SetTarget(c97057016.thtg)
	e1:SetOperation(c97057016.thop)
	c:RegisterEffect(e1)
	--destroy Spell/Trap
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(97057016,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetCountLimit(1,97057016)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c97057016.descon1)
	e2:SetTarget(c97057016.destg1)
	e2:SetOperation(c97057016.desop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(97057016,21))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,{97057016,1})
	e3:SetCondition(c97057016.descon2)
	e3:SetTarget(c97057016.destg2)
	c:RegisterEffect(e3)
	--pendulum set
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTarget(c97057016.pentg)
	e4:SetOperation(c97057016.penop)
	c:RegisterEffect(e4)
end
c97057016.pendulum_level=5
function c97057016.thfilter(c)
	return c:IsSetCard(0x3bd) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and c:IsFaceup()
end
function c97057016.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
	or e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM) 
end
function c97057016.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_OVERLAY 
	if chk==0 then return Duel.IsExistingMatchingCard(c97057016.thfilter,tp,loc,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,loc)
end
function c97057016.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c97057016.thfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_OVERLAY ,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
	end
end
function c97057016.filter1(c)
	return c:IsFaceup() and c:IsSpellTrap()
end
function c97057016.descon1(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	local atype=re:GetActiveType()
	return atype==TYPE_PENDULUM+TYPE_SPELL and (loc&LOCATION_PZONE)~=0 and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c97057016.filter2(c,tp)
	return c:IsPendulumSummoned() and c:IsSummonPlayer(tp)
end
function c97057016.descon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c97057016.filter2,1,nil,tp)
end
function c97057016.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c97057016.filter1(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c97057016.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c97057016.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c97057016.destg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c97057016.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c97057016.penfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x3bd) and not c:GetLeftScale()==6 and not c:IsForbidden() 
end
function c97057016.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c97057016.penfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c97057016.penop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c97057016.penfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end