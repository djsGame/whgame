--[[
	银行记录界面
	2016_06_21 Ravioyla
]]

local BankRecordLayer = class("BankRecordLayer", function(scene)
		local bankRecordLayer = display.newLayer(cc.c4b(0, 0, 0, 125))
    return bankRecordLayer
end)

local BankFrame = appdf.req(appdf.CLIENT_SRC.."plaza.models.BankFrame")

local CBT_ACCEPT = 1
local CBT_ZENGSONG = 2

-- 进入场景而且过渡动画结束时候触发。
function BankRecordLayer:onEnterTransitionFinish()
	self._scene:showPopWait()
	local this = self
	self._bankRecordList2 = {}
    self._bankRecordList1 = {}
	appdf.onHttpJsionTable(yl.HTTP_URL .. "/WS/MobileInterface.ashx","GET","action=getbankrecord&userid="..GlobalUserItem.dwUserID.."&signature="..GlobalUserItem:getSignature(os.time()).."&time="..os.time().."&number=20&page=1",function(jstable,jsdata)
			this._scene:dismissPopWait()
			if jstable then
				local code = jstable["code"]
				print("-----------------------------------------------")
				dump(jstable["data"],"asd")
				print("-----------------------------------------------")
				if tonumber(code) == 0 then
					local datax = jstable["data"]
					if datax then
						local valid = datax["valid"]
						if valid == true then
							local listcount = datax["total"]
							local list = datax["list"]
							if type(list) == "table" then
								for i=1,#list do
									local item = {}
						            item.tradeType = list[i]["TradeTypeDescription"]
						            item.swapScore = tonumber(list[i]["SwapScore"])
						            item.revenue = tonumber(list[i]["Revenue"])
						            item.date = GlobalUserItem:getDateNumber(list[i]["CollectDate"])
						            item.id = list[i]["TransferAccounts"]
									item.GiftType  = list[i]["GiftType"]   --礼物类型
									item.GiftTotal = list[i]["GiftTotal"]  --礼物数量 

									item.OprState  = list[i]["OprState"]   --状态
									item.TargetUserID  = list[i]["TargetUserID"]   --状态
									item.SourceUserID  = list[i]["SourceUserID"]   --状态
									item.RecordID = list[i]["RecordID"]			--索引
									--过滤自己的存储款操作
									local TargetUserID = tonumber(item.TargetUserID)
									if TargetUserID ~= 0 then
                                        local SourceUserID = tonumber(item.SourceUserID)
                                        if SourceUserID == GlobalUserItem.dwUserID  then
                                            --赠送
                                            if #self._bankRecordList2 <= 100 then
										        table.insert(self._bankRecordList2,item)
                                            end
                                        else
                                            if #self._bankRecordList1 <= 100 then
                                                table.insert(self._bankRecordList1,item)
                                            end
                                        end
									end
								end
							end
						end
					end
				end

				this:onUpdateShow()
			else
				showToast(this,"抱歉，获取银行记录信息失败！",2,cc.c3b(250,0,0))
			end
		end)
    return self
end

-- 退出场景而且开始过渡动画时候触发。
function BankRecordLayer:onExitTransitionStart()
    return self
end

function BankRecordLayer:ctor(scene)
	
	local this = self

	self._scene = scene
	
	self:registerScriptHandler(function(eventType)
		if eventType == "enterTransitionFinish" then	-- 进入场景而且过渡动画结束时候触发。
			self:onEnterTransitionFinish()
		elseif eventType == "exitTransitionStart" then	-- 退出场景而且开始过渡动画时候触发。
			self:onExitTransitionStart()
		end
	end)
	
    --网络回调
    local  bankCallBack = function(result,message)
		this:onBankCallBack(result,message)
	end

	--网络处理
	self._bankFrame = BankFrame:create(self,bankCallBack)
    self._bankFrame._gameFrame = gameFrame
    if nil ~= gameFrame then
        gameFrame._shotFrame = self._bankFrame
    end

	self._bankRecordList1 = {}
    self._bankRecordList2 = {}

	local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("sp_top_bg.png")
	if nil ~= frame then
		local sp = cc.Sprite:createWithSpriteFrame(frame)
		sp:setPosition(yl.WIDTH/2,yl.HEIGHT - 51)
		self:addChild(sp)
	end
	display.newSprite("BankRecord/title_bankrecord.png")
		:move(yl.WIDTH/2,yl.HEIGHT - 51)
		:addTo(self)
	frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("sp_public_frame_0.png")
	if nil ~= frame then
		local sp = cc.Sprite:createWithSpriteFrame(frame)
		sp:setPosition(yl.WIDTH/2,326)
		self:addChild(sp)
	end
	display.newSprite("BankRecord/frame_back_2.png")
		:move(yl.WIDTH/2+30,326)
		:addTo(self)

	ccui.Button:create("bt_return_0.png","bt_return_1.png")
		:move(75,yl.HEIGHT-51)
		:addTo(self)
		:addTouchEventListener(function(ref, type)
       		 	if type == ccui.TouchEventType.ended then
					this._scene:onKeyBack()
				end
			end)

	--标题列
	display.newSprite("BankRecord/table_bankrecord_line.png")
		:move(yl.WIDTH/2+30,520)
		:setScale(0.8)
		:addTo(self)
	display.newSprite("BankRecord/title_bankrecord_0.png")
		:move(230 - 30,550)
		:setScale(0.8)
		:addTo(self)
	display.newSprite("BankRecord/title_bankrecord_1.png")
		:move(500 - 70,550)
		:setScale(0.8)
		:addTo(self)
	display.newSprite("BankRecord/title_bankrecord_leixing.png")
		:move(700 - 120,550)
		:setScale(0.8)
		:addTo(self)

	display.newSprite("BankRecord/title_bankrecord_shuliang.png")
		:move(750,550)
		:setScale(0.8)
		:addTo(self)		
		
	display.newSprite("BankRecord/title_bankrecord_3.png")
		:move(880,550)
		:setScale(0.8)
		:addTo(self)
	display.newSprite("BankRecord/title_bankrecord_zhuangtai.png")
		:move(1140,550)
		:setScale(0.8)
		:addTo(self)

	--无记录提示
	self._nullTipLabel = cc.Label:createWithTTF("没有银行记录","fonts/round_body.ttf",32)
			:move(yl.WIDTH/2+30,326)
			:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
			:setTextColor(cc.c4b(206,175,255,255))
			:setAnchorPoint(cc.p(0.5,0.5))
			-- :setVisible(false)
			:addTo(self)

    local cbtlistener = function (sender,eventType)
    	this:onSelectedEvent(sender,eventType)
    end

	self._cbtAccept = ccui.CheckBox:create("BankRecord/bank_jieshoujilu_click.png","BankRecord/bank_jieshoujilu_click.png","BankRecord/bank_jieshoujilu.png","","")
		:setAnchorPoint(cc.p(0.5,0))
		:move(70,yl.HEIGHT/2 - 50)
		:setSelected(true)
		:addTo(self)
		:setTag(CBT_ACCEPT)
	self._cbtAccept:addEventListener(cbtlistener)

	self._cbtZengSong = ccui.CheckBox:create("BankRecord/bank_zengsongjilu_click.png","BankRecord/bank_zengsongjilu_click.png","BankRecord/bank_zengsongjilu.png","","")
		:setAnchorPoint(cc.p(0.5,1))
		:move(70,yl.HEIGHT/2 - 50)
		:setSelected(false)
		:addTo(self)
		:setTag(CBT_ZENGSONG)
	self._cbtZengSong:addEventListener(cbtlistener)

    self._bAccept = true

	--记录列表
	self._listView = cc.TableView:create(cc.size(1161, 454))
	self._listView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)    
	self._listView:setPosition(cc.p(90+30,62))
	self._listView:setDelegate()
	self._listView:addTo(self)
	self._listView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
	self._listView:registerScriptHandler(self.cellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX)
	self._listView:registerScriptHandler(handler(self,self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
	self._listView:registerScriptHandler(self.numberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

	display.newSprite("BankRecord/frame_back_1.png")
		:move(yl.WIDTH/2+30,326)
		:addTo(self)

end

function BankRecordLayer:onUpdateShow()
	print("BankRecordLayer:onUpdateShow")
    if self._bAccept then
	    if not self._bankRecordList1 then
		    print("self._nullTipLabel:setVisible(true)")
		    self._nullTipLabel:setVisible(true)
	    else
		    self._nullTipLabel:setVisible(false)
	    end
    else
	    if not self._bankRecordList2 then
		    print("self._nullTipLabel:setVisible(true)")
		    self._nullTipLabel:setVisible(true)
	    else
		    self._nullTipLabel:setVisible(false)
	    end
    end

	self._listView:reloadData()

end

---------------------------------------------------------------------

--子视图大小
function BankRecordLayer.cellSizeForTable(view, idx)
  	return 1161 , 76
end

--子视图数目
function BankRecordLayer.numberOfCellsInTableView(view)
    if view:getParent()._bAccept then
	    return #view:getParent()._bankRecordList1
    else
        return #view:getParent()._bankRecordList2
    end
end
	
--获取子视图
function BankRecordLayer:tableCellAtIndex(view, idx)		
	local cell = view:dequeueCell()
	
	local item 
    if self._bAccept then
        item = view:getParent()._bankRecordList1[idx+1]
    else
        item = view:getParent()._bankRecordList2[idx+1]
    end

	local width = 1161
	local height= 76

	if not cell then
		cell = cc.TableViewCell:new()
	else
		cell:removeAllChildren()
	end

	display.newSprite("BankRecord/table_bankrecord_cell_"..(idx%2)..".png")
		:move(width/2,height/2)
		:addTo(cell)

	--日期
	local date = os.date("%Y/%m/%d %H:%M:%S", tonumber(item.date)/1000)
	-- print(date)
	-- print(""..tonumber(item.date))
	cc.Label:createWithTTF(date,"fonts/round_body.ttf",25)
		:move(142 - 30,height/2)
		:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		:setTextColor(cc.c4b(206,175,255,255))
		:setAnchorPoint(cc.p(0.5,0.5))
		:addTo(cell)

	cc.Label:createWithTTF(item.tradeType,"fonts/round_body.ttf",25)
		:move(412 -100,height/2)
		:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		:setTextColor(cc.c4b(206,175,255,255))
		:setAnchorPoint(cc.p(0.5,0.5))
		:addTo(cell)
	local giftType = tonumber(item.GiftType)
	local giftTypeText = ""
	if giftType == 0 then
		giftTypeText = "黄金皇冠"
	elseif giftType == 1 then
		giftTypeText = "白金皇冠"
	elseif giftType == 2 then
		giftTypeText = "砖石皇冠"
	elseif giftType == 3 then
		giftTypeText = "金币"
	end
	--cc.Label:createWithTTF(string.formatNumberThousands(item.swapScore,true,","),"fonts/round_body.ttf",25)
	cc.Label:createWithTTF(giftTypeText,"fonts/round_body.ttf",25)
		:move(612 - 150,height/2)
		:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		:setTextColor(cc.c4b(206,175,255,255))
		:setAnchorPoint(cc.p(0.5,0.5))
		:addTo(cell)
		
	--cc.Label:createWithTTF(item.id,"fonts/round_body.ttf",25)
	cc.Label:createWithTTF(string.formatNumberThousands(item.GiftTotal,true,","),"fonts/round_body.ttf",25)
		:move(640,height/2)
		:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		:setTextColor(cc.c4b(206,175,255,255))
		:setAnchorPoint(cc.p(0.5,0.5))
		:addTo(cell)

	cc.Label:createWithTTF(item.id,"fonts/round_body.ttf",25)
		:move(760,height/2)
		:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		:setTextColor(cc.c4b(206,175,255,255))
		:setAnchorPoint(cc.p(0.5,0.5))
		:addTo(cell)

--[[	cc.Label:createWithTTF(string.formatNumberThousands(item.revenue,true,","),"fonts/round_body.ttf",32)
		:move(1028,height/2)
		:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		:setTextColor(cc.c4b(206,175,255,255))
		:setAnchorPoint(cc.p(0.5,0.5))
		:addTo(cell)--]]
		
		if tonumber(item.TargetUserID)  == 0 then
			
		elseif tonumber(item.SourceUserID) == GlobalUserItem.dwUserID  then
			print("赠送")
			local text = cc.Label:createWithTTF("","fonts/round_body.ttf",25)
				:move(1000,height/2)
				:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
				:setTextColor(cc.c4b(206,175,255,255))
				:setAnchorPoint(cc.p(0.5,0.5))
				:addTo(cell)
			if tonumber(item.OprState) == 0  then
				text:setString("等待对方操作")
			elseif tonumber(item.OprState) == 1 then
			
			elseif tonumber(item.OprState) == 2 then

			elseif tonumber(item.OprState) == 3 then
				text:setString("对方已接受")
			elseif tonumber(item.OprState) == 4 then 
				text:setString("对方已拒绝")
			end
		elseif tonumber(item.SourceUserID) ~= GlobalUserItem.dwUserID  then
			print("接受")
			if tonumber(item.OprState) == 0  then
				ccui.ImageView:create("BankRecord/bank_jieshou.png")
					:move(910,height/2)
					:setTouchEnabled(true)
					:setAnchorPoint(cc.p(0.5,0.5))
					:setVisible(true)
					:addTo(cell)
					:addTouchEventListener(function(ref, tType)
						if tType == ccui.TouchEventType.ended then
							print("jie shou idx = ",idx)
							self._bankFrame:sendCaoZuo(0,item.RecordID)
						end
					 end)
					
				ccui.ImageView:create("BankRecord/bank_jujue.png")
					:move(1080,height/2)
					:setTouchEnabled(true)
					:setVisible(true)
					:setAnchorPoint(cc.p(0.5,0.5))
					:addTo(cell)
					:addTouchEventListener(function(ref, tType)
						if tType == ccui.TouchEventType.ended then
							print("ju jue idx = ",idx)
							self._bankFrame:sendCaoZuo(1,item.RecordID)
						end
					 end)	
			elseif tonumber(item.OprState) == 1 then
			
			elseif tonumber(item.OprState) == 2 then

			elseif tonumber(item.OprState) == 3 then					
				cc.Label:createWithTTF("已接收","fonts/round_body.ttf",25)
					:move(1000,height/2)
					:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
					:setTextColor(cc.c4b(206,175,255,255))
					:setAnchorPoint(cc.p(0.5,0.5))
					:addTo(cell)
			elseif tonumber(item.OprState) == 4 then 
				cc.Label:createWithTTF("已拒绝","fonts/round_body.ttf",25)
					:move(1000,height/2)
					:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
					:setTextColor(cc.c4b(206,175,255,255))
					:setAnchorPoint(cc.p(0.5,0.5))
					:addTo(cell)
			end
		else

				
			ccui.ImageView:create("BankRecord/bank_jieshouchenggong.png")
				:move(1028,height/2)
				:setTag(9)
				:setVisible(false)
		--		:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
				:setTouchEnabled(true)
				:setAnchorPoint(cc.p(0.5,0.5))
				:addTo(cell)
				:addTouchEventListener(function(ref, tType)
					if tType == ccui.TouchEventType.ended then
						print(" chenggong idx = ",idx)
						
					end
				 end)
				
			ccui.ImageView:create("BankRecord/bank_jieshou.png")
				:move(910,height/2)
		--		:setTag(9)
		--		:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
				:setTouchEnabled(true)
				:setVisible(true)
				:setAnchorPoint(cc.p(0.5,0.5))
				:addTo(cell)
				:addTouchEventListener(function(ref, tType)
					if tType == ccui.TouchEventType.ended then
						print("jie shou idx = ",idx)
						
					end
				 end)
				
			ccui.ImageView:create("BankRecord/bank_jujue.png")
				:move(1080,height/2)
		--		:setTag(9)
		--		:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
				:setTouchEnabled(true)
				:setVisible(true)
				:setAnchorPoint(cc.p(0.5,0.5))
				:addTo(cell)
				:addTouchEventListener(function(ref, tType)
					if tType == ccui.TouchEventType.ended then
						print("ju jue idx = ",idx)
					end
				 end)
		end
		
		
	return cell
end

--操作结果
function BankRecordLayer:onBankCallBack(result,message)
    if result == 255 then
        if message ~= nil and message ~= "" then
		    showToast(self._scene,message,2)
        else
            showToast(self._scene,"操作失败",2)
        end
	end
	if result ~= 255 then
		self:onEnterTransitionFinish()
	end

end

function BankRecordLayer:onSelectedEvent(sender,eventType)
	local tag = sender:getTag()
    if tag == CBT_ACCEPT or tag == CBT_ZENGSONG then
		local transfermode = (tag == CBT_ACCEPT)
		self._cbtAccept:setSelected(transfermode)
		self._cbtZengSong:setSelected(not transfermode)
        if self._bAccept ~= transfermode then
            self._bAccept = transfermode
            self:onUpdateShow()
        end
    end
end
---------------------------------------------------------------------
return BankRecordLayer