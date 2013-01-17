package xdmh.furnace.mediators
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import xdmh.core.data.GlobalAPI;
	import xdmh.core.utils.SetModuleUtils;
	import xdmh.furnace.FurnaceModule;
	import xdmh.furnace.components.LqPanel;
	import xdmh.furnace.events.FurnaceMediatorEvent;
	
	public class FurnaceMediator extends Mediator
	{
		public static const NAME:String = "FurnaceMediator";
		
		public function FurnaceMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				FurnaceMediatorEvent.FURNACE_MEDIATOR_START,
				FurnaceMediatorEvent.FURNACE_MEDIATOR_DISPOSE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case FurnaceMediatorEvent.FURNACE_MEDIATOR_START:
					initView();
					break;
				case FurnaceMediatorEvent.FURNACE_MEDIATOR_DISPOSE:
					dispose();
					break;
			}
		}
		
		private function initView():void
		{
			if(!furnaceModule.lqPanel)
			{
				furnaceModule.lqPanel = new LqPanel();
				furnaceModule.lqPanel.addEventListener(Event.CLOSE,furnaceCloseHandler);
				GlobalAPI.layerManager.addPanel(furnaceModule.lqPanel);
			}
		}
		
		private function furnaceCloseHandler(evt:Event):void
		{
			if(furnaceModule.lqPanel)
			{
				furnaceModule.lqPanel.removeEventListener(Event.CLOSE,furnaceCloseHandler);
				furnaceModule.lqPanel.dispose();
				furnaceModule.lqPanel = null;
				furnaceModule.dispose();
			}
		}
		
		public function get furnaceModule():FurnaceModule
		{
			return viewComponent as FurnaceModule;
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}