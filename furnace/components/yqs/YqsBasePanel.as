package xdmh.furnace.components.yqs
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import mhqy.ui.backgroundUtil.BackgroundInfo;
	import mhqy.ui.backgroundUtil.BackgroundUtils;
	import mhqy.ui.container.MAlert;
	
	import xdmh.core.data.GlobalData;
	import xdmh.core.data.item.ItemInfo;
	import xdmh.core.data.module.ModuleType;
	import xdmh.core.manager.LanguageManager;
	import xdmh.core.utils.AssetUtil;
	import xdmh.core.view.quickTips.QuickTips;
	import xdmh.furnace.FurnaceFacade;
	import xdmh.furnace.data.FurnaceInfo;
	import xdmh.furnace.events.FuranceEvent;
	import xdmh.interfaces.dispose.IDispose;
	import xdmh.interfaces.moviewrapper.IMovieWrapper;
	import xdmh.ui.BorderAsset15;
	
	/**
	 * 御器术附灵、造化基类 
	 * @author Administrator
	 * 
	 */	
	public class YqsBasePanel extends Sprite implements IDispose
	{
		private var _currEqType:int;			//当前选中装备类型
		private var _currEq:ItemInfo;
		private var _bg:IMovieWrapper;
		private var _pic:Bitmap;
		
		protected var _picPath:String;
		protected var _needXianQi:Number;		//需要仙气
		
		public function YqsBasePanel()
		{
			initView();
			initEvent();
		}
		
		protected function initView():void
		{
			//背景
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BorderAsset15,new Rectangle(0,0,470,379))
			]);
			_bg.move(0, 32);
			addChild(_bg as DisplayObject);
			
			//背景图片
			_pic = new Bitmap(AssetUtil.getAsset(_picPath) as BitmapData);
			_pic.x = 8;
			_pic.y = 39;
			addChild(_pic);
		}
		
		protected function initEvent():void
		{
			furnaceInfo.addEventListener(FuranceEvent.EQUIP_TYPE_SELECTED, typePickerHandler);
		}
		
		protected function removeEvent():void
		{
			furnaceInfo.removeEventListener(FuranceEvent.EQUIP_TYPE_SELECTED, typePickerHandler);
		}
		
		private function typePickerHandler(e:FuranceEvent):void
		{
			_currEqType = e.data.eqType;
			_currEq = GlobalData.bagInfo.getEquipByType(_currEqType);
			showDetail(_currEq);
		}
		
		protected function showDetail(equip:ItemInfo):void
		{
			
		}
		
		protected function get furnaceInfo():FurnaceInfo
		{
			return FurnaceFacade.getInstance(ModuleType.FURNACE.toString()).furnaceModule.furnaceInfo;
		}
		
		protected function get currEq():ItemInfo
		{
			return _currEq;
		}
		
		public function get currEqType():int
		{
			return _currEqType;
		}
		
		protected function showPoorMsg(itemName:String, callBack:Function = null):void
		{
			MAlert.show("对不起，你当前" + itemName + "不足，可尝试去市场购买！",
				LanguageManager.getWord("xdmh.common.alertTitle"),
				MAlert.YES|MAlert.NO,null, callBack);
		}
		
		public function dispose():void
		{
			removeEvent();
		}
	}
}