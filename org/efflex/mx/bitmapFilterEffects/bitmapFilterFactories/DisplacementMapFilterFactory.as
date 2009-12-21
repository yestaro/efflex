package org.efflex.mx.bitmapFilterEffects.bitmapFilterFactories
{
	import flash.display.BitmapDataChannel;
	import flash.filters.BitmapFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.Point;
	
	import org.efflex.mx.bitmapFilterEffects.bitmapDataMapFactories.IBitmapDataMapFactory;
	import org.efflex.mx.bitmapFilterEffects.bitmapDataMaps.IBitmapDataMap;

	public class DisplacementMapFilterFactory implements IBitmapFilterFactory
	{
		
		public var bitmapDataMapFactory		: IBitmapDataMapFactory;
		public var mapPoint					: Point = null;
		
		public var componentX		: uint = 0;
		public var componentY		: uint = 0;
		
		public var mode				: String = DisplacementMapFilterMode.WRAP;
		public var color			: uint;
		public var alpha			: Number;
		
		public var scaleXFrom		: Number = 1;
		public var scaleYFrom		: Number = 1;
		
		public var scaleXTo			: Number = 1;
		public var scaleYTo			: Number = 1;
		
		public var scaleXChange		: Number;
		public var scaleYChange		: Number;
		
		private var _bitmapDataMap	: IBitmapDataMap;
		
		public function DisplacementMapFilterFactory()
		{
			super();
		}
		
		public function newFilter( width:Number, height:Number ):BitmapFilter
		{
			_bitmapDataMap = ( bitmapDataMapFactory ) ? bitmapDataMapFactory.newBitmapDataMap( width, height ) : null;
			return new DisplacementMapFilter( _bitmapDataMap.bitmapData, new Point(), componentX, componentY, scaleXFrom, scaleYFrom, mode, color, alpha )
		}
		
		public function update( filter:BitmapFilter, value:Number ):void
		{
			if( isNaN( scaleXChange ) ) scaleXChange = scaleXTo - scaleXFrom;
			if( isNaN( scaleYChange ) ) scaleYChange = scaleYTo - scaleYFrom;
			
			var f:DisplacementMapFilter = DisplacementMapFilter( filter );
			f.scaleX = scaleXFrom + ( scaleXChange * value );
			f.scaleY = scaleYFrom + ( scaleYChange * value );
			
			if( _bitmapDataMap ) _bitmapDataMap.update();
		}

		public function destroy():void
		{
			_bitmapDataMap.destroy();
		}
		
		
	}
}