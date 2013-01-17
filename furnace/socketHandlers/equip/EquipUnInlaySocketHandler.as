package xdmh.furnace.socketHandlers.equip
{
	import xdmh.core.data.GlobalAPI;
	import xdmh.core.data.ProtocolType;
	import xdmh.core.socketHandlers.BaseSocketHandler;
	import xdmh.core.socketHandlers.furnace.EquipPearlInfoReSocketHandler;
	import xdmh.furnace.FurnaceModule;
	import xdmh.interfaces.socket.IPackageOut;
	
	/**灵珠摘除 13144 S->C
	   int32: 装备部位
	   uint32: 原型ID
	   int32: 位置,1~3
	   ----------------------------------------------
	   灵珠摘除响应 13145 C-> 
	   int32: 失败０，成功１
	 */ 
	public class EquipUnInlaySocketHandler extends BaseSocketHandler
	{
		public function EquipUnInlaySocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.EQUIP_PEARL_REMOVE_SC;
		}
		
		override public function handlePackage():void
		{
			var status:int = _data.readInt();
			
			if(status)
			{
				//更新装备附灵信息
				EquipPearlInfoReSocketHandler.sendEquipPearlInfoRe();
			}
			
			super.handComplete();
		}
		
		/**
		 * 发送装备镶嵌（附灵）请求
		 * @param eqType 装备部位
		 * @param templateId 原型Id
		 * @param pos 位置（1~3）
		 */ 
		public static function sendEquipUnInlay(eqType:int, templateId:uint, pos:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.EQUIP_PEARL_REMOVE_CS);
			pkg.writeInt(eqType);
			pkg.writeUnsignedInt(templateId);
			pkg.writeInt(pos);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get furnaceModule():FurnaceModule
		{
			return _handlerData as FurnaceModule;
		} 
	}
}