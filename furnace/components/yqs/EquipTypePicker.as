package xdmh.furnace.components.yqs
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mhqy.ui.backgroundUtil.BackgroundInfo;
	import mhqy.ui.backgroundUtil.BackgroundUtils;
	import mhqy.ui.mcache.btns.selectBtns.MCacheSelectBtn4;
	
	import xdmh.constData.CategoryType;
	import xdmh.core.data.module.ModuleType;
	import xdmh.furnace.FurnaceFacade;
	import xdmh.furnace.FurnaceModule;
	import xdmh.furnace.data.FurnaceInfo;
	import xdmh.interfaces.moviewrapper.IMovieWrapper;
	import xdmh.ui.BorderAsset15;
	
	/**
	 * 装备部位选取器 
	 * @author Administrator
	 * 
	 */	
	public class EquipTypePicker extends Sprite
	{
		private var _eqTypeList:Vector.<MCacheSelectBtn4>;		//与CategoryType.Equip_Types数组顺序一致
		private var _currBtn:MCacheSelectBtn4;
		private var _bg:IMovieWrapper;
		
		public function EquipTypePicker()
		{
			initView();
			initEvent();
			//默认选中第一项
			//_eqTypeList[0].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		private function initView():void
		{
			//背景
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BorderAsset15, new Rectangle(0,0,140,408))		//底图
			]);
			addChild(_bg as DisplayObject);
			
			//装备类型按钮
			var _eqBtnPos:Vector.<Point> = new Vector.<Point>();
			_eqBtnPos.push(new Point(11,8), new Point(11,57), new Point(11,106), new Point(11,155), 
						   new Point(11,204), new Point(11,253),new Point(11,302), new Point(11,351),new Point(11,400));
			
			_eqTypeList = new Vector.<MCacheSelectBtn4>();
			_eqTypeList.push(new MCacheSelectBtn4(0,0,"武器"),new MCacheSelectBtn4(0,0,"衣服"), new MCacheSelectBtn4(0,0,"帽子"), new MCacheSelectBtn4(0,0,"鞋子"),
							 new MCacheSelectBtn4(0,0,"戒指"),new MCacheSelectBtn4(0,0,"护符"), new MCacheSelectBtn4(0,0,"项链"), new MCacheSelectBtn4(0,0,"手镯"));
			for(var i:int = 0, len:int = _eqTypeList.length; i<len ; i++)
			{
				var btn:MCacheSelectBtn4 = _eqTypeList[i];
				var pos:Point = _eqBtnPos[i];
				btn.move(pos.x, pos.y);
				addChild(btn);
			}
		}
		
		private function initEvent():void
		{
			for(var i:int = 0, len:int = _eqTypeList.length ; i<len ; i++)
			{
				_eqTypeList[i].addEventListener(MouseEvent.CLICK,onEqTypeChange);
			}
		}
		
		private function removeEvent():void
		{
			for(var i:int = 0, len:int = _eqTypeList.length ; i<len ; i++)
			{
				_eqTypeList[i].removeEventListener(MouseEvent.CLICK,onEqTypeChange);
			}
		}
		
		private function onEqTypeChange(e:MouseEvent):void
		{
			var target:MCacheSelectBtn4 = MCacheSelectBtn4(e.currentTarget);
			if(_currBtn == target) return;
			_currBtn = target;
			setSelected(_currBtn);
			furnaceInfo.eqTypeSelected({"eqType": CategoryType.EQUIP_TYPES[_eqTypeList.indexOf(_currBtn)]});
		}
		
		private function setSelected(currBtn:MCacheSelectBtn4):void
		{
			for each(var btn:MCacheSelectBtn4 in  _eqTypeList)
			{
				btn.selected = false;
			}
			currBtn.selected = true;
		}
		
		private function get furnaceInfo():FurnaceInfo
		{
			return FurnaceFacade.getInstance(ModuleType.FURNACE.toString()).furnaceModule.furnaceInfo;
		}
		
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			removeEvent();
		}
	}
}