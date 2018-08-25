local GameLogic = GameLogic or {}

--数目定义
GameLogic.ITEM_COUNT 				= 11			--图标数量
GameLogic.ITEM_X_COUNT				= 5				--图标横坐标数量
GameLogic.ITEM_Y_COUNT				= 3				--图标纵坐标数量
GameLogic.YAXIANNUM					= 9				--压线数字

--逻辑类型
--GameLogic.CT_FUTOU					= 0				--斧头
--GameLogic.CT_LANZHUAN				= 1				--银抢
--GameLogic.CT_SHIZIJIA					= 2				--大刀
--GameLogic.CT_RENSHIZI						= 3				--鲁
--GameLogic.CT_YINGZUI					= 4				--林
--GameLogic.CT_GOUTOU					= 5				--宋
--GameLogic.CT_GUOWANG			= 6				--替天行道
--GameLogic.CT_NVGUOWANG			= 7				--忠义堂
--GameLogic.CT_WILD			= 8				--水浒传




GameLogic.CT_YAOSHI					= 0				--钥匙
GameLogic.CT_LANZHUAN				= 1				--蓝转
GameLogic.CT_SHIZIJIA				= 2				--十字架
GameLogic.CT_RENSHIZI				= 3				--人狮
GameLogic.CT_YINGZUI				= 4				--鹰嘴
GameLogic.CT_GOUTOU					= 5				--狗头
GameLogic.CT_GUOWANG				= 6				--国王
GameLogic.CT_NVGUOWANG				= 7				--女国王
GameLogic.CT_BONUS					= 8				--BONUS
GameLogic.CT_SCATTER				= 9				--SCATTER 连续三列出现sactter既可活的免费要游戏五次
GameLogic.CT_WILD					= 10				--WILD    能代替除scatter和bonus之后的任何图案

--[[	CPoint(0, 0), CPoint(0, 1), CPoint(0, 2), CPoint(0, 3), CPoint(0, 4),
CPoint(1, 0), CPoint(1, 1), CPoint(1, 2), CPoint(1, 3), CPoint(1, 4),
CPoint(2, 0), CPoint(2, 1), CPoint(2, 2), CPoint(2, 3), CPoint(2, 4),
CPoint(0, 0), CPoint(1, 1), CPoint(2, 2), CPoint(1, 3), CPoint(0, 4),
CPoint(2, 0), CPoint(1, 1), CPoint(0, 2), CPoint(1, 3), CPoint(2, 4),
CPoint(0, 0), CPoint(0, 1), CPoint(1, 2), CPoint(2, 3), CPoint(2, 4),
CPoint(2, 0), CPoint(2, 1), CPoint(1, 2), CPoint(0, 3), CPoint(0, 4),
CPoint(1, 0), CPoint(0, 1), CPoint(2, 2), CPoint(2, 3), CPoint(1, 4),
CPoint(1, 0), CPoint(2, 1), CPoint(2, 2), CPoint(0, 3), CPoint(1, 4)--]]


--可能中奖的位置线
GameLogic.m_ptXian = {}
GameLogic.m_ptXian[1] = {{x=1,y=1},{x=1,y=2},{x=1,y=3},{x=1,y=4},{x=1,y=5}} --1
GameLogic.m_ptXian[2] = {{x=2,y=1},{x=2,y=2},{x=2,y=3},{x=2,y=4},{x=2,y=5}}	--2
GameLogic.m_ptXian[3] = {{x=3,y=1},{x=3,y=2},{x=3,y=3},{x=3,y=4},{x=3,y=5}}	--3
GameLogic.m_ptXian[4] = {{x=1,y=1},{x=2,y=2},{x=3,y=3},{x=2,y=4},{x=1,y=5}}	--4
GameLogic.m_ptXian[5] = {{x=3,y=1},{x=2,y=2},{x=1,y=3},{x=2,y=4},{x=3,y=5}}	--5
GameLogic.m_ptXian[6] = {{x=1,y=1},{x=1,y=2},{x=2,y=3},{x=3,y=4},{x=3,y=5}}	--6
GameLogic.m_ptXian[7] = {{x=3,y=1},{x=3,y=2},{x=2,y=3},{x=1,y=4},{x=1,y=5}}	--7
GameLogic.m_ptXian[8] = {{x=2,y=1},{x=1,y=2},{x=2,y=3},{x=3,y=4},{x=2,y=5}} --8
GameLogic.m_ptXian[9] = {{x=2,y=1},{x=3,y=2},{x=2,y=3},{x=1,y=4},{x=2,y=5}} --9
----------------------------------------------------------
----------------------------------------------------------
--取得中奖分数
function GameLogic:GetZhongJiangTime( cbIndex ,cbItemInfo )
	local ptXian = GameLogic.m_ptXian[cbIndex]
	local item_x_count = GameLogic.ITEM_X_COUNT
	local nTime = 0
	local bLeftLink = true
	local nLeftBaseLindCount = 0
	local cbLeftFirstIndex = 1
	
	
	for i=1,item_x_count do
		--左
		if cbItemInfo[ptXian[i].x][ptXian[i].y] >= GameLogic.CT_BONUS and  bLeftLink == true then
			cbLeftFirstIndex = i
			bLeftLink = false
		end
	end
	
	bLeftLink = true
	
	
	for i=1,item_x_count do
		--左到右基本奖
		if cbItemInfo[ptXian[cbLeftFirstIndex].x][ptXian[cbLeftFirstIndex].y] == cbItemInfo[ptXian[i].x][ptXian[i].y] or cbItemInfo[ptXian[i].x][ptXian[i].y] == GameLogic.CT_WILD and bLeftLink == true then
			nLeftBaseLindCount = nLeftBaseLindCount + 1
		else
			bLeftLink = false
		end
	end
	

	
		
	
	if nLeftBaseLindCount == 5 then
		local itemType  = cbItemInfo[ptXian[cbLeftFirstIndex].x][ptXian[cbLeftFirstIndex].y]
		if itemType == GameLogic.CT_YAOSHI then
			nTime = nTime + 50
		elseif itemType == GameLogic.CT_LANZHUAN then
			nTime = nTime + 70
		elseif itemType == GameLogic.CT_SHIZIJIA then
			nTime = nTime + 100
		elseif itemType == GameLogic.CT_RENSHIZI then
			nTime = nTime + 500
		elseif itemType == GameLogic.CT_YINGZUI then
			nTime = nTime + 650
		elseif itemType == GameLogic.CT_GOUTOU then
			nTime = nTime + 800
		elseif itemType == GameLogic.CT_GUOWANG then
			nTime = nTime + 1200
		elseif itemType == GameLogic.CT_NVGUOWANG then
			nTime = nTime + 2000
		end
		
	elseif nLeftBaseLindCount == 3 or nLeftBaseLindCount == 4 then
		local itemType  = cbItemInfo[ptXian[cbLeftFirstIndex].x][ptXian[cbLeftFirstIndex].y]
		if itemType == GameLogic.CT_YAOSHI then
			nTime = nTime + (nLeftBaseLindCount == 3 and 3 or 10)
		elseif  itemType == GameLogic.CT_LANZHUAN then
			nTime = nTime + (nLeftBaseLindCount == 3 and 5 or 15)
		elseif  itemType == GameLogic.CT_SHIZIJIA then
			nTime = nTime + (nLeftBaseLindCount == 3 and 10 or 30)
		elseif  itemType == GameLogic.CT_RENSHIZI then
			nTime = nTime + (nLeftBaseLindCount == 3 and 30 or 70)
		elseif  itemType == GameLogic.CT_YINGZUI then
			nTime = nTime + (nLeftBaseLindCount == 3 and 35 or 80)
		elseif  itemType == GameLogic.CT_GOUTOU then
			nTime = nTime + (nLeftBaseLindCount == 3 and 45 or 100)
		elseif  itemType == GameLogic.CT_GUOWANG then
			nTime = nTime + (nLeftBaseLindCount == 3 and 75 or 175)
		elseif  itemType == GameLogic.CT_NVGUOWANG then
			nTime = nTime + (nLeftBaseLindCount == 3 and 80 or 200)
		end
	elseif nLeftBaseLindCount == 2 then
		local itemType  = cbItemInfo[ptXian[cbLeftFirstIndex].x][ptXian[cbLeftFirstIndex].y]
		if itemType == GameLogic.CT_YAOSHI then
			nTime = nTime + 1
		elseif  itemType == GameLogic.CT_LANZHUAN then
			nTime = nTime + 2
		elseif  itemType == GameLogic.CT_SHIZIJIA then
			nTime = nTime + 3
		end
	end
	return nTime
end
--全部中奖信息
function GameLogic:GetAllZhongJiangInfo( cbItemInfo ,ptZhongJiang,nCount)
	
	for i=1,nCount do
		local nCount=self:GetZhongJiangXian(cbItemInfo,GameLogic.m_ptXian[i],ptZhongJiang[i])
	end
end
--单条中奖信息
function GameLogic:getZhongJiangInfo( cbIndex ,cbItemInfo)--,cbZhongJiang)
	local cbZhongJiang = {}
	if cbIndex == 5 then
		local aaa=0;
		aaa=aaa+1
	end
	return self:GetZhongJiangXian(cbItemInfo,GameLogic.m_ptXian[cbIndex],cbZhongJiang)
end

--全盘中奖
function GameLogic:GetQuanPanJiangTime( cbItemInfo )
	local nTime = 0
	return nTime
end
--单线中奖
function GameLogic:GetZhongJiangXian( cbItemInfo,ptXian,ptZhongJiang )
	local item_x_count = GameLogic.ITEM_X_COUNT
	local nTime = 0
	local bLeftLink = true
	local nLeftBaseLinkCount = 0
	local cbLeftFirstIndex = 1
	for i=1,GameLogic.ITEM_X_COUNT do
		local nDate = i
		local nIndex1 = ptXian[i].x
		local nIndex2 = ptXian[i].y
		if nIndex1>3 or nIndex2>5 then
			local nErrDate =0;
			nErrDatenErrDate=nErrDate+1
		end
		
--		print("nIndex1="..nIndex1.."nIndex2="..nIndex2.."i="..i)
			
		if cbItemInfo[nIndex1][nIndex2] ~= GameLogic.CT_WILD and  bLeftLink == true then
			cbLeftFirstIndex = i
			bLeftLink = false
		end
	end
	
	bLeftLink = true
	
	--BONUS
--GameLogic.CT_SCATTER				= 9				--SCATTER 连续三列出现sactter既可活的免费要游戏五次
--GameLogic.CT_WILD					= 10				--WILD    能代替除scatter和bonus之后的任何图案
	
	--中奖线
	for i=1,item_x_count do
		local temp = cbItemInfo[ptXian[i].x][ptXian[i].y]
		if temp > 7 and temp < 10 then --BOUNUS,SCATTER,WILD 不中奖
			bLeftLink = false
			break
		end
		--从左到右基本奖
		if (cbItemInfo[ptXian[cbLeftFirstIndex].x][ptXian[cbLeftFirstIndex].y] == cbItemInfo[ptXian[i].x][ptXian[i].y]  or  cbItemInfo[ptXian[i].x][ptXian[i].y] == GameLogic.CT_WILD ) and bLeftLink == true  then
			nLeftBaseLinkCount = nLeftBaseLinkCount+1
		else
			bLeftLink = false
		end
	end
	
	--如果是1到3图案数量是2个 可以中奖
	local nItemReturnCount=3
	local nItemLeftIndex = cbItemInfo[ptXian[cbLeftFirstIndex].x][ptXian[cbLeftFirstIndex].y]
	if nItemLeftIndex <3 and nLeftBaseLinkCount==2 then
		nItemReturnCount=2
	end
	
	
	
	local nLinkCount = 0
	local nTableCount =#ptZhongJiang
	if nTableCount<=0 then
		local nLinkCountDate = 0
		if nLeftBaseLinkCount >=nItemReturnCount then
			nLinkCount = nLinkCountDate + nLeftBaseLinkCount
		end
		
		return math.min(5,nLinkCount)
	end
	
	
	
	if nLeftBaseLinkCount >=nItemReturnCount then
		for i=1,nLeftBaseLinkCount do
			ptZhongJiang[i].x = ptXian[i].x
			ptZhongJiang[i].y = ptXian[i].y
		end
		nLinkCount = nLinkCount + nLeftBaseLinkCount
	end
	return math.min(5,nLinkCount)
end

-----------------------------------------------------------------------------------

--拷贝表
function GameLogic:copyTab(st)
	local tab = {}
	for k, v in pairs(st) do
		if type(v) ~= "table" then
			tab[k] = v
		else
			tab[k] = self:copyTab(v)
		end
	end
	return tab
end


return GameLogic