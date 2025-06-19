--Gensui Escort Ryuho
function c97057008.initial_effect(c)
	--Pendulum summon
	Pendulum.AddProcedure(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(97057008,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c97057008.spcon)
	e1:SetTarget(c97057008.sptg)
	e1:SetOperation(c97057008.spop)
	c:RegisterEffect(e1)
	--place in Pzone
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(97057008,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c97057008.pencon)
	e2:SetTarget(c97057008.pentg)
	e2:SetOperation(c97057008.penop)
	c:RegisterEffect(e2)
	--fetch pendulum target
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(97057008,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCountLimit(1,97057008)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c97057008.thcon)
	e3:SetTarget(c97057008.thtg)
	e3:SetOperation(c97057008.thop)
	c:RegisterEffect(e3)
end
function c97057008.cfilter(c,tp)
	return c:IsFaceup() and c:IsSummonPlayer(tp) and c:IsSetCard(0x3bd)
end
function c97057008.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c97057008.cfilter,1,nil,tp)
end
function c97057008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c97057008.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c97057008.pencon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsActivated() and re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsAttribute(ATTRIBUTE_WATER)
end
function c97057008.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckPendulumZones(tp) end
end
function c97057008.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckPendulumZones(tp) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c97057008.thcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	local atype=re:GetActiveType()
	return atype==TYPE_PENDULUM+TYPE_SPELL and (loc&LOCATION_PZONE)~=0 and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler()~=e:GetHandler()
end
function c97057008.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c97057008.thfilter(c,lc,rc)
	local lv=c:GetLevel()
	return c:IsRace(RACE_MACHINE) and c:IsAbleToHand() and
	(c:IsType(TYPE_PENDULUM) or (c:HasLevel() and lv>lc and lv<rc))
end
function c97057008.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<5 then return end
	local dg=Duel.GetDecktopGroup(tp,5)
	Duel.ConfirmDecktop(tp,#dg)
	local lc=Duel.GetFieldCard(tp,LOCATION_PZONE,0):GetLeftScale()
	local rc=Duel.GetFieldCard(tp,LOCATION_PZONE,1):GetRightScale()
	if lc>rc then lc,rc=rc,lc end
	local g=dg:Match(c97057008.thfilter,nil,lc,rc)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(97057008,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
	Duel.ShuffleDeck(tp)
end