package xdmh.furnace.socketHandlers.equip
{
	import xdmh.core.data.GlobalAPI;
	import xdmh.core.data.ProtocolType;
	import xdmh.core.data.furnace.equip.BaptizeData;
	import xdmh.core.socketHandlers.BaseSocketHandler;
	import xdmh.core.utils.SceneUtils;
	import xdmh.furnace.FurnaceModule;
	import xdmh.interfaces.socket.IPackageOut;
	 
	/**
	 *  装备洗炼协议
		PP_EQUIPMENT_BAPTIZE_RE 13104　C->S
		uint64: 装备ID
    	int16: 数组长度，表示锁住的属性条数
    		int32: 序号(取值范围1~6)
		----------------------------------
		PP_EQUIPMENT_BAPTIZE_ACK 13105 S->C
		uint64: 装备ID
		int16: 数组长度,表示洗练后属性条数, 失败时为0
			int32: 属性类型，攻、防...
			int32: 属性值
			int32：星级
		int32:洗炼星级
	 */
	public class EquipBaptizeSocketHandler extends BaseSocketHandler
	{
		public function EquipBaptizeSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.EQUIP_BAPTIZE_SC;
		}
		
		override public function handlePackage():void
		{
			var equipId1:uint = _data.readUnsignedInt();
			var equipId2:uint = _data.readUnsignedInt();
			var equipId:String = equipId1+"_"+equipId2;
			var attrCount:int = _data.readShort();
			var attrList:Array = [];
			for(var i:int=0; i<attrCount; i++)
			{
				var type:int = _data.readInt();
				var value:int = _data.readInt();
				var star:int = _data.readInt();
				var attr:BaptizeData = new BaptizeData(type,value,star);
				attrList.push(attr);
			}
			var layer:int = _data.readInt();
			
			furnaceModule.furnaceInfo.updateEquipAttr({"equipId":equipId,"attrList":attrList,"layer":layer});
			super.handComplete();
		}
		
		/**
		 * 发送装备洗练请求
		 * @param equipId 装备id
		 * @param lockedAttr 锁定属性条（1-6）,无锁定属性时发送空数组长度
		 */ 
		static public function sendEquipBaptize(equipId:String,lockedAttr:Array):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.EQUIP_BAPTIZE_CS);
			pkg.writeUnsignedInt(SceneUtils.getID1(equipId));
			pkg.writeUnsignedInt(SceneUtils.getID2(equipId));
			
			var len:int = lockedAttr.length;
			pkg.writeShort(len);
			
			for(var i:int = 0; i<len; i++)
			{
				pkg.writeInt(lockedAttr[i]);
			}
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get furnaceModule():FurnaceModule
		{
			return _handlerData as FurnaceModule;
		}
	}
}