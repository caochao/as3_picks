package xdmh.furnace.components.cell
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import mhqy.ui.mcache.cells.CellCaches;
	
	import xdmh.constData.SourceClearType;
	import xdmh.core.data.GlobalAPI;
	import xdmh.core.data.furnace.equip.EquipQuality;
	import xdmh.core.view.cell.BaseCompareItemInfoCell;
	import xdmh.interfaces.character.ILayerInfo;
	import xdmh.ui.blueOutLineBgAsset;
	import xdmh.ui.goldOutLineBgAsset;
	import xdmh.ui.greenOutLineBgAsset;
	import xdmh.ui.purpleOutLineBgAsset;
	import xdmh.ui.whiteOutLineBgAsset;
	
	public class LQBigCell extends BaseCompareItemInfoCell
	{
		public function LQBigCell(info:ILayerInfo=null, showLoading:Boolean=true, autoDisposeLoader:Boolean=true, fillBg:int=-1)
		{
			super();
		}
		
		override protected function initChildren():void
		{
			super.initChildren();
		}
		
		override protected function initFigureBound():void
		{
			_figureBound = new Rectangle(0,0,72,72);
		}
		
		override protected function createContent():void
		{
			_picPath = GlobalAPI.pathManager.getPicPath(_info.iconPath, "bigitem");
			GlobalAPI.loaderAPI.getPicFile(_picPath,createPicComplete,SourceClearType.CHANGESCENE_AND_TIME);		
		}
		
		override protected function getQualityOutline(quality:int):BitmapData
		{
			switch(quality)
			{
				case EquipQuality.WHITE:
					return new whiteOutLineBgAsset();
					break;
				case EquipQuality.BLUE:
					return new blueOutLineBgAsset();
					break;
				case EquipQuality.PURPLE:
					return new purpleOutLineBgAsset();
					break;
				case EquipQuality.GOLD:
					return new goldOutLineBgAsset();
					break;
				default:
					return new greenOutLineBgAsset();
					break;
			}
		}
	}
}