--Gensui Breakthrough Cruiser - Sendai
function c97057011.initial_effect(c)
	--summon with 1 tribute
	local e1=aux.AddNormalSummonProcedure(c,true,true,1,1,SUMMON_TYPE_TRIBUTE,aux.Stringid(97057011,0),c97057011.otfilter)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(97057011,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(c97057011.spcon)
	e2:SetTarget(c97057011.sptg)
	e2:SetOperation(c97057011.spop)
	c:RegisterEffect(e2)
	--tribute check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c97057011.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--lv
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(97057011,2))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1)
	e4:SetTarget(c97057011.lvtg)
	e4:SetOperation(c97057011.lvop)
	c:RegisterEffect(e4)
	--Prevent activations in response to your "Gensui" Traps
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(c97057011.chainop)
	c:RegisterEffect(e5)
end
function c97057011.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rp==tp and rc:IsSetCard(0x3bd) and re:IsActiveType(TYPE_MONSTER) then
		Duel.SetChainLimit(c97057011.chainlm)
	end
end
function c97057011.chainlm(e,rp,tp)
	local ec=e:GetHandler()
	return not (e:IsHasType(EFFECT_TYPE_ACTIVATE)
	and ec:IsFacedown() and ec:IsLocation(LOCATION_SZONE))
end
function c97057011.otfilter(c,tp)
	return c:IsSetCard(0x3bd) and (c:IsControler(tp) or c:IsFaceup())
end
function c97057011.valcheck(e,c)
	local g=c:GetMaterial()
	if #g>0 then
		e:GetLabelObject():SetLabel(#g)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c97057011.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsTributeSummoned() and e:GetLabel()>0
end
function c97057011.eqfilter(c,cd)
	return c:IsCode(cd) and (c:IsFaceup() or not c:IsOnField())
end
function c97057011.spfilter(c,e,tp)
	return c:IsSetCard(0x3bd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not Duel.IsExistingMatchingCard(c97057011.eqfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function c97057011.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c97057011.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c97057011.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c97057011.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=aux.SelectUnselectGroup(g,e,tp,1,e:GetLabel(),aux.dncheck,1,tp,HINTMSG_SPSUMMON)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c97057011.rescon(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetCode)==#sg
end
function c97057011.lvfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(1) and c:IsRace(RACE_MACHINE)
end
function c97057011.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c97057011.lvfilter,tp,LOCATION_MZONE,0,nil,e)
	if chk==0 then return #g>1 and g:GetClassCount(Card.GetLevel)>1 end
	local tg=aux.SelectUnselectGroup(g,e,tp,2,#g,aux.dpcheck(Card.GetLevel),1,tp,HINTMSG_TARGET)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_LVCHANGE,tg,1,tp,1)
end
function c97057011.lvop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e):Match(Card.IsFaceup,nil)
	if #g>1 and g:GetClassCount(Card.GetLevel)>1 then
		local lc=g:Select(tp,1,1,nil)
		local lv=lc:GetFirst():GetLevel()
		g:Sub(lc)
		Duel.HintSelection(lc)
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
			e1:SetValue(lv)
			e1:SetReset(RESETS_STANDARD_PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
end