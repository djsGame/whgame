local module_pre = "game.yule.egyptslots.src"
local ScollNumLayer = appdf.req(module_pre .. ".views.layer.ScollNumLayer")
local Treasure = class("Treasure", cc.Layer)
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")
Treasure.RES_PATH              = "game/yule/egyptslots/res/"
Treasure.BT_HOME = 1

local enGameLayer = 
{
	"TAG_BOX11",		--1
	"TAG_BOX12",		--2
	"TAG_BOX13",		--3
	"TAG_BOX14",		--4
	"TAG_BOX15",		--5	
	"TAG_BOX21",		--6
	"TAG_BOX22",		--7
	"TAG_BOX23",		--8
	"TAG_BOX24",		--9	
	"TAG_BOX25",		--10
	"TAG_BOX31",		--11
	"TAG_BOX32",		--12
	"TAG_BOX33",		--13
	"TAG_BOX34",		--14
	"TAG_BOX35",		--15
	"TAG_BOX41",		--16
	"TAG_BOX42",		--17
	"TAG_BOX43",		--18
	"TAG_BOX44",		--19
	"TAG_BOX45",		--20
	"TAG_BOMB21",		--21
	"TAG_BOMB22",		--22
	"TAG_BOMB23",		--23
	"TAG_BOMB24",		--24
	"TAG_BOMB25",		--25
	"TAG_BOMB31",		--26
	"TAG_BOMB32",		--27
	"TAG_BOMB33",		--28
	"TAG_BOMB34",		--29
	"TAG_BOMB35",		--30
	"TAG_BOMB41",		--31
	"TAG_BOMB42",		--32
	"TAG_BOMB43",		--33
	"TAG_BOMB44",		--34
	"TAG_BOMB45",		--35
	"TAG_SINGLE_SCORE",	--36
	"",
	"TAG_TOTAL_SCORE",	--37
	"TAG_TIMES",		--38
	"TAG_GET_TREASURE",	--39
	"TAG_WIN_COUNT"		--40
}

local TAG_ENUM = ExternalFun.declarEnumWithTable(Treasure.TAG_START, enGameLayer)

function Treasure:ctor(treasureClick,cbBombInfo, lScore, lBeiShu)
    --注册触摸事件
    ExternalFun.registerTouchEvent(self, true)
	local function btnEvent( sender, eventType )
        if eventType == ccui.TouchEventType.began then
			self:onButtonClickedEvent_treasure(sender:getTag(), sender)
			--ExternalFun.popupTouchFilter(1, false)
        elseif eventType == ccui.TouchEventType.canceled then
            --ExternalFun.dismissTouchFilter()
        elseif eventType == ccui.TouchEventType.ended then
            --ExternalFun.dismissTouchFilter()
		elseif eventType == ccui.TouchEventType.moved then
            --ExternalFun.dismissTouchFilter()	
        end
    end
	--断线重连
	self.m_duanxian = nil
	self.m_lScore = nil
	self.m_lBeiShu = nil
	--加载宝藏界面
	local csbNodeTreasure = ExternalFun.loadCSB(Treasure.RES_PATH.."nodeTreasure.csb", self)
	csbNodeTreasure:setPosition(cc.p(1334/2,750/2))
	--宝藏获得
	local getTreasure = csbNodeTreasure:getChildByName("getTreasure")
		:setTag(TAG_ENUM.TAG_GET_TREASURE)
		:setVisible(false)
	self.getTreasure = getTreasure
	local winCount = getTreasure:getChildByName("winCount")
		:setTag(TAG_ENUM.TAG_WIN_COUNT)
	local bk = csbNodeTreasure:getChildByName("bk")
	local box11 = bk:getChildByName("checkBox_11")--checkBox_11
		box11:setTag(TAG_ENUM.TAG_BOX11)
		box11:addTouchEventListener(btnEvent)
	local box12 = bk:getChildByName("checkBox_12")
		:setTag(TAG_ENUM.TAG_BOX12)
		:addTouchEventListener(btnEvent)
	local box13 = bk:getChildByName("checkBox_13")
		:setTag(TAG_ENUM.TAG_BOX13)
	box13:addTouchEventListener(btnEvent)
	local box14 = bk:getChildByName("checkBox_14")
		:setTag(TAG_ENUM.TAG_BOX14)
		:addTouchEventListener(btnEvent)
	local box15 = bk:getChildByName("checkBox_15")
		:setTag(TAG_ENUM.TAG_BOX15)
		:addTouchEventListener(btnEvent)
	local box21 = bk:getChildByName("checkBox_21")
		:setTag(TAG_ENUM.TAG_BOX21)
		:setBright(false)
		:setTouchEnabled(false)
		:addTouchEventListener(btnEvent)
	local box22 = bk:getChildByName("checkBox_22")
		:setTag(TAG_ENUM.TAG_BOX22)
		:setBright(false)
		:setTouchEnabled(false)
		:addTouchEventListener(btnEvent)
	local box23 = bk:getChildByName("checkBox_23")
		:setTag(TAG_ENUM.TAG_BOX23)
		:setBright(false)
		:setTouchEnabled(false)
		:addTouchEventListener(btnEvent)
	local box24 = bk:getChildByName("checkBox_24")
		:setTag(TAG_ENUM.TAG_BOX24)
		:setBright(false)
		:setTouchEnabled(false)
		:addTouchEventListener(btnEvent)
	local box25 = bk:getChildByName("checkBox_25")
		:setTag(TAG_ENUM.TAG_BOX25)
		:setBright(false)
		:setTouchEnabled(false)
		:addTouchEventListener(btnEvent)
	local box31 = bk:getChildByName("checkBox_31")
		:setTag(TAG_ENUM.TAG_BOX31)
		:setBright(false)
		:setTouchEnabled(false)
		:addTouchEventListener(btnEvent)
	local box32 = bk:getChildByName("checkBox_32")
		:setTag(TAG_ENUM.TAG_BOX32)
		:setBright(false)
		:setTouchEnabled(false)
		:addTouchEventListener(btnEvent)
	local box33 = bk:getChildByName("checkBox_33")
		:setTag(TAG_ENUM.TAG_BOX33)
		:setBright(false)
		:setTouchEnabled(false)
		:addTouchEventListener(btnEvent)
	local box34 = bk:getChildByName("checkBox_34")
		:setTag(TAG_ENUM.TAG_BOX34)
		:setBright(false)
		:setTouchEnabled(false)
		:addTouchEventListener(btnEvent)
	local box35 = bk:getChildByName("checkBox_35")
		:setTag(TAG_ENUM.TAG_BOX35)
		:setBright(false)
		:setTouchEnabled(false)
		:addTouchEventListener(btnEvent)
	local box41 = bk:getChildByName("checkBox_41")
		:setTag(TAG_ENUM.TAG_BOX41)
		:setBright(false)
		:setTouchEnabled(false)
		:addTouchEventListener(btnEvent)
	local box42 = bk:getChildByName("checkBox_42")
		:setTag(TAG_ENUM.TAG_BOX42)
		:setBright(false)
		:setTouchEnabled(false)
		:addTouchEventListener(btnEvent)
	local box43 = bk:getChildByName("checkBox_43")
		:setTag(TAG_ENUM.TAG_BOX43)
		:setBright(false)
		:setTouchEnabled(false)
		:addTouchEventListener(btnEvent)
	local box44 = bk:getChildByName("checkBox_44")
		:setTag(TAG_ENUM.TAG_BOX44)
		:setBright(false)
		:setTouchEnabled(false)
		:addTouchEventListener(btnEvent)
	local box45 = bk:getChildByName("checkBox_45")
		:setTag(TAG_ENUM.TAG_BOX45)
		:setBright(false)
		:setTouchEnabled(false)
		box45:addTouchEventListener(btnEvent)
	--炸弹
	for i = 1, 15 do
		local row = math.floor((i - 1) / 5) + 2
		local column = math.mod(i - 1,5) + 1
		local str = "bomb_"..row..column
		--print(str)
		local bomb = bk:getChildByName(str)
			:setTag(TAG_ENUM.TAG_BOMB21 + i -1)
			--:setVisible(false)
	end
	
	self.treasure_bk = bk

	--宝箱得分
	bk = self.treasure_bk:getChildByName("rect_bk")
	local singleScore = bk:getChildByName("atlasSingle")
		:setTag(TAG_ENUM.TAG_SINGLE_SCORE)
		:setAnchorPoint(0.0,0.5)
	local pos1 = singleScore:getContentSize()
	local multiple = self.treasure_bk:getChildByName("rect_bk"):getChildByName("multiple"):setVisible(false)
	local mulPosX,mulPosY = multiple:getPosition()
	multiple:setPosition(cc.p(pos1.width + mulPosX,mulPosY))
	local equal = self.treasure_bk:getChildByName("rect_bk"):getChildByName("equal"):setVisible(false)
	local times = bk:getChildByName("atlasCount"):setVisible(false)
		:setTag(TAG_ENUM.TAG_TIMES)
	local totalScore = bk:getChildByName("atlasCount_all")
		:setTag(TAG_ENUM.TAG_TOTAL_SCORE)
		:setVisible(false)
	--播放背景音乐
	ExternalFun.playBackgroudAudio("treasureBK.mp3")
	--箱子晃动
	self.m_boxShake = {}
	self.m_boxShakeAni = {}
	for i = 1, 4 do
		local path = ""
		local str = "res/treasure/boxShake/"..i.."/".."boxShake0"..i..".csb"
		self.m_boxShake[i] = ExternalFun.loadCSB(str, self.treasure_bk)
		--self.m_boxShake[i]:setVisible(false)
	end
	--开箱子
	self.m_openBox = ExternalFun.loadCSB("res/treasure/openBox/openBox.csb", self.treasure_bk)
		:setVisible(false)
	--爆炸
	self.m_explode = ExternalFun.loadCSB("res/treasure/explode/explode.csb", self.treasure_bk)
		:setVisible(false)
	--断线重连
	if treasureClick ~= nil then
		self.m_duanxian = true
		for i = 1, #treasureClick do
			if treasureClick[i] ~= 0 then
				--self:game2BombTimes(cbBombInfo[i],i)
				self:openBox(treasureClick[i] + 1, 5, false)
			end
		end
		--self:updataScore(lScore, lBeiShu, lScore * lBeiShu)
		self.m_lScore = lScore
		self.m_lBeiShu = lBeiShu
	end
end

function Treasure:openBox(index, number, bBomb)
	local row = math.floor((index - 1) / 5) + 1		--点击的宝箱所在位置行数
	local column = math.mod((index - 1), 5) + 1		--点击宝箱所在位置列数
	if index <= 20 then 
		if bBomb == false then	
			self:runAction(cc.Sequence:create(
				cc.CallFunc:create(function()
					for i = 1, number do	--使其它箱子不可以点击
						local box = self.treasure_bk:getChildByTag(i + (row - 1) * 5 )
						if box ~= nil then
							if i ~= column then
								box:setTouchEnabled(false)
							end	
						end
					end
					self.treasure_bk:getChildByTag(index):setVisible(false)
					--self:boxShakeAni(index)	--晃动箱子
				end),
				--cc.DelayTime:create(1.5),
				cc.CallFunc:create(function()	--打开箱子
					ExternalFun.playSoundEffect("openBox.mp3")
					self.treasure_bk:getChildByTag(index):setVisible(true)
					self.treasure_bk:getChildByTag(index):setSelected(true)
				end),
				cc.CallFunc:create(function()	--宝箱闪光
					--self:openBoxAni(index)
				end),
				--cc.DelayTime:create(0.2),
				cc.CallFunc:create(function()	--显示先点中宝箱的倍数
					self:game2BombTimes(self:getParent()._scene.cbBombInfo[row], row, column)
					--if self.m_duanxian ~= true then
						--self:updataScore(self:getParent()._scene.m_lScore, self:getParent()._scene.m_nYaLienCount, self:getParent()._scene.m_lYaZhubScore)
					--else
						self:updataScore(self.m_lScore,self.m_lBeiShu,self.m_lBeiShu * self.m_lScore)
					--end
				end),
				--cc.DelayTime:create(0.8),
				cc.CallFunc:create(function()	--打开其它箱子，显示倍数
					self:game2BombTimes(self:getParent()._scene.cbBombInfo[row], row)
					for i = 1, number do
						local box = self.treasure_bk:getChildByTag(i + (row - 1) * 5 )
						if box ~= nil then
							box:setSelected(true)
							box:setTouchEnabled(false)
							if i ~= column then
								box:setBright(false)
							end	
						end
					end
				end),
				--cc.DelayTime:create(0.8),
				cc.CallFunc:create(function()	--没有点中炸弹，继续下一行
					if row < 4 then
						for i = 1, 5 do
							local box = self.treasure_bk:getChildByTag(i + row * 5 )
							:setBright(true)
							box:setTouchEnabled(true)
						end
					elseif row == 4 then
						self:onTreasureEnd(4)
					end
				end)
			))
		end
	end
end
--箱子晃动动画
function Treasure:boxShakeAni(indexOfBox)
	local row = math.floor((indexOfBox - 1) / 5) + 1		--宝箱所在位置行数
	local box = self.treasure_bk:getChildByTag(indexOfBox)
	self.m_boxShake[row]:setPosition(box:getPosition())
	self.m_boxShake[row]:setVisible(true)
	self.m_boxShakeAni[row] = ExternalFun.loadTimeLine("res/treasure/boxShake/"..row.."/".."boxShake0"..row..".csb")
	ExternalFun.SAFE_RETAIN(self.m_boxShakeAni[row])
	self.m_boxShake[row]:stopAllActions()
	self.m_boxShakeAni[row]:gotoFrameAndPlay(0,true)
	
	local shakBox = cc.CallFunc:create(
			function()
				self.m_boxShake[row]:runAction(self.m_boxShakeAni[row])
			end
		) 
	
	local close = cc.CallFunc:create(
			function()
				self.m_boxShake[row]:setVisible(false)
			end
		)
	
	local seq = cc.Sequence:create(shakBox,cc.DelayTime:create(1.5),close )
	self:runAction(seq)
	
--[[	self:runAction(cc.Repeat:create( cc.Sequence:create(
		cc.CallFunc:create(
		function()
			self.m_boxShake[row]:runAction(self.m_boxShakeAni[row])
		end
		),
		cc.DelayTime:create(0.8)),
		cc.CallFunc:create(
		function()
			self.m_boxShake[row]:setVisible(false)
		end
		)))--]]
end
--炸弹动画
function Treasure:explodeAni(indexOfBox)
	local bomb = self.treasure_bk:getChildByTag(indexOfBox)
		:setVisible(false)
	local tempx,tempy = bomb:getPosition()
	self.m_explode:setPosition(cc.p(tempx + 20,tempy))
	self.m_explode:setVisible(true)
	self.m_explodeAni = ExternalFun.loadTimeLine( "res/treasure/explode/explode.csb" )
	ExternalFun.SAFE_RETAIN(self.m_explodeAni)
	self.m_explode:stopAllActions()
	self.m_explodeAni:gotoFrameAndPlay(0,false)
	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(
		function()
			ExternalFun.playSoundEffect("bomb.mp3")
			self.m_explode:runAction(self.m_explodeAni)
		end
		),
		cc.DelayTime:create(0.3),
		cc.CallFunc:create(
		function()
			self.m_explode:setVisible(false)
		end
		)))
end
--开箱子动画
function Treasure:openBoxAni(indexOfBox)
	local box = self.treasure_bk:getChildByTag(indexOfBox)
	self.m_openBox:setPosition(box:getPosition())
	self.m_openBox:setVisible(true)
	self.m_openBoxAni = ExternalFun.loadTimeLine( "res/treasure/openBox/openBox.csb" )
	ExternalFun.SAFE_RETAIN(self.m_openBoxAni)
	self.m_openBox:stopAllActions()
	self.m_openBoxAni:gotoFrameAndPlay(0,true)
	
	self:runAction(cc.Sequence:create(
		cc.CallFunc:create(
		function()
			ExternalFun.playSoundEffect("openBox.mp3")
			self.m_openBox:runAction(self.m_openBoxAni)
		end
		),
		cc.DelayTime:create(1.5),
		cc.CallFunc:create(
		function()
			self.m_openBox:setVisible(false)
		end
		)))
end
--显示一行宝箱倍数并显示炸弹（隐藏箱子）
function Treasure:game2BombTimes(cbBombInfo,row, column)
	if column == nil then
		for i = 1, #cbBombInfo do
			print("宝箱序号宝箱序号"..TAG_ENUM.TAG_BOX11 + i -1 + (row - 1) * 5)
			local box = self.treasure_bk:getChildByTag(i  + (row - 1) * 5)
			if box ~= nil then
				if cbBombInfo[i] ~= 255 then
					local bombTimes = cc.Label:createWithTTF(cbBombInfo[i].."倍","round_body.ttf", 40)
					bombTimes:setTextColor(cc.c4b(239,251,0,255))
					bombTimes:enableOutline(cc.c4b(255,0,0,255), 3)
					bombTimes:setPosition(cc.p(60,55))
					bombTimes:setAnchorPoint(0.5,0.0)
					bombTimes:addTo(box)
				else
					box:setVisible(false)
				end
			end
		end
	else
		local box = self.treasure_bk:getChildByTag(column  + (row - 1) * 5)
		if box ~= nil then
			if cbBombInfo[column] ~= 255 then
				local bombTimes = cc.Label:createWithTTF(cbBombInfo[column].."倍","round_body.ttf", 40)
				bombTimes:setTextColor(cc.c4b(239,251,0,255))
				bombTimes:enableOutline(cc.c4b(255,0,0,255), 3)
				bombTimes:setPosition(cc.p(60,55))
				bombTimes:setAnchorPoint(0.5,0.0)
				bombTimes:addTo(box)
			else
				box:setVisible(false)
			end
		end
	end
end
--打开宝箱,index是所点击数的宝箱的值，nmumber是需要打开宝箱的数量，并使上一行宝箱可以点击
function Treasure:game2OpenBox(index, number, bBomb)
	local row = math.floor((index - 1) / 5) + 1		--点击的宝箱所在位置行数
	local column = math.mod((index - 1), 5) + 1		--点击宝箱所在位置列数
	if index <= 20 then 
		if bBomb == false then	
			self:runAction(cc.Sequence:create(
				cc.CallFunc:create(function()
					for i = 1, number do	--使一排所有箱子不可以点击
						local box = self.treasure_bk:getChildByTag(i + (row - 1) * 5 )
						if box ~= nil then
							--if i ~= column then
								box:setTouchEnabled(false)
							--end	
						end
					end
					self.treasure_bk:getChildByTag(index):setVisible(false)
					self:boxShakeAni(index)	--晃动箱子
				end),
				cc.DelayTime:create(1.5),
				cc.CallFunc:create(function()	--打开箱子
					ExternalFun.playSoundEffect("openBox.mp3")
					self.treasure_bk:getChildByTag(index):setVisible(true)
					self.treasure_bk:getChildByTag(index):setSelected(true)
				end),
				cc.CallFunc:create(function()	--宝箱闪光
					self:openBoxAni(index)
				end),
				cc.DelayTime:create(0.2),
				cc.CallFunc:create(function()	--显示先点中宝箱的倍数
					self:game2BombTimes(self:getParent()._scene.cbBombInfo[row], row, column)
					print("11111111 = ",self:getParent()._scene.m_lScore)
					print("22222222 = ",self:getParent()._scene.m_nYaLienCount)
					print("33333333 = ",self:getParent()._scene.m_lYaZhubScore)
					self:updataScore(self:getParent()._scene.m_lScore, self:getParent()._scene.m_nYaLienCount, self:getParent()._scene.m_lYaZhubScore)
				end),
				cc.DelayTime:create(0.8),
				cc.CallFunc:create(function()	--打开其它箱子，显示倍数
					self:game2BombTimes(self:getParent()._scene.cbBombInfo[row], row)
					for i = 1, number do
						local box = self.treasure_bk:getChildByTag(i + (row - 1) * 5 )
						if box ~= nil then
							box:setSelected(true)
							box:setTouchEnabled(false)
							if i ~= column then
								box:setBright(false)
							end	
						end
					end
				end),
				cc.DelayTime:create(0.8),
				cc.CallFunc:create(function()	--没有点中炸弹，继续下一行
					if row < 4 then
						for i = 1, 5 do
							local box = self.treasure_bk:getChildByTag(i + row * 5 )
							:setBright(true)
							box:setTouchEnabled(true)
						end
					elseif row == 4 then
						self:onTreasureEnd(4)
					end
				end)
			))
		else	--点中炸弹
			self:runAction(cc.Sequence:create(
				cc.CallFunc:create(function()
					for i = 1, number do	--使其它箱子不可以点击
						local box = self.treasure_bk:getChildByTag(i + (row - 1) * 5 )
						if box ~= nil then
							if i ~= column then
								box:setTouchEnabled(false)
							end	
						end
					end
					self.treasure_bk:getChildByTag(index):setVisible(false)	--隐藏箱子
					self.treasure_bk:getChildByTag(index + 15):setVisible(false)	--隐藏炸弹
					self:boxShakeAni(index)	--晃动箱子
				end),
				cc.DelayTime:create(1.5),
				cc.CallFunc:create(function()	--炸弹爆炸
					self:explodeAni(index)
				end),
				cc.DelayTime:create(1.8),
				cc.CallFunc:create(function()	--打开所有宝箱
					if row <= 4 then
						for j = row, 4 do
							for i = 1, 5 do
								local box = self.treasure_bk:getChildByTag(i + (j - 1) * 5 )
								if box ~= nil then
									box:setSelected(true)
									box:setBright(false)
									box:setTouchEnabled(false)
								end
							end
							self:game2BombTimes(self:getParent()._scene.cbBombInfo[j],j)
						end
					end
				end),
				cc.DelayTime:create(1.0),
				cc.CallFunc:create(function()	--炸弹爆炸
					if self:getParent()._scene.m_cbBomb == 1 then
						self:onTreasureEnd(row)
					end
				end)
				))
		end
	end
end
--判断点击的宝箱是否是炸弹 index 数值 1 -20
function Treasure:isBomb(index)
	local row = math.floor((index - 1) / 5) + 1
	local column = math.mod((index - 1),5) + 1
	local temp = self:getParent()._scene.cbBombInfo
	for k, v in pairs(self:getParent()._scene.cbBombInfo[row]) do
		if k == column and v == 255 then --判断是否是炸弹
			print("bomb")
			--ExternalFun.playSoundEffect("bomb.mp3")
			--local box = self.treasure_bk:getChildByTag(TAG_ENUM.TAG_BOX11 + index -1 )
				--:removeFromParent()
				--:setVisible(false)
			--local bomb = self.treasure_bk:getChildByTag(TAG_ENUM.TAG_BOX11 + index -1 + 20 - 5)
				--:setVisible(false)
			--self:explode(index)
			return true --是炸弹返回true
		end
	end
	--ExternalFun.playSoundEffect("openBox.mp3")
	--self:openBoxAni(index)
	return false
end
--[[
	local singleScore = bk:getChildByName("atlasSingle")
		:setTag(TAG_ENUM.TAG_SINGLE_SCORE)
		:setAnchorPoint(0.0,0.5)
	local pos1 = singleScore:getContentSize()
	local multiple = self.treasure_bk:getChildByName("rect_bk"):getChildByName("multiple"):setVisible(false)
	local mulPosX,mulPosY = multiple:getPosition()
	multiple:setPosition(cc.p(pos1.width + mulPosX,mulPosY))
	local equal = self.treasure_bk:getChildByName("rect_bk"):getChildByName("equal"):setVisible(false)
	local times = bk:getChildByName("atlasCount"):setVisible(false)
		:setTag(TAG_ENUM.TAG_TIMES)
	local totalScore = bk:getChildByName("atlasCount_all")
]]
--更新宝藏得分
function Treasure:updataScore(singleScore, times, totalScore)
	local single_text = self.treasure_bk:getChildByName("rect_bk"):getChildByTag(TAG_ENUM.TAG_SINGLE_SCORE)
	single_text:setString(singleScore)
	local widthOfSingle_text = single_text:getContentSize().width
	local posOfSingle_text = single_text:getPositionX()	--x轴起点坐标
	
	local multiple = self.treasure_bk:getChildByName("rect_bk"):getChildByName("multiple")
	multiple:setVisible(true)
	local widthOfMul = multiple:getContentSize().width	--乘号字符宽度
	multiple:setPositionX(widthOfSingle_text + posOfSingle_text)
	
	local times_text = self.treasure_bk:getChildByName("rect_bk"):getChildByTag(TAG_ENUM.TAG_TIMES)
	times_text:setString(times)
	times_text:setVisible(true)
	local widthOfTimes = times_text:getContentSize().width --倍数字符宽度
	times_text:setPositionX(widthOfSingle_text + widthOfMul + posOfSingle_text)
	
	local equal = self.treasure_bk:getChildByName("rect_bk"):getChildByName("equal")
	equal:setVisible(true)
	local widthOfEqual = equal:getContentSize().width --等号字符宽度
	equal:setPositionX(widthOfSingle_text + widthOfMul + posOfSingle_text + widthOfTimes)
	
	local total_text = self.treasure_bk:getChildByName("rect_bk"):getChildByTag(TAG_ENUM.TAG_TOTAL_SCORE)
	total_text:setVisible(true)
	total_text:setPositionX(widthOfSingle_text + widthOfMul + posOfSingle_text + widthOfTimes + widthOfEqual)
	total_text:setString(totalScore)
	
	self.totalScore = totalScore
end

function Treasure:onButtonClickedEvent_treasure(tag,sender)
	
	if tag>=TAG_ENUM.TAG_BOX11 and tag<=TAG_ENUM.TAG_BOX45 then
		self:getParent()._scene:sendGame2Star( tag )
	end
--[[	if tag == TAG_ENUM.TAG_BOX11 then
		print("box11")
		self:getParent()._scene:sendGame2Star( tag )
	elseif tag == TAG_ENUM.TAG_BOX12 then
		print("box12")
		self:getParent()._scene:sendGame2Star( tag )
	elseif tag == TAG_ENUM.TAG_BOX13 then
		print("box13")
		self:getParent()._scene:sendGame2Star( tag )
	elseif tag == TAG_ENUM.TAG_BOX14 then
		print("box14")
		self:getParent()._scene:sendGame2Star( tag )
	elseif tag == TAG_ENUM.TAG_BOX15 then
		print("box15")
		self:getParent()._scene:sendGame2Star( tag )
	elseif tag == TAG_ENUM.TAG_BOX21 then
		print("box21")
		self:getParent()._scene:sendGame2Star( tag )
	elseif tag == TAG_ENUM.TAG_BOX22 then
		print("box22")
		self:getParent()._scene:sendGame2Star( tag )
	elseif tag == TAG_ENUM.TAG_BOX23 then
		print("box23")
		self:getParent()._scene:sendGame2Star( tag )
	elseif tag == TAG_ENUM.TAG_BOX24 then
		print("box24")
		self:getParent()._scene:sendGame2Star( tag )
	elseif tag == TAG_ENUM.TAG_BOX25 then
		print("box25")
		self:getParent()._scene:sendGame2Star( tag )
	elseif tag == TAG_ENUM.TAG_BOX31 then
		print("box31")
		self:getParent()._scene:sendGame2Star( tag )
	elseif tag == TAG_ENUM.TAG_BOX32 then
		print("box32")
		self:getParent()._scene:sendGame2Star( tag )
	elseif tag == TAG_ENUM.TAG_BOX33 then
		print("box33")
		self:getParent()._scene:sendGame2Star( tag )
	elseif tag == TAG_ENUM.TAG_BOX34 then
		print("box34")
		self:getParent()._scene:sendGame2Star( tag )
	elseif tag == TAG_ENUM.TAG_BOX35 then
		print("box35")
		self:getParent()._scene:sendGame2Star( tag )
	elseif tag == TAG_ENUM.TAG_BOX41 then
		print("box41")
		self:getParent()._scene:sendGame2Star( tag )
	elseif tag == TAG_ENUM.TAG_BOX42 then
		print("box42")
		self:getParent()._scene:sendGame2Star( tag )
	elseif tag == TAG_ENUM.TAG_BOX43 then
		print("box43")
		self:getParent()._scene:sendGame2Star( tag )
	elseif tag == TAG_ENUM.TAG_BOX44 then
		print("box44")
		self:getParent()._scene:sendGame2Star( tag )
	elseif tag == TAG_ENUM.TAG_BOX45 then
		print("box45")
		self:getParent()._scene:sendGame2Star( tag )
	end--]]
end

function Treasure:setCloseCallback(closeCallback)
    self._closeCallback = closeCallback
end

--宝藏游戏结束
function Treasure:onTreasureEnd(row)
	print("宝藏游戏结束")
	ExternalFun.SAFE_RELEASE(self.m_explodeAni)
	for i = 1, row do
		ExternalFun.SAFE_RELEASE(self.m_boxShakeAni[i])
	end
	ExternalFun.SAFE_RELEASE(self.m_openBoxAni)
	local function win()
		self:onTreasureEndResult()
	end
	local function gameover()
        local gameview = self:getParent()
        gameview.m_userHead:switchGameState(gameview._scene.m_lCoins)
        if self._closeCallback ~= nil then
            self._closeCallback()
        end
		gameview:removeChildByTag(100000)
		--self:retain()
	end
	local action1 = cc.DelayTime:create(5)
	local action2 = cc.CallFunc:create(win)
	local action3 = cc.CallFunc:create(gameover)
	self:runAction(cc.Sequence:create(action2,action1,action3,cc.CallFunc:create(
	function ()
		ExternalFun.playBackgroudAudio("xiongdiwushu.mp3")
		--local tmep = self:getParent()  ----._scene.m_bEnterGame2 = false
		--if self:getParent()._scene.m_bIsAuto == true then 
			--self:getParent()._scene:SendUserReady()
			--self:getParent()._scene:sendReadyMsg()
			--self:getParent()._scene.m_cbGameStatus = g_var(cmd).SHZ_GAME_SCENE_FREE
			--self:getParent()._scene:setGameMode(1)
			--self:Release()
		--end
	end)))
end
--宝藏游戏结束结算
function Treasure:onTreasureEndResult()
	print("宝藏游戏结束1111111111111111111111")
	self.getTreasure:setVisible(true)
--[[	local winBlink  = cc.Blink:create(1.5,2)
	local winScale  = cc.ScaleTo:create(1.0,2.0)
	local action1   = cc.DelayTime:create(5)
	local runAction = cc.Spawn:create(action1,winScale,winBlink)--]]
	
	local winBlink  = cc.Blink:create(1.5,2)
	local winScale  = cc.ScaleTo:create(1.0,2.0)
	local action1   = cc.DelayTime:create(5)
	local runAction = cc.Spawn:create(action1)
	ExternalFun.playSoundEffect("zhongjiang_coin.mp3")
	self.getTreasure:runAction(runAction)
	local str1 = self.getTreasure:getChildByTag(TAG_ENUM.TAG_WIN_COUNT)
	str1:setString(self.totalScore)
	str1:setVisible(false)
	
	print("-----------------------------------------------------")
	print("self.totalScore = ",self.totalScore)
	print("-----------------------------------------------------")
	
	self.layer1 = self.getTreasure:getChildByTag(6666)	
	if self.layer1 ~= nil then 
	else
		self.layer1 = ScollNumLayer:create()
		self.layer1:addTo(self.getTreasure)
		self.layer1:setPosition(-400,-335)
		self.layer1:setTag(6666)
		self.layer1:start(0,self.totalScore,math.floor(self.totalScore/32))
	end
end

function Treasure:onTouchBegan( touch, event )
	local tmep = self:isVisible()
	return self:isVisible()
end

return Treasure