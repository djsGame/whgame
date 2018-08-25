local GameViewLayer = class("GameViewLayer",function(scene)
		local gameViewLayer =  display.newLayer()
    return gameViewLayer
end)

require("client/src/plaza/models/yl")
local cmd = appdf.req(appdf.GAME_SRC.."yule.oxnew.src.models.CMD_Game")
local SetLayer = appdf.req(appdf.GAME_SRC.."yule.oxnew.src.views.layer.SetLayer")
local PopupInfoHead = appdf.req("client.src.external.PopupInfoHead")
local GameChatLayer = appdf.req(appdf.CLIENT_SRC.."plaza.views.layer.game.GameChatLayer")
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local AnimationMgr = appdf.req(appdf.EXTERNAL_SRC .. "AnimationMgr")

GameViewLayer.BT_PROMPT 			= 2
GameViewLayer.BT_OPENCARD 			= 3
GameViewLayer.BT_START 				= 4
GameViewLayer.BT_CALLBANKER 		= 5
GameViewLayer.BT_CANCEL 			= 6
GameViewLayer.BT_CHIP 				= 7
GameViewLayer.BT_CHIP1 				= 8
GameViewLayer.BT_CHIP2 				= 9
GameViewLayer.BT_CHIP3 				= 10
GameViewLayer.BT_CHIP4 				= 11

GameViewLayer.BT_SWITCH 			= 12
GameViewLayer.BT_SET 				= 13
GameViewLayer.BT_CHAT 				= 14
GameViewLayer.BT_HOWPLAY 			= 15
GameViewLayer.BT_EXIT 				= 16
--GameViewLayer.BT_SOUND 				= 15
--GameViewLayer.BT_TAKEBACK 			= 16

GameViewLayer.FRAME 				= 1
GameViewLayer.NICKNAME 				= 2
GameViewLayer.SCORE 				= 3
GameViewLayer.FACE 					= 7

GameViewLayer.TIMENUM   			= 1
GameViewLayer.CHIPNUM 				= 1
GameViewLayer.SCORENUM 				= 1

--牌间距
GameViewLayer.CARDSPACING 			= 35

GameViewLayer.VIEWID_CENTER 		= 5

GameViewLayer.RES_PATH 				= "game/yule/oxnew/res/"

local pointPlayer = {cc.p(877, 625), cc.p(88, 410), cc.p(157, 115), cc.p(1238, 410)}
local pointCard = {cc.p(667, 617), cc.p(298, 402), cc.p(667, 110), cc.p(1028, 402)}
local pointClock = {cc.p(1017, 640), cc.p(88, 560), cc.p(157, 255), cc.p(1238, 560)}
local pointOpenCard = {cc.p(437, 625), cc.p(288, 285), cc.p(917, 115), cc.p(1038, 285)}
local pointTableScore = {cc.p(667, 505), cc.p(491, 410), cc.p(667, 342), cc.p(835, 410)}
local pointBankerFlag = {cc.p(948, 714), cc.p(159, 499), cc.p(228, 204), cc.p(1168, 495)}
local pointChat = {cc.p(767, 690), cc.p(160, 525), cc.p(230, 250), cc.p(1173, 525)}
local pointUserInfo = {cc.p(445, 240), cc.p(182, 305), cc.p(205, 170), cc.p(750, 305)}
local anchorPoint = {cc.p(1, 1), cc.p(0, 0.5), cc.p(0, 0), cc.p(1, 0.5)}

local AnimationRes = 
{
	{name = "banker", file = GameViewLayer.RES_PATH.."animation_banker/banker_", nCount = 11, fInterval = 0.2, nLoops = 1},
	{name = "faceFlash", file = GameViewLayer.RES_PATH.."animation_faceFlash/faceFlash_", nCount = 2, fInterval = 0.6, nLoops = 3},
	{name = "lose", file = GameViewLayer.RES_PATH.."animation_lose/lose_", nCount = 17, fInterval = 0.1, nLoops = 1},
	{name = "start", file = GameViewLayer.RES_PATH.."animation_start/start_", nCount = 11, fInterval = 0.15, nLoops = 1},
	{name = "victory", file = GameViewLayer.RES_PATH.."animation_victory/victory_", nCount = 17, fInterval = 0.13, nLoops = 1},
	{name = "yellow", file = GameViewLayer.RES_PATH.."animation_yellow/yellow_", nCount = 5, fInterval = 0.2, nLoops = 1},
	{name = "blue", file = GameViewLayer.RES_PATH.."animation_blue/blue_", nCount = 5, fInterval = 0.2, nLoops = 1}
}

function GameViewLayer:onInitData()
	self.bCardOut = {false, false, false, false, false}
	self.lUserMaxScore = {0, 0, 0, 0}
	self.chatDetails = {}
	self.bCanMoveCard = false
	self.cbGender = {}
	self.bBtnInOutside = false
	self.bBtnMoving = false
end

function GameViewLayer:onExit()
	print("GameViewLayer onExit")
	cc.Director:getInstance():getTextureCache():removeTextureForKey("card.png")
	cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("gameScene_oxnew.plist")
	cc.Director:getInstance():getTextureCache():removeTextureForKey("gameScene_oxnew.png")
    cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()

    AnimationMgr.removeCachedAnimation(cmd.VOICE_ANIMATION_KEY)
end

local this
function GameViewLayer:ctor(scene)
	this = self
	self._scene = scene
	self:onInitData()
	self:preloadUI()
	self._setLayer = SetLayer:create(self):addTo(self, 3)

	--节点事件
	local function onNodeEvent(event)
		if event == "exit" then
			self:onExit()
		end
	end
	self:registerScriptHandler(onNodeEvent)

	display.newSprite(GameViewLayer.RES_PATH.."game/background.png")
		:move(display.center)
		:addTo(self)

	self._csbNode = cc.CSLoader:createNode(GameViewLayer.RES_PATH.."game/GameScene.csb")
		:addTo(self, 1)


	local  btcallback = function(ref, type)
        if type == ccui.TouchEventType.ended then
         	this:onButtonClickedEvent(ref:getTag(),ref)
        end
    end

    --特殊按钮
	self.spButtonBg = self._csbNode:getChildByName("sp_buttonBg"):setScaleY(0.1)
	self.spButtonBg:setVisible(false)

	self.btSwitch = self._csbNode:getChildByName("bt_switch")
		:setTag(GameViewLayer.BT_SWITCH)
	self.btSwitch:addTouchEventListener(btcallback)

	local posSwitchX, posSwitchY = self.btSwitch:getPosition()
	local posSwitch = cc.p(posSwitchX, posSwitchY)

	self.btSet = self._csbNode:getChildByName("bt_set")
		:setTag(GameViewLayer.BT_SET)
		:setPosition(posSwitch)
		:setTouchEnabled(false)
	self.btSet:addTouchEventListener(btcallback)

	self.btChat = self._csbNode:getChildByName("bt_chat")
		:setTag(GameViewLayer.BT_CHAT)
		:setPosition(posSwitch)
		:setTouchEnabled(false)
	self.btChat:addTouchEventListener(btcallback)

	self.btHowPlay = self._csbNode:getChildByName("bt_howPlay")
		:setTag(GameViewLayer.BT_HOWPLAY)
		:setPosition(posSwitch)
		:setTouchEnabled(false)
	self.btHowPlay:addTouchEventListener(btcallback)

	self.btExit = self._csbNode:getChildByName("bt_exit")
		:setTag(GameViewLayer.BT_EXIT)
		:setPosition(posSwitch)
		:setTouchEnabled(false)
	self.btExit:addTouchEventListener(btcallback)

	--普通按钮
	self.btPrompt = self._csbNode:getChildByName("bt_prompt")
		:move(yl.WIDTH - 163, 60)
		:setTag(GameViewLayer.BT_PROMPT)
		:setVisible(false)
	self.btPrompt:addTouchEventListener(btcallback)

	self.btOpenCard = self._csbNode:getChildByName("bt_showCard")
		:move(yl.WIDTH - 163, 112)
		:setTag(GameViewLayer.BT_OPENCARD)
		:setVisible(false)
	self.btOpenCard:addTouchEventListener(btcallback)

	self.btStart = self._csbNode:getChildByName("bt_start")
		:move(yl.WIDTH - 163, 112)
		:setVisible(false)
		:setTag(GameViewLayer.BT_START)
	self.btStart:addTouchEventListener(btcallback)

	self.btCallBanker = self._csbNode:getChildByName("bt_callBanker")
		:move(display.cx - 150, 300)
		:setTag(GameViewLayer.BT_CALLBANKER)
		:setVisible(false)
	self.btCallBanker:addTouchEventListener(btcallback)

	self.btCancel = self._csbNode:getChildByName("bt_cancel")
		:move(display.cx + 150, 300)
		:setTag(GameViewLayer.BT_CANCEL)
		:setVisible(false)
	self.btCancel:addTouchEventListener(btcallback)

	--四个下注的筹码按钮
	self.btChip = {}
	for i = 1, 4 do
		self.btChip[i] = ccui.Button:create("bt_chip_0.png", "bt_chip_1.png", "", ccui.TextureResType.plistType)
			:move(420 + 165*(i - 1), 253)
			:setTag(GameViewLayer.BT_CHIP + i)
			:setVisible(false)
			:addTo(self)
		self.btChip[i]:addTouchEventListener(btcallback)
		cc.LabelAtlas:_create("123456", GameViewLayer.RES_PATH.."num_chip.png", 17, 24, string.byte("0"))
			:move(self.btChip[i]:getContentSize().width/2, self.btChip[i]:getContentSize().height/2 + 5)
			:setAnchorPoint(cc.p(0.5, 0.5))
			:setTag(GameViewLayer.CHIPNUM)
			:addTo(self.btChip[i])
	end

	self.txt_CellScore = cc.Label:createWithTTF("底注：250","fonts/round_body.ttf",24)
		:move(1000, yl.HEIGHT - 20)
		:setVisible(false)
		:addTo(self)
	self.txt_TableID = cc.Label:createWithTTF("桌号：38","fonts/round_body.ttf",24)
		:move(333, yl.HEIGHT-20)
		:setVisible(false)
		:addTo(self)

	--牌提示背景
	self.spritePrompt = display.newSprite("#prompt.png")
		:move(display.cx, display.cy - 108)
		:setVisible(false)
		:addTo(self)
	--牌值
	self.labAtCardPrompt = {}
	for i = 1, 3 do
		self.labAtCardPrompt[i] = cc.LabelAtlas:_create("", GameViewLayer.RES_PATH.."num_prompt.png", 39, 38, string.byte("0"))
			:move(72 + 162*(i - 1), 25)
			:setAnchorPoint(cc.p(0.5, 0.5))
			:addTo(self.spritePrompt)
	end
	self.labCardType = cc.Label:createWithTTF("", "fonts/round_body.ttf", 34)
		:move(568, 25)
		:addTo(self.spritePrompt)

	--时钟
	self.spriteClock = display.newSprite("#sprite_clock.png")
		:move(display.cx, display.cy + 50)
		:setVisible(false)
		:addTo(self)
	local labAtTime = cc.LabelAtlas:_create("", GameViewLayer.RES_PATH.."num_time.png", 42, 39, string.byte("0"))
		:move(self.spriteClock:getContentSize().width/2, self.spriteClock:getContentSize().height/2)
		:setAnchorPoint(cc.p(0.5, 0.5))
		:setScale(0.7)
		:setTag(GameViewLayer.TIMENUM)
		:addTo(self.spriteClock)
	--用于发牌动作的那张牌
	self.animateCard = display.newSprite(GameViewLayer.RES_PATH.."card.png")
		:move(display.center)
		:setVisible(false)
		:setLocalZOrder(2)
		:addTo(self)
	local cardWidth = self.animateCard:getContentSize().width/13
	local cardHeight = self.animateCard:getContentSize().height/5
	self.animateCard:setTextureRect(cc.rect(cardWidth*2, cardHeight*4, cardWidth, cardHeight))

	--四个玩家
	self.nodePlayer = {}
	for i = 1 ,cmd.GAME_PLAYER do
		--玩家结点
		self.nodePlayer[i] = cc.Node:create()
			:move(pointPlayer[i])
			:setVisible(false)
			:addTo(self)
		--人物框
		local spriteFrame = display.newSprite("#oxnew_frame.png")
			:setTag(GameViewLayer.FRAME)
			:addTo(self.nodePlayer[i])
		--昵称
		self.nicknameConfig = string.getConfig("fonts/round_body.ttf", 18)
		cc.Label:createWithTTF("小白狼大白兔", "fonts/round_body.ttf", 18)
			:move(3, -43)
			:setScaleX(0.8)
			:setColor(cc.c3b(0, 0, 0))
			:setTag(GameViewLayer.NICKNAME)
			:addTo(self.nodePlayer[i])
		--金币
		cc.LabelAtlas:_create("123456", GameViewLayer.RES_PATH.."num_score.png", 15, 15, string.byte("0"))
			:move(13, -79)
			:setAnchorPoint(cc.p(0.5, 0.5))
			:setTag(GameViewLayer.SCORE)
			:addTo(self.nodePlayer[i])
	end

	--自己方牌框
	self.cardFrame = {}
	for i = 1, 5 do
		self.cardFrame[i] = ccui.CheckBox:create("cardFrame_0.png",
												"cardFrame_1.png",
												"cardFrame_0.png",
												"cardFrame_0.png",
												"cardFrame_0.png", ccui.TextureResType.plistType)
			:move(335 + 166*(i - 1), 110)
			:setTouchEnabled(false)
			:setVisible(false)
			:addTo(self)
	end

	--牌节点
	self.nodeCard = {}
	--牌的类型
	self.cardType = {}
	--桌面金币
	self.tableScore = {}
	--准备标志
	self.flag_ready = {}
	--摊牌标志
	self.flag_openCard = {}
	for i = 1, cmd.GAME_PLAYER do
		--牌
		self.nodeCard[i] = cc.Node:create()
			:move(pointCard[i])
			:setAnchorPoint(cc.p(0.5, 0.5))
			:addTo(self)
		for j = 1, 5 do
			local card = display.newSprite(GameViewLayer.RES_PATH.."card.png")
				:setTag(j)
				:setVisible(false)
				:setTextureRect(cc.rect(cardWidth*2, cardHeight*4, cardWidth, cardHeight))
				:addTo(self.nodeCard[i])
		end
		--牌型
		self.cardType[i] = display.newSprite("#ox_10.png")
			:move(pointOpenCard[i])
			:setVisible(false)
			:addTo(self)
		--桌面金币
		self.tableScore[i] = display.newSprite("#score_bg.png")
			:move(pointTableScore[i])
			:setVisible(false)
			:addTo(self)
		cc.LabelAtlas:_create("1008611", GameViewLayer.RES_PATH.."num_chipScore.png", 20, 28, string.byte("/"))
			:move(66, 37)
			:setAnchorPoint(cc.p(0.5, 0.5))
			:setTag(GameViewLayer.SCORENUM)
			:addTo(self.tableScore[i])
		--准备
		self.flag_ready[i] = display.newSprite("#sprite_prompt.png")
			:move(pointCard[i])
			:setVisible(false)
			:addTo(self)
		--摊牌
		self.flag_openCard[i] = display.newSprite("#sprite_openCard.png")
			:move(pointOpenCard[i])
			:setVisible(false)
			:addTo(self)
	end

	self.nodeLeaveCard = cc.Node:create():addTo(self)

	self.spriteBankerFlag = display.newSprite()
		:setVisible(false)
		:setLocalZOrder(2)
		:addTo(self)

	--聊天框
    self._chatLayer = GameChatLayer:create(self._scene._gameFrame)
    self._chatLayer:addTo(self, 3)
	--聊天泡泡
	self.chatBubble = {}
	for i = 1 , cmd.GAME_PLAYER do
		if i == 2 or i == 3 then
			self.chatBubble[i] = display.newSprite(GameViewLayer.RES_PATH.."game_chat_lbg.png"	,{scale9 = true ,capInsets=cc.rect(0, 0, 180, 110)})
				:setAnchorPoint(cc.p(0,0.5))
				:move(pointChat[i])
				:setVisible(false)
				:addTo(self, 2)
		else
			self.chatBubble[i] = display.newSprite(GameViewLayer.RES_PATH.."game_chat_rbg.png",{scale9 = true ,capInsets=cc.rect(0, 0, 180, 110)})
				:setAnchorPoint(cc.p(1,0.5))
				:move(pointChat[i])
				:setVisible(false)
				:addTo(self, 2)
		end
	end
	--点击事件
	self:setTouchEnabled(true)
	self:registerScriptTouchHandler(function(eventType, x, y)
		return self:onEventTouchCallback(eventType, x, y)
	end)

	-- 玩家头像
	self.m_bNormalState = {}
	--房卡需要
	self.m_tabUserItem = {}
	--语音按钮 gameviewlayer -> gamelayer -> clientscene
    self._scene._scene:createVoiceBtn(cc.p(1150, 230), 0, self)

    -- 语音动画
    AnimationMgr.loadAnimationFromFrame("record_play_ani_%d.png", 1, 3, cmd.VOICE_ANIMATION_KEY)
end

function GameViewLayer:onResetView()
	self.nodeLeaveCard:removeAllChildren()
	self.spriteBankerFlag:setVisible(false)
	self.spritePrompt:setVisible(false)
	--重排列牌
	local cardWidth = self.animateCard:getContentSize().width
	local cardHeight = self.animateCard:getContentSize().height
	for i = 1, cmd.GAME_PLAYER do
		local fSpacing		--牌间距
		local fX 			--起点
		local fWidth 		--宽度
		--以上三个数据是保证牌节点的坐标位置位于其下五张牌的正中心
		if i == cmd.MY_VIEWID then
			fSpacing = 166
			fX = fSpacing/2
			fWidth = fSpacing*5
		else
			fSpacing = GameViewLayer.CARDSPACING
			fX = cardWidth/2
			fWidth = cardWidth + fSpacing*4
		end
		self.nodeCard[i]:setContentSize(cc.size(fWidth, cardHeight))
		for j = 1, 5 do
			local card = self.nodeCard[i]:getChildByTag(j)
				:move(fX + fSpacing*(j - 1), cardHeight/2)
				:setTextureRect(cc.rect(cardWidth*2, cardHeight*4, cardWidth, cardHeight))
				:setVisible(false)
				:setLocalZOrder(1)
		end
		self.tableScore[i]:setVisible(false)
		self.cardType[i]:setVisible(false)
	end
	self.bCardOut = {false, false, false, false, false}
	self.bBtnMoving = false
	self.labCardType:setString("")
	for i = 1, 3 do
		self.labAtCardPrompt[i]:setString("")
	end
end

--更新用户显示
function GameViewLayer:OnUpdateUser(viewId, userItem)
	if not viewId or viewId == yl.INVALID_CHAIR then
		print("OnUpdateUser viewId is nil")
		return
	end
	--dump(userItem, "OnUpdateUser" .. viewId, 6)
	self.m_tabUserItem[viewId] = userItem
	local head = self.nodePlayer[viewId]:getChildByTag(GameViewLayer.FACE)
	if not userItem then
		self.nodePlayer[viewId]:setVisible(false)
		self.flag_ready[viewId]:setVisible(false)
		self.cbGender[viewId] = nil
		if head then
			head:setVisible(false)
		end
	else
		self.nodePlayer[viewId]:setVisible(true)

		self:setNickname(viewId, userItem.szNickName)
		self:setScore(viewId, userItem.lScore)
		self.flag_ready[viewId]:setVisible(yl.US_READY == userItem.cbUserStatus)
		self.cbGender[viewId] = userItem.cbGender
		if not head then
			head = PopupInfoHead:createNormal(userItem, 85)
			head:setPosition(3, 24)
			head:enableHeadFrame(false)
			head:enableInfoPop(true, pointUserInfo[viewId], anchorPoint[viewId])
			head:setTag(GameViewLayer.FACE)
			self.nodePlayer[viewId]:addChild(head)

			--遮盖层，美化头像
			display.newSprite("#oxnew_frameTop.png")
				--:move(1, 1)
				:addTo(head)
			self.m_bNormalState[viewId] = true
		else
			head:updateHead(userItem)
		end
		head:setVisible(true)
		--掉线头像变灰
		if userItem.cbUserStatus == yl.US_OFFLINE then
			if self.m_bNormalState[viewId] then
				convertToGraySprite(head.m_head.m_spRender)
			end
			self.m_bNormalState[viewId] = false
		else
			if not self.m_bNormalState[viewId] then
				convertToNormalSprite(head.m_head.m_spRender)
			end
			self.m_bNormalState[viewId] = true
		end
	end
end

--****************************      计时器        *****************************--
function GameViewLayer:OnUpdataClockView(viewId, time)
	if not viewId or viewId == yl.INVALID_CHAIR or not time then
		self.spriteClock:getChildByTag(GameViewLayer.TIMENUM):setString("")
		self.spriteClock:setVisible(false)
	else
		self.spriteClock:getChildByTag(GameViewLayer.TIMENUM):setString(time)
	end
end

function GameViewLayer:setClockPosition(viewId)
	if viewId then
		self.spriteClock:move(pointClock[viewId])
	else
		self.spriteClock:move(display.cx, display.cy + 50)
	end
    self.spriteClock:setVisible(true)
end

--**************************      点击事件        ****************************--
--点击事件
function GameViewLayer:onEventTouchCallback(eventType, x, y)
	if eventType == "began" then
		if self.bBtnInOutside then
			self:onButtonSwitchAnimate()
			return false
		end
	elseif eventType == "ended" then
		--用于触发手牌
		if self.bCanMoveCard ~= true then
			return false
		end

		local size1 = self.nodeCard[cmd.MY_VIEWID]:getContentSize()
		local x1, y1 = self.nodeCard[cmd.MY_VIEWID]:getPosition()
		for i = 1, 5 do
			local card = self.nodeCard[cmd.MY_VIEWID]:getChildByTag(i)
			local x2, y2 = card:getPosition()
			local size2 = card:getContentSize()
			local rect = card:getTextureRect()
			rect.x = x1 - size1.width/2 + x2 - size2.width/2
			rect.y = y1 - size1.height/2 + y2 - size2.height/2
			if cc.rectContainsPoint(rect, cc.p(x, y)) then
				if false == self.bCardOut[i] then
					card:move(x2, y2 + 30)
					self.cardFrame[i]:setSelected(true)
				elseif true == self.bCardOut[i] then
					card:move(x2, y2 - 30)
					self.cardFrame[i]:setSelected(false)
				end
				self.bCardOut[i] = not self.bCardOut[i]
				self:updateCardPrompt()
				return true
			end
		end
	end

	return true
end

--按钮点击事件
function GameViewLayer:onButtonClickedEvent(tag,ref)
	if tag == GameViewLayer.BT_START then
		self.btStart:setVisible(false)
		self._scene:onStartGame()
	elseif tag == GameViewLayer.BT_SWITCH then
		self:onButtonSwitchAnimate()
	elseif tag == GameViewLayer.BT_CHAT then
		self._chatLayer:showGameChat(true)
	elseif tag == GameViewLayer.BT_SET then
		print("设置")
		self._setLayer:showLayer()
	elseif tag == GameViewLayer.BT_HOWPLAY then
		print("玩法")
		self._scene._scene:popHelpLayer2(cmd.KIND_ID, 0, yl.ZORDER.Z_HELP_WEBVIEW)
	elseif tag == GameViewLayer.BT_EXIT then
		self._scene:onQueryExitGame()
	elseif tag == GameViewLayer.BT_OPENCARD then
		self.bCanMoveCard = false
		self.btOpenCard:setVisible(false)
		--self.btPrompt:setVisible(false)
		self.spritePrompt:setVisible(false)
		for i = 1, 5 do
			self.cardFrame[i]:setVisible(false)
			self.cardFrame[i]:setSelected(false)
		end
		self._scene:onOpenCard()
	elseif tag == GameViewLayer.BT_PROMPT then
		self:promptOx()
	elseif tag == GameViewLayer.BT_CALLBANKER then
		self.btCallBanker:setVisible(false)
		self.btCancel:setVisible(false)
		self._scene:onBanker(1)
	elseif tag == GameViewLayer.BT_CANCEL then
		self.btCallBanker:setVisible(false)
		self.btCancel:setVisible(false)
		self._scene:onBanker(0)
	elseif tag - GameViewLayer.BT_CHIP == 1 or
			tag - GameViewLayer.BT_CHIP == 2 or
			tag - GameViewLayer.BT_CHIP == 3 or
			tag - GameViewLayer.BT_CHIP == 4 then
		for i = 1, 4 do
			self.btChip[i]:setVisible(false)
		end
		local index = tag - GameViewLayer.BT_CHIP
		self._scene:onAddScore(self.lUserMaxScore[index])
	else
		showToast(self,"功能尚未开放！",1)
	end
end

function GameViewLayer:onButtonSwitchAnimate()
	if self.bBtnMoving then
		return
	end
	self.bBtnMoving = true 		--正在滚
	local fInterval = 0.15
	local spacing = 114
	local fScale = 0

	if self.bBtnInOutside then
		fScale = 0.1
		self.btSwitch:setTouchEnabled(true)
	else
		fScale = 1
		self.btSwitch:setTouchEnabled(false)
		self.spButtonBg:setVisible(true)
	end

	--背景图移动
	local timeMax = fInterval*(GameViewLayer.BT_EXIT - GameViewLayer.BT_SET + 1)
	self.spButtonBg:runAction(cc.ScaleTo:create(timeMax, 1, fScale, 1))
	--按钮滚动
	for i = GameViewLayer.BT_SET, GameViewLayer.BT_EXIT do
		local nCount = i - GameViewLayer.BT_SET + 1
		local button = self._csbNode:getChildByTag(i)
		button:setTouchEnabled(false)
		--算时间和距离
		local fRotate = 360
		local time = fInterval*nCount
		local pointTarget = cc.p(0, spacing*nCount)
		if not self.bBtnInOutside then 			--滚出
			fRotate = -fRotate
			pointTarget = cc.p(-pointTarget.x, -pointTarget.y)
		end

		button:runAction(cc.Sequence:create(
			cc.Spawn:create(cc.MoveBy:create(time, pointTarget), cc.RotateBy:create(time, fRotate)),
			cc.CallFunc:create(function(ref)
				if not this.bBtnInOutside then
					ref:setTouchEnabled(true)
				else
					self.spButtonBg:setVisible(false)
				end

				if i == GameViewLayer.BT_EXIT then
					this.bBtnInOutside = not this.bBtnInOutside
					self.bBtnMoving = false
				end
			end)))
	end
end

function GameViewLayer:gameCallBanker(callBankerViewId, bFirstTimes)
	if callBankerViewId == cmd.MY_VIEWID then
		if self._scene.cbDynamicJoin == 0 then
        	self.btCallBanker:setVisible(true)
        	self.btCancel:setVisible(true)
        end
    end

    if bFirstTimes then
		display.newSprite()
			:move(display.center)
			:addTo(self, 1)
			:runAction(self:getAnimate("start", true))
    end
end

function GameViewLayer:gameStart(bankerViewId)
    if bankerViewId ~= cmd.MY_VIEWID then
    	if self._scene.cbDynamicJoin == 0 then
	        for i = 1, 4 do
	            self.btChip[i]:setVisible(true)
	        end
	    end
    end
end

function GameViewLayer:gameAddScore(viewId, score)
	local strScore = ""..score
	if score < 0 then
		strScore = "/"..(-score)
	end
	self.tableScore[viewId]:getChildByTag(GameViewLayer.SCORENUM):setString(strScore)
	self.tableScore[viewId]:setVisible(true)
    local labelScore = self.nodePlayer[viewId]:getChildByTag(GameViewLayer.SCORE)
    local lScore = tonumber(labelScore:getString())
    self:setScore(viewId, lScore - score)

    -- 自己下注, 隐藏下注信息
    if viewId == cmd.MY_VIEWID then
    	for i = 1, 4 do
	        self.btChip[i]:setVisible(false)
	    end
    end
end

function GameViewLayer:gameSendCard(firstViewId, totalCount)
	--开始发牌
	self:runSendCardAnimate(firstViewId, totalCount)
end

--开牌
function GameViewLayer:gameOpenCard(wViewChairId, cbOx, bEnded)
	local cardWidth = self.animateCard:getContentSize().width
	local cardHeight = self.animateCard:getContentSize().height
	local fSpacing = GameViewLayer.CARDSPACING
	local fWidth
	if cbOx > 0 then
		fWidth = cardWidth + fSpacing*2
	else
		fWidth = cardWidth + fSpacing*4
	end
	--牌的排列
	self.nodeCard[wViewChairId]:setContentSize(cc.size(fWidth, cardHeight))
	for i = 1, 5 do
        local card = self.nodeCard[wViewChairId]:getChildByTag(i)
		if wViewChairId == cmd.MY_VIEWID then
			card:move(cardWidth/2 + fSpacing*(i - 1), cardHeight/2)
		end

		if cbOx > 0 and i >= 4 then
			local positionX, positionY = card:getPosition()
			positionX = positionX - (fSpacing*2 + fSpacing/2)
			positionY = positionY + 50
			card:move(positionX, positionY)
			card:setLocalZOrder(0)
		end
	end
	--牌型
	if cbOx >= 10 then
		self._scene:PlaySound(GameViewLayer.RES_PATH.."sound/GAME_OXOX.wav")
		cbOx = 10
	end
	local strFile = string.format("ox_%d.png", cbOx)
	local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(strFile)
	self.cardType[wViewChairId]:setSpriteFrame(spriteFrame)
	self.cardType[wViewChairId]:setVisible(true)
	--隐藏摊牌图标
    self:setOpenCardVisible(wViewChairId, false)
    --声音
    if bEnded and wViewChairId == cmd.MY_VIEWID then
    	local strGender = "GIRL"
    	if self.cbGender[wViewChairId] == 1 then
			strGender = "BOY"
		end
    	local strSound = GameViewLayer.RES_PATH.."sound/"..strGender.."/ox_"..cbOx..".MP3"
		self._scene:PlaySound(strSound)
    end
end

function GameViewLayer:gameEnd(bMeWin)
	local name
	if bMeWin then
		name = "victory"
		self._scene:PlaySound(GameViewLayer.RES_PATH.."sound/GAME_WIN.WAV")
	else
		name = "lose"
		self._scene:PlaySound(GameViewLayer.RES_PATH.."sound/GAME_LOST.WAV")
	end

    self.btStart:setVisible(true)

	display.newSprite()
		:move(display.center)
		:addTo(self)
		:runAction(self:getAnimate(name, true))

	-- 隐藏牌信息
	self.spritePrompt:setVisible(false)
	for i = 1, 5 do
		self.cardFrame[i]:setVisible(false)
		self.cardFrame[i]:setSelected(false)
	end
end

function GameViewLayer:gameScenePlaying()
	if self._scene.cbDynamicJoin == 0 then
	    self.btOpenCard:setVisible(true)
	    --self.btPrompt:setVisible(true)
	    self.spritePrompt:setVisible(true)
	    for i = 1, 5 do
	    	self.cardFrame[i]:setVisible(true)
	    end
	end
end

function GameViewLayer:setCellScore(cellscore)
	if not cellscore then
		self.txt_CellScore:setString("底注：")
	else
		self.txt_CellScore:setString("底注："..cellscore)
	end
end

function GameViewLayer:setCardTextureRect(viewId, tag, cardValue, cardColor)
	if viewId < 1 or viewId > 4 or tag < 1 or tag > 5 then
		print("card texture rect error!")
		return
	end
	
	local card = self.nodeCard[viewId]:getChildByTag(tag)
	local rectCard = card:getTextureRect()
	rectCard.x = rectCard.width*(cardValue - 1)
	rectCard.y = rectCard.height*cardColor
	card:setTextureRect(rectCard)
end

function GameViewLayer:setNickname(viewId, strName)
	local name = string.EllipsisByConfig(strName, 156, self.nicknameConfig)
	local labelNickname = self.nodePlayer[viewId]:getChildByTag(GameViewLayer.NICKNAME)
	labelNickname:setString(name)
end

function GameViewLayer:setScore(viewId, lScore)
	local labelScore = self.nodePlayer[viewId]:getChildByTag(GameViewLayer.SCORE)
	labelScore:setString(lScore)

	local labelWidth = labelScore:getContentSize().width
	if labelWidth > 96 then
		labelScore:setScaleX(96/labelWidth)
	elseif labelScore:getScaleX() ~= 1 then
		labelScore:setScaleX(1)
	end
end

function GameViewLayer:setTableID(id)
	if not id or id == yl.INVALID_TABLE then
		self.txt_TableID:setString("桌号：")
	else
		self.txt_TableID:setString("桌号："..(id + 1))
	end
end

function GameViewLayer:setUserScore(wViewChairId, lScore)
	self.nodePlayer[wViewChairId]:getChildByTag(GameViewLayer.SCORE):setString(lScore)
end

function GameViewLayer:setReadyVisible(wViewChairId, isVisible)
	self.flag_ready[wViewChairId]:setVisible(isVisible)
end

function GameViewLayer:setOpenCardVisible(wViewChairId, isVisible)
	self.flag_openCard[wViewChairId]:setVisible(isVisible)
end

function GameViewLayer:setTurnMaxScore(lTurnMaxScore)
	for i = 1, 4 do
		self.lUserMaxScore[i] = math.max(lTurnMaxScore, 1)
		self.btChip[i]:getChildByTag(GameViewLayer.CHIPNUM):setString(self.lUserMaxScore[i])
		lTurnMaxScore = math.floor(lTurnMaxScore/2)
	end
end

-- 积分房卡配置的下注
function GameViewLayer:setScoreRoomJetton( tabJetton )
	self.lUserMaxScore = tabJetton
	for i = 1, 4 do
		self.btChip[i]:getChildByTag(GameViewLayer.CHIPNUM):setString(self.lUserMaxScore[i])
	end
end

function GameViewLayer:setBankerUser(wViewChairId)
	self.spriteBankerFlag:move(pointBankerFlag[wViewChairId])
	self.spriteBankerFlag:setVisible(true)
	self.spriteBankerFlag:runAction(self:getAnimate("banker"))
	--闪烁动画
	display.newSprite()
		:move(pointPlayer[wViewChairId].x + 2, pointPlayer[wViewChairId].y - 12)
		:addTo(self)
		:runAction(self:getAnimate("faceFlash", true))
end

function GameViewLayer:setUserTableScore(wViewChairId, lScore)
	if lScore == 0 then
		return
	end

	local strScore = ""..lScore
	if lScore < 0 then
		strScore = "/"..(-lScore)
	end
	self.tableScore[wViewChairId]:getChildByTag(GameViewLayer.SCORENUM):setString(strScore)
	self.tableScore[wViewChairId]:setVisible(true)
end


--发牌动作
function GameViewLayer:runSendCardAnimate(wViewChairId, nCount)
	local nPlayerNum = self._scene:getPlayNum()
	print("GameViewLayer:runSendCardAnimate count,player ==> ", nCount, nPlayerNum)
	if nCount == nPlayerNum*5 then
		self.animateCard:setVisible(true)
    	self._scene:PlaySound(GameViewLayer.RES_PATH.."sound/SEND_CARD.wav")
	elseif nCount < 1 then
		self.animateCard:setVisible(false)

		if self._scene.cbDynamicJoin == 0 then
			self.btOpenCard:setVisible(true)
			--self.btPrompt:setVisible(true)
			self.spritePrompt:setVisible(true)
		end
		self._scene:sendCardFinish()
		self.bCanMoveCard = true
		return
	end

	local pointMove = {cc.p(0, 250), cc.p(-310, 0), cc.p(0, -180), cc.p(310, 0)}
	self.animateCard:runAction(cc.Sequence:create(
			cc.MoveBy:create(0.15, pointMove[wViewChairId]),
			cc.CallFunc:create(function(ref)
				ref:move(display.center)
				--显示一张牌
				local nTag = math.floor(5 - nCount/nPlayerNum) + 1
				if wViewChairId == 1 then 		--1号位发牌时牌居中对齐
					local size = self.nodeCard[1]:getContentSize()
					if nTag == 1 then
						size.width = size.width - 120
					else
						size.width = size.width + GameViewLayer.CARDSPACING
					end
					self.nodeCard[1]:setContentSize(size)
				elseif wViewChairId == 3 then
					self.cardFrame[nTag]:setVisible(true)
				elseif wViewChairId == 4 then 		--4号位发牌时牌居右对齐
					nTag = math.ceil(nCount/nPlayerNum)
				end
				local card = self.nodeCard[wViewChairId]:getChildByTag(nTag)
				if not card then return end
				card:setVisible(true)
				--开始下一个人的发牌
				wViewChairId = wViewChairId + 1
				if wViewChairId > 4 then
					wViewChairId = 1
				end
				while not self._scene:isPlayerPlaying(wViewChairId) do
					wViewChairId = wViewChairId + 1
					if wViewChairId > 4 then
						wViewChairId = 1
					end
				end
				self:runSendCardAnimate(wViewChairId, nCount - 1)
			end)))
end

--检查牌类型
function GameViewLayer:updateCardPrompt()
	--弹出牌显示，统计和
	local nSumTotal = 0
	local nSumOut = 0
	local nCount = 1
	for i = 1, 5 do
		local nCardValue = self._scene:getMeCardLogicValue(i)
		nSumTotal = nSumTotal + nCardValue
		if self.bCardOut[i] then
	 		if nCount <= 3 then
	 			self.labAtCardPrompt[nCount]:setString(nCardValue)
	 		end
	 		nCount = nCount + 1
			nSumOut = nSumOut + nCardValue
		end
	end
	for i = nCount, 3 do
		self.labAtCardPrompt[i]:setString("")
	end
	--判断是否构成牛
	local nDifference = nSumTotal - nSumOut
	if nCount == 1 then
		self.labCardType:setString("")
	elseif nCount == 3 then 		--弹出两张牌
		if self:mod(nDifference, 10) == 0 then
			self.labCardType:setString("牛  "..(nSumOut > 10 and nSumOut - 10 or nSumOut))
		else
			self.labCardType:setString("无牛")
		end
	elseif nCount == 4 then 		--弹出三张牌
		if self:mod(nSumOut, 10) == 0 then
			self.labCardType:setString("牛  "..(nDifference > 10 and nDifference - 10 or nDifference))
		else
			self.labCardType:setString("无牛")
		end
	else
		self.labCardType:setString("无牛")
	end
end

function GameViewLayer:preloadUI()
	for i = 1, #AnimationRes do
		local animation = cc.Animation:create()
		animation:setDelayPerUnit(AnimationRes[i].fInterval)
		animation:setLoops(AnimationRes[i].nLoops)

		for j = 1, AnimationRes[i].nCount do
			local strFile = AnimationRes[i].file..string.format("%d.png", j)
			animation:addSpriteFrameWithFile(strFile)
		end

		cc.AnimationCache:getInstance():addAnimation(animation, AnimationRes[i].name)
	end
end

function GameViewLayer:getAnimate(name, bEndRemove)
	local animation = cc.AnimationCache:getInstance():getAnimation(name)
	local animate = cc.Animate:create(animation)

	if bEndRemove then
		animate = cc.Sequence:create(animate, cc.CallFunc:create(function(ref)
			ref:removeFromParent()
		end))
	end

	return animate
end

function GameViewLayer:promptOx()
	--首先将牌复位
	for i = 1, 5 do
		if self.bCardOut[i] == true then
			local card = self.nodeCard[cmd.MY_VIEWID]:getChildByTag(i)
			local x, y = card:getPosition()
			y = y - 30
			card:move(x, y)
			self.bCardOut[i] = false
		end
	end
	--将牛牌弹出
	local index = self._scene:GetMeChairID() + 1
	local cbDataTemp = self:copyTab(self._scene.cbCardData[index])
	if self._scene:getOxCard(cbDataTemp) then
		for i = 1, 5 do
			for j = 1, 3 do
				if self._scene.cbCardData[index][i] == cbDataTemp[j] then
					local card = self.nodeCard[cmd.MY_VIEWID]:getChildByTag(i)
					local x, y = card:getPosition()
					y = y + 30
					card:move(x, y)
					self.bCardOut[i] = true
				end
			end
		end
	end
	self:updateCardPrompt()
end

--用户聊天
function GameViewLayer:userChat(wViewChairId, chatString)
	if chatString and #chatString > 0 then
		self._chatLayer:showGameChat(false)
		--取消上次
		if self.chatDetails[wViewChairId] then
			self.chatDetails[wViewChairId]:stopAllActions()
			self.chatDetails[wViewChairId]:removeFromParent()
			self.chatDetails[wViewChairId] = nil
		end

		--创建label
		local limWidth = 24*12
		local labCountLength = cc.Label:createWithSystemFont(chatString,"Arial", 24)  
		if labCountLength:getContentSize().width > limWidth then
			self.chatDetails[wViewChairId] = cc.Label:createWithSystemFont(chatString,"Arial", 24, cc.size(limWidth, 0))
		else
			self.chatDetails[wViewChairId] = cc.Label:createWithSystemFont(chatString,"Arial", 24)
		end
		if wViewChairId ==2 or wViewChairId == 3 then
			self.chatDetails[wViewChairId]:move(pointChat[wViewChairId].x + 24 , pointChat[wViewChairId].y + 9)
				:setAnchorPoint( cc.p(0, 0.5) )
		else
			self.chatDetails[wViewChairId]:move(pointChat[wViewChairId].x - 24 , pointChat[wViewChairId].y + 9)
				:setAnchorPoint(cc.p(1, 0.5))
		end
		self.chatDetails[wViewChairId]:addTo(self, 2)

	    --改变气泡大小
		self.chatBubble[wViewChairId]:setContentSize(self.chatDetails[wViewChairId]:getContentSize().width+48, self.chatDetails[wViewChairId]:getContentSize().height + 40)
			:setVisible(true)
		--动作
	    self.chatDetails[wViewChairId]:runAction(cc.Sequence:create(
	    	cc.DelayTime:create(3),
	    	cc.CallFunc:create(function(ref)
	    		self.chatDetails[wViewChairId]:removeFromParent()
				self.chatDetails[wViewChairId] = nil
				self.chatBubble[wViewChairId]:setVisible(false)
	    	end)))
    end
end

--用户表情
function GameViewLayer:userExpression(wViewChairId, wItemIndex)
	if wItemIndex and wItemIndex >= 0 then
		self._chatLayer:showGameChat(false)
		--取消上次
		if self.chatDetails[wViewChairId] then
			self.chatDetails[wViewChairId]:stopAllActions()
			self.chatDetails[wViewChairId]:removeFromParent()
			self.chatDetails[wViewChairId] = nil
		end

	    local strName = string.format("e(%d).png", wItemIndex)
	    self.chatDetails[wViewChairId] = cc.Sprite:createWithSpriteFrameName(strName)
	        :addTo(self, 2)
	    if wViewChairId ==2 or wViewChairId == 3 then
			self.chatDetails[wViewChairId]:move(pointChat[wViewChairId].x + 45 , pointChat[wViewChairId].y + 5)
		else
			self.chatDetails[wViewChairId]:move(pointChat[wViewChairId].x - 45 , pointChat[wViewChairId].y + 5)
		end

	    --改变气泡大小
		self.chatBubble[wViewChairId]:setContentSize(90,80)
			:setVisible(true)

	    self.chatDetails[wViewChairId]:runAction(cc.Sequence:create(
	    	cc.DelayTime:create(3),
	    	cc.CallFunc:create(function(ref)
	    		self.chatDetails[wViewChairId]:removeFromParent()
				self.chatDetails[wViewChairId] = nil
				self.chatBubble[wViewChairId]:setVisible(false)
	    	end)))
    end
end

-- 语音开始
function GameViewLayer:onUserVoiceStart( viewId )
	--取消上次
	if self.chatDetails[viewId] then
		self.chatDetails[viewId]:stopAllActions()
		self.chatDetails[viewId]:removeFromParent()
		self.chatDetails[viewId] = nil
	end
     -- 语音动画
    local param = AnimationMgr.getAnimationParam()
    param.m_fDelay = 0.1
    param.m_strName = cmd.VOICE_ANIMATION_KEY
    local animate = AnimationMgr.getAnimate(param)
    self.m_actVoiceAni = cc.RepeatForever:create(animate)

    self.chatDetails[viewId] = display.newSprite("#blank.png")
		:setAnchorPoint(cc.p(0.5, 0.5))
		:addTo(self, 3)
	if viewId == 2 or viewId == 3 then
		self.chatDetails[viewId]:setRotation(180)
		self.chatDetails[viewId]:move(pointChat[viewId].x + 45 , pointChat[viewId].y + 15)
	else
		self.chatDetails[viewId]:move(pointChat[viewId].x - 45 , pointChat[viewId].y + 15)
	end
	self.chatDetails[viewId]:runAction(self.m_actVoiceAni)

    --改变气泡大小
	self.chatBubble[viewId]:setContentSize(90,100)
		:setVisible(true)
end

-- 语音结束
function GameViewLayer:onUserVoiceEnded( viewId )
	if self.chatDetails[viewId] then
	    self.chatDetails[viewId]:removeFromParent()
	    self.chatDetails[viewId] = nil
	    self.chatBubble[viewId]:setVisible(false)
	end
end

--拷贝表
function GameViewLayer:copyTab(st)
    local tab = {}
    for k, v in pairs(st) do
        if type(v) ~= "table" then
            tab[k] = v
        else
            tab[k] = self:copyTab(v)
        end
    end
    return tab
 end

--取模
function GameViewLayer:mod(a,b)
    return a - math.floor(a/b)*b
end

--运行输赢动画
function GameViewLayer:runWinLoseAnimate(viewid, score)
	local ptWinLoseAnimate = {cc.p(727, 500), cc.p(238, 300), cc.p(307, 50), cc.p(1088, 300)}
	local strAnimate
	local strSymbol
	local strNum
	if score > 0 then
		strAnimate = "yellow"
		strSymbol = "#symbol_add.png"
		strNum = GameViewLayer.RES_PATH.."num_add.png"
	else
		score = -score
		strAnimate = "blue"
		strSymbol = "#symbol_reduce.png"
		strNum = GameViewLayer.RES_PATH.."num_reduce.png"
	end

	--加减
	local node = cc.Node:create()
		:move(ptWinLoseAnimate[viewid])
		:setAnchorPoint(cc.p(0.5, 0.5))
		:setOpacity(0)
		:setCascadeOpacityEnabled(true)
		:addTo(self, 4)

	local spriteSymbol = display.newSprite(strSymbol)		--符号
		:addTo(node)
	local sizeSymbol = spriteSymbol:getContentSize()
	spriteSymbol:move(sizeSymbol.width/2, sizeSymbol.height/2)

	local labAtNum = cc.LabelAtlas:_create(score, strNum, 40, 35, string.byte("0"))		--数字
		:setAnchorPoint(cc.p(0.5, 0.5))
		:addTo(node)
	local sizeNum = labAtNum:getContentSize()
	labAtNum:move(sizeSymbol.width + sizeNum.width/2, sizeNum.height/2)

	node:setContentSize(sizeSymbol.width + sizeNum.width, sizeSymbol.height)

	--底部动画
	local nTime = 1.5
	local spriteAnimate = display.newSprite()
		:move(ptWinLoseAnimate[viewid])
		:addTo(self, 3)
	spriteAnimate:runAction(cc.Sequence:create(
		cc.Spawn:create(
			cc.MoveBy:create(nTime, cc.p(0, 200)),
			self:getAnimate(strAnimate)
		),
		cc.DelayTime:create(2),
		cc.CallFunc:create(function(ref)
			ref:removeFromParent()
		end)
	))

	node:runAction(cc.Sequence:create(
		cc.Spawn:create(
			cc.MoveBy:create(nTime, cc.p(0, 200)), 
			cc.FadeIn:create(nTime)
		),
		cc.DelayTime:create(2),
		cc.CallFunc:create(function(ref)
			ref:removeFromParent()
		end)
	))
end

return GameViewLayer