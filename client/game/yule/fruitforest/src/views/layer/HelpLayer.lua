--
-- Author: luo
-- Date: 2016年12月26日 20:24:43
--
local HelpLayer = class("HelpLayer", cc.Layer)
local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")

HelpLayer.BT_LEFT = 1
HelpLayer.BT_RIGHT = 2
HelpLayer.BT_CLOSE = 3

function HelpLayer:ctor( parent )
	--注册触摸事件
	ExternalFun.registerTouchEvent(self, true)
	--加载csb资源
	self._csbNode = ExternalFun.loadCSB("helpLayer.csb", parent)
	--self._csbNode:setPosition(1334/2,750/2);
	
	local cbtlistener = function (sender,eventType)
		if eventType == ccui.TouchEventType.ended then
			self:OnButtonClickedEvent(sender:getTag(),sender)
		end
	end
	
	self._csPanel = self._csbNode:getChildByName("Panel_1")
	
	self.m_btnleft = self._csPanel:getChildByName("Button_1")
	self.m_btnleft:setTag(HelpLayer.BT_LEFT)
	self.m_btnleft:addTouchEventListener(cbtlistener)
	
	self.m_btnRight = self._csPanel:getChildByName("Button_2")
	self.m_btnRight:setTag(HelpLayer.BT_RIGHT)
	self.m_btnRight:addTouchEventListener(cbtlistener)
	
	self.m_btnClose = self._csPanel:getChildByName("BT_CLOSE")
	self.m_btnClose:setTag(HelpLayer.BT_CLOSE)
	self.m_btnClose:addTouchEventListener(cbtlistener)
	
	
	self._PlayIndex=1
	
	
end

function HelpLayer:OnButtonClickedEvent( tag, sender )
	local PlayImage = self._csPanel:getChildByName("Image_1")
	if HelpLayer.BT_LEFT == tag then
		if self._PlayIndex>1 then
			self._PlayIndex = self._PlayIndex-1
		end
	elseif HelpLayer.BT_RIGHT == tag then
		if self._PlayIndex<3 then
			self._PlayIndex = self._PlayIndex+1
		end
	end
	
	local strFileName = string.format("setting/TableView%d.png",self._PlayIndex)
	if strFileName then
		PlayImage:loadTexture(strFileName)
	end
	
	for i=1,3 do
		local strNodeName = string.format("Normal%d",i)
		local NodeImage = self._csPanel:getChildByName(strNodeName)
		if i == self._PlayIndex then
			NodeImage:loadTexture("setting/select.png")
		else
			NodeImage:loadTexture("setting/Normal.png")
		end
	end
	
	
	if HelpLayer.BT_CLOSE == tag then
		ExternalFun.playClickEffect()
		self._csbNode:removeFromParent()
		self:removeFromParent()
	end
	
end

function HelpLayer:onTouchBegan( touch, event )
	return self:isVisible()
end

return HelpLayer