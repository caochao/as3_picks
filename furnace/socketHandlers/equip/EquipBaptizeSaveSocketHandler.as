package xdmh.furnace.socketHandlers.equip
{
	import xdmh.core.data.GlobalAPI;
	import xdmh.core.data.ProtocolType;
	import xdmh.core.socketHandlers.BaseSocketHandler;
	import xdmh.core.utils.SceneUtils;
	import xdmh.furnace.FurnaceModule;
	import xdmh.interfaces.socket.IPackageOut;
	
	/**
	 * 保存洗炼结果请求 13106 C->S
	   uint64: 装备ID 
	   ------------------------------------------------------	
	   保存洗炼结果响应 13107 S->C
	   uint64： 装备ID 
	   int32：0失败，1成功
	 */ 
	public class EquipBaptizeSaveSocketHandler extends BaseSocketHandler
	{
		public function EquipBaptizeSaveSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.EQUIP_BAPTIZE_SAVE_SC;
		}
		
		override public function handlePackage():void
		{
			var equipId1:uint = _data.readUnsignedInt();
			var equipId2:uint = _data.readUnsignedInt();
			var equipId:String = equipId1+"_"+equipId2;
			var status:int = _data.readInt();
			if(status)
			{
				furnaceModule.furnaceInfo.updateEquipAttr({"equipId":equipId,"status":status});
			}
			super.handComplete();
		}
		
		/**
		 * @param equipId 装备id
		 */ 
		public static function sendBaptizeSave(equipId:String):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.EQUIP_BAPTIZE_SAVE_CS);
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