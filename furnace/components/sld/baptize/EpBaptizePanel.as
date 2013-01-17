package xdmh.furnace.components.sld.baptize
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	
	import mhqy.ui.backgroundUtil.BackgroundInfo;
	import mhqy.ui.backgroundUtil.BackgroundType;
	import mhqy.ui.backgroundUtil.BackgroundUtils;
	import mhqy.ui.container.MAlert;
	import mhqy.ui.container.MTile;
	import mhqy.ui.event.CloseEvent;
	import mhqy.ui.label.MAssetLabel;
	import mhqy.ui.label.MAssetLabelPair;
	import mhqy.ui.mcache.btns.MCacheAsset1Btn;
	import mhqy.ui.mcache.btns.XDCacheAsset1Btn;
	import mhqy.ui.mcache.cells.CellCaches;
	
	import xdmh.constData.CategoryType;
	import xdmh.core.data.GlobalData;
	import xdmh.core.data.bag.BagInfoUpdateEvent;
	import xdmh.core.data.chat.ChannelType;
	import xdmh.core.data.chat.ChatItemInfo;
	import xdmh.core.data.escape.EscapeTemplateList;
	import xdmh.core.data.fontFormat.FontFormatTemplateList;
	import xdmh.core.data.furnace.equip.BaptizeData;
	import xdmh.core.data.furnace.equip.Color;
	import xdmh.core.data.furnace.equip.EquipLayer;
	import xdmh.core.data.furnace.equip.EquipQuality;
	import xdmh.core.data.item.ItemInfo;
	import xdmh.core.data.player.SelfPlayerInfoUpdateEvent;
	import xdmh.core.manager.LanguageManager;
	import xdmh.core.utils.TextUtil;
	import xdmh.core.view.broadcast.NoticeBanner;
	import xdmh.core.view.quickTips.QuickTips;
	import xdmh.core.view.tips.TipsUtil;
	import xdmh.furnace.baptize.bgAsset;
	import xdmh.furnace.components.cell.LQBigCell;
	import xdmh.furnace.components.cell.LQCell;
	import xdmh.furnace.components.cell.LQMaterialCell;
	import xdmh.furnace.components.sld.EpBasePanel;
	import xdmh.furnace.data.FurnaceInfo;
	import xdmh.furnace.events.FuranceEvent;
	import xdmh.furnace.socketHandlers.equip.EquipBaptizeSaveSocketHandler;
	import xdmh.furnace.socketHandlers.equip.EquipBaptizeSocketHandler;
	import xdmh.interfaces.moviewrapper.IMovieWrapper;
	import xdmh.ui.LockAsset;
	
	public class EpBaptizePanel extends EpBasePanel
	{
		private var _lockerList:Vector.<BaptizeViewer>;
		private var _enhancerList:Vector.<BaptizeViewer>;
		private var _needLocker:int;
		private var _hasGoldAttr:Boolean;
		
		private var _previewCell:LQBigCell;				//当前装备格子
		private var _jinHuaCell:LQMaterialCell;			//精华材料
		private var _lbNeedMaterial:MAssetLabel;
		private var _lbLingQiConsume:MAssetLabelPair;		//灵气消耗
		private var _lbBapLockCount:MAssetLabel;			//洗炼锁数量
		
		private var _lbTotalStarDesc:MAssetLabel;
		private var _lbTotalStar:MAssetLabel;
		private var _lbNextBapLayerStar:MAssetLabel;
		
		
		private var _lbTotalStarOld:MAssetLabel;
		private var _lbTotalStarNew:ArrowLabel;
		private var _lockAsset:Bitmap;
		
		private var _baptizeBtn:XDCacheAsset1Btn;			//洗炼按钮
		private var _replaceBtn:XDCacheAsset1Btn;			//保存按钮
		private var _cancelBtn:XDCacheAsset1Btn;			//取消按钮
		
		public function EpBaptizePanel()
		{
			_picAsset = bgAsset;
			_funcLvMin = 30;
			super();
		}
		
		
		override protected function initView():void
		{
			super.initView();
			
			_lbBapLockCount = new MAssetLabel(GlobalData.bagInfo.getItemCountById(CategoryType.BAPTIZE_LOCKER).toString(), FontFormatTemplateList.getFormatById(1023),TextFieldAutoSize.LEFT);
			_lbBapLockCount.move(206,26);
			addChild(_lbBapLockCount);
			
			_lockAsset = new Bitmap(new LockAsset());
			_lockAsset.x = 184;
			_lockAsset.y = 25;
			addChild(_lockAsset);
			
			//原有洗炼属性总洗炼星级
			_lbTotalStarDesc = new MAssetLabel("总洗炼星级：",FontFormatTemplateList.getFormatById(1016));
			_lbTotalStarDesc.move(426,20);
			addChild(_lbTotalStarDesc);
			
			_lbTotalStar = new MAssetLabel("",FontFormatTemplateList.getFormatById(1016),TextFieldAutoSize.LEFT);
			_lbTotalStar.move(499,20);
			addChild(_lbTotalStar);
			
			_lbNextBapLayerStar = new MAssetLabel("",FontFormatTemplateList.getFormatById(1016));
			_lbNextBapLayerStar.move(490,40);
			addChild(_lbNextBapLayerStar);
			
			//原洗炼属性
			var title:MAssetLabel = new MAssetLabel("原属性：", FontFormatTemplateList.getFormatById(1017));
			title.move(192,156);
			addChild(title);
			
			var posArr:Array = [new Point(177,182),new Point(177,203),new Point(177,224),new Point(177,245),new Point(177,266),new Point(177,287)];
			_lockerList = new Vector.<BaptizeViewer>();
			for(var i:int=0; i<6; i++)
			{
				var locker:BaptizeViewer = new BaptizeLocker(i+1);
				locker.move(posArr[i].x,posArr[i].y);
				locker.visible = false;
				_lockerList.push(locker);
				addChild(locker);
			}
			
			_lbTotalStarOld = new MAssetLabel("", MAssetLabel.LABELTYPE1);
			_lbTotalStarOld.move(259,156);
			addChild(_lbTotalStarOld);
			
			//新洗炼属性
			var newTitle:MAssetLabel = new MAssetLabel("新属性：", FontFormatTemplateList.getFormatById(1017));
			newTitle.move(457,156);
			addChild(newTitle);
			
			_lbTotalStarNew = new ArrowLabel("",0,MAssetLabel.LABELTYPE1, MAssetLabel.LABELTYPE1);
			_lbTotalStarNew.move(477,156);
			addChild(_lbTotalStarNew);
			
			var newPosArr:Array = [new Point(410,182),new Point(410,203),new Point(410,224),new Point(410,245),new Point(410,266),new Point(410,287)];
			_enhancerList = new Vector.<BaptizeViewer>();
			for(var j:int=0; j<6; j++)
			{
				var enhancer:BaptizeViewer = new BaptizeEnhancer(j+1);
				enhancer.move(newPosArr[j].x, newPosArr[j].y);
				enhancer.visible = false;
				_enhancerList.push(enhancer);
				addChild(enhancer);
			}
			
			//装备格子
			_previewCell = new LQBigCell();
			_previewCell.move(330, 22);
			addChild(_previewCell);
			
			//材料
			_lbNeedMaterial = new MAssetLabel("需要材料：", FontFormatTemplateList.getFormatById(1016));
			_lbNeedMaterial.move(212, 344);
			addChild(_lbNeedMaterial);
			
			_jinHuaCell = new LQMaterialCell(null, null, "精华");
			_jinHuaCell.move(274, 331);
			_jinHuaCell.needCount = 0;
			addChild(_jinHuaCell);
			
			//消耗灵气
			_lbLingQiConsume = new MAssetLabelPair("消耗灵气", "", FontFormatTemplateList.getFormatById(1016), FontFormatTemplateList.getFormatById(1016), "：");
			_lbLingQiConsume.move(384, 342);
			addChild(_lbLingQiConsume);
			
			_baptizeBtn = new XDCacheAsset1Btn(0, "洗炼");
			_baptizeBtn.move(330,400);
			_baptizeBtn.enabled = false;
			addChild(_baptizeBtn);
			
			_replaceBtn = new XDCacheAsset1Btn(0, "保存");
			_replaceBtn.move(290,400);
			_replaceBtn.visible = false;
			addChild(_replaceBtn);
			
			_cancelBtn = new XDCacheAsset1Btn(0, "取消");
			_cancelBtn.move(370,400);
			_cancelBtn.visible = false;
			addChild(_cancelBtn);
		}

		
		override protected function initEvent():void
		{
			super.initEvent();
			for each(var locker:BaptizeLocker in _lockerList)
			{
				locker.addEventListener(FuranceEvent.BAPTIZE_ATTR_LOCK, onBapLock);
				//locker.checkBox.addEventListener(MouseEvent.MOUSE_OVER, onOverLocker);
				//locker.checkBox.addEventListener(MouseEvent.MOUSE_OUT, onOutLocker);
			}
			furnaceInfo.addEventListener(FuranceEvent.EQUIP_ATTR_UPDATE,onBaptizeSuccess);
			_baptizeBtn.addEventListener(MouseEvent.CLICK,onBaptize);
			_replaceBtn.addEventListener(MouseEvent.CLICK,onReplace);
			_cancelBtn.addEventListener(MouseEvent.CLICK,onCancel);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			for each(var locker:BaptizeLocker in _lockerList)
			{
				locker.removeEventListener(FuranceEvent.BAPTIZE_ATTR_LOCK, onBapLock);
				//locker.checkBox.removeEventListener(MouseEvent.MOUSE_OVER, onOverLocker);
				//locker.checkBox.removeEventListener(MouseEvent.MOUSE_OUT, onOutLocker);
			}
			furnaceInfo.removeEventListener(FuranceEvent.EQUIP_ATTR_UPDATE,onBaptizeSuccess);
			_baptizeBtn.removeEventListener(MouseEvent.CLICK,onBaptize);
			_replaceBtn.removeEventListener(MouseEvent.CLICK,onReplace);
			_cancelBtn.removeEventListener(MouseEvent.CLICK,onCancel);
		}
		
		private function getEnableLockerList():Array
		{
			var res:Array = [];
			for each(var locker:BaptizeLocker in _lockerList)
			{
				locker.visible && res.push(locker);
			}
			return res;
		}
		
		private function getLockedList():Array
		{
			var enableList:Array = getEnableLockerList();
			var res:Array = [];
			for each(var locker:BaptizeLocker in enableList)
			{
				locker.lock && res.push(locker.type);
			}
			return res;
		}
		
		private function onOverLocker(e:MouseEvent):void
		{
			TipsUtil.getInstance().show("锁定",null,new Rectangle(e.stageX, e.stageY,0,0));
		}
		
		private function onOutLocker(e:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		private function onBapLock(e:FuranceEvent):void
		{
			_needLocker = getLockedList().length;
			_jinHuaCell.needCount = _needLocker;
			_needLingQi = getLingQi(_needLocker);
			_lbLingQiConsume.value = _needLingQi.toString();
			_baptizeBtn.enabled = _needLocker == getEnableLockerList().length ? false : true;
		}
		
		override protected function onRolePropUpdate(e:SelfPlayerInfoUpdateEvent):void
		{
			super.onRolePropUpdate(e);
			//_baptizeBtn.enabled = true;
		}
		
		override protected function onItemUpdate(e:BagInfoUpdateEvent):void
		{
			if(selectedEquip)
			{
				getMaterial();
				_lbBapLockCount.setValue(GlobalData.bagInfo.getItemCountById(CategoryType.BAPTIZE_LOCKER).toString());
			}
		}
		
		private function getMaterial():void
		{
			//精华,洗炼锁
			_jinHuaCell.itemInfo = GlobalData.bagInfo.getItemById(CategoryType.SPRITE)[0];
			_needLingQi = getLingQi(0);
			_lbLingQiConsume.value = _needLingQi.toString();
		}
		
		private function clear(keepLock:Boolean = false):void
		{
			for each(var viewer:BaptizeViewer in _lockerList)
			{
				viewer.key = "攻击";
				viewer.value = "0";
				viewer.star = 1;
				viewer.visible = false;
				if(viewer is BaptizeLocker && !keepLock)
				{
					BaptizeLocker(viewer).lock = false;
				}
			}
			_previewCell.itemInfo = null;
			_lbTotalStarOld.visible = false;
			_jinHuaCell.itemInfo = null;
			_jinHuaCell.needCount = 0;
			_lbLingQiConsume.value = "0";
			_lbTotalStar.setValue("");
			_lbNextBapLayerStar.setValue("");
		}
		
		override protected function showDetail(equip:ItemInfo):void
		{
			clear();
			onCancel(null);
			if(equip.quality > EquipQuality.WHITE)
			{
				_showDetail(equip);
			}
			else
			{
				_jinHuaCell.forceClear();
				QuickTips.show("白色装备无法洗炼，请先进阶！");
			}
		}
		
		private function _showDetail(equip:ItemInfo):void
		{
			_lbBapLockCount.setValue(GlobalData.bagInfo.getItemCountById(CategoryType.BAPTIZE_LOCKER).toString());
			_lbTotalStar.setLabelType(Color.getQiLingLayerFormat(equip.bapLayer));
			_lbTotalStarOld.setLabelType(Color.getQiLingLayerFormat(equip.bapLayer));
			_lbNextBapLayerStar.setValue("(" + EquipLayer.getDesc(equip.bapLayer+1) + "级需要"+ equip.nextBapLayerStar +"星)");
			_lbNextBapLayerStar.setLabelType(Color.getQiLingLayerFormat(equip.bapLayer+1));
			
			getMaterial();
			showLockerData(equip);
			onBapLock(null);
			_previewCell.itemInfo = equip;
			_baptizeBtn.enabled = true;
		}
		
		//点击洗炼
		private function onBaptize(e:MouseEvent):void
		{
			//判断灵气、精华、洗炼锁是否足够
			if(GlobalData.selfPlayer.smartGas < _needLingQi)
			{
				showPoorMsg("灵气值", lingQiPoorHandler);
			}
			else if(_jinHuaCell.isPoor)
			{
				showPoorMsg("精华", jinHuaPoorHandler);
			}
			else if(GlobalData.bagInfo.getItemCountById(CategoryType.BAPTIZE_LOCKER) < _needLocker)
			{
				showPoorMsg("洗炼锁", bapLockerPoorHandler);
			}
			else
			{
				EquipBaptizeSocketHandler.sendEquipBaptize(selectedEquip.itemId, getLockedList());
			}
		}
		
		private function onBaptizeSuccess(e:FuranceEvent):void
		{
			var equipId:String = e.data.equipId;
			var equip:ItemInfo = GlobalData.bagInfo.getItemByItemId(equipId) || GlobalData.bagInfo.getEqItemByItemId(equipId);
			if(e.data.attrList)		//洗炼成功
			{
				showEnhance(e.data.attrList);
				//设置新属性洗炼层级颜色
				_lbTotalStarNew.setLabelType(Color.getQiLingLayerFormat(e.data.layer));
			}
			else if(e.data.status)		//保存成功
			{
				clear(true);
				onCancel(null);
				_showDetail(equip);
			}
		}
		
		private function bapLockerPoorHandler(e:CloseEvent):void
		{
			if(e.detail == MAlert.YES)
			{
				showStorePanel();
			}
		}
		
		private function onReplace(e:MouseEvent):void
		{
			EquipBaptizeSaveSocketHandler.sendBaptizeSave(selectedEquip.itemId);
			_hasGoldAttr = false;
		}
		
		private function onCancel(e:MouseEvent):void
		{
			if(_hasGoldAttr)
			{
				MAlert.show(EscapeTemplateList.replace("新属性中有#R金色属性#n，确定继续洗练吗？"),"", MAlert.OK|MAlert.CANCEL,null, cancerHandler);
			}
			else
			{
				hideEnhance();
				showBaptizeBtn(true);
			}
			function cancerHandler(e:CloseEvent):void
			{
				if(e.detail == MAlert.OK)
				{
					hideEnhance();
					showBaptizeBtn(true);
				}
				_hasGoldAttr = false;
			}
		}
		
		//显示装备原洗练属性
		private function showLockerData(equip:ItemInfo):void
		{
			var totalStar:int;
			for(var i:int=0, n:int= equip.baptizeAttr.length; i<n; i++)
			{
				var attr:BaptizeData = equip.baptizeAttr[i];
				var locker:BaptizeLocker = _lockerList[i] as BaptizeLocker;
				locker.visible = true;
				locker.key = attr.key;
				locker.value = attr.attrValue.toString();
				locker.star = attr.star;
				totalStar += attr.star;
			}
			_lbTotalStar.setValue(totalStar.toString() + "星("+ EquipLayer.getDesc(equip.bapLayer)+")");
			_lbTotalStarOld.setValue(totalStar.toString() + "星");
			_lbTotalStarOld.visible = true;
		}
		
		//显示洗炼后新属性 
		private function showEnhance(data:Array):void
		{
			hideEnhance();
			bindEnhanceData(data);
			showBaptizeBtn(false);
		}
		
		private function bindEnhanceData(data:Array):void
		{
			var totalStarNew:int;
			var totalStarOld:int;
			for(var i:int=0, n:int=data.length; i<n; i++)
			{
				//洗炼结果中隐藏已锁定的洗炼属性
				var locker:BaptizeLocker = _lockerList[i] as BaptizeLocker;
				var enhancer:BaptizeEnhancer = _enhancerList[i] as BaptizeEnhancer;
				var attr:BaptizeData = data[i];
				enhancer.key = attr.key;
				enhancer.value = attr.attrValue.toString();
				enhancer.star = attr.star;
				enhancer.enhance = attr.attrValue - int(locker.value);
				enhancer.visible = locker.lock ? false : true;
				totalStarOld += locker.star;
				totalStarNew += enhancer.star;
				if(enhancer.visible && enhancer.quality >= EquipQuality.GOLD)
				{
					_hasGoldAttr = true;
				}
			}
			_lbTotalStarNew.label = totalStarNew + "星";
			_lbTotalStarNew.enhance = totalStarNew - totalStarOld;
			_lbTotalStarNew.visible = true;
		}
		
		private function hideEnhance():void
		{
			for each(var enhancer:BaptizeEnhancer in _enhancerList)
			{
				enhancer.visible = false;
				enhancer.enhance = 0;
			}
			_lbTotalStarNew.visible = false;
		}
		
		private function showBaptizeBtn(show:Boolean):void
		{
			_baptizeBtn.visible = show;
			_replaceBtn.visible = !show;
			_cancelBtn.visible = !show;
			_baptizeBtn.visible ? showLocker() : hideLocker();
		}
		
		private function showLocker():void
		{
			for each(var locker:BaptizeLocker in _lockerList)
			{
				locker.lockerVisible = true;
			}
		}
		
		private function hideLocker():void
		{
			for each(var locker:BaptizeLocker in _lockerList)
			{
				locker.lockerVisible = false;
			}
		}
		
		//获取洗炼灵气消耗
		private function getLingQi(numLock:int):int
		{
			return 300;
		}
		
		override public function dispose():void
		{
			removeEvent();
			super.dispose();
		}
	}
}