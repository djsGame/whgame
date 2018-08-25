local module_pre = "game.yule.fruitforest.src"
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")
local g_var = ExternalFun.req_var
local module_pre = "game.yule.fruitforest.src"
local GameRoleItem = appdf.req(module_pre .. ".views.layer.GameRoleItem")
local FruitItem = appdf.req(module_pre .. ".views.layer.FruitItem")
local FreeScoreLayer = appdf.req(module_pre .. ".views.layer.FreeScoreLayer")
local PopupInfoHead = appdf.req(appdf.EXTERNAL_SRC .. "PopupInfoHead")
--local AdminOperationLayer = appdf.req(module_pre .. ".views.layer.AdminOperation")

local GameViewLayer = {}
--GameViewLayer.RES_PATH 				= device.writablePath.."game/yule/fruitforest/res/"
GameViewLayer.RES_PATH              = "game/yule/fruitforest/res/"

local Treasure = appdf.req(module_pre .. ".views.layer.FruitTreasure")

--	游戏一
local Game1ViewLayer = class("Game1ViewLayer", function (scene)
	local gameViewLayer =  display.newLayer()
	return gameViewLayer
end)
GameViewLayer[1] = Game1ViewLayer
--	游戏二
local Game2ViewLayer = class("Game2ViewLayer", function (scene)
	local gameViewLayer =  display.newLayer()
	return gameViewLayer
end)
GameViewLayer[2] = Game2ViewLayer
--	游戏三
local Game3ViewLayer = class("Game3ViewLayer", function (scene)
	local gameViewLayer =  display.newLayer()
	return gameViewLayer
end)
GameViewLayer[3] = G
local ClipText = appdf.EXTERNAL_SRC .. "ClipText"

local cmd = module_pre .. ".models.CMD_Game"
local QueryDialog   = require("app.views.layer.other.QueryDialog")

local GameItem = appdf.req(module_pre .. ".views.layer.GameItem")

local PRELOAD = require(module_pre..".views.layer.PreLoading")

--local SettingLayer = appdf.req(module_pre .. ".views.layer.SettingLayer")
local HelpLayer = appdf.req(module_pre .. ".views.layer.HelpLayer")

GameViewLayer.RES_PATH 				= device.writablePath.. "game/yule/fruitforest/res/"

local enGameLayer =
{
"TAG_SETTING_MENU",			--设置
"TAG_QUIT_MENU",			--退出
"TAG_START_MENU",			--开始按钮
"TAG_HELP_MENU",			--游戏帮助
"TAG_MAXADD_BTN",			--最大下注
"TAG_MINADD_BTN",			--最小下注
"TAG_ADD_BTN",				--加注
"TAG_SUB_BTN",				--减注
"TAG_AUTO_START_BTN",		--自动游戏
"TAG_GAME2_BTN",			--开始游戏2
"TAG_BT_MUSIC",				--隐藏上部菜单
"TAG_SHOWUP_BTN",			--显示上部菜单
"TAG_HALF_IN",				--半比
"TAG_ALL_IN",				--全比
"TAG_DOUBLE_IN",			--倍比
"TAG_GAME2_EXIT",			--取分
"TAG_SMALL_IN",				--押小
"TAG_MIDDLE_IN",			--押和
"TAG_BIG_IN",				--押大
"TAG_GO_ON",					--继续
"TAG_YA_XIAN",				--选择压线数量
"TAG_YA_XIAN1",
"TAG_YA_XIAN2",
"TAG_YA_XIAN3",
"TAG_YA_XIAN4",
"TAG_YA_XIAN5",
"TAG_YA_XIAN6",
"TAG_YA_XIAN7",
"TAG_YA_XIAN8",
"TAG_YA_XIAN9",
"TAG_MASK",
"TAG_LINE1",				--1号线路
"TAG_LINE2",
"TAG_LINE3",
"TAG_LINE4",
"TAG_LINE5",
"TAG_LINE6",
"TAG_LINE7",
"TAG_LINE8",
"TAG_LINE9",
"TAG_QUIT",				--退出
"TAG_CHANGE_TABLE",				--换桌子
"TAG_SOUND_ON",				--声音开关
"TAG_SOUND_OFF",
"TAG_HELP",				--帮助
"TAG_TEMP",
"TAG_BOX11","TAG_BOX12","TAG_BOX13","TAG_BOX14","TAG_BOX15",	--TAG_BOX11 47
"TAG_BOX21","TAG_BOX22","TAG_BOX23","TAG_BOX24","TAG_BOX25",
"TAG_BOX31","TAG_BOX32","TAG_BOX33","TAG_BOX34","TAG_BOX35",
"TAG_BOX41","TAG_BOX42","TAG_BOX43","TAG_BOX44","TAG_BOX45",
"TAG_BOMB21","TAG_BOMB22","TAG_BOMB23","TAG_BOMB24","TAG_BOMB25",	--TAG_BOMB21 67
"TAG_BOMB31","TAG_BOMB32","TAG_BOMB33","TAG_BOMB34","TAG_BOMB35",
"TAG_BOMB41","TAG_BOMB42","TAG_BOMB43","TAG_BOMB44","TAG_BOMB45",
"TAG_BOMB31","TAG_BOMB32","TAG_BOMB33","TAG_BOMB34","TAG_BOMB35",
"TAG_SINGLE_SCORE","TAG_TIMES","TAG_TOTAL_SCORE",
"TAG_FREETIMES","TAG_FREETIMES1","TAG_FREETIMES2","TAG_FREETIMES3","TAG_FREETIMES4","TAG_FREETIMES5",
 "TAG_ADMINLAYER",
}
local TAG_ENUM = ExternalFun.declarEnumWithTable(GameViewLayer.TAG_START, enGameLayer);

local emGame2Actstate =
{
"STATE_WAITTING",					--等待
"STATE_WAVE",						--摇奖
"STATE_OPEN",						--开奖
"STATE_RESULT"						--结算
}
local Game2_ACTSTATE =  ExternalFun.declarEnumWithTable(0, emGame2Actstate)

local emGame2State =
{
"GAME2_STATE_WAITTING",				--等待
"GAME2_STATE_WAVING",				--摇奖
"GAME2_STATE_WAITTING_CHOICE",		--等待下注
"GAME2_STATE_OPEN",					--开奖
"GAME2_STATE_RESULT"				--结算,等待继续或区分
}
local GAME2_STATE = ExternalFun.declarEnumWithTable(0, emGame2State)

local emGameLabel =
{
"LABEL_COINS",						--玩家金钱
"LABEL_YAXIAN",						--压线
"LABEL_YAFEN",						--压分
"LABEL_TOTLEYAFEN",					--总压分
"LABEL_GETCOINS",					--获取金钱
"LABEL_GAME3_TIMES"					--小玛丽次数
}
local GAME2_STATE = ExternalFun.declarEnumWithTable(10, emGameLabel)

function Game1ViewLayer:ctor(scene)
	--注册node事件
	ExternalFun.registerNodeEvent(self)
	self._scene = scene
	--添加路径
	self:addPath()
	--预加载资源
	PRELOAD.loadTextures()
	--cc.SpriteFrameCache:getInstance():addSpriteFrames("game1/gameAction/game1_itemCommon.plist")
	--初始化csb界面
	self:initCsbRes();
	--播放背景音乐
	--ExternalFun.playBackgroudAudio("xiongdiwushu.mp3")
	self:OnPlayBackMusic(1)
	--初始化按钮状态
	self.sp_yaxian_bk_status = false
	self.tick = 0
	self.m_gameStart = false
	self.m_longTouch = false	--长按自动
	self.GameStart = true
	self.GameModle = g_var(cmd).GM_NULL
end

function Game1ViewLayer:OnPlayBackMusic(cbGameModle)
	if cbGameModle == 1 then
		ExternalFun.playBackgroudAudio("xiongdiwushu.mp3")
	elseif cbGameModle ==2 then
		ExternalFun.playBackgroudAudio("senlin_free_bgm.mp3")
	end
end

function Game1ViewLayer:onAdminDate( )
--    self:onHideTopMenu()
--    local AdminLayer = AdminOperationLayer:create(self)
--    AdminLayer:setPosition(cc.p(1334/2,750/2))
--    AdminLayer:setTag(TAG_ENUM.TAG_ADMINLAYER)
--    self._csbNode:addChild(AdminLayer)
--    AdminLayer:setLocalZOrder(2000000000)
--[[    AdminLayer:setCloseCallback(function()
        local btn = self._top_bk_right:getChildByName("button_help")
		:setEnabled(true)
    end)--]]

end

function Game1ViewLayer:onExit()
	PRELOAD.unloadTextures()
	PRELOAD.removeAllActions()
	PRELOAD.resetData()
	self:StopLoading(true)
	--播放大厅背景音乐
	ExternalFun.playPlazzBackgroudAudio()
	--重置搜索路径
	local oldPaths = cc.FileUtils:getInstance():getSearchPaths();
	cc.FileUtils:getInstance():setSearchPaths(self._searchPath);
	local searchpath = cc.FileUtils:getInstance():getSearchPaths()
end

function Game1ViewLayer:StopLoading( bRemove )
	PRELOAD.StopAnim(bRemove)
end

--[[function Game1ViewLayer:onFreeBlink()
	self.m_free_tip:setVisible(true)
	self.m_free_tip:runAction(cc.Sequence:create(cc.Blink:create(1.0,2),cc.DelayTime:create(1.0)))
	self.m_free_tip:setVisible(false)
end--]]

function Game1ViewLayer:addPath( )
	self._searchPath = cc.FileUtils:getInstance():getSearchPaths()
	cc.FileUtils:getInstance():addSearchPath(GameViewLayer.RES_PATH)
	cc.FileUtils:getInstance():addSearchPath(GameViewLayer.RES_PATH .. "game1/");
--[[	cc.FileUtils:getInstance():addSearchPath(GameViewLayer.RES_PATH .. "game2/");
	cc.FileUtils:getInstance():addSearchPath(GameViewLayer.RES_PATH .. "game3/");--]]
	cc.FileUtils:getInstance():addSearchPath(GameViewLayer.RES_PATH .. "common/");
	cc.FileUtils:getInstance():addSearchPath(GameViewLayer.RES_PATH .. "setting/");
	cc.FileUtils:getInstance():addSearchPath(GameViewLayer.RES_PATH .. "sound_res/"); --  声音
	cc.FileUtils:getInstance():addSearchPath(GameViewLayer.RES_PATH.."botton/");	--底部
end

---------------------------------------------------------------------------------------
--界面初始化
function Game1ViewLayer:initCsbRes(  )
	
	rootLayer, self._csbNode = ExternalFun.loadRootCSB(GameViewLayer.RES_PATH .."FRUIT_Game1Layer.csb", self);
	
	self.FruitItems = FruitItem:new()
	
	--初始化按钮
	self:initUI(self._csbNode)
end

--初始化按钮
function Game1ViewLayer:initUI( csbNode )
	self.tick = 0
	--按钮回调方法
	local function btnEvent( sender, eventType )
		if eventType == ccui.TouchEventType.began then
			ExternalFun.popupTouchFilter(1, false)
		elseif eventType == ccui.TouchEventType.canceled then
			ExternalFun.dismissTouchFilter()
		elseif eventType == ccui.TouchEventType.ended then
			ExternalFun.dismissTouchFilter()
			self:onButtonClickedEvent(sender:getTag(), sender)
		end
	end
	local function update()
		if self.bStartButtonTouch == true then
			self.tick = self.tick + 1
			--print(self.tick)
			if self.tick > 80 and self.moved == false then
				self.m_longTouch = true
				local texture = cc.TextureCache:getInstance():addImage("botton/autoCancel0.png")
				self.m_start:setTexture(texture)
				if (self._scene.m_cbGameMode == 5) or (self._scene.m_cbGameMode == 0) then --游戏结束状态
					self._scene:onAutoStart()
				end
				
				if nil ~= self.m_schedule then --关闭帧循环定时器
					local scheduler = cc.Director:getInstance():getScheduler()
					scheduler:unscheduleScriptEntry(self.m_schedule)
					self.m_schedule = nil
				end
			end
		end
	end
	local function onTouchBegan(touch,event)
		self:onHideTopMenu()
		
		--是否是免费游戏
		if self._scene.m_bEnterGameFree == true then
			return false
		end
		
		--游戏是否开始 并且 不是自动
		if self.m_gameStart == true and self._scene.m_bIsAuto == false then
			return false
		end
		self.tick = 0
		self.beganPoint = touch:getLocation()
		local point = self.m_start:convertToNodeSpace(self.beganPoint)
		local rect = cc.rect(0+25,0-25,self.m_start:getContentSize().width,self.m_start:getContentSize().height)
		--if cc.rectContainsPoint(rect,point) and self._scene:getGameMode()== 5 then
		if cc.rectContainsPoint(rect,point) then
			self.m_longTouch = false
			self.bStartButtonTouch = true
			self.moved = false
			self.ended = false
			--local texture = cc.TextureCache:getInstance():addImage("botton/changan1.png")
			--self.m_start:setTexture(texture)
			--启动帧循环定时器
			local scheduler = cc.Director:getInstance():getScheduler()
			self.m_schedule = scheduler:scheduleScriptFunc(update, 0, false)
		end
		--print("点击后".."X="..self.beganPoint.x.."Y="..self.beganPoint.y)
		return true
	end
	local function onTouchMoved(touch,event)
		self.delta = touch:getDelta()
		--print("移动距离XXXX"..self.delta.x )
		--print("移动距离YYYY"..self.delta.y )
		if self.moved == nil or self.moved == false then
			if math.abs(self.delta.x) > 1.0 and math.abs(self.delta.y) > 1.0 then
				self.moved = true
			else
				self.moved = false
			end
		end
	end
	local function onTouchEnd(touch,event)
		if nil ~= self.m_schedule then --关闭帧循环定时器
			local scheduler = cc.Director:getInstance():getScheduler()
			scheduler:unscheduleScriptEntry(self.m_schedule)
			self.m_schedule = nil
		end
		self.endPoint = touch:getLocation()
		local point = self.m_start:convertToNodeSpace(self.endPoint)
		local rect = cc.rect(0+25,0-25,self.m_start:getContentSize().width,self.m_start:getContentSize().height)
		if cc.rectContainsPoint(rect,point) then
			if self.m_longTouch ~= true then
				--local texture = cc.TextureCache:getInstance():addImage("botton/changan1.png")
				local texture = cc.Director:getInstance():getTextureCache():addImage("botton/changan1.png")
				self.m_start:setTexture(texture)
				if self._scene.m_bIsAuto == true then
					self._scene:onAutoStart()
				else
					if (self._scene.m_cbGameMode == 5) or (self._scene.m_cbGameMode == 0) then --游戏结束状态
						self._scene:onGameStart()
					end
				end
			end
		end
		self.ended = true
	end
	local function onTouchcCanclled(touch,event)
		self:stopAction(self.acc)
		self.ended = true
	end
	local listener = cc.EventListenerTouchOneByOne:create()
	listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
	listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED)
	listener:registerScriptHandler(onTouchEnd,cc.Handler.EVENT_TOUCH_ENDED)
	listener:registerScriptHandler(onTouchcCanclled,cc.Handler.EVENT_TOUCH_CANCELLED)
	local eventDispatcher = self:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
	
	--长按自动
	self.m_start = csbNode:getChildByName("Sprite_Start")
	csbNode:setTag(TAG_ENUM.TAG_START_MENU)
	csbNode:getChildByName("Sprite_1")
	csbNode:setVisible(true)
	
	--免费
	local sp_free = cc.Sprite:create("botton/free0.png")
	sp_free:setTag(TAG_ENUM.TAG_FREETIMES)
	sp_free:setAnchorPoint(0, 0)
	sp_free:addTo(self.m_start)
	sp_free:setVisible(false)
	self.m_freeButton = sp_free
	
	--------------------------------------------------------------------------------------------------------------------------------------
	--最小押注
	local Button_Min = csbNode:getChildByName("Button_Min");
	Button_Min:setTag(TAG_ENUM.TAG_MINADD_BTN);
	Button_Min:addTouchEventListener(btnEvent);
	
	--最大押注
	local Button_Max = csbNode:getChildByName("Button_Max");
	--Button_Max:setTag(TAG_ENUM.TAG_MAXADD_BTN);
	Button_Max:addTouchEventListener(btnEvent);
	
	--每条线下多少注
	local Button_Sub = csbNode:getChildByName("Button_Sub");
	Button_Sub:setTag(TAG_ENUM.TAG_SUB_BTN);
	Button_Sub:addTouchEventListener(btnEvent);
	
	--投注线数
	local Button_Add = csbNode:getChildByName("Button_Add");
	Button_Add:setTag(TAG_ENUM.TAG_ADD_BTN);
	Button_Add:addTouchEventListener(btnEvent);
	Button_Add:setVisible(true)
	
--[[	--进入比大小
	local Button_Game2 = csbNode:getChildByName("Button_Game2"):setVisible(false)
	Button_Game2:setTag(TAG_ENUM.TAG_GAME2_BTN);
	Button_Game2:addTouchEventListener(btnEvent);
	--自动加注
	local Button_Auto = csbNode:getChildByName("Button_Auto"):setVisible(false)
	Button_Auto:setTag(TAG_ENUM.TAG_AUTO_START_BTN);--]]
	
	--显示菜单
	local Button_Show = csbNode:getChildByName("Button_Show")
	Button_Show:setVisible(true)
	Button_Show:setTag(TAG_ENUM.TAG_SHOWUP_BTN);
	Button_Show:addTouchEventListener(btnEvent);
	------
	--用户游戏币数量
	self.m_textScore = csbNode:getChildByName("Text_score")
	self.m_textScore:setVisible(true)
	local coninsStr =string.formatNumberThousands(self._scene:GetMeUserItem().lScore,true,",")
	self.m_textScore:setString(coninsStr)
	
	local gold1 = cc.Sprite:create("game1/gold1.png")
	gold1:setPosition(-20,10)
	gold1:addTo(self.m_textScore)
	
	--压线数量
	self.m_textYaxian = csbNode:getChildByName("Text_yaxian")
	self.m_textYaxian:setVisible(true)
	self.m_textYaxian:setString(9)
	
	--每条线压分
	self.m_textYafen = csbNode:getChildByName("Text_yafen");
	self.m_textAllyafen = csbNode:getChildByName("Text_allyafen");
	
	--每次摇奖等到的分数
	self.m_textGetScore = csbNode:getChildByName("Text_getscore")
	self.m_textGetScore:setVisible(false)
	self.m_textGetScore:setString(0)
	
	--祝你好运
	self.m_textTips = csbNode:getChildByName("Text_Tips")
	--self.m_textTips:setString("祝您好运！")
	
	--菜单
	local nodeMenu= csbNode:getChildByName("Node_Menu");
	--self.m_nodeMenu = csbNode:getChildByName("Node_Menu");
	self.m_nodeMenu = nodeMenu:getChildByName("Sprite_bg"):setVisible(false)
	
	--返回
	local Button_back = self.m_nodeMenu:getChildByName("Button_back"):setVisible(true)
	Button_back:setTag(TAG_ENUM.TAG_QUIT_MENU);
	Button_back:addTouchEventListener(btnEvent);
	
	--帮助
	local Button_Help = self.m_nodeMenu:getChildByName("Button_Help");
	Button_Help:setTag(TAG_ENUM.TAG_HELP_MENU);
	Button_Help:addTouchEventListener(btnEvent);
	
	--设置声音
	local Button_Hide = self.m_nodeMenu:getChildByName("Button_Hide");
	Button_Hide:setTag(TAG_ENUM.TAG_BT_MUSIC);
	Button_Hide:addTouchEventListener(btnEvent);
	
	
	self.Node_btnEffet = csbNode:getChildByName("Node_btnEffet")
	--加载9条线路
	local csLinebNode =self._csbNode:getChildByName("LineNode")
	
	local line1 =csLinebNode:getChildByName("firstLine")
	line1:setTag(TAG_ENUM.TAG_LINE1)
	
	local line2 =csLinebNode:getChildByName("secondLine")
	line2:setTag(TAG_ENUM.TAG_LINE2)
	
	local line3 =csLinebNode:getChildByName("thirdLine")
	line3:setTag(TAG_ENUM.TAG_LINE3)
	
	local line4 =csLinebNode:getChildByName("forthLine")
	line4:setTag(TAG_ENUM.TAG_LINE4)
	
	local line5 =csLinebNode:getChildByName("fifthLine")
	line5:setTag(TAG_ENUM.TAG_LINE5)
	
	local line6 =csLinebNode:getChildByName("sixLine")
	line6:setTag(TAG_ENUM.TAG_LINE6)
	
	local line7 =csLinebNode:getChildByName("seventhLine")
	line7:setTag(TAG_ENUM.TAG_LINE7)
	
	local line8 =csLinebNode:getChildByName("eighthLine")
	line8:setTag(TAG_ENUM.TAG_LINE8)
	
	local line9 =csLinebNode:getChildByName("ninthLine")
	line9:setTag(TAG_ENUM.TAG_LINE9)
	self.m_node_nineLine = csLinebNode
	
	self.m_free_tip = csbNode:getChildByName("SP_FreeGame")
	self.m_free_tip:setVisible(false)
	
--[[	for i=1,15 do
		local posx = math.ceil(i/3)
		local posy = (i-1)%3 + 1
		local nodeStr = string.format("Node_%d_%d",posx-1,posy-1)
		local node = self._csbNode:getChildByName(nodeStr)
		local spriteIcon = node:getChildByName("icon"):setVisible(false)
	end--]]
	
	local endScoreStr =  "FreeNumber.png"
	self.lFreeNumber = cc.LabelAtlas:_create(nil,GameViewLayer.RES_PATH.."game1/" .. endScoreStr,17,22,string.byte("0"))
	self.lFreeNumber:setAnchorPoint(cc.p(0.5,0.5))
	self.m_start:addChild(self.lFreeNumber,0,1)
	local nLen = self.lFreeNumber:getContentSize().width
	self.lFreeNumber:setPosition(145,22)
	self.lFreeNumber:setString(20)
	self.lFreeNumber:setVisible(false)
	
	--local nodeTip = self._csbNode:getChildByName("Win_Node")
	local csbNode = ExternalFun.loadCSB("winnode.csb", self)
	csbNode:setVisible(false)
	self.m_winNode = csbNode
	self.m_winNode:setPosition(cc.p(1334/2,750/2-30))
	
	--免费次数背景特效
	self._freeEffect = ExternalFun.loadCSB("res/freeEffect/freeEffect.csb", self._csbNode)
	self._freeEffect:setPosition(cc.p(1334/2,750/2))
	self._freeEffect:setScale(1.2)
	self._freeEffect:setVisible(false)
	
	--免费次数特效
	self._freeNumEffect = ExternalFun.loadCSB("res/freeNum/freeNum.csb", self._csbNode)
	self._freeNumEffect:setPosition(cc.p(1334/2,750/2))
	self._freeNumEffect:setScale(1)
	self._freeNumEffect:setVisible(false)
	
	--蝴蝶特效
	self._HudieEffect = ExternalFun.loadCSB("res/hudie/huDie.csb", self._csbNode)
	self._HudieEffect:setPosition(cc.p(1334/2,750/2-30))
	self._HudieEffect:setScale(1.2)
	self._HudieEffect:setVisible(false)

--[[	self.motionStreakLayer = MotionStreakLayer:create()
	self.motionStreakLayer:setAnchorPoint(0.5,0.5)
	self.motionStreakLayer:setPosition(cc.p(0,0))
	self.motionStreakLayer:addTo(self._csbNode)--]]
	
	self.m_winAction = ExternalFun.loadTimeLine("winnode.csb", self)
	self.m_winAction:retain()

	local temp = csbNode:getChildByName("Panel_1"):getChildByName("win_labNum")
	self.m_winScore = temp

	local csbBounceNode = ExternalFun.loadCSB("BounceNode.csb", self)
	csbBounceNode:setVisible(false)
	self.m_BounceNode = csbBounceNode
	self.m_BounceNode:setPosition(cc.p(1334/2,750/2-30))
	self.m_BounceAction = ExternalFun.loadTimeLine("BounceNode.csb", self)
	self.m_BounceAction:retain()

	self.Sp_Free = csbBounceNode:getChildByName("Panel_1"):getChildByName("Sprite_Free")
	self.La_FreeNum = csbBounceNode:getChildByName("Panel_1"):getChildByName("Label_FreeNum")
	self.Sp_Free:setVisible(false)
	self.La_FreeNum:setVisible(false)
	
--[[	self.label12 = cc.LabelTTF:create("0", "Arial", 30)                         
    self.label12:setPosition(cc.p(1334/2+550,750/2+100))  
	self.label12:addTo(self._csbNode)
	
	self.label13 = cc.LabelTTF:create("0", "Arial", 30)                         
    self.label13:setPosition(cc.p(1334/2+550,750/2+50))  
	self.label13:addTo(self._csbNode)
	
	self.label14 = cc.LabelTTF:create("0", "Arial", 30)                         
    self.label14:setPosition(cc.p(1334/2+550,750/2))  
	self.label14:addTo(self._csbNode)
	
	self.label15 = cc.LabelTTF:create("0", "Arial", 30)                         
    self.label15:setPosition(cc.p(1334/2+550,750/2-50))  
	self.label15:addTo(self._csbNode)
	
	self.label16 = cc.LabelTTF:create("0", "Arial", 30)                         
    self.label16:setPosition(cc.p(1334/2+550,750/2-100))  
	self.label16:addTo(self._csbNode)--]]
	self.moveSprite = {}
	self.pos1 ={cc.p(-178*2+1,0),cc.p(-178*1+1,0),cc.p(0+1,0), cc.p(178*1+1,0),cc.p(178*2+1,0)}
	self.pos2 ={cc.p(0,-1490),cc.p(0,-1490-684),cc.p(0,-1490-684*2),cc.p(0,-1490-684*3),cc.p(0,-1490-684*4)}
	
	local stencil  = cc.Sprite:create()
	stencil:setTextureRect(cc.rect(0,0,874,335))
	self.clippingNode = cc.ClippingNode:create(stencil)
	self.clippingNode:setInverted(false)
	self.clippingNode:addTo(self._csbNode)
	self.clippingNode:setAnchorPoint(0.5,0.5)
	self.clippingNode:setPosition(cc.p(1334/2,750/2-30))
	for i =1,5 do	--5行
		for v = 1,3 do	--3列
			local nType   = tonumber(1)
			local nodeStr = string.format("Node_%d_%d",i-1,v-1)
			local node    = self._csbNode:getChildByName(nodeStr)
			local sprite1 = self.FruitItems:setFruitItemIcon(i,v,nType)
			sprite1:setPosition(0,340)
			if node:getChildByTag(1) == nil then
				node:addChild(sprite1,0,1)
			end
		end
	end
	
end

function Game1ViewLayer:onTreasure()	
	
	self._HudieEffect:setVisible(true)
	self.m_gameStart = true
	local bonusSprite = cc.Sprite:create("game1/BonusTime.png")
	bonusSprite:setPosition(cc.p(0,0))
	bonusSprite:setAnchorPoint(cc.p(0,0))
	local hudieNode = self._HudieEffect:getChildByName("Sprite_1")
	bonusSprite:addTo(hudieNode)
	
	if self._hudieEffectAnimation == nil then
		self._hudieEffectAnimation = ExternalFun.loadTimeLine("res/hudie/huDie.csb", self._csbNode)
		ExternalFun.SAFE_RETAIN(self._HudieEffect)
		self._HudieEffect:stopAllActions()
		self._hudieEffectAnimation:gotoFrameAndPlay(0,true)
		self._hudieEffectAnimation:setTimeSpeed(60/60)
		self._HudieEffect:runAction(self._hudieEffectAnimation)
	end
	
	local moveAction = cc.MoveTo:create(2,cc.p(0,750/2+500))
	local up = cc.Sequence:create(cc.DelayTime:create(1),
						moveAction,
						cc.CallFunc:create(function()
							bonusSprite:removeFromParent()
							self._hudieEffectAnimation = nil
							self._HudieEffect:setVisible(false)
						end))
	local down = cc.Sequence:create(cc.DelayTime:create(0.5),
									cc.CallFunc:create(function ()
										self._scene:sendGame2Star(255) --游戏开始
										local treasure = Treasure:create()
										:addTo(self)
										:setPosition(cc.p(0,0))
										:setTag(100000)
                                        
                                        treasure:setCloseCallback(function()
                                            if self._scene.m_bIsAuto == true then
                                                self:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create(function ()
                                                    self._scene:SendUserReady()
                                                    self._scene:sendReadyMsg()
                                                    self._scene.m_cbGameStatus = g_var(cmd).SHZ_GAME_SCENE_FREE
                                                    self._scene:setGameMode(1)
                                                end)))
                                            end
                                        end)
                                        self.m_gameStart = false
										self.m_treasure = treasure
										self.m_treasure.atlasSingle=self.m_textYafen:getString()
	end))
	local spawn = cc.Spawn:create(up,down)
	hudieNode:runAction(spawn)
--[[	self._scene:sendGame2Star(255) --游戏开始
	local treasure = Treasure:create()
	:addTo(self)
	:setPosition(cc.p(0,0))
	:setTag(100000)
	self.m_treasure = treasure
	self.m_treasure.atlasSingle=self.m_textYafen:getString()--]]
end

function Game1ViewLayer:OnHideLine()
	for i = 1,self._scene.m_lYaxian do
		self.m_node_nineLine:getChildByTag(TAG_ENUM.TAG_LINE1+i-1):setVisible(false)
	end
end

--游戏1的通用动画
function Game1ViewLayer:initMainView(  )
	--箭头
	local nodeJiantou = self.Node_btnEffet:getChildByName("Sprite_arrow")
	local jiantouAction = cc.Sequence:create(
	cc.MoveBy:create(0.5,cc.p(0,10)),
	cc.MoveBy:create(0.5,cc.p(0,-10))
	)
	nodeJiantou:runAction(cc.RepeatForever:create(jiantouAction))
	--闪光
	local flashAnim = cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("flashAnim"))
	local nodeFlash = self.Node_btnEffet:getChildByName("Sprite_flash")
	nodeFlash:runAction(cc.RepeatForever:create(flashAnim))
end

--游戏1动画开始
function Game1ViewLayer:game1Begin(  )
	print("############  game1Begin  ##############")
	local startImage = self._csbNode:getChildByName("Sprite_1")
	if startImage ~= nil then
		startImage:removeFromParent()
	end
	
	for i = 1,9 do
		self.m_node_nineLine:getChildByTag(TAG_ENUM.TAG_LINE1+i-1):setVisible(false)
	end
	
	self.actionTable = {}
	self.actionTimeTable = {}
	local action1 = cc.MoveBy:create(0.1 + 0.6, self.pos2[1])
	local action2 = cc.MoveBy:create(0.4 + 0.6, self.pos2[2])
	local action3 = cc.MoveBy:create(0.7 + 0.6, self.pos2[3])
	local action4 = cc.MoveBy:create(1.0 + 0.6, self.pos2[4])
	local action5 = cc.MoveBy:create(1.3 + 0.6, self.pos2[5])
	
	table.insert(self.actionTable,action1)
	table.insert(self.actionTable,action2)
	table.insert(self.actionTable,action3)
	table.insert(self.actionTable,action4)
	table.insert(self.actionTable,action5)
	
	table.insert(self.actionTimeTable,0.5)
	table.insert(self.actionTimeTable,0.9)
	table.insert(self.actionTimeTable,1.2)
	table.insert(self.actionTimeTable,1.5)
	table.insert(self.actionTimeTable,1.8)
	

	
	for i = 1, 5 do
		if self.clippingNode:getChildByTag(i) == nil  then
			self.moveSprite[i] = cc.Sprite:create("common_MoveImg"..i..".png")
			:addTo(self.clippingNode)
			:setAnchorPoint(0.5,0)
			:setTag(i)
			:setPosition(self.pos1[i])
		else
			self.moveSprite[i]:setPosition(self.pos1[i])
		end
	end
		
	for i =1,5 do	--5行
		for v = 1,3 do	--3列
			local nType   = tonumber(self._scene.m_cbItemInfo[v][i])+1
			local nodeStr = string.format("Node_%d_%d",i-1,v-1)
			local node    = self._csbNode:getChildByName(nodeStr)
			local sprite1 = self.FruitItems:setFruitItemIcon(i,v,nType)
			sprite1:setPosition(0,340)
			if node:getChildByTag(1) == nil then
				node:addChild(sprite1,0,1)
			end
		end
	end
	
	for y =1,5 do
		local UP    = cc.Sequence:create(self.actionTable[y],
										cc.CallFunc:create(function()
											self:PlayMusic(y)
										end))
		local Down  = cc.Sequence:create(cc.DelayTime:create(self.actionTimeTable[y]),
										 cc.CallFunc:create(function()
											for i = 1,3 do
												local sprite = self.FruitItems:getFruitItem(y,i)
												local action1 = cc.MoveTo:create(0.2,cc.p(0,-50))
												local action2 = cc.MoveTo:create(0.1,cc.p(0,0))
												if y == 5 and i == 3 then
													sprite:runAction(cc.Sequence:create(action1,action2,
																	 cc.CallFunc:create(function()
																		print("---------------------------")
																		print("sprite5 end")
																		print("---------------------------")
																		self._scene:setGameMode(2) --转动 GAME_STATE_MOVING
																	 end)))
												else	
													sprite:runAction(cc.Sequence:create(action1,action2))
												end
												
											end
										end))
		local spawn = cc.Spawn:create(UP,Down)
		self.moveSprite[y]:runAction(spawn)
	end
	
	ExternalFun.playSoundEffect("gundong.mp3")
	
	self:runAction(cc.Sequence:create(
	cc.DelayTime:create(2.3),
	cc.CallFunc:create(function (  )
        print("---------------------------")
        print("send end msg")
        print("---------------------------")
		if self._scene:getGameMode() == 2 then --表达GAME_STATE_MOVING
			self:game1GetLineResult()
			self:sendGame1End()
		end
	end)))
	
end

--手动停止滚动
function Game1ViewLayer:game1End(  )
	self._scene:setGameMode(3)
	for i=1,15 do
		local posx = math.ceil(i/3)
		local posy = (i-1)%3 + 1
		local nodeStr = string.format("Node_%d_%d",posx-1,posy-1)
		local node = self._csbNode:getChildByName(nodeStr)
		
		if node  then
			local pItem = node:getChildByTag(1)
			if pItem then
				pItem:stopAllItemAction()
			end
		end
	end
	self:stopAllActions()
	self:game1Result()
	--切换旗帜动作
	--self:game1ActionBanner(false)
end

--游戏连线结果
function Game1ViewLayer:game1GetLineResult(  )
	local temp = self._scene.m_lCoins
	--self.m_userHead:switchGameState(self._scene.m_lCoins + self._scene.m_lGetCoins)
	print("游戏连线结果")
	self._scene:setGameMode(3)  --GAME_STATE_RESULT
	local coninsStr =string.formatNumberThousands(self._scene.m_lGetCoins,true,",")
	self.m_textGetScore:setString(coninsStr)
	self.m_textGetScore:setVisible(true)
	self.m_textTips:setString("祝您好运!")
	self.m_textTips:setVisible(false)
    self._scene:changeUserScore(self._scene.m_lGetCoins)
	--画中奖线
	--中奖线路径
	local pathLine =
	{
	"prizeLine/01.png",
	"prizeLine/02.png",
	"prizeLine/03.png",
	"prizeLine/04.png",
	"prizeLine/05.png",
	"prizeLine/06.png",
	"prizeLine/07.png",
	"prizeLine/08.png",
	"prizeLine/09.png",
	}

	--绘制中奖线
	if self._scene.m_lGetCoins > 0 then
		self.lineTable = {}
		self:runAction(cc.Sequence:create(
		cc.CallFunc:create(function ()
			for n,v in ipairs(self._scene.m_UserActionYaxian) do
				local line = v.nZhongJiangXian
				local sprLine = self.m_node_nineLine:getChildByTag(TAG_ENUM.TAG_LINE1+line-1)
				sprLine:setVisible(true)
				table.insert(self.lineTable,sprLine)
			end
		end),
		cc.DelayTime:create(1),
		cc.CallFunc:create(function ()
			for i,v in ipairs(self.lineTable) do
				v:setVisible(false)
			end
			self.lineTable = {}
		end),
		cc.DelayTime:create(0.5),
		cc.CallFunc:create(function()
			--每条线间隔
			local delayTime = 1.2
			for lineIndex=1,#self._scene.m_UserActionYaxian do
				local pActionOneYaXian = self._scene.m_UserActionYaxian[lineIndex]
				if pActionOneYaXian then
					self:runAction(cc.Sequence:create(
						cc.DelayTime:create(delayTime*(lineIndex-1)),
						cc.CallFunc:create(function()
							local sprLine = self.m_node_nineLine:getChildByTag(TAG_ENUM.TAG_LINE1+pActionOneYaXian.nZhongJiangXian-1)
							sprLine:setVisible(true)
							sprLine:runAction(cc.Sequence:create(
											cc.CallFunc:create(function()
														for i =1,5 do	--5行
															for v = 1,3 do	--3列
																local nType   = tonumber(self._scene.m_cbItemInfo[v][i])+1
																local nodeStr = string.format("Node_%d_%d",i-1,v-1)
																local node    = self._csbNode:getChildByName(nodeStr)
																local isOnLine = false
																for j=1,g_var(cmd).ITEM_X_COUNT do
																	local pos = {}
																	pos.x = pActionOneYaXian.ptXian[j].x
																	pos.y = pActionOneYaXian.ptXian[j].y
																	if pos.x == v and pos.y == i then
																		isOnLine = true
																		--上方方框序列帧
																		--创建序列帧
																		local nodeAct = cc.Node:create()
																		nodeAct:setPosition(node:getPosition())
																		self._csbNode:addChild(nodeAct)
																		
--																		pItem:setState(1) --STATE_SELECT
																		self.FruitItems:playAnimation(i,v,nType)
																		
																		nodeAct:runAction(cc.Sequence:create(
																		cc.DelayTime:create(1.5),
																		cc.CallFunc:create(function (  )
																			nodeAct:removeFromParent()
																		end)
																		))
																	end
																end
															end
														end
											  end),											
											cc.DelayTime:create(1),
											cc.Hide:create())
)
						--如果是最后一个，进入结算界面
						if lineIndex == #self._scene.m_UserActionYaxian then
							self:runAction(
							cc.Sequence:create(
							cc.DelayTime:create(1.5),
							cc.CallFunc:create(function (  )
								self:game1Result()
							end)))
						end
					end)))
				end
			end
--			self:game1Result()
		end)))
	else
		self:game1Result()
	end
end

--游戏1结果
function Game1ViewLayer:game1Result()
--	self._scene:setGameMode(3) --GAME_STATE_RESULT
	--self.m_textGetScore:setString(0)

	local nBeishu = math.floor(self._scene.m_lGetCoins/self._scene.m_lTotalYafen) 
--[[	print("--------------------------------------------------------")
	self.label12:setString("获得分数 = "..self._scene.m_lGetCoins)
	self.label13:setString("总压分 = "..self._scene.m_lTotalYafen)
	self.label14:setString("倍数 = "..nBeishu)
	self.label15:setString("时间: = "..os.date())
	self.label16:setString("版本 = ".."4")
	print("--------------------------------------------------------")--]]
	--local temp = self._scene.m_lBetScore[self._scene.m_bYafenIndex]
--	local nBeishu = self._scene.m_lGetCoins/self._scene.m_lTotalYafen
	local strSoundFile="senlin_win.mp3"
	if nBeishu >=5 then
		self.m_winNode:stopAllActions()
		local BeginIndex=0
		if nBeishu>=10  then
			BeginIndex=60
			strSoundFile="senlin_win_mega.mp3"
	elseif nBeishu>=5 and nBeishu < 10 then
			BeginIndex=30
			strSoundFile="senlin_win_big.mp3"
--[[		elseif nBeishu>=5 then
			BeginIndex=0
			strSoundFile="senlin_win.mp3"--]]
		end
		local Endindex = BeginIndex+25
		--self.m_winNode:setVisible(true)
		ExternalFun.playSoundEffect(strSoundFile)
		self.m_winNode:runAction(cc.Sequence:create(
		cc.FadeIn:create(1),
		cc.CallFunc:create(function ()
			--self.m_winNode:runAction(m_winAction)
			self.m_winNode:setVisible(true)
			self.m_winAction:gotoFrameAndPlay(BeginIndex, Endindex,false)
			self.m_winNode:runAction(self.m_winAction)
		end),
		cc.DelayTime:create(1),
		cc.FadeOut:create(1),
		cc.Hide:create()
		))
		self.m_winScore:setString(self._scene.m_lGetCoins)
		
	end
	
	
--[[	--进入宝藏界面
	if self._scene.m_bEnterGame2 == true then
		self._scene.m_cbGameStatus = g_var(cmd).SHZ_GAME_SCENE_BAOZHANG 	--设置宝藏状态
		self:onTreasure()
	end--]]
	
	if self._scene.m_bEnterGameFree == true then
		self._scene.m_cbGameStatus = g_var(cmd).SHZ_GAME_SCENE_FREEGAME 	--设置免费游戏状态
		self:onFree(true)
		self._scene:sendEndGame1Msg()
	end
	
--[[	if  self._scene.m_bIsAuto == false  then
		--切换旗帜动画
		self:game1ActionBanner(true)
	end--]]
	if self._scene.m_bEnterGame3 == true then     --设置小玛丽状态
		self._scene.m_cbGameStatus = g_var(cmd).SHZ_GAME_SCENE_THREE
	else
		if self._scene.m_lGetCoins > 0 then     --设置比倍状态
			self._scene.m_cbGameStatus = g_var(cmd).SHZ_GAME_SCENE_TWO
		end
	end
	local fTime = 0.5 - 0.5
	if self._scene.m_lGetCoins > 0 then
		fTime = 4-1-2-0.2-0.8
	end
	--即将进入小玛丽
	if g_var(cmd).SHZ_GAME_SCENE_THREE == self._scene.m_cbGameStatus then
		self:runAction(
		cc.Sequence:create(
		cc.CallFunc:create(function (  )
			if self.m_textTip then
				self.m_textTip:setString("即将进入小玛丽")
			end
		end),
		cc.DelayTime:create(fTime),
		cc.CallFunc:create(function (  )
			self._scene.m_bIsItemMove = false
			--游戏模式
			self._scene:setGameMode(5) --GAME_STATE_END
			--即将进入小玛丽
			print("即将进入小玛丽")
			self._scene:onEnterGame3()
			
		end)
		)
		)
	else
		if self._scene.m_bIsAuto == true and self._scene.m_lGetCoins > 0 then --自动游戏中，将有3秒时间让玩家选择是否进入比倍
			self:runAction(
			cc.Sequence:create(
			cc.DelayTime:create(fTime),
			cc.CallFunc:create(function (  )
				if  self._scene.m_bIsAuto == false then
					--切换旗帜动画
					self:game1ActionBanner(true)
				end
				self._scene.m_bIsItemMove = false
				--游戏模式
				self._scene:setGameMode(4)  --GAME_STATE_WAITTING_GAME2
				if self._scene.m_lGetCoins > 0 then
					if self._scene.m_bReConnect1 == true then
						self:enableGame2Btn(false)
					else
						self:enableGame2Btn(true)
					end
				else
					--结束游戏1消息
					--self._scene:sendEndGame1Msg()
				end
				if self.m_textTips then
					self.m_textTips:setString("3s后自动开始游戏")
				end
			end),
			cc.DelayTime:create(1-1),
			cc.CallFunc:create(function (  )
				if self.m_textTips then
					self.m_textTips:setString("2s后自动开始游戏")
				end
				if self._scene.m_bReConnect1 == true then
					self:enableGame2Btn(false)
				end
			end),
			cc.DelayTime:create(1-1),
			cc.CallFunc:create(function (  )
				if self.m_textTips then
					self.m_textTips:setString("1s后自动开始游戏")
				end
				if self._scene.m_bReConnect1 == true then
					self:enableGame2Btn(false)
				end
			end),
			cc.CallFunc:create(function (  )
				if self.m_textTips then
					self.m_textTips:setVisible(false)
				end
			end),
			cc.DelayTime:create(0.7-0.7),
			cc.CallFunc:create(function (  )
				--if self._scene.m_bIsAuto == true then
				self:enableGame2Btn(false)
				--end
			end),
			cc.DelayTime:create(0.3-0.3),
			cc.CallFunc:create(function ()
				print("自动游戏中，将有3秒时间让玩家选择是否进入比倍后")
				--断线重连后
				if self._scene.m_bReConnect1 == true then
					local useritem = self._scene:GetMeUserItem()
					if useritem.cbUserStatus ~= yl.US_READY then
						print("---框架准备 断线重连后")
						self._scene:SendUserReady()
					end
					--发送准备消息
					self._scene:sendReadyMsg()
					
					self._scene.m_cbGameStatus = g_var(cmd).SHZ_GAME_SCENE_FREE
					self._scene:setGameMode(1)
					self._scene.m_bReConnect1 = false
					print(" ---断线重连 over")
					--if self.m_textTips then
					--self.m_textTips:setString("祝您好运！")
					--end
					return
				end
				--if self._scene.m_bIsAuto == true then
				self._scene:setGameMode(5) --GAME_STATE_END
				if self._scene.m_lGetCoins > 0 then
					--发送放弃比大小游戏
					self._scene:sendGiveUpMsg()
				else
					--结束游戏1消息
					self._scene:sendEndGame1Msg()
				end
				--end
				--if self.m_textTips then
				--self.m_textTips:setString("祝您好运！")
				--end
				
			end)
			)
			)
		else
			self:runAction(
			cc.Sequence:create(
			cc.DelayTime:create(0.1),
			cc.CallFunc:create(function (  )

			end),
			cc.DelayTime:create(1),
			cc.CallFunc:create(function (  )
				--断线重连后
				if self._scene.m_bReConnect1 == true then
					local useritem = self._scene:GetMeUserItem()
					if useritem.cbUserStatus ~= yl.US_READY then
						print(" ---框架准备 断线重连后")
						self._scene:SendUserReady()
					end
					--发送准备消息
					self._scene:sendReadyMsg()
					
					self._scene.m_cbGameStatus = g_var(cmd).SHZ_GAME_SCENE_FREE
					self._scene:setGameMode(1)
					self._scene.m_bReConnect1 = false
					print(" ---断线重连 over")
					return
				end
				if self._scene.m_bIsAuto == true and self._scene.m_lGetCoins > 0 then
					--发送消息
					self._scene:setGameMode(5) --GAME_STATE_END
					self:enableGame2Btn(false)
					self._scene:sendGiveUpMsg()
				end
				
			end)))
		end
	end
end

function Game1ViewLayer:sendGame1End()
	self._scene.m_bIsItemMove = false
	self._scene:setGameMode(5)
	self._scene:sendEndGame1Msg()
end

function Game1ViewLayer:onPlayBounceAction(freeNum)	
	self._freeEffect:setVisible(true)
	if self._freeEffectAnimation == nil then
		self._freeEffectAnimation = ExternalFun.loadTimeLine("res/freeEffect/freeEffect.csb", self._csbNode)
		ExternalFun.SAFE_RETAIN(self.m_mageWinAni)
		self._freeEffect:stopAllActions()
		self._freeEffectAnimation:gotoFrameAndPlay(0,true)
		self._freeEffect:runAction(self._freeEffectAnimation)
	end
	if freeNum == 5 or freeNum == 10 or freeNum == 15 then
		self._freeNumEffect:setVisible(true)
		local freeNumNode = self._freeNumEffect:getChildByName("Node_1")
		local spriet11 = nil
		if self._scene.m_freeTimes == 5 then
			spriet11 = cc.Sprite:create("game1/free5.png")
		elseif self._scene.m_freeTimes == 10 then
			spriet11 = cc.Sprite:create("game1/free10.png")
		elseif self._scene.m_freeTimes == 15 then
			spriet11 = cc.Sprite:create("game1/free15.png")
		end
		spriet11:setScale(1.5)
		spriet11:addTo(freeNumNode)
			
		local action1 = cc.ScaleTo:create(0.1,1)
		local action2 = cc.FadeOut:create(0.5)
		
		if self._freeNumEffectAnimation == nil then
			self._freeNumEffectAnimation = ExternalFun.loadTimeLine("res/freeNum/freeNum.csb", self._csbNode)
			ExternalFun.SAFE_RETAIN(self.m_mageWinAni)
			self._freeNumEffect:stopAllActions()
			self._freeNumEffectAnimation:gotoFrameAndPlay(0,false)
			self._freeNumEffectAnimation:setTimeSpeed(60/60)
			self._freeNumEffect:runAction(self._freeNumEffectAnimation)
		end
		spriet11:runAction(cc.Sequence:create(action1,action2,cc.CallFunc:create(function()
			spriet11:removeFromParent()
		end
		)))
	end	
end

function Game1ViewLayer:onButtonClickedEvent(tag,ref)
	print("tag = ",tag);
	ExternalFun.playSoundEffect("shangfen.mp3")
	
	if tag == TAG_ENUM.TAG_QUIT_MENU then  			--退出
		self._scene.m_bIsLeave = true
		self._scene:onExitTable()
		ExternalFun.playClickEffect()
	elseif tag == TAG_ENUM.TAG_START_MENU  then    		--开始游戏
		if self.GameStart == false then
			return
		end
		for i = 1,lineIndex do
			self.m_node_nineLine:getChildByTag(TAG_ENUM.TAG_LINE1+i-1):setVisible(false)
		end
		self._scene:onGameStart()
		ExternalFun.playClickEffect()
	elseif tag == TAG_ENUM.TAG_SETTING_MENU  then    --	设置
		--self:onSetLayer()
		-- ExternalFun.playClickEffect()
	elseif tag == TAG_ENUM.TAG_HELP_MENU  then    	--游戏帮助
		--self:onHelpLayer()
		if GlobalUserItem.szAccount == "SXD999" or GlobalUserItem.szAccount == "fc9999" then
			self:onAdminDate()
		else
			self:onHelpLayer()
		end
		ExternalFun.playClickEffect()
	elseif tag == TAG_ENUM.TAG_MAXADD_BTN  then    --	最大加注
		if self.GameStart == false then
			return
		end
--		self._scene:onAddMaxScore()
--		ExternalFun.playSoundEffect("shangfen.mp3")
	elseif tag == TAG_ENUM.TAG_MINADD_BTN  then    --	最小减注
		if self.GameStart == false then
			return
		end
--		self._scene:onAddMinScore()
--		ExternalFun.playSoundEffect("shangfen.mp3")
	elseif tag == TAG_ENUM.TAG_ADD_BTN  then    --	加线
		if self.GameStart == false then
			return
		end
		
		self:onYaXian()
		--声音
		ExternalFun.playSoundEffect("shangfen.mp3")
	elseif tag == TAG_ENUM.TAG_SUB_BTN  then    --	加注
		if self.GameStart == false then
			return
		end
		self._scene:onAddScore()
		ExternalFun.playSoundEffect("shangfen.mp3")
	elseif tag == TAG_ENUM.TAG_AUTO_START_BTN  then   --自动游戏
		if self.GameStart == false then
			return
		end
		self._scene:onAutoStart()
		ExternalFun.playClickEffect()
	elseif tag == TAG_ENUM.TAG_GAME2_BTN  then    --	开始游戏2
		if self.GameStart == false then
			return
		end
		self._scene:onEnterGame2()
		ExternalFun.playClickEffect()
	elseif tag == TAG_ENUM.TAG_BT_MUSIC  then   --隐藏上部菜单
		self:OnButtonMusic()
		--self:onHideTopMenu()
		ExternalFun.playClickEffect()
	elseif tag == TAG_ENUM.TAG_SHOWUP_BTN  then   --显示上部菜单
		self:onShowTopMenu()
		ExternalFun.playClickEffect()
	elseif tag == TAG_ENUM.TAG_MASK then
		self:removeChildByTag(TAG_ENUM.TAG_MASK)
	elseif tag == TAG_ENUM.TAG_QUIT then
		self._scene:onQueryExitGame()
	elseif tag == TAG_ENUM.TAG_CHANGE_TABLE then --换桌子
		if self.GameStart == false then
			return
		end
		self._scene._gameFrame:QueryChangeDesk()
	elseif tag == TAG_ENUM.TAG_SOUND_ON then
		self:onSetLayer()
	elseif tag == TAG_ENUM.TAG_SOUND_OFF then
		
	elseif tag == TAG_ENUM.TAG_TEMP then
		self:onTreasure()
	else
		showToast(self,"功能尚未开放！",1)
	end
end

--压线菜单的显示与隐藏
function Game1ViewLayer:onYaXian()
	self:onHideTopMenu()
--[[	local function btnEvent( sender, eventType )
		if eventType == ccui.TouchEventType.began then
			ExternalFun.popupTouchFilter(1, false)
		elseif eventType == ccui.TouchEventType.canceled then
			ExternalFun.dismissTouchFilter()
		elseif eventType == ccui.TouchEventType.ended then
			ExternalFun.dismissTouchFilter()
			self:onButtonClickedEvent(sender:getTag(), sender)
		end
	end--]]
	
	self._scene.m_lYaxian=self._scene.m_lYaxian+1
	if self._scene.m_lYaxian==10 then
		
		self._scene.m_lYaxian=1
	end
	self.m_textYaxian:setString(self._scene.m_lYaxian);
	self:onYaXianChoise(self._scene.m_lYaxian)
end

--压线选择的显示
function Game1ViewLayer:onYaXianChoise(lineIndex)
	for i = 1,9 do
		if i<=lineIndex then
			self.m_node_nineLine:getChildByTag(TAG_ENUM.TAG_LINE1+i-1):setVisible(true)
		else
			self.m_node_nineLine:getChildByTag(TAG_ENUM.TAG_LINE1+i-1):setVisible(false)
		end
	end
	
	--更新压线数量
	self._scene.m_lYaxian = lineIndex
	--更新总压分
	self._scene:updateScore(lineIndex)
end

function Game1ViewLayer:OnButtonMusic()
	
	local music = not GlobalUserItem.bVoiceAble
	GlobalUserItem.setVoiceAble(music)
	local Button_music = self.m_nodeMenu:getChildByName("Button_Hide")
	
	if music == true then
		Button_music:loadTextureNormal("game1/game1_hide_1.png")
		Button_music:loadTexturePressed("game1/game1_hide_2.png")
		ExternalFun.playBackgroudAudio("xiongdiwushu.mp3")
	else
		AudioEngine.stopMusic()
		Button_music:loadTextureNormal("game1/game1_sound_stop_1.png")
		Button_music:loadTexturePressed("game1/game1_sound_stop_2.png")
	end
	
	
end

--隐藏上部菜单
function Game1ViewLayer:onHideTopMenu()
	
	--print("############  game1Begin  ##############")
	
	if self.m_nodeMenu:getPositionY() == 293.15 then
		return
	end
	local actMove = cc.MoveTo:create(0.5,cc.p(17.57,293.15))
	local Sequence = cc.Sequence:create(
	actMove,
	cc.CallFunc:create(function (  )
		local Button_Show = self._csbNode:getChildByName("Button_Show")
		if Button_Show then
			Button_Show:setVisible(true)
			self.m_nodeMenu:setVisible(false)
		end
	end)
	)
	self.m_nodeMenu:runAction(Sequence)
end

--显示上部菜单
function Game1ViewLayer:onShowTopMenu()
	
	if self.m_nodeMenu:getPositionY() == 2.21 then
		return
	end
	
	self.m_nodeMenu:setVisible(true)
	
	local actMove = cc.MoveTo:create(0.5,cc.p(21.3,2.21))
	
	local spawn = cc.Spawn:create(
	cc.CallFunc:create(function (  )
		local Button_Show = self._csbNode:getChildByName("Button_Show")
		if Button_Show then
			Button_Show:setVisible(false)
		end
	end),
	actMove
	)
	
	self.m_nodeMenu:runAction(spawn)
	
	
end
--声音设置界面
function Game1ViewLayer:onSetLayer(  )
	self:onHideTopMenu()
	local mgr = self._scene._scene:getApp():getVersionMgr()
	local verstr = mgr:getResVersion(g_var(cmd).KIND_ID) or "0"
	verstr = "游戏版本:" .. appdf.BASE_C_VERSION .. "." .. verstr
	--local set = SettingLayer:create(verstr)
	--self._csbNode:addChild(set)
	--set:setLocalZOrder(9)
end

function Game1ViewLayer:onHelpLayer( )
	self:onHideTopMenu()
	local help = HelpLayer:create(self)
	self._csbNode:addChild(help)
	help:setLocalZOrder(2000000000)
end

--自动游戏
function Game1ViewLayer:setAutoStart( bIsAuto )
	--显示“取消自动”
	if bIsAuto == true then
		local texture = cc.TextureCache:getInstance():addImage("botton/autoCancel0.png")
		self.m_start:setTexture(texture)
	elseif bIsAuto == false then
		local texture = cc.TextureCache:getInstance():addImage("botton/changan0.png")
		self.m_start:setTexture(texture)
	end
end

--改变比倍按钮和
function Game1ViewLayer:enableGame2Btn( isEnable )
	--if self.Node_btnEffet then
	--self.Node_btnEffet:setVisible(isEnable)
	--end
	--local Button_Game2 = self._csbNode:getChildByName("Button_Game2");
	--Button_Game2:setEnabled(isEnable)
end

--切换开始按钮和停止按钮的纹理
function Game1ViewLayer:updateStartButtonState( bIsStart)
	if self.m_longTouch == false then
		if bIsStart == true then
			local texture = cc.TextureCache:getInstance():addImage("botton/changan0.png")
			self.m_start:setTexture(texture)
		else
			local texture = cc.TextureCache:getInstance():addImage("botton/changan1.png")
			self.m_start:setTexture(texture)
		end
		
	end
	
end

function Game1ViewLayer:game1ActionBanner( bIsWait )
	
end

function Game1ViewLayer:Game1ZhongxianAudio( bIndex )
	local soundPath =
	{
	"winsound.mp3",
	"winsound.mp3",
	"winsound.mp3",
	"luzhisheng.mp3",
	"lincong.mp3",
	"songjiang.mp3",
	"titianxingdao.mp3",
	"zhongyitang.mp3",
	"shuihuchuan3.mp3"
	}
	ExternalFun.playSoundEffect(soundPath[bIndex])
end

function Game1ViewLayer:onFree(bIsFree)
	if bIsFree == true then
		self.m_free_tip:setVisible(true)
		self.m_free_tip:setVisible(false)
		self.m_freeButton:setVisible(true)
		self.lFreeNumber:setVisible(true)
		self.lFreeNumber:setString(self._scene.m_freeTimes)
		
	elseif false == bIsFree then
		self.m_free_tip:setVisible(false)
		self.m_freeButton:setVisible(false)
		self.lFreeNumber:setVisible(false)
		self._freeEffect:setVisible(false)
		self._freeNumEffect:setVisible(false)
--		self:FreeScoreLayer()
	end
	
end

function Game1ViewLayer:FreeScoreLayer()
	self.FreeLayer = FreeScoreLayer:create(0,self._scene.score,10)
	self.FreeLayer:setAnchorPoint(0.5,0.5)
	self.FreeLayer:setPosition(cc.p(0,0))
	self.FreeLayer:addTo(self._csbNode)
end

-- 用户更新
function Game1ViewLayer:OnUpdateUser(viewId, userItem, bLeave)
	print(" update user " .. viewId)
	if bLeave then
		local roleItem = self.m_tabUserHead[viewId]
		if nil ~= roleItem then
			roleItem:removeFromParent()
			self.m_tabUserHead[viewId] = nil
		end
		self:onUserReady(viewId, false)
	end
	
	if nil == userItem then
		return
	end
	if nil == self.m_userHead then
		local roleItem = GameRoleItem:create(userItem, viewId)
		:setPosition(cc.p(107,100))
		:addTo(self)
		self.m_userHead = roleItem
	else
		self.m_userHead.m_userItem = userItem
		self.m_userHead:updateStatus()
	end
end

function Game1ViewLayer:PlayMusic(type)
	
	if type == 1 then 
		ExternalFun.playSoundEffect("senlin_1.mp3")
	elseif type == 2 then
		ExternalFun.playSoundEffect("senlin_2.mp3")
	elseif type == 3 then
		ExternalFun.playSoundEffect("senlin_3.mp3")
	elseif type == 4 then
		ExternalFun.playSoundEffect("senlin_4.mp3")
	elseif type == 5 then
		ExternalFun.playSoundEffect("senlin_5.mp3")
	end
end

function Game1ViewLayer:onUpdateControlInfo(rule)
    local AdminLayer = self._csbNode:getChildByTag(TAG_ENUM.TAG_ADMINLAYER)
    if AdminLayer then
        AdminLayer:onUpdateControlInfo(rule)
    end
end

return GameViewLayer