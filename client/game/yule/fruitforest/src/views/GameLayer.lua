
local GameModel = appdf.req(appdf.CLIENT_SRC.."gamemodel.GameModel")
local GameLayer = class("GameLayer", GameModel)

--local Game2Layer = class("Game2Layer", GameModel)

local module_pre = "game.yule.fruitforest.src"
require("cocos.init")
local ExternalFun =  appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local cmd = module_pre .. ".models.CMD_Game"

local GameViewLayer = appdf.req(module_pre .. ".views.layer.GameViewLayer")
local g_var = ExternalFun.req_var
local GameLogic = appdf.req(module_pre .. ".models.GameLogic")
local QueryDialog = appdf.req("base.src.app.views.layer.other.QueryDialog")
--local GameFrame = appdf.req(module_pre .. ".models.GameFrame")
local Treasure = appdf.req(module_pre .. ".views.layer.FruitTreasure")

local emGameState =
{
"GAME_STATE_WAITTING",              --等待
"GAME_STATE_WAITTING_RESPONSE",     --等待服务器响应
"GAME_STATE_MOVING",                --转动
"GAME_STATE_RESULT",                --结算
"GAME_STATE_WAITTING_GAME2",        --等待游戏2
"GAME_STATE_END"                    --结束
}
local GAME_STATE = ExternalFun.declarEnumWithTable(0, emGameState)

local emGame2State =
{
"GAME2_STATE_WAITTING",
"GAME2_STATE_WAVING",
"GAME2_STATE_WAITTING_CHOICE",
"GAME2_STATE_OPEN",
"GAME2_STATE_RESULT"
}
local GAME2_STATE = ExternalFun.declarEnumWithTable(0, emGame2State)

function GameLayer:ctor( frameEngine,scene )
	
	ExternalFun.registerNodeEvent(self)
	
--	self.m_bLeaveGame = false
	
	GameLayer.super.ctor(self,frameEngine,scene)
	
	--self._gameFrame:QueryUserInfo( self:GetMeUserItem().wTableID,yl.INVALID_CHAIR)
	
	self.score = 0
	
	self:addAnimationEvent()  --监听加载完动画的事件
--[[0 zhengchang 
	1 mianfei 
	2 baozang
	3 mianfei10 
	4 mianfei15--]]
	self.Mianfei=2
end

function GameLayer:getFrame( )
	return self._gameFrame
end

--创建场景
function GameLayer:CreateView()
	self._gameView = GameViewLayer[1]:create(self)
	self:addChild(self._gameView,0,2001)
	return self._gameView
end

function GameLayer:OnInitGameEngine()
	GameLayer.super.OnInitGameEngine(self)
	
	self.m_bIsLeave             = false     --是否离开游戏
	self.m_bIsPlayed            = false     --是否玩过游戏
	self.m_cbGameStatus         = 0         --游戏状态
	self.m_cbGameMode           = 0         --游戏模式
	
	--游戏逻辑操作
	self.m_bIsItemMove          = false     --动画是否滚动的标示
	self.m_lCoins               = 0         --游戏币
	self.m_lYaxian              = GameLogic.YAXIANNUM         --压线
	self.m_lYafen               = 0         --压分
	self.m_lTotalYafen          = 0         --总压分
	self.m_lGetCoins            = 0         --获得金钱
	
	self.m_bEnterGameFree       = false		--是否免费游戏
--	self.m_bEnterGame3          = false     --是否小玛丽
	--self.m_bEnterGame2        = true       --是否比倍
	self.m_bEnterGame2          = false     --是否宝藏
	self.m_bYafenIndex          = 1         --压分索引（数组索引）
	self.m_lBetScore            = {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0}}        --压分存储数组
	self.m_cbItemInfo           = {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0}}          --开奖信息
	self.m_freeTimes			=0
	
	--中奖位置
	self.m_ptZhongJiang = {}
	for i=1,GameLogic.ITEM_COUNT do
		self.m_ptZhongJiang[i] = {}
		for j=1,GameLogic.ITEM_X_COUNT do
			self.m_ptZhongJiang[i][j] = {}
			self.m_ptZhongJiang[i][j].x = 0
			self.m_ptZhongJiang[i][j].y = 0
		end
	end
	
	self.m_UserActionYaxian     = {}           --用户压线的情况
	
	
	self.m_bIsAuto                 = false        --控制自动开始按钮
	--self.m_bYafenIndexNow        = 0         	  --发送服务器时的压分索引
	self.m_bIsAuto                 = false        --控制自动开始按钮
	self.m_bReConnect1             = false
	self.m_bReConnect2             = false
	self.m_bReConnect3             = false
	
	self.tagActionOneKaiJian = {}
	self.tagActionOneKaiJian.nCurIndex = 0
	self.tagActionOneKaiJian.nMaxIndex = 9
	self.tagActionOneKaiJian.lScore = 0
	self.tagActionOneKaiJian.lQuanPanScore = 0
	self.tagActionOneKaiJian.cbGameMode = 0
	self.tagActionOneKaiJian.bZhongJiang = {}
	for i=1, GameLogic.ITEM_Y_COUNT do
		self.tagActionOneKaiJian.bZhongJiang[i] = {}
		for j=1,GameLogic.ITEM_X_COUNT do
			self.tagActionOneKaiJian.bZhongJiang[i][j] = false
		end
	end
	
	--游戏2结果
	self.m_pGame2Result = {}
	self.m_pGame2Result.cbOpenSize = {0,0}
	self.m_pGame2Result.lScore = 0
end

function GameLayer:ResetAction( )
	self.tagActionOneKaiJian.nCurIndex = 0
	self.tagActionOneKaiJian.nMaxIndex = 9
	self.tagActionOneKaiJian.lScore = 0
	self.tagActionOneKaiJian.lQuanPanScore = 0
	self.tagActionOneKaiJian.cbGameMode = 0
	self.tagActionOneKaiJian.bZhongJiang = {}
	for i=1, GameLogic.ITEM_Y_COUNT do
		self.tagActionOneKaiJian.bZhongJiang[i] = {}
		for j=1,GameLogic.ITEM_X_COUNT do
			self.tagActionOneKaiJian.bZhongJiang[i][j] = false
		end
	end
end

function GameLayer:resetData()
	--GameLayer.super.resetData(self)
	
	self.m_cbGameStatus         = 0         --游戏状态
	
	self.m_cbGameMode           = 0         --游戏模式
	
	--游戏逻辑操作
	self.m_bIsItemMove          = false     --动画是否滚动的标示
	self.m_lCoins               = 0         --游戏币
	self.m_lYaxian              = GameLogic.YAXIANNUM         --压线
	self.m_lYafen               = self.m_lBetScore[self.m_bYafenIndex]        --压分
	self.m_lTotalYafen          = self.m_lBetScore[self.m_bYafenIndex]*self.m_lYafen*self.m_lYaxian         --总压分
	self.m_lGetCoins            = 0         --获得金钱
	
	self.m_bEnterGameFree		= false		--是否免费游戏
	self.m_bEnterGame3          = false     --是否小玛丽
	self.m_bEnterGame2          = false     --是否宝藏
	self.m_bYafenIndex          = 1         --压分索引（数组索引）
	self.m_lBetScore            = {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0}}         --压分存储数组
	self.m_cbItemInfo           = {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0}}         --开奖信息
	--self.m_ptZhongJiang         = {{},{},{}}
	--中奖位置
	self.m_ptZhongJiang = {}
	for i=1,11 do
		self.m_ptZhongJiang[i] = {}
		for j=1,5 do
			self.m_ptZhongJiang[i][j] = {}
			self.m_ptZhongJiang[i][j].x = 0
			self.m_ptZhongJiang[i][j].y = 0
		end
	end
	
	self.m_bIsAuto                 = false        --控制自动开始按钮
	self.m_bReConnect1             = false
	self.m_bReConnect2             = false
	self.m_bReConnect3             = false
	--游戏2结果
	self.m_pGame2Result = {}
	self.m_pGame2Result.cbOpenSize = {0,0}
	self.m_pGame2Result.lScore = 0
end

-- 重置游戏数据
function GameLayer:OnResetGameEngine()
	
	local useritem = self:GetMeUserItem()
	if (self.m_bIsAuto == true  and useritem.cbUserStatus == yl.US_PLAYING and self.m_cbGameStatus == 101) or (self.m_cbGameStatus == 102 and self.m_bEnterGame2 == false) then--g_var(cmd).SHZ_GAME_SCENE_FREE
		print("游戏1断线重连")
		self.m_bReConnect1 = true
	elseif self.m_cbGameStatus == 102 and self.m_bEnterGame2 == true then --g_var(cmd).g_var(cmd).SHZ_GAME_SCENE_TWO
		print("游戏2断线重连")
		self.m_bReConnect2 = true
		local gameview = self._gameView
		if gameview then
			gameview:setPosition(0,0)
			gameview:setVisible(true)
		end
		if self._game2View then
			self._game2View:removeFromParent()
			self._game2View = nil
		end
		
		self.m_bIsAuto = false
		self._gameView:setAutoStart(false)
		self._gameView.m_textTips:setString("祝您好运！")
		self:setGameMode(0)
	elseif self.m_cbGameStatus == 103  then--g_var(cmd).g_var(cmd).SHZ_GAME_SCENE_THREE
		print("游戏3断线重连")
		self.m_bReConnect3 = true
	end
	
end

function GameLayer:addAnimationEvent()
	--通知监听
	local function eventListener(event)
		cc.Director:getInstance():getEventDispatcher():removeCustomEventListeners(g_var(cmd).Event_LoadingFinish)
		
		--self._gameView:initMainView()
		print("移除监听事件")
		if self._gameView then
			self._gameView:initMainView()
			self:SendUserReady()
		end
	end
	
	local listener = cc.EventListenerCustom:create(g_var(cmd).Event_LoadingFinish, eventListener)
	cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(listener, 1)
end
--------------------------------------------------------------------------------------
function GameLayer:onExit()
	print("gameLayer onExit()...................................")
	self:KillGameClock()
	self:dismissPopWait()
end

--退出桌子
function GameLayer:onExitTable()
	if self.m_querydialog then
		return
	end
	self:KillGameClock()
	self:showPopWait()
	local MeItem = self:GetMeUserItem()
	if MeItem and MeItem.cbUserStatus > yl.US_FREE then
		self:runAction(cc.Sequence:create(
		cc.DelayTime:create(2),
		cc.CallFunc:create(
		function ()
			self._gameFrame:StandUp(1)
		end
		),
		cc.DelayTime:create(10),
		cc.CallFunc:create(
		function ()
			--强制离开游戏(针对长时间收不到服务器消息的情况)
			print("delay leave")
			self:onExitRoom()
		end
		)
		)
		)
		return
	end
	self:onExitRoom()
end

--离开房间
function GameLayer:onExitRoom()
	self:getFrame():onCloseSocket()
	self._scene:onKeyBack()
end
--系统消息
function GameLayer:onSystemMessage( wType,szString )
	if wType == 515 then  --515 当玩家没钱时候
		self.m_querydialog = QueryDialog:create(szString, function ()
			
			self:KillGameClock()
			local MeItem = self:GetMeUserItem()
			if MeItem and MeItem.cbUserStatus > yl.US_FREE then
				self:showPopWait()
				self:runAction(cc.Sequence:create(
				cc.CallFunc:create(
				function ()
					self._gameFrame:StandUp(1)
				end
				),
				cc.DelayTime:create(10),
				cc.CallFunc:create(
				function ()
					print("delay leave")
					self:onExitRoom()
				end
				)
				)
				)
				return
			end
			self:onExitRoom()
			
			end,nil,1)
			self.m_querydialog:setCanTouchOutside(false)
			self.m_querydialog:addTo(self)
		end
	end
	
-- -------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------场景消息
	
-- -- 场景信息
function GameLayer:onEventGameScene(cbGameStatus,dataBuffer)
	print("场景数据:" .. cbGameStatus)
	--self._gameView:removeAction()
	self:KillGameClock()
	--游戏状态
	self._gameView.m_cbGameStatus = cbGameStatus;
	
	if cbGameStatus == g_var(cmd).SHZ_GAME_SCENE_FREE	then      --压住状态
		self:onEventGameSceneFree(dataBuffer);
	elseif cbGameStatus == g_var(cmd).SHZ_GAME_SCENE_WIAT 	then  --等待开始
		self:onEventGameSceneFree(dataBuffer);
	elseif cbGameStatus == g_var(cmd).SHZ_GAME_SCENE_TWO	then
		self:onEventGame2SceneStatus(dataBuffer);
	end
	self:dismissPopWait()
end
			
function GameLayer:onEventGameSceneFree(buffer)    --空闲
	
	local cmd_table = ExternalFun.read_netdata(g_var(cmd).SHZ_CMD_S_StatusFree, buffer)
	
	self.m_bEnterGameFree = false
	
	self.m_cbFreeGameMode = cmd_table.cbGameMode
	
	---------------------------------------------初始化数据-------------------------------------------
	
	--免费游戏次数
	self.m_freeTimes = cmd_table.cbFreeTimes  
	
	--下注数量
	self.m_bMaxNum = cmd_table.cbBetCount 
--	self.m_bYafenIndex = self.m_bMaxNum
	
	-- 基础下分
	self.m_lYafen  = cmd_table.lCellScore 
	
	--获得金钱
	self.m_lGetCoins = cmd_table.lOneGameScore 
	
	--下注大小
	self.m_lBetScore = GameLogic:copyTab(cmd_table.lBetScore[1])
	
	--用户金币数量
	self.m_lCoins = self:GetMeUserItem().lScore 
	
	--用户压线数量
	self.m_lYaxian = cmd_table.cbYaXian
	
	self.m_cbItemInfo = {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0}}
	self.m_cbItemInfo = GameLogic:copyTab(cmd_table.cbItemInfo)
	
	for i=1,9 do
		self.m_ptZhongJiang[i] = {}
		for j=1,5 do
			self.m_ptZhongJiang[i][j] = {}
			self.m_ptZhongJiang[i][j].x = 0xff
			self.m_ptZhongJiang[i][j].y = 0xff
		end
	end
	
	print("-----------------------------------------------------------------------")
	print("免费次数:",self.m_freeTimes)
	print("下注数量:",self.m_bMaxNum)
	print("基础压分:",self.m_lYafen)
	print("获得金钱:",self.m_lGetCoins)
	print("用户金币数量:",self.m_lCoins)
	print("用户压线数量:",self.m_lYaxian)
	dump(self.m_lBetScore,"用户下注大小")
	print("-----------------------------------------------------------------------")
	
	if self.m_freeTimes >0 or self.m_cbFreeGameMode>=g_var(cmd).GM_FREE  then 
		self.m_bEnterGameFree = true
		self._gameView.m_gameStart = true
		self.m_bReConnect1 = true
		
		--检验是否中奖
		GameLogic:GetAllZhongJiangInfo(self.m_cbItemInfo, self.m_ptZhongJiang, self.m_lYaxian)
		--改变状态
		self.m_cbGameStatus = g_var(cmd).SHZ_GAME_SCENE_ONE
		if self.m_lGetCoins > 0 then
			--清空数组
			self.m_UserActionYaxian = {}
			--获取中奖信息，压线和中奖结果
			-- for i=1,GameLogic.ITEM_COUNT do
			for i=1,9 do
				if i<=self.m_lYaxian then
					if GameLogic:getZhongJiangInfo(i,self.m_cbItemInfo,self.m_ptZhongJiang) ~= 0 then
						local pActionOneYaXian = {}
						pActionOneYaXian.nZhongJiangXian = i
						pActionOneYaXian.lXianScore = GameLogic:GetZhongJiangTime(i,self.m_cbItemInfo)*self.m_lYafen*self.m_lBetScore[self.m_bYafenIndex]
						pActionOneYaXian.lScore = self.m_lGetCoins
						pActionOneYaXian.ptXian = self.m_ptZhongJiang[pActionOneYaXian.nZhongJiangXian]
						self.m_UserActionYaxian[#self.m_UserActionYaxian+1] = pActionOneYaXian
					end
				end
			end
			self:ResetAction()
			self.tagActionOneKaiJian.nCurIndex = 0
			self.tagActionOneKaiJian.nMaxIndex = 9
			self.tagActionOneKaiJian.cbGameMode = cmd_table.cbGameMode
			self.tagActionOneKaiJian.lQuanPanScore = cmd_table.lScore
			self.tagActionOneKaiJian.lScore = cmd_table.lScore
			if GameLogic:GetQuanPanJiangTime(self.m_cbItemInfo) ~= 0 then
				for i=1,GameLogic.ITEM_Y_COUNT do
					for j=1,GameLogic.ITEM_X_COUNT do
						self.tagActionOneKaiJian.bZhongJiang[i][j] = true
					end
				end
			else
				for i=1,9 do
					for j=1,GameLogic.ITEM_X_COUNT do
						if self.m_ptZhongJiang[i][j].x ~= 0xff then
							self.tagActionOneKaiJian.bZhongJiang[self.m_ptZhongJiang[i][j].x][self.m_ptZhongJiang[i][j].y] = true
						end
					end
				end
			end
		end
		
		self._gameView:onFree(true)
		
		self._gameView:onPlayBounceAction(tonumber(self.m_freeTimes))

		self.m_bIsItemMove = true
		
		--开始游戏
		self._gameView:game1Begin()
		
		--切换旗帜动作
--		self._gameView:game1ActionBanner(false)
		if self.m_bIsAuto == true then
			self._gameView:updateStartButtonState(true)
		else
			self._gameView:updateStartButtonState(false)
		end
		
	else
		self.m_bIsItemMove = false
		self.m_bEnterGameFree = false
		self._gameView.m_gameStart = false
	end
	
	
	--总压分
--	self.m_lTotalYafen = self.m_lBetScore[self.m_bYafenIndex]*self.m_lYafen*self.m_lYaxian
	
	self.m_lTotalYafen = cmd_table.lScore
	
	self._YaFen1  = cmd_table.lScore /  self.m_lYaxian
	
	for i,v in ipairs(self.m_lBetScore) do
		if v == tonumber(self._YaFen1)  then
			self.m_bYafenIndex = i
		end
	end
	
--[[	local coninsStr =string.formatNumberThousands(tostring(self.m_lTotalYafen),true,",")
	local coninsStr1 =string.formatNumberThousands(self.m_lBetScore[self.m_bYafenIndex]*self.m_lYafen,true,",")--]]
	
	local coninsStr =string.formatNumberThousands(tostring(self.m_lTotalYafen),true,",")
	local coninsStr1 =string.formatNumberThousands(self._YaFen1,true,",")
	
	self._gameView.m_textAllyafen:setString(coninsStr)
	self._gameView.m_textYafen:setString(coninsStr1)
end

function GameLayer:onEventGameSceneStatus(buffer)
	--local cmd_table = ExternalFun.read_netdata(g_var(cmd).CMD_S_StatusPlay, buffer)
	print("···游戏1 ====================== >")
	
end

function GameLayer:onEventGame2SceneStatus(buffer)
	local cmd_table = ExternalFun.read_netdata(g_var(cmd).SHZ_CMD_S_StatusTwo, buffer)
	print("···宝藏 ====================== >")
--	dump(cmd_table,"cmd_table")
	if cmd_table.bIsAuto == 0 then
		self.m_bIsAuto = false
	elseif cmd_table.bIsAuto == 1 then
		self.m_bIsAuto = true
	end
	self.m_bMaxNum    = cmd_table.cbBetCount
	self.m_lYafen     = cmd_table.lCellScore
	self.m_yafen      = cmd_table.lScore
	
	self.m_lBetScore  = GameLogic:copyTab(cmd_table.lbetScore1[1])
	self._gameView.m_textAllyafen:setString(cmd_table.lScore)
	
	self.m_lScore     = cmd_table.lScore / cmd_table.cbYaXian		--总压线分数，单注*压线数量		--总压线分数，单注*压线数量
	self._gameView.m_textYafen:setString(self.m_lScore)
	self.m_lTotalYafen = cmd_table.lScore
	self.m_lBeiShu     = cmd_table.lBeiShu
	--self.cbTwoGameCount=cmd_table.cbTwoGameCount
	--	self._gameView.m_treasure.m_BoxCount:setString(cmd_table.cbTwoGameCount)
	local treasureClick = cmd_table.cbClickIndex[1]
	self.cbBombInfo = {}
	for i = 1, 4 do
		self.cbBombInfo[i] = {}
	end
	for i = 1, #cmd_table.cbItemInfo[1] do
		local row = math.floor((i - 1) / 7) + 1
		table.insert(self.cbBombInfo[row],cmd_table.cbItemInfo[1][i])
	end

	local userItem = self._gameFrame:getTableUserItem(self._gameFrame:GetTableID(), 0)
	self.m_lCoins = userItem.lScore
	self._gameView:OnUpdateUser(1,userItem,false)
--	self:changeUserScore(-self.m_lYafen);
	local treasure = Treasure:create(treasureClick,self.m_lScore, self.m_lBeiShu)
	treasure:addTo(self._gameView)
	treasure:setTag(100000)
	self._gameView.m_treasure = treasure
	self._gameView.m_treasure.m_BoxCount:setString(cmd_table.cbTwoGameCount)
	--self._gameView.m_treasure:updataScore(self.m_lScore/cmd_table.cbYaXian, self.m_lBeiShu, self.m_lScore * self.m_lBeiShu)
end

-----------------------------------------------------------------------------------
-- 游戏消息
function GameLayer:onEventGameMessage(sub,dataBuffer)
	print("unknow gamemessage sub is "..sub)
	
	 if sub == g_var(cmd).SUB_S_USER_CONTROL then        --获取控制信息
		self:onGetControlInfo(dataBuffer)
    elseif sub == g_var(cmd).SUB_S_USER_UPDATECURST_OK then --修改控制成功
		self:onModifyControlInfo(true)
    elseif sub == g_var(cmd).SUB_S_USER_UPDATECURST then    --修改控制失败
		self:onModifyControlInfo(false)
	elseif sub == g_var(cmd).SUB_S_GAME_START then
		--print("watermargin 游戏开始")
		self:onGame1Start(dataBuffer)                       --游戏开始
	elseif sub == g_var(cmd).SUB_S_GAME_CONCLUDE then
		--print("watermargin 压线结束")
		self:onSubGame1End(dataBuffer)                      --压线结束
	elseif sub == g_var(cmd).SUB_S_TWO_START then
		--print("watermargin 宝藏开始")
		self:onGame2Start(dataBuffer)                       --宝藏开始
	elseif sub == g_var(cmd).SUB_S_GAMETWO_INFO then
		self:onGame2Info(dataBuffer)						--得到点击宝箱结果
	elseif sub == g_var(cmd).SUB_S_TWO_GAME_CONCLUDE then
		--print("watermargin 比倍结束")
		--self:onSubSendCard(dataBuffer)
	elseif sub == g_var(cmd).SUB_S_THREE_START then         --小玛丽开始
		--print("watermargin 小玛丽开始")
		self:onGame3Start(dataBuffer)
	elseif sub == g_var(cmd).SUB_S_THREE_KAI_JIANG then     --小玛丽开奖
		--print("watermargin 小玛丽开奖")
		self:onGame3Result(dataBuffer)
	elseif sub == g_var(cmd).SUB_S_THREE_END then
		--print("watermargin 小玛丽结束")
		--self:onSubGetWinner(dataBuffer)
	elseif sub == g_var(cmd).SUB_Game_SCENE_FREE_END then
		self:FreeScore(dataBuffer)

	else
		print("unknow gamemessage sub is "..sub)
	end
end
	
--游戏开始
function GameLayer:onGame1Start(dataBuffer) --游戏开始
	
	print("服务端返回:-------游戏开始------")
	local cmd_table = ExternalFun.read_netdata(g_var(cmd).SHZ_CMD_S_GameStart, dataBuffer)
	
	--获得金钱
	self.m_lGetCoins = cmd_table.lScore 
	
	if self.m_yafen==0 and cmd_table.lBetScore<0 then
		self._gameView:OnPlayBackMusic(1)
	end
	
	--下注大小
	self.m_yafen = cmd_table.lBetScore
	
	--使开始按钮处于不可用状态
	self:enableButton(false)
	
	self._gameView.m_gameStart = true
	
	--进入免费游戏
	if self.m_freeTimes == 0 and cmd_table.cbBounsGameCount > 0 then
		self.m_freeBlink = true
	else
		self.m_freeBlink = false
	end
	
	self.m_freeTimes = cmd_table.cbBounsGameCount  --免费游戏次数
	
--[[	if self.m_yafen >0 and self.m_freeTimes>0 then
		self.m_bEnterGameFree = true
		if self.m_freeBlink == false then
			self._gameView:onFree(true)
		end
	elseif self.m_yafen ==0 and self.m_freeTimes==0 then
		self.m_bEnterGameFree = false
		self._gameView:onFree(false)
	end--]]
	
	
	--进入小玛丽
--[[	if g_var(cmd).GM_THREE == cmd_table.cbGameMode then
		self.m_bEnterGame3 = true
	else
		self.m_bEnterGame3 = false
	end--]]
	
	--进入宝藏
	if g_var(cmd).GM_TWO == cmd_table.cbGameMode then
		self.m_bEnterGame2 = true
	else
		self.m_bEnterGame2 = false
	end
	
	self._gameView.GameModle = cmd_table.cbGameMode
	
	self.m_cbItemInfo = {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0}}
	self.m_cbItemInfo = GameLogic:copyTab(cmd_table.cbItemInfo)
	
	self.m_lBetScore = GameLogic:copyTab(cmd_table.lBetScoreDeye[1])
	
	for i=1,9 do
		self.m_ptZhongJiang[i] = {}
		for j=1,5 do
			self.m_ptZhongJiang[i][j] = {}
			self.m_ptZhongJiang[i][j].x = 0xff
			self.m_ptZhongJiang[i][j].y = 0xff
		end
	end
	
	--检验是否中奖
	GameLogic:GetAllZhongJiangInfo(self.m_cbItemInfo, self.m_ptZhongJiang, self.m_lYaxian)
	
	--改变状态
	self.m_cbGameStatus = g_var(cmd).SHZ_GAME_SCENE_ONE
	
	if self.m_lGetCoins > 0 then
		--清空数组
		self.m_UserActionYaxian = {}
		--获取中奖信息，压线和中奖结果
		-- for i=1,GameLogic.ITEM_COUNT do
		for i=1,9 do
			if i<=self.m_lYaxian then
				if GameLogic:getZhongJiangInfo(i,self.m_cbItemInfo,self.m_ptZhongJiang) ~= 0 then
					print("i=..........."..i)
					local pActionOneYaXian = {}
					pActionOneYaXian.nZhongJiangXian = i
					pActionOneYaXian.lXianScore = GameLogic:GetZhongJiangTime(i,self.m_cbItemInfo)*self.m_lYafen*self.m_lBetScore[self.m_bYafenIndex]
					pActionOneYaXian.lScore = self.m_lGetCoins
					pActionOneYaXian.ptXian = self.m_ptZhongJiang[pActionOneYaXian.nZhongJiangXian]
					self.m_UserActionYaxian[#self.m_UserActionYaxian+1] = pActionOneYaXian
				end
			end
		end
		self:ResetAction()
		self.tagActionOneKaiJian.nCurIndex = 0
		self.tagActionOneKaiJian.nMaxIndex = 9
		self.tagActionOneKaiJian.cbGameMode = cmd_table.cbGameMode
		self.tagActionOneKaiJian.lQuanPanScore = cmd_table.lScore
		self.tagActionOneKaiJian.lScore = cmd_table.lScore
		if GameLogic:GetQuanPanJiangTime(self.m_cbItemInfo) ~= 0 then
			for i=1,GameLogic.ITEM_Y_COUNT do
				for j=1,GameLogic.ITEM_X_COUNT do
					self.tagActionOneKaiJian.bZhongJiang[i][j] = true
				end
			end
		else
			for i=1,9 do
				for j=1,GameLogic.ITEM_X_COUNT do
					if self.m_ptZhongJiang[i][j].x ~= 0xff then
						self.tagActionOneKaiJian.bZhongJiang[self.m_ptZhongJiang[i][j].x][self.m_ptZhongJiang[i][j].y] = true
					end
				end
			end
		end
	end
	
	self.m_bIsItemMove = true
	--开始游戏
	self._gameView:game1Begin()
	
	--切换旗帜动作
	--	self._gameView:game1ActionBanner(false)
	
	if self.m_bIsAuto == ture then
		self._gameView:updateStartButtonState(true)
	else
		self._gameView:updateStartButtonState(false)
	end
end

function GameLayer:onSubGame1End( dataBuffer )
	print("服务端返回: -------游戏1结束------")
	local cmd_table = ExternalFun.read_netdata(g_var(cmd).CMD_S_Gameconclude, dataBuffer)

	if self.m_yafen >0 and self.m_freeTimes>0 then
		self.m_bEnterGameFree = true
		if self.m_freeBlink then
			self._gameView:onFree(true)
		end
	elseif self.m_yafen ==0 and self.m_freeTimes==0 then
		self.m_bEnterGameFree = false
		self._gameView:onFree(false)
	end
	
	self._gameView.m_gameStart = false
	
	if self.m_bEnterGameFree == true or self.m_bIsAuto == true then
		self:enableButton(false)
	else
		self:enableButton(true)
	end
		
		
	print("----------------------------------------------------")
	print("self.m_lTotalYafen = ",self.m_lTotalYafen)
	print("self.m_lCoins = ",self.m_lCoins)
	print("self.m_lGetCoins = ",self.m_lGetCoins)
	print("服务端返回金币 = ",cmd_table.lUserScore)
	print("----------------------------------------------------")
	self.m_lCoins = cmd_table.lUserScore
	local coninsStr =string.formatNumberThousands(self.m_lCoins,true,",")
	self._gameView.m_textScore:setString(coninsStr)
	if self.m_lTotalYafen > self.m_lCoins then
			--提示游戏币不足
			if self.m_bEnterGameFree == true and self.m_freeTimes ~= 0 then
				local useritem = self:GetMeUserItem()
				if useritem.cbUserStatus ~= yl.US_READY then --self.m_bIsPlayed == true and
					self:runAction(cc.Sequence:create(cc.DelayTime:create(6),cc.CallFunc:create(
					function ()
						self:SendUserReady()
						self:sendReadyMsg()
						self.m_cbGameStatus = g_var(cmd).SHZ_GAME_SCENE_FREE
						self:setGameMode(1)
					end)))
				end
			elseif self.m_bEnterGame2 == true then
				--进入宝藏界面
				self._scene.m_cbGameStatus = g_var(cmd).SHZ_GAME_SCENE_BAOZHANG 	--设置宝藏状态
				self._gameView:onTreasure()
			else
				showToast(self, "提醒：游戏币不足", 1)
				self.m_bIsAuto = false
				self._gameView:setAutoStart(false)
			end
		else
			if self.m_bIsAuto == true and self.m_bEnterGame2 ~= true then
				if self.m_bEnterGameFree == true then
					self._gameView:stopAllActions()
					local useritem = self:GetMeUserItem()
					if  self.m_freeBlink == true  then
						self._gameView:onPlayBounceAction(tonumber(self.m_freeTimes))
					end
					if useritem.cbUserStatus ~= yl.US_READY then --self.m_bIsPlayed == true and
						self:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create(
						function ()
							self:SendUserReady()
							self:sendReadyMsg()
							self.m_cbGameStatus = g_var(cmd).SHZ_GAME_SCENE_FREE
							self:setGameMode(1)
						end)))
					end
					return
				else 
					self._gameView:stopAllActions()
					local useritem = self:GetMeUserItem()
					if useritem.cbUserStatus ~= yl.US_READY then --self.m_bIsPlayed == true and
						self:runAction(cc.Sequence:create(cc.DelayTime:create(3),cc.CallFunc:create(
						function ()
							self:SendUserReady()
							self:sendReadyMsg()
							self.m_cbGameStatus = g_var(cmd).SHZ_GAME_SCENE_FREE
							self:setGameMode(1)
						end)))
					end
					return
				end
			
				if  (self:getGameMode() == GAME_STATE.GAME_STATE_END) then--and (self:getGameMode() == GAME_STATE.GAME_STATE_WAITTING_GAME2  or (self:getGameMode() == GAME_STATE.GAME_STATE_WAITTING) or (self:getGameMode() == GAME_STATE.GAME_STATE_END))  then
					self._gameView:stopAllActions()
					local useritem = self:GetMeUserItem()
					if useritem.cbUserStatus ~= yl.US_READY then --self.m_bIsPlayed == true and
						self:SendUserReady()
					end
					--发送准备消息
					self:sendReadyMsg()
					self.m_cbGameStatus = g_var(cmd).SHZ_GAME_SCENE_FREE
					self:setGameMode(1)
				end
			elseif self.m_bIsAuto == false and self.m_freeBlink == true  then
				self._gameView:onPlayBounceAction(tonumber(self.m_freeTimes))
				local useritem = self:GetMeUserItem()
				if useritem.cbUserStatus ~= yl.US_READY then --self.m_bIsPlayed == true and
					self:runAction(cc.Sequence:create(cc.DelayTime:create(6),cc.CallFunc:create(
					function ()
						self:SendUserReady()
						self:sendReadyMsg()
						self.m_cbGameStatus = g_var(cmd).SHZ_GAME_SCENE_FREE
						self:setGameMode(1)
					end)))
				end
			elseif self.m_bEnterGameFree == true and self.m_freeTimes ~= 0 then
				local useritem = self:GetMeUserItem()
				if useritem.cbUserStatus ~= yl.US_READY then --self.m_bIsPlayed == true and
					self:runAction(cc.Sequence:create(cc.DelayTime:create(6),cc.CallFunc:create(
					function ()
						self:SendUserReady()
						self:sendReadyMsg()
						self.m_cbGameStatus = g_var(cmd).SHZ_GAME_SCENE_FREE
						self:setGameMode(1)
					end)))
				end
			elseif self.m_bEnterGame2 == true then
				--进入宝藏界面
				self._scene.m_cbGameStatus = g_var(cmd).SHZ_GAME_SCENE_BAOZHANG 	--设置宝藏状态
				self._gameView:onTreasure()
			end
		end
end

function GameLayer:setGameMode( state )
	if state == 0 then
		self.m_cbGameMode = GAME_STATE.GAME_STATE_WAITTING  --等待
	elseif state == 1 then
		self.m_cbGameMode = GAME_STATE.GAME_STATE_WAITTING_RESPONSE --等待服务器响应
	elseif state == 2 then
		self.m_cbGameMode = GAME_STATE.GAME_STATE_MOVING --转动
	elseif state == 3 then
		self.m_cbGameMode = GAME_STATE.GAME_STATE_RESULT --结算
	elseif state == 4 then
		self.m_cbGameMode = GAME_STATE.GAME_STATE_WAITTING_GAME2 --等待游戏2
	elseif state == 5 then
		self.m_cbGameMode = GAME_STATE.GAME_STATE_END  --结束
	else
		print("未知状态")
	end
	-- self.m_cbGameMode = GAME_STATE[state]
end
--游戏2
function GameLayer:setGame2Mode( state )
	if state == 0 then
		self.m_cbGameMode = GAME2_STATE.GAME2_STATE_WAITTING  --等待
	elseif state == 1 then
		self.m_cbGameMode = GAME2_STATE.GAME2_STATE_WAVING --摇奖
	elseif state == 2 then
		self.m_cbGameMode = GAME2_STATE.GAME2_STATE_WAITTING_CHOICE --等待下注
	elseif state == 3 then
		self.m_cbGameMode = GAME2_STATE.GAME2_STATE_OPEN --结算
	elseif state == 4 then
		self.m_cbGameMode = GAME2_STATE.GAME2_STATE_RESULT --等待游戏2
	else
		print("未知状态")
	end
	-- self.m_cbGameMode = GAME_STATE[state]
end

--获取游戏状态
function GameLayer:getGameMode()
	if self.m_cbGameMode then
		return self.m_cbGameMode
	end
end

--游戏开始
function GameLayer:onGameStart()
	self._gameView:OnHideLine()
	local useritem = self:GetMeUserItem()
	--self._gameView:onHideTopMenu()
	--自动开始
	if self.m_bIsAuto == true then
		if self:getGameMode() == GAME_STATE.GAME_STATE_MOVING then
			self._gameView:game1End()
			--return
			--elseif self.m_bIsItemMove == false and (self:getGameMode() == GAME_STATE.GAME_STATE_WAITTING_GAME2  or (self:getGameMode() == GAME_STATE.GAME_STATE_WAITTING) or (self:getGameMode() == GAME_STATE.GAME_STATE_END)) then
		elseif self:getGameMode() == GAME_STATE.GAME_STATE_WAITTING_GAME2  then
			print("客户端开始:-----游戏开始")
			self.m_bIsPlayed = true
			self._gameView:stopAllActions()
			--游戏2按钮不可用
			self._gameView:enableGame2Btn(false)
			--发送消息
			self:sendGiveUpMsg()
			
			self._gameView.m_textTips:setString("祝您好运！")
			
			if self.m_lTotalYafen > self.m_lCoins then
				--提示游戏币不足
				showToast(self, "提醒：游戏币不足", 1)
				return
			end
			self:SendUserReady()
			--发送准备消息
			self:sendReadyMsg()
			--减去押注
			--self._gameView.m_textScore:setString(self:GetMeUserItem().lScore-self.m_lTotalYafen)
			self.m_cbGameStatus = g_var(cmd).SHZ_GAME_SCENE_FREE
			self:setGameMode(1)
			--return
		else
			--return
		end
	end
	--开始
	local temp = self:getGameMode()
	if self:getGameMode() == GAME_STATE.GAME_STATE_MOVING then
		self._gameView:game1End()
		--elseif  self.m_bIsItemMove == false and  (self:getGameMode() == GAME_STATE.GAME_STATE_WAITTING_GAME2) or (self:getGameMode() == GAME_STATE.GAME_STATE_WAITTING) or (self:getGameMode() == GAME_STATE.GAME_STATE_END) then
	elseif  (self:getGameMode() == GAME_STATE.GAME_STATE_WAITTING) or (self:getGameMode() == GAME_STATE.GAME_STATE_END) then
		--发送放弃到比大小的消息
		--[[	if self.m_lGetCoins > 0 then --or (self:getGameMode() == GAME_STATE.GAME_STATE_END) then
		self:sendGiveUpMsg()
	end--]]
	
	if self.m_lTotalYafen > self.m_lCoins then
		--提示游戏币不足
		showToast(self, "提醒：游戏币不足", 1)
		return
	end
	self.m_bIsPlayed = true
	self._gameView:stopAllActions()
	
	--游戏2按钮不可用
	self._gameView:enableGame2Btn(false)
	
	self:SendUserReady()
	--发送准备消息
	self:sendReadyMsg()
	self.m_cbGameStatus = g_var(cmd).SHZ_GAME_SCENE_FREE
	self:setGameMode(1)
end
end

--自动游戏
function GameLayer:onAutoStart( )
	--self._gameView:onHideTopMenu()
	self._gameView:OnHideLine()
	--判断金钱是否够自动开始
	if self.m_bIsAuto == true then
		self.m_bIsAuto = false
        self:stopAllActions()
		self._gameView:setAutoStart(false)
	else
		self.m_bIsAuto = true
		if self.m_lTotalYafen > self.m_lCoins then
			--提示游戏币不足
			showToast(self, "提醒：游戏币不足", 1)
			self.m_bIsAuto = false
			self._gameView:setAutoStart(false)
			return
		end
		self._gameView:setAutoStart(true)
		
		if  self.m_bIsItemMove == false  then--and (self:getGameMode() == GAME_STATE.GAME_STATE_WAITTING_GAME2  or (self:getGameMode() == GAME_STATE.GAME_STATE_WAITTING) or (self:getGameMode() == GAME_STATE.GAME_STATE_END))  then
			self._gameView:stopAllActions()
			
			if self.m_lGetCoins > 0 then
				self:sendGiveUpMsg()
			end
			self.m_bIsPlayed = true
			self._gameView:enableGame2Btn(false)
			local useritem = self:GetMeUserItem()
			if useritem.cbUserStatus ~= yl.US_READY then
				self:SendUserReady()
			end
			--发送准备消息
			self:sendReadyMsg()
			self.m_cbGameStatus = g_var(cmd).SHZ_GAME_SCENE_FREE
			self:setGameMode(1) --"GAME_STATE_WAITTING_RESPONSE",     --等待服务器响应
		end
	end
end

--最大加注
--[[function GameLayer:onAddMaxScore()
	
	self._gameView:onHideTopMenu()
	
	self.m_bYafenIndex = self.m_bMaxNum
	self.m_lTotalYafen = self.m_lBetScore[self.m_bYafenIndex]*self.m_lYafen*self.m_lYaxian
	--压分
	self._gameView.m_textYafen:setString(self.m_lBetScore[self.m_bYafenIndex])
	--总压分
	self._gameView.m_textAllyafen:setString(self.m_lTotalYafen)
	
end--]]

--最小加注
--[[function GameLayer:onAddMinScore( )
	self._gameView:onHideTopMenu()
	self.m_bYafenIndex = 1
	self.m_lTotalYafen = self.m_lBetScore[self.m_bYafenIndex]*self.m_lYafen*self.m_lYaxian
	--压分
	self._gameView.m_textYafen:setString(self.m_lBetScore[self.m_bYafenIndex])
	--总压分
	self._gameView.m_textAllyafen:setString(self.m_lTotalYafen)
	
end--]]

--加注
function GameLayer:onAddScore()
	self._gameView:onHideTopMenu()
	if self.m_bYafenIndex < self.m_bMaxNum then
		self.m_bYafenIndex = self.m_bYafenIndex + 1
	else
		self.m_bYafenIndex = 1
	end
	self.m_lTotalYafen = self.m_lBetScore[self.m_bYafenIndex]*self.m_lYafen*self.m_lYaxian
	
	
	local coninsStr =string.formatNumberThousands(tostring(self.m_lBetScore[self.m_bYafenIndex]),true,",")
	local coninsStr1 =string.formatNumberThousands(self.m_lTotalYafen,true,",")
	--压分
	self._gameView.m_textYafen:setString(coninsStr)
	--总压分
	self._gameView.m_textAllyafen:setString(coninsStr1)
end

--减注
--[[function GameLayer:onSubScore()
	self._gameView:onHideTopMenu()
	if self.m_bYafenIndex > 1  then
		self.m_bYafenIndex = self.m_bYafenIndex - 1
	else
		self.m_bYafenIndex = 1
	end
	self.m_lTotalYafen = self.m_lBetScore[self.m_bYafenIndex]*self.m_lYafen*self.m_lYaxian
	
	--压分
	self._gameView.m_textYafen:setString(self.m_lBetScore[self.m_bYafenIndex])
	--总压分
	self._gameView.m_textAllyafen:setString(self.m_lTotalYafen)
end--]]

--根据压线数量更新总压分
function GameLayer:updateScore(lineCount)
	self.m_lTotalYafen = self.m_lBetScore[self.m_bYafenIndex] * lineCount
	self._gameView.m_textAllyafen:setString(self.m_lTotalYafen)
end

function GameLayer:FreeScore(dataBuffer)
	local cmd_table = ExternalFun.read_netdata(g_var(cmd).SUB_CMD_S_FreeGameEnd, dataBuffer)
	self.score     = cmd_table.lFreeGameScore
--	self._gameView:FreeScoreLayer(tonumber(score))
end

--发送准备消息
function GameLayer:sendReadyMsg()
	print("客户端：----------发送准备消息成功")
	
	if self._gameView.GameModle == g_var(cmd).GM_TWO then
		return
	end
	
	self._gameView.m_textGetScore:setString(0)
	self._gameView.m_textGetScore:setVisible(false)
	
	self._gameView.m_textTips:setString("祝您好运!")
	self._gameView.m_textTips:setVisible(true)
	
	
	local  dataBuffer= CCmd_Data:create(10)
	dataBuffer:pushbyte(self.m_lYaxian)--压线数量
	dataBuffer:pushscore(self.m_bYafenIndex-1)
	dataBuffer:pushbyte(self.Mianfei)--1免费模式，0 正常模式,2宝藏，
	self.Mianfei=0
	
	--[[	if self.temp == false or self.temp == nil then
		dataBuffer:pushbyte(1)--1免费模式，0 正常模式
		self.temp = true
	else
		dataBuffer:pushbyte(0)--1免费模式，0 正常模式
	end--]]
	
	print("发送压线信息——————————————————————")
	self:SendData(g_var(cmd).SHZ_SUB_C_ONE_START, dataBuffer)
	
	if self.m_lGetCoins and self.m_lGetCoins > 0 then
		ExternalFun.playSoundEffect("defen.wav")
--		self.m_lCoins = self.m_lCoins + self.m_lGetCoins
		if  self.m_bEnterGameFree == true then
			self._gameView.m_textGetScore:setString(self.m_lGetCoins)
		else
			self.m_lGetCoins = 0
			self:changeUserScore(-self.m_lTotalYafen)
			self._gameView.m_textGetScore:setString(self.m_lGetCoins)
		end
	else
		if self.m_bEnterGameFree == false then
			self:changeUserScore(-self.m_lTotalYafen)
		end
		self._gameView.m_textGetScore:setString(self.m_lGetCoins)
	end
	
end
--发送放弃比倍消息
function GameLayer:sendGiveUpMsg( )
	print("放弃比倍消息")
	--发送数据
	local  dataBuffer= CCmd_Data:create(1)
	--dataBuffer:pushscore(0)
	self:SendData(g_var(cmd).SHZ_SUB_C_TWO_GIVEUP, dataBuffer)
end
--发送放弃游戏一消息
function GameLayer:sendEndGame1Msg()
	print("客户端：----------------------------发送结束游戏1消息")
	--发送数据
	local  dataBuffer= CCmd_Data:create(1)
	--dataBuffer:pushscore(0)
	self:SendData(g_var(cmd).SHZ_SUB_C_ONE_END, dataBuffer)
end

--进入摇骰子
function GameLayer:onEnterGame2()
	if self.m_cbGameStatus == g_var(cmd).SHZ_GAME_SCENE_TWO then
		self._gameView:stopAllActions()
		
		self._gameView:enableGame2Btn(false)
		
		self._game2View = GameViewLayer[2]:create(self)
		self:addChild(self._game2View)
		
		self._gameView:setPosition(-1334,0)
	end
end
--进入小玛丽
function GameLayer:onEnterGame3( )
	if self.m_cbGameStatus == g_var(cmd).SHZ_GAME_SCENE_THREE then
		--self.m_lCoins = self:GetMeUserItem().lScore
		self._gameView:stopAllActions()
		
		self._gameView:enableGame2Btn(false)
		
		self._game3View = GameViewLayer[3]:create(self)
		self:addChild(self._game3View)
		
		self._gameView:setPosition(-1334,0)
	end
end

--刷新服务器分数
function GameLayer:refreshScore()
	local useritem = self:GetMeUserItem()
	local coninsStr =string.formatNumberThousands(useritem.lScore,true,",")
	self._gameView.m_textScore:setString(coninsStr)
	--self._gameView.m_userHead:switchGameState(useritem.lScore)
	self.m_lCoins = self:GetMeUserItem().lScore
end

function GameLayer:changeUserScore( changeScore )
	print("--------------------------------------------------------------")
	print("changeScore = ",changeScore)
	print("self.m_lCoins1 = ",self.m_lCoins)
	print("--------------------------------------------------------------")
	self.m_lCoins = self.m_lCoins + changeScore
	print("--------------------------------------------------------------")
	print("self.m_lCoins2 = ",self.m_lCoins)
	print("--------------------------------------------------------------")
	local coninsStr =string.formatNumberThousands(self.m_lCoins,true,",")
	self._gameView.m_textScore:setString(coninsStr)
end


--[[function GameLayer:onEventGame3SceneStatus(buffer)
	local cmd_table = ExternalFun.read_netdata(g_var(cmd).SHZ_CMD_S_StatusFreeGame, buffer)
	print("···免费 ====================== >")
	self.m_bEnterGameFree = true
	
	local cbItemInfo = cmd_table.cbItemInfo
	--如果是免费游戏，则计算问号的位置
	if self.m_bEnterGameFree == true then
		self.m_posOfquestion = self:analysisItemInfo(cbItemInfo)	--免费游戏问号显示的位置
	end
	
	--中奖的分数
	self.m_lGetCoins = cmd_table.lOneGameScore 
	
	--self.m_freeTimes = cmd_table.cbBounsGameCount  --免费游戏次数
	--self.m_yafen = cmd_table.lBetScore
	
	--使开始按钮处于不可用状态
	self:enableButton(false)
	
	self._gameView.m_gameStart = true
	
	self.m_cbFreeGameMode = cmd_table.cbGameMode
	
	self.m_freeTimes = cmd_table.cbFreeTimes  --免费游戏次数
	self.m_lCoins = self:GetMeUserItem().lScore
	self.m_cbItemInfo = {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0}}
	self.m_cbItemInfo = GameLogic:copyTab(cmd_table.cbItemInfo)
	--self.m_lBetScore = GameLogic:copyTab(cmd_table.lBetScore[1])

		
	self.m_lYaxian = cmd_table.cbYaXian
	
	for i=1,9 do
		self.m_ptZhongJiang[i] = {}
		for j=1,5 do
			self.m_ptZhongJiang[i][j] = {}
			self.m_ptZhongJiang[i][j].x = 0xff
			self.m_ptZhongJiang[i][j].y = 0xff
		end
	end
	--检验是否中奖
	GameLogic:GetAllZhongJiangInfo(self.m_cbItemInfo, self.m_ptZhongJiang, self.m_lYaxian)
	--改变状态
	self.m_cbGameStatus = g_var(cmd).SHZ_GAME_SCENE_ONE
	if self.m_lGetCoins > 0 then
		--清空数组
		self.m_UserActionYaxian = {}
		--获取中奖信息，压线和中奖结果
		-- for i=1,GameLogic.ITEM_COUNT do
		for i=1,9 do
			if i<=self.m_lYaxian then
				if GameLogic:getZhongJiangInfo(i,self.m_cbItemInfo,self.m_ptZhongJiang) ~= 0 then
					local pActionOneYaXian = {}
					pActionOneYaXian.nZhongJiangXian = i
					pActionOneYaXian.lXianScore = GameLogic:GetZhongJiangTime(i,self.m_cbItemInfo)*self.m_lYafen*self.m_lBetScore[self.m_bYafenIndex]
					pActionOneYaXian.lScore = self.m_lGetCoins
					pActionOneYaXian.ptXian = self.m_ptZhongJiang[pActionOneYaXian.nZhongJiangXian]
					self.m_UserActionYaxian[#self.m_UserActionYaxian+1] = pActionOneYaXian
				end
			end
		end
		self:ResetAction()
		self.tagActionOneKaiJian.nCurIndex = 0
		self.tagActionOneKaiJian.nMaxIndex = 9
		self.tagActionOneKaiJian.cbGameMode = cmd_table.cbGameMode
		self.tagActionOneKaiJian.lQuanPanScore = cmd_table.lScore
		self.tagActionOneKaiJian.lScore = cmd_table.lScore
		if GameLogic:GetQuanPanJiangTime(self.m_cbItemInfo) ~= 0 then
			for i=1,GameLogic.ITEM_Y_COUNT do
				for j=1,GameLogic.ITEM_X_COUNT do
					self.tagActionOneKaiJian.bZhongJiang[i][j] = true
				end
			end
		else
			for i=1,9 do
				for j=1,GameLogic.ITEM_X_COUNT do
					if self.m_ptZhongJiang[i][j].x ~= 0xff then
						self.tagActionOneKaiJian.bZhongJiang[self.m_ptZhongJiang[i][j].x][self.m_ptZhongJiang[i][j].y] = true
					end
				end
			end
		end
	end
	self.m_bIsItemMove = true
	--开始游戏
	self._gameView:game1Begin()
	
	--切换旗帜动作
	self._gameView:game1ActionBanner(false)
	if self.m_bIsAuto == true then
		self._gameView:updateStartButtonState(true)
	else
		self._gameView:updateStartButtonState(false)
	end
	
end--]]

----------------------------------------------------------
--                      游戏 宝藏						--
----------------------------------------------------------
--发送255代表游戏开始
function GameLayer:sendGame2Star( index )
	--发送数据
	local  dataBuffer = CCmd_Data:create(1)
	dataBuffer:pushbyte(index)
	local temp = g_var(cmd).SHZ_SUB_C_TWO_START
	self:SendData(g_var(cmd).SHZ_SUB_C_TWO_START, dataBuffer)
	--print("游戏2准备消息")
	if index == 255 then
		self.m_bEnterGame2 = false
		self:SendUserReady()
		self:sendReadyMsg()
	end
end

--宝藏开始服务器返回
function GameLayer:onGame2Start(dataBuffer)
	local cmd_table = ExternalFun.read_netdata(g_var(cmd).SHZ_CMD_S_GameTwoStart, dataBuffer)
	
	self.lScore = cmd_table.lScore		--总压线分数，单注*压线数量
	self.cbBombInfo = {}
	for i = 1, 4 do
		self.cbBombInfo[i] = {}
	end
	for i = 1, #cmd_table.cbItemInfo[1] do
		local row = math.floor((i - 1) / 7) + 1
		table.insert(self.cbBombInfo[row],cmd_table.cbItemInfo[1][i])
	end
	self._gameView.m_treasure:updataScore(self.lScore, 0, 0)
end
--点击宝箱服务器返回
function GameLayer:onGame2Info(dataBuffer)
	local cmd_table = ExternalFun.read_netdata(g_var(cmd).CMD_S_GameTwoInfo, dataBuffer)
	local boxIndex = cmd_table.cbBoxIndex
	self.m_nYaLienCount = cmd_table.nYaLienCount
	self.m_lYaZhubScore = cmd_table.lYaZhubScore
	self._gameView.m_treasure.m_BoxCount:setString(cmd_table.cbTwoGameCount)
	
	--local bomb = self._gameView.m_treasure:isBomb(boxIndex)
	
	
	if cmd_table.cbBomb == 1 then
		self._gameView.GameModle = g_var(cmd).GM_ONE
		self._gameView.m_treasure._GameTWoEnd = true
		self:changeUserScore(cmd_table.lYaZhubScore)
		--self:onGame2end()
	end
	
	
	self._gameView.m_treasure:game2OpenBox(boxIndex, 5, false)
	self.m_cbBomb = cmd_table.cbBomb
	--self._gameView.m_treasure:updataScore(self.lScore, cmd_table.nYaLienCount, cmd_table.lYaZhubScore)
	--if cmd_table.cbBomb == 1 then
	--	self:onGame2end()
	--end
end
--宝藏游戏结束
function GameLayer:onGame2end()
	print("宝藏游戏结束")
	local function win()
		self._gameView.m_treasure:onTreasureEnd()
	end
	local function gameover()
		self._gameView:removeChildByTag(100000)
	end
	local action1 = cc.DelayTime:create(5)
	local action2 = cc.CallFunc:create(win)
	local action3 = cc.CallFunc:create(gameover)
	self:runAction(cc.Sequence:create(action2,action1,action3))
end
--初始化游戏2数据
function GameLayer:game2DataInit()
	self:setGame2Mode(0)
	self.m_lBaseYafen = self.m_lGetCoins
	self.m_lGetCoins2 = 0
	self.m_lAllGetCoin2 = 0
	self.m_bEnterGame2 = true
end

--半比
function GameLayer:onHalfIn(  )
	if self.m_cbGameMode ~= GAME2_STATE.GAME2_STATE_WAITTING then
		return
	end
	--发送消息
	self:sendReadyMsg2(0)
	self._game2View:initDiceView()
	--压分
	self.m_lYafen2 = self.m_lBaseYafen/2
	--设置压分label的数值
	self._game2View.m_textYafen:setString(self.m_lYafen2)
	--设置用户分数
	self.m_lCoins = self.m_lCoins + self.m_lYafen2
	self._game2View.m_textScore:setString(self.m_lCoins)
	--不能点击按钮
	self._game2View:enableButton(false)
end

--全比
function GameLayer:onAllIn( )
	if self.m_cbGameMode ~= GAME2_STATE.GAME2_STATE_WAITTING then
		return
	end
	--发送消息
	self:sendReadyMsg2(1)
	self._game2View:initDiceView()
	--压分
	self.m_lYafen2 = self.m_lBaseYafen
	--设置压分label的数值
	self._game2View.m_textYafen:setString(self.m_lYafen2)
	--不能点击按钮
	self._game2View:enableButton(false)
end
--倍比
function GameLayer:onDoubleIn( )
	if self.m_cbGameMode ~= GAME2_STATE.GAME2_STATE_WAITTING then
		return
	end
	if self.m_lBaseYafen > self.m_lCoins then
		showToast(self, "提醒：游戏币不足，请选择其他倍率", 1)
	else
		--发送消息
		self:sendReadyMsg2(2)
		self._game2View:initDiceView()
		--压分
		self.m_lYafen2 = self.m_lBaseYafen*2
		--设置压分label的数值
		self._game2View.m_textYafen:setString(self.m_lYafen2)
		--设置用户分数
		self.m_lCoins = self.m_lCoins - self.m_lBaseYafen
		self._game2View.m_textScore:setString(self.m_lCoins)
		--不能点击按钮
		self._game2View:enableButton(false)
	end
end
--游戏2发送准备模式消息
function GameLayer:sendReadyMsg2( openMode )
	--发送数据
	local  dataBuffer = CCmd_Data:create(1)
	dataBuffer:pushbyte(openMode)
	self:SendData(g_var(cmd).SHZ_SUB_C_TWO_MODE, dataBuffer)
	--print("游戏2准备消息")
end
--押注
function GameLayer:onYaZhu( cbtype )
	--不能再点击
	self._game2View:enableDickButton(false)
	local useritem = self:GetMeUserItem()
	if self:getGameMode() ~= GAME2_STATE.GAME2_STATE_WAITTING_CHOICE then
		return
	end
	self:setGame2Mode(3) --GAME2_STATE_OPEN
	--放置元宝
	self._game2View:setYuanBaoPostion(cbtype)  --1 是小 2是和 3 是大
	--发送开奖消息
	self:sendKaiJiangMsg(cbtype-1)
end

--游戏2发送准备模式消息
function GameLayer:sendKaiJiangMsg( openArea )
	print("发送开奖消息")
	--发送数据
	local  dataBuffer = CCmd_Data:create(1)
	dataBuffer:pushbyte(openArea)
	self:SendData(g_var(cmd).SHZ_SUB_C_TWO_START, dataBuffer)
end
--取分
function GameLayer:onExitGame2()
	if self:getGameMode() ~= GAME2_STATE.GAME2_STATE_RESULT then
		return
	end
	self:sendGiveUpMsg()
	
	self.m_lCoins = self.m_lCoins + self.m_lAllGetCoin2
	self.m_lGetCoins2 = 0
	self._game2View.m_textScore:setString(self.m_lCoins)
	--self._gameView.m_textScore:setString(self.m_lCoins)
	self._gameView.m_userHead:switchGameState(self.m_lCoins)
	self._game2View:backOneGame()
	
	-- if self.m_bIsAuto == true then
	--     self:onGameStart()
	--     self:game1ActionBanner(false) --切换旗帜动作
	-- end
end

--继续
function GameLayer:onGoon()
	if self:getGameMode() ~= GAME2_STATE.GAME2_STATE_RESULT then
		return
	end
	self._game2View:initDiceView()
	
	--得分
	self.m_lCoins = self.m_lCoins - self.m_lYafen2
	--self._game2View.m_textScore:setString(self.m_lCoins)
end
----------------------------------------------------------------
--                      游戏3 小玛丽
----------------------------------------------------------------

function GameLayer:game3DataInit(  )
	--self.m_lCoins = self:GetMeUserItem().lScore
	self.m_lYafen3 = self.m_lTotalYafen
	self.m_lGetCoins3 = 0
	self.m_pGame3Info = {}
	self.m_pGame3Result = {}
	--self.m_lRunTime = 0
end

function GameLayer:onGame3Start( dataBuffer )
	print("小玛丽开始")
	local cmd_table = ExternalFun.read_netdata(g_var(cmd).SHZ_CMD_S_GameThreeStart, dataBuffer)
	--dump(cmd_table)
	local pGame3Info = GameLogic:copyTab(cmd_table)
	
	self.m_pGame3Info[#self.m_pGame3Info+1] = pGame3Info
	self.m_lGetCoins3 =  self.m_lGetCoins3 + pGame3Info.lScore
	
	--如果元素个数等于小玛丽次数，则开始
	if cmd_table.cbBounsGameCount == 0 then
		self._game3View:game3Begin()
	end
end

function GameLayer:onGame3Result( dataBuffer )
	print("小玛丽结算")
	local cmd_table = ExternalFun.read_netdata(g_var(cmd).SHZ_CMD_S_GameThreeKaiJiang, dataBuffer)
	--dump(cmd_table)
	local pGame3Result = GameLogic:copyTab(cmd_table)
	self.m_lGetCoins3 = self.m_lGetCoins3 + pGame3Result.lScore
	
	self.m_pGame3Result[#self.m_pGame3Result+1] =  pGame3Result
	--print("小玛丽结算 #self.m_pGame3Result",#self.m_pGame3Result)
end

--发送准备消息
function GameLayer:sendReadyMsg3()
	--发送数据
	local  dataBuffer= CCmd_Data:create(1)
	
	self:SendData(g_var(cmd).SHZ_SUB_C_THREE_START, dataBuffer)
end

function GameLayer:sendThreeEnd(  )
	--发送数据
	local  dataBuffer= CCmd_Data:create(1)
	
	self:SendData(g_var(cmd).SHZ_SUB_C_THREE_END, dataBuffer)
end

function GameLayer:enableButton(bEnableORdisable)
	--[[self._gameView.m_add:setEnabled(bEnableORdisable)
	self._gameView.m_reduce:setEnabled(bEnableORdisable)
	self._gameView.m_max:setEnabled(bEnableORdisable)
	self._gameView.button_yaxian:setEnabled(bEnableORdisable)--]]
	self._gameView.GameStart = bEnableORdisable
	
	if bEnableORdisable == true  then
		local texture = cc.Director:getInstance():getTextureCache():addImage("botton/changan0.png")
		self._gameView.m_start:setTexture(texture)
	elseif bEnableORdisable == false and self.m_bIsAuto == false then
		local texture = cc.Director:getInstance():getTextureCache():addImage("botton/changan1.png")
		self._gameView.m_start:setTexture(texture)
	end
end

--发送控制消息
function GameLayer:sendGetControlMsg()
    print("--------------------------------------------------------------------")
	print("获取控制消息")
	print("--------------------------------------------------------------------")
	--发送数据
    local cmddata = ExternalFun.create_netdata(g_var(cmd).CMD_C_UserContrl)
    cmddata:pushword(65534)

    self:SendData(g_var(cmd).SUB_C_USER_CONTROL, cmddata)
end

function GameLayer:sendModifyControlMsg(rule)
    print("--------------------------------------------------------------------")
	print("修改控制消息")
	print("--------------------------------------------------------------------")
	--发送数据
    local cmddata = ExternalFun.create_netdata(g_var(cmd).CMD_C_UpdateContrl)
    cmddata:pushscore(rule.lStorageMax1Room)
    cmddata:pushscore(rule.lStorageMul1Room)
    cmddata:pushscore(rule.lStorageMax2Room)
    cmddata:pushscore(rule.lStorageMul2Room)
    cmddata:pushscore(rule.lStorageMax3Room)
    cmddata:pushscore(rule.lStorageMul3Room)
    cmddata:pushword(rule.wHandse)
    cmddata:pushbyte(rule.cbNoCaijin)
    
    self:SendData(g_var(cmd).SUB_C_USER_UPDATECURST, cmddata)
end

function GameLayer:onGetControlInfo(datebuffer)
    local cmd_table = ExternalFun.read_netdata(g_var(cmd).CMD_S_UpdateContrl, datebuffer)
    self._gameView:onUpdateControlInfo(cmd_table)
end


function GameLayer:onModifyControlInfo(success)
    if success then
        showToast(self, "修改控制信息成功", 1)
    else
        showToast(self, "修改控制信息失败", 1)
    end
end
return GameLayer