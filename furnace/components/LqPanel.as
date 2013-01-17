package xdmh.furnace.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import mhqy.ui.backgroundUtil.BackgroundInfo;
	import mhqy.ui.backgroundUtil.BackgroundType;
	import mhqy.ui.backgroundUtil.BackgroundUtils;
	import mhqy.ui.container.MPanel;
	import mhqy.ui.mcache.bottom.MCacheBottom1;
	import mhqy.ui.mcache.titles.MCacheTitle1;
	import mhqy.ui.tab.BaseTabPanel;
	
	import xdmh.core.utils.AssetUtil;
	import xdmh.furnace.common.lianQiAsset;
	import xdmh.interfaces.moviewrapper.IMovieWrapper;
	import xdmh.ui.BorderAsset10;
	
	/**
	 * 炼器主面板
	 */ 
	public class LqPanel extends MPanel
	{
		private const _WIDTH:int = 600;
		private const _HEIGHT:int = 490;
		
		private var _lqTab:LqTabPanel;
		private var _eqPicker:EquipPicker;
		
		public function LqPanel()
		{
			super(new MCacheTitle1("",new Bitmap(new lianQiAsset())),true,-1,true,true);//面板底纹
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			setContentSize(_WIDTH,_HEIGHT);
			
			_lqTab=new LqTabPanel();
			addContent(_lqTab);
			
			_eqPicker = new EquipPicker();
			_eqPicker.move(10,40);
			addContent(_eqPicker);
		}
		
		public function get lqTab():LqTabPanel
		{
			return _lqTab;
		}
		
		override public function dispose():void
		{
			if(_eqPicker)
			{
				_eqPicker.dispose();
				_eqPicker = null;
			}
			if(_lqTab)
			{
				_lqTab.dispose();
				_lqTab = null;
			}
			super.dispose();
		}
	}
}