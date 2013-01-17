package xdmh.furnace.components.sld.inlay
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mhqy.ui.backgroundUtil.BackgroundInfo;
	import mhqy.ui.backgroundUtil.BackgroundType;
	import mhqy.ui.backgroundUtil.BackgroundUtils;
	import mhqy.ui.container.MTile;
	import mhqy.ui.mcache.cells.CellCaches;
	import mhqy.ui.page.PageEvent;
	import mhqy.ui.page.PageView;
	
	import xdmh.constData.CategoryType;
	import xdmh.core.data.GlobalAPI;
	import xdmh.core.data.GlobalData;
	import xdmh.core.data.bag.BagInfoUpdateEvent;
	import xdmh.core.data.furnace.equip.PearlInlayType;
	import xdmh.core.data.furnace.equip.YqsInfoUpdateEvent;
	import xdmh.core.data.item.ItemInfo;
	import xdmh.furnace.components.cell.PearlCell;
	import xdmh.furnace.socketHandlers.equip.EquipUnInlaySocketHandler;
	import xdmh.interfaces.moviewrapper.IMovieWrapper;
	
	/**
	 * 灵珠背包
	 */ 
	public class PearlBag extends Sprite
	{
		private const _PAGESIZE:int = 24;
		
		private var _cellList:Array;		//格子列表
		private var _pearlList:Array;		//灵珠列表
		
		private var _tile:MTile;
		private var _pager:PageView;
		private var _owner:EpInlayPanel;
		
		public function PearlBag(owner:EpInlayPanel)
		{
			_pearlList = GlobalData.bagInfo.getListByCategoryType(CategoryType.INLAY_PEARL);
			_cellList = [];
			_owner = owner;
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			//排版
			_tile = new MTile(40,40,4);
			_tile.setSize(168,252);
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			addChild(_tile);
			
			//6*4格子列表
			for(var i:int = 0; i<_PAGESIZE; i++)
			{
				var cell:PearlCell = new PearlCell(i+1);
				_tile.appendItem(cell);
				_cellList.push(cell);
			}
			
			//分页
			_pager = new PageView(25);
			_pager.totalRecord = _pearlList.length;
			_pager.move(41,262);
			addChild(_pager);
			
			//显示第一页数据
			pageChangeHandler(null);
		}
		
		private function initEvent():void
		{
			for each(var cell:PearlCell in _cellList)
			{
				cell.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			}
			_pager.addEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
			GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.ITEM_UPDATE,onBagUpdate);
			GlobalData.pearlList.addEventListener(YqsInfoUpdateEvent.YQS_CELL_MOVE,onCellMove);
		}
		
		private function removeEvent():void
		{
			for each(var cell:PearlCell in _cellList)
			{
				cell.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			}
			_pager.removeEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
			GlobalData.bagInfo.removeEventListener(BagInfoUpdateEvent.ITEM_UPDATE,onBagUpdate);
			GlobalData.pearlList.removeEventListener(YqsInfoUpdateEvent.YQS_CELL_MOVE,onCellMove);
		}
		
		//背包更新
		private function onBagUpdate(e:BagInfoUpdateEvent):void
		{
			_pearlList = GlobalData.bagInfo.getListByCategoryType(CategoryType.INLAY_PEARL);
			getPageData(_pager.currentPage);
		}
		
		//灵珠拖动
		private function onMouseDown(e:MouseEvent):void
		{
			var cell:PearlCell = e.currentTarget as PearlCell;
			if(cell.itemInfo)
			{
				GlobalAPI.dragManager.startDrag(cell);
			}
		}
		
		//灵珠摘除
		private function onCellMove(e:YqsInfoUpdateEvent):void
		{
			if(e.data.action == PearlInlayType.REMOVE)
			{
				//发送摘除灵珠协议
 				EquipUnInlaySocketHandler.sendEquipUnInlay(1, e.data.itemInfo.templateId, e.data.pos);
			}
		}
		
		private function pageChangeHandler(e:PageEvent):void
		{
			var idx:int = e ? e.currentPage : 1;
			getPageData(idx);
		}
		
		private function getPageData(pageIdx:int = 1):void
		{
			var start:int = (pageIdx-1) * _pager.pageSize;
			var end:int = pageIdx * _pager.pageSize;
			var data:Array = _pearlList.slice(start, end);
			updatePage(data);
		}
		
		private function updatePage(pageData:Array):void
		{
			clearCell();
			for(var i:int = 0, n:int = pageData.length; i<n; i++)
			{
				_cellList[i].itemInfo = pageData[i];
			}
		}
		
		private function clearCell():void
		{
			for each(var cell:PearlCell in _cellList)
			{
				cell.itemInfo = null;
			}
		}
		
		public function move(x:Number,y:Number):void
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