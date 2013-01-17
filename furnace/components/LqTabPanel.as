package xdmh.furnace.components
{
	import flash.geom.Point;
	
	import mhqy.ui.mcache.btns.tabBtns.MCacheTab1Btn;
	import mhqy.ui.tab.BaseTabPanel;
	
	import xdmh.core.data.GlobalData;
	import xdmh.furnace.components.sld.baptize.EpBaptizePanel;
	import xdmh.furnace.components.sld.evolve.EpEvolvePanel;
	import xdmh.furnace.components.sld.inlay.EpInlayPanel;
	import xdmh.furnace.components.sld.strengthen.EpStrengthenPanel;
	import xdmh.furnace.components.sld.suiting.EpSuitingPanel;
	
	/**
	 * 炼器tab panel，包括神龙鼎和御器术面板
	 */ 
	public class LqTabPanel extends BaseTabPanel
	{
		public function LqTabPanel()
		{
			super();
		}
		
		override protected function initComponent():void
		{
			_tabBtnPos = [new Point(14,11), new Point(62,11), new Point(110,11), new Point(158,11),new Point(206,11)];
			_tabBtns=[new MCacheTab1Btn(0,0,"强化"),new MCacheTab1Btn(0, 0, "洗炼"),new MCacheTab1Btn(0,0,"进阶"),new MCacheTab1Btn(0,0,"套装"),new MCacheTab1Btn(0,0,"附灵")];
			_tabPanels=[EpStrengthenPanel, EpBaptizePanel, EpEvolvePanel, EpSuitingPanel, EpInlayPanel];
		}
	}
}