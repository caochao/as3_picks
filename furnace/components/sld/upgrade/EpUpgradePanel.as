package xdmh.furnace.components.sld.upgrade
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mhqy.ui.backgroundUtil.BackgroundInfo;
	import mhqy.ui.backgroundUtil.BackgroundType;
	import mhqy.ui.backgroundUtil.BackgroundUtils;
	import mhqy.ui.label.MAssetLabel;
	import mhqy.ui.label.MAssetLabelPair;
	import mhqy.ui.mcache.btns.MCacheAsset1Btn;
	import mhqy.ui.mcache.cells.CellCaches;
	
	import xdmh.core.data.furnace.equip.Color;
	import xdmh.core.data.item.ItemInfo;
	import xdmh.core.utils.AssetUtil;
	import xdmh.furnace.components.cell.LQBigCell;
	import xdmh.furnace.components.cell.LQCell;
	import xdmh.furnace.components.cell.LQMaterialCell;
	import xdmh.furnace.components.sld.EpBasePanel;
	import xdmh.furnace.events.FuranceEvent;
	import xdmh.interfaces.moviewrapper.IMovieWrapper;
	
	/**
	 * 装备升级面板
	 */ 
	public class EpUpgradePanel extends EpBasePanel
	{
		private var _lbOld:MAssetLabel;
		private var _lbNew:MAssetLabel;
		private var _lbFee:MAssetLabelPair;
		private var _lbNeed:MAssetLabel;
		
		private var _oldCell:LQCell;
		private var _newCell:LQBigCell;
		private var _jinHuaCell:LQMaterialCell;			//精华
		private var _xuanTieCell:LQMaterialCell;			//玄铁
		private var _shuiJinCell:LQMaterialCell;			//水晶
		private var _stoneCell:LQMaterialCell;				//鸿蒙石
		
		private var _baguaBg:Bitmap;
		private var _bagua:Bitmap;
		private var _btnUpgrade:MCacheAsset1Btn;
		
		public function EpUpgradePanel()
		{
			_picPath = "xdmh.furnace.upgrade.bgAsset";
			super();
		}
		
		override protected function initView():void
		{
			super.initView();
			
			//八卦背景
			_baguaBg = new Bitmap(AssetUtil.getAsset("xdmh.furnace.upgrade.ringAsset") as BitmapData);
			_baguaBg.x = 331;
			_baguaBg.y = 99;
			addChild(_baguaBg);
			_bagua = new Bitmap(AssetUtil.getAsset("xdmh.furnace.upgrade.baguaAsset") as BitmapData);
			_bagua.x = 344;
			_bagua.y = 110;
			addChild(_bagua);
		
			//新装备
			_newCell = new LQBigCell();
			_newCell.move(235,138);
			addChild(_newCell);
			
			_lbNew = new MAssetLabel("新装备",MAssetLabel.LABELTYPE53);
			_lbNew.move(252,212);
			addChild(_lbNew);
			
			//原装备
			_oldCell = new LQCell();
			_oldCell.move(510,152); 
			addChild(_oldCell);
			
			_lbOld = new MAssetLabel("原装备",MAssetLabel.LABELTYPE53);
			_lbOld.move(510,212);
			addChild(_lbOld);
			
			//消耗灵气
			_lbFee = new MAssetLabelPair("消耗灵气", "", MAssetLabel.LABELTYPE53, MAssetLabel.LABELTYPE53);
			_lbFee.move(295, 267);
			addChild(_lbFee);
			
			//需要材料
			_lbNeed = new MAssetLabel("需要材料：", MAssetLabel.LABELTYPE53);
			_lbNeed.move(295, 289);
			addChild(_lbNeed);
			
			_jinHuaCell = new LQMaterialCell(null, null, "精华");
			_jinHuaCell.move(358,289);
			addChild(_jinHuaCell);
			
			_xuanTieCell = new LQMaterialCell(null, null, "玄铁");
			_xuanTieCell.move(404,289);
			addChild(_xuanTieCell);
			
			_shuiJinCell = new LQMaterialCell(null, null, "水晶");
			_shuiJinCell.move(404,289);
			_shuiJinCell.visible = false;
			addChild(_shuiJinCell);
			
			_stoneCell = new LQMaterialCell(null, null, "鸿蒙石");
			_stoneCell.move(450,289);
			addChild(_stoneCell);
			
			//升级按钮
			_btnUpgrade = new MCacheAsset1Btn(2,"开始升级");
			_btnUpgrade.move(367,368);
			_btnUpgrade.enabled = false;
			addChild(_btnUpgrade);
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			furnaceInfo.addEventListener(FuranceEvent.EQUIP_ATTR_UPDATE,onUpgradeSuccess);
			_btnUpgrade.addEventListener(MouseEvent.CLICK,onUpgrade);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			furnaceInfo.removeEventListener(FuranceEvent.EQUIP_ATTR_UPDATE,onUpgradeSuccess);
			_btnUpgrade.removeEventListener(MouseEvent.CLICK,onUpgrade);
		}
		
		private function onUpgrade(e:MouseEvent):void
		{
			
		}
		
		private function onUpgradeSuccess(e:FuranceEvent):void
		{
			
		}
		
		override protected function showDetail(equip:ItemInfo):void
		{
			//装备图标
			_oldCell.itemInfo = equip;
			_newCell.itemInfo = equip;
			
			//原装备、新装备
			_lbOld.setValue(equip.showGreenName());
			_lbOld.setLabelType(Color.getQualityFormat(equip.quality,14,true));
			_lbNew.setValue(equip.showGreenName());
			_lbNew.setLabelType(Color.getQualityFormat(equip.quality,14,true));
		}
		
		override public function dispose():void
		{
			//to do:释放子类资源
			super.dispose();
		}
	}
}