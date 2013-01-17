package xdmh.furnace.components.sld.baptize
{
	import fl.controls.CheckBox;
	
	import flash.events.MouseEvent;
	
	import xdmh.furnace.events.FuranceEvent;

	/**
	 * 可锁定的洗炼属性条
	 */ 
	public class BaptizeLocker extends BaptizeViewer
	{
		private var _lock:Boolean;					//洗炼时是否锁定该属性
		private var _bapCheck:BapCheckBox;
		
		public function BaptizeLocker(type:int=1, key:String="攻击", value:String="0", star:int=1, lock:Boolean = false)
		{
			_lock = lock;
			super(type, key, value, star);
		}
		
		override protected function initView():void
		{
			super.initView();
			
			//checkbox
			_bapCheck = new BapCheckBox();
			_bapCheck.selected = _lock;
			_bapCheck.move(_starStrLabel.x + _starStrLabel.width + 12, _starStrLabel.y + 10);
			addChild(_bapCheck);
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			_bapCheck.checkBox.addEventListener(MouseEvent.CLICK, onLockClick);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			_bapCheck.checkBox.removeEventListener(MouseEvent.CLICK, onLockClick);
		}
		
		private function onLockClick(e:MouseEvent):void
		{
			lock = !lock;
			dispatchEvent(new FuranceEvent(FuranceEvent.BAPTIZE_ATTR_LOCK));
		}
		
		public function set lockerVisible(value:Boolean):void
		{
			if(_bapCheck.checkBox.visible == value) return;
			_bapCheck.checkBox.visible = value;
			if(_bapCheck.checkBox.selected) return;
			_bapCheck.label.visible = value;
		}
		
		public function get checkBox():CheckBox
		{
			return _bapCheck.checkBox;
		}
		
		public function get lock():Boolean
		{
			return _lock;
		}
		
		public function set lock(value:Boolean):void
		{
			if(_lock == value) return;
			_lock = value;
			_bapCheck.selected = _lock;
		}
	}
}