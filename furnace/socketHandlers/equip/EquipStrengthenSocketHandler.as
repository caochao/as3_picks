package xdmh.furnace.socketHandlers.equip
{
	import xdmh.core.data.GlobalAPI;
	import xdmh.core.data.GlobalData;
	import xdmh.core.data.ProtocolType;
	import xdmh.core.data.furnace.equip.StrengthenData;
	import xdmh.core.socketHandlers.BaseSocketHandler;
	import xdmh.core.socketHandlers.login.RoleDetailSocketHandler;
	import xdmh.core.utils.SceneUtils;
	import xdmh.furnace.FurnaceModule;
	import xdmh.interfaces.socket.IPackageOut;
	
	/**
	 ** 装备强化请求 13100 C->S
		uint64: 装备ID
		int32:完美玉符类型。0表示未使用，大于0表示类型
	   -----------------------------------------------------
		装备强化响应 13101 S->C
		uint64: 装备ID
		int32: 0强化等级不变，1升级 
		int32: 全身强化等级变化时，为全身强化等级，否则为0
	 */ 
	public class EquipStrengthenSocketHandler extends BaseSocketHandler
	{
		public function EquipStrengthenSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.EQUIP_STRENGTHEN_SC;
		}
		
		override public function handlePackage():void
		{
			var equipId1:uint = _data.readUnsignedInt();
			var equipId2:uint = _data.readUnsignedInt();
			var equipId:String = equipId1+"_"+equipId2;
			var lvUp:Boolean = _data.readInt() == 1;
			var fullStrengLv:int = _data.readInt();
			GlobalData.selfPlayer.fullStrengLv = fullStrengLv;
			
			furnaceModule.furnaceInfo.updateEquipAttr({"equipId":equipId, "lvUp":lvUp, "fullStrengLv":fullStrengLv});
			super.handComplete();
		}
		
		/**
		 * 发送装备强化请求
		 * @param equipId 装备id
		 * @param perfect 完美玉符类型。(0表示未使用，大于0表示类型)
		 */ 
		static public function sendEquipStrengthen(equipId:String,perfect:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.EQUIP_STRENGTHEN_CS);
			pkg.writeUnsignedInt(SceneUtils.getID1(equipId));
			pkg.writeUnsignedInt(SceneUtils.getID2(equipId));
			pkg.writeInt(perfect);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get furnaceModule():FurnaceModule
		{
			return _handlerData as FurnaceModule;
		}
	}
}