--[[
	ѯ�ʶԻ���
		2016_04_27 C.P
	���ܣ�ȷ��/ȡ�� �Ի��� ���û�����
]]
local PopInfoDialog = class("PopInfoDialog", function(msg,callback)
		local PopInfoDialog = display.newLayer()
    return PopInfoDialog
end)

--Ĭ�������С
PopInfoDialog.DEF_TEXT_SIZE 	= 32

--UI��ʶ
PopInfoDialog.DG_QUERY_EXIT 	=  2 
PopInfoDialog.BT_CANCEL		=  0   
PopInfoDialog.BT_CONFIRM		=  1

-- �Ի�������
PopInfoDialog.QUERY_SURE 			= 1
PopInfoDialog.QUERY_SURE_CANCEL 	= 2

-- ���볡�����ҹ��ɶ�������ʱ�򴥷���
function PopInfoDialog:onEnterTransitionFinish()
    return self
end

-- �˳��������ҿ�ʼ���ɶ���ʱ�򴥷���
function PopInfoDialog:onExitTransitionStart()
	self:unregisterScriptTouchHandler()
    return self
end

--���ⴥ��
function PopInfoDialog:setCanTouchOutside(canTouchOutside)
	self._canTouchOutside = canTouchOutside
	return self
end

--msg ��ʾ��Ϣ
--callback �����ص�
--txtsize �����С
function PopInfoDialog:ctor(msg,msg1,msg2,msg3,msg4,msg5,msg6,callback, txtsize, queryType)
	queryType = queryType or PopInfoDialog.QUERY_SURE_CANCEL
	self._callback = callback
	self._canTouchOutside = true

	local this = self 
	self:setContentSize(appdf.WIDTH,appdf.HEIGHT)
	self:move(0,appdf.HEIGHT)

	--�ص�����
	self:registerScriptHandler(function(eventType)
		if eventType == "enterTransitionFinish" then	-- ���볡�����ҹ��ɶ�������ʱ�򴥷���
			this:onEnterTransitionFinish()
		elseif eventType == "exitTransitionStart" then	-- �˳��������ҿ�ʼ���ɶ���ʱ�򴥷���
			this:onExitTransitionStart()
		end
	end)

	--��������
	local  btcallback = function(ref, type)
        if type == ccui.TouchEventType.ended then
         	this:onButtonClickedEvent(ref:getTag(),ref)
        end
    end

	--������ȡ����ʾ
	local  onQueryExitTouch = function(eventType, x, y)
		if not self._canTouchOutside then
			return true
		end

		if self._dismiss == true then
			return true
		end

		if eventType == "began" then
			local rect = this:getChildByTag(PopInfoDialog.DG_QUERY_EXIT):getBoundingBox()
        	if cc.rectContainsPoint(rect,cc.p(x,y)) == false then
        		self:dismiss()
    		end
		end
    	return true
    end
	self:setTouchEnabled(true)
	self:registerScriptTouchHandler(onQueryExitTouch)

	display.newSprite("query_bg.png")
		:setTag(PopInfoDialog.DG_QUERY_EXIT)
		:move(appdf.WIDTH/2,appdf.HEIGHT/2)
		:addTo(self)

	if PopInfoDialog.QUERY_SURE == queryType then
		ccui.Button:create("bt_query_confirm_0.png","bt_query_confirm_1.png")
			:move(appdf.WIDTH/2 , 200 )
			:setTag(PopInfoDialog.BT_CONFIRM)
			:addTo(self)
			:addTouchEventListener(btcallback)
	else
		ccui.Button:create("bt_query_confirm_0.png","bt_query_confirm_1.png")
			:move(appdf.WIDTH/2+169 , 200 )
			:setTag(PopInfoDialog.BT_CONFIRM)
			:addTo(self)
			:addTouchEventListener(btcallback)

		ccui.Button:create("bt_query_cancel_0.png","bt_query_cancel_1.png")
			:move(appdf.WIDTH/2-169 ,200 )
			:setTag(PopInfoDialog.BT_CANCEL)
			:addTo(self)
			:addTouchEventListener(btcallback)
	end

	cc.Label:createWithTTF(msg, "fonts/round_body.ttf", 36)
		:setTextColor(cc.c4b(255,221,65,255))
		:setAnchorPoint(cc.p(0.5,0.5))
		:setDimensions(600, 120)
		:setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
		:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		:move(appdf.WIDTH/2 ,545 )
		:addTo(self)

	cc.Label:createWithTTF(msg1, "fonts/round_body.ttf", not txtsize and PopInfoDialog.DEF_TEXT_SIZE or txtsize)
		:setTextColor(cc.c4b(255,255,255,255))
		:setAnchorPoint(cc.p(0.5,0.5))
		:setDimensions(600, 180)
		:setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
		:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		:move(appdf.WIDTH/2 - 50 ,375 +50 )
		:addTo(self)
		
	cc.Label:createWithTTF(msg2, "fonts/round_body.ttf", not txtsize and PopInfoDialog.DEF_TEXT_SIZE or txtsize)
		:setTextColor(cc.c4b(255,255,255,255))
		:setAnchorPoint(cc.p(0.5,0.5))
		:setDimensions(600, 180)
		:setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
		:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		:move(appdf.WIDTH/2 - 50 ,375 )
		:addTo(self)
		
	cc.Label:createWithTTF(msg3, "fonts/round_body.ttf", not txtsize and PopInfoDialog.DEF_TEXT_SIZE or txtsize)
		:setTextColor(cc.c4b(255,255,255,255))
		:setAnchorPoint(cc.p(0.5,0.5))
		:setDimensions(600, 180)
		:setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
		:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		:move(appdf.WIDTH/2 - 50 ,375 - 50 )
		:addTo(self)
		
	cc.Label:createWithTTF(msg4, "fonts/round_body.ttf", not txtsize and PopInfoDialog.DEF_TEXT_SIZE or txtsize)
		:setTextColor(cc.c4b(255,255,255,255))
		:setAnchorPoint(cc.p(0.5,0.5))
		:setDimensions(600, 180)
		:setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
		:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		:move(appdf.WIDTH/2 + 100 ,375 +50 )
		:addTo(self)
		
	cc.Label:createWithTTF(msg5, "fonts/round_body.ttf", not txtsize and PopInfoDialog.DEF_TEXT_SIZE or txtsize)
		:setTextColor(cc.c4b(255,255,255,255))
		:setAnchorPoint(cc.p(0.5,0.5))
		:setDimensions(600, 180)
		:setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
		:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		:move(appdf.WIDTH/2 + 100 ,375 )
		:addTo(self)
		
	cc.Label:createWithTTF(msg6, "fonts/round_body.ttf", not txtsize and PopInfoDialog.DEF_TEXT_SIZE or txtsize)
		:setTextColor(cc.c4b(255,255,255,255))
		:setAnchorPoint(cc.p(0.5,0.5))
		:setDimensions(600, 180)
		:setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
		:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		:move(appdf.WIDTH/2 + 100 ,375 - 50 )
		:addTo(self)
		
--[[		cc.Label:createWithTTF(msg, "fonts/round_body.ttf", not txtsize and PopInfoDialog.DEF_TEXT_SIZE or txtsize)
		:setTextColor(cc.c4b(255,255,255,255))
		:setAnchorPoint(cc.p(0.5,0.5))
		:setDimensions(600, 180)
		:setString("����ID:")
		:setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
		:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		:move(appdf.WIDTH/2 ,375 )
		:addTo(self)--]]
		
		
	self._dismiss  = false
	self:runAction(cc.MoveTo:create(0.3,cc.p(0,0)))
end

--�������
function PopInfoDialog:onButtonClickedEvent(tag,ref)
	if self._dismiss == true then
		return
	end
	--ȡ����ʾ
	self:dismiss()
	--֪ͨ�ص�
	if self._callback then
		self._callback(tag == PopInfoDialog.BT_CONFIRM)
	end
end

--ȡ����ʧ
function PopInfoDialog:dismiss()
	self._dismiss = true
	local this = self
	self:stopAllActions()
	self:runAction(
		cc.Sequence:create(
			cc.MoveTo:create(0.3,cc.p(0,appdf.HEIGHT)),
			cc.CallFunc:create(function()
					this:removeSelf()
				end)
			))	
end

return PopInfoDialog
