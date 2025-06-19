--Gensui Coverfire Cruiser - Isuzu
function c97057010.initial_effect(c)
	--special summon self and another
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(97057010,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,97057010)
	e1:SetCost(c97057010.spcost)
	e1:SetTarget(c97057010.sptg)
	e1:SetOperation(c97057010.spop)
	c:RegisterEffect(e1)
	--level raise
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(97057010,1))
	e2:SetCategory(CATEGORY_LVCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c97057010.lvcon)
	e2:SetTarget(c97057010.lvtg)
	e2:SetOperation(c97057010.lvop)
	c:RegisterEffect(e2)
	--Prevent activations in response to your "Gensui" Traps
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c97057010.chainop)
	c:RegisterEffect(e3)
end
function c97057010.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rp==tp and rc:IsSetCard(0x3bd) and re:IsActiveType(TYPE_MONSTER) then
		Duel.SetChainLimit(c97057010.chainlm)
	end
end
function c97057010.chainlm(e,rp,tp)
	return rp==tp or not (e:IsMonsterEffect()
	and e:GetActivateLocation()==LOCATION_HAND)
end
function c97057010.spcostfilter(c,e,tp)
	return c:IsSetCard(0x3bd) and not c:IsPublic() and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c97057010.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c97057010.spcostfilter,tp,LOCATION_HAND,0,1,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local rc=Duel.SelectMatchingCard(tp,c97057010.spcostfilter,tp,LOCATION_HAND,0,1,1,c,e,tp):GetFirst()
	Duel.ConfirmCards(1-tp,rc)
	e:SetLabelObject(rc)
	Duel.ShuffleHand(tp)
end
function c97057010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	local rc=e:GetLabelObject()
	Duel.SetTargetCard(rc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,Group.FromCards(c,rc),2,tp,0)
end
function c97057010.spfilter(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c97057010.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Group.FromCards(c,Duel.GetFirstTarget())
	if g:FilterCount(c97057010.spfilter,nil,e,tp)==2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2
		and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end

function c97057010.lvfilter(c,e)
	return c:IsFaceup() and c:IsSetCard(0x3bd)
end
function c97057010.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c97057010.lvfilter,1,nil) and not eg:IsContains(e:GetHandler())
end
function c97057010.filter(c)
	return c:IsFaceup() and c:HasLevel() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c97057010.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c97057010.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c97057010.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c97057010.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c97057010.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		--Increase Level
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end