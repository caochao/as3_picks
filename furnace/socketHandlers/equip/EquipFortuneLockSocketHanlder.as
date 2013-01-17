package xdmh.furnace.socketHandlers.equip
{
	import xdmh.core.data.GlobalAPI;
	import xdmh.core.data.ProtocolType;
	import xdmh.core.socketHandlers.BaseSocketHandler;
	import xdmh.core.utils.SceneUtils;
	import xdmh.furnace.FurnaceModule;
	import xdmh.interfaces.socket.IPackageOut;
	import xdmh.core.socketHandlers.furnace.EquipFortuneInfoInitSocketHandler;
	
	/**
	 *  打通或锁定造化位置 13132 C->S
	    int32:装备部位
		int32:造化位置
		int32:0->锁定造化位置,1->打通造化位置
		----------------------------
		打通或锁定造化位置响应 13133 S->C
		int32:装备部位
		int32:造化位置
		int32:造化加成值(百分比)
		int32：是否锁定，0->锁定，1->未锁定
	 */ 
	public class EquipFortuneLockSocketHanlder extends BaseSocketHandler
	{
		public function EquipFortuneLockSocketHanlder(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.EQUIP_FORTUNE_LOCK_SC;
		}
		
		override public function handlePackage():void
		{
			var eqType:uint = _data.readInt();
			var pos:int = _data.readInt();
			var val:int = _data.readInt();
			var lock:int = _data.readInt();
			var data:Object = {"eqType":eqType,"lockData":{"pos":pos,"val":val,"lock":lock}};
			
			//更新人物造化属性
			EquipFortuneInfoInitSocketHandler.sendFortuneInfoInit();
			furnaceModule.furnaceInfo.updateEquipAttr(data);
			super.handComplete();
		}
		
		/**
		 * 发送锁定或解锁装备造化位置请求
		 * @param eqType 装备部位,CategoryType.Equip_x值
		 * @param pos 造化位置
		 * @param flag 0->锁定，1->打通
		 */ 
		public static function sendFortuneLock(eqType:int, pos:int, flag:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.EQUIP_FORTUNE_LOCK_CS);
			pkg.writeInt(eqType);
			pkg.writeInt(pos);
			pkg.writeInt(flag);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get furnaceModule():FurnaceModule
		{
			return _handlerData as FurnaceModule;
		}
	}
}