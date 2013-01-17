package xdmh.furnace.socketHandlers.equip
{
	import xdmh.core.data.GlobalAPI;
	import xdmh.core.data.GlobalData;
	import xdmh.core.data.ProtocolType;
	import xdmh.core.data.furnace.equip.PearlAttr;
	import xdmh.core.data.furnace.equip.PearlData;
	import xdmh.core.socketHandlers.BaseSocketHandler;
	import xdmh.core.socketHandlers.furnace.EquipPearlInfoReSocketHandler;
	import xdmh.core.utils.SceneUtils;
	import xdmh.furnace.FurnaceModule;
	import xdmh.interfaces.socket.IPackageOut;
	
	/**
		镶嵌（附灵） 13142 C->S
		int32: 装备部位
		uint32: 原型ID
		int32: 位置,1~3
	  --------------------------
	    响应 13143 S->C
	     int32: 装备部位
	     uint32: 原型ID
	     int32: 属性类型
	     int32: 属性值 
	     int32: 位置,1~3 
	 */ 
	public class EquipInlaySocketHandler extends BaseSocketHandler
	{
		public function EquipInlaySocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.EQUIP_PEARL_INLAY_SC;
		}
		
		override public function handlePackage():void
		{
			var eqType:int = _data.readInt();
			var tid:uint = _data.readUnsignedInt();
			var attrT:int = _data.readInt();
			var attrV:int = _data.readInt();
			var pos:int = _data.readInt();
			
			//更新装备附灵信息
			var attr:PearlAttr = new PearlAttr(tid,attrT,attrV,pos);

			//furnaceModule.furnaceInfo.updateEquipAttr({"eqType":eqType,"inlayData":attr});
			
			//更新装备附灵信息
			EquipPearlInfoReSocketHandler.sendEquipPearlInfoRe();
			
			super.handComplete();
		}
		
		/**
		 * 发送装备镶嵌（附灵）请求
		 * @param eqType 装备部位
		 * @param templateId 原型Id
		 * @param pos 位置（1~3）
		 */ 
		public static function sendEquipInlay(eqType:int, templateId:uint, pos:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.EQUIP_PEARL_INLAY_CS);
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