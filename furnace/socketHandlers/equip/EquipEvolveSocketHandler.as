package xdmh.furnace.socketHandlers.equip
{
	import xdmh.core.data.GlobalAPI;
	import xdmh.core.data.ProtocolType;
	import xdmh.core.socketHandlers.BaseSocketHandler;
	import xdmh.core.utils.SceneUtils;
	import xdmh.furnace.FurnaceModule;
	import xdmh.interfaces.socket.IPackageOut;
	
	/**
	 * 装备进阶请求 13110 C->S
	   uint64:装备ID
	   -------------------------
	   装备进阶响应 13111 S->C
	   uint64:装备ID
	   int32: 装备品质
	 */ 
	public class EquipEvolveSocketHandler extends BaseSocketHandler
	{
		public function EquipEvolveSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.EQUIP_EVOLVE_SC; 
		}
		
		override public function handlePackage():void
		{
			var equipId1:uint = _data.readUnsignedInt();
			var equipId2:uint = _data.readUnsignedInt();
			var equipId:String = equipId1+"_"+equipId2;
			var quality:int = _data.readInt();
			furnaceModule.furnaceInfo.updateEquipAttr({"equipId":equipId,"quality":quality});
			super.handComplete();
		}
		
		static public function sendEquipEvolve(equipId:String):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.EQUIP_EVOLVE_CS);
			pkg.writeUnsignedInt(SceneUtils.getID1(equipId));
			pkg.writeUnsignedInt(SceneUtils.getID2(equipId));
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get furnaceModule():FurnaceModule
		{
			return _handlerData as FurnaceModule;
		}
	}
}