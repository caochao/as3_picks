package xdmh.furnace.socketHandlers.equip
{
	import xdmh.core.data.GlobalAPI;
	import xdmh.core.data.ProtocolType;
	import xdmh.core.socketHandlers.BaseSocketHandler;
	import xdmh.core.utils.SceneUtils;
	import xdmh.furnace.FurnaceModule;
	import xdmh.interfaces.socket.IPackageOut;
	
	/**
	 * 装备造化请求 13130 C->S
		int32:装备部位
       -------------------------------
		装备造化响应 13131 S->C
		int32:装备部位
		int16:造化数组长度
		    int32:造化位置
		    int32:造化经验
		    int32:造化等级
			int32:造化加成值
			int32:是否锁定，0->未锁定，1->锁定
	 */ 
	public class EquipFortuneSocketHandler extends BaseSocketHandler
	{
		public function EquipFortuneSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.EQUIP_FORTUNE_SC;
		}
		
		override public function handlePackage():void
		{
			var eqType:int = _data.readInt();
			var expArr:Array = [];
			var expCount:int = _data.readShort();
			if(expCount)
			{
				for(var i:int = 0; i<expCount; i++)
				{
					var pos:int = _data.readInt();
					var exp:int = _data.readInt();
					var lv:int = _data.readInt();
					var enhance:int = _data.readInt();
					var lock:int = _data.readInt();
					expArr.push({"pos":pos,"exp":exp,"lv":lv,"enhance":enhance});
				}
			}
			furnaceModule.furnaceInfo.updateEquipAttr({"eqType":eqType,"fortuneData":expArr});
			super.handComplete();
		}
		
		/**
		 * 发送装备造化请求
		 * @param eqType  装备部位(CategoryType.Equip_x类型)
		 */ 
		static public function sendEquipFortune(eqType:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.EQUIP_FORTUNE_CS);
			pkg.writeInt(eqType);
			GlobalAPI.socketManager.send(pkg);
		}
		
		private function get furnaceModule():FurnaceModule
		{
			return _handlerData as FurnaceModule;
		} 
	}
}