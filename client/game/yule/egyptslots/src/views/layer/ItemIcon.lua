local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")

local ItemIcon = class("ItemIcon")

function ItemIcon:ctor()
	self._ItemIconTable = {}
	self._Icon = 
	{
		"common_icon_001.png",
		"common_icon_002.png",
		"common_icon_003.png",
		"common_icon_004.png",
		"common_icon_005.png",
		"common_icon_006.png",
		"common_icon_007.png",
		"common_icon_008.png",
		"common_icon_009.png",
		"common_icon_010.png",
		"common_icon_011.png",
		"common_icon_999.png",
	}
	self:init()
end

function ItemIcon:init()
	for i =1,5 do	--5行
		self._ItemIconTable[i] = {}
		for v = 1,3 do	--3列
			local sprite = cc.Sprite:create()
			sprite:retain() 
			table.insert(self._ItemIconTable[i],sprite)
		end
	end
end

function ItemIcon:setItemIcon(row,col,index)
	local item = self._ItemIconTable[tonumber(row)][tonumber(col)]
	local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(self._Icon[tonumber(index)])
	item:cleanup()
	item:setSpriteFrame(spriteFrame)
	return item
end

function ItemIcon:getItemIconSpriteFrame(index)
	return cc.SpriteFrameCache:getInstance():getSpriteFrame(self._Icon[tonumber(index)])
end

function ItemIcon:getItemIcon(row,col)
	return self._ItemIconTable[tonumber(row)][tonumber(col)]
end

function ItemIcon:playAnimation(row,col,index)

end

return ItemIcon