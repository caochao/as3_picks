package xdmh.furnace.socketHandlers.equip
{
	import xdmh.core.data.GlobalAPI;
	import xdmh.core.data.ProtocolType;
	import xdmh.core.socketHandlers.BaseSocketHandler;
	import xdmh.core.utils.SceneUtils;
	import xdmh.interfaces.socket.IPackageOut;
	
	/**
	 * 保存造化结果 13134 C->S
	   int32: 装备部位
	   ---------------------------
	   S->C 人物造化属性 13136
	 */ 
	public class EquipFortuneSaveSocketHandler extends BaseSocketHandler
	{
		public function EquipFortuneSaveSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		/**
		 * 发送保存造化结果请求
		 * @param eqType 装备ID
		 */ 
		public static function sendFortuneSave(eqType:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.EQUIP_FORTUNE_SAVE_CS);
			pkg.writeInt(eqType);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}