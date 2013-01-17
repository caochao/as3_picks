package xdmh.furnace.components.cell
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.text.TextFieldAutoSize;
	
	import mhqy.ui.label.MAssetLabel;
	import mhqy.ui.label.MAssetLabelPair;
	import mhqy.ui.mcache.cells.CellCaches;
	
	import xdmh.core.data.GlobalData;
	import xdmh.core.data.fontFormat.FontFormatTemplateList;
	import xdmh.core.data.item.ItemInfo;
	import xdmh.core.data.item.ItemTemplateInfo;
	import xdmh.core.data.item.ItemTemplateList;
	import xdmh.core.utils.ColorUtils;

	/**
	 * 装备系统材料格子
	 * 显示方式为“当前数量/需要数量”
	 */	
	public class LQMaterialCell extends LQCell
	{
		private var _templateId:int;
		private var _currCount:int;				//当前数量
		private var _needCount:int;				//需要数量
		private var _poorFormat:Array;				//材料不足字体颜色
		private var _enoughFormat:Array;			//材料充足字体颜色
		
		private var _lbTip:MAssetLabel;			//"材料"
		private var _lbCurrCount:MAssetLabel;		//"当前数量"
		private var _lbNeedCount:MAssetLabel;		//"/需要数量"
		
		public function LQMaterialCell(clickHandler:Function=null, doubleClickHandler:Function=null, bgWord:String = "材料")
		{
			super(clickHandler, doubleClickHandler);
			
			//材料
			_lbTip = new MAssetLabel(bgWord, FontFormatTemplateList.getFormatById(1016));
			if(bgWord.length >= 4)
			{
				_lbTip.multiline = true;
				_lbTip.wordWrap = true;
				_lbTip.width = 30;
			}
			_lbTip.move((width - _lbTip.width)/2+1, (height - _lbTip.height)/2);
			addChild(_lbTip);
			
			//字体
			_poorFormat = FontFormatTemplateList.getFormatById(1021);
			_enoughFormat = FontFormatTemplateList.getFormatById(16);
			
			//当前数量/需要数量
			_lbCurrCount = new MAssetLabel("",_enoughFormat,TextFieldAutoSize.CENTER);
			addChild(_lbCurrCount);
			_lbCurrCount.visible = false;
			
			_lbNeedCount = new MAssetLabel("",_enoughFormat,TextFieldAutoSize.LEFT);
			addChild(_lbNeedCount);
			_lbNeedCount.visible = false;
			
			reDraw();
		}
		
		override public function set itemInfo(value:ItemInfo):void
		{
			super.itemInfo = value;
			if(value)
			{
				_lbTip.visible = false;	
				countLabelVisible = true;
				_templateId = value.templateId;
				currCount = GlobalData.bagInfo.getItemCountById(_templateId);
			}
			else
			{
				//若格子之前有物品，则数量为0时照样显示物品icon
				if(_templateId && GlobalData.bagInfo.getItemCountById(_templateId) == 0)
				{
					info = ItemTemplateList.getTemplate(_templateId);
					_lbTip.visible = false;	
					countLabelVisible = true;
				}
				else
				{
					_lbTip.visible = true;
					countLabelVisible = false;
				}
				currCount = 0;
			}
		}
		
		override protected function createPicComplete(value:BitmapData):void
		{
			super.createPicComplete(value);
			setChildIndex(_lbCurrCount, getChildIndex(_pic));
			setChildIndex(_lbNeedCount, getChildIndex(_lbCurrCount));
		}
		
		public function get currCount():int
		{
			return _currCount;
		}
		
		public function get needCount():int
		{
			return _needCount;
		}
		
		private function set countLabelVisible(value:Boolean):void
		{
			_lbCurrCount.visible = value;
			_lbNeedCount.visible = value;
		}
		
		/**
		 * 设置材料当前数量
		 * @param value
		 */		
		public function set currCount(value:int):void
		{
			if(_currCount == value) return;
			_currCount = value;
			_lbCurrCount.setValue(_currCount.toString());
			reDraw();
		}
		
		/**
		 * 设置材料需求量 
		 * @param value
		 */		
		public function set needCount(value:int):void
		{
			//if(_needCount == value) return;
			_needCount = value;
			_lbNeedCount.setValue("/"+_needCount.toString());
			reDraw();
		}
		
		public function get isPoor():Boolean
		{
			return _currCount < _needCount;
		}
		
		public function setGray():void
		{
			ColorUtils.setGray(this);
		}
		
		//显示强化，进阶到最高阶状态
		public function showTopState():void
		{
			if(info == null && _templateId)
			{
				info = ItemTemplateList.getTemplate(_templateId);
			}
			this.setGray();
			countLabelVisible = false;
		}
		
		public function forceClear():void
		{
			info = null;
			_lbTip.visible = true;
			countLabelVisible = false;
		}
		
		private function reDraw():void
		{
			var _x:int = (this.width - _lbCurrCount.width - _lbNeedCount.width)/2;
			var _y:int = 26;
			var _x2:int = _x + _lbCurrCount.width;
			_lbCurrCount.move(_x, _y);
			_lbNeedCount.move(_x2, _y);
			_lbCurrCount.setLabelType(getFormat());
		}
		
		private function getFormat():Array
		{
			return _currCount >= _needCount ? _enoughFormat : _poorFormat;
		}
	}
}