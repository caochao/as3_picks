package xdmh.furnace.components.sld.baptize
{
	import flash.display.Sprite;
	import flash.text.TextFieldAutoSize;
	
	import mhqy.ui.label.MAssetLabel;
	import mhqy.ui.label.MAssetLabelPair;
	
	import xdmh.core.data.furnace.equip.Color;
	import xdmh.core.data.furnace.equip.EquipQuality;
	
	/**
	 * 洗炼属性条
	 */
	public class BaptizeViewer extends Sprite
	{
		private var _showAttrType:Boolean;			//是否显示洗炼属性类型
		
		protected var _type:int;				//类型，1子，2丑，3寅，4卯，5辰，6巳
		protected var _key:String;				//洗炼属性，例如“攻击，暴击”
		protected var _value:String;			//洗炼值,例如"100,200"
		protected var _quality:int;		    //洗炼属性品质，Color常量（1白，2蓝，3紫，4金）
		protected var _star:int;				//洗炼属性星级
		
		protected var _attrFormat:Array;				//属性条字体格式
														//攻击+100   （2 星）
		protected var _attrLabel:MAssetLabel;			//攻击+100
		protected var _starValLabel:MAssetLabel;		//(2
		protected var _starStrLabel:MAssetLabel;		//星)	
		
		public function BaptizeViewer(type:int = 1, key:String = "攻击", value:String = "0", star:int = 1, showAttrType:Boolean = true)
		{
			_type = type;
			_key = key;
			_value = value;
			_star = star;
			_showAttrType = showAttrType;
			_quality = EquipQuality.getBaptizeQuality(_star);
			initView();
			initEvent();
		}
		
		protected function initView():void
		{
			//attr属性条
			setAttrFormat(_quality);
			
			_attrLabel = new MAssetLabel("",_attrFormat);
			_attrLabel.autoSize = TextFieldAutoSize.LEFT;
			addChild(_attrLabel);
			
			_starValLabel = new MAssetLabel("",_attrFormat);
			_starValLabel.autoSize = TextFieldAutoSize.LEFT;
			addChild(_starValLabel);
			
			_starStrLabel = new MAssetLabel("星)",_attrFormat);
			_starStrLabel.autoSize = TextFieldAutoSize.RIGHT;
			addChild(_starStrLabel);
			
			if(_showAttrType)
			{
				_attrLabel.width = 70;
				_attrLabel.move(0,0);
				_starValLabel.width = 20;
				_starValLabel.move(70,0);
				_starStrLabel.width = 19;
				_starStrLabel.move(90,0);
			}
			else
			{
				_attrLabel.width = 35;
				_attrLabel.move(0,0);
				_starValLabel.width = 20;
				_starValLabel.move(35,0);
				_starStrLabel.width = 19;
				_starStrLabel.move(55,0);
			}
		}
		
		protected function initEvent():void
		{
			
		}
		
		protected function removeEvent():void
		{
			
		}
		
		private function setAttrFormat(quality:int):void
		{
			_attrFormat = Color.getQiLingBapAttrFormat(quality);
		}
		
		private function setAttrStr(key:String,value:String,star:int):void
		{
			if(_showAttrType)
			{
				_attrLabel.setValue(key + "+" + value);
			}
			else
			{
				_attrLabel.setValue(value);
			}
			_starValLabel.setValue("(" + star.toString());
		}
		
		private function set labelType(format:Array):void
		{
			_attrLabel.setLabelType(format);
			_starValLabel.setLabelType(format);
			_starStrLabel.setLabelType(format);
		}
		
		public function get type():int
		{
			return _type;
		}
		
		public function set type(value:int):void
		{
			if(_type == value) return;
			_type = value;
		}
		
		public function get key():String
		{
			return _key;
		}
		
		public function set key(value:String):void
		{
			if(_key == value) return;
			_key = value;
			setAttrStr(_key,_value,_star);
		}
		
		public function get value():String
		{
			return _value;
		}
		
		public function set value(value:String):void
		{
			if(_value == value) return;
			_value = value;
			setAttrStr(_key,_value,_star);
		}
		
		public function set quality(value:int):void
		{
			if(_quality == value) return;
			_quality = value;
			setAttrFormat(_quality);
			this.labelType = _attrFormat;
		}
		
		public function get quality():int
		{
			return _quality;
		}
		
		public function get star():int
		{
			return _star;
		}
		
		public function set star(star:int):void
		{
			_star = star;
			quality = EquipQuality.getBaptizeQuality(_star);
			setAttrStr(_key,_value,_star);
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