local module_pre = "game.yule.egyptslots.src"
local ScollNumLayer = appdf.req(module_pre .. ".views.layer.ScollNumLayer")
local FreeScoreLayer = appdf.req(module_pre .. ".views.layer.FreeScoreLayer")
local ItemIcon = appdf.req(module_pre .. ".views.layer.ItemIcon")
local GameRoleItem = appdf.req(module_pre .. ".views.layer.GameRoleItem")
--local PopupInfoHead = appdf.req(appdf.EXTERNAL_SRC .. "PopupInfoHead")
local GameViewLayer = {}
GameViewLayer.RES_PATH              = "game/yule/egyptslots/res/"
local Treasure = appdf.req(module_pre .. ".views.layer.Treasure")

--	游戏一
local Game1ViewLayer = class("Game1ViewLayer",function(scene)
		local gameViewLayer =  display.newLayer()
    return gameViewLayer
end)
GameViewLayer[1] = Game1ViewLayer
--	游戏二
local Game2ViewLayer = class("Game2ViewLayer",function(scene)
		local gameViewLayer =  display.newLayer()
    return gameViewLayer
end)
GameViewLayer[2] = Game2ViewLayer
--	游戏三
local Game3ViewLayer = class("Game3ViewLayer",function(scene)
		local gameViewLayer =  display.newLayer()
    return gameViewLayer
end)
GameViewLayer[3] = Game3ViewLayer

local module_pre = "game.yule.egyptslots.src"
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")
local g_var = ExternalFun.req_var
local ClipText = appdf.EXTERNAL_SRC .. "ClipText"

local cmd = module_pre .. ".models.CMD_Game"
local QueryDialog   = require("app.views.layer.other.QueryDialog")

local GameItem = appdf.req(module_pre .. ".views.layer.GameItem")

local PRELOAD = require(module_pre..".views.layer.PreLoading") 

local SettingLayer = appdf.req(module_pre .. ".views.layer.SettingLayer")
local HelpLayer = appdf.req(module_pre .. ".views.layer.HelpLayer")

GameViewLayer.RES_PATH 				= device.writablePath.. "game/yule/egyptslots/res/"

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
	"TAG_HIDEUP_BTN",			--隐藏上部菜单
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
	"TAG_START_IMAGE1","TAG_START_IMAGE2",
	"TAG_KAI","TAG_QI","TAG_SHEN","TAG_MI","TAG_BAO","TAG_ZANG",
	"TAG_CLIPPING",
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
	--初始化按钮状态
	self.sp_yaxian_bk_status = false
	self.tick = 0
	self.m_gameStart = false		
	self.m_longTouch = false	--长按自动
	self.m_question = {}
	self.m_node = {}
	self.m_bQuestion = false
	
	self.GameModle = g_var(cmd).GM_NULL
	
	self.m_nodeAct = {}
	self.m_bNodeActRun = false
	--注册node事件
	ExternalFun.registerNodeEvent(self)
	self._scene = scene
    --添加路径
    self:addPath()
    --预加载资源
	PRELOAD.loadTextures()
	--初始化csb界面
	self:initCsbRes();
    --播放背景音乐
    ExternalFun.playBackgroudAudio("xiongdiwushu.mp3")
	
    --头像初始化
    local useritem = scene:GetMeUserItem()
    local viewid = scene:SwitchViewChairID(scene:GetMeChairID())
    self.m_userHead = GameRoleItem:create(useritem, viewid)
    self.m_userHead:setPosition(cc.p(110,550))
    self.m_userHead:addTo(self)
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

function Game1ViewLayer:addPath( )
    self._searchPath = cc.FileUtils:getInstance():getSearchPaths()
	cc.FileUtils:getInstance():addSearchPath(GameViewLayer.RES_PATH)
	cc.FileUtils:getInstance():addSearchPath(GameViewLayer.RES_PATH .. "game1/");
	cc.FileUtils:getInstance():addSearchPath(GameViewLayer.RES_PATH .. "game2/");
	cc.FileUtils:getInstance():addSearchPath(GameViewLayer.RES_PATH .. "game3/");
	cc.FileUtils:getInstance():addSearchPath(GameViewLayer.RES_PATH .. "common/");
	cc.FileUtils:getInstance():addSearchPath(GameViewLayer.RES_PATH .. "setting/");
    cc.FileUtils:getInstance():addSearchPath(GameViewLayer.RES_PATH .. "sound_res/"); --  声音
	cc.FileUtils:getInstance():addSearchPath(GameViewLayer.RES_PATH.."botton/");	--底部
end

function Game1ViewLayer:addNodeAction()
	for i=1,15 do
		local posx = math.ceil(i/3)
		local posy = (i-1)%3 + 1
		local nodeStr = string.format("Node_%d_%d",posx-1,posy-1)
		local node = self._csbNode:getChildByName(nodeStr)
		--上方方框序列帧
		--创建序列帧
		self.m_nodeAct[i] = cc.Node:create()
		self.m_nodeAct[i]:setPosition(node:getPosition())
		self.m_nodeAct[i]:setVisible(false)
		self._csbNode:addChild(self.m_nodeAct[i])
		--item框
		local spBox = display.newSprite("#game1_box_1.png")
		self.m_nodeAct[i]:addChild(spBox)
		spBox:setPosition(0,0)
   		local action = cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("game1BoxAnim"))
		spBox:runAction(cc.RepeatForever:create(action))
		--闪光精灵
		local spLight = display.newSprite("#common_light_01.png")
		local spLight = cc.Sprite:create()
		self.m_nodeAct[i]:addChild(spLight)
		spLight:setPosition(0,0)
		local action2 = cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("lightAnim"))
		local action3 = cc.ScaleTo:create(0.3,1.1)
		local action4 = cc.Spawn:create(action2,action3)
		--spLight:runAction(cc.RepeatForever:create(action2))
		spLight:runAction(cc.RepeatForever:create(action4))
	end
end

---------------------------------------------------------------------------------------
--界面初始化
function Game1ViewLayer:initCsbRes(  )
	
	cc.Sprite:create("game1/bk.png"):addTo(self):setPosition(cc.p(1334/2,750/2-20))
	rootLayer, self._csbNode = ExternalFun.loadRootCSB(GameViewLayer.RES_PATH .."SHZ_Game1Layer.csb", self);
	local pos =	{
		cc.p(355+157*0,505),		cc.p(355+157*1,505),		cc.p(355+157*2,505),		cc.p(355+157*3,505),		cc.p(355-0.5+157*4,505),
		cc.p(355+157*0,505-146*1),	cc.p(355+157*1,505-146*1),	cc.p(355+157*2,505-146*1),	cc.p(355+157*3,505-146*1),	cc.p(355-0.5+157*4,505-146*1),
		cc.p(355+157*0,506-146*2),	cc.p(355+157*1,506-146*2),	cc.p(355+157*2,506-146*2),	cc.p(355+157*3,506-146*2),	cc.p(355-0.5+157*4,506-146*2),
		}
--[[	local question = {}
	for i=1,15 do
		---local posx = math.mod(i-1,5)+1
		--local posy = math.mod(i-1,3)+1
		question[i] = cc.Sprite:create("common/question.png")
		self._csbNode:addChild(question[i])
		question[i]:setPosition(pos[i])
			:setVisible(false)
			:setTag(10000+i)
	end--]]
		
	self.ItemIcons = ItemIcon:new()
	
	local stencil  = cc.Sprite:create()
	stencil:setTextureRect(cc.rect(0,0,800,420))
	self.clippingNode = cc.ClippingNode:create(stencil)
	self.clippingNode:setInverted(false)
	self.clippingNode:addTo(self._csbNode)
	self.clippingNode:setAnchorPoint(0.5,0.5)
	self.clippingNode:setPosition(cc.p(1334/2,750/2-15))
	self.clippingNode:setVisible(false)
	self.clippingNode:setTag(TAG_ENUM.TAG_CLIPPING)
	
	local pos1 = {cc.p(-157*2+1,180+10+10-400),cc.p(-157*1+1,200-400),cc.p(0+1,200-400), cc.p(157*1+1,200-400),cc.p(157*2+1,200-400)}
	
	self.m_moveSprite = {0,0,0,0,0}
	self.m_moveSprite[1] = cc.Sprite:create("common/common_MoveImg1.png")
	self.m_moveSprite[1]:addTo(self.clippingNode)
	self.m_moveSprite[1]:setAnchorPoint(0.5,0)
	self.m_moveSprite[1]:setPosition(pos1[1])
	
	self.m_moveSprite[2] = cc.Sprite:create("common/common_MoveImg2.png")
	self.m_moveSprite[2]:addTo(self.clippingNode)
	self.m_moveSprite[2]:setAnchorPoint(0.5,0)
	self.m_moveSprite[2]:setPosition(pos1[2])
	
	self.m_moveSprite[3] = cc.Sprite:create("common/common_MoveImg3.png")
	self.m_moveSprite[3]:addTo(self.clippingNode)
	self.m_moveSprite[3]:setAnchorPoint(0.5,0)
	self.m_moveSprite[3]:setPosition(pos1[3])
	
	self.m_moveSprite[4] = cc.Sprite:create("common/common_MoveImg4.png")
	self.m_moveSprite[4]:addTo(self.clippingNode)
	self.m_moveSprite[4]:setAnchorPoint(0.5,0)
	self.m_moveSprite[4]:setPosition(pos1[4])
		
	self.m_moveSprite[5] = cc.Sprite:create("common/common_MoveImg5.png")
	self.m_moveSprite[5]:addTo(self.clippingNode)
	self.m_moveSprite[5]:setAnchorPoint(0.5,0)
	self.m_moveSprite[5]:setPosition(pos1[5])
	
	
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
	self.label15:addTo(self._csbNode)--]]
	
--	self.label16 = cc.LabelTTF:create("0", "Arial", 30)                         
--    self.label16:setPosition(cc.p(1334/2+550,750/2-100))  
--	self.label16:addTo(self._csbNode)

	
	--初始化按钮
	self:initUI(self._csbNode)

   	local nodeDagu    = self.Node_top:getChildByName("Sprite_dagu"):setVisible(false)
   	local nodeTitle   = self.Node_top:getChildByName("Sprite_title"):setVisible(false)
   	local nodePiaoqi  = self.Node_top:getChildByName("Sprite_piaoqi"):setVisible(false)
   	local nodePiaoqi2 = self.Node_top:getChildByName("Sprite_piaoqi2"):setVisible(false)
   	
	--公告
	local notify = cc.Sprite:create("game1/laba.png")
		:setPosition(cc.p(1334/2,720))
		:addTo(self._csbNode)
	local stencil  = display.newSprite()
	stencil:setAnchorPoint(cc.p(0,0.5))
	stencil:setTextureRect(cc.rect(0,0,627+270,50))
	
	self._notifyClip = cc.ClippingNode:create(stencil)
	self._notifyClip:setAnchorPoint(cc.p(0,0.5))
	self._notifyClip:setInverted(false)
	self._notifyClip:move(95,30)
	self._notifyClip:addTo(notify)

	self._notifyText = cc.Label:createWithTTF("", "fonts/round_body.ttf", 24)
								:addTo(self._notifyClip)
								:setTextColor(cc.c4b(255,191,123,255))
								:setAnchorPoint(cc.p(0,0.5))
								:enableOutline(cc.c4b(79,48,35,255), 1)
				
	self.m_tabInfoTips = {}
	
	self._tipIndex = 1
	
	self.m_nNotifyId = 0
	
	-- 系统公告列表
	self.m_tabSystemNotice = {}
	
	self._sysIndex = 1
	
	-- 公告是否运行
	self.m_bNotifyRunning = false

	self.m_bSingleGameMode = false
	
	--免费游戏提示
	local free = cc.Sprite:create("game1/free.png")
	free:addTo(self._csbNode)
	free:setPosition(cc.p(1334/2,750/2))
	free:setVisible(false)
	free:setLocalZOrder(9)
	self.m_free_tip = free
	
	--进入宝藏提示
	local treasure = cc.Sprite:create("game1/intoTreasure.png")
	treasure:addTo(self._csbNode)
	treasure:setPosition(cc.p(1334/2,750/2))
	treasure:setVisible(false)
	self.m_treasure_tip = treasure
	local kai = cc.Sprite:create("res/treasure/kai.png")
		:addTo(self._csbNode)
		--:setPosition(cc.p(300,750/2))
		:setPosition(cc.p(300+1200,750/2))
		:setTag(TAG_ENUM.TAG_KAI)
	local qi = cc.Sprite:create("res/treasure/qi.png")
		:addTo(self._csbNode)
		:setPosition(cc.p(300+734/5+1200,750/2))
		:setTag(TAG_ENUM.TAG_QI)
	local shen = cc.Sprite:create("res/treasure/shen.png")
		:addTo(self._csbNode)
		:setPosition(cc.p(300+734/5*2+1200,750/2))
		:setTag(TAG_ENUM.TAG_SHEN)
	local mi = cc.Sprite:create("res/treasure/mi.png")
		:addTo(self._csbNode)
		:setPosition(cc.p(300+734/5*3+1200,750/2))
		:setTag(TAG_ENUM.TAG_MI)
	local bao = cc.Sprite:create("res/treasure/bao.png")
		:addTo(self._csbNode)
		:setPosition(cc.p(300+734/5*4+1200,750/2))
		:setTag(TAG_ENUM.TAG_BAO)
	local zang = cc.Sprite:create("res/treasure/zang.png")
		:addTo(self._csbNode)
		:setPosition(cc.p(1334 - 300+1200,750/2))
		:setTag(TAG_ENUM.TAG_ZANG)
	
	--请求公告
	self:requestNotice()
	
	self.m_bigWin = ExternalFun.loadCSB("res/bigWin/bigWin.csb", self._csbNode)
	self.m_bigWin:setAnchorPoint(cc.p(0.5,0.5))
	self.m_bigWin:setPosition(cc.p(1334/2,750/2))
	self.m_bigWin:setVisible(false)
	local node1 = self.m_bigWin:getParent()
	self.m_getScore1 = cc.Label:createWithTTF("", "round_body.ttf", 80)
		:setPosition(667,125)
		:setTextColor(cc.c4b(239,251,0,255))
		:enableOutline(cc.c4b(255,0,0,255), 1)
		:addTo(node1)
		
	self.m_mageWin = ExternalFun.loadCSB("res/mageWin/mageWin.csb", self._csbNode)
	self.m_mageWin:setPosition(cc.p(1334/2,750/2))
	self.m_mageWin:setVisible(false)
	self.m_mageWin:setScale(0.73)
	local node2 = self.m_mageWin:getParent()
	local temp = node2:getContentSize()
	self.m_getScore2 = cc.Label:createWithTTF("", "round_body.ttf", 95)
		:setPosition(667,145)
		:setTextColor(cc.c4b(239,251,0,255))
		:enableOutline(cc.c4b(255,0,0,255), 1)
		:addTo(node2)
end

function Game1ViewLayer:nodeAction()
	for i=1,15 do
		local posx = math.ceil(i/3)
		local posy = (i-1)%3 + 1
		local nodeStr = string.format("Node_%d_%d",posx-1,posy-1)
		local node = self._csbNode:getChildByName(nodeStr)
		if node then
		local pItem = node:getChildByTag(1)
		if pItem then
			pItem:setState(0) -- STATE_NORMAL
			--判断是否中奖的
			local isOnLine = false
			for j=1,g_var(cmd).ITEM_X_COUNT do
			local pos = {}
			pos.x = pActionOneYaXian.ptXian[j].x
			pos.y = pActionOneYaXian.ptXian[j].y
			if pos.x == posy and pos.y == posx then
				isOnLine = true
				--上方方框序列帧
				--创建序列帧
				local index = i + (self.m_lineIndex - 1) * 15
				self.m_nodeAct[index] = cc.Node:create()
				self.m_nodeAct[index]:setPosition(node:getPosition())
				self._csbNode:addChild(self.m_nodeAct[index])
				--item框
				local spBox = display.newSprite("#game1_box_1.png")
				self.m_nodeAct[index]:addChild(spBox)
				spBox:setPosition(0,0)
   				local action = cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("game1BoxAnim"))
				spBox:runAction(cc.RepeatForever:create(action))
				--闪光精灵
				local spLight = display.newSprite("#common_light_01.png")
				local spLight = cc.Sprite:create()
				self.m_nodeAct[index]:addChild(spLight)
				spLight:setPosition(0,0)
				local action2 = cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("lightAnim"))
				local action3 = cc.ScaleTo:create(0.3,1.1)
				local action4 = cc.Spawn:create(action2,action3)
				--spLight:runAction(cc.RepeatForever:create(action2))
				spLight:runAction(cc.RepeatForever:create(action4))
				self.m_bNodeActRun = true
				--table.insert(self.m_nodeAct,nodeAct)

				self.m_nodeAct[index]:runAction(cc.Sequence:create(
				cc.DelayTime:create(1.5),
				cc.CallFunc:create(function (  )
				for i = 1, #self.m_nodeAct do
					self.m_nodeAct[index]:stopAllActions()
					self.m_nodeAct[index]:removeFromParent()
				end
				self.m_bNodeActRun = false
				end)
				))
				--显示得分
					--self.m_textTips:setString(string.format("得分：%d",pActionOneYaXian.lXianScore))
					end
				end
				if isOnLine == false then
					pItem:setState(2) --STATE_GREY
				end
			end
		end
	end
end

--得分动画megeWin()
function Game1ViewLayer:mageWin()
	self.m_getScore2:setVisible(false)
	self.m_getScore2:setString(self._scene.m_lGetCoins)
	
	self.layer1 = self._csbNode:getChildByTag(6666)	
	if self.layer1 ~= nil then 
		
	else
		self.layer1 = ScollNumLayer:create()
		self.layer1:addTo(self._csbNode)
		self.layer1:setPositionY(-230)
		self.layer1:setTag(6666)
		local number = math.ceil(self._scene.m_lGetCoins/180*3.5)
		self.layer1:start(0,self._scene.m_lGetCoins,number)
	end
	
	self.m_mageWin:setVisible(true)
	if self.m_mageWinAni == nil then 
		self.m_mageWinAni = ExternalFun.loadTimeLine("res/mageWin/mageWin.csb", self._csbNode)
	end
	ExternalFun.SAFE_RETAIN(self.m_mageWinAni)
	self.m_mageWin:stopAllActions()
	self.m_mageWinAni:gotoFrameAndPlay(0,true)
	self._csbNode:stopAllActions()
	self._csbNode:runAction(cc.Sequence:create(
		cc.CallFunc:create(
		function()
			self.m_mageWin:runAction(self.m_mageWinAni)
		end
		),
		cc.DelayTime:create(6.5),
		cc.CallFunc:create(
		function()
			self.m_mageWin:setVisible(false)
			self.m_getScore2:setVisible(false)
			self.layer1:removeFromParent()
		end
		)))
end

--得分动画bigWin
function Game1ViewLayer:bigWin()
	self.m_getScore1:setVisible(false)
	self.m_getScore1:setString(self._scene.m_lGetCoins)
	
	self.layer2 = self._csbNode:getChildByTag(9999)	
	if self.layer2 ~= nil then 
		
	else
		self.layer2 = ScollNumLayer:create()
		self.layer2:addTo(self._csbNode)
		self.layer2:setPositionY(-260)
		self.layer2:setTag(9999)
		local number = math.ceil(self._scene.m_lGetCoins/180*3.5)
		self.layer2:start(0,self._scene.m_lGetCoins,number)
	end
	
	self.m_bigWin:setVisible(true)
	if self.m_bigWinAni == nil then
		self.m_bigWinAni = ExternalFun.loadTimeLine("res/bigWin/bigWin.csb", self._csbNode)
	end
	ExternalFun.SAFE_RETAIN(self.m_bigWinAni)
	self.m_bigWin:stopAllActions()
	self.m_bigWinAni:gotoFrameAndPlay(0,true)
	local actionHide = cc.Hide:create()
	self._csbNode:stopAllActions()
	self._csbNode:runAction(cc.Sequence:create(
		cc.CallFunc:create(
		function()
			self.m_bigWin:runAction(self.m_bigWinAni)
		end
		),
		cc.DelayTime:create(6.5),
		cc.CallFunc:create(
		function()
			self.m_bigWin:setVisible(false)
			self.m_getScore1:setVisible(false)
			self.layer2:removeFromParent()
		end
		)))
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
	--帧循环定时器回调函数
	local function update()
		if self.bStartButtonTouch == true then
			self.tick = self.tick + 1
			if self.tick > 80 and self.moved == false then
				--自动开始
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
		if self._scene.m_bEnterGameFree == true then
			return false
		end
		
		if self.m_gameStart == true and self._scene.m_bIsAuto == false then
			return false
		end
		self.tick = 0
		self.m_longTouch = false
        
        if self._scene.m_bIsAuto then
            return true
        end
        
        self.beganPoint = touch:getLocation()
        local point = self.m_start:convertToNodeSpace(self.beganPoint)
        local rect = cc.rect(0+25,0-25,self.m_start:getContentSize().width,self.m_start:getContentSize().height)
        --if cc.rectContainsPoint(rect,point) and self._scene:getGameMode()== 5 then
		if cc.rectContainsPoint(rect,point) then
				self.bStartButtonTouch = true
				self.moved = false
				self.ended = false
				--启动帧循环定时器
				local scheduler = cc.Director:getInstance():getScheduler()
				self.m_schedule = scheduler:scheduleScriptFunc(update, 0, false)
        end
		--print("点击后".."X="..self.beganPoint.x.."Y="..self.beganPoint.y)
        return true
    end
	
	local function onTouchMoved(touch,event)
		self.delta = touch:getDelta()
		if self.moved == nil or self.moved == false then
			if math.abs(self.delta.x) > 20.0 and math.abs(self.delta.y) > 20.0 then
				self.moved = true
			else
				self.moved = false
			end
		end
    end
	
	local function onTouchEnd(touch,event)
		local temp = self._scene.m_cbGameMode 
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
					elseif 	self._scene.m_cbGameMode == 3 then --转动
						if self._scene.m_lGetCoins < self._scene.m_lTotalYafen * 5 then
								for i = 1, #self.m_nodeAct do
									if 	self.m_nodeAct[i] then
										if self.m_bNodeActRun == true then
											self.m_nodeAct[i]:setVisible(false)
										end
									end
								end
							self._scene.m_cbGameMode = 0
							self._scene:onGameStart()
						end
					end
				end
			else
				if (self._scene.m_cbGameMode == 5) or (self._scene.m_cbGameMode == 0) then --游戏结束状态
					self._scene:onGameStart()
				elseif 	self._scene.m_cbGameMode == 3 then --转动
					if self._scene.m_lGetCoins < self._scene.m_lTotalYafen * 5 then
							for i = 1, #self.m_nodeAct do
								if 	self.m_nodeAct[i] then
									if self.m_bNodeActRun == true then
										self.m_nodeAct[i]:setVisible(false)
									end
								end
							end
						self._scene.m_cbGameMode = 0
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
	--加载中间图片
	local image = ccui.ImageView:create("game1/startImage2.png")
		:addTo(self._csbNode)
		:setPosition(cc.p(1334/2,750/2-9))
		:setTag(TAG_ENUM.TAG_START_IMAGE1)
	local image = ccui.ImageView:create("game1/startImage1.png")
		:addTo(self._csbNode)
		:setPosition(cc.p(1334/2-14,750/2-9-8))
		:setTag(TAG_ENUM.TAG_START_IMAGE2)
	--加载顶部按钮
	local csbNodeTop = ExternalFun.loadCSB(GameViewLayer.RES_PATH.."nodeTop.csb", self)
	csbNodeTop:setLocalZOrder(256)
	--左边按钮背景
	local top_bk_left = csbNodeTop:getChildByName("image_top_bk_left")
	local btn_back = top_bk_left:getChildByName("button_back")
		:setTag(TAG_ENUM.TAG_QUIT)
		:addTouchEventListener(btnEvent)
		
	local top_bk_right = csbNodeTop:getChildByName("image_top_bk_right")
    self._top_bk_right = top_bk_right
	
	local btn = top_bk_right:getChildByName("button_help")
		:setTag(TAG_ENUM.TAG_HELP)
		:addTouchEventListener(btnEvent)
	
	local btn = top_bk_right:getChildByName("button_sound_on")
		:setTag(TAG_ENUM.TAG_SOUND_ON)
		:addTouchEventListener(btnEvent)
	
	local btn = top_bk_right:getChildByName("button_sound_off")
		:setVisible(false)
		:setTag(TAG_ENUM.TAG_SOUND_OFF)
		:addTouchEventListener(btnEvent)
	--换桌	
	local btn = top_bk_right:getChildByName("button_change_table"):setVisible(false)
		:setTag(TAG_ENUM.TAG_CHANGE_TABLE)
		:addTouchEventListener(btnEvent)
		
	local treasure = ccui.Button:create("botton/add0.png","botton/add1.png")
		:addTo(top_bk_left)
		:setPosition(cc.p(100,30))
		:setTag(TAG_ENUM.TAG_TEMP)
		:setVisible(false)
		:addTouchEventListener(btnEvent)
	
	--底部背景
	local sprite_bk = cc.Sprite:create("botton/botton_bk.png")
	sprite_bk:addTo(self)
	local size = sprite_bk:getContentSize()
	sprite_bk:setPosition(cc.p(size.width/2,size.height/2))
	--单注金币
	local sprite_singleCoin = cc.Sprite:create("botton/singleCoin.png")
	sprite_singleCoin:addTo(sprite_bk)
	sprite_singleCoin:setPosition(cc.p(133,size.height/2))
	--单注金币背景
	local sprite_singleCoin_bk = cc.Sprite:create("botton/singleCoin_bk.png")
	sprite_singleCoin_bk:addTo(sprite_bk)
	sprite_singleCoin_bk:setPosition(cc.p(326,size.height/2))
	--加
	local button_add = ccui.Button:create("botton/add0.png","botton/add1.png","botton/add1.png")
	button_add:addTo(sprite_bk)
	button_add:setPosition(cc.p(225,size.height/2))
	button_add:setTag(TAG_ENUM.TAG_ADD_BTN)
	button_add:addTouchEventListener(btnEvent)
	self.m_add = button_add
	--减
	local button_reduce = ccui.Button:create("botton/reduce0.png","botton/reduce1.png","botton/reduce1.png")
	button_reduce:addTo(sprite_bk)
	button_reduce:setPosition(cc.p(427,size.height/2))
	button_reduce:setTag(TAG_ENUM.TAG_SUB_BTN)
		:addTouchEventListener(btnEvent)
	self.m_reduce = button_reduce
	--总下注
	local sprite_total = cc.Sprite:create("botton/total.png")
	sprite_total:addTo(sprite_bk)
	sprite_total:setPosition(cc.p(519,size.height/2))
	--总下注金币背景
	local sprite_total_bk = cc.Sprite:create("botton/total_bk.png")
	sprite_total_bk:addTo(sprite_bk)
	sprite_total_bk:setPosition(cc.p(673.5,size.height/2))
	--最大押注
	local button_max = ccui.Button:create("botton/max0.png","botton/max1.png","botton/max1.png")
		:setTag(TAG_ENUM.TAG_MAXADD_BTN)
	button_max:addTo(sprite_bk)
	button_max:setPosition(cc.p(881.5,size.height/2))
		:addTouchEventListener(btnEvent)
	self.m_max = button_max
	--压线数量
	local button_yaxian = ccui.Button:create("botton/yaxian0.png","botton/yaxian1.png","botton/yaxian1.png")
	button_yaxian:addTo(sprite_bk)
	button_yaxian:setPosition(cc.p(1042,size.height/2))
	button_yaxian:setTag(TAG_ENUM.TAG_YA_XIAN)
		:addTouchEventListener(btnEvent)
	local size_button_yaxian = button_yaxian:getContentSize()
	self.button_yaxian = button_yaxian
	--按钮上显示的当前压线数量（1-9线）
	for i = 1,9 do
		local stringPath1 = "botton/yaxian/"..i..".png"
		local sp_yaxian = CCSprite:create(stringPath1)
		sp_yaxian:setTag(TAG_ENUM.TAG_YA_XIAN + i)
		sp_yaxian:addTo(self.button_yaxian)
		sp_yaxian:setPosition(cc.p(size_button_yaxian.width/2,size_button_yaxian.height/2))
		sp_yaxian:setVisible(false)
	end
	--默认显示9线
	local temp = self.button_yaxian:getChildByTag(TAG_ENUM.TAG_YA_XIAN9):setVisible(true)
	--长按自动
	local button_changan = cc.Sprite:create("botton/changan0.png")
		:setTag(TAG_ENUM.TAG_START_MENU)
	button_changan:setAnchorPoint(0.55,0.33)
	button_changan:addTo(sprite_bk)
	button_changan:setPosition(cc.p(1252,size.height/2))
		--:addTouchEventListener(btnEvent)
	self.m_start = button_changan
	--免费
	local sp_free = cc.Sprite:create("botton/free0.png")
		:setTag(TAG_ENUM.TAG_FREETIMES)
		:setAnchorPoint(0, 0)
		:addTo(button_changan)
		:setVisible(false)
	self.m_free = sp_free
	--免费次数的数字
	self.m_freeNumber ={}
	for i = 1, 15 do
		local str = "botton/freeNumber"..i..".png"
		local sp_free = cc.Sprite:create(str)
			:setTag(TAG_ENUM.TAG_FREETIMES+i)
			:setAnchorPoint(0, 0)
			:addTo(sp_free)
			:setPosition(50,0)
			:setVisible(false)
		self.m_freeNumber[i] = sp_free
	end
	
	--压分（单注金币）
	self.m_textYafen = csbNode:getChildByName("Text_yafen")
	self.m_textYafen:retain()
	self.m_textYafen:removeFromParent()
	self.m_textYafen:addTo(sprite_bk)
	self.m_textYafen:release()
	self.m_textYafen:setPosition(cc.p(328,size.height/2))
	--总压分（总下注）
	self.m_textAllyafen = csbNode:getChildByName("Text_allyafen")
	self.m_textAllyafen:retain()
	self.m_textAllyafen:removeFromParent()
	self.m_textAllyafen:addTo(sprite_bk)
	self.m_textAllyafen:release()
	self.m_textAllyafen:setPosition(cc.p(675,size.height/2))
	
--------------------------------------------------------------------------------------------------------------------------------------
	--最小押注
	local Button_Min = csbNode:getChildByName("Button_Min"):setVisible(false)
	--Button_Min:setTag(TAG_ENUM.TAG_MINADD_BTN);
	--Button_Min:addTouchEventListener(btnEvent);
	--最大押注
	local Button_Max = csbNode:getChildByName("Button_Max"):setVisible(false)
	--Button_Max:setTag(TAG_ENUM.TAG_MAXADD_BTN);
	Button_Max:addTouchEventListener(btnEvent);
	--减少
	local Button_Sub = csbNode:getChildByName("Button_Sub"):setVisible(false)
	--Button_Sub:setTag(TAG_ENUM.TAG_SUB_BTN);
	Button_Sub:addTouchEventListener(btnEvent);
	--减少
	local Button_Add = csbNode:getChildByName("Button_Add"):setVisible(false)
	--Button_Add:setTag(TAG_ENUM.TAG_ADD_BTN);
	Button_Add:addTouchEventListener(btnEvent);
	--进入比大小
	local Button_Game2 = csbNode:getChildByName("Button_Game2"):setVisible(false)
	Button_Game2:setTag(TAG_ENUM.TAG_GAME2_BTN);
	Button_Game2:addTouchEventListener(btnEvent);
	--自动加注
	local Button_Auto = csbNode:getChildByName("Button_Auto"):setVisible(false)
	Button_Auto:setTag(TAG_ENUM.TAG_AUTO_START_BTN);
	--Button_Auto:addTouchEventListener(btnEvent);
	--开始
	local Button_Start = csbNode:getChildByName("Button_Start"):setVisible(false)
	--Button_Start:setTag(TAG_ENUM.TAG_START_MENU);
	--Button_Start:addTouchEventListener(btnEvent);
	--显示菜单
	local Button_Show = csbNode:getChildByName("Button_Show"):setVisible(false)
	Button_Show:setTag(TAG_ENUM.TAG_SHOWUP_BTN);
	Button_Show:addTouchEventListener(btnEvent);
	------
	--游戏币
	self.m_textScore = csbNode:getChildByName("Text_score"):setVisible(false)
--	"self._scene:GetMeUserItem().lScore"
	local userScore = string.formatNumberThousands("1000000000000",true,",")
	self.m_textScore:setString(userScore)
	
	--压线
	self.m_textYaxian = csbNode:getChildByName("Text_yaxian"):setVisible(false)
	--得到分数
	self.m_textGetScore = csbNode:getChildByName("Text_getscore")
		:setPosition(668,750-90)
		:setFontSize(40)
		:setTextColor(cc.c4b(239,251,0,255))
		:enableOutline(cc.c4b(255,0,0,255), 1)
		--:setVisible(false)
	self.m_textGetScore:setString(0)

	self.m_textTips = csbNode:getChildByName("Text_Tips"):setVisible(false)
	--self.m_textTips:setString("祝您好运！")
	------
	--菜单  
	self.m_nodeMenu = csbNode:getChildByName("Node_Menu");
	--返回
	local Button_back = self.m_nodeMenu:getChildByName("Button_back"):setVisible(false)
	Button_back:setTag(TAG_ENUM.TAG_QUIT_MENU);
	Button_back:addTouchEventListener(btnEvent);
    --帮助
	local Button_Help = self.m_nodeMenu:getChildByName("Button_Help");
	Button_Help:setTag(TAG_ENUM.TAG_HELP_MENU);
	Button_Help:addTouchEventListener(btnEvent);
    --设置
	local Button_Set = self.m_nodeMenu:getChildByName("Button_Set"):setVisible(false)
	Button_Set:setTag(TAG_ENUM.TAG_SETTING_MENU);
	Button_Set:addTouchEventListener(btnEvent);
    --隐藏
	local Button_Hide = self.m_nodeMenu:getChildByName("Button_Hide");
	Button_Hide:setTag(TAG_ENUM.TAG_HIDEUP_BTN);
	Button_Hide:addTouchEventListener(btnEvent);

	self.Node_top = csbNode:getChildByName("Node_top");

	self.Node_btnEffet = csbNode:getChildByName("Node_btnEffet")
	
	local pos =	{
		cc.p(356+157*0,505),	cc.p(356+157*0,505-146*1),		cc.p(356+157*0,506-146*2),
		cc.p(356+157*1,505),	cc.p(356+157*1,505-146*1),		cc.p(356+157*1,506-146*2),
		cc.p(356+157*2,505),	cc.p(356+157*2,505-146*1),		cc.p(356+157*2,506-146*2),
		cc.p(356+157*3,505),	cc.p(356+157*3,505-146*1),		cc.p(356+157*3,506-146*2),
		cc.p(355+157*4,505),	cc.p(355+157*4,505-146*1),		cc.p(355+157*4,506-146*2),
				}
				
    for i=1,15 do
        local posx = math.ceil(i/3)
        local posy = (i-1)%3 + 1
        local nodeStr = string.format("Node_%d_%d",posx-1,posy-1)
        local node = self._csbNode:getChildByName(nodeStr)
		--重新调整方块的位置
		node:setPosition(pos[i])
	end
end

function Game1ViewLayer:onTreasureTest() 
	local kai = self._csbNode:getChildByTag(TAG_ENUM.TAG_KAI)
	local qi = self._csbNode:getChildByTag(TAG_ENUM.TAG_QI)
	local shen = self._csbNode:getChildByTag(TAG_ENUM.TAG_SHEN)
	local mi = self._csbNode:getChildByTag(TAG_ENUM.TAG_MI)
	local bao = self._csbNode:getChildByTag(TAG_ENUM.TAG_BAO)
	local zang = self._csbNode:getChildByTag(TAG_ENUM.TAG_ZANG)
	
	local seq = cc.Sequence:create(
		cc.CallFunc:create(function()
			kai:runAction(cc.MoveBy:create(0.1,cc.p(-1200,0)))
		end),
		cc.DelayTime:create(0.2),
		cc.CallFunc:create(function()
			qi:runAction(cc.MoveBy:create(0.1,cc.p(-1200,0)))
		end),
		cc.DelayTime:create(0.2),
		cc.CallFunc:create(function()
			shen:runAction(cc.MoveBy:create(0.1,cc.p(-1200,0)))
		end),
		cc.DelayTime:create(0.2),
		cc.CallFunc:create(function()
			mi:runAction(cc.MoveBy:create(0.1,cc.p(-1200,0)))
		end),
		cc.DelayTime:create(0.2),
		cc.CallFunc:create(function()
			bao:runAction(cc.MoveBy:create(0.1,cc.p(-1200,0)))
		end),
		cc.DelayTime:create(0.2),
		cc.CallFunc:create(function()
			zang:runAction(cc.MoveBy:create(0.1,cc.p(-1200,0)))
		end))
	self._csbNode:runAction(seq)
end

function Game1ViewLayer:onTreasure()
	self.m_gameStart = true
	local kai = self._csbNode:getChildByTag(TAG_ENUM.TAG_KAI)
	local qi = self._csbNode:getChildByTag(TAG_ENUM.TAG_QI)
	local shen = self._csbNode:getChildByTag(TAG_ENUM.TAG_SHEN)
	local mi = self._csbNode:getChildByTag(TAG_ENUM.TAG_MI)
	local bao = self._csbNode:getChildByTag(TAG_ENUM.TAG_BAO)
	local zang = self._csbNode:getChildByTag(TAG_ENUM.TAG_ZANG)
--	local actionMoveBy = cc.MoveBy:create(0.5,cc.p(1200,0))
	
	local seq = cc.Sequence:create(
		cc.CallFunc:create(function()
			kai:runAction(cc.MoveBy:create(0.3,cc.p(-1200,0)))
		end),
		cc.DelayTime:create(0.2),
		cc.CallFunc:create(function()
			qi:runAction(cc.MoveBy:create(0.3,cc.p(-1200,0)))
		end),
		cc.DelayTime:create(0.2),
		cc.CallFunc:create(function()
			shen:runAction(cc.MoveBy:create(0.3,cc.p(-1200,0)))
		end),
		cc.DelayTime:create(0.2),
		cc.CallFunc:create(function()
			mi:runAction(cc.MoveBy:create(0.3,cc.p(-1200,0)))
		end),
		cc.DelayTime:create(0.2),
		cc.CallFunc:create(function()
			bao:runAction(cc.MoveBy:create(0.3,cc.p(-1200,0)))
		end),
		cc.DelayTime:create(0.2),
		cc.CallFunc:create(function()
			zang:runAction(cc.MoveBy:create(0.3,cc.p(-1200,0)))
		end))
		
	local function callFunc1()
		self.m_treasure_tip:setVisible(true)
		self.m_treasure_tip:runAction(cc.RotateTo:create(2.5,720+360))
	end
	local function callFunc2()
		self.m_treasure_tip:setVisible(false)
		self._scene:sendGame2Star(255) --游戏开始
		--ExternalFun.playBackgroudAudio("treasureBK.mp3")
		local treasure = Treasure:create()
		treasure:addTo(self)
		treasure:setTag(100000)
        treasure:setCloseCallback(function()
			self.m_gameStart = false
            if self._scene.m_bIsAuto == true then
                self:runAction(cc.Sequence:create(cc.DelayTime:create(5),cc.CallFunc:create(function ()
					self._scene:SendUserReady()
                    self._scene:sendReadyMsg()
                    self._scene.m_cbGameStatus = g_var(cmd).SHZ_GAME_SCENE_FREE
                    self._scene:setGameMode(1)
                end)))
            end
        end)
		self.m_treasure = treasure
		
		--还原
		local kai = self._csbNode:getChildByTag(TAG_ENUM.TAG_KAI)
		:setPosition(cc.p(300+1200,750/2))
		local qi = self._csbNode:getChildByTag(TAG_ENUM.TAG_QI)
		:setPosition(cc.p(300+734/5+1200,750/2))
		local shen = self._csbNode:getChildByTag(TAG_ENUM.TAG_SHEN)
		:setPosition(cc.p(300+734/5*2+1200,750/2))
		local mi = self._csbNode:getChildByTag(TAG_ENUM.TAG_MI)
		:setPosition(cc.p(300+734/5*3+1200,750/2))
		local bao = self._csbNode:getChildByTag(TAG_ENUM.TAG_BAO)
		:setPosition(cc.p(300+734/5*4+1200,750/2))
		local zang = self._csbNode:getChildByTag(TAG_ENUM.TAG_ZANG)
		:setPosition(cc.p(1334 - 300+1200,750/2))
	end
	local seq2 = cc.Sequence:create(cc.CallFunc:create(callFunc1),cc.DelayTime:create(2.5),cc.CallFunc:create(callFunc2))
	local spawn1 = cc.Spawn:create(seq2,seq)
	--self:runAction(cc.Sequence:create(spawn1,cc.DelayTime:create(30),cc.CallFunc:create(callFunc3)))
	self:runAction(spawn1)
end

function Game1ViewLayer:onFreeBlink()
	if self._scene.m_cbFreeGameMode == 6 then
		local texture = cc.Director:getInstance():getTextureCache():addImage("game1/free.png")
		self.m_free_tip:setTexture(texture)
	elseif self._scene.m_cbFreeGameMode == 7 then
		local texture = cc.Director:getInstance():getTextureCache():addImage("game1/free10.png")
		self.m_free_tip:setTexture(texture)
	elseif self._scene.m_cbFreeGameMode == 8 then
		local texture = cc.Director:getInstance():getTextureCache():addImage("game1/free15.png")
		self.m_free_tip:setTexture(texture)
	end
	ExternalFun.playSoundEffect("free.mp3")
	self.m_free_tip:setVisible(true)
	self.m_free_tip:runAction(cc.Sequence:create(cc.Blink:create(1.0,2),cc.DelayTime:create(1.0)))
	self.m_free_tip:setVisible(false)
end

function Game1ViewLayer:onFree(bIsFree)
	if bIsFree == true then
		self.m_free_tip:setVisible(false)
		if self._scene.m_freeTimes>0 then 
			self.m_free:setVisible(true)
		end
		for i = 1, 15 do
			self.m_freeNumber[i]:setVisible(false)
		end
		local temp = self._scene.m_freeTimes
		if self._scene.m_freeTimes>0 then
			self.m_freeNumber[self._scene.m_freeTimes]:setVisible(true)
		end

	elseif false == bIsFree then
		self.m_free_tip:setVisible(false)
		self.m_free:setVisible(false)
		for i = 1, 15 do
			self.m_freeNumber[i]:setVisible(false)
		end
		
	end
end

function Game1ViewLayer:FreeScoreLayer(score)
	ExternalFun.playSoundEffect("zhongjiang_coin.mp3")
	self.FreeLayer = FreeScoreLayer:create(0,score,math.floor(score / 32),self)
	self.FreeLayer:setAnchorPoint(0.5,0.5)
	self.FreeLayer:setPosition(cc.p(0,0))
	self.FreeLayer:addTo(self._csbNode)
end

--游戏1的通用动画
function Game1ViewLayer:initMainView(  )
	--打鼓
	--local daguAnim = cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("daguAnim"))
   	local nodeDagu = self.Node_top:getChildByName("Sprite_dagu"):setVisible(false)
   	--nodeDagu:runAction(cc.RepeatForever:create(daguAnim))
   	--标题
	--local titleAnim = cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("titleAnim"))
   	local nodeTitle = self.Node_top:getChildByName("Sprite_title"):setVisible(false)
   	--nodeTitle:runAction(cc.RepeatForever:create(titleAnim))
   	--飘旗
	--local piaoqiAnim1 = cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("wYaoqiAnim"))
   	local nodePiaoqi = self.Node_top:getChildByName("Sprite_piaoqi"):setVisible(false)
   	--nodePiaoqi:runAction(cc.RepeatForever:create(piaoqiAnim1))
    --飘旗2
   	--local piaoqiAnim2 = cc.Animate:create(cc.AnimationCache:getInstance():getAnimation("rYaoqiAnim"))
   	local nodePiaoqi2 = self.Node_top:getChildByName("Sprite_piaoqi2"):setVisible(false)
   	--nodePiaoqi2:runAction(cc.RepeatForever:create(piaoqiAnim2))

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
	self.m_userHead:switchGameState(self._scene.m_lCoins)
	self._csbNode:getChildByTag(TAG_ENUM.TAG_CLIPPING):setVisible(true)
--[[	local batchNode = cc.SpriteBatchNode:create("common_MoveImg1.png")
	if self._scene.m_bEnterGameFree == true then 
		self.m_question = {}
		self.m_node = {}
		for i = 10001, 10015 do
			self._csbNode:getChildByTag(i):setVisible(false)
			:setScaleX(1.0)
		end
	end--]]
	
    print("############  game1Begin  ##############")
	local startImage1 = self._csbNode:getChildByTag(TAG_ENUM.TAG_START_IMAGE1)
	local startImage2 = self._csbNode:getChildByTag(TAG_ENUM.TAG_START_IMAGE2)

	if startImage1 ~= nil then
		startImage1:removeFromParent()
	end
	if startImage2 ~= nil then
		startImage2:removeFromParent()
	end
	
	
	local pos1 = {cc.p(-157*2+1,180+10+10-400),cc.p(-157*1+1,200-400),cc.p(0+1,200-400), cc.p(157*1+1,200-400),cc.p(157*2+1,200-400)}
	local pos2 = {cc.p(0,-1820-200),cc.p(0,-1820-876-2-200),cc.p(0,-1820-876*2-200),cc.p(0,-1820-876*2-2-200),cc.p(0,-1820-876*2-10-2-200)}
	for i = 1, 5 do
		self.m_moveSprite[i]:setPosition(pos1[i])
	end
				
	self.actionTable = {}
	self.actionTimeTable = {}
	local action1 = cc.MoveBy:create(1.1 + 0.2-0.2, pos2[1])
	local action2 = cc.MoveBy:create(1.4 + 0.2-0.2, pos2[2])
	local action3 = cc.MoveBy:create(1.7 + 0.2-0.2, pos2[3])
	local action4 = cc.MoveBy:create(2.0 + 0.2-0.2, pos2[4])
	local action5 = cc.MoveBy:create(2.45 + 0.2-0.2, pos2[5])
	
	table.insert(self.actionTable,action1)
	table.insert(self.actionTable,action2)
	table.insert(self.actionTable,action3)
	table.insert(self.actionTable,action4)
	table.insert(self.actionTable,action5)
	
	table.insert(self.actionTimeTable,0.7)
	table.insert(self.actionTimeTable,1.0)
	table.insert(self.actionTimeTable,1.3)
	table.insert(self.actionTimeTable,1.6)
	table.insert(self.actionTimeTable,2.0)
				
	for i =1,5 do	--5行
		for v = 1,3 do	--3列
			local nType   = tonumber(self._scene.m_cbItemInfo[v][i])+1
			local nodeStr = string.format("Node_%d_%d",i-1,v-1)
			local node    = self._csbNode:getChildByName(nodeStr)
			local sprite1 = self.ItemIcons:setItemIcon(i,v,nType)
			sprite1:setPosition(0,430)
			if node:getChildByTag(1) == nil then
				node:addChild(sprite1,0,1)
			end
		end
	end
	
	self:setItemQuestionResult()
	
	for y =1,5 do
		local UP    = cc.Sequence:create(self.actionTable[y],
										cc.CallFunc:create(function()
											
										end))
		local Down  = cc.Sequence:create(cc.DelayTime:create(self.actionTimeTable[y]),
										 cc.CallFunc:create(function()
											for i = 1,3 do
												local sprite = self.ItemIcons:getItemIcon(y,i)
												local action1 = cc.MoveTo:create(0.2,cc.p(0,-30))
												local action2 = cc.MoveTo:create(0.1,cc.p(0,0))
												if y == 5 and i == 3 then
													sprite:runAction(cc.Sequence:create(action1,action2,
																	 cc.CallFunc:create(function()
																		if #self.questionItem > 0 then
																			self:runAction(cc.Sequence:create(cc.DelayTime:create(1),
																			cc.CallFunc:create(function()
																				for i,v in ipairs(self.questionItem) do
																					local nodeStr = string.format("Node_%d_%d",v.posx,v.posy)
																					local node = self._csbNode:getChildByName(nodeStr)
																					local item = self.ItemIcons:getItemIcon(v.posx+1,v.posy+1)
																					item:runAction(cc.Sequence:create(
																								cc.DelayTime:create(0.3),
																								cc.ScaleTo:create(0.3,0.0,1.0),
																								cc.CallFunc:create(function()
																									item:setSpriteFrame(self.ItemIcons:getItemIconSpriteFrame(self.itemType))
																								end),
																								cc.ScaleTo:create(0.3,1.0,1.0),
																								cc.CallFunc:create(function()
																										if self._scene.m_lGetCoins < self._scene.m_lTotalYafen * 5 then
																											if self.m_bIsAuto ~= true then
																												if self._scene.m_bEnterGameFree ~= true then
																													if self._scene.m_freeBlink ~= true then
																														self._scene:sendEndGame1Msg()
																													end
																												end
																											end
																										end
																										self:game1GetLineResult()  	
																								end)
																							))
																				end
																			end)))
																		else
																			if self._scene.m_lGetCoins < self._scene.m_lTotalYafen * 5 then
																				if self.m_bIsAuto ~= true then
																					if self._scene.m_bEnterGameFree ~= true then
																						if self._scene.m_freeBlink ~= true then
																							self._scene:sendEndGame1Msg()
																						end
																					end
																				end
																			end
																			self:game1GetLineResult()  											
																		end
																	 end)))
												else	
													sprite:runAction(cc.Sequence:create(action1,action2))
												end
												
											end
										end))
		local spawn = cc.Spawn:create(UP,Down)
		self.m_moveSprite[y]:runAction(spawn)
	end
			
    ExternalFun.playSoundEffect("gundong.mp3")
	
end

function Game1ViewLayer:setItemQuestionResult()
	self.questionItem = {}
	self.itemType = 0
	if self._scene.m_bEnterGameFree == true then 
		local randomNum,randomNum1 = self:getRandomNumber()
		if randomNum ~= 5  then
			if randomNum1 <= 8 then 
				for i=1, #self._scene.m_posOfquestion-1 do
					
					local data = {}
					local posx = self._scene.m_posOfquestion[i].x
					local posy = self._scene.m_posOfquestion[i].y
					local nodeStr = string.format("Node_%d_%d",posx-1,posy-1)
					self.itemType = tonumber(self._scene.m_cbItemInfo[posy][posx])+1
					data["posx"] = posx-1
					data["posy"] = posy-1
					table.insert(self.questionItem,data)
					local node = self._csbNode:getChildByName(nodeStr)
					local sprite1 = self.ItemIcons:setItemIcon(posx,posy,12)
					if node:getChildByTag(1) == nil then
						node:addChild(sprite1,0,1)
					end
				end
			elseif randomNum1 > 8 then
				for i=1, #self._scene.m_posOfquestion do
					local data = {}
					local posx = self._scene.m_posOfquestion[i].x
					local posy = self._scene.m_posOfquestion[i].y
					local nodeStr = string.format("Node_%d_%d",posx-1,posy-1)
					data["posx"] = posx-1
					data["posy"] = posy-1
					table.insert(self.questionItem,data)
					local node = self._csbNode:getChildByName(nodeStr)
					local sprite1 = self.ItemIcons:setItemIcon(posx,posy,12)
					if node:getChildByTag(1) == nil then
						node:addChild(sprite1,0,1)
					end
				end
			end
		end
	end	
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
--游戏1结果
function Game1ViewLayer:game1Result()
	self._scene:setGameMode(3) --GAME_STATE_RESULT
	local coninsStr =string.formatNumberThousands(self._scene.m_lGetCoins,true,",")
	self.m_textGetScore:setString(coninsStr)
	
--[[    for i=1,15 do
        local posx = math.ceil(i/3)
        local posy = (i-1)%3 + 1
        local nodeStr = string.format("Node_%d_%d",posx-1,posy-1)
        local node = self._csbNode:getChildByName(nodeStr)
        if node  then
        	local pItem = node:getChildByTag(1)
        	if pItem then
        		if self._scene.m_lGetCoins > 0 then
					local temp = self._scene.tagActionOneKaiJian.bZhongJiang[posy][posx]
        			if self._scene.tagActionOneKaiJian.bZhongJiang[posy][posx] == true then 
        				pItem:setState(0) --STATE_NORMAL
        				self:runAction(
        					cc.Sequence:create(
        						cc.DelayTime:create(0.5-0.5),
        						cc.CallFunc:create(function (  )
        							--显示中奖的动画
        							--pItem:setState(1) --STATE_SELECT
									--pItem:runAction(cc.Sequence:create(cc.ScaleBy:create(0.2,1.5)))
        							--对应音效-
                                    --self:Game1ZhongxianAudio(pItem.m_nType)
									--ExternalFun.playSoundEffect("zhongjiang.mp3")
        						end),
        						cc.DelayTime:create(0.2-0.2),
        						cc.CallFunc:create(function (  )
        							--if self.m_textTips then
        								--self.m_textTips:setString("恭喜中奖")
        							--end
									
									if self._scene.m_lGetCoins <= self._scene.m_lTotalYafen * 5 then
									end
        						end)
        						)
        					)
        			else
						if self._scene.m_lGetCoins > self._scene.m_lTotalYafen * 10 then
							self:stopAllActions()
							ExternalFun.playSoundEffect("win2.mp3")
							self:mageWin()
							--ExternalFun.SAFE_RELEASE(self.m_mageWinAni)
						elseif self._scene.m_lGetCoins >= self._scene.m_lTotalYafen * 5 then
							self:stopAllActions()
							ExternalFun.playSoundEffect("win1.mp3")
							self:bigWin()
							--ExternalFun.SAFE_RELEASE(self.m_bigWinAni)
						end
        				pItem:setState(2) --STATE_GREY
        			end
        		else
        			pItem:setState(0)  --STATE_NORMAL
        		end
        	end
        end
    end--]]
    --切换按钮状态
	--self._scene:enableButton(true)
	
--	self.label16:setString("时间: = "..os.date())
	

	if self._scene.m_lGetCoins > self._scene.m_lTotalYafen * 10 then
		self:stopAllActions()
		ExternalFun.playSoundEffect("win2.mp3")
		self:mageWin()
		--ExternalFun.SAFE_RELEASE(self.m_mageWinAni)
	elseif self._scene.m_lGetCoins >= self._scene.m_lTotalYafen * 5 then
		self:stopAllActions()
		ExternalFun.playSoundEffect("win1.mp3")
		self:bigWin()
		--ExternalFun.SAFE_RELEASE(self.m_bigWinAni)
	end	
	
    self:updateStartButtonState(true)
	--进入宝藏界面
	--[[if self._scene.m_bEnterGame2 == true then
		self._scene.m_cbGameStatus = g_var(cmd).SHZ_GAME_SCENE_BAOZHANG 	--设置宝藏状态
		self:onTreasure()
	end]]
	
	if self._scene.m_bEnterGameFree == true then
		self._scene.m_cbGameStatus = g_var(cmd).SHZ_GAME_SCENE_FREEGAME 	--设置免费游戏状态
		self:onFree(true)
		self._scene:sendEndGame1Msg()
	end
	--local line = 0
	local fTime = 0.0
	--[[if self.m_lGetCoins > 0 then
		line = self._scene.m_UserActionYaxian
	end --]]
	--6.3
	if self._scene.m_lGetCoins > self._scene.m_lTotalYafen * 10 then
		fTime = 4.5+3-1-0.2
	elseif self._scene.m_lGetCoins > self._scene.m_lTotalYafen * 5 then
		fTime = 7.4
	elseif self._scene.m_lGetCoins > 0 then
		fTime = 0.1
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
                                --self:game1ActionBanner(true)
                            end
    						self._scene.m_bIsItemMove = false
    						--游戏模式
    						self._scene:setGameMode(4)  --GAME_STATE_WAITTING_GAME2
    						if self._scene.m_lGetCoins > 0 then
                                if self._scene.m_bReConnect1 == true then
    						          --self:enableGame2Btn(false)
                                else
                                    --self:enableGame2Btn(true)
                                end
                            else
                                --结束游戏1消息
                                --self._scene:sendEndGame1Msg()
    						end
    						if self.m_textTips then
    							--self.m_textTips:setString("3s后自动开始游戏")
    						end
    					end),
    					cc.DelayTime:create(0),
    					cc.CallFunc:create(function (  )
    						if self.m_textTips then
    							--self.m_textTips:setString("2s后自动开始游戏")
    						end
                            if self._scene.m_bReConnect1 == true then
                                  self:enableGame2Btn(false)
                            end
    					end),
    		    		cc.DelayTime:create(0),
    					cc.CallFunc:create(function (  )
    						if self.m_textTips then
    							--self.m_textTips:setString("1s后自动开始游戏")
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
                        cc.DelayTime:create(0.0),
                        cc.CallFunc:create(function (  )
                            --if self._scene.m_bIsAuto == true then
                                self:enableGame2Btn(false)
                            --end
                        end),
    					cc.DelayTime:create(0.0),
    					cc.CallFunc:create(function()
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
                                --if self._scene.m_lGetCoins > 0 then
                                    --发送放弃比大小游戏
                                    --self._scene:sendGiveUpMsg()
                                --else
                                    --结束游戏1消息
                                    self._scene:sendEndGame1Msg()
                               -- end
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
    				cc.DelayTime:create(fTime),
    				cc.CallFunc:create(function (  )
    					self._scene.m_bIsItemMove = false
    					self._scene:setGameMode(5)
--[[						for i=1,15 do
					        local posx = math.ceil(i/3)
					        local posy = (i-1)%3 + 1
					        local nodeStr = string.format("Node_%d_%d",posx-1,posy-1)
					        local node = self._csbNode:getChildByName(nodeStr)
					        if node  then
					        	local pItem = node:getChildByTag(1)
					        	if pItem then
					        		pItem:setState(0)  --STATE_NORMAL
					        	end
					        end
					    end--]]
					    --if self._scene.m_lGetCoins > 0 then
					    	--显示游戏2按钮
					    	--self:enableGame2Btn(true)
					    	--改变提示语
					    	--if self.m_textTips then
					    		--self.m_textTips:setString("恭喜中奖！")
					    	--end
							--self._scene:sendGiveUpMsg()
							--self._scene:sendEndGame1Msg()
                        --else
                            --结束游戏1消息
                            self._scene:sendEndGame1Msg()
					    --end
                        --if self.m_textTips then
                            --self.m_textTips:setString("祝您好运！")
                        --end
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
                            --self._scene:sendGiveUpMsg()
                        end
                    end)
    				)
    			)
    	end
    end
end
--15个位置中随机抽4-7个位置
function Game1ViewLayer:getRandomPos(  )
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	local pos = {
					{["x"]=1,["y"]=1},{["x"]=2,["y"]=1},{["x"]=3,["y"]=1},{["x"]=4,["y"]=1},{["x"]=5,["y"]=1},
					{["x"]=1,["y"]=2},{["x"]=2,["y"]=2},{["x"]=3,["y"]=2},{["x"]=4,["y"]=2},{["x"]=5,["y"]=2},
					{["x"]=1,["y"]=3},{["x"]=2,["y"]=3},{["x"]=3,["y"]=3},{["x"]=4,["y"]=3},{["x"]=5,["y"]=3},
				}
	local randomPos =  {}
	local count = math.random(4,7)
	for i = 1, count do
		local number = math.random(1,#pos)
		table.insert(randomPos,pos[number])
		table.remove(pos,number)
	end
	return randomPos
end
--随机翻牌
function Game1ViewLayer:getRandomNumber(  )
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	local number = math.random(1,5)
	local number1 = math.random()
	return number, number1
end
--游戏连线结果
function Game1ViewLayer:game1GetLineResult(  )
	self.m_lineIndex = 0
	self.m_nodeAct = {}
	self.m_bNodeActRun = false
	self:addNodeAction()
	local temp = self._scene.m_lCoins
	self.m_userHead:switchGameState(self._scene.m_lCoins + self._scene.m_lGetCoins)
    --统一大厅分数
    GlobalUserItem.lUserScore=self._scene.m_lCoins + self._scene.m_lGetCoins
	print("游戏连线结果")
    self._scene:setGameMode(3)  --GAME_STATE_RESULT
	local coninsStr =string.formatNumberThousands(self._scene.m_lGetCoins,true,",")
    self.m_textGetScore:setString(coninsStr)
	--免费游戏的问号
	local action1 = cc.ScaleBy:create(0.3,0.80)
	local action2 = action1:reverse()
	local action3 = cc.Sequence:create(action1,action2)
	local scaleToHide = cc.ScaleTo:create(0.6,0.0,1.0)
	local scaleToShow = cc.ScaleTo:create(0.6,1.0,1.0)
	
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
		--每条线间隔
		local delayTime = 1.5
		local temp11 = #self._scene.m_UserActionYaxian
		local line = self._scene.m_UserActionYaxian
		for lineIndex=1,#self._scene.m_UserActionYaxian do
			self.m_bNodeActRun = false
			local pActionOneYaXian = self._scene.m_UserActionYaxian[lineIndex]
			if pActionOneYaXian then
				self:runAction(
					cc.Sequence:create(
						cc.DelayTime:create(delayTime*(lineIndex-1)),
						cc.CallFunc:create(function ()
							--音效
                            ExternalFun.playSoundEffect("zhongjiangxian.mp3")
							--如果是最后一个，进入结算界面
							if lineIndex == #self._scene.m_UserActionYaxian then
								self:runAction(
									cc.Sequence:create(
										cc.DelayTime:create(1.5),
										cc.CallFunc:create(function (  )
											self:game1Result()
										end)
										)
									)
							end
							local sprLine = display.newSprite(pathLine[pActionOneYaXian.nZhongJiangXian])
							self:removeChildByTag(lineIndex)
							self._csbNode:addChild(sprLine,0,lineIndex)
							sprLine:setPosition(667,375)
							sprLine:runAction(
								cc.Sequence:create(
									cc.DelayTime:create(0.3),
									cc.Hide:create()
									)
								)
								
							for i =1,5 do	--5行
								for v = 1,3 do	--3列
									local nodeStr = string.format("Node_%d_%d",i-1,v-1)
									local node    = self._csbNode:getChildByName(nodeStr)
									local sprite1 = self.ItemIcons:getItemIcon(i,v)
									for j=1,g_var(cmd).ITEM_X_COUNT do
										local pos = {}
										pos.x = pActionOneYaXian.ptXian[j].x
										pos.y = pActionOneYaXian.ptXian[j].y
										if pos.x == v and pos.y == i then
											isOnLine = true

											self.m_bNodeActRun = true
											local index = v + (i - 1) * 3
											self.m_nodeAct[index]:setVisible(true)
											self.m_nodeAct[index]:runAction(cc.Sequence:create(
												cc.DelayTime:create(1.5),
												cc.CallFunc:create(function (  )
													self.m_nodeAct[index]:setVisible(false)
													self.m_bNodeActRun = false
												end)
												))
											--显示得分
											--self.m_textTips:setString(string.format("得分：%d",pActionOneYaXian.lXianScore))
										end
									end
								end
							end
						end)
						)
					)
			end
            if #self._scene.m_UserActionYaxian == lineIndex then
                return
            end
		end
        self:game1Result()
	else
		self:game1Result()
	end
end

function Game1ViewLayer:onButtonClickedEvent(tag,ref)
	if tag == TAG_ENUM.TAG_QUIT_MENU then  			--退出
        self._scene.m_bIsLeave = true
        self._scene:onExitTable()
        ExternalFun.playClickEffect()
	elseif tag == TAG_ENUM.TAG_START_MENU  then    		--开始游戏
		self._scene:onGameStart()
		--self:game1ActionBanner(false)             --切换旗帜动作
        ExternalFun.playClickEffect()
		--self.m_userHead:switchGameState(self._scene.m_lCoins)
	elseif tag == TAG_ENUM.TAG_SETTING_MENU  then    --	设置
		--self:onSetLayer()
       -- ExternalFun.playClickEffect()
	elseif tag == TAG_ENUM.TAG_HELP_MENU  then    	--游戏帮助
        --self:onHelpLayer()
        ExternalFun.playClickEffect()
	elseif tag == TAG_ENUM.TAG_MAXADD_BTN  then    --	最大加注
		self._scene:onAddMaxScore()
        --声音
        ExternalFun.playSoundEffect("dianji.mp3")
	elseif tag == TAG_ENUM.TAG_MINADD_BTN  then    --	最小减注
		self._scene:onAddMinScore()
        --声音
        ExternalFun.playSoundEffect("shangfen1.mp3")
	elseif tag == TAG_ENUM.TAG_ADD_BTN  then    --	加注
		self._scene:onAddScore()
        --声音
        ExternalFun.playSoundEffect("dianji.mp3")
	elseif tag == TAG_ENUM.TAG_SUB_BTN  then    --	减注
		self._scene:onSubScore()
        --声音
        ExternalFun.playSoundEffect("dianji.mp3")
	elseif tag == TAG_ENUM.TAG_AUTO_START_BTN  then   --自动游戏
		self._scene:onAutoStart()
        ExternalFun.playClickEffect()
	elseif tag == TAG_ENUM.TAG_GAME2_BTN  then    --	开始游戏2
		self._scene:onEnterGame2()
        ExternalFun.playClickEffect()
	elseif tag == TAG_ENUM.TAG_HIDEUP_BTN  then   --隐藏上部菜单
		self:onHideTopMenu()
        ExternalFun.playClickEffect()
	elseif tag == TAG_ENUM.TAG_SHOWUP_BTN  then   --显示上部菜单
		self:onShowTopMenu()
        ExternalFun.playClickEffect()
	elseif tag == TAG_ENUM.TAG_YA_XIAN  then   --显示9线选择菜单
		self:onYaXian()
		 ExternalFun.playClickEffect()
	elseif tag == TAG_ENUM.TAG_YA_XIAN1  then   --1线
		self:onYaXianChoise(TAG_ENUM.TAG_YA_XIAN1 - TAG_ENUM.TAG_YA_XIAN)
		 ExternalFun.playClickEffect()
	elseif tag == TAG_ENUM.TAG_YA_XIAN2  then   --2线
		self:onYaXianChoise(TAG_ENUM.TAG_YA_XIAN2 - TAG_ENUM.TAG_YA_XIAN)
		 ExternalFun.playClickEffect()
	elseif tag == TAG_ENUM.TAG_YA_XIAN3  then   --3线
		self:onYaXianChoise(TAG_ENUM.TAG_YA_XIAN3 - TAG_ENUM.TAG_YA_XIAN)
		 ExternalFun.playClickEffect()
	elseif tag == TAG_ENUM.TAG_YA_XIAN4  then   --4线
		self:onYaXianChoise(TAG_ENUM.TAG_YA_XIAN4 - TAG_ENUM.TAG_YA_XIAN)
		 ExternalFun.playClickEffect()
	elseif tag == TAG_ENUM.TAG_YA_XIAN5  then   --5线
		self:onYaXianChoise(TAG_ENUM.TAG_YA_XIAN5 - TAG_ENUM.TAG_YA_XIAN)
		 ExternalFun.playClickEffect()
	elseif tag == TAG_ENUM.TAG_YA_XIAN6  then   --6线
		self:onYaXianChoise(TAG_ENUM.TAG_YA_XIAN6 - TAG_ENUM.TAG_YA_XIAN)
		 ExternalFun.playClickEffect()
	elseif tag == TAG_ENUM.TAG_YA_XIAN7  then   --7线
		self:onYaXianChoise(TAG_ENUM.TAG_YA_XIAN7 - TAG_ENUM.TAG_YA_XIAN)
		 ExternalFun.playClickEffect()
	elseif tag == TAG_ENUM.TAG_YA_XIAN8  then   --8线
		self:onYaXianChoise(TAG_ENUM.TAG_YA_XIAN8 - TAG_ENUM.TAG_YA_XIAN)
		 ExternalFun.playClickEffect()
	elseif tag == TAG_ENUM.TAG_YA_XIAN9  then   --9线
		self:onYaXianChoise(TAG_ENUM.TAG_YA_XIAN9 - TAG_ENUM.TAG_YA_XIAN)
		 ExternalFun.playClickEffect()
	elseif tag == TAG_ENUM.TAG_MASK then 
		self:removeChildByTag(TAG_ENUM.TAG_MASK)
	elseif tag == TAG_ENUM.TAG_QUIT then 	
	    self._scene:onQueryExitGame()
	elseif tag == TAG_ENUM.TAG_CHANGE_TABLE then --换桌子
		self._scene._gameFrame:QueryChangeDesk()
	elseif tag == TAG_ENUM.TAG_SOUND_ON then 
		self:onSetLayer()
	elseif tag == TAG_ENUM.TAG_SOUND_OFF then
		
	elseif tag == TAG_ENUM.TAG_HELP then	--帮助
		self:onHelpLayer()
        ExternalFun.playClickEffect()
	elseif tag == TAG_ENUM.TAG_TEMP then 
--		self:onTreasure()
	else
		showToast(self,"功能尚未开放！",1)
	end
end

--压线选择的显示
function Game1ViewLayer:onYaXianChoise(lineIndex)
	for i = 1, 9 do
		if i == lineIndex then
			self.sp_yaxian_bk:getChildByTag(TAG_ENUM.TAG_YA_XIAN + i):setSelected(true)
			self.button_yaxian:getChildByTag(TAG_ENUM.TAG_YA_XIAN + i):setVisible(true)
		else
			self.sp_yaxian_bk:getChildByTag(TAG_ENUM.TAG_YA_XIAN + i):setSelected(false)
			self.button_yaxian:getChildByTag(TAG_ENUM.TAG_YA_XIAN + i):setVisible(false)
		end
		self.m_node_nineLine:getChildByTag(TAG_ENUM.TAG_LINE1+i-1):setVisible(false)
	end
	
	
	for i = 1,lineIndex do
		self.m_node_nineLine:getChildByTag(TAG_ENUM.TAG_LINE1+i-1):setVisible(true)
	end
	
	--更新压线数量
	self._scene.m_lYaxian = lineIndex
	--更新总压分
	self._scene:updateScore(lineIndex)
end

--压线菜单的显示与隐藏
function Game1ViewLayer:onYaXian()
	local startImage2 = self._csbNode:getChildByTag(TAG_ENUM.TAG_START_IMAGE2)
	if startImage2 ~= nil then
		startImage2:removeFromParent()
	end
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
	
	--屏蔽层
	local mask = ccui.Layout:create()
	mask:setTouchEnabled(true)
	mask:setContentSize(appdf.WIDTH, appdf.HEIGHT)
	self:addChild(mask, 256)
	mask:setTag(TAG_ENUM.TAG_MASK)
	mask:addTouchEventListener(btnEvent)
	--加载9条线路
	local csbNode = ExternalFun.loadCSB("nodeLine.csb", mask)
		:setPosition(ccp(1334/2,750/2))
	local line1 =csbNode:getChildByName("firstLine")
		:setTag(TAG_ENUM.TAG_LINE1)
	local line1 =csbNode:getChildByName("secondLine")
		:setTag(TAG_ENUM.TAG_LINE2)
	local line1 =csbNode:getChildByName("thirdLine")
		:setTag(TAG_ENUM.TAG_LINE3)
	local line1 =csbNode:getChildByName("forthLine")
		:setTag(TAG_ENUM.TAG_LINE4)
	local line1 =csbNode:getChildByName("fifthLine")
		:setTag(TAG_ENUM.TAG_LINE5)
	local line1 =csbNode:getChildByName("sixLine")
		:setTag(TAG_ENUM.TAG_LINE6)
	local line1 =csbNode:getChildByName("seventhLine")
		:setTag(TAG_ENUM.TAG_LINE7)
	local line1 =csbNode:getChildByName("eighthLine")
		:setTag(TAG_ENUM.TAG_LINE8)
	local line1 =csbNode:getChildByName("ninthLine")
		:setTag(TAG_ENUM.TAG_LINE9)
	self.m_node_nineLine = csbNode
	--压线背景	
	local sp_yaxian_bk = cc.Sprite:create("botton/yaxian_bk.png")
		:setAnchorPoint(0.5,0)
		:setPosition(cc.p(1042,84/2 + 30))
		:addTo(mask)
		--:setVisible(fasle)
	local size_yaxian_bk = sp_yaxian_bk:getContentSize()
	self.sp_yaxian_bk = sp_yaxian_bk
	
	--压线按钮弹出菜单，1-9线选择
	local button_one = ccui.CheckBox:create("botton/yaxian/10.png","","botton/yaxian/11.png","","")
		:setTag(TAG_ENUM.TAG_YA_XIAN1)
		:setAnchorPoint(0.5,0)
		:setPosition(cc.p(cc.p(size_yaxian_bk.width/2-0.5,0+46*8)))
		:addTo(sp_yaxian_bk)
		:addTouchEventListener(btnEvent)
	
	--2条线
	local button_two = ccui.CheckBox:create("botton/yaxian/20.png","","botton/yaxian/21.png","","")
		:setTag(TAG_ENUM.TAG_YA_XIAN2)
		:setAnchorPoint(0.5,0)
		:setPosition(cc.p(cc.p(size_yaxian_bk.width/2-0.5,0+46*7)))
		:addTo(sp_yaxian_bk)
		:addTouchEventListener(btnEvent)
	--3条线
	local button_three = ccui.CheckBox:create("botton/yaxian/30.png","","botton/yaxian/31.png","","")
		:setTag(TAG_ENUM.TAG_YA_XIAN3)
		:setAnchorPoint(0.5,0)
		:setPosition(cc.p(cc.p(size_yaxian_bk.width/2-0.5,0+46*6)))
		:addTo(sp_yaxian_bk)
		:addTouchEventListener(btnEvent)
	--4条线
	local button_four = ccui.CheckBox:create("botton/yaxian/40.png","","botton/yaxian/41.png","","")
		:setTag(TAG_ENUM.TAG_YA_XIAN4)
		:setAnchorPoint(0.5,0)
		:setPosition(cc.p(cc.p(size_yaxian_bk.width/2-0.5,0+46*5)))
		:addTo(sp_yaxian_bk)
		:addTouchEventListener(btnEvent)
	--5条线
	local button_five = ccui.CheckBox:create("botton/yaxian/50.png","","botton/yaxian/51.png","","")
		:setTag(TAG_ENUM.TAG_YA_XIAN5)
		:setAnchorPoint(0.5,0)
		:setPosition(cc.p(cc.p(size_yaxian_bk.width/2-0.5,0+46*4)))
		:addTo(sp_yaxian_bk)
		:addTouchEventListener(btnEvent)
	--6条线
	local button_six = ccui.CheckBox:create("botton/yaxian/60.png","","botton/yaxian/61.png","","")
		:setTag(TAG_ENUM.TAG_YA_XIAN6)
		:setAnchorPoint(0.5,0)
		:setPosition(cc.p(cc.p(size_yaxian_bk.width/2-0.5,0+46*3)))
		:addTo(sp_yaxian_bk)
		:addTouchEventListener(btnEvent)
	--7条线
	local button_seven = ccui.CheckBox:create("botton/yaxian/70.png","","botton/yaxian/71.png","","")
		:setTag(TAG_ENUM.TAG_YA_XIAN7)
		:setAnchorPoint(0.5,0)
		:setPosition(cc.p(cc.p(size_yaxian_bk.width/2-0.5,0+46*2)))
		:addTo(sp_yaxian_bk)
		:addTouchEventListener(btnEvent)
	--8条线
	local button_eight = ccui.CheckBox:create("botton/yaxian/80.png","","botton/yaxian/81.png","","")
		:setTag(TAG_ENUM.TAG_YA_XIAN8)
		:setAnchorPoint(0.5,0)
		:setPosition(cc.p(cc.p(size_yaxian_bk.width/2-0.5,0+46*1)))
		:addTo(sp_yaxian_bk)
		:addTouchEventListener(btnEvent)
	--9条线
	local button_nine = ccui.CheckBox:create("botton/yaxian/90.png","","botton/yaxian/91.png","","")
		:setTag(TAG_ENUM.TAG_YA_XIAN9)
		:setAnchorPoint(0.5,0)
		:setPosition(cc.p(cc.p(size_yaxian_bk.width/2-0.5,0)))
		:addTo(sp_yaxian_bk)
		:setSelected(true)
		:addTouchEventListener(btnEvent)


	--[[if self.sp_yaxian_bk_status == false then
		self.sp_yaxian_bk_status = true
		self.sp_yaxian_bk:setVisible(true)
	else
		self.sp_yaxian_bk_status = false
		self.sp_yaxian_bk:setVisible(false)
	end--]]
end
--隐藏上部菜单
function Game1ViewLayer:onHideTopMenu()
    if self.m_nodeMenu:getPositionX() == -667 then
        return
    end
	local actMove = cc.MoveTo:create(0.5,cc.p(-667,703.5))
	local Sequence = cc.Sequence:create(
		actMove,
		cc.CallFunc:create(function (  )
			local Button_Show = self._csbNode:getChildByName("Button_Show")
			if Button_Show then
				Button_Show:setVisible(true)
			end
		end)
		)
	self.m_nodeMenu:runAction(Sequence)
end

--显示上部菜单
function Game1ViewLayer:onShowTopMenu()
    if self.m_nodeMenu:getPositionX() == 667 then
        return
    end
	local actMove = cc.MoveTo:create(0.5,cc.p(667,703.5))
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
	local set = SettingLayer:create(verstr)
    self._csbNode:addChild(set)
    set:setLocalZOrder(9)
    set:setCloseCallback(function()
        local btn = self._top_bk_right:getChildByName("button_sound_on")
		:setEnabled(true)
    end)
    local btn = self._top_bk_right:getChildByName("button_sound_on")
		:setEnabled(false)
end

function Game1ViewLayer:onHelpLayer( )
    self:onHideTopMenu()
    local help = HelpLayer:create()
    self._csbNode:addChild(help)
    help:setLocalZOrder(2000000000)
    help:setCloseCallback(function()
        local btn = self._top_bk_right:getChildByName("button_help")
		:setEnabled(true)
    end)
    local btn = self._top_bk_right:getChildByName("button_help")
    :setEnabled(false)
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
	if self.Node_btnEffet then
		--self.Node_btnEffet:setVisible(isEnable)		
	end
	--local Button_Game2 = self._csbNode:getChildByName("Button_Game2");
	--Button_Game2:setEnabled(isEnable)
end

--切换开始按钮和停止按钮的纹理
function Game1ViewLayer:updateStartButtonState( bIsStart)
    local Button_Start = self._csbNode:getChildByName("Button_Start");
    if bIsStart == true then
        Button_Start:loadTextureNormal("game1/game1_start_1.png")
        Button_Start:loadTexturePressed("game1/game1_start_2.png")
    else
        Button_Start:loadTextureNormal("game1/game1_stop_1.png")
        Button_Start:loadTexturePressed("game1/game1_stop_2.png")
    end
end

function Game1ViewLayer:game1ActionBanner( bIsWait )
	local qizhi1 = self.Node_top:getChildByName("Sprite_piaoqi")
	qizhi1:setVisible(bIsWait)
	local qizhi2 = self.Node_top:getChildByName("Sprite_piaoqi2")
	qizhi2:setVisible(not bIsWait)
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
   -- ExternalFun.playSoundEffect(soundPath[bIndex])
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
    --local bHide = ((table.nums(self.m_tabUserHead)) == (self:getParentNode():getFrame():GetChairCount()))
--[[    if not GlobalUserItem.bPrivateRoom then
        self.m_btnInvite:setVisible(not bHide)
        self.m_btnInvite:setEnabled(not bHide)
    end    
    self.m_btnInvite:setVisible(false)
    self.m_btnInvite:setEnabled(false)--]]

    if nil == userItem then
        return
    end
    --self.m_tabUserItem[viewId] = userItem

    --local bReady = userItem.cbUserStatus == yl.US_READY
    --self:onUserReady(viewId, bReady)

   --[[ if nil == self.m_tabUserHead[viewId] then
        local roleItem = GameRoleItem:create(userItem, viewId)
        roleItem:setPosition(self.m_tabUserHeadPos[viewId])
        self.m_tabUserHead[viewId] = roleItem
        self.m_userinfoControl:addChild(roleItem)
    else
        self.m_tabUserHead[viewId].m_userItem = userItem
        self.m_tabUserHead[viewId]:updateStatus()
    end

    if cmd.MY_VIEWID == viewId then
        self:reSetUserInfo()
    end--]]
	if nil == self.m_userHead then
		local roleItem = GameRoleItem:create(userItem, viewId)
			:setPosition(cc.p(110,550))
			:addTo(self)
		self.m_userHead = roleItem
	else
		self.m_userHead.m_userItem = userItem
        self.m_userHead:updateStatus()
	end
end

function GameViewLayer:updateTime()
	local CurrentDateTime = os.date("*t",os.time())
	local min = CurrentDateTime.min
	self.m_time:setString( string.format("%02d", min ))
end

--请求公告
function Game1ViewLayer:requestNotice()
	local url = yl.HTTP_URL .. "/WS/MobileInterface.ashx?action=GetMobileRollNotice"         	
	appdf.onHttpJsionTable(url ,"GET","",function(jstable,jsdata)
		if type(jstable) == "table" then
			local data = jstable["data"]
			local msg = jstable["msg"]
			if type(data) == "table" then
				local valid = data["valid"]
				if nil ~= valid and true == valid then
					local list = data["notice"]
					if type(list)  == "table" then
						local listSize = #list
						self.m_nNoticeCount = listSize
						for i = 1, listSize do
							local item = {}
							item.str = list[i].content or ""
							--item.id = self:getNoticeId()
							item.id = 1
							item.color = cc.c4b(255,191,123,255)
							item.autoremove = false
							item.showcount = 0
							table.insert(self.m_tabSystemNotice, item)
						end
						self:onChangeNotify(self.m_tabSystemNotice[self._sysIndex])
					end
				end
			end
			if type(msg) == "string" and "" ~= msg then
				showToast(self, msg, 3)
			end
		end
	end)
end

function Game1ViewLayer:onChangeNotify(msg)
	self._notifyText:stopAllActions()
	if not msg or not msg.str or #msg.str == 0 then
		self._notifyText:setString("")
		self.m_bNotifyRunning = false
		self._tipIndex = 1
		self._sysIndex = 1
		return
	end
	self.m_bNotifyRunning = true
	local msgcolor = msg.color or cc.c4b(255,191,123,255)
	self._notifyText:setVisible(false)
	self._notifyText:setString(msg.str)
	self._notifyText:setTextColor(msgcolor)

	if true == msg.autoremove then
		msg.showcount = msg.showcount or 0
		msg.showcount = msg.showcount - 1
		if msg.showcount <= 0 then
			self:removeNoticeById(msg.id)
		end
	end
	
	local tmpWidth = self._notifyText:getContentSize().width
	self._notifyText:runAction(
			cc.Sequence:create(
				cc.CallFunc:create(	function()
					self._notifyText:move(yl.WIDTH-500,0)
					self._notifyText:setVisible(true)
				end),
				cc.MoveTo:create(16 + (tmpWidth / 172),cc.p(0-tmpWidth,0)),
				cc.CallFunc:create(	function()
					local tipsSize = 0
					local tips = {}
					local index = 1
					if 0 ~= #self.m_tabInfoTips then
						-- 喇叭等
						local tmp = self._tipIndex + 1
						if tmp > #self.m_tabInfoTips then
							tmp = 1
						end
						self._tipIndex = tmp
						self:onChangeNotify(self.m_tabInfoTips[self._tipIndex])
					else
						-- 系统公告
						local tmp = self._sysIndex + 1
						if tmp > #self.m_tabSystemNotice then
							tmp = 1
						end
						self._sysIndex = tmp
						self:onChangeNotify(self.m_tabSystemNotice[self._sysIndex])
					end				
				end)
			)
	)
end

return GameViewLayer