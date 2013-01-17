package xdmh.furnace.components.sld.baptize
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	
	import mhqy.ui.label.MAssetLabel;
	
	import xdmh.core.utils.AssetUtil;
	import xdmh.furnace.common.ArrowsDownAsset;
	import xdmh.furnace.common.ArrowsUpAsset;

	/**
	 * 带箭头且可显示数值变化的洗炼属性条
	 */ 
	public class BaptizeEnhancer extends BaptizeViewer
	{
		private var _arrowUp:Bitmap;
		private var _arrowDown:Bitmap;
		private var _lbEnhance:MAssetLabel;	//enhance文本域
		
		private var _enhance:int;				//数值变化
		private var _color:uint;				//数值颜色
		
		public function BaptizeEnhancer(type:int=1, key:String="攻击", value:String="0", star:int=1, enhance:int=0)
		{
			_enhance = enhance;
			super(type, key, value, star, true);
		}
		
		override protected function initView():void
		{
			super.initView();
			
			//箭头
			_arrowUp = new Bitmap(new ArrowsUpAsset());
			_arrowUp.x = _starStrLabel.x + _starStrLabel.width;
			_arrowUp.y = _starStrLabel.y + 2;
			_arrowUp.visible = false;
			addChild(_arrowUp);
			
			_arrowDown = new Bitmap(new ArrowsDownAsset());
			_arrowDown.x = _starStrLabel.x + _starStrLabel.width;
			_arrowDown.y = _starStrLabel.y + 2;
			_arrowDown.visible = false;
			addChild(_arrowDown);
			
			_lbEnhance = new MAssetLabel("", MAssetLabel.LABELTYPE19);
			_lbEnhance.move(_arrowUp.x+10 , _starStrLabel.y-2);
			_lbEnhance.visible = false;
			addChild(_lbEnhance);
		}
		
		
		/**
		 * 设置洗炼变化数值
		 */		
		public function set enhance(value:int):void
		{
			if(_enhance == value) return;
			_enhance = value;
			if(0 == _enhance)
			{
				_arrowUp.visible = false;
				_arrowDown.visible = false;
				_lbEnhance.visible =false;
				return;
			}
			
			var asc:Boolean = _enhance > 0;
			_arrowUp.visible = asc;
			_arrowDown.visible = !asc;
			
			_lbEnhance.setValue(_enhance.toString().replace("-",""));
			_lbEnhance.setLabelType(MAssetLabel.getLabelType(asc ? 0x11B711 : 0xC81717));
			_lbEnhance.visible = true;
			_lbEnhance.move(_arrowUp.x+10, _arrowUp.y-2);
		}
		
		override public function dispose():void
		{
			if(_arrowUp)
			{
				_arrowUp = null;
			}
			if(_arrowDown)
			{
				_arrowDown = null;
			}
			if(_lbEnhance)
			{
				_lbEnhance = null;
			}
			super.dispose();
		}
	}
}