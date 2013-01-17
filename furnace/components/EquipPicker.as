package xdmh.furnace.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import mhqy.ui.backgroundUtil.BackgroundInfo;
	import mhqy.ui.backgroundUtil.BackgroundType;
	import mhqy.ui.backgroundUtil.BackgroundUtils;
	import mhqy.ui.button.MAssetButton;
	import mhqy.ui.container.MTile;
	import mhqy.ui.label.MAssetLabel;
	import mhqy.ui.mcache.cells.CellCaches;
	import mhqy.ui.page.PageEvent;
	import mhqy.ui.page.PageView;
	
	import xdmh.core.data.GlobalData;
	import xdmh.core.data.bag.BagInfoUpdateEvent;
	import xdmh.core.data.fontFormat.FontFormatTemplateList;
	import xdmh.core.data.item.ItemInfo;
	import xdmh.core.data.module.ModuleType;
	import xdmh.furnace.FurnaceFacade;
	import xdmh.furnace.components.cell.LQCell;
	import xdmh.furnace.data.FurnaceInfo;
	import xdmh.interfaces.moviewrapper.IMovieWrapper;
	import xdmh.ui.bagSeletedYellowOutLine;
	
	public class EquipPicker extends Sprite
	{
		private static const _WIDTH:int = 150;
		private static const _HEIGHT:int = 442;
		private static const _PAGE_SIZE:int = 21;

		private var _cellList:Array;
		private var _eqList:Array;
		private var _currCell:LQCell;
		private var _label:MAssetLabel;
		private var _bg:IMovieWrapper;
		private var _selectedBg:Bitmap;
		private var _hoverBg:Bitmap;
		private var _tile:MTile;
		private var _pager:PageView;
		
		public function EquipPicker()
		{
			init();
		}
		
		private function init():void
		{			
			//背景
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.GRAY_BORDER_BG,new Rectangle(0, 0, _WIDTH, _HEIGHT)),
				new BackgroundInfo(BackgroundType.P_TITLE_BG,new Rectangle(1, 2, _WIDTH-2, 30)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5, 38, _WIDTH-10, 48),new Bitmap(CellCaches.getEquipBgPanel2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5, 86, _WIDTH-10, 48),new Bitmap(CellCaches.getEquipBgPanel2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5, 134, _WIDTH-10, 48),new Bitmap(CellCaches.getEquipBgPanel2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5, 182, _WIDTH-10, 48),new Bitmap(CellCaches.getEquipBgPanel2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5, 230, _WIDTH-10, 48),new Bitmap(CellCaches.getEquipBgPanel2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5, 278, _WIDTH-10, 48),new Bitmap(CellCaches.getEquipBgPanel2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5, 326, _WIDTH-10, 48),new Bitmap(CellCaches.getEquipBgPanel2())),
				new BackgroundInfo(BackgroundType.SPLIT_BOLD,new Rectangle(4,382,_WIDTH-8, 2))
			]);
			addChild(_bg as DisplayObject);
			
			//标题
			_label = new MAssetLabel("装备",FontFormatTemplateList.getFormatById(1012));
			_label.move(59,4);
			addChild(_label);
			
			//排版
			_tile = new MTile(46,48,3);
			_tile.itemGapW = 0;
			_tile.itemGapH = 0;
			_tile.setSize(138,336);
			_tile.move(6,38);
			_tile.verticalScrollPolicy = ScrollPolicy.OFF;
			_tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			addChild(_tile);
			
			//器灵格子
			_cellList = [];
			for(var i:int = 0; i < _PAGE_SIZE; i++)
			{
				var cell:LQCell = new LQCell(null,null,true);
				_tile.appendItem(cell);
				_cellList.push(cell);
			}
			
			//选中背景
			_selectedBg = new Bitmap(new bagSeletedYellowOutLine());
			_selectedBg.visible = false;
			addChild(_selectedBg);
			
			_hoverBg = new Bitmap(new bagSeletedYellowOutLine());
			_hoverBg.visible = false;
			addChild(_hoverBg);
			
			//分页
			_eqList = GlobalData.bagInfo.getAllEquip();
			_pager = new PageView(_PAGE_SIZE);
			_pager.totalRecord = _eqList.length;
			_pager.move(23,400);
			addChild(_pager); 
			
			initEvent();
			
			//初始状态，选中第一页第一个装备
			getPagedData();
		}
		
		private function updateCell(list:Array):void
		{
			clearCell();
			for(var i:int = 0, n:int = list.length; i < n; i++)
			{
				_cellList[i].itemInfo = list[i];
			}
		}
		
		private function clearCell():void
		{
			for(var i:int = 0; i < _PAGE_SIZE; i++)
			{
				_cellList[i].itemInfo = null;
			}
		}
		
		private function initEvent():void
		{
			for(var i:int = 0;i < _PAGE_SIZE ;i++)
			{
				_cellList[i].addEventListener(MouseEvent.CLICK, eqClickHandler);
				_cellList[i].addEventListener(MouseEvent.MOUSE_OVER, eqMoveInHandler);
				_cellList[i].addEventListener(MouseEvent.MOUSE_OUT, eqMoveOutHandler);
			}
			_pager.addEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
			GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.EQUIP_LIST_UPDATE,eqListUpdateHandler);
		}
		
		private function removeEvent():void
		{
			for(var i:int = 0;i < _PAGE_SIZE ;i++)
			{
				_cellList[i].removeEventListener(MouseEvent.CLICK, eqClickHandler);
				_cellList[i].removeEventListener(MouseEvent.MOUSE_OVER, eqMoveInHandler);
				_cellList[i].removeEventListener(MouseEvent.MOUSE_OUT, eqMoveOutHandler);
			}
			_pager.removeEventListener(PageEvent.PAGE_CHANGE,pageChangeHandler);
			GlobalData.bagInfo.removeEventListener(BagInfoUpdateEvent.EQUIP_LIST_UPDATE,eqListUpdateHandler);
		}
		
		private function eqListUpdateHandler(e:BagInfoUpdateEvent):void
		{
			_eqList = GlobalData.bagInfo.getAllEquip();
			_pager.totalRecord = _eqList.length;
			getPagedData(_pager.currentPage);
		}
		
		private function eqClickHandler(e:MouseEvent):void
		{
			_currCell = LQCell(e ? e.currentTarget : _cellList[0]);
			if(_currCell.itemInfo)
			{
				selected = _currCell;
				furnaceInfo.equipSelected({"selectedEquip":_currCell.itemInfo});
			}
		}
		
		private function eqMoveInHandler(e:MouseEvent):void
		{
			_currCell = LQCell(e.currentTarget);
			if(_currCell.itemInfo)
			{
				hover = _currCell;
			}
		}
		
		private function eqMoveOutHandler(e:MouseEvent):void
		{
			_hoverBg.visible = false;
			Mouse.cursor =  MouseCursor.AUTO;
		}
		
		private function pageChangeHandler(e:PageEvent):void
		{
			getPagedData(e.currentPage);
			eqClickHandler(null);
		}
		
		private function getPagedData(pageIdx:int = 1):void
		{
			var start:int = (pageIdx - 1) * _pager.pageSize;
			var end:int = pageIdx * _pager.pageSize;
			eqList = _eqList.slice(start, end);
		}
		
		private function set eqList(list:Array):void
		{
			updateCell(list);
		}
		
		private function set selected(currCell:LQCell):void
		{
			_selectedBg.x = currCell.x + 7;
			_selectedBg.y = currCell.y + 38;
			_selectedBg.visible = true;
			Mouse.cursor =  MouseCursor.BUTTON;
		}
		
		private function set hover(currCell:LQCell):void
		{
			_hoverBg.x = currCell.x + 7;
			_hoverBg.y = currCell.y + 38;
			_hoverBg.visible = true;
			Mouse.cursor =  MouseCursor.BUTTON;
		}
		
		private function get furnaceInfo():FurnaceInfo
		{
			return FurnaceFacade.getInstance(ModuleType.FURNACE.toString()).furnaceModule.furnaceInfo;
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_selectedBg && _selectedBg.parent)
			{
				_selectedBg.parent.removeChild(_selectedBg);
				_selectedBg.bitmapData.dispose();
				_selectedBg.bitmapData = null;
				_selectedBg = null;
			}
			if(_hoverBg && _hoverBg.parent)
			{
				_hoverBg.parent.removeChild(_hoverBg);
				if(_hoverBg.bitmapData)
				{
					_hoverBg.bitmapData.dispose();
					_hoverBg.bitmapData = null;
				}
				_hoverBg = null;
			}
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			if(_label)
			{
				_label = null;
			}
			if(_pager)
			{
				_pager.dispose();
				_pager = null;
			}
			if(_eqList)
			{
				_eqList.length = 0;
			}
			if(_cellList)
			{
				_cellList.length = 0;
			}
		}
	}
}