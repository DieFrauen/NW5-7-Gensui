--Gensui Steadfast Carrier Soryu
function c97057014.initial_effect(c)
	--Pendulum summon
	Pendulum.AddProcedure(c)
	--Special Summon this card from your hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(97057014,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c97057014.spcon)
	c:RegisterEffect(e1)
	--Change levels
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(97057014,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c97057014.lvcon)
	e2:SetTarget(c97057014.lvtg)
	e2:SetOperation(c97057014.lvop)
	c:RegisterEffect(e2)
	--psummon lock
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetTargetRange(1,0)
	e3:SetCondition(c97057014.splimcon)
	e3:SetTarget(c97057014.splimit)
	c:RegisterEffect(e3)
	--search 1 Pendulum Card 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(97057014,2))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c97057014.thtg)
	e4:SetOperation(c97057014.thop)
	c:RegisterEffect(e4)
	--Destroy all opponen Spell/Trap cards on the field
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(97057014,3))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_CUSTOM+97057014)
	e5:SetRange(LOCATION_PZONE)
	e5:SetTarget(c97057014.destg)
	e5:SetOperation(c97057014.desop)
	c:RegisterEffect(e5)
end
function c97057014.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c97057014.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsRace(RACE_MACHINE) and (sumtp&SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c97057014.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
end
function c97057014.lvfilter(c,e)
	return c:IsFaceup() and c:IsSetCard(0x3bd) and c:HasLevel() and c:IsCanBeEffectTarget(e) 
end
function c97057014.lvcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local lc,rc=Duel.GetFieldCard(tp,LOCATION_PZONE,0),Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if not (lc and rc) then return end
	local lc=lc:GetLeftScale()
	local rc=rc:GetRightScale()
	if lc>rc then lc,rc=rc,lc end
	return rc>lc+1
end
function c97057014.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c97057014.lvfilter,tp,LOCATION_MZONE,0,nil,e)
	local lvf=g:GetFirst():GetLevel()
	if g:GetClassCount(Card.GetLevel)>1 then lvf=nil end
	if chk==0 then return #g>1 and g end
	local lc=Duel.GetFieldCard(tp,LOCATION_PZONE,0):GetLeftScale()
	local rc=Duel.GetFieldCard(tp,LOCATION_PZONE,1):GetRightScale()
	if lc>rc then lc,rc=rc,lc end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LVRANK)
	local lv=Duel.AnnounceLevel(tp,lc+1,rc-1,lvf)
	g:Sub(g:Filter(function (c,lv); return c:GetLevel()==lv end,nil))
	local tg=g:Select(tp,1,#g,nil)
	Duel.SetTargetCard(tg)
	Duel.SetTargetParam(lv)
end
function c97057014.lvop(e,tp,eg,ep,ev,re,r,rp)
	local g,lv=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS,CHAININFO_TARGET_PARAM)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 and lv then
		for tc in sg:Iter() do
			if tc:GetLevel()~=lv then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_CHANGE_LEVEL)
				e1:SetValue(lv)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
		end
	end
end
function c97057014.thfilter(c,lv)
	return c:IsSetCard(0x3bd) and c:IsType(TYPE_PENDULUM) and c:IsLevel(lv) and c:IsAbleToHand()
end
function c97057014.revfilter(c,tp)
	return c:IsRace(RACE_MACHINE) and c:IsAbleToDeck() and not c:IsPublic()
		and Duel.IsExistingMatchingCard(c97057014.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetLevel())
end
function c97057014.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c97057014.revfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c97057014.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,c97057014.revfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	if #g1==0 then return end
	Duel.ConfirmCards(1-tp,g1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp,c97057014.thfilter,tp,LOCATION_DECK,0,1,1,nil,g1:GetFirst():GetLevel())
	if #g2==0 then return end
	Duel.BreakEffect()
	if Duel.SendtoHand(g2,nil,REASON_EFFECT)>0 and g2:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g2)
		Duel.BreakEffect()
		Duel.SendtoDeck(g1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function c97057014.pcfilter(c)
	return c:IsSetCard(0x3bd) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c97057014.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckPendulumZones(tp) and Duel.IsExistingMatchingCard(c97057014.pcfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c97057014.pcop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or not Duel.CheckPendulumZones(tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c97057014.pcfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c97057014.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c97057014.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end