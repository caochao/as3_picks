package xdmh.furnace.components.sld.strengthen
{	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import mhqy.ui.button.MBitmapButton;
	import mhqy.ui.container.MAlert;
	import mhqy.ui.event.CloseEvent;
	import mhqy.ui.label.MAssetLabel;
	import mhqy.ui.label.MAssetLabelPair;
	import mhqy.ui.mcache.btns.MCacheAsset1Btn;
	import mhqy.ui.mcache.btns.XDCacheAsset1Btn;
	import mhqy.ui.mcache.cells.CellCaches;
	import mhqy.ui.progress.ProgressBar;
	
	import xdmh.constData.CategoryType;
	import xdmh.constData.SourceClearType;
	import xdmh.core.data.EffectType;
	import xdmh.core.data.GlobalData;
	import xdmh.core.data.bag.BagInfoUpdateEvent;
	import xdmh.core.data.chat.ChannelType;
	import xdmh.core.data.chat.ChatItemInfo;
	import xdmh.core.data.fontFormat.FontFormatTemplateList;
	import xdmh.core.data.furnace.equip.BasicAttr;
	import xdmh.core.data.furnace.equip.Color;
	import xdmh.core.data.furnace.equip.EquipAttr;
	import xdmh.core.data.furnace.equip.EquipLayer;
	import xdmh.core.data.furnace.equip.StrengthenData;
	import xdmh.core.data.furnace.equip.StrengthenFormula;
	import xdmh.core.data.item.ItemInfo;
	import xdmh.core.data.item.ItemTemplateInfo;
	import xdmh.core.data.item.ItemTemplateList;
	import xdmh.core.data.player.SelfPlayerInfoUpdateEvent;
	import xdmh.core.manager.LanguageManager;
	import xdmh.core.utils.AssetUtil;
	import xdmh.core.utils.ColorUtils;
	import xdmh.core.view.broadcast.NoticeBanner;
	import xdmh.core.view.quickTips.QuickTips;
	import xdmh.core.view.tips.TipsUtil;
	import xdmh.equipTips.spliterLineAsset;
	import xdmh.furnace.components.cell.LQBigCell;
	import xdmh.furnace.components.cell.LQCell;
	import xdmh.furnace.components.cell.LQMaterialCell;
	import xdmh.furnace.components.sld.EpBasePanel;
	import xdmh.furnace.data.FurnaceInfo;
	import xdmh.furnace.events.FuranceEvent;
	import xdmh.furnace.socketHandlers.equip.EquipStrengthenSocketHandler;
	import xdmh.furnace.strengthen.bgAsset;
	import xdmh.furnace.strengthen.swordAsset;
	
	/**
	 * 装备强化面板
	 */ 
	public class EpStrengthenPanel extends EpBasePanel
	{
		private var _perfectFlag:int;					//完美玉符类型
		private var _progressMax:int;					//完美度剑宽度
		private const _strengLvMax:int = 20;			//最大强化等级
		private const _percentMax:int = 10;			//完美度最大值
		
		private var _swordBg:MBitmapButton;
		private var _previewCell:LQBigCell;
		
		private var _lbEquipName:MAssetLabel;
		private var _lbBasicDesc:MAssetLabel;
		private var _lbBasicProp:MAssetLabel;
		
		private var _lbCurrLv:MAssetLabel;
		private var _lbNextLv:MAssetLabel;
		
		private var _lbStrengCurrLv:MAssetLabel;
		private var _lbStrengCurrProp:MAssetLabel;
		private var _lbStrengNextLvDesc:MAssetLabel;
		private var _lbStrengNextPropDesc:MAssetLabel;
		private var _lbStrengNextLv:MAssetLabel;
		private var _lbStrengNextProp:MAssetLabel;
		
		private var _lbStrengDesc:MAssetLabel;
		private var _lbStrengLayer:MAssetLabel;
		private var _lbNextStrengLayer:MAssetLabel;
		
		private var _lbStrengFee:MAssetLabelPair;
		private var _lbNeedMaterial:MAssetLabel;
		private var _lbPerfect:MAssetLabel;
		private var _jinHuaCell:LQMaterialCell;			   //精华格子
		private var _perfectCell:LQMaterialCell;			  //完美符格子
		private var _perfectBmp:MBitmapButton;				  //完美符图标
		private var _perfectLb:MAssetLabel;
		private var _btnStrength:XDCacheAsset1Btn;
		
		public function EpStrengthenPanel()
		{
			_picAsset = bgAsset;
			_funcLvMin = 30;
			super();
		}
		
		override protected function initView():void
		{
			super.initView();
			
			//进度条剑
			_swordBg = new MBitmapButton(new swordAsset());
			_swordBg.x = 246;
			_swordBg.y = 256;
			_swordBg.visible = false;
			_progressMax = _swordBg.width;
			addChild(_swordBg);
			
			//装备名称
			_lbEquipName = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_lbEquipName.move(457,43);
			addChild(_lbEquipName);
			
			//预览格子
			_previewCell = new LQBigCell();
			_previewCell.move(234,87);
			addChild(_previewCell);
			
			//强化层级
			_lbStrengDesc = new MAssetLabel("强化等级：",FontFormatTemplateList.getFormatById(1016));
			_lbStrengDesc.move(210,164);
			addChild(_lbStrengDesc);
			
			_lbStrengLayer = new MAssetLabel("",FontFormatTemplateList.getFormatById(1016));
			_lbStrengLayer.move(272,164);
			_lbStrengLayer.width = 80;
			_lbStrengLayer.autoSize = TextFieldAutoSize.LEFT;
			addChild(_lbStrengLayer);
			
			_lbNextStrengLayer = new MAssetLabel("",FontFormatTemplateList.getFormatById(1016));
			_lbNextStrengLayer.move(270,180);
			addChild(_lbNextStrengLayer);
			
			//基础属性
			_lbBasicDesc = new MAssetLabel("基础属性：",FontFormatTemplateList.getFormatById(1016));
			_lbBasicDesc.move(402,72);
			_lbBasicDesc.autoSize = TextFieldAutoSize.LEFT;
			addChild(_lbBasicDesc);
			
			_lbBasicProp = new MAssetLabel("",FontFormatTemplateList.getFormatById(36));
			_lbBasicProp.move(464,72);
			_lbBasicProp.autoSize = TextFieldAutoSize.LEFT;
			addChild(_lbBasicProp);
			
			//当前效果
			_lbCurrLv = new MAssetLabel("当前级别",FontFormatTemplateList.getFormatById(1016));
			_lbCurrLv.move(402,99);
			addChild(_lbCurrLv);
			
			var poseArray:Array = [new Point(429,121),new Point(429,143)];
			var label:Array = ["等级：","附加："];
			for(var i:int = 0; i< poseArray.length; i++)
			{
				var la:MAssetLabel = new MAssetLabel(label[i],FontFormatTemplateList.getFormatById(1016));
				la.move(poseArray[i].x, poseArray[i].y);
				addChild(la);
			}
			
			_lbStrengCurrLv = new MAssetLabel("",FontFormatTemplateList.getFormatById(1016));
			_lbStrengCurrLv.move(465,121);
			_lbStrengCurrLv.autoSize = TextFieldAutoSize.LEFT;
			addChild(_lbStrengCurrLv);
			
			_lbStrengCurrProp = new MAssetLabel("",FontFormatTemplateList.getFormatById(1016));
			_lbStrengCurrProp.move(465,143);
			_lbStrengCurrProp.autoSize = TextFieldAutoSize.LEFT;
			addChild(_lbStrengCurrProp);
			
			//下级效果
			_lbNextLv = new MAssetLabel("下一级别",FontFormatTemplateList.getFormatById(1016));
			_lbNextLv.move(402,172);
			addChild(_lbNextLv);
			
			_lbStrengNextLvDesc = new MAssetLabel("等级：",FontFormatTemplateList.getFormatById(1016));
			_lbStrengNextLvDesc.move(429,194);
			addChild(_lbStrengNextLvDesc);
			
			_lbStrengNextPropDesc = new MAssetLabel("附加：",FontFormatTemplateList.getFormatById(1016));
			_lbStrengNextPropDesc.move(429,216);
			addChild(_lbStrengNextPropDesc);
			
			_lbStrengNextLv = new MAssetLabel("",FontFormatTemplateList.getFormatById(1016));
			_lbStrengNextLv.move(465,194);
			_lbStrengNextLv.autoSize = TextFieldAutoSize.LEFT;
			addChild(_lbStrengNextLv);
			
			_lbStrengNextProp = new MAssetLabel("",FontFormatTemplateList.getFormatById(1016));
			_lbStrengNextProp.move(465,216);
			_lbStrengNextProp.autoSize = TextFieldAutoSize.LEFT;
			addChild(_lbStrengNextProp);
			
			//消耗灵气
			_lbStrengFee = new MAssetLabelPair("消耗灵气","",FontFormatTemplateList.getFormatById(1016),FontFormatTemplateList.getFormatById(1016),"：");
			_lbStrengFee.move(360,343);
			addChild(_lbStrengFee);
			
			//需要材料
			_lbNeedMaterial = new MAssetLabel("需要材料：",FontFormatTemplateList.getFormatById(1016));
			_lbNeedMaterial.move(216,343);
			addChild(_lbNeedMaterial);
			
			//精华
			_jinHuaCell = new LQMaterialCell(null, null, "精华");
			_jinHuaCell.needCount = 2;
			_jinHuaCell.move(279, 327);
			addChild(_jinHuaCell);
			
			//完美符
			_perfectCell = new LQMaterialCell(null, null, "完美符");
			_perfectCell.needCount = 1;
			_perfectCell.move(474, 230);
			addChild(_perfectCell);
			_perfectCell.visible = false;		//暂时屏蔽完美符
			
			//完美度图标
			_perfectBmp = new MBitmapButton(AssetUtil.getAsset("xdmh.furnace.strengthen.perfectAmuAsset")); 
			_perfectBmp.move(474, 230);
			_perfectBmp.visible = false;
			addChild(_perfectBmp);
			_perfectLb = new MAssetLabel("完美符", MAssetLabel.getLabelType(0xffffff,"宋体",11));
			_perfectLb.move(1,10);
			_perfectBmp.addChild(_perfectLb);
			
			//强化进度
			_lbPerfect = new MAssetLabel("强化进度：",FontFormatTemplateList.getFormatById(16));
			_lbPerfect.move(340,275);
			_lbPerfect.width = 120;
			_lbPerfect.autoSize = TextFieldAutoSize.LEFT;
			addChild(_lbPerfect);
			
			//强化按钮
			_btnStrength = new XDCacheAsset1Btn(0,"强化");
			_btnStrength.move(330,400);
			_btnStrength.enabled = false;
			addChild(_btnStrength);
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			furnaceInfo.addEventListener(FuranceEvent.EQUIP_ATTR_UPDATE,onStrengthenSuccess);
			_perfectCell.addEventListener(MouseEvent.CLICK, onPerfectCellClick);
			_perfectBmp.addEventListener(MouseEvent.CLICK, onPerfectClick);
			_perfectBmp.addEventListener(MouseEvent.MOUSE_OVER, onPerfectTipIn);
			_perfectBmp.addEventListener(MouseEvent.MOUSE_OUT, onPerfectTipOut);
			_swordBg.addEventListener(MouseEvent.MOUSE_OVER, onSwordTipIn);
			_swordBg.addEventListener(MouseEvent.MOUSE_OUT, onSwordTipOut);
			_btnStrength.addEventListener(MouseEvent.CLICK,onStrengthen);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			furnaceInfo.removeEventListener(FuranceEvent.EQUIP_ATTR_UPDATE,onStrengthenSuccess);
			_perfectCell.removeEventListener(MouseEvent.CLICK, onPerfectCellClick);
			_perfectBmp.removeEventListener(MouseEvent.CLICK, onPerfectClick);
			_perfectBmp.removeEventListener(MouseEvent.MOUSE_OVER, onPerfectTipIn);
			_perfectBmp.removeEventListener(MouseEvent.MOUSE_OUT, onPerfectTipOut);
			_swordBg.removeEventListener(MouseEvent.MOUSE_OVER, onSwordTipIn);
			_swordBg.removeEventListener(MouseEvent.MOUSE_OUT, onSwordTipOut);
			_btnStrength.removeEventListener(MouseEvent.CLICK,onStrengthen);
		}
		
		private function clear():void
		{
			_perfectCell.visible = false;
			//_perfectBmp.visible = true;	暂时屏蔽完美符
			_lbEquipName.setValue("");
			_previewCell.itemInfo = null;
			_lbStrengLayer.setValue("");
			_lbNextStrengLayer.setValue("");
			_lbBasicDesc.setValue("基础属性：");
			_lbBasicProp.setValue("");
			_lbStrengCurrLv.setValue("");
			_lbStrengCurrProp.setValue("");
			_lbStrengNextLv.setValue("");
			_lbStrengNextProp.setValue("");
			_lbStrengFee.value = "";
			_btnStrength.enabled = false;
			_lbPerfect.setValue("强化进度：");
			_swordBg.visible = false;
			_jinHuaCell.itemInfo = null;
		}
		
		override protected function showDetail(equip:ItemInfo):void
		{
			clear();
			if(equip.strengthen.level < _strengLvMax)
			{
				_showDetail(equip);
			}
			else
			{
				_jinHuaCell.forceClear();
				QuickTips.show("无法强化，该装备已达到最高强化等级！");
			}
		}
		
		private function _showDetail(equip:ItemInfo):void
		{
			var template:ItemTemplateInfo = equip.template;
			var streng:StrengthenData = equip.strengthen;
			var layer:int = equip.strengLayer;
			var nextLayer:int = equip.nextStrengLvLayer;
			
			//装备名
			_lbEquipName.setValue(equip.greenName);
			_lbEquipName.setLabelType(Color.getQiLingEquipNameFormat(equip.quality));
			
			//装备图标
			_previewCell.itemInfo = equip;
			
			//强化层级
			_lbStrengLayer.setValue(streng.level + "级(" + EquipLayer.getDesc(layer) + ")");
			_lbStrengLayer.setLabelType(Color.getQiLingLayerFormat(layer));
			
			if(layer < EquipLayer.LAYER_LEGEND)
			{
				_lbNextStrengLayer.setValue("("+EquipLayer.getDesc(layer+1) + "级需要" + equip.nextStrengLayerLv + "级)");
				_lbNextStrengLayer.setLabelType(Color.getQiLingLayerFormat(layer+1));
			}
			
			//基础属性
			_lbBasicDesc.setValue("基础" + EquipAttr.getText(equip.basicAttr.attrType) + "：");
			_lbBasicProp.setValue(equip.basicAttr.attrValue.toString());
			
			//判断当前强化等级是否大于上限
			//当前效果
			var canStreng:Boolean = streng.level < _strengLvMax;
			_lbStrengCurrLv.setValue((canStreng ? streng.level : _strengLvMax) + "级(" + streng.perfectValue * 10 + "%)");
			_lbStrengCurrProp.setValue(EquipAttr.getAttrDesc2(streng.attrType,streng.attrValue));
			_lbStrengCurrLv.setLabelType(Color.getQiLingLayerFormat(layer));
			_lbStrengCurrProp.setLabelType(Color.getQiLingLayerFormat(layer));
			updatePerfectProgress(canStreng ? streng.perfectValue : _percentMax);
			
			if(canStreng)
			{
				//下级效果
				_lbStrengNextLv.setValue((streng.level+1) + "级(" + EquipLayer.getDesc(nextLayer) + ")"); 
				_lbStrengNextProp.setValue(EquipAttr.getAttrDesc2(streng.attrType,streng.nextStrengVal));
				_lbStrengNextLv.setLabelType(Color.getQiLingLayerFormat(nextLayer));
				_lbStrengNextProp.setLabelType(Color.getQiLingLayerFormat(nextLayer));
				
				getJinHua();
				_needLingQi = streng.needLingQi;
				_lbStrengFee.value = _needLingQi.toString();
				_lbNextLv.visible = true;
				_lbStrengNextLvDesc.visible = true;
				_lbStrengNextPropDesc.visible = true;
				_btnStrength.enabled = true;
			}
			else
			{
				_jinHuaCell.showTopState();
				_lbStrengFee.value = "0";
				_lbNextLv.visible = false;
				_lbStrengNextLvDesc.visible = false;
				_lbStrengNextPropDesc.visible = false;
				_btnStrength.enabled = false;
			}
		}
		
		override protected function onRolePropUpdate(e:SelfPlayerInfoUpdateEvent):void
		{
			super.onRolePropUpdate(e);
			//_btnStrength.enabled = true;
		}
		
		override protected function onItemUpdate(e:BagInfoUpdateEvent):void
		{
			if(selectedEquip)
			{
				getJinHua();
			}
		}
		
		//获取精华
		private function getJinHua():void
		{
			var spriteList:Array = GlobalData.bagInfo.getItemById(CategoryType.SPRITE);
			_jinHuaCell.itemInfo = spriteList[0];
			_jinHuaCell.filters = null;
		}
		
		//获取完美符
		private function getPerfectSymbol():void
		{
			var symbolList:Array = GlobalData.bagInfo.getItemByType(CategoryType.PERFECT_SYMBOL);
			_perfectCell.itemInfo = symbolList.filter(function(item:*, index:int, arr:Array):Boolean
			{
				//获取对应等级的的完美玉符
				return item.template.itemLv == StrengthenFormula.getPerfectSymbol(selectedEquip.strengthen.level);
			})[0];
		}
		
		private function onPerfectCellClick(e:MouseEvent):void
		{
			if(selectedEquip)
			{
				_perfectCell.visible = !_perfectCell.visible;
				_perfectBmp.visible = !_perfectCell.visible;
			}
		}
		
		private function onPerfectClick(e:MouseEvent):void
		{
			if(!selectedEquip)
			{
				return;
			}
			else if(selectedEquip.strengthen.level < 10)
			{
				QuickTips.show("需要装备强化到10级才能使用完美符！");
			}
			else
			{
				getPerfectSymbol();
				if(!_perfectCell.itemInfo)
				{
					MAlert.show("对不起，包裹内无对应完美符，你可以尝试去商城购买！",
						LanguageManager.getWord("xdmh.common.alertTitle"),
						MAlert.YES|MAlert.NO,null,perfectPoorHandler);
					return;
				}
				
				//强化等级大于20后点击无效
				if(selectedEquip.strengthen.level < _strengLvMax)
				{
					_perfectCell.visible = !_perfectCell.visible;
					_perfectBmp.visible = !_perfectCell.visible;
				}
			}
		}
		
		private function onPerfectTipIn(e:MouseEvent):void
		{
			TipsUtil.getInstance().show("使用完美符，可使装备成功强化到下一等级！", null, new Rectangle(e.stageX, e.stageY,0,0));
		}
		
		private function onPerfectTipOut(e:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		private function onSwordTipIn(e:MouseEvent):void
		{
			TipsUtil.getInstance().show("完美度表示强化进度，完美度到100%时成功强化到下一等级！", null, new Rectangle(e.stageX, e.stageY,0,0));
		}
		
		private function onSwordTipOut(e:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		private function perfectPoorHandler(e:CloseEvent):void
		{
			if(e.detail == MAlert.YES)
			{
				showStorePanel();
			}
		}
		
		private function onStrengthen(e:MouseEvent):void
		{
			if(selectedEquip)
			{
				//判断灵气、精华是否足够
				if(GlobalData.selfPlayer.smartGas < _needLingQi)
				{
					showPoorMsg("灵气", lingQiPoorHandler);
				}
				else if(_jinHuaCell.isPoor)
				{
					showPoorMsg("精华", jinHuaPoorHandler);
				}
				else
				{
					_perfectFlag = getPerfectType();
					EquipStrengthenSocketHandler.sendEquipStrengthen(selectedEquip.itemId, _perfectFlag);
					playEffect(EffectType.CLICK_STRENGTHEN_BTN_EFFECT, _swordBg.x+290, _swordBg.y+18,false,SourceClearType.TIME);
				}	
			}
		}
		
		private function onStrengthenSuccess(e:FuranceEvent):void
		{
			var equipId:String = e.data.equipId;
			var equip:ItemInfo = GlobalData.bagInfo.getItemByItemId(equipId) || GlobalData.bagInfo.getEqItemByItemId(equipId);
			var fullStrengLv:int = e.data.fullStrengLv;
			
			clear();
			_showDetail(equip);
			
			if(e.data.lvUp)
			{
				QuickTips.show("恭喜你，装备强化等级升到第"+ equip.strengthen.level + "级！");
			}
			if(fullStrengLv)
			{
				QuickTips.show("恭喜你，全身装备强化到"+ fullStrengLv +"级");
			}
			
			//暂时屏蔽完美符
			//_perfectCell.visible = false;
			//_perfectBmp.visible = true;
		}
		
		private function updatePerfectProgress(value:int):void
		{
			value = value >= _percentMax ? _percentMax : value;
			var percent:Number = value/Number(_percentMax);
			_lbPerfect.setValue("强化进度：" + (percent*100).toString()+"%");
			_swordBg.width = _progressMax * percent;
			_swordBg.visible = true;
		}
		
		//获取使用的完美玉符类型（为0时表示未使用玉符）
		private function getPerfectType():int
		{
			if(_perfectCell.itemInfo && _perfectCell.visible)
				return _perfectCell.itemInfo.template.itemLv;
			return 0;
		}
		
		override public function dispose():void
		{
			removeEvent();
			super.dispose();
		}
	}
}