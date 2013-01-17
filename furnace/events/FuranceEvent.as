package xdmh.furnace.events
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class FuranceEvent extends Event
	{
		public var data:Object;
		public static var CELL_QUALITY_UPDATE:String = "cellQualityUpdate";
		public static var CELL_QUALITY_ADD:String = "cellQualityAdd";
		public static var CELL_QUALITY_DELETE:String = "cellQualityDelete";
		
		public static var CELL_ALL_CLEAR:String = "cellAllClear";
		public static var CELL_MIDDLE_CLEAR:String = "cellMiddleClear";
		public static var CELL_CLICK:String = "cellClick";
		public static var CELL_PUTAGAIN:String = "cellPutAgain";
		
		public static var CELL_MATERIAL_UPDATE:String = "cellMaterialUpdate";
		public static var CELL_MATERIAL_ADD:String = "cellMaterialAdd";
		public static var CELL_MATERIAL_DELETE:String = "cellMaterialDelete";
		
		public static var CELL_QUICKBUY_INITIAL:String = "cellQuickBuyInitial";
		
		public static var FURANCE_CELL_UPDATE:String = "furanceCellUpdate";
		
		public static var ITEMINFO_CELL_UPDATE:String = "itemInfoCellUpdate";
		
		public static var CELL_EQUIP_UPDATE:String = "cellEquipUpdate";
		
		//装备洗炼、强化、进阶后属性更新事件
		public static var EQUIP_ATTR_UPDATE:String = "equipAttrUpdate";
		
		//EquipPicker装备选中事件
		public static var EQUIP_SELECTED:String = "equipSelected";
		
		//造化与附灵界面选中武器类型选中事件
		public static var EQUIP_TYPE_SELECTED:String = "equipTypeSelected";
		
		//造化柱开锁事件
		public static var FORTUNE_PILLAR_UNLOCK:String = "fortunePillarUnlock";
		
		//洗炼属性锁定事件
		public static var BAPTIZE_ATTR_LOCK:String = "baptizeAttrLock";
		
		public function FuranceEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data =obj;
			super(type, bubbles, cancelable);
		}
	}
}