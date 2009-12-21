package org.efflex.mx.bitmapFilterEffects.bitmapDataMaps
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import mx.core.Application;

	public class PerlinNoiseBitmapDataMap implements IBitmapDataMap
	{
		private var _baseX:Number;
		private var _baseY:Number;
		private var _numOctaves:uint;
		private var _randomSeed	: int;
		private var _stitch		: Boolean;
		
		private var _fractalNoise		: Boolean;
		private var _channelOptions		: uint = 7;
		
		private var _grayScale	: Boolean = false;
		
		private var _bitmapData		: BitmapData
		
		private var _offsets			: Array;
		private var _offsetIncrements			: Array;
		
		public function PerlinNoiseBitmapDataMap( width:Number, height:Number, baseX:Number, baseY:Number, numOctaves:uint, randomSeed:int, stitch:Boolean, fractalNoise:Boolean, channelOptions:uint = 7, grayScale:Boolean = false, offsetIncrements:Array = null )
		{
			super();
			
			initialize( width, height, baseX, baseY, numOctaves, randomSeed, stitch, fractalNoise, channelOptions, grayScale, offsetIncrements )
		}
		
		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}
		
		public function update():void
		{
			var p:Point;
			var o:OffsetIncrement;
			for( var i:int = 0; i < _numOctaves; i++ )
			{
				p = Point( _offsets[ i ] );
				o = OffsetIncrement( _offsetIncrements[ i ] );
				p.x += o.xOffset;
				p.y += o.yOffset;
			}
			
			_bitmapData.perlinNoise( _baseX, _baseY, _numOctaves, _randomSeed, _stitch, _fractalNoise, _channelOptions, _grayScale, _offsets );
		}
		
		public function destroy():void
		{
			_bitmapData.dispose();
			_bitmapData = null;
		}
		
		private function initialize(  width:Number, height:Number, baseX:Number, baseY:Number, numOctaves:uint, randomSeed:int, stitch:Boolean, fractalNoise:Boolean, channelOptions:uint, grayScale:Boolean, offsetIncrements:Array ):void
		{
			_baseX = baseX;
			_baseY = baseY;
			_numOctaves = numOctaves;
			_randomSeed = randomSeed;
			_stitch = stitch;
			_fractalNoise = fractalNoise;
			_channelOptions = channelOptions;
			_grayScale = grayScale;
			
			if( !offsetIncrements ) offsetIncrements = new Array();
			
			_offsetIncrements = new Array();
			_offsets = new Array();
			for( var i:int = 0; i < numOctaves; i++ )
			{
				_offsets.push( new Point() );
				_offsetIncrements.push( new OffsetIncrement( offsetIncrements[ i ] ) );
			}
						
			_bitmapData = new BitmapData( width, height, false, 0x000000 );
		}
		
		
	}
}

internal class OffsetIncrement
{
	
	private var _xOffset	: Number = 0;
	private var _yOffset	: Number = 0;
	
	public function OffsetIncrement( offsetIncrements:Array )
	{
		initialize( offsetIncrements );
	}
	
	public function get xOffset():Number
	{
		return _xOffset;
	}
	
	public function get yOffset():Number
	{
		return _yOffset;
	}
	
	private function initialize( offsetIncrements:Array ):void
	{
		if( offsetIncrements )
		{
			_xOffset = ( isNaN( Number( offsetIncrements[ 0 ] ) ) ) ? 0 : Number( offsetIncrements[ 0 ] );
			_yOffset = ( isNaN( Number( offsetIncrements[ 1 ] ) ) ) ? 0 : Number( offsetIncrements[ 1 ] );
		}
	}
}