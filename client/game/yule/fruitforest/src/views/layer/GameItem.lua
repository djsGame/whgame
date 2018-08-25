local ExternalFun = require(appdf.EXTERNAL_SRC .. "ExternalFun")

local cmd = "game.yule.fruitforest.src.models.CMD_Game"

local emItemState = 
{
	"STATE_NORMAL",		--正常
	"STATE_SELECT",		--中奖
	"STATE_GREY"		--变灰
}
local ITEM_STATE = ExternalFun.declarEnumWithTable(0, emItemState);

local GameItem = class("GameItem",cc.ClippingRectangleNode)

--序列帧个数
GameItem.ACT_FUTOU_NUM					= 4			--斧头
GameItem.ACT_YINQIANG_NUM				= 4			--银抢
GameItem.ACT_DADAO_NUM 					= 4			--大刀
GameItem.ACT_LU_NUM						= 4			--鲁智深
GameItem.ACT_LIN_NUM					= 4			--打鼓
GameItem.ACT_SONG_NUM					= 4			--宋江
GameItem.ACT_TITIANXINGDAO_NUM 			= 4			--替天行道
GameItem.ACT_ZHONGYITANG_NUM			= 4			--忠义堂
GameItem.ACT_ZHONGYITANG_NUM1			= 4			--忠义堂
GameItem.ACT_ZHONGYITANG_NUM2			= 4			--忠义堂
GameItem.ACT_ZHONGYITANG_NUM3			= 4			--水浒传

GameItem.GAME_IMG_TAG = 100

function GameItem:ctor(  )

end
--初始化
function GameItem:created( nType )

	self.m_bIsEnd = false
	self.m_nType = -1
	self.m_pSprite = nil

	self:initNotice()
	self:setItemType(nType)
end

function GameItem:initNotice(  )
	--self:setClippingRegion(cc.rect(0,0,210,149))
    self:setClippingRegion(cc.rect(0,0,126,126))
	self:setClippingEnabled(true)

end

function GameItem:setItemType( nType )
	self.m_nType = nType
end

function GameItem:getItemType( )
	return self.m_nType
end

function GameItem:beginMove( deyTime )
	if self.m_pSprite == nil then
		self.m_pSprite = cc.Sprite:create("common_MoveImg.png")
	end

	self:addChild(self.m_pSprite,0)
	--self.m_pSprite:setPosition(cc.p(6,689))
	self.m_pSprite:setPosition(cc.p(49,-1100))
	--self.m_pSprite:setVisible(true)
    --self.m_pSprite:setPosition(cc.p(0,689))

--[[	local actMove = cc.RepeatForever:create(
		cc.Sequence:create(
			--cc.MoveBy:create(0.5,cc.p(0,-1378)),
			--cc.MoveTo:create(0.01,cc.p(105.5,689)),
			cc.MoveBy:create(0.5,cc.p(0,-1000)),
			cc.MoveTo:create(0.01,cc.p(49,539))
			)
		)--]]
	--actMove:setTag(GameItem.GAME_IMG_TAG)
	--self.m_pSprite:runAction(actMove)
	self.m_pSprite:runAction(
		cc.Sequence:create(
			cc.DelayTime:create(deyTime),
			cc.CallFunc:create(function (  )
				self:beginJump()
			end)
			)
		)
end

function GameItem:beginJump(  )
	if self.m_bIsEnd == true then
		return
	end
	local strPath = 
	{
		"jump_futou_0%d.png",
		"jump_yin_0%d.png",
		"jump_dadao_0%d.png",
		"jump_lu_0%d.png",
		"jump_lin_0%d.png",
		"jump_song_0%d.png",
		"jump_ttxd_0%d.png",
		"jump_zyt_0%d.png",
		"jump_Bouns_0%d.png",
		"jump_Scatter_0%d.png",
		"jump_shz_0%d.png",
	}
	if self.m_pSprite ~= nil then
		self.m_pSprite:stopAction(self.m_pSprite:getActionByTag(GameItem.GAME_IMG_TAG))
		local imageFile = string.format(strPath[self.m_nType],1)
		local spriteFirstFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(imageFile)
		if spriteFirstFrame == nil then
				local nErrDate = 0;
				nErrDate= nErrDate+1
		end
		
		self.m_pSprite:setSpriteFrame(spriteFirstFrame)

		local animation =cc.Animation:create()
		for i=1,5 do
		    local frameName =string.format(strPath[self.m_nType],i)  

		    print("frameName =%s",frameName)
		    local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)
			if spriteFrame == nil then
				local nErrDate = 0;
				nErrDate= nErrDate+1
			end
		   animation:addSpriteFrame(spriteFrame)
		end  
	   	animation:setDelayPerUnit(0.05)          --设置两个帧播放时间                   
	   	animation:setRestoreOriginalFrame(false)    --动画执行后还原初始状态    

	   	local action =cc.Animate:create(animation)   

	   	local seq = cc.Sequence:create(
	   		action,
	   		cc.CallFunc:create(function (  )
	   			self.m_bIsEnd = true
	   		end)
	   		)

	   	self.m_pSprite:runAction(seq)
	self.m_pSprite:setAnchorPoint(0.5,0.5)
	self.m_pSprite:setPosition(cc.p(self.m_pSprite:getContentSize().width/2,self.m_pSprite:getContentSize().height/2+3))
	end
end

function GameItem:stopAllItemAction(  )
	self.m_bIsEnd = true
	if self.m_pSprite ~= nil then
		self.m_pSprite:stopAllActions()
	else
		print("不存在这个GameItem")
	end
	self:setState(ITEM_STATE.STATE_NORMAL)
	self:stopAllActions()
end


function GameItem:setState( nState )
	self.m_bIsEnd = true
	local strPath = 
	{
		"common_icon_%d1.png",
		"common_icon_%d2.png",
		"common_icon_%d3.png",
		"common_icon_%d4.png",
		"common_icon_%d5.png",
		"common_icon_%d6.png",
		"common_icon_%d7.png",
		"common_icon_%d8.png",
		"common_icon_%d9.png",
		"common_icon_%d10.png",
		"common_icon_%d11.png",
	}
	local strAnimePath = 
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
	--序列帧数目
	local nAnimeNum = 
	{
		GameItem.ACT_FUTOU_NUM,
		GameItem.ACT_YINQIANG_NUM,
		GameItem.ACT_DADAO_NUM,
		GameItem.ACT_LU_NUM,
		GameItem.ACT_LIN_NUM,
		GameItem.ACT_SONG_NUM,
		GameItem.ACT_TITIANXINGDAO_NUM,
		GameItem.ACT_ZHONGYITANG_NUM,
		GameItem.ACT_SHUIHUZHUAN_NUM
	}

	if nState == ITEM_STATE.STATE_NORMAL then
		--正常纹理
		local frameName =string.format(strPath[self.m_nType],0)
		--print(frameName)
	    local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)
		
		if spriteFrame == nil then
				local nErrDate = 0;
				nErrDate= nErrDate+1
		end
		
		
	    if self.m_pSprite then
			self.m_pSprite:setSpriteFrame(spriteFrame)
		else
			self.m_pSprite = cc.Sprite:create()
			self.m_pSprite:setSpriteFrame(spriteFrame)
	    end

	elseif	nState == ITEM_STATE.STATE_SELECT then
		--播放序列帧动画
		local animation =cc.Animation:create()
		if self.m_nType>8 then
			return
		end
		for i=1,nAnimeNum[self.m_nType] do
		    local frameName =string.format(strAnimePath[self.m_nType],i)
		    --print("frameName =%s",frameName)
		    local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)
			if spriteFrame == nil then
				local nErrDate = 0;
				nErrDate= nErrDate+1
			end
		
		   	animation:addSpriteFrame(spriteFrame)
		end  
	   	animation:setDelayPerUnit(3/nAnimeNum[self.m_nType])          --设置两个帧播放时间                   
	   	animation:setRestoreOriginalFrame(false)    --动画执行后还原初始状态    

	   	local action =cc.Animate:create(animation)
	   	local seq =   cc.Sequence:create(
	   			action,
	   			cc.CallFunc:create(function (  )
					local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format(strPath[self.m_nType],0))  

	   				self.m_pSprite:setSpriteFrame(frame)
	   			end)
	   		)
	   	self.m_pSprite:runAction(action)

	elseif	nState == ITEM_STATE.STATE_GREY then
		--灰色纹理
		local frameName =string.format(strPath[self.m_nType],0)
		--print("frameName =%s",frameName)       
       
	    local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)
		if spriteFrame == nil then
				local nErrDate = 0;
				nErrDate= nErrDate+1
			end  
		self.m_pSprite:setSpriteFrame(spriteFrame)
	end
	self.m_pSprite:setAnchorPoint(0.5,0.5)
	self.m_pSprite:setPosition(cc.p(self.m_pSprite:getContentSize().width/2,self.m_pSprite:getContentSize().height/2+3))

end

return GameItem