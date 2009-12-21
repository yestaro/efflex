package org.efflex.mx.bitmapFilterEffects.bitmapDataMapFactories
{
	import flash.geom.Point;
	
	import org.efflex.mx.bitmapFilterEffects.bitmapDataMaps.IBitmapDataMap;
	import org.efflex.mx.bitmapFilterEffects.bitmapDataMaps.PerlinNoiseBitmapDataMap;

	public class PerlinNoiseFactory implements IBitmapDataMapFactory
	{
		public var baseX:Number;
		public var baseY:Number;
		public var numOctaves:uint;
		public var randomSeed	: int;
		public var stitch		: Boolean;
		
		public var fractalNoise		: Boolean;
		public var channelOptions		: uint = 7;
		
		public var grayScale		: Boolean = false;
		public var offsetIncrements		: Array;
		
		public function PerlinNoiseFactory()
		{
			super();
		}
		
		public function newBitmapDataMap( width:Number, height:Number ):IBitmapDataMap
		{
			return new PerlinNoiseBitmapDataMap( width, height, baseX, baseY, numOctaves, randomSeed, stitch, fractalNoise, channelOptions, grayScale, offsetIncrements );
		}
		
		
	}
}