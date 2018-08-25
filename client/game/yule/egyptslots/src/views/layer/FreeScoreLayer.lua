--
-- Author: luo
-- Date: 2016年12月26日 20:24:43
--
local FreeScoreLayer = class("FreeScoreLayer", cc.Layer)

function FreeScoreLayer:ctor(beginNum,endNum,dis,obj)
	
	self._beginNum = tonumber(beginNum) 
	
	self._endNum =  tonumber(endNum) 
	
	self._dis  = tonumber(dis) 
	
	self._obj = obj
	
	self._obj.m_gameStart = true
	
	self:init()
end

function FreeScoreLayer:init()
	
	self:setTouchEnabled(true)
	
	self.bg = cc.Sprite:create("game1/FreeBg.png")
	self.bg:addTo(self)
	self.bg:setAnchorPoint(0.5,0.5)
	self.bg:setPosition(cc.p(1334/2,750/2))
	
	
	--创建文本-将文本加入节点中
	self.size = self:getContentSize()

	self.txt = cc.LabelAtlas:_create("0", "game1/shuzi5.png", 42,67, string.byte("/")) 
	self.txt:move(self.size.width/2,self.size.height/2-140)
--	self.txt:setPosition(cc.p(0,0))
	self.txt:setAnchorPoint(cc.p(0.5,0.5))
	self:addChild(self.txt)
	
	local coninsStr =string.formatNumberThousands(self._beginNum,true,"/")
	self.txt:setString(coninsStr)		
    local taction = {}
	
--延迟
    local delay =cc.DelayTime:create(0.01)
    table.insert(taction,delay)
		
--扩大
	local scale = cc.ScaleTo:create(0.2,2)
	local scale2 = cc.ScaleTo:create(0.2,1)
	table.insert(taction,scale)
	table.insert(taction,scale2)
		
-- 数值改变
--[[    math.randomseed(3000)
    _dis = math.random(300,400)
	_dis = 100
    print(_dis)--]]
	
    local rtime = (self._endNum-self._beginNum)/self._dis
     print(rtime)
		
    function chagenum()
        if (self._beginNum <self._endNum) then
           self._beginNum= self._beginNum +self._dis
			local coninsStr =string.formatNumberThousands(self._beginNum,true,"/")
            self.txt:setString(coninsStr)
        elseif (self._beginNum ==  self._endNum) then
			local coninsStr =string.formatNumberThousands(self._endNum,true,"/")
            self.txt:setString(coninsStr)
        end
    end
    local seq = cc.Sequence:create(delay,cc.CallFunc:create(chagenum))
	--数字翻滚
    local X = self.size.width/2
    local Y = self.size.height/2-140
    local UPY = 2*Y
    local DownY = 0
    local move1 = cc.MoveTo:create(0.05,cc.p(X,UPY))
    local move2 = cc.MoveTo:create(0.05,cc.p(X,DownY))
    local move3 = cc.MoveTo:create(0.05,cc.p(X,Y))

	
	local UP    = cc.Sequence:create(move1)
    local Down  = cc.Sequence:create(move2,move3)
    local spawn = cc.Spawn:create(UP,seq,Down)
    local rep   = cc.Repeat:create(spawn,rtime)
	
	--设置真值
    local function setnum()
        self._beginNum =  self._endNum
		local coninsStr =string.formatNumberThousands(self._beginNum,true,"/")
        self.txt:setString(coninsStr)
    end

    local call = cc.CallFunc:create(setnum)
	local call11 = cc.DelayTime:create(2)
	local call22 = cc.CallFunc:create(function()
		self._obj.m_gameStart  = false
		self:removeFromParent()
	end)
    local seq2 = cc.Sequence:create(rep,delay,call,call11,call22)
        table.insert(taction,seq2)
        table.insert(taction,scale)
        table.insert(taction,scale2)
    local seqaction = cc.Sequence:create(taction)
    self.txt:runAction(seqaction)
	
end

return FreeScoreLayer