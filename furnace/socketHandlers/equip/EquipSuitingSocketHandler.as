package xdmh.furnace.socketHandlers.equip
{
	import xdmh.core.data.GlobalAPI;
	import xdmh.core.data.ProtocolType;
	import xdmh.core.socketHandlers.BaseSocketHandler;
	import xdmh.core.utils.SceneUtils;
	import xdmh.furnace.FurnaceModule;
	import xdmh.interfaces.socket.IPackageOut;
	
	/**
	 * 套装打造协议 13170 C->S
	   uint64: 装备ID
	   int32: 绿装类型(1~5表示金木...)
	  -------------------------------------
	   套装打造响应 13171 S->C
	   int32: 0成功，非0失败
	 */ 
	public class EquipSuitingSocketHandler extends BaseSocketHandler
	{
		private static var _equipId:String;
		public function EquipSuitingSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.EQUIP_SUITING_SC;
		}
		
		override public function handlePackage():void
		{
			var status:int = _data.readInt();
			if(status == 0)
			{
				furnaceModule.furnaceInfo.updateEquipAttr({"equipId":_equipId,"status":status});
			}
			super.handComplete();
		}
		
		/**
		 * @param equipId 装备id
		 * @param greenEqType 绿装类型（1~5表示金木..）
		 */ 
		public static function sendEquipSuiting(equipId:String, greenEqType:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.EQUIP_SUITING_CS);
			pkg.writeUnsignedInt(SceneUtils.getID1(equipId));
			pkg.writeUnsignedInt(SceneUtils.getID2(equipId));
			pkg.writeInt(greenEqType);
			GlobalAPI.socketManager.send(pkg);
			_equipId = equipId;
		}
		
		private function get furnaceModule():FurnaceModule
		{
			return _handlerData as FurnaceModule;
		}
	}
}