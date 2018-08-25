--
-- Author: zhong
-- Date: 2016-11-04 11:36:24
--
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local PopupInfoHead = appdf.req(appdf.EXTERNAL_SRC .. "PopupInfoHead")
local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")
local AnimationMgr = appdf.req(appdf.EXTERNAL_SRC .. "AnimationMgr")
local popPosition = {}
popPosition[1] = cc.p(210, 350)
popPosition[2] = cc.p(750, 350)
popPosition[3] = cc.p(145, 175)
local popAnchor = {} 
popAnchor[1] = cc.p(0, 0)
popAnchor[2] = cc.p(1, 0)
popAnchor[3] = cc.p(0, 0)

local GameRoleItem = class("GameRoleItem", cc.Node)

function GameRoleItem:ctor(userItem, viewId)
    ExternalFun.registerNodeEvent(self)
    self.m_nViewId = viewId
    self.m_userItem = userItem
    self.m_bNormalState = (self.m_userItem.cbUserStatus ~= yl.US_OFFLINE)

    -- 加载csb资源
    --local csbNode = ExternalFun.loadCSB("game/GameRoleItem.csb",self)

    -- 用户头像
    local head = PopupInfoHead:createClipHead(userItem, 90)
    head:enableInfoPop(true, popPosition[viewId], popAnchor[viewId])
    --head:enableHeadFrame(true, {_framefile = "land_headframe.png", _zorder = -1, _scaleRate = 0.75, _posPer = cc.p(0.5, 0.63)})
    self.m_popHead = head
    --csbNode:addChild(head)
	self:addChild(head)
	
	--用户昵称
	self.nickname_bk = cc.Sprite:create("roleItem/nickname_bk.png")
	:addTo(head)
	:setAnchorPoint(0.5, 1)
	:setPosition(0, -50)
	local bk_size = self.nickname_bk:getContentSize() 
	self.m_clipNick = ClipText:createClipText(cc.size(120, 20), self.m_userItem.szNickName)
    self.m_clipNick:setAnchorPoint(cc.p(0.5, 0.5))
    self.m_clipNick:setPosition(bk_size.width/2, bk_size.height/2)
    self.nickname_bk:addChild(self.m_clipNick)
    
    --金币
	self.coin_bk = cc.Sprite:create("roleItem/coin_bk.png")
	:setAnchorPoint(0.5, 1)
	:addTo(head)
	:setPosition(0,-50 - bk_size.height - 5)
	bk_size = self.coin_bk:getContentSize()
	local coin_sp = cc.Sprite:create("roleItem/coin.png")
	:setScale(0.9)
	local coin_sp_size = coin_sp:getContentSize()
	coin_sp:addTo(self.coin_bk)
	coin_sp:setPosition(coin_sp_size.width/2 + 2, bk_size.height / 2)
	local coninsStr =string.formatNumberThousands(self.m_userItem.lScore,true,",")
	self.m_clipScore = ClipText:createClipText(cc.size(150, 20), coninsStr .. "")
    self.m_clipScore:setAnchorPoint(cc.p(0.5, 0.5))
    self.m_clipScore:setPosition(bk_size.width/2 + 20, bk_size.height/2)
    self.coin_bk:addChild(self.m_clipScore)

    -- 游戏状态
    --self.m_spGameFrame = csbNode:getChildByName("head_frame")
    --self.m_spGameFrame:setVisible(false)
    --self.m_spGameFrame:addTouchEventListener(function( ref, tType)
        --if tType == ccui.TouchEventType.ended then
            --if self.m_spGameFrame:isVisible() then
                --self.m_popHead:onTouchHead()
            --end
        --end
    --end)
    --self.m_spGameFrame:setTouchEnabled(true)

--[[    -- 聊天气泡
    self.m_spChatBg = csbNode:getChildByName("chat_bg")
    self.m_spChatBg:setVisible(false)
    self.m_spChatBg:setScaleX(0.00001)

    -- 聊天表情
    self.m_spBrow = self.m_spChatBg:getChildByName("chat_face")
    -- 聊天内容
    self.m_labChat = nil

    -- 信息底板
    local infobg = csbNode:getChildByName("head_bg")
    infobg:setVisible(false)
    self.m_spInfoBg = infobg

    self.m_clipNick = nil
    self.m_clipScore = nil

    -- 聊天动画
    local sc = cc.ScaleTo:create(0.1, 1.0, 1.0)
    local show = cc.Show:create()
    local spa = cc.Spawn:create(sc, show)
    self.m_actTip = cc.Sequence:create(spa, cc.DelayTime:create(2.0), cc.ScaleTo:create(0.1, 0.00001, 1.0), cc.Hide:create())
    self.m_actTip:retain()

    -- 语音动画
    local param = AnimationMgr.getAnimationParam()
    param.m_fDelay = 0.1
    param.m_strName = Define.VOICE_ANIMATION_KEY
    local animate = AnimationMgr.getAnimate(param)
    self.m_actVoiceAni = cc.RepeatForever:create(animate)
    self.m_actVoiceAni:retain()

    self:updateStatus()--]]
end

function GameRoleItem:onExit()
    --self.m_actTip:release()
    --self.m_actTip = nil
    --self.m_actVoiceAni:release()
    --self.m_actVoiceAni = nil
end

function GameRoleItem:reSet()
    --self.m_popHead:setVisible(true)
    --self.m_spInfoBg:setVisible(false)
    --self.m_spGameFrame:setVisible(false)
end

function GameRoleItem:switchGameState(Coins )
    --self.m_popHead:setVisible(false) 
    --if self.m_nViewId ~= cmd.MY_VIEWID then
        --self.m_spInfoBg:setVisible(true)
        --local infobg = self.m_spInfoBg

        -- 昵称
        if nil == self.m_clipNick then            
            self.m_clipNick = ClipText:createClipText(cc.size(90, 20), self.m_userItem.szNickName)
            self.m_clipNick:setAnchorPoint(cc.p(0.5, 0.5))
            self.m_clipNick:setPosition(57, 40)
            self.nickname_bk:addChild(self.m_clipNick)
        else
            self.m_clipNick:setString(self.m_userItem.szNickName)
        end
        
        -- 金币
        if nil == self.m_clipScore then
			local coninsStr =string.formatNumberThousands(self.m_userItem.lScore,true,",")
            self.m_clipScore = ClipText:createClipText(cc.size(70, 20), coninsStr.. "")
            self.m_clipScore:setAnchorPoint(cc.p(0.5, 0.5))
            self.m_clipScore:setPosition(63, 17)
            self.coin_bk:addChild(self.m_clipScore)
        else
			local coninsStr =string.formatNumberThousands(Coins,true,",")
            self.m_clipScore:setString(coninsStr.. "")
        end
    --end

    self:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(function()
        self:updateStatus()
    end)))
end

function GameRoleItem:textChat( str )
    self.m_spBrow:setVisible(false)
    if nil == self.m_labChat then
        self.m_labChat = cc.LabelTTF:create(str, "fonts/round_body.ttf", 20, cc.size(150,0), cc.TEXT_ALIGNMENT_CENTER)        
        self.m_spChatBg:addChild(self.m_labChat)
    else
        self.m_labChat:setString(str)
    end
    self:changeChatPos()
    self.m_labChat:setVisible(true)
    -- 尺寸调整
    local labSize = self.m_labChat:getContentSize()
    if labSize.height >= 40 then
        self.m_spChatBg:setContentSize(170, labSize.height + 30)
    else
        self.m_spChatBg:setContentSize(170, 40)
    end
    self.m_labChat:setPosition(self.m_spChatBg:getContentSize().width * 0.5, self.m_spChatBg:getContentSize().height * 0.5)
end

function GameRoleItem:browChat( idx )
    if nil ~= self.m_labChat then
        self.m_labChat:setVisible(false)
    end
    self:changeChatPos()
    self.m_spBrow:setVisible(true)

    self.m_spChatBg:setContentSize(170, 40)
    local str = string.format("e(%d).png", idx)
    local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(str)
    if nil ~= frame then
        self.m_spBrow:setSpriteFrame(frame)
    end
end

function GameRoleItem:onUserVoiceStart()
    if nil ~= self.m_labChat then
        self.m_labChat:setVisible(false)
    end
    self.m_spBrow:stopAllActions()
    self:changeChatPos()  
    self.m_spChatBg:setContentSize(170, 40) 
    self.m_spChatBg:stopAllActions()
    self.m_spChatBg:setVisible(true)
    self.m_spChatBg:setScale(1.0)
    local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("blank.png")
    if nil ~= frame then
        if cmd.RIGHT_VIEWID == self.m_nViewId then 
            self.m_spBrow:setRotation(0)
        else
            self.m_spBrow:setRotation(180)
        end        
        self.m_spBrow:setVisible(true)
        self.m_spBrow:setSpriteFrame(frame)
        self.m_spBrow:runAction(self.m_actVoiceAni)
    end
end

function GameRoleItem:onUserVoiceEnded()
    self.m_spBrow:setRotation(0)
    self.m_spBrow:stopAllActions()
    self.m_spBrow:setVisible(false)
    self.m_spChatBg:setVisible(false)
    self.m_spChatBg:setScaleX(0.00001)
end

function GameRoleItem:changeChatPos()
    if cmd.RIGHT_VIEWID == self.m_nViewId then
        self.m_spChatBg:setAnchorPoint(cc.p(1.0, 0.5))
        self.m_spChatBg:loadTexture("game_chat_1.png", UI_TEX_TYPE_PLIST)
        self.m_spChatBg:setPosition(-93, 60)
    else
        self.m_spChatBg:setAnchorPoint(cc.p(0, 0.5))
        self.m_spChatBg:loadTexture("game_chat_0.png", UI_TEX_TYPE_PLIST)
        self.m_spChatBg:setPosition(93, 60)
    end
    self.m_spChatBg:stopAllActions()
    self.m_spChatBg:runAction(self.m_actTip)
end

function GameRoleItem:updateStatus()
    if self.m_userItem.cbUserStatus == yl.US_OFFLINE then
        self.m_bNormalState = false
        if nil ~= convertToGraySprite then
            -- 灰度图
            if nil ~= self.m_popHead and nil ~= self.m_popHead.m_head and nil ~= self.m_popHead.m_head.m_spRender then
                convertToGraySprite(self.m_popHead.m_head.m_spRender)
            end
            if nil ~= self.m_spGameFrame and nil ~= self.m_spGameFrame.getVirtualRenderer then
                local s9render = self.m_spGameFrame:getVirtualRenderer()
                if nil ~= s9render.getSprite then
                    convertToGraySprite(s9render:getSprite())
                end
            end
        end        
    else
        if not self.m_bNormalState then
            self.m_bNormalState = true
            -- 普通图
            if nil ~= convertToNormalSprite then
                -- 灰度图
                if nil ~= self.m_popHead and nil ~= self.m_popHead.m_head and nil ~= self.m_popHead.m_head.m_spRender then
                    convertToNormalSprite(self.m_popHead.m_head.m_spRender)
                end
                if nil ~= self.m_spGameFrame and nil ~= self.m_spGameFrame.getVirtualRenderer then
                    local s9render = self.m_spGameFrame:getVirtualRenderer()
                    if nil ~= s9render.getSprite then
                        convertToNormalSprite(s9render:getSprite())
                    end                    
                end
            end
        end
    end
end

return GameRoleItem