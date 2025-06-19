--Daigensui Elite Unit - Suzutsuki
function c97057006.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c97057006.spcon)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(97057006,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,97057006)
	e2:SetTarget(c97057006.drtg)
	e2:SetOperation(c97057006.drop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c97057006.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==1
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c97057006.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x3bd)
end
function c97057006.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local hc=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local fc=Duel.GetMatchingGroupCount(c97057006.filter,tp,LOCATION_MZONE,0,nil)
	local dc=math.min(hc,fc)-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if chk==0 then return dc>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,dc)
end
function c97057006.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local hc=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local fc=Duel.GetMatchingGroupCount(c97057006.filter,tp,LOCATION_MZONE,0,nil)
	local ct=math.min(hc,fc)-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if ct<=0 then return end
	Duel.Draw(p,ct,REASON_EFFECT)
end