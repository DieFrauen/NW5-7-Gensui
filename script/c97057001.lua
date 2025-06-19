--Gensui Destroyer Unit - Fubuki
function c97057001.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(97057001,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c97057001.spcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(97057001,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,97057001)
	e2:SetTarget(c97057001.thtg)
	e2:SetOperation(c97057001.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(c97057001.detcon)
	c:RegisterEffect(e5)
	--gain atk (material)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_XMATERIAL)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCondition(c97057001.xyzcon)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetValue(c97057001.xyzval)
	c:RegisterEffect(e6)
end
function c97057001.cfilter(c)
	return c:IsFacedown() or not (c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_WATER))
end
function c97057001.spcon(e,c)
	return not Duel.IsExistingMatchingCard(c97057001.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c97057001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c97057001.thfilter(c)
	return c:IsSetCard(0x3bd) and c:IsAbleToHand()
end
function c97057001.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
	local dg=Duel.GetDecktopGroup(tp,3)
	if dg:FilterCount(Card.IsType,nil,TYPE_MONSTER)==#dg
	and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 then
		dg=Duel.GetDecktopGroup(tp,5)
	end
	Duel.ConfirmDecktop(tp,#dg)
	local g=dg:Match(c97057001.thfilter,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(97057001,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
	Duel.ShuffleDeck(tp)
end
function c97057001.detcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsActivated() and re:IsActiveType(TYPE_XYZ)
		and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c97057001.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSetCard(0x3bd)
end

function c97057001.xyzval(e,tp,eg,ep,ev,re,r,rp)
	local ov=e:GetHandler():GetOverlayGroup():FilterCount(Card.IsSetCard,nil,0x3bd)
	return ov*100
end