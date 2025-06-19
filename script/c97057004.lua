--Gensui Miracle Unit - Yukikaze
function c97057004.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,97057004)
	e1:SetCondition(c97057004.spcon1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c97057004.spcon2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_LEAVE_FIELD_P)
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCondition(c97057004.remcon)
	e3:SetOperation(c97057004.remop)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_CONTINUOUS)
	c:RegisterEffect(e4)
end
function c97057004.spcon1(e,c)
	if c==nil then return true end
	return (Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		or Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>0)
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c97057004.spcon2(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsMainPhase() and not Duel.CheckPhaseActivity()
end
function c97057004.remfilter(c)
	return c:IsSetCard(0x3bd) and c:IsMonster() and c:IsAbleToHand() and not c:IsCode(97057004)
end
function c97057004.remcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local hg=c:GetOverlayGroup():Filter(Card.IsCode,nil,97057004)
	local og=c:GetOverlayGroup():Filter(c97057004.remfilter,nil)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x3bd) and not c:IsDisabled()
end
function c97057004.remop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup():Filter(Card.IsCode,nil,97057004)
	local hg=c:GetOverlayGroup():Filter(c97057004.remfilter,nil)
	hg:Sub(og)
	if #og>0 and #hg>0 and Duel.SelectEffectYesNo(tp,c,aux.Stringid(97057004,1)) then
		hg=hg:Select(tp,1,#og,nil)
		Duel.BreakEffect()
		Duel.SendtoGrave(og,REASON_COST)
		Duel.SendtoHand(hg,nil,REASON_EFFECT)
	end
end