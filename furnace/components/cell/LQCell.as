package xdmh.furnace.components.cell
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import mhqy.ui.mcache.cells.CellCaches;
	
	import xdmh.core.data.GlobalData;
	import xdmh.core.data.item.ItemInfo;
	import xdmh.core.view.cell.BaseCompareItemInfoCell;
	import xdmh.furnace.common.equipedTrigleBgAsset;
	
	public class LQCell extends BaseCompareItemInfoCell
	{
		private var _showEquiped:Boolean;
		private var _equipedIcon:Bitmap;
		
		public function LQCell(clickHandler:Function=null, doubleClickHandler:Function=null, showEquiped:Boolean = false)
		{
			super();
			_showEquiped = showEquiped;
		}
		
		override protected function initFigureBound():void
		{
			_figureBound = new Rectangle(0,0,46,46);
		}
		
		override public function set itemInfo(value:ItemInfo):void
		{
			super.itemInfo = value;
			if(_iteminfo)
			{
				if(_showEquiped && GlobalData.bagInfo.getDressedEqupList().indexOf(_iteminfo) > -1)
				{
					_equipedIcon = new Bitmap(new equipedTrigleBgAsset());
					_equipedIcon.x = width - _equipedIcon.width-3;
					_equipedIcon.y = 3;
					addChild(_equipedIcon);
				}
			}
			else
			{
				disposeBitmap();
			}
		}
		
		override protected function createPicComplete(value:BitmapData):void
		{
			super.createPicComplete(value);
			if(_equipedIcon)
			{
				setChildIndex(_equipedIcon, numChildren - 1);
			}
		}
		
		private function disposeBitmap():void
		{
			if(_equipedIcon && _equipedIcon.parent)
			{
				_equipedIcon.parent.removeChild(_equipedIcon);
				if(_equipedIcon.bitmapData)
				{
					_equipedIcon.bitmapData.dispose();
					_equipedIcon.bitmapData = null;
				}
				_equipedIcon = null;
			}
		}
		
		override public function dispose():void
		{
			disposeBitmap();
			super.dispose();
		}
	}
}