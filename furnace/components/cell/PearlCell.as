package xdmh.furnace.components.cell
{
	import flash.display.BitmapData;
	
	import mhqy.ui.label.MAssetLabel;
	
	import xdmh.constData.DragActionType;
	import xdmh.core.data.GlobalData;
	import xdmh.core.data.furnace.equip.PearlInlayType;
	import xdmh.core.data.furnace.equip.YqsInfoUpdateEvent;
	import xdmh.core.view.cell.CellType;
	import xdmh.interfaces.drag.IAcceptDrag;
	import xdmh.interfaces.drag.IDragData;
	import xdmh.interfaces.drag.IDragable;

	/**
	 * 装备附灵，存放灵珠的格子
	 */ 
	public class PearlCell extends LQbgCell implements IAcceptDrag
	{
		private var _pos:int;					//灵珠格子位置
		private var _count:int;				//堆叠物品数量
		private var _lblCount:MAssetLabel;		//计数文本域
		
		/**
		 * @param pos 位置，起始值为1
		 */ 
		public function PearlCell(pos:int, clickHandler:Function=null, doubleClickHandler:Function=null)
		{
			_pos = pos;
			super(clickHandler, doubleClickHandler);
		}
		
		public function get count():int
		{
			return _count;
		}
		
		public function set count(value:int):void
		{
			if(_count == value) return;
			_count = value > 99 ? 99 : value;
			_lblCount.setValue(_count.toString());
		}
		
		override protected function createPicComplete(value:BitmapData):void
		{
			super.createPicComplete(value);
			
			_lblCount = new MAssetLabel("",MAssetLabel.LABELTYPE3);
			count = itemInfo.count;
			_lblCount.move(3,3);
			addChild(_lblCount);
		}
		
		//IAcceptDrag接口方法
		override public function dragDrop(data:IDragData):int
		{
			var action:int = DragActionType.UNDRAG;
			var source:IDragable = data.dragSource;
			if(!source || source.getSourceType() != CellType.INLAYCELL)
			{
				action = DragActionType.UNDRAG;
			}
			else if(source==this || source.getSourceType() == CellType.PEARLCELL )
			{
				action = DragActionType.ONSELF;
			}
			else if(!source.getSourceData())
			{
				action = DragActionType.UNDRAG;
			}
			else
			{
				action = DragActionType.DRAGIN;
				var obj:Object = {"action": PearlInlayType.REMOVE,"itemInfo":data.dragSource.getSourceData(),"pos":InlayCell(source).pos };
				GlobalData.pearlList.dispatchEvent(new YqsInfoUpdateEvent(YqsInfoUpdateEvent.YQS_CELL_MOVE,obj));
			}
			return action;
		}
		
		//IDragable接口方法
		override public function dragStop(data:IDragData):void
		{
			if(data.action==DragActionType.UNDRAG || data.action==DragActionType.ONSELF) return;
		}
		
		override public function getSourceType():int
		{
			return CellType.PEARLCELL;
		}
		
		override public function getSourceData():Object
		{
			return itemInfo;
		}
	}
}