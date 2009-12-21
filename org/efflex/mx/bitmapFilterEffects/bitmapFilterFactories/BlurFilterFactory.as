package org.efflex.mx.bitmapFilterEffects.bitmapFilterFactories
{
	import flash.filters.BitmapFilter;
	import flash.filters.BlurFilter;

	public class BlurFilterFactory implements IBitmapFilterFactory
	{
		public var blurXFrom	: Number = 0;
		public var blurYFrom	: Number = 0;
		
		public var blurXTo		: Number = 0;
		public var blurYTo		: Number = 0;
		
		public var blurXChange	: Number;
		public var blurYChange	: Number;
		
		public var quality		: int = 1;
		
		public function BlurFilterFactory()
		{
			super();
		}
		
		public function newFilter( width:Number, height:Number ):BitmapFilter
		{
			return new BlurFilter( blurXFrom, blurYFrom, quality );
		}
		
		public function update( filter:BitmapFilter, value:Number ):void
		{
			if( isNaN( blurXChange ) ) blurXChange = blurXTo - blurXFrom;
			if( isNaN( blurYChange ) ) blurYChange = blurYTo - blurYFrom;
			
			var f:BlurFilter = BlurFilter( filter );
			f.blurX = blurXFrom + ( blurXChange * value );
			f.blurY = blurYFrom + ( blurYChange * value );
		}
		
		public function destroy():void
		{
			
		}

		
	}
}