package xdmh.furnace.components.cell
{
	import flash.display.Bitmap;
	
	import mhqy.ui.mcache.cells.CellCaches;

	/**
	 *带背包背景的格子
	 * @author caochao
	 * 
	 */	
	public class LQbgCell extends LQCell
	{
		private var cellBg:Bitmap;
		
		public function LQbgCell(clickHandler:Function=null, doubleClickHandler:Function=null)
		{
			super(clickHandler, doubleClickHandler);
		}
		
		override protected function initChildren():void
		{
			cellBg = new Bitmap(CellCaches.getCellBg1());
			addChild(cellBg);
			super.initChildren();
		}
	}
}