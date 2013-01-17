package xdmh.furnace.components.sld.baptize
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import mhqy.ui.label.MAssetLabel;
	
	import xdmh.core.data.fontFormat.FontFormatTemplateList;
	import xdmh.furnace.common.ArrowsDownAsset;
	import xdmh.furnace.common.ArrowsUpAsset;
	
	/**
	 * 自定义组件，会根据数据正负显示上下箭头
	 * 注：需保证传入的值是数字，方能正常显示
	 */	
	public class ArrowLabel extends Sprite
	{
		private var _label:MAssetLabel;
		private var _enhanceLabel:MAssetLabel;
		private var _upArrows:Bitmap;				//向上的绿色箭头
		private var _downArrows:Bitmap;			//向下的红色箭头
		
		public function ArrowLabel(label:String, enhance:int, labelType:Array, enhanceType:Array, align:String="center")
		{
			super();
			
			_label = new MAssetLabel(label, labelType, align);
			addChild(_label);
			
			_upArrows = new Bitmap(new ArrowsUpAsset());
			_upArrows.x = _label.x + _label.width + 10;
			_upArrows.y = _label.y + 3;
			addChild(_upArrows);
			_upArrows.visible = false;
			
			_downArrows = new Bitmap(new ArrowsDownAsset());
			_downArrows.x = _label.x + _label.width + 10;
			_downArrows.y = _label.y + 3;
			addChild(_downArrows);
			_downArrows.visible = false;
			
			_enhanceLabel = new MAssetLabel(enhance == 0 ? "" : enhance.toString() + "星", enhanceType, align);
			_enhanceLabel.move(_upArrows.x + _upArrows.width + 10, _label.y);
			addChild(_enhanceLabel);
		}
		
		public function setLabelType(argLabelType:Array):void
		{
			_label.setLabelType(argLabelType);
		}
		
		private function setEnhanceType(argLabelType:Array):void
		{
			_enhanceLabel.setLabelType(argLabelType);
		}
		
		public function set label(label:String):void
		{
			_label.setValue(label);
		}
		
		public function set enhance(value:int):void
		{
			if(value == 0)
			{
				_enhanceLabel.visible = false;
				_upArrows.visible = false;
				_downArrows.visible = false;
			}
			else
			{
				_enhanceLabel.setValue(value.toString().replace("-","") + "星");
				_enhanceLabel.visible = true;
				if(value >= 0)
				{
					_upArrows.visible = true;
					_downArrows.visible = false;
					setEnhanceType(FontFormatTemplateList.getFormatById(43));
				}
				else 
				{
					_downArrows.visible = true;
					_upArrows.visible = false;		
					setEnhanceType(FontFormatTemplateList.getFormatById(1015));
				}
			}
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			if(_upArrows && _upArrows.parent)
			{
				_upArrows.parent.removeChild(_upArrows);
				_upArrows.bitmapData.dispose();
				_upArrows.bitmapData = null;
				_upArrows = null;
			}
			if(_downArrows && _downArrows.parent)
			{
				_downArrows.parent.removeChild(_downArrows);
				_downArrows.bitmapData.dispose();
				_downArrows.bitmapData = null;
				_downArrows = null;
			}
			if(_enhanceLabel)
			{
				_enhanceLabel = null;
			}
			if(_label)
			{
				_label = null;
			}
		}
	}
}