--Daigensui Command Cruiser - Yahagi
function c97057012.initial_effect(c)
	local e1=aux.AddNormalSummonProcedure(c,true,true,1,1,SUMMON_TYPE_TRIBUTE,aux.Stringid(97057012,0),c97057012.otfilter)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(97057012,1))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	c:RegisterEffect(e2)
	--tribute check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c97057012.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SUMMON_COST)
	e4:SetOperation(c97057012.facechk)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	--raise level in response
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(97057012,2))
	e5:SetCategory(CATEGORY_LVCHANGE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c97057012.lvcon)
	e5:SetTarget(c97057012.lvtg)
	e5:SetOperation(c97057012.lvop)
	c:RegisterEffect(e5)
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(97057012,3))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(c97057012.sptg)
	e6:SetOperation(c97057012.spop)
	c:RegisterEffect(e6)
	--Prevent activations in response to your "Gensui" Traps
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_CHAINING)
	e7:SetRange(LOCATION_MZONE)
	e7:SetOperation(c97057012.chainop)
	c:RegisterEffect(e7)
end
c97057012[0]=0
function c97057012.otfilter(c,tp)
	return c:IsSetCard(0x3bd) and (c:IsControler(tp) or c:IsFaceup())
end
function c97057012.valcheck(e,c)
	local g=c:GetMaterial()
	if e:GetLabel()==1 then
		e:SetLabel(0)
		--atk continuous effect
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(500*#g)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE&~RESET_TOFIELD)
		c:RegisterEffect(e1)
		--def continuous effect
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_LEVEL)
		e2:SetValue(2*#g)
		c:RegisterEffect(e2)
	end
end
function c97057012.facechk(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(1)
end
function c97057012.lvcon(e,tp,eg,ep,ev,re,r,rp)
	if rp==1-tp then return false end
	local trp,setc,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_SETCODES,CHAININFO_TRIGGERING_LOCATION)
	if trp==1-tp then return false end
	for _,arch in ipairs(setc) do
		if ((0x3bd&0xfff)==(arch&0xfff) and (arch&0x3bd)==0x3bd) then
			return loc==LOCATION_MZONE 
		end
	end
end
function c97057012.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c,rc=e:GetHandler(),re:GetHandler()
	if chkc then return rc end
	if chk==0 then return rc:HasLevel() and rc:GetLevel()~=c:GetLevel() end
	rc:CreateEffectRelation(e)
	Duel.SetTargetCard(rc)
end
function c97057012.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c,rc=e:GetHandler(),Duel.GetFirstTarget()
	if not c and c:IsRelateToEffect() and rc and rc:IsRelateToEffect(e) then return end
	local lv1,lv2=c:GetLevel(),rc:GetLevel()
	if lv1~=lv2 then 
		--atk continuous effect
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(c:GetLevel())
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		rc:RegisterEffect(e1)
	end
end
function c97057012.filter(c,e,tp)
	return c:IsSetCard(0x3bd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c97057012.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c97057012.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c97057012.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c97057012.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c97057012.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c97057012.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rp==tp and rc:IsSetCard(0x3bd) and re:IsActiveType(TYPE_MONSTER) then
		c97057012[0]=c97057012.lv(rc)
		Duel.SetChainLimit(c97057012.chainlm)
	end
end
function c97057012.chainlm(e,rp,tp)
	local c=e:GetHandler()
	return rp==tp or not (e:IsMonsterEffect()
	and e:GetActivateLocation()==LOCATION_MZONE 
	and c97057012.lv(c)<c97057012[0])
end
function c97057012.lv(c)
	local lv=c:GetLevel()
	if c:IsType(TYPE_XYZ) then lv=c:GetRank() end
	return lv
end