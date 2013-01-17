package xdmh.furnace.components.yqs.fortune
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mhqy.ui.button.MBitmapButton;
	import mhqy.ui.label.MAssetLabel;
	import mhqy.ui.mcache.cells.CellCaches;
	
	import xdmh.core.data.furnace.equip.BasicAttr;
	import xdmh.core.data.furnace.equip.EquipAttr;
	import xdmh.core.data.furnace.equip.FortuneExpTemplateList;
	import xdmh.core.data.furnace.equip.baptize.BaptizePos;
	import xdmh.core.data.item.ItemInfo;
	import xdmh.core.data.module.ModuleType;
	import xdmh.core.utils.AssetUtil;
	import xdmh.furnace.FurnaceFacade;
	import xdmh.furnace.data.FurnaceInfo;
	import xdmh.furnace.events.FuranceEvent;
	import xdmh.furnace.socketHandlers.equip.EquipFortuneLockSocketHanlder;

	/**
	 * 装备造化部位视图（1子，2丑，3寅，4卯，5辰，6巳）
	 */ 
	public class FortunePillar extends Sprite
	{
		private var _type:int;						//类型(1子，2丑，3寅，4卯，5辰，6巳)
		private var _lv:int;						//造化等级
		private var _lvExp:int;					//当前等级对应经验
		private var _exp:int;						//当前经验
		private var _bapAttr:BasicAttr;			//洗炼属性
		private var _lock:Boolean;					//锁定（即不选用此造化属性）
		private var _eqType:int;					//装备部位
		private var _change:int;					//造化经验值变化
		private var _lockFormat:Array;				//锁定时造化加成字体
		private var _openFormat:Array;				//启用时造化加成字体
		private var _ascFormat:Array;				//升序字体
		private var _descFormat:Array;				//降序字体
		
		private var _openBtn:MBitmapButton;		//"启"按钮
		private var _lockBtn:MBitmapButton;		//"封"按钮
		private var _haloBmp:Bitmap;				//光环轮廓
		private var _typeBmp:Bitmap;				//蓝、紫、金
		private var _bubbleBmp:Bitmap;				//水泡
		private var _arrowUpBmp:Bitmap;			//向上箭头
		private var _arrowDownBmp:Bitmap;			//向下箭头
		
		private var _lbExp:MAssetLabel;			//造化经验
		private var _lbLv:MAssetLabel;				//造化等级
		private var _lbEnhance:MAssetLabel;		//造化加成
		private var _lbBapAttr:MAssetLabel;		//洗炼属性描述
		private var _lbChange:MAssetLabel;			//造化经验值变化
		
		/**
		 * @param type 造化部位（1子，2丑，3寅，4卯，5辰，6巳）
		 * @param lv 造化等级
		 * @param bapType 洗炼属性类型
		 * @param bapVal 洗炼属性值
		 * @param lock 锁定（不选用）此造化属性
		 */ 
		public function FortunePillar(type:int=0, lv:int=0, exp:int=0, bapAttr:BasicAttr=null, lock:Boolean=true)
		{
			_type = type;
			_lv = lv;
			_exp = exp;
			_bapAttr = bapAttr;
			_lock = lock;
			
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			//光环轮廓
			_haloBmp = new Bitmap(AssetUtil.getAsset("xdmh.furnace.fortune.pillerOutlineAsset") as BitmapData);
			_haloBmp.x = -17;
			_haloBmp.y = 29;
			_haloBmp.visible = false;
			addChild(_haloBmp);
			
			//类型图片
			_typeBmp = createTypeBmp(_type);
			_typeBmp.x = -2;
			_typeBmp.y = 38;
			_typeBmp.visible = false;
			addChild(_typeBmp);
			
			//"启","封"按钮
			_openBtn = new MBitmapButton(AssetUtil.getAsset("xdmh.furnace.fortune.openFortuneAsset") as BitmapData);
			_openBtn.move(9, 121);
			addChild(_openBtn);
			
			_lockBtn = new MBitmapButton(AssetUtil.getAsset("xdmh.furnace.fortune.closeFortuneAsset") as BitmapData);
			_lockBtn.move(3, 116);
			_lockBtn.visible = false;
			addChild(_lockBtn);
			
			//水泡按钮
			_bubbleBmp = new Bitmap(AssetUtil.getAsset("xdmh.furnace.fortune.bubbleAsset") as BitmapData);
			_bubbleBmp.x = -9;
			_bubbleBmp.y = 148;
			addChild(_bubbleBmp);
			
			//向上、下箭头
			_arrowUpBmp = new Bitmap(AssetUtil.getAsset("xdmh.furnace.common.ArrowsUpAsset") as BitmapData);
			_arrowUpBmp.x = 6;
			_arrowUpBmp.y = 160;
			_arrowUpBmp.visible = false;
			addChild(_arrowUpBmp);
			
			_arrowDownBmp = new Bitmap(AssetUtil.getAsset("xdmh.furnace.common.ArrowsDownAsset") as BitmapData);
			_arrowDownBmp.x = 6;
			_arrowDownBmp.y = 160;
			_arrowDownBmp.visible = false;
			addChild(_arrowDownBmp);
			
			//造化加成字体
			_lockFormat = MAssetLabel.getLabelType2(0x737373,0x000000,"宋体",13);
			_openFormat = MAssetLabel.getLabelType2(0xFFF601,0x000000,"宋体",13);
			_ascFormat = MAssetLabel.getLabelType2(0x00ff00,0x000000);
			_descFormat = MAssetLabel.getLabelType2(0xff0000,0x000000);
			
			//洗炼属性描述
			_lbBapAttr = new MAssetLabel("",MAssetLabel.getLabelType(0xffffff,"宋体",13));
			_lbBapAttr.move(4,0);
			_lbBapAttr.visible = false;
			addChild(_lbBapAttr);
			
			//造化加成
			_lbEnhance = new MAssetLabel("", _lockFormat);
			_lbEnhance.move(4,42);
			_lbEnhance.visible = false;
			addChild(_lbEnhance); 
			
			//经验值变化
			_lbChange = new MAssetLabel("", MAssetLabel.LABELTYPE19);
		    _lbChange.move(14,156);
			_lbChange.visible = false;
			addChild(_lbChange);
			
			//造化经验
			_lbExp = new MAssetLabel(getExp(), _openFormat);
			_lbExp.move(6,175);
			addChild(_lbExp);
			
			//造化等级
			_lbLv = new MAssetLabel("LV."+_lv.toString(),_openFormat);
			_lbLv.move(0,207);
			addChild(_lbLv);
		}
		
		private function initEvent():void
		{
			_openBtn.addEventListener(MouseEvent.CLICK,onLockClick);
			_lockBtn.addEventListener(MouseEvent.CLICK,onLockClick);
			furnaceInfo.addEventListener(FuranceEvent.EQUIP_TYPE_SELECTED,onFortuneEqChange);
		}
		
		private function removeEvent():void
		{
			_openBtn.removeEventListener(MouseEvent.CLICK,onLockClick);
			_lockBtn.removeEventListener(MouseEvent.CLICK,onLockClick);
			furnaceInfo.removeEventListener(FuranceEvent.EQUIP_TYPE_SELECTED,onFortuneEqChange);
		}
		
		private function createTypeBmp(type:int):Bitmap
		{
			var asset:String;
			switch(type)
			{
				case BaptizePos.ZHI:
				case BaptizePos.CHOU:
					asset = "xdmh.furnace.fortune.blueCircleAsset";
					break;
				case BaptizePos.YIN:
				case BaptizePos.MAO:
					asset = "xdmh.furnace.fortune.purpleCircleAsset";
					break;
				case BaptizePos.CHEN:
				case BaptizePos.SI:
					asset = "xdmh.furnace.fortune.goldCircleAsset";
					break;
			}
			return new Bitmap(AssetUtil.getAsset(asset) as BitmapData);
		}
		
		public function get lock():Boolean
		{
			return _lock;
		}
		
		public function set lock(value:Boolean):void
		{
			if(_lock == value) return;
			_lock = value;
			
			_openBtn.visible = _lock;
			_lockBtn.visible = !_lock;
			_haloBmp.visible = !_lock;
			_typeBmp.visible = !_lock;
			_lbEnhance.setLabelType(_lock ? _lockFormat : _openFormat);
		}
		
		/**
		 * 获取造化柱位置
		 */ 
		public function get type():int
		{
			return _type;
		}
		
		/**
		 * 设置造化增益
		 */ 
		public function set enhance(value:int):void
		{
			var percent:Number = Math.ceil(value / 100.0);
			_lbEnhance.setValue(EquipAttr.getAttrDesc4(_bapAttr.attrType, _bapAttr.attrValue * percent));
			_lbEnhance.move(4,42);
		}
		
		/** 
		 * 设置基础洗炼属性
		 */		
		public function set bapAttr(attr:BasicAttr):void
		{
			_bapAttr = attr;
			_lbBapAttr.setValue(EquipAttr.getAttrDesc3(_bapAttr));
			_lbBapAttr.move(4,0);
		}
		
		public function getExp():String
		{
			var percent:Number = Number(_exp)/FortuneExpTemplateList.getExp(_lv)*100;
			return Math.ceil(percent).toString()+"%";
		}
		
		/**
		 * 获取该造化等级对应的累积造化经验
		 */		
		public function get totalExp():int
		{
			return FortuneExpTemplateList.getTotalExp(_lv) + _exp;
		}
		
		public function get exp():int
		{
			//trace("等级："+ _lv + "累积经验：" + (FortuneExpTemplateList.getTotalExp(_lv) + _exp));
			//return FortuneExpTemplateList.getTotalExp(_lv) + _exp;
			return _exp;
		}
		
		/**
		 * 设置造化经验
		 */ 
		public function set exp(value:int):void
		{
			_exp = value;
			_lbExp.setValue(getExp());
			_lbExp.move(6, 175);
		}
		
		public function get lv():int
		{
			return _lv;
		}
		
		/**
		 * 设置造化等级
		 */ 
		public function set lv(value:int):void
		{
			_lv = value;
			_lbLv.setValue("LV."+ _lv.toString());
			_lbLv.move(0, 207);
		}
		
		/** 
		 * 设置经验值变化
		 */		
		public function set change(value:int):void
		{
			if(_change == value) return;
			_change = value;
			if(0 == _change) 
			{
				_arrowUpBmp.visible = false;
				_arrowDownBmp.visible = false;
				_lbChange.visible = false;
				return;
			}
			
			var asc:Boolean = _change > 0;
			_arrowUpBmp.visible = asc;
			_arrowDownBmp.visible = !asc;
			
			_lbChange.visible = true;
			_lbChange.setValue(_change.toString().replace("-",""));
			_lbChange.setLabelType(asc ? _ascFormat : _descFormat);
			_lbChange.move(14,156);
		}
		
		public function get change():int
		{
			return _change;
		}
		
		/**
		 * 造化时没有装备，则隐藏装备的洗炼和造化加成属性
		 * @param show 是否显示洗炼属性
		 * 
		 */		
		public function showBapAttr(show:Boolean):void
		{
			_lbBapAttr.visible = _lbEnhance.visible = show;
		}
		
		private function onLockClick(e:MouseEvent):void
		{
			var tlock:Boolean = !_lock;
			if(!tlock)
			{
				dispatchEvent(new FuranceEvent(FuranceEvent.FORTUNE_PILLAR_UNLOCK));
			}
			_eqType && EquipFortuneLockSocketHanlder.sendFortuneLock(_eqType , _type, tlock?0:1);
		}
		
		//更改造化装备类型
		private function onFortuneEqChange(e:FuranceEvent):void
		{
			_eqType = e.data.eqType;
		}
		
		private function get furnaceInfo():FurnaceInfo
		{
			return FurnaceFacade.getInstance(String(ModuleType.FURNACE)).furnaceModule.furnaceInfo;
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