package xdmh.furnace.components.sld.suiting
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	
	import mhqy.ui.button.MBitmapButton;
	import mhqy.ui.container.MAlert;
	import mhqy.ui.event.CloseEvent;
	import mhqy.ui.label.MAssetLabel;
	import mhqy.ui.label.MAssetLabelPair;
	import mhqy.ui.mcache.btns.XDCacheAsset1Btn;
	
	import xdmh.constData.CareerType;
	import xdmh.constData.CategoryType;
	import xdmh.core.data.GlobalData;
	import xdmh.core.data.bag.BagInfoUpdateEvent;
	import xdmh.core.data.chat.ChannelType;
	import xdmh.core.data.chat.ChatItemInfo;
	import xdmh.core.data.fontFormat.FontFormatTemplateList;
	import xdmh.core.data.furnace.equip.BasicAttr;
	import xdmh.core.data.furnace.equip.Color;
	import xdmh.core.data.furnace.equip.EquipAttr;
	import xdmh.core.data.furnace.equip.EquipLayer;
	import xdmh.core.data.furnace.equip.EquipQuality;
	import xdmh.core.data.furnace.equip.suit.SuitAttr;
	import xdmh.core.data.furnace.equip.suit.SuitTemplateList;
	import xdmh.core.data.item.ItemInfo;
	import xdmh.core.data.player.SelfPlayerInfoUpdateEvent;
	import xdmh.core.manager.LanguageManager;
	import xdmh.core.utils.AssetUtil;
	import xdmh.core.view.broadcast.NoticeBanner;
	import xdmh.core.view.quickTips.QuickTips;
	import xdmh.core.view.tips.TipsUtil;
	import xdmh.furnace.components.cell.LQBigCell;
	import xdmh.furnace.components.cell.LQCell;
	import xdmh.furnace.components.cell.LQMaterialCell;
	import xdmh.furnace.components.sld.EpBasePanel;
	import xdmh.furnace.events.FuranceEvent;
	import xdmh.furnace.socketHandlers.equip.EquipSuitingSocketHandler;
	import xdmh.furnace.suit.bgAsset;
	import xdmh.furnace.suit.fireAsset;
	import xdmh.furnace.suit.goldAsset;
	import xdmh.furnace.suit.soilAsset;
	import xdmh.furnace.suit.suitTypeSelectedBg;
	import xdmh.furnace.suit.waterAsset;
	import xdmh.furnace.suit.woodAsset;
	
	/**
	 * 套装打造面板
	 */ 
	public class EpSuitingPanel extends EpBasePanel
	{
		private var _career:int;					//绿装职业类型，1~5表示金~土
		private var _careerList:Array;
		
		private var _gold:SuitCareerIcon;
		private var _wood:SuitCareerIcon;
		private var _water:SuitCareerIcon;
		private var _fire:SuitCareerIcon;
		private var _soil:SuitCareerIcon;
		
		private var _lbName:MAssetLabelPair;			//装备名
		
		private var _lbSuitAttrDesc:MAssetLabel;		
		private var _lbSuitAttr:MAssetLabel;			//套装属性
		
		private var _lbAttrLayerDesc:MAssetLabel;
		private var _lbAttrLayer:MAssetLabel;			//属性层级
		
		private var _lbSuitDesc:MAssetLabel;			//套装属性描述
		private var _lbSuitText:MAssetLabel;
		
		private var _lbReSuitDesc:MAssetLabel;			//重新打造属性描述
		private var _lbSuitTips:MAssetLabel;
		
		private var _lbNeeds:MAssetLabel;				//需要材料
		private var _lbConsume:MAssetLabelPair;		//消耗灵气
		private var _jinHuaCell:LQMaterialCell;		//精华
		private var _stoneCell:LQMaterialCell;			//套装石
		private var _previewCell:LQBigCell;			//预览装备
		private var _btnSuiting:XDCacheAsset1Btn;		//打造按钮
		
		public function EpSuitingPanel()
		{
			_funcLvMin = 50;
			_picAsset = bgAsset;
			super();
		}
		
		override protected function initView():void
		{
			super.initView();
			
			//金，木，水，火，土
			var selectedBg:BitmapData = new suitTypeSelectedBg();
			_gold = new SuitCareerIcon(new goldAsset(), selectedBg, "金");
			_gold.move(253, 51);
			addChild(_gold);
			
			_wood = new SuitCareerIcon(new woodAsset(), selectedBg, "木");
			_wood.move(178, 103);
			addChild(_wood);
			
			_water = new SuitCareerIcon(new waterAsset(), selectedBg, "水");
			_water.move(196, 198);
			addChild(_water);
			
			_fire = new SuitCareerIcon(new fireAsset(), selectedBg, "火");
			_fire.move(311, 198);
			addChild(_fire);
			
			_soil = new SuitCareerIcon(new soilAsset(), selectedBg, "土");
			_soil.move(332, 103);
			addChild(_soil);
			
			_careerList = [];
			_careerList.push(_gold, _wood, _water, _fire, _soil);
			
			_previewCell = new LQBigCell();
			_previewCell.move(249,127);
			addChild(_previewCell);
			
			//装备名称
			_lbName = new MAssetLabelPair("", "", Color.getQiLingEquipNameFormat(EquipQuality.GREEN), Color.getQiLingEquipNameFormat(EquipQuality.GREEN), "·");
			_lbName.move(460,65);
			addChild(_lbName);
			
			_lbSuitAttrDesc = new MAssetLabel("套装属性：",FontFormatTemplateList.getFormatById(1016));
			_lbSuitAttrDesc.move(426,97);
			addChild(_lbSuitAttrDesc);
			
			_lbSuitAttr = new MAssetLabel("",FontFormatTemplateList.getFormatById(1024),TextFieldAutoSize.LEFT);
			_lbSuitAttr.move(488,97);
			addChild(_lbSuitAttr);
			
			_lbAttrLayerDesc = new MAssetLabel("属性层级：",FontFormatTemplateList.getFormatById(1016));
			_lbAttrLayerDesc.move(426,119);
			addChild(_lbAttrLayerDesc);
			
			_lbAttrLayer = new MAssetLabel("", FontFormatTemplateList.getFormatById(1016),TextFieldAutoSize.LEFT);
			_lbAttrLayer.move(488,119);
			addChild(_lbAttrLayer);
			
			//套装生成属性描述
			_lbSuitDesc = new MAssetLabel("",FontFormatTemplateList.getFormatById(1016),TextFieldAutoSize.LEFT);
			_lbSuitDesc.move(426,149);
			addChild(_lbSuitDesc);
			
			_lbSuitText = new MAssetLabel("", FontFormatTemplateList.getFormatById(1024),TextFieldAutoSize.LEFT);
			_lbSuitText.multiline = true;
			_lbSuitText.wordWrap = true;
			_lbSuitText.width = 135;
			_lbSuitText.move(426,169);
			addChild(_lbSuitText);
			
			_lbReSuitDesc = new MAssetLabel("打造可重新生成套装属性", FontFormatTemplateList.getFormatById(1016));
			_lbReSuitDesc.move(426,231);
			_lbReSuitDesc.visible = false;
			addChild(_lbReSuitDesc);
			
			_lbSuitTips = new MAssetLabel("请先选择需要打造的套装系别", FontFormatTemplateList.getFormatById(1016));
			_lbSuitTips.move(203,287);
			addChild(_lbSuitTips);
			
			_lbNeeds = new MAssetLabel("需要材料：", FontFormatTemplateList.getFormatById(1016));
			_lbNeeds.move(195,343);
			addChild(_lbNeeds);
			
			_lbConsume = new MAssetLabelPair("消耗灵气", "", FontFormatTemplateList.getFormatById(1016), FontFormatTemplateList.getFormatById(1016),"：");
			_lbConsume.move(402,343);
			addChild(_lbConsume);
			
			_jinHuaCell = new LQMaterialCell(null, null, "精华");
			_jinHuaCell.move(259, 330);
			addChild(_jinHuaCell);
			
			_stoneCell = new LQMaterialCell(null, null, "套装材料");
			_stoneCell.move(307, 330);
			_stoneCell.needCount = 1;
			addChild(_stoneCell);
			
			_btnSuiting = new XDCacheAsset1Btn(0, "打造套装");
			_btnSuiting.move(330,400);
			_btnSuiting.enabled = false;
			addChild(_btnSuiting);
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			for each(var icon:SuitCareerIcon in _careerList)
			{
				icon.addEventListener(MouseEvent.CLICK,onCareerClick);
				icon.addEventListener(MouseEvent.MOUSE_OVER, onCareerOver);
				icon.addEventListener(MouseEvent.MOUSE_OUT, onCareerOut);
			}
			furnaceInfo.addEventListener(FuranceEvent.EQUIP_ATTR_UPDATE,onSuitSuccess);
			_btnSuiting.addEventListener(MouseEvent.CLICK,onSuiting);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			for each(var icon:SuitCareerIcon in _careerList)
			{
				icon.removeEventListener(MouseEvent.CLICK,onCareerClick);
				icon.removeEventListener(MouseEvent.MOUSE_OVER, onCareerOver);
				icon.removeEventListener(MouseEvent.MOUSE_OUT, onCareerOut);
			}
			furnaceInfo.removeEventListener(FuranceEvent.EQUIP_ATTR_UPDATE,onSuitSuccess);
			_btnSuiting.removeEventListener(MouseEvent.CLICK,onSuiting);
		}
		
		private function onCareerOver(e:MouseEvent):void
		{
			var target:SuitCareerIcon = e.currentTarget as SuitCareerIcon;
			target.mouseOver = true;
			TipsUtil.getInstance().show(target.career + "系套装！", null, new Rectangle(e.stageX, e.stageY,0,0));
		}
		
		private function onCareerOut(e:MouseEvent):void
		{
			var target:SuitCareerIcon = e.currentTarget as SuitCareerIcon;
			target.mouseOver = false;
			TipsUtil.getInstance().hide();
		}
		
		private function clearCareerSelect():void
		{
			for each(var icon:SuitCareerIcon in _careerList)
			{
				icon.select = false;
			}
			_career = 0;
		}
		
		private function onCareerClick(e:MouseEvent):void
		{
			if(_previewCell.itemInfo && _previewCell.itemInfo.quality >= EquipQuality.GOLD)
			{
				clearCareerSelect();
				var selectedIcon:SuitCareerIcon = e.currentTarget as SuitCareerIcon;
				selectedIcon.select = true;
				_career = _careerList.indexOf(selectedIcon) + 1;
				_lbName.title = CareerType.getNameByCareer(_career);
				_lbName.type = Color.getQiLingEquipNameFormat(EquipQuality.GREEN);
				_lbReSuitDesc.visible = true;
				showSuitAttrs(_career,_previewCell.itemInfo.template.type);
				getMaterial();
				getSuitStone(_career, _previewCell.itemInfo.template.needLevel);
			}
		}
		
		private function clear():void
		{
			_jinHuaCell.itemInfo = null;
			_stoneCell.itemInfo = null;
			_lbConsume.value = "";
			_lbName.title = "";
			_lbName.value = "";
			_lbSuitAttr.setValue("");
			_lbSuitAttr.setLabelType(FontFormatTemplateList.getFormatById(1024));
			_lbAttrLayer.setValue("");
			_lbSuitDesc.setValue("");
			_lbSuitText.setValue("");
			_lbReSuitDesc.visible = false;
			_lbConsume.value = "";
			_previewCell.itemInfo = null;
			_btnSuiting.enabled = false;
		}
		
		override protected function showDetail(equip:ItemInfo):void
		{
			clear();
			if(equip.quality < EquipQuality.GOLD)
			{
				clearCareerSelect();
				_jinHuaCell.forceClear();
				_stoneCell.forceClear();
				QuickTips.show("无法打造套装，需要装备品质达到金色及以上！");
			}
			else
			{
				if(equip.template.needLevel < _funcLvMin)
				{
					_jinHuaCell.forceClear();
					_stoneCell.forceClear();
					QuickTips.show("该装备未到达"+ _funcLvMin.toString() +"级，不可打造套装！");
				}
				else
				{
					_showDetail(equip);
				}
			}
		}
		
		private function _showDetail(equip:ItemInfo):void
		{
			if(equip.suitAttr.isGreenEq)
			{
				_lbName.title =  CareerType.getNameByCareer(equip.suitAttr.career);
				_lbSuitAttr.setValue(EquipAttr.getAttrDesc(equip.suitAttr));
				_lbSuitAttr.setLabelType(FontFormatTemplateList.getFormatById(1028));
				_lbAttrLayer.setValue(EquipLayer.getDesc(equip.suitLayer));
				_lbAttrLayer.setLabelType(Color.getQiLingLayerFormat(equip.suitLayer));
			}
			else
			{
				_lbSuitAttr.setValue("随机生成");
				_lbSuitAttr.setLabelType(FontFormatTemplateList.getFormatById(1024));
				_lbAttrLayer.setValue("无");
				_lbAttrLayer.setLabelType(FontFormatTemplateList.getFormatById(1024));
			}
			_lbName.value = equip.template.name;
			_lbName.type = Color.getQiLingEquipNameFormat(equip.quality);
			_previewCell.itemInfo = equip;
			
			_needLingQi = 100 * equip.template.needLevel;	//消耗灵气 = 100 * 装备等级
			_lbConsume.value = _needLingQi.toString();
			_btnSuiting.enabled = true;
			if(_career)
			{
				getMaterial();
				getSuitStone(_career,equip.template.needLevel);
				showSuitAttrs(_career,equip.template.type);
				_lbReSuitDesc.visible = true;
			}
		}
		
		private function showSuitAttrs(career:int, eqType:int):void
		{
			_lbSuitDesc.setValue(CareerType.getNameByCareer(_career)+"系套装属性会生成：");
			_lbSuitText.setValue(SuitTemplateList.getSuitAttr(_career, eqType));
		}
		
		private function onSuiting(e:MouseEvent):void
		{
			if(!_career)
			{
				QuickTips.show("请先选择需要打造的套装系别！");
			}
			else if(selectedEquip.template.needLevel<_funcLvMin)
			{
				QuickTips.show("该装备未到达"+ _funcLvMin.toString() +"级，不能打造套装！");
			}
			else if(GlobalData.selfPlayer.smartGas < _needLingQi)
			{
				showPoorMsg("灵气值", lingQiPoorHandler);
			}
			else if(_jinHuaCell.isPoor)
			{
				showPoorMsg("精华", jinHuaPoorHandler);
			}
			else if(_stoneCell.isPoor)
			{
				showPoorMsg("套装石", stonePoorHandler);
			}
			else
			{
				EquipSuitingSocketHandler.sendEquipSuiting(selectedEquip.itemId, _career);
			}
		}
		
		private function onSuitSuccess(e:FuranceEvent):void
		{
			if(e.data.status == 0)
			{
				var equipId:String = e.data.equipId;
				var equip:ItemInfo = GlobalData.bagInfo.getItemByItemId(equipId) || GlobalData.bagInfo.getEqItemByItemId(equipId);
				
				clear();
				_showDetail(equip);
				QuickTips.show("恭喜你成功打造" + CareerType.getNameByCareer(_career) + "系套装！");
			}
		}
		
		private function stonePoorHandler(e:CloseEvent):void
		{
			if(e.detail == MAlert.YES)
			{
				showStorePanel();
			}
		}
		
		override protected function onRolePropUpdate(e:SelfPlayerInfoUpdateEvent):void
		{
			super.onRolePropUpdate(e);
			//_btnSuiting.enabled = true;
		}
		
		override protected function onItemUpdate(e:BagInfoUpdateEvent):void
		{
			if(_career && selectedEquip)
			{
				getMaterial();
				getSuitStone(_career, selectedEquip.template.needLevel);
			}
		}
		
		private function getMaterial():void
		{
			//精华消耗 = 6+新装备等级/5
			_jinHuaCell.needCount = 6 + selectedEquip.template.needLevel/5;
			_jinHuaCell.itemInfo = GlobalData.bagInfo.getItemById(CategoryType.SPRITE)[0];
		}
		
		private function getSuitStone(career:int, eqLv:int):void
		{
			var stoneId:int;
			switch(career)
			{
				case CareerType.GOLD:
					stoneId = CategoryType.SUIT_GOLD_STONE_LV1;
					break;
				case CareerType.WOOD:
					stoneId = CategoryType.SUIT_WOOD_STONE_LV1;
					break;
				case CareerType.WATER:
					stoneId = CategoryType.SUIT_WATER_STONE_LV1;
					break;
				case CareerType.FIRE:
					stoneId = CategoryType.SUIT_FIRE_STONE_LV1;
					break;
				case CareerType.SOIL:
					stoneId = CategoryType.SUIT_SOIL_STONE_LV1;
					break;
			}
			stoneId += (eqLv - 60)/10;
			_stoneCell.itemInfo = GlobalData.bagInfo.getItemById(stoneId)[0];
		}
		
		override public function dispose():void
		{
			removeEvent();
			if(_careerList)
			{
				for each(var icon:SuitCareerIcon in _careerList)
				{
					icon.dispose();
				}
				_careerList.length = 0;
			}
			
			super.dispose();
		}
	}
}