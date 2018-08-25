--                            _ooOoo_  
--                           o8888888o  
--                           88" . "88  
--                           (| -_- |)  
--                            O\ = /O  
--                        ____/`---'\____  
--                      .   ' \\| |// `.  
--                      / \\||| : |||// \  
--                     / _||||| -:- |||||- \  
--                       | | \\\ - /// | |  
--                     | \_| ''\---/'' | |  
--                      \ .-\__ `-` ___/-. /  
--                   ___`. .' /--.--\ `. . __  
--                ."" '< `.___\_<|>_/___.' >'"".  
--               | | : `- \`.;`\ _ /`;.`/ - ` : | |  
--                 \ \ `-. \_ __\ /__ _/ .-` / /  
--         ======`-.____`-.___\_____/___.-`____.-'======  
--                            `=---='  
--  
--         .............................................  
--                  佛祖保佑             永无BUG 
local GameModel = appdf.req(appdf.CLIENT_SRC.."gamemodel.GameModel")

local GameLayer = class("GameLayer", GameModel)

local cmd = appdf.req(appdf.GAME_SRC.."yule.zhajinhua.src.models.CMD_Game")
local GameLogic = appdf.req(appdf.GAME_SRC.."yule.zhajinhua.src.models.GameLogic")
local GameViewLayer = appdf.req(appdf.GAME_SRC.."yule.zhajinhua.src.views.layer.GameViewLayer")
local QueryDialog = appdf.req("base.src.app.views.layer.other.QueryDialog")


function GameLayer:onExit()
    self:KillGameClock()
    self:dismissPopWait()
    GameLayer.super.onExit(self)
end

--退出桌子
function GameLayer:onExitTable()
    if self.m_querydialog then
        return
    end
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
end

--离开房间
function GameLayer:onExitRoom()
    self._scene:onKeyBack()
end
--系统消息
function GameLayer:onSystemMessage( wType,szString )
    if wType == 501 or wType == 515 then
        print("扎金花金币不足消息", szString)
        GlobalUserItem.bWaitQuit = true
        self:onSubNoticeAddScore(szString)
    end
end


function GameLayer:SwitchViewChairID(chair)
    local viewid = yl.INVALID_CHAIR
    local nChairCount = 5
    print("椅子数目", nChairCount)
    local nChairID = self:GetMeChairID()
    if chair ~= yl.INVALID_CHAIR and chair < nChairCount then
        viewid = math.mod(chair + math.floor(nChairCount * 3/2) - nChairID, nChairCount) + 1
        print("装换完的ID", viewid)
    end
    return viewid
end

function GameLayer:onGetSitUserNum()
    local userNum = 0
    for i=1,table.nums(self._gameView.nodePlayer) do
        if self._gameView.nodePlayer[i]:isVisible() then
            userNum = userNum + 1
        end
    end
    return userNum
    --return table.nums(self._gameView.nodePlayer)
end

function GameLayer:getUserInfoByChairID(chairId)
    return self._gameFrame:getTableUserItem(self._gameFrame:GetTableID(), chairId)
end

--获取gamekind
function GameLayer:getGameKind()
    return cmd.KIND_ID
end

-- 初始化界面
function GameLayer:ctor(frameEngine,scene)
    GameLayer.super.ctor(self,frameEngine,scene)
end

-- 创建场景
function GameLayer:CreateView()
    --cc.FileUtils:getInstance():addSearchPath(device.writablePath..cmd.RES,true)
    return GameViewLayer:create(self)
        :addTo(self)
end

function GameLayer:getParentNode( )
    return self._scene
end
--设置私有房的层级
function GameModel:addPrivateGameLayer( layer )
    if nil == layer then
        return
    end
        self._gameView:addChild(layer, 9)
end

-- 初始化游戏数据
function GameLayer:OnInitGameEngine()

    GameLayer.super.OnInitGameEngine(self)

    self.m_wCurrentUser = yl.INVALID_CHAIR              --当前用户
    self.m_wBankerUser = yl.INVALID_CHAIR               --庄家用户

    self.m_cbPlayStatus = {0,0,0,0,0}                     --游戏状态
    self.m_lTableScore = {0,0,0,0,0}                      --下注数目

    self.m_lMaxCellScore = 0                            --单元上限
    self.m_lCellScore = 0                               --单元下注

    self.m_lCurrentTimes = 0                            --当前倍数
    self.m_lUserMaxScore = 0                            --最大分数

    self.m_bLookCard  = {false,false,false,false,false}        --看牌动作

    self.m_wLostUser = yl.INVALID_CHAIR                 --比牌失败
    self.m_wWinnerUser = yl.INVALID_CHAIR               --胜利用户 

    self.m_lAllTableScore = 0

    self.m_bNoScore = false   --金币不足
    self.m_bStartGame = false
    -- 提示
    self.m_szScoreMsg = ""
    
    self.chUserAESKey = 
    {
        0x32, 0x43, 0xF6, 0xA8,
        0x88, 0x5A, 0x30, 0x8D,
        0x31, 0x31, 0x98, 0xA2,
        0xE0, 0x37, 0x07, 0x34
    }
    self.nVoiceFollow = {0, 0, 0, 0, 0}
end

-- 重置游戏数据
function GameLayer:OnResetGameEngine()
    GameLayer.super.OnResetGameEngine(self)

    self._gameView:OnResetView()

    self.m_wCurrentUser = yl.INVALID_CHAIR              --当前用户
    self.m_wBankerUser = yl.INVALID_CHAIR               --庄家用户
    self.m_cbPlayStatus = {0,0,0,0,0}                     --游戏状态
    self.m_lTableScore = {0,0,0,0,0}                      --下注数目
    self.m_lMaxCellScore = 0                            --单元上限
    self.m_lCellScore = 0                               --单元下注
    self.m_lCurrentTimes = 0                            --当前倍数
    self.m_lUserMaxScore = 0                            --最大分数
    self.m_bLookCard  = {false,false,false,false,false}        --看牌动作
    self.m_wLostUser = yl.INVALID_CHAIR                 --比牌失败
    self.m_wWinnerUser = yl.INVALID_CHAIR               --胜利用户 
    self.m_lAllTableScore = 0
end

-- 设置计时器
function GameLayer:SetGameClock(chair,id,time)
    GameLayer.super.SetGameClock(self,chair,id,time)
    local viewid = self:GetClockViewID()
    if viewid and viewid ~= yl.INVALID_CHAIR then
        local progress = self._gameView.m_TimeProgress[viewid]
        if progress ~= nil then
            progress:setPercentage(100)
            progress:setVisible(true)
            progress:runAction(cc.Sequence:create(cc.ProgressTo:create(time, 0), cc.CallFunc:create(function()
                progress:setVisible(false)
                self:OnEventGameClockInfo(viewid, id)
            end)))
        end
    end
end

-- 关闭计时器
function GameLayer:KillGameClock(notView)
    local viewid = self:GetClockViewID()
    if viewid and viewid ~= yl.INVALID_CHAIR then
        local progress = self._gameView.m_TimeProgress[viewid]
        if progress ~= nil then
            progress:stopAllActions()
            progress:setVisible(false)
        end
    end
    
    GameLayer.super.KillGameClock(self,notView)
end

--获得当前正在玩的玩家数量
function GameLayer:getPlayingNum()
    local num = 0
    for i = 1, cmd.GAME_PLAYER do
        if self.m_cbPlayStatus[i] == 1 then
            num = num + 1
        end
    end
    return num
end

-- 时钟处理
function GameLayer:OnEventGameClockInfo(chair,time,clockid)
     --房卡不托管
    if GlobalUserItem.bPrivateRoom then
        print("倒计时处理，房卡返回")
        if time <= 0 then
            return true
        end
    end 
    if time < 5 then
        self:PlaySound(cmd.RES.."sound_res/GAME_WARN.wav")
    end
    if clockid == cmd.IDI_START_GAME then
        if time <= 0 then
            self._gameFrame:setEnterAntiCheatRoom(false)--退出防作弊
            return true
        end
    elseif clockid == cmd.IDI_DISABLE then
        if time == 0 then
            return true
        end
    elseif clockid == cmd.IDI_USER_ADD_SCORE then
        if time == 0 then
            if self.m_wCurrentUser == self:GetMeChairID() then
                    self:onGiveUp()
                return true
            end
        end
    elseif clockid == cmd.IDI_USER_COMPARE_CARD then
        if time == 0 then
            self._gameView:SetCompareCard(false)
            self:onAutoCompareCard()
            return true
        end
    end
end

-- 场景信息
function GameLayer:onEventGameScene(cbGameStatus,dataBuffer)
    --辅助读取int64
    local int64 = Integer64.new()

    --初始化已有玩家
    for i = 1, cmd.GAME_PLAYER do
        local userItem = self._gameFrame:getTableUserItem(self._gameFrame:GetTableID(), i-1)
        local wViewChairId = self:SwitchViewChairID(i-1)
        self._gameView:OnUpdateUser(wViewChairId, userItem)
    end
    self.m_cbGameStatus = cbGameStatus
	if cbGameStatus == cmd.GAME_STATUS_FREE	then				--空闲状态

        self.m_lCellScore = dataBuffer:readscore(int64):getvalue()
        local lRoomStorageStart = dataBuffer:readscore(int64):getvalue()
        local lRoomStorageCurrent = dataBuffer:readscore(int64):getvalue()
        --机器人配置
        for i = 1, 40 do
            dataBuffer:readbyte()
        end
        --初始秘钥
        for i = 1, 16 do
            self.chUserAESKey[i] = dataBuffer:readbyte()
        end
        --房间名称
        local szServerName = dataBuffer:readstring(32)

        self._gameView:SetCellScore(self.m_lCellScore)
        if not GlobalUserItem.isAntiCheat() then
            self._gameView.btReady:setVisible(self:GetMeUserItem().cbUserStatus == yl.US_SIT)
                -- 私人房无倒计时
            if not GlobalUserItem.bPrivateRoom then
                -- 设置倒计时
                self:SetGameClock(self:GetMeChairID(),cmd.IDI_START_GAME,cmd.TIME_START_GAME)
            end   
        end

	elseif cbGameStatus == cmd.GAME_STATUS_PLAY	then			--游戏状态
        print("game status is play!")
        local MyChair = self:GetMeChairID() + 1
        --参数设置
        self.m_lMaxCellScore = dataBuffer:readscore(int64):getvalue()
        self.m_lCellScore = dataBuffer:readscore(int64):getvalue()
        self.m_lCurrentTimes = dataBuffer:readscore(int64):getvalue()
        self.m_lUserMaxScore = dataBuffer:readscore(int64):getvalue()
        self.m_wBankerUser = dataBuffer:readword()
        self.m_wCurrentUser = dataBuffer:readword()
        for i = 1, cmd.GAME_PLAYER do
            self.m_cbPlayStatus[i] = dataBuffer:readbyte()
            print("状态", self.m_cbPlayStatus[i])
        end

        for i = 1, cmd.GAME_PLAYER  do
            self.m_bLookCard[i] = dataBuffer:readbool()
        end
        for i = 1, cmd.GAME_PLAYER do
            self.m_lTableScore[i]  = dataBuffer:readscore(int64):getvalue()
        end
        local lRoomStorageStart = dataBuffer:readscore(int64):getvalue()
        local lRoomStorageCurrent = dataBuffer:readscore(int64):getvalue()
        --机器人数据
        for i = 1, 40 do
            dataBuffer:readbyte()
        end
        local cardData = {}
        for i = 1, 3 do
            cardData[i] = dataBuffer:readbyte()
        end
        local bCompareStatus = dataBuffer:readbool()
        --初始秘钥
        for i = 1, 16 do
            self.chUserAESKey[i] = dataBuffer:readbyte()
        end
        --房间名称
        local szServerName = dataBuffer:readstring(32)

        self.m_lAllTableScore = 0

        --底注信息
        self._gameView:SetCellScore(self.m_lCellScore)
        self._gameView:SetMaxCellScore(self.m_lMaxCellScore)

        --庄家信息
        self._gameView:SetBanker(self:SwitchViewChairID(self.m_wBankerUser))

        for i = 1, cmd.GAME_PLAYER do
            --视图位置
            local viewid = self:SwitchViewChairID(i-1)
            --手牌显示
            if self.m_cbPlayStatus[i] == 1 then
                self._gameView.userCard[viewid].area:setVisible(true)
                if i == MyChair  and self.m_bLookCard[MyChair] == true then
                    local cardIndex = {}
                    for k = 1 , 3 do
                        cardIndex[k] = GameLogic:getCardColor(cardData[k])*13 + GameLogic:getCardValue(cardData[k])
                    end
                    self._gameView:SetUserCard(viewid,cardIndex)
                    
                else
                    self._gameView:SetUserCard(viewid,{0xff,0xff,0xff})
                end
            else
                 self._gameView.userCard[viewid].area:setVisible(false)
                 self._gameView:SetUserCard(viewid)
            end
            --看牌显示
            self._gameView:SetLookCard(viewid,self.m_bLookCard[i])
            self._gameView:SetUserTableScore(viewid, self.m_lTableScore[i])
            self.m_lAllTableScore = self.m_lAllTableScore + self.m_lTableScore[i]

            self._gameView:PlayerJetton(viewid,self.m_lTableScore[i],true)

            --是否弃牌
            if self.m_cbPlayStatus[i] ~= 1 and self.m_lTableScore[i] > 0 then
                self._gameView.userCard[viewid].area:setVisible(true)
                self._gameView:SetUserGiveUp(viewid, true)
                print("\n成功了\n")
            end
        end

        --总下注
        self._gameView:SetAllTableScore(self.m_lAllTableScore)

        --控件信息
        self._gameView.nodeButtomButton:setVisible(false)

        if not bCompareStatus then
            --控件信息
            if self:GetMeChairID() == self.m_wCurrentUser then
                self:UpdataControl()
            end
            --设置时间
            self:SetGameClock(self.m_wCurrentUser, cmd.IDI_USER_ADD_SCORE, cmd.TIME_USER_ADD_SCORE)
        else

            if self:GetMeChairID() == self.m_wCurrentUser then
                --选择玩家比牌
                local compareStatus={false,false,false,false,false}
                for i = 1 ,cmd.GAME_PLAYER do
                    if self.m_cbPlayStatus[i] == 1 and i ~= MyChair then
                        compareStatus[self:SwitchViewChairID(i-1)] = true
                    end
                end
                self._gameView:SetCompareCard(true,compareStatus)
                --设置时间
                self:SetGameClock(self.m_wCurrentUser, cmd.IDI_USER_COMPARE_CARD, cmd.TIME_USER_COMPARE_CARD)
            else
                self._gameView:SetCompareCard(false)
                --设置时间
                self:SetGameClock(self.m_wCurrentUser, cmd.IDI_DISABLE, cmd.TIME_USER_COMPARE_CARD)
            end
        end
	end
    -- 刷新房卡
    print("场景消息PriRoom GlobalUserItem.bPrivateRoom", PriRoom, GlobalUserItem.bPrivateRoom)
    if PriRoom and GlobalUserItem.bPrivateRoom then
        print("场景消息 self._gameView._priView self._gameView._priView.onRefreshInfo", self._gameView._priView, self._gameView._priView.onRefreshInfo)
        if nil ~= self._gameView._priView and nil ~= self._gameView._priView.onRefreshInfo then
            print("场景消息 刷新房卡信息")
            self._gameView._priView:onRefreshInfo()
        end
    end
    self:dismissPopWait()
end

-- 游戏消息
function GameLayer:onEventGameMessage(sub,dataBuffer)

	if sub == cmd.SUB_S_GAME_START then 
		self:onSubGameStart(dataBuffer)
	elseif sub == cmd.SUB_S_ADD_SCORE then 
		self:onSubAddScore(dataBuffer)
	elseif sub == cmd.SUB_S_LOOK_CARD then 
		self:onSubLookCard(dataBuffer)
	elseif sub == cmd.SUB_S_COMPARE_CARD then 
		self:onSubCompareCard(dataBuffer)
	elseif sub == cmd.SUB_S_GIVE_UP then 
		self:onSubGiveUp(dataBuffer)
	elseif sub == cmd.SUB_S_PLAYER_EXIT then 
		self:onSubPlayerExit(dataBuffer)
    elseif sub == cmd.SUB_S_GAME_END then 
        self:onSubGameEnd(dataBuffer)
    elseif sub == cmd.SUB_S_WAIT_COMPARE then 
        self:onSubWaitCompare(dataBuffer)
    elseif sub == cmd.SUB_S_UPDATEAESKEY then
        self:onSubUpdateAesKey(dataBuffer)
    elseif sub == cmd.SUB_S_RC_TREASURE_DEFICIENCY then
       --self:onSubNoticeAddScore("你的金币不足，无法继续游戏")
	else
		print("unknow gamemessage sub is"..sub)
	end
end

--游戏开始
function GameLayer:onSubGameStart(dataBuffer)

    local int64 = Integer64.new()

    self.m_cbGameStatus = cmd.GAME_STATUS_PLAY

    self.m_lMaxCellScore = dataBuffer:readscore(int64):getvalue()
    self.m_lCellScore = dataBuffer:readscore(int64):getvalue()
    self.m_lCurrentTimes = dataBuffer:readscore(int64):getvalue()
    self.m_lUserMaxScore = dataBuffer:readscore(int64):getvalue()

    print("游戏开始底注信息 MaxCellScore   CellScore", self.m_lMaxCellScore, self.m_lCellScore)

    self.m_wBankerUser = dataBuffer:readword()
    self.m_wCurrentUser = dataBuffer:readword()

    self._gameView:SetBanker(self:SwitchViewChairID(self.m_wBankerUser))
    self._gameView:SetCellScore(self.m_lCellScore)
    self._gameView:SetMaxCellScore(self.m_lMaxCellScore)

    self.m_lAllTableScore = 0
    self._gameView:CleanAllJettons()
    for i = 1, cmd.GAME_PLAYER  do
        --跟新玩家
        local userItem = self._gameFrame:getTableUserItem(self._gameFrame:GetTableID(), i-1)
        local wViewChairId = self:SwitchViewChairID(i-1)
        self._gameView:OnUpdateUser(wViewChairId, userItem)
        --读取游戏状态
        local data = dataBuffer:readbyte()
        self.m_cbPlayStatus[i] = data
        if self.m_cbPlayStatus[i] == 1 then 
            self.m_lAllTableScore = self.m_lAllTableScore + self.m_lCellScore
            self.m_lTableScore[i] = self.m_lCellScore
            --用户下注
            self._gameView:SetUserTableScore(wViewChairId, self.m_lCellScore)
            --移动筹码
            self._gameView:PlayerJetton(wViewChairId,self.m_lTableScore[i])
        end
    end

    --总计下注
    self._gameView:SetAllTableScore(self.m_lAllTableScore)

    --发牌
    self:PlaySound(cmd.RES.."sound_res/SEND_CARD_BEGIN.wav")
    local delayCount = 1
    for index = 1 , 3 do
        for i = 1, cmd.GAME_PLAYER do
            local chair = math.mod(self.m_wBankerUser + i - 1,cmd.GAME_PLAYER) 
            if self.m_cbPlayStatus[chair + 1] == 1 then
                self._gameView:SendCard(self:SwitchViewChairID(chair),index,delayCount*0.1)
                delayCount = delayCount + 1
            end
        end
    end
   
    self:SetGameClock(self.m_wCurrentUser,cmd.IDI_USER_ADD_SCORE,cmd.TIME_USER_ADD_SCORE)

    if self.m_wCurrentUser == self:GetMeChairID() then
        self:UpdataControl()
    end
    self:PlaySound(cmd.RES.."sound_res/GAME_START.wav")

    if PriRoom and GlobalUserItem.bPrivateRoom then
        if nil ~= self._gameView._priView and nil ~= self._gameView._priView.onRefreshInfo then
            PriRoom:getInstance().m_tabPriData.dwPlayCount = PriRoom:getInstance().m_tabPriData.dwPlayCount + 1
            self._gameView._priView:onRefreshInfo()
        end
    end
end

--用户叫分
function GameLayer:onSubAddScore(dataBuffer)

    
    local MyChair = self:GetMeChairID()

    local int64 = Integer64.new()
    self.m_wCurrentUser = dataBuffer:readword()
    local wAddScoreUser = dataBuffer:readword()
    local wCompareState = dataBuffer:readword()
    local lAddScoreCount = dataBuffer:readscore(int64):getvalue()
    local lCurrentTimes = dataBuffer:readscore(int64):getvalue()

    local viewid = self:SwitchViewChairID(wAddScoreUser)
    if self.m_lCurrentTimes < lCurrentTimes then
        self._gameView:runAddTimesAnimate(viewid)
    end

    if wAddScoreUser ~= MyChair then
         self:KillGameClock()
    end

    if wAddScoreUser ~= MyChair then
        self._gameView:PlayerJetton(viewid, lAddScoreCount)
        self.m_lTableScore[wAddScoreUser+1] = self.m_lTableScore[wAddScoreUser+1] + lAddScoreCount
        self.m_lAllTableScore = self.m_lAllTableScore + lAddScoreCount
        self._gameView:SetUserTableScore(viewid, self.m_lTableScore[wAddScoreUser+1])
        self._gameView:SetAllTableScore(self.m_lAllTableScore)
    end

    if wCompareState == 0 then
        --声音
        if self.m_cbPlayStatus[wAddScoreUser + 1] == 1 then
            if self.m_lCurrentTimes == lCurrentTimes then
                local strFile = cmd.RES.."sound_res/"..string.format("FOLLOW_COIN_%d.wav", math.mod(self.nVoiceFollow[viewid], 3))
                self:PlaySound(strFile)
                self.nVoiceFollow[viewid] = self.nVoiceFollow[viewid] + 1
            else
                self:PlaySound(cmd.RES.."sound_res/RAISE_COIN.wav")
            end
        end
        --设置计时器
        self:SetGameClock(self.m_wCurrentUser, cmd.IDI_USER_ADD_SCORE, cmd.TIME_USER_ADD_SCORE)
    end
    self.m_lCurrentTimes = lCurrentTimes

    --更新操作控件
    if wCompareState == 0 and self.m_wCurrentUser == MyChair then
        self:UpdataControl()
    end
end

--庄家信息
function GameLayer:onSubLookCard(dataBuffer)
    local wLookCardUser = dataBuffer:readword()
   
    local viewid = self:SwitchViewChairID(wLookCardUser)
    self._gameView:SetLookCard(viewid,true)
    if wLookCardUser == self:GetMeChairID() then
        local cbCardData = {}
        for i = 1, 3 do
            cbCardData[i] = dataBuffer:readbyte()
        end
        local cardIndex = {}
        for k = 1 , 3 do
            cardIndex[k] = GameLogic:getCardColor(cbCardData[k])*13 + GameLogic:getCardValue(cbCardData[k])
        end
        self._gameView:SetUserCard(viewid, cardIndex)
    end
end

--出牌信息
function GameLayer:onSubCompareCard(dataBuffer)

    self.m_wCurrentUser = dataBuffer:readword()
    local wCompareUser = {}
    for i = 1, 2 do
        wCompareUser[i] = dataBuffer:readword()
    end
    self.m_wLostUser = dataBuffer:readword()
    self.m_wWinnerUser = wCompareUser[1] + wCompareUser[2] - self.m_wLostUser

    self.m_cbPlayStatus[self.m_wLostUser+1] = 0

    self._gameView:SetCompareCard(false)

    self:KillGameClock()
    local this = self
    local firstuser =  self._gameFrame:getTableUserItem(self._gameFrame:GetTableID(), wCompareUser[1])
    local seconduser =  self._gameFrame:getTableUserItem(self._gameFrame:GetTableID(), wCompareUser[2])
    self._gameView:CompareCard(firstuser,seconduser,nil,nil,wCompareUser[1] == self.m_wWinnerUser, function()
         this:OnFlushCardFinish()
        end)
    -- self._gameView:CompareCard(self:SwitchViewChairID(self.m_wWinnerUser), self:SwitchViewChairID(self.m_wLostUser), function()
    --     this:OnFlushCardFinish()
    -- end)

    self:PlaySound(cmd.RES.."sound_res/COMPARE_CARD.wav")
end

function GameLayer:OnFlushCardFinish()

    local nodeCard = self._gameView.userCard[self:SwitchViewChairID(self.m_wLostUser)]
    for i = 1, 3 do
        nodeCard.card[i]:setSpriteFrame("card_break.png")
    end

    self._gameView:StopCompareCard()
    local myChair = self:GetMeChairID()
    local count = self:getPlayingNum()
    if count > 1 then  
        if self.m_wCurrentUser == self:GetMeChairID() then
            self:UpdataControl()
        end
        self:SetGameClock(self.m_wCurrentUser, cmd.IDI_USER_ADD_SCORE, cmd.TIME_USER_ADD_SCORE)
    else
        if self.m_cbPlayStatus[myChair+1] == 1 or  myChair == self.m_wLostUser then
            local sendBuffer = CCmd_Data:create(0)
            self:SendData(cmd.SUB_C_FINISH_FLASH, sendBuffer)
        end
    end

    if myChair == self.m_wWinnerUser then
        self:PlaySound(cmd.RES.."sound_res/COMPARE_WIN.wav")
    elseif myChair == self.m_wLostUser then
        self:PlaySound(cmd.RES.."sound_res/COMPARE_LOSE.wav")
    end
end

--游戏结算
function GameLayer:onSubGiveUp(dataBuffer)

    local wGiveUpUser = dataBuffer:readword()
    local viewid = self:SwitchViewChairID(wGiveUpUser)
    self._gameView:SetUserGiveUp(viewid,true)

    self.m_cbPlayStatus[wGiveUpUser+1] = 0

    --超时服务器自动放弃
    if wGiveUpUser == self:GetMeChairID() then
        self:KillGameClock()
        self._gameView:StopCompareCard()
        self._gameView:SetCompareCard(false, nil)
        self._gameView.m_ChipBG:setVisible(false)
        self._gameView.nodeButtomButton:setVisible(false)
    end

    self:PlaySound(cmd.RES.."sound_res/GIVE_UP.wav")
end

--设置基数
function GameLayer:onSubPlayerExit(dataBuffer)
    local wPlayerID = dataBuffer:readword()
    local wViewChairId = self:SwitchViewChairID(wPlayerID)
    self.m_cbPlayStatus[wPlayerID + 1] = 0
    self._gameView.nodePlayer[wViewChairId]:setVisible(false)
end

--设置基数
function GameLayer:onSubGameEnd(dataBuffer)
    self:KillGameClock()
    self.m_bStartGame = false

    local MyChair = self:GetMeChairID() + 1

     --清理界面
    self._gameView:StopCompareCard()
    self._gameView:SetCompareCard(false)
    self._gameView.m_ChipBG:setVisible(false)
    self._gameView.nodeButtomButton:setVisible(false)
    self._gameView.m_GameEndView:ReSetData()

    local endShow 

    local int64 = Integer64.new()

    local lGameTax = dataBuffer:readscore(int64):getvalue()

    local winner 
    local lGameScore = {}
    for i = 1, cmd.GAME_PLAYER do
        lGameScore[i] = dataBuffer:readscore(int64):getvalue()
        if lGameScore[i] > 0 then
            winner = i
        else
            winner = 0
        end
    end

    --用户扑克
    local cbCardData = {}
    for i = 1, cmd.GAME_PLAYER do
        cbCardData[i] = {}
        for j = 1, 3 do
            cbCardData[i][j] = dataBuffer:readbyte()
        end
    end

    --比牌用户
    local wCompareUser = {}
    for i = 1, cmd.GAME_PLAYER  do
        wCompareUser[i] = {}
        for j = 1, 4 do
            wCompareUser[i][j] = dataBuffer:readword()
        end
    end

    local wEndState = dataBuffer:readword()

    local bDelayOverGame = dataBuffer:readbool()

    local wServerType = dataBuffer:readword()

    local savetype = {}

    --移动筹码
    for i = 1, cmd.GAME_PLAYER do
        local viewid = self:SwitchViewChairID(i-1)
        if lGameScore[i] ~= 0 then
            if lGameScore[i] > 0 then
                self._gameView:SetUserTableScore(viewid,"+"..lGameScore[i])
                self._gameView:WinTheChip(viewid)
                if viewid == cmd.MY_VIEWID then
                    print("播放胜利音乐")
                    self:PlaySound(cmd.RES.."sound_res/GAME_WIN.wav")
                else
                    self:PlaySound(cmd.RES.."sound_res/GAME_LOSE.wav")
                end
            else
                self._gameView:SetUserTableScore(viewid,lGameScore[i])
            end

            endShow = true
            self._gameView.m_GameEndView:SetUserScore(viewid, lGameScore[i])
            self._gameView.m_GameEndView:SetUserCard(viewid,nil,nil,lGameScore[i]<0)
            local userItem = self._gameFrame:getTableUserItem(self._gameFrame:GetTableID(), i-1)
            self._gameView.m_GameEndView:SetUserInfo(viewid,userItem)
            self._gameView.m_GameEndView:SetWinFlag(viewid, lGameScore[i])
            savetype[i] = GameLogic:getCardType(cbCardData[i])

            print("savetype["..i.."]"..savetype[i])
        else
            savetype[i] = 0
            self._gameView:SetUserTableScore(viewid)
        end
    end
    
    for i = 1 , cmd.GAME_PLAYER - 1 do
        local wUserID = wCompareUser[MyChair][i]
        if wUserID and wUserID ~= yl.INVALID_CHAIR then
            local viewid = self:SwitchViewChairID(wUserID)
            local cardIndex = {}
            for k = 1 , 3 do
                cardIndex[k] = GameLogic:getCardColor(cbCardData[wUserID+1][k])*13 + GameLogic:getCardValue(cbCardData[wUserID+1][k])
            end
            self._gameView:SetUserCard(viewid, cardIndex)
            self._gameView:SetUserCardType(viewid, savetype[wUserID+1])
            self._gameView.m_GameEndView:SetUserCard(viewid,cardIndex,savetype[wUserID+1])
        end
    end
    --比过牌或看过牌，才能显示自己的牌
    if wCompareUser[MyChair][1] ~= yl.INVALID_CHAIR or self.m_bLookCard[MyChair] == true then
        local cardIndex = {}
        for k = 1 , 3 do
             cardIndex[k] = GameLogic:getCardColor(cbCardData[MyChair][k])*13 + GameLogic:getCardValue(cbCardData[MyChair][k])
        end
        self._gameView:SetUserCard(cmd.MY_VIEWID, cardIndex)
        self._gameView:SetUserCardType(cmd.MY_VIEWID, savetype[MyChair])
        self._gameView.m_GameEndView:SetUserCard(cmd.MY_VIEWID,cardIndex,savetype[MyChair])
    end

    if wEndState == 1 then
        if self.m_cbPlayStatus[MyChair] == 1 then
            for i =1 , cmd.GAME_PLAYER do
                if self.m_cbPlayStatus[i] == 1 then
                    local cardIndex = {}
                    for k = 1 , 3 do
                        cardIndex[k] = GameLogic:getCardColor(cbCardData[i][k])*13 + GameLogic:getCardValue(cbCardData[i][k])
                    end
                    local viewid = self:SwitchViewChairID(i-1)
                    self._gameView:SetUserCard(viewid, cardIndex)
                    self._gameView:SetUserCardType(viewid, savetype[i])
                    self._gameView.m_GameEndView:SetUserCard(viewid,cardIndex,savetype[i])
                end
            end
        end
    end



    if endShow then
        self._gameView.m_GameEndView:setVisible(true)
    end
    
    self._gameView.btReady:setVisible(true)
    if not GlobalUserItem.bPrivateRoom then
        -- 设置倒计时
        self:SetGameClock(self:GetMeChairID(),cmd.IDI_START_GAME,cmd.TIME_START_GAME)
    end 
    

    self.m_cbPlayStatus = {0, 0, 0, 0, 0}
    self.nVoiceFollow = {0, 0, 0, 0, 0}
    self:PlaySound(cmd.RES.."sound_res/GAME_END.wav")

    if 0 ~=  winner then
        if lGameScore[winner]/self.m_lCellScore > 100 then
            self:PlaySound(cmd.RES.."sound_res/GET_MORECOIN.wav")
        else
            self:PlaySound(cmd.RES.."sound_res/GET_COIN.wav")
        end
    end

end

--更新秘钥
function GameLayer:onSubUpdateAesKey(dataBuffer)
    for i = 1, 16 do
        self.chUserAESKey[i] = dataBuffer:readbyte()
    end
end

--等待比牌
function GameLayer:onSubWaitCompare(dataBuffer)
    local wCompareUser = dataBuffer:readword()
    assert(wCompareUser == self.m_wCurrentUser , "onSubWaitCompare assert wCompareUser ~= m_wCurrentUser")
    if self.m_wCurrentUser ~= self:GetMeChairID() then
        self:SetGameClock(self.m_wCurrentUser, cmd.IDI_DISABLE, cmd.TIME_USER_COMPARE_CARD)
    end
end

function GameLayer:onSubNoticeAddScore(szString)
    --设置准备按钮不可见
    self.m_bNoScore = true

    if self.m_bStartGame then
        local msg = szString or "你的金币不足，无法继续游戏"
        self.m_querydialog = QueryDialog:create(msg,function()
            self:onExitTable()
        end,nil,1)
        self.m_querydialog:setCanTouchOutside(false)
        self.m_querydialog:addTo(self)
    else
        self.m_bNoScore = true
        self.m_szScoreMsg = szString
    end
end


--发送准备
function GameLayer:onStartGame(bReady)
    self:OnResetGameEngine()
    if bReady == true then
        self:SendUserReady()
        self.m_bStartGame = true
    end
end

--自动比牌
function GameLayer:onAutoCompareCard()

    local MyChair = self:GetMeChairID() + 1

    for i = 1 , cmd.GAME_PLAYER - 1 do
        local chair = MyChair - i
        if chair < 1 then
            chair = chair + cmd.GAME_PLAYER
        end
        if self.m_cbPlayStatus[chair] == 1 then
            --发送比牌消息
            local dataBuffer = CCmd_Data:create(2)
            dataBuffer:pushword(chair - 1)
            self:SendData(cmd.SUB_C_COMPARE_CARD,dataBuffer)
            break
        end
    end
end

--比牌操作
function GameLayer:onCompareCard()
    local MyChair = self:GetMeChairID()
    if not MyChair or MyChair ~= self.m_wCurrentUser then
        return
    end
    MyChair = MyChair + 1
    self._gameView.nodeButtomButton:setVisible(false)

    local playerCount = self:getPlayingNum() 

    if playerCount < 2 then
        return
    end
     
    self:KillGameClock()

    local score = self.m_lCurrentTimes*self.m_lCellScore*(self.m_bLookCard[MyChair] == true and 4 or 2)

    print("onCompareCard score:"..score)
    self.m_lTableScore[MyChair] = self.m_lTableScore[MyChair] + score
    self.m_lAllTableScore = self.m_lAllTableScore + score
    self._gameView:PlayerJetton(cmd.MY_VIEWID, score)
    self._gameView:SetUserTableScore(cmd.MY_VIEWID, self.m_lTableScore[MyChair])
    self._gameView:SetAllTableScore(self.m_lAllTableScore)

    
    self:onSendAddScore(score, true)--发送下注消息

    local bAutoCompare = (self:getPlayingNum() == 2)
    if not bAutoCompare then
        bAutoCompare =((self.m_wBankerUser+1) == MyChair and (self.m_lTableScore[MyChair]-score) == self.m_lCellScore) 
    end

    if bAutoCompare then
        self:onAutoCompareCard()
    else
        local compareStatus={false,false,false,false,false}
        for i = 1 ,cmd.GAME_PLAYER do
            if self.m_cbPlayStatus[i] == 1 and i ~= MyChair then
                compareStatus[self:SwitchViewChairID(i-1)] = true
            end
        end
        self._gameView:SetCompareCard(true,compareStatus)
       
        --发送等待比牌消息
        local compareBuffer = CCmd_Data:create(0)
        self:SendData(cmd.SUB_C_WAIT_COMPARE,compareBuffer)
        self:SetGameClock(self.m_wCurrentUser, cmd.IDI_USER_COMPARE_CARD, cmd.TIME_USER_COMPARE_CARD)
    end
end

function  GameLayer:OnCompareChoose(index)
    if not index or index == yl.INVALID_CHAIR then
        print("OnCompareChoose error index")
        return
    end
    local MyChair = self:GetMeChairID()
    if self.m_wCurrentUser ~= MyChair then
        print("OnCompareChoose not m_wCurrentUser")
        return
    end
    MyChair = MyChair+1
    for i = 1 ,cmd.GAME_PLAYER do
        if i ~= MyChair and self.m_cbPlayStatus[i] == 1 and index == self:SwitchViewChairID(i-1) then
            self._gameView:SetCompareCard(false)
            self:KillGameClock()
            --发送比牌消息
            local dataBuffer = CCmd_Data:create(2)
            dataBuffer:pushword(i - 1)
            self:SendData(cmd.SUB_C_COMPARE_CARD,dataBuffer)
            break
        end
    end

end

--放弃操作
function GameLayer:onGiveUp()
    --删除计时器
    self:KillGameClock()
    --隐藏操作按钮
    self._gameView.nodeButtomButton:setVisible(false)
    --发送数据
    local dataBuffer = CCmd_Data:create(0)
    self:SendData(cmd.SUB_C_GIVE_UP,dataBuffer)
end

--换位操作
function GameLayer:onChangeDesk()
    self._gameFrame:QueryChangeDesk()
end

--看牌操作
function GameLayer:onLookCard()
    local MyChair = self:GetMeChairID()
    if not MyChair or MyChair == yl.INVALID_CHAIR then
        return
    end

    if self.m_wCurrentUser ~= MyChair then
        return
    end
    self.m_bLookCard[MyChair + 1] = true
    self._gameView.btLookCard:setColor(cc.c3b(158, 112, 8))
    self._gameView.btLookCard:setEnabled(false)
    --发送消息
    local dataBuffer = CCmd_Data:create(0)
    self:SendData(cmd.SUB_C_LOOK_CARD,dataBuffer)
end

--下注操作
function GameLayer:addScore(index)
    local MyChair = self:GetMeChairID()
    if self.m_wCurrentUser ~= MyChair then
        return
    end

    MyChair = MyChair + 1

    self:KillGameClock()
    --清理界面
    self._gameView.m_ChipBG:setVisible(false)
    self._gameView.nodeButtomButton:setVisible(false)

    --下注金额
    local scoreIndex = (not index and 0 or index)
    local score = self.m_lCellScore*self.m_lCurrentTimes + self.m_lCellScore*scoreIndex

    --看牌加倍
    if self.m_bLookCard[MyChair] == true then
        score = score*2
    end

    self.m_lTableScore[MyChair] = self.m_lTableScore[MyChair] + score
    self.m_lAllTableScore = self.m_lAllTableScore + score
    self._gameView:PlayerJetton(cmd.MY_VIEWID, score)
    self._gameView:SetUserTableScore(cmd.MY_VIEWID, self.m_lTableScore[MyChair])
    self._gameView:SetAllTableScore(self.m_lAllTableScore)

    --发送数据
    self:onSendAddScore(score, false)
end

--发送加注消息
function GameLayer:onSendAddScore(score, bCompareCard)
    local  dataBuffer = CCmd_Data:create(10)
    dataBuffer:pushscore(score)
    dataBuffer:pushword(bCompareCard and 1 or 0)
    
    -- local aesKey = self:getAesKey()     --加密
    -- for i = 1, 16 do
    --     dataBuffer:pushbyte(aesKey[i])
    -- end
    self:SendData(cmd.SUB_C_ADD_SCORE, dataBuffer)
end

--更新按钮控制
function GameLayer:UpdataControl()
    local MyChair = self:GetMeChairID() 
    if not MyChair or MyChair == yl.INVALID_CHAIR then
        print("UpdataControl myChair is"..(not MyChair and "nil" or "INVALID_CHAIR"))
        return
    end
    MyChair = MyChair + 1
    self._gameView.nodeButtomButton:setVisible(true)
    self._gameView.m_ChipBG:setVisible(false)

    --看牌按钮
    if not self.m_bLookCard[MyChair] then
        self._gameView.btLookCard:setColor(cc.c3b(255, 255, 255))
        self._gameView.btLookCard:setEnabled(true)
    else        
        self._gameView.btLookCard:setColor(cc.c3b(158, 112, 8))
        self._gameView.btLookCard:setEnabled(false)
    end

    self._gameView.btGiveUp:setColor(cc.c3b(255, 255, 255))
    self._gameView.btGiveUp:setEnabled(true)

    local userCount = self:getPlayingNum()
    print("更新按钮控制时参数 times cellscore MaxCellScore", self.m_lCurrentTimes, self.m_lCellScore, self.m_lMaxCellScore)
    local lTempTime =(self.m_bLookCard[MyChair] == true and 6 or 5)
    if self.m_lUserMaxScore - self.m_lTableScore[MyChair] >= 
        self.m_lCellScore*(lTempTime + self.m_lCurrentTimes) + (userCount - 1)*self.m_lCurrentTimes*self.m_lCellScore*4 then
        --查找上家
        local perUser
        for i = 1 , cmd.GAME_PLAYER - 1 do
            local tmpchair = MyChair - i
            if tmpchair < 1 then
                tmpchair = tmpchair + cmd.GAME_PLAYER
            end
            if self.m_cbPlayStatus[tmpchair] == 1 then
                perUser = tmpchair
                break
            end
        end
        --跟注按钮
        if perUser and (self.m_lTableScore[perUser] == self.m_lCellScore) then
            self._gameView.btFollow:setColor(cc.c3b(158, 112, 8))
            self._gameView.btFollow:setEnabled(false) 
        else
            self._gameView.btFollow:setColor(cc.c3b(255, 255, 255))
            self._gameView.btFollow:setEnabled(true)
        end

        --加注按钮
        if((self.m_lCurrentTimes*self.m_lCellScore) < self.m_lMaxCellScore) then
            self._gameView.btAddScore:setColor((self.m_lCurrentTimes<=9) and cc.c3b(255, 255, 255) or cc.c3b(158, 112, 8))
            self._gameView.btAddScore:setEnabled(self.m_lCurrentTimes<=9)
            self._gameView.btChip[1]:setEnabled(self.m_lCurrentTimes<=9)
            self._gameView.btChip[2]:setEnabled(self.m_lCurrentTimes<=8)
            self._gameView.btChip[3]:setEnabled(self.m_lCurrentTimes<=5)
        else
            self._gameView.btAddScore:setColor(cc.c3b(158, 112, 8))
            self._gameView.btAddScore:setEnabled(false)
            self._gameView.btChip[1]:setEnabled(false)
            self._gameView.btChip[2]:setEnabled(false)
            self._gameView.btChip[3]:setEnabled(false)
        end  

        --比牌按钮
        if self.m_wBankerUser == MyChair - 1 or self.m_lTableScore[MyChair] >= 2*self.m_lCellScore then
            self._gameView.btCompare:setColor(cc.c3b(255, 255, 255))
            self._gameView.btCompare:setEnabled(true)
        else
            self._gameView.btCompare:setColor(cc.c3b(158, 112, 8))
            self._gameView.btCompare:setEnabled(false)     
        end  

    else
        print("不能再下注了！！！")
        self._gameView.btCompare:setColor(cc.c3b(255, 255, 255))
        self._gameView.btCompare:setEnabled(true)

        self._gameView.btAddScore:setColor(cc.c3b(158, 112, 8))
        self._gameView.btAddScore:setEnabled(false)
        self._gameView.btFollow:setColor(cc.c3b(158, 112, 8))
        self._gameView.btFollow:setEnabled(false)

        self._gameView.btChip[1]:setEnabled(false)
        self._gameView.btChip[2]:setEnabled(false)
        self._gameView.btChip[3]:setEnabled(false)
    end

end

function GameLayer:onUserChat(chatinfo,sendchair)
    if chatinfo and sendchair then
        local viewid = self:SwitchViewChairID(sendchair)
        if viewid and viewid ~= yl.INVALID_CHAIR then
            self._gameView:ShowUserChat(viewid, chatinfo.szChatString)
        end
    end
end

function GameLayer:onUserExpression(expression,sendchair)
    if expression and sendchair then
        local viewid = self:SwitchViewChairID(sendchair)
        if viewid and viewid ~= yl.INVALID_CHAIR then
            self._gameView:ShowUserExpression(viewid, expression.wItemIndex)
        end
    end
end

-- 语音播放开始
function GameLayer:onUserVoiceStart( useritem, filepath )
    local viewid = self:SwitchViewChairID(useritem.wChairID)
    if viewid and viewid ~= yl.INVALID_CHAIR then
        self._gameView:ShowUserVoice(viewid, true)
    end
end

-- 语音播放结束
function GameLayer:onUserVoiceEnded( useritem, filepath )
    local viewid = self:SwitchViewChairID(useritem.wChairID)
    if viewid and viewid ~= yl.INVALID_CHAIR then
        self._gameView:ShowUserVoice(viewid, false)
    end
end

--获得加密Key
function GameLayer:getAesKey()
    --将数组转成字符串
    local strInput = ""
    for i = 1, #self.chUserAESKey do
        strInput = strInput .. string.format("%d,", self.chUserAESKey[i])
     end
     --加密
    local result = AesCipher(strInput)
    --将字符串转成数组
    local resultKey = {}
    local k = 1
    local num = 0
    for i = 1, string.len(result) do
        if string.sub(result, i, i) ~= ',' then
            local bt = string.byte(result, i) - string.byte("0")
            num = num*10 + bt
        else
            resultKey[k] = num
            k = k + 1
            num = 0
        end
    end

    return resultKey
end
return GameLayer