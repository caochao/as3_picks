package xdmh.furnace.data
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import xdmh.constData.CategoryType;
	import xdmh.core.data.GlobalData;
	import xdmh.core.data.bag.BagInfoUpdateEvent;
	import xdmh.core.data.bag.ClientBagInfoUpdateEvent;
	import xdmh.core.data.item.ItemInfo;
	import xdmh.furnace.events.FuranceEvent;
	
	public class FurnaceInfo extends EventDispatcher
	{
		public var lastEq:String;		//上次选中装备Id
		
		public function FurnaceInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/**
		 * 通知装备面板更新数据
		 */ 
		public function updateEquipAttr(data:Object):void
		{
			dispatchEvent(new FuranceEvent(FuranceEvent.EQUIP_ATTR_UPDATE,data));
		}
		
		/**
		 * 洗炼、强化、进阶时选中装备后触发
		 */ 
		public function equipSelected(data:Object):void
		{
			lastEq = data.selectedEquip.itemId;
			dispatchEvent(new FuranceEvent(FuranceEvent.EQUIP_SELECTED,data));
		}
		
		/**
		 * 造化与附灵装备类型选定事件
		 */ 
		public function eqTypeSelected(data:Object):void
		{
			dispatchEvent(new FuranceEvent(FuranceEvent.EQUIP_TYPE_SELECTED,data));
		}
	}
}