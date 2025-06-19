--Daigensui Armed Fortress Taihou
function c97057021.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,9,2,nil,nil,Xyz.InfiniteMats)
	c:EnableReviveLimit()
	--Destroy all Spell/Trap cards on the field
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(97057021,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c97057021.retcon)
	e1:SetTarget(c97057021.rettg)
	e1:SetOperation(c97057021.retop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c97057021.negcon)
	e2:SetOperation(c97057021.negop)
	c:RegisterEffect(e2)
	--Place itself in the pendulum zone
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(97057021,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c97057021.pencon)
	e3:SetTarget(c97057021.pentg)
	e3:SetOperation(c97057021.penop)
	c:RegisterEffect(e3)
	--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c97057021.txtg)
	e4:SetOperation(c97057021.txop)
	c:RegisterEffect(e4)
	--Destruction replacement
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_PZONE)
	e5:SetTarget(c97057021.reptg)
	e5:SetOperation(c97057021.repop)
	c:RegisterEffect(e5)
	--use extra deck xyz material
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(97057021)
	e6:SetRange(LOCATION_PZONE)
	e6:SetTargetRange(1,0)
	c:RegisterEffect(e6)
	
end
c97057021.pendulum_level=9
function c97057021.edfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsAbleToGrave()
end
function c97057021.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
	or e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM) 
end
function c97057021.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end
function c97057021.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	local op=false
	if #g>0 then 
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c97057021.negcon(e,tp,eg,ep,ev,re,r,rp)
	local chnk=Duel.GetCurrentChain(true)-1
	if not (chnk>0 and rp==1-tp and Duel.IsChainDisablable(ev)) then return false end
	local treff=Duel.GetChainInfo(chnk,CHAININFO_TRIGGERING_EFFECT)
	return treff and treff:GetHandler():IsSetCard(0x3bd)
end
function c97057021.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then
		if c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)>0 then
			Duel.Hint(HINT_CARD,0,97057021)
			Duel.NegateEffect(ev)
		end
	else
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c97057021.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r&REASON_EFFECT+REASON_BATTLE~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c97057021.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckPendulumZones(tp) end
end
function c97057021.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckPendulumZones(tp) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c97057021.txfilter(c,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x3bd) and not c:IsForbidden()
end
function c97057021.txtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c97057021.txfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
end
function c97057021.txop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26067006,3))
	local g=Duel.SelectMatchingCard(tp,c97057021.txfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	if #g>0 then
		Duel.SendtoExtraP(g,tp,REASON_EFFECT)
	end
end
function c97057021.repfilter(c,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsDestructable()
end
function c97057021.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c97057021.repfilter,tp,LOCATION_EXTRA,0,nil,tp)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and #g>0 end
	return true
end
function c97057021.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c97057021.repfilter,tp,LOCATION_EXTRA,0,nil,tp)
	Duel.Destroy(g,REASON_REPLACE+REASON_EFFECT)
end