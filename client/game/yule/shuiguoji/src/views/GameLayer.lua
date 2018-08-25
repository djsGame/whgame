local GameModel = appdf.req(appdf.CLIENT_SRC.."gamemodel.GameModel")
local GameLayer = class("GameLayer", GameModel)

--local Game2Layer = class("Game2Layer", GameModel)

local module_pre = "game.yule.shuiguoji.src";
require("cocos.init")
local ExternalFun =  appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local cmd = module_pre .. ".models.CMD_Game"

local GameViewLayer = appdf.req(module_pre .. ".views.layer.GameViewLayer")
local g_var = ExternalFun.req_var
local GameLogic = appdf.req(module_pre .. ".models.GameLogic")
local QueryDialog = appdf.req("base.src.app.views.layer.other.QueryDialog")
--local GameFrame = appdf.req(module_pre .. ".models.GameFrame")

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

    self.m_bLeaveGame = false

    GameLayer.super.ctor(self,frameEngine,scene)

    --self._gameFrame:QueryUserInfo( self:GetMeUserItem().wTableID,yl.INVALID_CHAIR)

    self:addAnimationEvent()  	--监听加载完动画的事件
	self:dingshiqi(1) 			-- 没2秒查询一次 库存
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
    self.m_bIsPlayed            = false       --是否玩过游戏
    self.m_cbGameStatus         = 0         --游戏状态

    self.m_cbGameMode           = 0         --游戏模式

    --游戏逻辑操作
    self.m_bIsItemMove          = false     --动画是否滚动的标示
    self.m_lCoins               = 0         --游戏币
    self.m_lYaxian              = GameLogic.YAXIANNUM         --压线
    self.m_lYafen               = 0         --压分
    self.m_lTotalYafen          = 0         --总压分
    self.m_lGetCoins            = 0         --获得金钱

    self.m_bEnterGame3          = false     --是否小玛丽
    self.m_bEnterGame2          = false     --是否比倍
    self.m_bYafenIndex          = 1         --压分索引（数组索引）
    self.m_lBetScore            = {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0}}        --压分存储数组
    self.m_cbItemInfo           = {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0}}          --开奖信息

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


    self.m_bIsAuto              = false        --控制自动开始按钮
    --self.m_bYafenIndexNow       = 0         --发送服务器时的压分索引
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
	self._lCurStorageScore = 1000000 --虚假库存
	self.m_nFreeCount = 0
	self.m_last_is_free = false
	self.m_free_count_before = 0 -- 前一轮的免费次数
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

    self.m_bEnterGame3          = false     --是否小玛丽
    self.m_bEnterGame2          = false     --是否比倍
    self.m_bYafenIndex          = 1         --压分索引（数组索引）
    self.m_lBetScore            = {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0}}         --压分存储数组
    self.m_cbItemInfo           = {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0}}         --开奖信息
    --self.m_ptZhongJiang         = {{},{},{}}         
    --中奖位置
    self.m_ptZhongJiang = {}
    for i=1,9 do
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
	-- 移除定时器
	cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
	self.schedulerID = nil	
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
            cc.DelayTime:create(60),
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
       self.m_querydialog = QueryDialog:create(szString,function()
        
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
	self:sendUpdateStock()
    --self._gameView:removeAction()
    self:KillGameClock()
    
    self._gameView.m_cbGameStatus = cbGameStatus;
	if cbGameStatus == g_var(cmd).SHZ_GAME_SCENE_FREE	then                        --空闲状态
        self:onEventGameSceneFree(dataBuffer);
	elseif cbGameStatus == g_var(cmd).SHZ_GAME_SCENE_ONE 	then                      
        self:onEventGameSceneStatus(dataBuffer);
	elseif cbGameStatus == g_var(cmd).SHZ_GAME_SCENE_TWO	then               
        self:onEventGame2SceneStatus(dataBuffer);
    elseif cbGameStatus == g_var(cmd).SHZ_GAME_SCENE_THREE    then                         
        --self:onEventGameSceneStatus(dataBuffer);	
	else
		print(cbGameStatus)
	end
    self:dismissPopWait()
end

--控制初始化消息, 只有作弊用户才能收到控制消息



function GameLayer:onEventGameSceneFree(buffer)    --空闲 
    local cmd_table = ExternalFun.read_netdata(g_var(cmd).SHZ_CMD_S_StatusFree, buffer)
    --初始化数据
    self.m_bMaxNum = cmd_table.cbBetCount
    self.m_lYafen = cmd_table.lCellScore

    self.m_lCoins = self:GetMeUserItem().lScore

    self.m_lBetScore = GameLogic:copyTab(cmd_table.lBetScore[1])
    self.m_lTotalYafen = self.m_lBetScore[self.m_bYafenIndex]*self.m_lYafen*self.m_lYaxian
    --self.m_lTotalYafen = self.m_lBetScore[self.m_bYafenIndex]*self.m_lYafen*self.m_lYaxian
    --压分
    self._gameView.m_textYafen:setString(tostring(self.m_lBetScore[self.m_bYafenIndex]))
    --总压分  Text_allyafen
    self._gameView.m_textAllyafen:setString(tostring(self.m_lTotalYafen))



end

function GameLayer:onEventGameSceneStatus(buffer)   
    --local cmd_table = ExternalFun.read_netdata(g_var(cmd).CMD_S_StatusPlay, buffer)
    print("···游戏1 ====================== >")

end

function GameLayer:onEventGame2SceneStatus(buffer)   
    --local cmd_table = ExternalFun.read_netdata(g_var(cmd).CMD_S_StatusPlay, buffer)
    print("···游戏2 ====================== >")

end


-----------------------------------------------------------------------------------
-- 游戏消息
function GameLayer:onEventGameMessage(sub,dataBuffer)
    if sub == g_var(cmd).SUB_S_GAME_START then 
        print("shuiguoji 游戏开始")
        self:onGame1Start(dataBuffer)                       --游戏开始
    elseif sub == g_var(cmd).SUB_S_GAME_CONCLUDE then 
        print("shuiguoji 压线结束")
        self:onSubGame1End(dataBuffer)                      --压线结束
    elseif sub == g_var(cmd).SUB_S_TWO_START then 
        --print("shuiguoji 比倍开始")
        self:onGame2Start(dataBuffer)                       --比倍开始
    elseif sub == g_var(cmd).SUB_S_TWO_GAME_CONCLUDE then 
        --print("shuiguoji 比倍结束") 
        --self:onSubSendCard(dataBuffer)
    elseif sub == g_var(cmd).SUB_S_THREE_START then         --小玛丽开始
        print("shuiguoji 小玛丽开始")
        self:onGame3Start(dataBuffer)
    elseif sub == g_var(cmd).SUB_S_THREE_KAI_JIANG then     --小玛丽开奖
        print("shuiguoji 小玛丽开奖")
        self:onGame3Result(dataBuffer)
    elseif sub == g_var(cmd).SUB_S_THREE_END then 
        print("shuiguoji 小玛丽结束")
        --self:onSubGetWinner(dataBuffer)
	elseif sub == g_var(cmd).SUB_S_QUERY_STORAGE_RESULT then
	    local cmd_table = ExternalFun.read_netdata(g_var(cmd).SHZ_CMD_S_CurStorage, dataBuffer)
		self._lCurStorageScore = cmd_table.lCurStorageScore
		self._gameView._csbNode:getChildByName("Text_storage"):setString("")
    else
        print("unknow gamemessage sub is "..sub)
		assert(false)
    end
end

-- score 8
-- word 2
-- dword 4

--游戏开始
function GameLayer:onGame1Start(dataBuffer) --游戏开始
    print("GameLayer -------游戏开始------")
    local cmd_table = ExternalFun.read_netdata(g_var(cmd).SHZ_CMD_S_GameStart, dataBuffer)
    dump(cmd_table)
    self.m_lGetCoins = cmd_table.lScore --中奖的分数
	self.m_nFreeCount = cmd_table.nFreeCount
	self.nFreeScoreCount = cmd_table.nFreeScoreCount
	self.m_nCurFreeCount = cmd_table.nCurFreeCount
	self.m_nXiaomaliCount = cmd_table.nXiaomaliCount -- 小玛丽次数
	self.m_lCoins = self.m_lCoins + self.m_lGetCoins
	print("onGame1Start 免费次数:"..self.m_nFreeCount)
	print("onGame1Start 免费次数获得的奖励:"..self.nFreeScoreCount)
	
	self._gameView._csbNode:getChildByName("img_free_count"):getChildByName("txt_free_count"):setString(self.m_nFreeCount) -- 剩余免费次数(一直显示)
	-- 如果有免费次数。禁止玩家操作部分按钮	
	if self.m_nFreeCount > 0 then
        self._gameView._csbNode:getChildByName("img_free_count"):setVisible(true)
        self._gameView._csbNode:getChildByName("img_free_count"):getChildByName("txt_free_count"):setString(self.m_nFreeCount) -- 剩余免费次数(一直显示)
    else
        self._gameView._csbNode:getChildByName("img_free_count"):setVisible(false)
    end

		self._gameView._csbNode:getChildByName("img_mianfei"):setVisible(false)
		self._gameView._csbNode:getChildByName("img_mianfei"):getChildByName("Text_mianfei"):setString(self.m_nFreeCount)--ui显示免费次数
		self._gameView._csbNode:getChildByName("img_mianfei"):getChildByName("free_score"):setString(self.nFreeScoreCount)--ui显示免费次数
		self._gameView._csbNode:getChildByName("img_mask"):setVisible(false) -- 改图片前的按钮点击无效
	
	
    self._gameView:updateStartAndAutoEnable(true)
    --进入小玛丽
	if self.m_nFreeCount>0 then
		self.m_bEnterGame3 = false
	else
		if g_var(cmd).GM_THREE == cmd_table.cbGameMode then
			self.m_bEnterGame3 = true
		else
			self.m_bEnterGame3 = false
		end
	end

    self.m_cbItemInfo = {{0,0,0,0,0},{0,0,0,0,0},{0,0,0,0,0}} 
    self.m_cbItemInfo = GameLogic:copyTab(cmd_table.cbItemInfo)

    --检验是否中奖
    GameLogic:GetAllZhongJiangInfo(self.m_cbItemInfo,self.m_ptZhongJiang)

    --改变状态
    self.m_cbGameStatus = g_var(cmd).SHZ_GAME_SCENE_ONE

    if self.m_lGetCoins > 0 then
        --清空数组

        self.m_UserActionYaxian = {}
        --获取中奖信息，压线和中奖结果
        for i=1,GameLogic.ITEM_COUNT do

            if GameLogic:getZhongJiangInfo(i,self.m_cbItemInfo,self.m_ptZhongJiang) ~= 0 then
                local pActionOneYaXian = {}
                pActionOneYaXian.nZhongJiangXian = i
                pActionOneYaXian.lXianScore = GameLogic:GetZhongJiangTime(i,self.m_cbItemInfo)*self.m_lYafen*self.m_lBetScore[self.m_bYafenIndex]
                pActionOneYaXian.lScore = self.m_lGetCoins
                pActionOneYaXian.ptXian = self.m_ptZhongJiang[pActionOneYaXian.nZhongJiangXian]
                self.m_UserActionYaxian[#self.m_UserActionYaxian+1] = pActionOneYaXian
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
            for i=1,GameLogic.ITEM_COUNT do
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

    if self.m_bIsAuto == ture then
        self._gameView:updateStartButtonState(true)
    else
        self._gameView:updateStartButtonState(false)
    end
end

function GameLayer:onSubGame1End( dataBuffer )
    print(dataBuffer:getlen())
    print("GameLayer -------游戏1结束------")
	
	self:sendUpdateStock()  -- 游戏结束 查询库存
    if self.m_lTotalYafen > self.m_lCoins + self.m_lGetCoins then
        --提示游戏币不足
        showToast(self, "提醒：游戏币不足", 1)
        self.m_bIsAuto = false
        self._gameView:setAutoStart(false)
    else
        if self.m_bIsAuto == true then

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
				
	            self._gameView:laganAnimation()-----------------自动开启拉杆
            end
        end
    end
end

function GameLayer:panduanMianfei()

	
	--[[当有免费次数, 且当前状态不是自动的情况下 , 调用自动]]
	if self.nextIsAuto == false then
		print("免费次数中获得的总共奖励:"..self.nFreeScoreCount)
		print(self.m_bIsAuto)
		-- 弹出提示 免费次数期间 获得的总分数 self.nFreeScoreCount
		--[[local node = self._gameView._csbNode:getChildByName("img_mianfei")
		node:setVisible(true)
		node:getChildByName("free_score"):setString(self.nFreeScoreCount)
		node:runAction(cc.Sequence:create(cc.DelayTime:create(1), cc.CallFunc:create(function()
		node:setVisible(false)
		end)))]]
		-- self.m_bIsAuto = true
		-- self:onAutoStart()
	end
	
	self.nextIsAuto = true
	if self.m_nFreeCount > 0 and not self.m_bIsAuto then -- 有免费次数， 游戏自动开始
		print("免费次数:"..self.m_nFreeCount)
		self:onAutoStart()
		if  self.m_nFreeCount == 1 then  -- 下一次 为最后一次, 执行下一次之后就停止(非自动情况下)
			 self.nextIsAuto = false
		end
	elseif self.m_nFreeCount == 1 then  -- 下一次 为最后一次, 执行下一次之后就停止(非自动情况下)
		 self.nextIsAuto = false
	end
	
	if self.m_nFreeCount > 0 then
		self.m_last_is_free = true
	else
		self.m_last_is_free = false
	end
	
	self.m_free_count_before = self.m_nFreeCount
	
	if self.m_nFreeCount >0 then -- 得到免费总次数
		self._gameView._free_count_view = self._gameView._free_count_view + self.m_nCurFreeCount
	else
		self._gameView._free_count_view = 0
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
    local useritem = self:GetMeUserItem()
    self._gameView:onHideTopMenu()
	self._gameView:laganAnimation()

	self:sendUpdateStock()  -- 游戏开始查询库存
    --自动开始
    if self.m_bIsAuto == true then
        if self:getGameMode() == GAME_STATE.GAME_STATE_MOVING then
            self._gameView:game1End()
            return
        --elseif self.m_bIsItemMove == false and (self:getGameMode() == GAME_STATE.GAME_STATE_WAITTING_GAME2  or (self:getGameMode() == GAME_STATE.GAME_STATE_WAITTING) or (self:getGameMode() == GAME_STATE.GAME_STATE_END)) then
        elseif self:getGameMode() == GAME_STATE.GAME_STATE_WAITTING_GAME2  then
            print("游戏开始")
            self.m_bIsPlayed = true
            self._gameView:stopAllActions()
            --游戏2按钮不可用
            self._gameView:enableGame2Btn(false)
            --发送消息
            self:sendGiveUpMsg()
            self._gameView.m_textTips:setString("祝您好运！")
             if self.m_lTotalYafen > self.m_lCoins + self.m_lGetCoins then
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
            return 
        else
            return
        end
    end
    --开始
    if self:getGameMode() == GAME_STATE.GAME_STATE_MOVING then
        self._gameView:game1End()
    --elseif  self.m_bIsItemMove == false and  (self:getGameMode() == GAME_STATE.GAME_STATE_WAITTING_GAME2) or (self:getGameMode() == GAME_STATE.GAME_STATE_WAITTING) or (self:getGameMode() == GAME_STATE.GAME_STATE_END) then
    elseif  (self:getGameMode() == GAME_STATE.GAME_STATE_WAITTING) or (self:getGameMode() == GAME_STATE.GAME_STATE_END) then
        --发送放弃到比大小的消息
        if self.m_lGetCoins > 0 then --or (self:getGameMode() == GAME_STATE.GAME_STATE_END) then
            self:sendGiveUpMsg()
        end
        if self.m_lTotalYafen > self.m_lCoins + self.m_lGetCoins then
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
    self._gameView:onHideTopMenu()
    --self._gameView:updateStartAndAutoEnable(false)
    --判断金钱是否够自动开始
    if self.m_bIsAuto == true then
        self.m_bIsAuto = false
        self._gameView:setAutoStart(false)
    else
        self.m_bIsAuto = true
        if self.m_lTotalYafen > self.m_lCoins + self.m_lGetCoins then
            --提示游戏币不足
            showToast(self, "提醒：游戏币不足", 1)
            self.m_bIsAuto = false
            self._gameView:setAutoStart(false)
            return
        end
        self._gameView:setAutoStart(true) 
        self._gameView:laganAnimation()-----------------------------------第一次开启自动播放拉杆动画
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
function GameLayer:onAddMaxScore()

    self._gameView:onHideTopMenu()

    self.m_bYafenIndex = self.m_bMaxNum 
    self.m_lTotalYafen = self.m_lBetScore[self.m_bYafenIndex]*self.m_lYafen*self.m_lYaxian
    --压分
    self._gameView.m_textYafen:setString(self.m_lBetScore[self.m_bYafenIndex])
    --总压分
    self._gameView.m_textAllyafen:setString(self.m_lTotalYafen)

end

--最小加注
function GameLayer:onAddMinScore( )
    self._gameView:onHideTopMenu()
    self.m_bYafenIndex = 1
    self.m_lTotalYafen = self.m_lBetScore[self.m_bYafenIndex]*self.m_lYafen*self.m_lYaxian
    --压分
    self._gameView.m_textYafen:setString(self.m_lBetScore[self.m_bYafenIndex])
    --总压分
    self._gameView.m_textAllyafen:setString(self.m_lTotalYafen)

end
--加注
function GameLayer:onAddScore()

    if self.m_nFreeCount > 0 then
        return
    end

    self._gameView:onHideTopMenu()
    if self.m_bYafenIndex < self.m_bMaxNum then
        self.m_bYafenIndex = self.m_bYafenIndex + 1
    else
        self.m_bYafenIndex = self.m_bMaxNum
    end
    self.m_lTotalYafen = self.m_lBetScore[self.m_bYafenIndex]*self.m_lYafen*self.m_lYaxian

    --压分
    self._gameView.m_textYafen:setString(self.m_lBetScore[self.m_bYafenIndex])
    --总压分
    self._gameView.m_textAllyafen:setString(self.m_lTotalYafen)
end

--减注
function GameLayer:onSubScore()

    if self.m_nFreeCount > 0 then
        return
    end
    
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
end

--请求更新库存
function GameLayer:sendUpdateStock( )
    local  dataBuffer= CCmd_Data:create(0)
    self:SendData(g_var(cmd).SHZ_SUB_C_QUERY_STORAGE, dataBuffer)
end

--发送准备消息
function GameLayer:sendReadyMsg()

    -- 游戏开始时，移除闪光动画
    for k,v in ipairs(self._gameView.lightAnim_node) do
        print(k,v)
        if v ~= nil then
            v:removeFromParent()
            v = nil
        end
    end

   -- self._gameView.lightAnim_node = nil
    self._gameView.lightAnim_node = {}

    print("发送准备消息成功")
    print("发送准备消息成功")
    print("发送准备消息成功")
    print("发送准备消息成功")
    print("发送准备消息成功")
    print("发送准备消息成功")
    local  dataBuffer= CCmd_Data:create(8)
    dataBuffer:pushscore(self.m_bYafenIndex-1)
    self:SendData(g_var(cmd).SHZ_SUB_C_ONE_START, dataBuffer)
    self._gameView:updateStartAndAutoEnable(false)
	self._gameView.m_textGetScore:setString(0)
    if self.m_lGetCoins and self.m_lGetCoins > 0 then
        ExternalFun.playSoundEffect("LabarStart.mp3")
        self._gameView.m_textScore:setString(self.m_lCoins)
		self._gameView.m_textScore_1:setString(self.m_lCoins)
		if self.m_nFreeCount > 0 then
			self:changeUserScore(0)
		else
			self:changeUserScore(-self.m_lTotalYafen)
		end
    else
        self._gameView.m_textScore:setString(self.m_lCoins)
		self._gameView.m_textScore_1:setString(self.m_lCoins)
		if self.m_nFreeCount > 0 then
			self:changeUserScore(0)
		else
			self:changeUserScore(-self.m_lTotalYafen)
		end
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
    print("发送结束游戏1消息")
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
    self._gameView.m_textScore:setString(useritem.lScore)
	self._gameView.m_textScore_1:setString(useritem.lScore)
    self.m_lCoins = self:GetMeUserItem().lScore
end

function GameLayer:changeUserScore( changeScore )
	
	self.m_lCoins = self.m_lCoins + changeScore
    self._gameView.m_textScore:setString(self.m_lCoins)
	self._gameView.m_textScore_1:setString(self.m_lCoins)
end
------------------------------------------------------------
--                      游戏2 摇骰子
------------------------------------------------------------
--游戏2开奖
function GameLayer:onGame2Start(dataBuffer)
    local cmd_table = ExternalFun.read_netdata(g_var(cmd).SHZ_CMD_S_GameTwoStart, dataBuffer)
    --self.m_pGame2Result = {}
    self.m_pGame2Result.cbOpenSize[1] = cmd_table.cbOpenSize[1][1]
    self.m_pGame2Result.cbOpenSize[2] = cmd_table.cbOpenSize[1][2]
    self.m_pGame2Result.lScore = cmd_table.lScore
    self.m_lGetCoins2 = self.m_pGame2Result.lScore
    self.m_lAllGetCoin2 = self.m_lAllGetCoin2 + self.m_lGetCoins2
    self._game2View:initOpenDiceCup()
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
    self._gameView.m_textScore:setString(self.m_lCoins)
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

function GameLayer:dingshiqi(time) -- 多少秒请求一次
	local scheduler = cc.Director:getInstance():getScheduler()  
	self.schedulerID = nil  
	self.schedulerID = scheduler:scheduleScriptFunc(function()  
		--self:sendUpdateStock()
        local num 
        if  self._lCurStorageScore + math.random(10, 1000) < 0 then
            num = "/"..(0-  self._lCurStorageScore + math.random(10, 1000))
        else
            num =   self._lCurStorageScore + math.random(10, 1000)
        end
        print(num, type(num))
		self._gameView._csbNode:getChildByName("Text_storage"):setString("")
	end,time,false)   
end


return GameLayer