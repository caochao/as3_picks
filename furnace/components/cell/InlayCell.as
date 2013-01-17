package xdmh.furnace.components.cell
{
	import xdmh.constData.DragActionType;
	import xdmh.core.data.GlobalData;
	import xdmh.core.data.furnace.equip.PearlInlayType;
	import xdmh.core.data.furnace.equip.YqsInfoUpdateEvent;
	import xdmh.core.view.cell.CellType;
	import xdmh.interfaces.drag.IAcceptDrag;
	import xdmh.interfaces.drag.IDragData;
	import xdmh.interfaces.drag.IDragable;

	/**
	 * 装备附灵，可镶嵌灵珠的格子
	 */ 
	public class InlayCell extends LQCell implements IAcceptDrag
	{
		private var _pos:int; 			//镶嵌格子
		
		/**
		 * @param pos 位置，起始值为1
		 */ 
		public function InlayCell(pos:int, clickHandler:Function=null, doubleClickHandler:Function=null)
		{
			_pos = pos;
			super(clickHandler, doubleClickHandler);
		}
		
		public function get pos():int
		{
			return _pos;
		}
		
		//IAcceptDrag接口方法
		override public function dragDrop(data:IDragData):int
		{
			var action:int = DragActionType.UNDRAG;
			var source:IDragable = data.dragSource;
			if(!source || source.getSourceType() != CellType.PEARLCELL)
			{
				action = DragActionType.UNDRAG;
			}
			else if(source==this || source.getSourceType() == CellType.INLAYCELL )
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
				var obj:Object = {"action": PearlInlayType.INLAY,"itemInfo":data.dragSource.getSourceData(),"pos":_pos};
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
			return CellType.INLAYCELL;
		}
		
		override public function getSourceData():Object
		{
			return itemInfo;
		}
	}
}