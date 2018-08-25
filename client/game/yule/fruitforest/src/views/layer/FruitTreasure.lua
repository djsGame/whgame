local Treasure = class("Treasure", cc.Layer)
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")
Treasure.RES_PATH              = "game/yule/fruitforest/res/"
Treasure.BT_HOME = 1

local enGameLayer =
{
"TAG_BOX11",		--1
"TAG_BOX12",		--2
"TAG_BOX13",		--3
"TAG_BOX14",		--4
"TAG_BOX15",		--5
"TAG_BOX16",		--6
"TAG_BOX17",		--7
"TAG_BOX21",		--8
"TAG_BOX22",		--9
"TAG_BOX23",		--10
"TAG_BOX24",		--11
"TAG_BOX25",		--12
"TAG_BOX26",		--13
"TAG_BOX27",		--14
"TAG_BOX31",		--15
"TAG_BOX32",		--16
"TAG_BOX33",		--17
"TAG_BOX34",		--18
"TAG_BOX35",		--19
"TAG_BOX36",		--20
"TAG_BOX37",		--21
"TAG_SINGLE_SCORE",	--36
"",
"TAG_TOTAL_SCORE",	--37
"TAG_TIMES",		--38
"TAG_GET_TREASURE",	--39
"TAG_WIN_COUNT"		--40
}

local TAG_ENUM = ExternalFun.declarEnumWithTable(Treasure.TAG_START, enGameLayer)

function Treasure:ctor( treasureClick,lScore, lBeiShu)
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
	self.m_alreadyBeTouchedApple = {}	--记录已经点击的苹果
	--加载宝藏界面
	local csbNodeTreasure = ExternalFun.loadCSB(Treasure.RES_PATH.."nodeTreasure_fruit.csb", self)
	csbNodeTreasure:setPosition(cc.p(1334/2,750/2- 750))
	local action1 = cc.MoveTo:create(0.5,cc.p(0,750/2+350))
	self:runAction(cc.Sequence:create(cc.DelayTime:create(1),action1))
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
	local box21 = bk:getChildByName("checkBox_16")
	:setTag(TAG_ENUM.TAG_BOX16)
	--:setBright(false)
	--:setTouchEnabled(false)
	:addTouchEventListener(btnEvent)
	local box22 = bk:getChildByName("checkBox_17")
	:setTag(TAG_ENUM.TAG_BOX17)
	--:setBright(false)
	--:setTouchEnabled(false)
	:addTouchEventListener(btnEvent)
	local box23 = bk:getChildByName("checkBox_21")
	:setTag(TAG_ENUM.TAG_BOX21)
	--:setBright(false)
	--:setTouchEnabled(false)
	:addTouchEventListener(btnEvent)
	local box24 = bk:getChildByName("checkBox_22")
	:setTag(TAG_ENUM.TAG_BOX22)
	--:setBright(false)
	--:setTouchEnabled(false)
	:addTouchEventListener(btnEvent)
	local box25 = bk:getChildByName("checkBox_23")
	:setTag(TAG_ENUM.TAG_BOX23)
	--:setBright(false)
	--:setTouchEnabled(false)
	:addTouchEventListener(btnEvent)
	local box31 = bk:getChildByName("checkBox_24")
	:setTag(TAG_ENUM.TAG_BOX24)
	--:setBright(false)
	--:setTouchEnabled(false)
	:addTouchEventListener(btnEvent)
	local box32 = bk:getChildByName("checkBox_25")
	:setTag(TAG_ENUM.TAG_BOX25)
	--:setBright(false)
	--:setTouchEnabled(false)
	:addTouchEventListener(btnEvent)
	local box33 = bk:getChildByName("checkBox_26")
	:setTag(TAG_ENUM.TAG_BOX26)
	--:setBright(false)
	--:setTouchEnabled(false)
	:addTouchEventListener(btnEvent)
	local box34 = bk:getChildByName("checkBox_27")
	:setTag(TAG_ENUM.TAG_BOX27)
	--:setBright(false)
	--:setTouchEnabled(false)
	:addTouchEventListener(btnEvent)
	local box35 = bk:getChildByName("checkBox_31")
	:setTag(TAG_ENUM.TAG_BOX31)
	--:setBright(false)
	--:setTouchEnabled(false)
	:addTouchEventListener(btnEvent)
	local box41 = bk:getChildByName("checkBox_32")
	:setTag(TAG_ENUM.TAG_BOX32)
	--:setBright(false)
	--:setTouchEnabled(false)
	:addTouchEventListener(btnEvent)
	local box42 = bk:getChildByName("checkBox_33")
	:setTag(TAG_ENUM.TAG_BOX33)
	--:setBright(false)
	--:setTouchEnabled(false)
	:addTouchEventListener(btnEvent)
	local box43 = bk:getChildByName("checkBox_34")
	:setTag(TAG_ENUM.TAG_BOX34)
	--:setBright(false)
	--:setTouchEnabled(false)
	:addTouchEventListener(btnEvent)
	local box44 = bk:getChildByName("checkBox_35")
	:setTag(TAG_ENUM.TAG_BOX35)
	--:setBright(false)
	--:setTouchEnabled(false)
	:addTouchEventListener(btnEvent)
	local box45 = bk:getChildByName("checkBox_36")
	:setTag(TAG_ENUM.TAG_BOX36)
	--:setBright(false)
	--:setTouchEnabled(false)
	box45:addTouchEventListener(btnEvent)
	local box46 = bk:getChildByName("checkBox_37")
	:setTag(TAG_ENUM.TAG_BOX37)
	--:setVisible(false)
	--:setTouchEnabled(false)
	box46:addTouchEventListener(btnEvent)
	
	self.treasure_bk = bk
	
	--宝箱得分
	bk = self.treasure_bk:getChildByName("rect_bk")
	self.singleScore = bk:getChildByName("atlasSingle")
	:setTag(TAG_ENUM.TAG_SINGLE_SCORE)
	--self.singleScore:setString(1)
	local times = bk:getChildByName("atlasCount")
	:setTag(TAG_ENUM.TAG_TIMES)
	local totalScore = bk:getChildByName("atlasCount_all")
	:setTag(TAG_ENUM.TAG_TOTAL_SCORE)
	--播放背景音乐
	ExternalFun.playBackgroudAudio("senlin_bonus_bgm.mp3")
	--箱子晃动
	self.m_boxShake = {}
	self.m_boxShakeAni = {}
	for i = 1, 4 do
		local path = ""
		local str = "boxShake.csb"
		self.m_boxShake[i] = ExternalFun.loadCSB(str, self.treasure_bk)
		--self.m_boxShake[i]:setVisible(false)
	end
	--开箱子
	self.m_openBox = ExternalFun.loadCSB("openBox.csb", self.treasure_bk)
	:setVisible(false)
	--爆炸
	self.m_explode = ExternalFun.loadCSB("explode.csb", self.treasure_bk)
	:setVisible(false)
	
	self._GameTWoEnd = false
	
	self.atlasSingle=0
	
	local zongTouZhu = self.treasure_bk:getChildByName("rect_bk"):getChildByName("zongTouZhu")
	local tempX1, tempY1 = zongTouZhu:getPosition()
	zongTouZhu:setPosition(cc.p(tempX1 - 90,tempY1))
	local single_text = self.treasure_bk:getChildByName("rect_bk"):getChildByTag(TAG_ENUM.TAG_SINGLE_SCORE)
	local multiple = self.treasure_bk:getChildByName("rect_bk"):getChildByName("multiple")
	local times_text = self.treasure_bk:getChildByName("rect_bk"):getChildByTag(TAG_ENUM.TAG_TIMES)
	local equal = self.treasure_bk:getChildByName("rect_bk"):getChildByName("equal")
	local total_text = self.treasure_bk:getChildByName("rect_bk"):getChildByTag(TAG_ENUM.TAG_TOTAL_SCORE)
	single_text:setAnchorPoint(0,0.5)
	multiple:setAnchorPoint(0,0.5)
	times_text:setAnchorPoint(0,0.5)
	equal:setAnchorPoint(0,0.5)
	total_text:setAnchorPoint(0,0.5)
	
	local tempX, tempY = single_text:getPosition()
	single_text:setPosition(cc.p(tempX - 90,tempY))
	--multiple:setPosition(cc.p(tempX,tempY))
	
	if treasureClick ~= nil then
		for i = 1, #treasureClick do
			if treasureClick[i] ~= 0 then
				--self:game2BombTimes(cbBombInfo[i],i)
				self:openBox(treasureClick[i] + 1, 7, false)
			end
		end
	end
	
	self.m_lScore = lScore
	self.m_lBeiShu = lBeiShu
	self.atlasSingle=lScore
	self.m_BoxCount= self.treasure_bk:getChildByName("rect_bk"):getChildByName("BoxCount")
	self.m_BoxCount:setString(3)
	
	
end

function Treasure:openBox(index, number, bBomb)
	local row = math.floor((index - 1) / 7) + 1		--点击的宝箱所在位置行数
	local column = math.mod((index - 1), 7) + 1		--点击宝箱所在位置列数
	--self.m_alreadyBeTouchedApple = {}
	table.insert(self.m_alreadyBeTouchedApple,index)
	if index <= 21 then
		if bBomb == false then
			self:runAction(cc.Sequence:create(
			cc.CallFunc:create(function ()
				for i = 1, 21 do	--使其它箱子不可以点击
					local box = self.treasure_bk:getChildByTag(i)
					if box ~= nil then
						--if i ~= column then
							box:setTouchEnabled(false)
						--end
					end
				end
				self.treasure_bk:getChildByTag(index):setTouchEnabled(false)
				self.treasure_bk:getChildByTag(index):setVisible(false)
			end),
			cc.CallFunc:create(function()	--打开箱子
				--ExternalFun.playSoundEffect("senlin_bonus_jinru.mp3")
				self.treasure_bk:getChildByTag(index):setVisible(true)
				self.treasure_bk:getChildByTag(index):setSelected(true)
			end),
			cc.CallFunc:create(function()	--显示先点中宝箱的倍数
				self:game2BombTimes(self:getParent()._scene.cbBombInfo[row], row, column)
				--self:updataScore(self.atlasSingle, self:getParent()._scene.m_nYaLienCount, self:getParent()._scene.m_lYaZhubScore)
				self:updataScore(self.m_lScore,self.m_lBeiShu,self.m_lBeiShu * self.m_lScore)
			end),
			
			cc.CallFunc:create(function()	--没有点中炸弹，继续下一行
				for i = 1, 21 do	--使其它箱子不可以点击
					local box = self.treasure_bk:getChildByTag(i)
					if box ~= nil then
						for j = 1, #self.m_alreadyBeTouchedApple do
							if i ~= self.m_alreadyBeTouchedApple[j] then
								box:setTouchEnabled(true)
							end
						end
					end
				end
			end),
			cc.CallFunc:create(
			function ()
				if self._GameTWoEnd == true then
					for i = 1, 21 do
						local box = self.treasure_bk:getChildByTag(i)
						box:setSelected(true)
						box:setTouchEnabled(false)
					end
				end
			end
			)
			))
			
		end
	end
end
--箱子晃动动画
function Treasure:boxShakeAni(indexOfBox)
	local row = math.floor((indexOfBox - 1) / 7) + 1		--宝箱所在位置行数
	local box = self.treasure_bk:getChildByTag(indexOfBox)
	self.m_boxShake[row]:setPosition(box:getPosition())
	self.m_boxShake[row]:setVisible(true)
	self.m_boxShakeAni[row] = ExternalFun.loadTimeLine("boxShake.csb")
	ExternalFun.SAFE_RETAIN(self.m_boxShakeAni[row])
	self.m_boxShake[row]:stopAllActions()
	self.m_boxShakeAni[row]:gotoFrameAndPlay(0,false)
	
	local shakBox = cc.CallFunc:create(
	function ()
		self.m_boxShake[row]:runAction(self.m_boxShakeAni[row])
	end
	)
	
	local close = cc.CallFunc:create(
	function ()
		self.m_boxShake[row]:setVisible(false)
	end
	)
	
	local seq = cc.Sequence:create(shakBox,cc.DelayTime:create(1.5),close )
	self:runAction(seq)
	
end

--开箱子动画
function Treasure:openBoxAni(indexOfBox)
	local box = self.treasure_bk:getChildByTag(indexOfBox)
	self.m_openBox:setPosition(box:getPosition())
	self.m_openBox:setVisible(true)
	self.m_openBoxAni = ExternalFun.loadTimeLine( "openBox.csb" )
	ExternalFun.SAFE_RETAIN(self.m_openBoxAni)
	self.m_openBox:stopAllActions()
	self.m_openBoxAni:gotoFrameAndPlay(0,true)
	
	--[[	self.m_openBox:runAction(cc.Sequence:create(self.m_openBox:runAction(self.m_openBoxAni),
	cc.CallFunc:create(
	function ()
		self.m_openBoxAni:setVisible(false)
	end)
	)
	)--]]
	self:runAction(cc.Sequence:create(
	cc.CallFunc:create(
	function ()
		ExternalFun.playSoundEffect("senlin_bonus_jinru.mp3")
		self.m_openBox:runAction(self.m_openBoxAni)
	end
	),
	cc.DelayTime:create(0.8),
	cc.CallFunc:create(
	function ()
		self.m_openBox:setVisible(false)
	end
	)
	
	))
end

--显示一行宝箱倍数并显示炸弹（隐藏箱子）
function Treasure:game2BombTimes(cbBombInfo,row, column)
	if column == nil then
		for i = 1, #cbBombInfo do
			print("宝箱序号宝箱序号"..TAG_ENUM.TAG_BOX11 + i -1 + (row - 1) * 7)
			local box = self.treasure_bk:getChildByTag(i  + (row - 1) * 7)
			if box ~= nil then
				if cbBombInfo[i]==0 then
						local  bombTimes = cc.Sprite:create("res/treasure/3.png");
						bombTimes:setPosition(cc.p(50,30))
						bombTimes:setAnchorPoint(0.5,0.0)
						bombTimes:addTo(box)
				elseif cbBombInfo[i] == 255 then
						local  bombTimes = cc.Sprite:create("res/treasure/2.png");
						bombTimes:setPosition(cc.p(50,30))
						bombTimes:setAnchorPoint(0.5,0.0)
						bombTimes:addTo(box)
				else 
						local bombTimes = cc.Label:createWithTTF(cbBombInfo[i].."","round_body.ttf", 40)
						bombTimes:setTextColor(cc.c4b(239,251,0,255))
						bombTimes:enableOutline(cc.c4b(255,0,0,255), 3)
						bombTimes:setPosition(cc.p(50,15))
						bombTimes:setAnchorPoint(0.5,0.0)
						bombTimes:addTo(box)
				end
				
			end
		end
	else
		local box = self.treasure_bk:getChildByTag(column  + (row - 1) * 7)
		if box ~= nil then
			
			if cbBombInfo[column]==0 then
						local  bombTimes = cc.Sprite:create("res/treasure/3.png");
						bombTimes:setPosition(cc.p(50,30))
						bombTimes:setAnchorPoint(0.5,0.0)
						bombTimes:addTo(box)
				elseif cbBombInfo[column] == 255 then
						local  bombTimes = cc.Sprite:create("res/treasure/2.png");
						bombTimes:setPosition(cc.p(50,30))
						bombTimes:setAnchorPoint(0.5,0.0)
						bombTimes:addTo(box)
				else 
						local bombTimes = cc.Label:createWithTTF(cbBombInfo[column].."","round_body.ttf", 40)
						bombTimes:setTextColor(cc.c4b(239,251,0,255))
						bombTimes:enableOutline(cc.c4b(255,0,0,255), 3)
						bombTimes:setPosition(cc.p(50,15))
						bombTimes:setAnchorPoint(0.5,0.0)
						bombTimes:addTo(box)
				end
		end
	end
end
--打开宝箱,index是所点击数的宝箱的值，nmumber是需要打开宝箱的数量，并使上一行宝箱可以点击
function Treasure:game2OpenBox(index, number, bBomb)
	local row = math.floor((index - 1) / 7) + 1		--点击的宝箱所在位置行数
	local column = math.mod((index - 1), 7) + 1		--点击宝箱所在位置列数
	table.insert(self.m_alreadyBeTouchedApple,index)
	if index <= 21 then
		if bBomb == false then
			self:runAction(cc.Sequence:create(
			cc.CallFunc:create(function ()
				for i = 1, 21 do	--使其它箱子不可以点击
					local box = self.treasure_bk:getChildByTag(i)
					if box ~= nil then
						--if i ~= column then
							box:setTouchEnabled(false)
						--end
					end
				end
				self.treasure_bk:getChildByTag(index):setTouchEnabled(false)
				self.treasure_bk:getChildByTag(index):setVisible(true)
				self:boxShakeAni(index)	--晃动箱子
			end),
			cc.DelayTime:create(0.8),
			cc.CallFunc:create(function()	--打开箱子
				ExternalFun.playSoundEffect("senlin_bonus_jinru.mp3")
				self.treasure_bk:getChildByTag(index):setVisible(true)
				self.treasure_bk:getChildByTag(index):setSelected(true)
			end),
			cc.CallFunc:create(function()	--宝箱闪光
				self:openBoxAni(index)
			end),
			cc.DelayTime:create(0.2),
			cc.CallFunc:create(function()	--显示先点中宝箱的倍数
				self:game2BombTimes(self:getParent()._scene.cbBombInfo[row], row, column)
				self:updataScore(self.atlasSingle, self:getParent()._scene.m_nYaLienCount, self:getParent()._scene.m_lYaZhubScore)
			end),
			cc.DelayTime:create(0.1),
			cc.DelayTime:create(0.1),
			cc.CallFunc:create(function()	--没有点中炸弹，继续下一行
				for i = 1, 21 do	--使其它箱子不可以点击
					local box = self.treasure_bk:getChildByTag(i)
					box:setTouchEnabled(true)
					for j = 1, #self.m_alreadyBeTouchedApple do
						local temp = self.m_alreadyBeTouchedApple[j]
						if i == self.m_alreadyBeTouchedApple[j] then
							box:setTouchEnabled(false)
						end
					end
				end
			end),
			cc.CallFunc:create(
			function ()
				if self._GameTWoEnd == true then
					for i = 1, 21 do
						local box = self.treasure_bk:getChildByTag(i)
						box:setSelected(true)
						box:setTouchEnabled(false)
					end
				end
			end
			),
			cc.CallFunc:create(
			function ()
				if self._GameTWoEnd == true then
					cc.DelayTime:create(0.1)
					
				end
			end
			),
			cc.CallFunc:create(
			function ()
				if self._GameTWoEnd == true then
					for i=1,3 do
						self:game2BombTimes(self:getParent()._scene.cbBombInfo[i], i)
					end
				end
			end
			),
			cc.CallFunc:create(
			function ()
				if self._GameTWoEnd == true then
					self:onTreasureEnd()
				end
			end
			)
			))
			
		end
	end
end

--更新宝藏得分zongTouZhu
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
	
	if tag>=TAG_ENUM.TAG_BOX11 and tag<=TAG_ENUM.TAG_BOX37 then
		print("box11"..tag)
		self:getParent()._scene:sendGame2Star( tag )
	end
	
	--[[if tag == TAG_ENUM.TAG_BOX11 then
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
function Treasure:onTreasureEnd()
	print("宝藏游戏结束")
	local function win()
		self:onTreasureEndResult()
	end
	local function gameover()
        if self._closeCallback ~= nil then
            self._closeCallback()
        end
		self:getParent():removeChildByTag(100000)
	end
	local action1 = cc.DelayTime:create(5)
	local action2 = cc.CallFunc:create(win)
	local action3 = cc.CallFunc:create(gameover)
	self:runAction(cc.Sequence:create(action2,action1,action3,cc.CallFunc:create(
	function ()
		ExternalFun.playBackgroudAudio("xiongdiwushu.mp3")
	end)))
end

--宝藏游戏结束结算
function Treasure:onTreasureEndResult()
	self.getTreasure:setVisible(true)
	local winBlink = cc.Blink:create(1.5,2)
	local winScale = cc.ScaleTo:create(1.0,1.5)
	local runAction = cc.Spawn:create(winScale,winBlink)
	ExternalFun.playSoundEffect("treasureGet.mp3")
	self.getTreasure:runAction(runAction)
	local coninsStr =string.formatNumberThousands(tostring(self.totalScore),true,",")
	self.getTreasure:getChildByTag(TAG_ENUM.TAG_WIN_COUNT):setString(coninsStr)
end

function Treasure:onTouchBegan( touch, event )
	local tmep = self:isVisible()
	return self:isVisible()
end

return Treasure