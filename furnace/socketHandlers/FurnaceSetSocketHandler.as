package xdmh.furnace.socketHandlers
{
	import xdmh.core.data.GlobalAPI;
	import xdmh.core.data.GlobalData;
	import xdmh.core.data.ProtocolType;
	import xdmh.core.socketHandlers.BaseSocketHandler;
	import xdmh.core.socketHandlers.furnace.EquipFortuneInfoInitSocketHandler;
	import xdmh.core.socketHandlers.furnace.EquipRepairSocketHandler;
	import xdmh.core.socketHandlers.furnace.EquipSmeltSocketHandler;
	import xdmh.furnace.FurnaceModule;
	import xdmh.furnace.socketHandlers.equip.EquipBaptizeSaveSocketHandler;
	import xdmh.furnace.socketHandlers.equip.EquipBaptizeSocketHandler;
	import xdmh.furnace.socketHandlers.equip.EquipEvolveSocketHandler;
	import xdmh.furnace.socketHandlers.equip.EquipFortuneLockSocketHanlder;
	import xdmh.furnace.socketHandlers.equip.EquipFortuneSocketHandler;
	import xdmh.furnace.socketHandlers.equip.EquipInlaySocketHandler;
	import xdmh.furnace.socketHandlers.equip.EquipStrengthenSocketHandler;
	import xdmh.furnace.socketHandlers.equip.EquipSuitingSocketHandler;
	import xdmh.furnace.socketHandlers.equip.EquipUnInlaySocketHandler;
	
	public class FurnaceSetSocketHandler extends BaseSocketHandler
	{
		public function FurnaceSetSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		public static function addFurnaceSocketHandlers(furnaceModule:FurnaceModule):void
		{
			//仙道新协议
			GlobalAPI.socketManager.addSocketHandler(new EquipBaptizeSocketHandler(furnaceModule));			//装备洗炼
			GlobalAPI.socketManager.addSocketHandler(new EquipBaptizeSaveSocketHandler(furnaceModule));		//保存洗炼结果
			GlobalAPI.socketManager.addSocketHandler(new EquipStrengthenSocketHandler(furnaceModule));		//装备强化
			GlobalAPI.socketManager.addSocketHandler(new EquipEvolveSocketHandler(furnaceModule));			//装备进阶
			GlobalAPI.socketManager.addSocketHandler(new EquipFortuneSocketHandler(furnaceModule));			//装备造化
			GlobalAPI.socketManager.addSocketHandler(new EquipFortuneLockSocketHanlder(furnaceModule));		//锁定、打通造化位置
			GlobalAPI.socketManager.addSocketHandler(new EquipInlaySocketHandler(furnaceModule));			//装备附灵
			GlobalAPI.socketManager.addSocketHandler(new EquipUnInlaySocketHandler(furnaceModule));			//灵珠摘除
			GlobalAPI.socketManager.addSocketHandler(new EquipSuitingSocketHandler(furnaceModule));			//套装打造
		}
		
		public static function removeFurnaceSocketHandlers():void
		{
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.EQUIP_BAPTIZE_SC );			//装备洗炼
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.EQUIP_BAPTIZE_SAVE_SC);		//保存洗炼结果
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.EQUIP_STRENGTHEN_SC);			//装备强化
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.EQUIP_EVOLVE_SC);				//装备进阶
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.EQUIP_FORTUNE_SC);				//装备造化
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.EQUIP_FORTUNE_LOCK_SC);		//锁定、打通造化位置
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.EQUIP_PEARL_INLAY_SC);			//装备附灵
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.EQUIP_PEARL_REMOVE_SC);		//灵珠摘除
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.EQUIP_SUITING_SC);				//套装打造
		}
	}
}