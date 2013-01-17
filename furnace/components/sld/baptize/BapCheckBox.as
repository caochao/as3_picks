package xdmh.furnace.components.sld.baptize
{
	import fl.controls.CheckBox;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import mhqy.ui.label.MAssetLabel;
	
	import xdmh.core.data.fontFormat.FontFormatTemplateList;
	import xdmh.ui.LockAsset;
	
	public class BapCheckBox extends Sprite
	{
		private var _label:MAssetLabel;
		private var _lockAsset:Bitmap;
		private var _checkBox:CheckBox;
		
		public function BapCheckBox()
		{	
			_lockAsset = new Bitmap(new LockAsset());
			_lockAsset.x = -16;
			_lockAsset.y = -10;
			addChild(_lockAsset);
			_lockAsset.visible = false;
			
			_checkBox = new CheckBox();
			_checkBox.move(0,0);
			addChild(_checkBox);
			
			_label = new MAssetLabel("锁定",FontFormatTemplateList.getFormatById(1016));
			_label.move(25, -10);
			addChild(_label);
			
			this.buttonMode = true;
		}
		
		public function get checkBox():CheckBox
		{
			return _checkBox;
		}
		
		public function get label():MAssetLabel
		{
			return _label;
		}
		
		public function set selected(value:Boolean):void 
		{
			_checkBox.selected = value;
			_lockAsset.visible = value;
			_label.visible = !value;
		}
		
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
	}
}