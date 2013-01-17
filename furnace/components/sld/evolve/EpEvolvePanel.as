package xdmh.furnace.components.sld.evolve
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mhqy.ui.container.MAlert;
	import mhqy.ui.event.CloseEvent;
	import mhqy.ui.label.MAssetLabel;
	import mhqy.ui.label.MAssetLabelPair;
	import mhqy.ui.mcache.btns.XDCacheAsset1Btn;
	
	import xdmh.constData.CategoryType;
	import xdmh.core.data.GlobalData;
	import xdmh.core.data.bag.BagInfoUpdateEvent;
	import xdmh.core.data.fontFormat.FontFormatTemplateList;
	import xdmh.core.data.furnace.equip.BaptizeData;
	import xdmh.core.data.furnace.equip.Color;
	import xdmh.core.data.furnace.equip.EquipQuality;
	import xdmh.core.data.item.ItemInfo;
	import xdmh.core.data.player.SelfPlayerInfoUpdateEvent;
	import xdmh.core.manager.LanguageManager;
	import xdmh.core.view.quickTips.QuickTips;
	import xdmh.furnace.components.cell.LQBigCell;
	import xdmh.furnace.components.cell.LQMaterialCell;
	import xdmh.furnace.components.sld.EpBasePanel;
	import xdmh.furnace.components.sld.baptize.BaptizeViewer;
	import xdmh.furnace.events.FuranceEvent;
	import xdmh.furnace.evolve.bgAsset;
	import xdmh.furnace.socketHandlers.equip.EquipEvolveSocketHandler;
	
	/**
	 * 装备进阶面板
	 */ 
	public class EpEvolvePanel extends EpBasePanel
	{
		private var _previewCell:LQBigCell;				//进阶物品图标

		private var _lbNeed:MAssetLabel;					//所需材料
		private var _lbSpendSrc:MAssetLabelPair;			//消耗灵气标签
		
		private var _jinHuaCell:LQMaterialCell;			//精华格子
		private var _stoneCell:LQMaterialCell;				//进阶石
		private var _evolveBtn:XDCacheAsset1Btn;			//进阶按钮
		
		private var _lblCurEquipName:MAssetLabel;			//当前选中装备名称
		private var _lblNextEquipName:MAssetLabel;			//下阶装备名称
		
		private var _newPosArr:Array;
		
		private var _vecCurEquipQuality:Vector.<BaptizeViewer>;	//当前装备属性
		private var _vecNextEquipQuality:Vector.<BaptizeViewer>;	//下级装备属性
		
		private var _lblRandomTextUp:MAssetLabelPair;				//随机属性提示信息
		private var _lblRandomTextDown:MAssetLabelPair;			//随机属性提示信息
		
		private var _nPosY:int = 147;								//当前装备第一条属性y坐标
		private var _nPosX:int = 216;								//当前装备第一条属性x坐标
		
		private var _lblNoneQuaText:MAssetLabel;					//无属性时显示提示
		public function EpEvolvePanel()
		{
			_funcLvMin = 30;
			_picAsset = bgAsset;
			super();
		}
		
		override protected function initView():void
		{
			super.initView();
			
			//当前装备名称
			_lblCurEquipName = new MAssetLabel("", FontFormatTemplateList.getFormatById(1016));
			_lblCurEquipName.move(266, 123);
			addChild(_lblCurEquipName);
			
			//下阶装备名称
			_lblNextEquipName = new MAssetLabel("", FontFormatTemplateList.getFormatById(1016));
			_lblNextEquipName.move(466, 123);
			addChild(_lblNextEquipName);
			
			//当前装备属性			
			var posArr:Array = [new Point(_nPosX,_nPosY),new Point(216,167),new Point(216,188),new Point(216,209),new Point(216,230),new Point(216,251)];
			_vecCurEquipQuality = new Vector.<BaptizeViewer>();
			for(var i:int = 0; i < 6; i++)
			{
				var curQua:BaptizeViewer = new BaptizeViewer(i+1);
				curQua.move(posArr[i].x,posArr[i].y);
				curQua.visible = false;
				_vecCurEquipQuality.push(curQua);
				addChild(curQua);
			}
			
			//下阶装备属性			
			_newPosArr = [new Point(414,_nPosY),new Point(414,167),new Point(414,188),new Point(414,209),new Point(457,230),new Point(457,251)];
			_vecNextEquipQuality = new Vector.<BaptizeViewer>();
			for(var j:int = 0; j < 6; j++)
			{
				var enhancer:BaptizeViewer = new BaptizeViewer(j+1);
				enhancer.move(_newPosArr[j].x, _newPosArr[j].y);
				enhancer.visible = false;
				_vecNextEquipQuality.push(enhancer);
				addChild(enhancer);
			}
			
			_lblRandomTextUp = new MAssetLabelPair("新属性", "随机生成", FontFormatTemplateList.getFormatById(1016), MAssetLabel.LABELTYPE19,"：");
			_lblRandomTextUp.move(416, 147);
			_lblRandomTextUp.visible = false;
			addChild(_lblRandomTextUp);
			
			_lblRandomTextDown = new MAssetLabelPair("新属性", "随机生成", FontFormatTemplateList.getFormatById(1016), MAssetLabel.LABELTYPE19,"：");
			_lblRandomTextDown.move(416, 267);
			_lblRandomTextDown.visible = false;
			addChild(_lblRandomTextDown);
			
			//下阶装备预览
			_previewCell = new LQBigCell();
			_previewCell.move(337, 45);
			addChild(_previewCell);
			
			//需要材料
			_lbNeed = new MAssetLabel("需要材料：", FontFormatTemplateList.getFormatById(1016));
			_lbNeed.move(191, 343);
			addChild(_lbNeed);
			
			//消耗灵气标签
			_lbSpendSrc = new MAssetLabelPair("消耗灵气", "", FontFormatTemplateList.getFormatById(1016), FontFormatTemplateList.getFormatById(1016), "：");
			_lbSpendSrc.move(403, 343);
			addChild(_lbSpendSrc);
			
			//精华
			_jinHuaCell = new LQMaterialCell(null, null, "精华");
			_jinHuaCell.move(252, 327);
			_jinHuaCell.needCount = 4;
			addChild(_jinHuaCell);
			
			//进阶石
			_stoneCell = new LQMaterialCell(null, null, "进阶石");
			_stoneCell.move(301, 327);
			_stoneCell.needCount = 1;
			addChild(_stoneCell);
			
			//进阶按钮
			_evolveBtn = new XDCacheAsset1Btn(2, LanguageManager.getWord("xdmh.furnace.beginEvolve"));
			_evolveBtn.move(342,402);
			_evolveBtn.width = 70;
			_evolveBtn.height = 30;
			_evolveBtn.label = "进阶";
			_evolveBtn.enabled = false;
			addChild(_evolveBtn);
			
			//无属性时提示语
			_lblNoneQuaText = new MAssetLabel("无品质属性", MAssetLabel.getLabelType(Color.COLOR_WHITE));
			_lblNoneQuaText.move(_nPosX, _nPosY);
			_lblNoneQuaText.width = 106;
			_lblNoneQuaText.height = 20
			_lblNoneQuaText.visible = false;
			addChild(_lblNoneQuaText);
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			furnaceInfo.addEventListener(FuranceEvent.EQUIP_ATTR_UPDATE,onEvolveSuccess);
			_evolveBtn.addEventListener(MouseEvent.CLICK, onEvolve);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			furnaceInfo.removeEventListener(FuranceEvent.EQUIP_ATTR_UPDATE,onEvolveSuccess);
			_evolveBtn.removeEventListener(MouseEvent.CLICK, onEvolve);
		}
		
		override protected function onRolePropUpdate(e:SelfPlayerInfoUpdateEvent):void
		{
			super.onRolePropUpdate(e);
			//_evolveBtn.enabled = true;
		}
		
		override protected function onItemUpdate(e:BagInfoUpdateEvent):void
		{
			if(selectedEquip)
			{
				getMaterial();
			}
		}
		
		private function getMaterial():void
		{
			//精华,进阶石
			_jinHuaCell.itemInfo = GlobalData.bagInfo.getItemById(CategoryType.SPRITE)[0];
			_stoneCell.itemInfo = GlobalData.bagInfo.getItemById(CategoryType.EVOLVE_STONE)[0];
			_jinHuaCell.filters = null;
			_stoneCell.filters = null;
		}
		
		private function clearMaterial():void
		{
			_previewCell.itemInfo = null;
			_jinHuaCell.itemInfo = null;
			_stoneCell.itemInfo = null;
			_lblNoneQuaText.visible = false;
			_lblRandomTextUp.visible = false;
			_lblRandomTextDown.visible = false;
			_lblCurEquipName.visible = false;
			_lblNextEquipName.visible = false;
			_lbSpendSrc.value = "";
			
			for each(var viewer:BaptizeViewer in _vecCurEquipQuality)
			{
				viewer.key = "攻击";
				viewer.value = "0";
				viewer.star = 1;
				viewer.visible = false;
			}
			
			for each(var viewerOther:BaptizeViewer in _vecNextEquipQuality)
			{
				viewerOther.key = "攻击";
				viewerOther.value = "0";
				viewerOther.star = 1;
				viewerOther.visible = false;
			}
		}
		
		private function onEvolve(e:MouseEvent):void
		{
			//判断灵气、精华、进阶石是否足够
			if(GlobalData.selfPlayer.smartGas < _needLingQi)
			{
				showPoorMsg("灵气值", lingQiPoorHandler);
			}
			else if(_jinHuaCell.isPoor)
			{
				showPoorMsg("精华", jinHuaPoorHandler);
			}
			else if(_stoneCell.isPoor)
			{
				showPoorMsg("进阶石", bapLockerPoorHandler);
			}
			else
			{
				EquipEvolveSocketHandler.sendEquipEvolve(selectedEquip.itemId);
			}
		}
		
		private function onEvolveSuccess(e:FuranceEvent):void
		{
			if(e.data.quality)
			{
				var equipId:String = e.data.equipId;
				var quality:int = e.data.quality;
				var equip:ItemInfo = GlobalData.bagInfo.getItemByItemId(equipId) || GlobalData.bagInfo.getEqItemByItemId(equipId);
				
				if(quality >= EquipQuality.GOLD)
				{
					showTopEvolveDetail(equip);
					QuickTips.show("恭喜你，装备已达到金色品质！");
					_evolveBtn.enabled = false;
				}
				else
				{
					showDetail(equip);
					QuickTips.show("恭喜你，装备进阶成功！");
					_evolveBtn.enabled = true;
				}
			}
		}

		override protected function showDetail(equip:ItemInfo):void
		{
			clearMaterial();		
			showSpendNimbus(equip.template.needLevel);
	
			var quality:int = equip.quality;
			if(quality >= EquipQuality.GOLD)
			{
				_jinHuaCell.forceClear();
				_stoneCell.forceClear();
				_evolveBtn.enabled = false;
				QuickTips.show("无法进阶，该装备已达到金色品质！");			
			}
			else
			{
				getMaterial();
				showAttr(equip.baptizeAttr);
				setEquipNameInfo(equip);
				setRandomTextInfo(equip.baptizeAttr);
				_evolveBtn.enabled = true;
				_previewCell.itemInfo = equip;
				_needLingQi = equip.template.needLevel * 50;
			}
		}
		
		private function showTopEvolveDetail(equip:ItemInfo):void
		{
			clearMaterial();
			_jinHuaCell.showTopState();
			_stoneCell.showTopState();
			_lblCurEquipName.setValue(equip.template.name);
			_lblCurEquipName.visible = true;
			_lblCurEquipName.setLabelType(Color.getQiLingEquipNameFormat(equip.quality));
			_previewCell.itemInfo = equip;
			_lbSpendSrc.value = "0";
			showAttr(equip.baptizeAttr);
			hideEnhance();
		}
		
		private function setEquipNameInfo(equip:ItemInfo):void
		{
			var equipName:String = equip.template.name;
			
			_lblCurEquipName.setValue(equipName);
			_lblCurEquipName.visible = true;
			_lblCurEquipName.setLabelType(Color.getQiLingEquipNameFormat(equip.quality));
			_lblNextEquipName.setValue(equipName);
			_lblNextEquipName.visible = true;
			
			if(equip.quality >= EquipQuality.GOLD)
				_lblNextEquipName.setLabelType(Color.getQiLingEquipNameFormat(equip.quality));
			else
				_lblNextEquipName.setLabelType(Color.getQiLingEquipNameFormat(equip.quality+1));
		}
		
		private function setRandomTextInfo(data:Array):void
		{
			_lblRandomTextUp.visible = true;
			_lblRandomTextUp.titleType = _lblRandomTextUp.valueType = MAssetLabel.getLabelType(_lblNextEquipName.textColor);
			_lblRandomTextDown.visible = true;
			_lblRandomTextDown.titleType = _lblRandomTextDown.valueType = MAssetLabel.getLabelType(_lblNextEquipName.textColor);
			
			var idx:int = data.length;
			_lblRandomTextUp.y =  _newPosArr[idx].y;
			_lblRandomTextDown.y = _newPosArr[idx+1].y;
		}
		
		private function showAttr(data:Array):void
		{
			hideEnhance();
			setMulQualities(data);
		}
		
		private function hideEnhance():void
		{
			for each(var enhancer:BaptizeViewer in _vecNextEquipQuality)
			{
				enhancer.visible = false;
				enhancer.value = "";
			}
		}
		
		private function setMulQualities(data:Array):void
		{
			for(var i:int=0, n:int=data.length; i<n; i++)
			{
				var attr:BaptizeData = data[i];
				var nextQua:BaptizeViewer = _vecNextEquipQuality[i];
				var curQua:BaptizeViewer = _vecCurEquipQuality[i];
				curQua.visible = nextQua.visible = true;
				curQua.key = nextQua.key = attr.key;
				curQua.value = nextQua.value = attr.attrValue.toString();
				curQua.star = nextQua.star = attr.star;
			}
			if(0 == data.length)
			{
				_lblNoneQuaText.visible = true;
			}
		}
		
		private function bapLockerPoorHandler(e:CloseEvent):void
		{
			if(e.detail == MAlert.YES)
			{
				showStorePanel();
			}
		}
		
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		//设置显示所需灵气值
		private function showSpendNimbus(equipLevel:Number):void
		{
			_lbSpendSrc.value = calSpendSrc(equipLevel).toString();
		}
		
		//计算消耗灵气
		private function calSpendSrc(equipLevel:Number):Number
		{
			return (equipLevel * 50)
		}
		
		override public function dispose():void
		{
			removeEvent();
			while(numChildren)
			{
				removeChildAt(0);
			}
			super.dispose();
		}
	}
}