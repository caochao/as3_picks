package xdmh.furnace.components.yqs.fortune
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mhqy.ui.label.MAssetLabel;
	import mhqy.ui.label.MAssetLabelPair;
	import mhqy.ui.mcache.btns.MCacheAsset2Btn;
	import mhqy.ui.mcache.btns.selectBtns.MCacheSelectBtn;
	
	import xdmh.constData.CategoryType;
	import xdmh.core.data.GlobalData;
	import xdmh.core.data.bag.BagInfoUpdateEvent;
	import xdmh.core.data.furnace.equip.BaptizeData;
	import xdmh.core.data.furnace.equip.BasicAttr;
	import xdmh.core.data.furnace.equip.FortuneAttr;
	import xdmh.core.data.furnace.equip.FortuneData;
	import xdmh.core.data.furnace.equip.FortuneExpTemplateList;
	import xdmh.core.data.furnace.equip.YqsInfoUpdateEvent;
	import xdmh.core.data.item.ItemInfo;
	import xdmh.core.data.module.ModuleType;
	import xdmh.core.view.quickTips.QuickTips;
	import xdmh.furnace.FurnaceFacade;
	import xdmh.furnace.FurnaceModule;
	import xdmh.furnace.components.cell.LQCell;
	import xdmh.furnace.components.yqs.YqsBasePanel;
	import xdmh.furnace.data.FurnaceInfo;
	import xdmh.furnace.events.FuranceEvent;
	import xdmh.furnace.socketHandlers.equip.EquipFortuneSaveSocketHandler;
	import xdmh.furnace.socketHandlers.equip.EquipFortuneSocketHandler;
	import xdmh.interfaces.moviewrapper.IMovieWrapper;
	import xdmh.interfaces.tick.ITick;
	
	/**
	 * 装备造化
	 */ 
	public class EpFortunePanel extends YqsBasePanel
	{
		private var _eqCell:LQCell;
		private var _pillarList:Vector.<FortunePillar>;		//造化水柱列表
		private var _defaultBap:BasicAttr;						//默认洗炼属性
		private var _lastFortuneData:Object;					//上次造化数据
		
		private var _lbTip:MAssetLabelPair;
		private var _btnFortune:MCacheAsset2Btn; 
		private var _btnSave:MCacheAsset2Btn;
		private var _btnCancel:MCacheAsset2Btn;
		
		private const _weaponNeedLv:int = 60;				//武器、衣服造化人物等级限制
		private const _hatNeedLv:int = 65;					//帽子、鞋子造化人物等级限制
		private const _necklaceNeedLv:int = 70;			//项链、护符造化人物等级限制
		private const _ringNeedLv:int = 75;				//手镯、戒指造化人物等级限制
		
		public function EpFortunePanel()
		{
			_picPath = "xdmh.furnace.fortune.bgAsset";
			super();
		}
		
		override protected function initView():void
		{
			super.initView();
			
			_defaultBap = new BasicAttr(1, 0);
			
			//当前装备
			_eqCell = new LQCell();
			_eqCell.move(218,60);
			addChild(_eqCell);
			
			//造化柱
			_pillarList = new Vector.<FortunePillar>();
			for(var j:int=0;j<6;j++)
			{
				var pillar:FortunePillar = new FortunePillar(j+1);
				pillar.move(57+65*j,119);
				addChild(pillar);
				_pillarList.push(pillar);
			}
			
			//提示文本
			_lbTip = new MAssetLabelPair("", "", MAssetLabel.getLabelType(0xffffff), MAssetLabel.getLabelType(0xffffff));
			_lbTip.move(80,342);
			addChild(_lbTip);
			
			//造化，保存、取消
			_btnFortune = new MCacheAsset2Btn(0,"造化");
			_btnFortune.move(220,362);
			addChild(_btnFortune);
			
			_btnSave = new MCacheAsset2Btn(0,"保存");
			_btnSave.move(160,362);
			_btnSave.visible = false;
			addChild(_btnSave);
			
			_btnCancel = new MCacheAsset2Btn(0,"取消");
			_btnCancel.move(260,362);
			_btnCancel.visible = false;
			addChild(_btnCancel);
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			
			for each(var p:FortunePillar in _pillarList)
			{
				p.addEventListener(FuranceEvent.FORTUNE_PILLAR_UNLOCK,onUnlock);
			}
			_btnFortune.addEventListener(MouseEvent.CLICK,onFortune);
			_btnSave.addEventListener(MouseEvent.CLICK,onSave);
			_btnCancel.addEventListener(MouseEvent.CLICK,onCancel);
			furnaceInfo.addEventListener(FuranceEvent.EQUIP_ATTR_UPDATE,onAttrUpdate);
			GlobalData.fortuneList.addEventListener(YqsInfoUpdateEvent.FORTUNE_DATA_UPDATE,onFortuneUpdate);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			
			for each(var p:FortunePillar in _pillarList)
			{
				p.removeEventListener(FuranceEvent.FORTUNE_PILLAR_UNLOCK,onUnlock);
			}
			_btnFortune.removeEventListener(MouseEvent.CLICK,onFortune);
			_btnSave.removeEventListener(MouseEvent.CLICK,onSave);
			_btnCancel.removeEventListener(MouseEvent.CLICK,onCancel);
			furnaceInfo.removeEventListener(FuranceEvent.EQUIP_ATTR_UPDATE,onAttrUpdate);
			GlobalData.fortuneList.removeEventListener(YqsInfoUpdateEvent.FORTUNE_DATA_UPDATE,onFortuneUpdate);
		}
		
		//显示详细造化属性
		override protected function showDetail(equip:ItemInfo):void
		{
			_eqCell.itemInfo = equip;
			clear();
			
			//强化属性
			var bapData:Array = currEq ? currEq.baptizeAttr : [];
			for (var i:int = 0, m:int = bapData.length; i < m; i++)
			{
				_pillarList[i].showBapAttr(true);
				_pillarList[i].bapAttr = bapData[i];
			}
			
			//造化属性
			var fortData:FortuneData = GlobalData.fortuneList.getFortuneByType(currEqType);
			if(fortData)
			{
				var fortuneArr:Array = fortData.fortune;
				for(var j:int = 0, n:int = fortuneArr.length; j<n; j++)
				{
					var attr:FortuneAttr = fortuneArr[j];
					var pillar:FortunePillar = _pillarList[attr.pos-1];
					pillar.lv = attr.lv;
					pillar.exp = attr.exp;
					pillar.enhance = attr.enhance;
					pillar.lock = attr.lock==0;
				}
				_btnSave.visible && setFortuneEnable(true);
			}
			_needXianQi = getXianQi();
			showFortuneTip(_needXianQi);
		}
		
		private function clear():void
		{
			for each(var pillar:FortunePillar in _pillarList)
			{
				pillar.lv = 0;
				pillar.exp = 0;
				pillar.bapAttr = _defaultBap;
				pillar.enhance = 0;
				pillar.change = 0;
				pillar.lock = true;
				pillar.showBapAttr(false);
			}
		}
		
		//开锁事件
		private function onUnlock(e:FuranceEvent):void
		{
			var count:int = 0;
			for each(var p:FortunePillar in _pillarList)
			{
				!p.lock && count++;
			}
			if(3 == count)
			{
				QuickTips.show("同一装备部位只能选择3条造化属性！");
			}
		}
		
		//点击造化按钮
		private function onFortune(e:MouseEvent):void
		{
			var playerLv:int = GlobalData.selfPlayer.level;
			if(playerLv < _weaponNeedLv && (currEqType == CategoryType.EQUIP_WEAPON || currEqType == CategoryType.EQUIP_CLOSTH))
			{
				QuickTips.show("武器和衣服造化在人物60级时开启！");
				return;
			}
			if(playerLv < _hatNeedLv && (currEqType == CategoryType.EQUIP_HAT || currEqType == CategoryType.EQUIP_SHOE))
			{
				QuickTips.show("帽子和鞋子造化在人物65级时开启！");
				return;
			}
			if(playerLv < _necklaceNeedLv && (currEqType == CategoryType.EQUIP_NECKLACE || currEqType == CategoryType.EQUIP_AMULET))
			{
				QuickTips.show("项链和护符造化在人物70级时开启！");
				return;
			}
			if(playerLv < _ringNeedLv && (currEqType == CategoryType.EQUIP_RING || currEqType == CategoryType.EQUIP_BRACELET))
			{
				QuickTips.show("手镯和戒指造化在人物75级时开启！");
				return;
			}
			
			//判断仙气是否足够
			if(GlobalData.selfPlayer.godGas < _needXianQi)
			{
				showPoorMsg("仙气值");
			}
			else
			{
				EquipFortuneSocketHandler.sendEquipFortune(currEqType);
			}
		}
		
		private function onSave(e:MouseEvent):void
		{
			EquipFortuneSaveSocketHandler.sendFortuneSave(currEqType);
		}
		
		private function onCancel(e:MouseEvent):void
		{
			for each(var pillar:FortunePillar in _pillarList)
			{
				pillar.change = 0;
			}
			showDetail(currEq);
			setFortuneEnable(true);
		}
		
		//开解锁、点击造化时触发
		private function onAttrUpdate(e:FuranceEvent):void
		{
			var eqType:int = e.data.eqType;
			if(e.data.lockData)
			{
				var lockData:Object = e.data.lockData;
				var pos:int = lockData.pos;
				var val:int = lockData.val;
			    var lock:int = lockData.lock;
				_pillarList[pos-1].lock = lock==0;
				_pillarList[pos-1].enhance = val;
			}
			else if(e.data.fortuneData)
			{
				var isCrit:Boolean = false;
				var fortuneData:Array = e.data.fortuneData;
				
				//保存上次造化数据
				_lastFortuneData = e.data.fortuneData;
				
				for each(var obj:Object in fortuneData)
				{
					var pillar:FortunePillar = _pillarList[obj.pos-1];
					var currExp:int = FortuneExpTemplateList.getTotalExp(obj.lv) + obj.exp;
					pillar.change = currExp - pillar.totalExp;
					//pillar.exp = obj.exp;
					//pillar.lv = obj.lv;
					if(pillar.change > 200)
						isCrit = true;
				}
				_needXianQi = getXianQi();
				showFortuneTip(_needXianQi);
				setFortuneEnable(false);
				if(isCrit)
				{
					QuickTips.show("道友你非常幸运，居然获得了暴击值！");
				}
				QuickTips.show("造化成功！");
			}
		}
		
		//计算消耗仙气量
		private function getXianQi():Number
		{
			var totalExp:Number = 0;
			for each(var pillar:FortunePillar in _pillarList)
			{
				totalExp += pillar.totalExp;
			}
			//仙气消耗=200*1.15^(造化总经验/5000)
			//造化总经验=六个经验值总和
			return Math.round(200 * Math.pow(1.15, totalExp/5000));
		}
		
		private function showFortuneTip(xianQi:int):void
		{
			_lbTip.title = "提示";
			_lbTip.value = "本次造化消耗" + xianQi.toString() + "仙气， 若取消造化则返回" + Math.round(xianQi / 2) + "仙气";
		}
		
		//人物造化属性更新(保存造化属性回调)
		private function onFortuneUpdate(e:YqsInfoUpdateEvent):void
		{
			if(currEq)
			{
				_eqCell.itemInfo = GlobalData.bagInfo.getEqItemByItemId(currEq.itemId)||GlobalData.bagInfo.getItemByItemId(currEq.itemId);
			}
			
			//点击保存按钮后再应用新属性
			for each(var obj:Object in _lastFortuneData)
			{
				var pillar:FortunePillar = _pillarList[obj.pos-1];
				var currExp:int = FortuneExpTemplateList.getTotalExp(obj.lv) + obj.exp;
				pillar.change = 0;
				pillar.exp = obj.exp;
			    pillar.lv = obj.lv;
			}
			_lastFortuneData = null;
			
			setFortuneEnable(true);
		}
		
		private function setFortuneEnable(enable:Boolean):void
		{
			_btnFortune.visible = enable;
			_btnSave.visible = !enable;
			_btnCancel.visible = !enable;
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}