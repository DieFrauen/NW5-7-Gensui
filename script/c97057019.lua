--Daigensui Fleet Carrier - Zuikaku
function c97057019.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x3bd),7,2,nil,nil,Xyz.InfiniteMats)
	Pendulum.AddProcedure(c)
	c:EnableReviveLimit()
	--Destroy all Spell/Trap cards on the field
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(97057019,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c97057019.descon1)
	e1:SetTarget(c97057019.destg)
	e1:SetOperation(c97057019.desop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(c97057019.descon2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetTarget(c97057019.tgtg)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--search 1 Pendulum Card 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(97057014,3))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c97057019.thtg)
	e4:SetOperation(c97057019.thop)
	c:RegisterEffect(e4)
end
c97057019.pendulum_level=7
function c97057019.tgtg(e,c)
	if c==e:GetHandler() then
		return Duel.IsExistingMatchingCard(c97057019.sffilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,c)
	else
		return c:IsType(TYPE_XYZ) and c:IsMonster()
	end
end
function c97057019.sffilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function c97057019.descon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
	or e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM) 
end
function c97057019.descon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_BATTLE|REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp)
end
function c97057019.pcfilter(c)
	local sc=c:GetLeftScale()
	return c:IsSetCard(0x3bd) and c:IsType(TYPE_PENDULUM)   
	and c:IsFaceup() and not c:IsForbidden()
end
function c97057019.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
		Duel.IsExistingMatchingCard(nil,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) or
		Duel.IsExistingMatchingCard(c97057019.pcfilter,tp,LOCATION_EXTRA,0,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c97057019.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	local pg=Duel.GetMatchingGroup(c97057019.pcfilter,tp,LOCATION_EXTRA,0,nil)
	local op=false
	if #g>0 and (#pg==0 or not Duel.CheckPendulumZones(tp) or Duel.SelectYesNo(tp,aux.Stringid(97057019,1))) then 
		op=false
		Duel.Destroy(g,REASON_EFFECT)
	else op=true end
	pg=Duel.GetMatchingGroup(c97057019.pcfilter,tp,LOCATION_EXTRA,0,nil)
	if #pg>0 and (op or Duel.SelectYesNo(tp,aux.Stringid(97057019,2))) then
		local tc=pg:Select(tp,1,1,nil):GetFirst()
		Duel.BreakEffect()
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c97057019.thfilter(c)
	return c:IsSetCard(0x3bd) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and c:IsFaceup()
end
function c97057019.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_PZONE 
	if chk==0 then return Duel.IsExistingMatchingCard(c97057019.thfilter,tp,loc,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,loc)
end
function c97057019.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c97057019.thfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_PZONE,0,1,1,e:GetHandler())
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
	end
end