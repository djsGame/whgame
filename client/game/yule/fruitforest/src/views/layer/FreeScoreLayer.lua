--
-- Author: luo
-- Date: 2016年12月26日 20:24:43
--
local FreeScoreLayer = class("FreeScoreLayer", cc.Layer)

function FreeScoreLayer:ctor(beginNum,endNum,dis)
	
	self._beginNum = tonumber(beginNum) 
	
	self._endNum =  tonumber(endNum) 
	
	self._dis  = tonumber(dis) 
	
	self:init()
end

function FreeScoreLayer:init()
	
	self.bg = cc.Sprite:create("game1/FreeScore.png")
	self.bg:addTo(self)
	self.bg:setAnchorPoint(0.5,0.5)
	self.bg:setPosition(cc.p(1334/2,750/2))
	
	
	--创建文本-将文本加入节点中
	self.size = self:getContentSize()

	self.txt = cc.LabelAtlas:_create("0", "game1/shuzi5.png", 42,67, string.byte("/")) 
	self.txt:move(self.size.width/2,self.size.height/2-80)
--	self.txt:setPosition(cc.p(0,0))
	self.txt:setAnchorPoint(cc.p(0.5,0.5))
	self:addChild(self.txt)
	local coninsStr =string.formatNumberThousands(self._endNum,true,"/")
	self.txt:setString(coninsStr)
	
	local action4 = cc.FadeOut:create(1)
	self:runAction(cc.Sequence:create(action4,cc.CallFunc:create(function()
		self:removeFromParent()
	end
	)))	
end

return FreeScoreLayer