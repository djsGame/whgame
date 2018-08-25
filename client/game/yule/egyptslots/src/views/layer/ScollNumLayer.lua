--
-- Author: luo
-- Date: 2016��12��26�� 20:24:43
--
local ScollNumLayer = class("ScollNumLayer", cc.Layer)

function ScollNumLayer:ctor()
	
	--�����ı�-���ı�����ڵ���
	self.size = self:getContentSize()

	self.txt = cc.LabelAtlas:_create("0", "game1/shuzi5.png", 42,67, string.byte("/")) 
	self.txt:move(self.size.width/2,self.size.height/2)
	self.txt:setAnchorPoint(cc.p(0.5,0.5))
	self:addChild(self.txt)		
	
end

function ScollNumLayer:start(beginNum,endNum,dis)

	self._beginNum = tonumber(beginNum) 
	
	self._endNum   = tonumber(endNum) 	

	self._dis      = tonumber(dis)
			
	local coninsStr =string.formatNumberThousands(self._beginNum,true,"/")
	self.txt:setString(self._beginNum)		
    local taction = {}
	
--�ӳ�
    local delay =cc.DelayTime:create(0.01)
    table.insert(taction,delay)
		
--����
	local scale = cc.ScaleTo:create(0.2,2)
	local scale2 = cc.ScaleTo:create(0.2,1)
	table.insert(taction,scale)
	table.insert(taction,scale2)
		
-- ��ֵ�ı�
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
            self.txt:setString(self._endNum)
        end
    end
    local seq = cc.Sequence:create(delay,cc.CallFunc:create(chagenum))
	--���ַ���
    local X = self.size.width/2
    local Y = self.size.height/2
    local UPY = 2*Y
    local DownY = 0
    local move1 = cc.MoveTo:create(0.05,cc.p(X,UPY))
    local move2 = cc.MoveTo:create(0.05,cc.p(X,DownY))
    local move3 = cc.MoveTo:create(0.05,cc.p(X,Y))

	
	local UP    = cc.Sequence:create(move1)
    local Down  = cc.Sequence:create(move2,move3)
    local spawn = cc.Spawn:create(UP,seq,Down)
    local rep   = cc.Repeat:create(spawn,rtime)
	
	--������ֵ
    local function setnum()
        self._beginNum =  self._endNum
		local coninsStr =string.formatNumberThousands(self._beginNum,true,"/")
        self.txt:setString(coninsStr)
    end

    local call = cc.CallFunc:create(setnum)
    local seq2 = cc.Sequence:create(rep,delay,call)
        table.insert(taction,seq2)
        table.insert(taction,scale)
        table.insert(taction,scale2)
    local seqaction = cc.Sequence:create(taction)
    self.txt:runAction(seqaction)
	
end

return ScollNumLayer