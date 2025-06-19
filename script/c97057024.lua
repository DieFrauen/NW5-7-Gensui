--Daigensui Decisive Doctrine
function c97057024.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Special Summon "Gensui" monsters from the hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(97057024,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,97057024)
	e2:SetTarget(c97057024.sptg)
	e2:SetOperation(c97057024.spop)
	c:RegisterEffect(e2)
	--Attach materials from hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(97057024,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,{97057024,1})
	e3:SetTarget(c97057024.mattg)
	e3:SetOperation(c97057024.matop)
	c:RegisterEffect(e3)
	--re-activate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(97057024,1))
	e4:SetCategory(CATEGORY_LEAVE_GRAVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,{97057024,2})
	e4:SetLabelObject(e1)
	e4:SetCondition(c97057024.tfcon)
	e4:SetTarget(c97057024.tftg)
	e4:SetOperation(c97057024.tfop)
	c:RegisterEffect(e4)
	--Destruction replacement
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTarget(c97057024.reptg)
	e5:SetOperation(c97057024.repop)
	c:RegisterEffect(e5)
end
function c97057024.cost(e,tp,eg,ep,ev,re,r,rp)
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c97057024.aclimit)
	Duel.RegisterEffect(e1,tp)
	aux.RegisterClientHint(e:GetHandler(),nil,tp,1,0,aux.Stringid(97057024,3),nil)
end
function c97057024.spfilter(c,e,tp)
	return c:IsSetCard(0x3bd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c97057024.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1,g2=
	Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0),
	Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	if chk==0 then return g1<g2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c97057024.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c97057024.spop(e,tp,eg,ep,ev,re,r,rp)
	local g1,g2=
	Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0),
	Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c97057024.spfilter,tp,LOCATION_HAND,0,1,g2-g1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c97057024.matfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3bd) and c:IsType(TYPE_XYZ)
end
function c97057024.attfilter(c)
	return c:IsRace(RACE_MACHINE) or c:IsAttribute(ATTRIBUTE_WATER)
end
function c97057024.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c97057024.matfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c97057024.matfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c97057024.attfilter,tp,LOCATION_HAND,0,1,nil)  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c97057024.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c97057024.matop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,c97057024.attfilter,tp,LOCATION_HAND,0,1,99,nil)
		if #g>0 then
			Duel.Overlay(tc,g)
			if Duel.IsPlayerCanDraw(tp,#g) and Duel.SelectYesNo(tp,aux.Stringid(97057024,3)) then
				Duel.Draw(tp,#g,REASON_EFFECT)
			end
		end
	end
end
function c97057024.tfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x23bd)
end
function c97057024.tfcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c97057024.tfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c97057024.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetLabelObject():IsActivatable(tp) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c97057024.tfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if e:GetLabelObject():IsActivatable(tp) then
		Duel.ActivateFieldSpell(c,e,tp,eg,ep,ev,re,r,rp)
	end
end
function c97057024.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE)
	and Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c97057024.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_EFFECT)
end