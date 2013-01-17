package xdmh.furnace.components.sld.inlay
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mhqy.ui.label.MAssetLabel;
	import mhqy.ui.mcache.btns.MCacheAsset2Btn;
	import mhqy.ui.mcache.btns.selectBtns.MCacheSelectBtn;
	
	import xdmh.constData.CategoryType;
	import xdmh.core.data.GlobalAPI;
	import xdmh.core.data.GlobalData;
	import xdmh.core.data.bag.BagInfoUpdateEvent;
	import xdmh.core.data.furnace.equip.PearlAttr;
	import xdmh.core.data.furnace.equip.PearlData;
	import xdmh.core.data.furnace.equip.PearlInlayType;
	import xdmh.core.data.furnace.equip.YqsInfoUpdateEvent;
	import xdmh.core.data.item.ItemInfo;
	import xdmh.core.data.module.ModuleType;
	import xdmh.core.data.player.SelfPlayerInfoUpdateEvent;
	import xdmh.core.utils.AssetUtil;
	import xdmh.core.view.quickTips.QuickTips;
	import xdmh.furnace.FurnaceFacade;
	import xdmh.furnace.components.cell.InlayCell;
	import xdmh.furnace.components.cell.LQBigCell;
	import xdmh.furnace.components.cell.PearlCell;
	import xdmh.furnace.components.sld.EpBasePanel;
	import xdmh.furnace.data.FurnaceInfo;
	import xdmh.furnace.events.FuranceEvent;
	import xdmh.furnace.pearl.pearlBgAsset;
	import xdmh.furnace.socketHandlers.equip.EquipFortuneSaveSocketHandler;
	import xdmh.furnace.socketHandlers.equip.EquipFortuneSocketHandler;
	import xdmh.furnace.socketHandlers.equip.EquipInlaySocketHandler;
	import xdmh.interfaces.moviewrapper.IMovieWrapper;
	
	/**
	 * 装备镶嵌（附灵）
	 */ 
	public class EpInlayPanel extends EpBasePanel
	{
		private var _eqCellBg:Bitmap;
		private var _eqCell:LQBigCell;
		private var _inlayList:Vector.<InlayCell>;				//附灵格子（共3个）
		private var _pearlBag:PearlBag;						//灵珠背包
		private var _lbTip:MAssetLabel;						//拖动提示
		private var _lnPearl:MAssetLabel;						//链接到灵珠合成
		
		public function EpInlayPanel()
		{
			_picAsset = pearlBgAsset;
			_funcLvMin = 60;
			super();
		}
		
		override protected function initView():void
		{
			super.initView();
			
			//格子背景
			_eqCellBg = new Bitmap(AssetUtil.getAsset("xdmh.furnace.common.cellGreenBgAsset") as BitmapData);
			_eqCellBg.x = 104;
			_eqCellBg.y = 182;
			addChild(_eqCellBg);
			
			//当前装备
			_eqCell = new LQBigCell();
			_eqCell.move(110,186);
			addChild(_eqCell);
			
			//3个附灵部位
			var _inlayPos:Vector.<Point> = new Vector.<Point>();
			_inlayPos.push(new Point(126,103), new Point(40,258), new Point(210,259));
			_inlayList = new Vector.<InlayCell>();
			
			for(var j:int = 0; j<3; j++)
			{
				var iCell:InlayCell = new InlayCell(j+1);
				var p:Point = _inlayPos[j];
				iCell.move(p.x, p.y);
				_inlayList.push(iCell);
				addChild(iCell);
				
				//灵珠文字 
				var label:MAssetLabel = new MAssetLabel("灵珠", MAssetLabel.getLabelType(0xB6996F));
				label.move((iCell.width - label.width)/2, (iCell.height - label.height)/2);
				iCell.addChild(label);
			}
			
			//拖动提示
			_lbTip = new MAssetLabel("←拖动灵珠到装备表面",MAssetLabel.LABELTYPE19);
			_lbTip.move(305, 50);
			addChild(_lbTip);
			
			//灵珠背包
			_pearlBag = new PearlBag(this);
			_pearlBag.move(291,80);
			addChild(_pearlBag);
			
			//灵珠合成链接
			_lnPearl = new MAssetLabel("灵珠合成", MAssetLabel.getLabelType(0x000000, "宋体", 14, false, true));
			_lnPearl.move(346, 384);
			addChild(_lnPearl);
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			for(var j:int = 0; j<3; j++)
			{
				_inlayList[j].addEventListener(MouseEvent.MOUSE_DOWN,onPearlDrag);
			}
			furnaceInfo.addEventListener(FuranceEvent.EQUIP_ATTR_UPDATE,onAttrUpdate);
			GlobalData.pearlList.addEventListener(YqsInfoUpdateEvent.PEARL_DATA_UPDATE,onEquipPearlUpdate);
			GlobalData.pearlList.addEventListener(YqsInfoUpdateEvent.YQS_CELL_MOVE,onCellMove);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			for(var j:int = 0; j<3; j++)
			{
				_inlayList[j].removeEventListener(MouseEvent.MOUSE_DOWN,onPearlDrag);
			}
			furnaceInfo.removeEventListener(FuranceEvent.EQUIP_ATTR_UPDATE,onAttrUpdate);
			GlobalData.pearlList.removeEventListener(YqsInfoUpdateEvent.PEARL_DATA_UPDATE,onEquipPearlUpdate);
			GlobalData.pearlList.removeEventListener(YqsInfoUpdateEvent.YQS_CELL_MOVE,onCellMove);
		}
		
		//灵珠拖动
		private function onPearlDrag(e:MouseEvent):void
		{
			var cell:InlayCell = e.currentTarget as InlayCell;
			if(cell.itemInfo)
			{
				GlobalAPI.dragManager.startDrag(cell);
			}
		}
		
		//显示详细附灵信息
		override protected function showDetail(equip:ItemInfo):void
		{
			_eqCell.itemInfo = equip;
			clear();
			
			var data:PearlData = GlobalData.pearlList.getPearlByType(1);
			if(data)
			{
				var pearlAttr:Array = data.pearl;
				for(var i:int = 0, n:int = pearlAttr.length; i<n; i++)
				{
					var attr:PearlAttr = pearlAttr[i];
					var pos:int = attr.pos;
					_inlayList[pos-1].itemInfo = GlobalData.bagInfo.getItemByTid(attr.templateId);
				}
			}
		}
		
		private function _showDetail(equip:ItemInfo):void
		{
			
		}
		
		private function clear():void
		{
			for each(var cell:InlayCell in _inlayList)
			{
				cell.itemInfo = null;
			}
		}
		
		//附灵后属性更新
		private function onAttrUpdate(e:FuranceEvent):void
		{
			var eqType:int = e.data.eqType;
			var attr:PearlAttr;
			if((attr = e.data.inlayData) != null)
			{
				_inlayList[attr.pos-1].itemInfo = GlobalData.bagInfo.getItemByTid(attr.templateId);
			}
		}
		
		override protected function onRolePropUpdate(e:SelfPlayerInfoUpdateEvent):void
		{
			super.onRolePropUpdate(e);
		}
		
		override protected function onItemUpdate(e:BagInfoUpdateEvent):void
		{
			if(selectedEquip)
			{
				getMaterial();
			}
		}
		
		private function getMaterial():void
		{
			
		}
		
		private function getLingQi(numLock:int):int
		{
			return 300;
		}
		
		//装备附灵信息更新
		private function onEquipPearlUpdate(e:YqsInfoUpdateEvent):void
		{
			var equip:ItemInfo = GlobalData.bagInfo.getEquipByType(1);
			showDetail(equip);
		}
		
		//灵珠附灵
		private function onCellMove(e:YqsInfoUpdateEvent):void
		{
			switch(isValid(e.data))
			{
				case PearlInlayType.NOT_INLAY:
					return;
				case PearlInlayType.POS_INLAYED:
					QuickTips.show("此部位已有灵珠，请选择其它孔！");
					return;
				case PearlInlayType.TYPE_EXIST:
					QuickTips.show("对不起，同一装备不能镶嵌同类灵珠！");
					return;
				default:
					//EquipInlaySocketHandler.sendEquipInlay(currEqType, e.data.itemInfo.templateId ,e.data.pos);
					EquipInlaySocketHandler.sendEquipInlay(1, e.data.itemInfo.templateId ,e.data.pos);
			}
		}
		
		//验证灵珠是否可镶嵌
		private function isValid(data:Object):int
		{
			//非镶嵌操作
			if(data.action != PearlInlayType.INLAY)		
			{
				return PearlInlayType.NOT_INLAY;
			}//同部位已有灵珠
			if(_inlayList[data.pos-1].itemInfo)			
			{
				return PearlInlayType.POS_INLAYED;
			}//同类灵珠已存在
			if(pearlTypeExist(data.itemInfo))			
			{
				return PearlInlayType.TYPE_EXIST;
			}
			return PearlInlayType.VALID_INLAY;
		}
		
		//判断同类似灵珠是否存在
		private function pearlTypeExist(pearl:ItemInfo):Boolean
		{
			var isExist:Boolean = false;
			/*for each(var cell:InlayCell in _inlayList)
			{
				if(cell.itemInfo &&　cell.itemInfo.template.type == pearl.template.type)
				{
					isExist = true;
					break;
				}
			}
			return isExist;*/
			//测试
			return false;
		}
		
		override public function dispose():void
		{
			removeEvent();
			super.dispose();
		}
	}
}