local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")

local FruitItem = class("FruitItem")

FruitItem.GAME_IMG_TAG = 100

function FruitItem:ctor()
	
	self._fruitItem = {}
	
	self._fruitItemIcon = 
	{
		"common_icon_01.png",
		"common_icon_02.png",
		"common_icon_03.png",
		"common_icon_04.png",
		"common_icon_05.png",
		"common_icon_06.png",
		"common_icon_07.png",
		"common_icon_08.png",
		"common_icon_09.png",
		"common_icon_010.png",
		"common_icon_011.png",
	}
	

	
	self.strAnimePath = 
	{
		"1_%d.png",
		"2_%d.png",
		"3_%d.png",
		"4_%d.png",
		"5_%d.png",
		"6_%d.png",
		"7_%d.png",
		"8_%d.png",
		"9_%d.png",
		"10_%d.png",
		"11_%d.png",
	}
	
	self:init()
end

function FruitItem:init()
	for i =1,5 do	--5行
		self._fruitItem[i] = {}
		for v = 1,3 do	--3列
			local sprite = cc.Sprite:create()
			sprite:retain() 
			table.insert(self._fruitItem[i],sprite)
		end
	end
end

function FruitItem:setFruitItemIcon(row,col,index)
	local item = self._fruitItem[tonumber(row)][tonumber(col)]
	local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(self._fruitItemIcon[tonumber(index)])
	item:cleanup()
	item:setSpriteFrame(spriteFrame)
	return item
end

function FruitItem:getFruitItemSpriteFrame(index)
	local str = self._fruitItemIcon[index]
	return cc.SpriteFrameCache:getInstance():getSpriteFrame(str)
end

function FruitItem:getFruitItem(row,col)
	return self._fruitItem[tonumber(row)][tonumber(col)]
end

function FruitItem:playAnimation(row,col,index)
	local item = self._fruitItem[tonumber(row)][tonumber(col)]
	
	--播放序列帧动画
	local animation =cc.Animation:create()
	if index > 8 then
		return
	end
	for i=1,4 do
		local frameName =string.format(self.strAnimePath[index],i)
		local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)
		if spriteFrame == nil then
			local nErrDate = 0;
			nErrDate= nErrDate+1
		end
		animation:addSpriteFrame(spriteFrame)
	end  
	animation:setDelayPerUnit(3/4)--设置两个帧播放时间                   
	animation:setRestoreOriginalFrame(false)    		--动画执行后还原初始状态    

	local action =cc.Animate:create(animation)
	local seq =   cc.Sequence:create(
			action,
			cc.CallFunc:create(function (  )
				local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(self._fruitItemIcon[tonumber(index)])
				item:setSpriteFrame(frame)
			end)
		)
	item:runAction(action)
end

return FruitItem