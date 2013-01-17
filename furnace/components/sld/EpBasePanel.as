package xdmh.furnace.components.sld
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mhqy.ui.backgroundUtil.BackgroundInfo;
	import mhqy.ui.backgroundUtil.BackgroundType;
	import mhqy.ui.backgroundUtil.BackgroundUtils;
	import mhqy.ui.container.MAlert;
	import mhqy.ui.event.CloseEvent;
	import mhqy.ui.label.MAssetLabel;
	import mhqy.ui.label.MAssetLabelPair;
	
	import xdmh.constData.SourceClearType;
	import xdmh.core.data.GlobalAPI;
	import xdmh.core.data.GlobalData;
	import xdmh.core.data.bag.BagInfoUpdateEvent;
	import xdmh.core.data.fontFormat.FontFormatTemplateList;
	import xdmh.core.data.furnace.equip.Color;
	import xdmh.core.data.item.ItemInfo;
	import xdmh.core.data.module.ModuleType;
	import xdmh.core.data.player.SelfPlayerInfoUpdateEvent;
	import xdmh.core.manager.LanguageManager;
	import xdmh.core.socketHandlers.store.GetShopListSocketHandler;
	import xdmh.core.utils.AssetUtil;
	import xdmh.core.view.effects.dg.DgLoadEffect;
	import xdmh.furnace.FurnaceFacade;
	import xdmh.furnace.components.EquipPicker;
	import xdmh.furnace.data.FurnaceInfo;
	import xdmh.furnace.events.FuranceEvent;
	import xdmh.interfaces.dispose.IDispose;
	import xdmh.interfaces.moviewrapper.IMovieWrapper;
	import xdmh.ui.BorderAsset15;

	/**
	 * 装备洗炼，强化，进阶，升级，套装基类
	 */ 
	public class EpBasePanel extends Sprite implements IDispose
	{
		private const _WIDTH:int = 600;
		private const _HEIGHT:int = 490;
		
		private var _effect:DgLoadEffect;
		private var _bg:IMovieWrapper;
		private var _pic:Bitmap;
		private var _lbLingQi:MAssetLabelPair;		//当前灵气
		private var _selectedEquip:ItemInfo;		//当前先中装备
		
		protected var _picAsset:Class;				//右侧背景图
		protected var _funcLvMin:int;			 	//功能开启等级
		protected var _needLingQi:int;				//消耗灵气
		
		public function EpBasePanel()
		{
			initView();
			initEvent();
			
			//切换标签页显示上次选择装备
			/*if(furnaceInfo.lastEq)
			{
				_selectedEquip = GlobalData.bagInfo.getItemByItemId(furnaceInfo.lastEq)|| GlobalData.bagInfo.getEqItemByItemId(furnaceInfo.lastEq);
				showDetail(_selectedEquip);	
			}*/
		}
		
		protected function initView():void
		{
			//背景
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.GOLD_BORDER_BG,new Rectangle(5, 0, _WIDTH-10, 454))
			]);
			addChild(_bg as DisplayObject);
			
			//右侧图片
			_pic = new Bitmap(new _picAsset() as BitmapData);
			_pic.x = 163;
			_pic.y = 6;
			addChild(_pic);
			
			//当前灵气
			_lbLingQi = new MAssetLabelPair("灵气", GlobalData.selfPlayer.smartGas.toString(),
				FontFormatTemplateList.getFormatById(1023),FontFormatTemplateList.getFormatById(1023),"：");
			_lbLingQi.move(170,9);
			addChild(_lbLingQi);
		}
		
		protected function initEvent():void
		{
			furnaceInfo.addEventListener(FuranceEvent.EQUIP_SELECTED, eqClickHandler);
			GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.ITEM_UPDATE,onItemUpdate);
			GlobalData.selfPlayer.addEventListener(SelfPlayerInfoUpdateEvent.PROPERTYUPDATE, onRolePropUpdate);
		}
		
		protected function removeEvent():void
		{
			furnaceInfo.removeEventListener(FuranceEvent.EQUIP_SELECTED, eqClickHandler);
			GlobalData.bagInfo.removeEventListener(BagInfoUpdateEvent.ITEM_UPDATE,onItemUpdate);
			GlobalData.selfPlayer.removeEventListener(SelfPlayerInfoUpdateEvent.PROPERTYUPDATE, onRolePropUpdate);
		}
		
		private function eqClickHandler(e:FuranceEvent):void
		{
			//if(GlobalData.selfPlayer.level < _funcLvMin) return;
			_selectedEquip = e.data.selectedEquip;
			showDetail(_selectedEquip);
		}
		
		//人物属性变化
		protected function onRolePropUpdate(e:SelfPlayerInfoUpdateEvent):void
		{
			_lbLingQi.value = GlobalData.selfPlayer.smartGas.toString();
			//if(GlobalData.selfPlayer.level < _funcLvMin) return;
		}
		
		//物品更新事件
		protected function onItemUpdate(e:BagInfoUpdateEvent):void
		{
			
		}
		
		protected function showPoorMsg(itemName:String, callBack:Function = null):void
		{
			MAlert.show("对不起，你当前" + itemName + "不足，可尝试去商城购买！",
				LanguageManager.getWord("xdmh.common.alertTitle"),
				MAlert.YES|MAlert.NO,null, callBack);
		}
		
		protected function lingQiPoorHandler(e:CloseEvent):void
		{
			if(e.detail == MAlert.YES)
			{
				showStorePanel();
			}
		}
		
		protected function jinHuaPoorHandler(e:CloseEvent):void
		{
			if(e.detail == MAlert.YES)
			{
				showStorePanel();
			}
		}
		
		protected function showStorePanel():void
		{
			GetShopListSocketHandler.send(); 
		}
		
		protected function showDetail(equip:ItemInfo):void
		{
			
		}
		
		protected function get selectedEquip():ItemInfo
		{
			return _selectedEquip;
		}
		
		protected function get furnaceInfo():FurnaceInfo
		{
			return FurnaceFacade.getInstance(ModuleType.FURNACE.toString()).furnaceModule.furnaceInfo;
		}
		
		protected function playEffect(dgPath:int,effX:int=0,effY:int=0,repeat:Boolean=false, clearType:int=SourceClearType.IMMEDIAT, clearTime:int=2147483647, priority:int=3,threshold:int=5):void
		{
			if(!_effect)
			{
				_effect = new DgLoadEffect(dgPath,0,repeat,threshold);
				_effect.move(effX,effY);
			}
			if(!this.contains(_effect))
			{
				addChild(_effect);
			}
			if(!GlobalAPI.tickManager.inTick(_effect))
			{
				_effect.play(clearType,clearTime,priority);
			}
		}
		
		public function dispose():void
		{
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_pic && _pic.parent)
			{
				_pic.parent.removeChild(_pic);
				_pic.bitmapData.dispose();
				_pic.bitmapData = null;
				_pic = null;
			}
			if(_lbLingQi)
			{
				_lbLingQi.dispose();
				_lbLingQi = null;
			}
			if(_selectedEquip)
			{
				_selectedEquip = null;
			}
			if(_effect)
			{
				_effect = null;
			}
		}
	}
}