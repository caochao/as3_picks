package xdmh.furnace
{
	import xdmh.core.data.GlobalAPI;
	import xdmh.core.data.module.ModuleType;
	import xdmh.core.data.module.changeInfos.ToFurnaceData;
	import xdmh.core.module.BaseModule;
	import xdmh.furnace.components.LqPanel;
	import xdmh.furnace.data.FurnaceInfo;
	import xdmh.furnace.events.FurnaceMediatorEvent;
	import xdmh.furnace.socketHandlers.FurnaceSetSocketHandler;
	import xdmh.interfaces.module.IModule;
	
	public class FurnaceModule extends BaseModule
	{
		public var facade:FurnaceFacade; 
		public var lqPanel:LqPanel;		//炼器面板
		public var furnaceInfo:FurnaceInfo;
		public var toData:ToFurnaceData;
		
		override public function setup(prev:IModule, data:Object=null):void
		{
			super.setup(prev,data);
			toData = data as ToFurnaceData;
			furnaceInfo = new FurnaceInfo();
			FurnaceSetSocketHandler.addFurnaceSocketHandlers(this);
			facade = FurnaceFacade.getInstance(String(moduleId));
			facade.startup(this);
			configure(data);
		}
		
		override public function configure(data:Object):void
		{
			super.configure(data);
			var argIndex:int = (data as ToFurnaceData).selectIndex;
			if(lqPanel)
			{
				if(GlobalAPI.layerManager.getTopPanel() != lqPanel)
				{
					lqPanel.setToTop();
					lqPanel.lqTab.setIndex(argIndex);
				}
				else lqPanel.dispose();
			}
			else
			{
				facade.sendNotification(FurnaceMediatorEvent.FURNACE_MEDIATOR_START);
				lqPanel.lqTab.setIndex(argIndex);
			}
		}
		
		override public function get moduleId():int
		{
			return ModuleType.FURNACE;
		}
		
		override public function dispose():void
		{
			FurnaceSetSocketHandler.removeFurnaceSocketHandlers();
			if(lqPanel)
			{
				lqPanel.dispose();
				lqPanel = null;
			}
			if(facade)
			{
				facade.dispose();
				facade = null;
			}
			if(furnaceInfo)
			{
				furnaceInfo = null;
			}
			super.dispose();
		}
	}
}