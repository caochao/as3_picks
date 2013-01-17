package xdmh.furnace.components.sld.suiting
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	
	import xdmh.core.utils.AssetUtil;

	/**
	 * 套装打造界面职业选取图标
	 * @author caochao
	 * 
	 */	
	public class SuitCareerIcon extends Sprite
	{
		private var _defaultIcon:Bitmap;
		private var _selectIcon:Bitmap;
		private var _overIcon:Bitmap;
		private var _select:Boolean;
		private var _over:Boolean;
		private var _career:String;
		
		/**
		 * 
		 * @param defaultBg 默认显示的图片资源
		 * @param selectBg  选中时的图片资源
		 * 
		 */		
		public function SuitCareerIcon(defaultBg:BitmapData, selectBg:BitmapData, career:String)
		{
			_defaultIcon = new Bitmap(defaultBg);
			addChild(_defaultIcon);
			
			_selectIcon = new Bitmap(selectBg);
			_selectIcon.visible = false;
			_selectIcon.x = -4;
			_selectIcon.y = -4;
			addChild(_selectIcon);
			
			_overIcon = new Bitmap(selectBg);
			_overIcon.visible = false;
			_overIcon.x = -4;
			_overIcon.y = -4;
			addChild(_overIcon);
			
			_career = career;
			buttonMode = true;
		}
		
		public function get select():Boolean
		{
			return _select;
		}
		
		public function set select(value:Boolean):void
		{
			if(_select == value) return;
			_select = value;
			_selectIcon.visible = _select;
		}
		
		public function set mouseOver(value:Boolean):void
		{
			if(_over == value) return;
			_over = value;
			_overIcon.visible = _over;
		}
		
		public function get career():String
		{
			return _career;
		}
		
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			if(_defaultIcon && _defaultIcon.parent)
			{
				_defaultIcon.parent.removeChild(_defaultIcon);
				if(_defaultIcon.bitmapData)
				{
					_defaultIcon.bitmapData.dispose();
					_defaultIcon.bitmapData = null;
				}
				_defaultIcon = null;
			}
			if(_selectIcon && _selectIcon.parent)
			{
				_selectIcon.parent.removeChild(_selectIcon);
				if(_selectIcon.bitmapData)
				{
					_selectIcon.bitmapData.dispose();
					_selectIcon.bitmapData = null;
				}
				_selectIcon = null;
			}
			if(_overIcon && _overIcon.parent)
			{
				_overIcon.parent.removeChild(_overIcon);
				if(_overIcon.bitmapData)
				{
					_overIcon.bitmapData.dispose();
					_overIcon.bitmapData = null;
				}
				_overIcon = null;
			}
		}
	}
}