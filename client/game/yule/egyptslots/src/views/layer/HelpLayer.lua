--
-- Author: luo
-- Date: 2016年12月26日 20:24:43
--
local HelpLayer = class("HelpLayer", cc.Layer)
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")


HelpLayer.BT_CLOSE = 1

function HelpLayer:ctor( parent )
	--注册触摸事件
	ExternalFun.registerTouchEvent(self, true)
	--加载csb资源
	self._csbNode = ExternalFun.loadCSB("helpLayer.csb", self)
	
	local cbtlistener = function (sender,eventType)
		if eventType == ccui.TouchEventType.ended then
			self:OnButtonClickedEvent(sender:getTag(),sender)
		end
	end
	
	self._csPanel = self._csbNode:getChildByName("Panel_1")
    self._csPanel:setBackGroundColorOpacity(0)
	self.m_btnleft = self._csPanel:getChildByName("BT_Close")
	self.m_btnleft:setTag(HelpLayer.BT_CLOSE)
	self.m_btnleft:addTouchEventListener(cbtlistener)
end

function HelpLayer:OnButtonClickedEvent( tag, sender )
	if HelpLayer.BT_CLOSE == tag then
		ExternalFun.playClickEffect()
		if self._closeCallback ~= nil then
		    self._closeCallback()
		end
		self._csbNode:removeFromParent()
		self:removeFromParent()
	end
end

function HelpLayer:setCloseCallback(closeCallback)
        self._closeCallback = closeCallback
end

function HelpLayer:onTouchBegan( touch, event )
	return self:isVisible()
end

return HelpLayer