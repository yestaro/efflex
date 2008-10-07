package ws.tink.flex.effects.effectClasses
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Matrix;
	
	import mx.core.UIComponent;
	
	import ws.tink.flex.effects.TileEffect;

	public class TileInstance extends BitmapInstance
	{
		
		public var numRows					: int = 5;
		public var numColumns				: int = 5;
		public var tileDurationPercent		: Number;
		public var order					: String;
		
		private var _tweenValue				: Number;
		private var _tileValues				: Array;
		
		private var _tileWidth			: Number;
		private var _tileHeight			: Number;
		
		
		public function TileInstance( target:UIComponent )
		{
			super( target );
		}
		
		public function get tileWidth():Number
		{    	
			return _tileWidth;
		}
		
		public function get tileHeight():Number
		{    	
			return _tileHeight;
		}
		
		public function getTileAt( column:uint, row:uint ):Bitmap
		{
			return Bitmap( display.getChildAt( column + ( numColumns * row ) ) );
		}
		
		public function getTileValueAt( column:uint, row:uint ):Number
		{
			var value:Number = Number( _tileValues[ row ][ column ] ) + _tweenValue;
			if( value < 0 ) return 0;
			if( value > 1 ) return 1;
			return value;
		}
		
		override public function initEffect( event:Event ):void
		{
			var t:UIComponent = UIComponent( target );
			
			_tileWidth = t.width / numColumns;
			_tileHeight = t.height / numRows;
			
			var leftOverPerTile:Number = tileDurationPercent / ( ( numColumns * numRows ) - 1 )
			
			_tweenValue = 0;

			var r:uint = 0;
			var c:uint = 0;
			var row:Array;
			var i:int = 0;
			_tileValues = new Array();
			
			switch( order )
			{
				case TileEffect.RANDOM :
				{
					var random:Array = new Array();
					for( r = 0; r < numRows; r++ )
					{
						row = new Array();
						for( c = 0; c < numColumns; c++ )
						{
							row.push( null );
							random.push( { row: r, column: c } );
						}
						_tileValues.push( row );
					}
					
					var randomIndex:Number;
					var rowColumn:Object;
					for( r = 0; r < numRows; r++ )
					{
						for( c = 0; c < numColumns; c++ )
						{
							randomIndex = Math.floor( Math.random() * random.length );
							if( randomIndex == random.length ) randomIndex--;
							rowColumn = random.splice( randomIndex, 1 )[ 0 ];
							_tileValues[ rowColumn.row ][ rowColumn.column ] = 0 - ( leftOverPerTile * i );
							i++;
						}
					}
					break;
				}
				case TileEffect.BOTTOM_LEFT_TO_TOP_RIGHT :
				{
					for( r = 0; r < numRows; r++ )
					{
						row = new Array();
						for( c = 0; c < numColumns; c++ )
						{
							row.push( 0 - ( leftOverPerTile * i ) );
							i++;
						}
						_tileValues.unshift( row );
						
					}
					break;
				}
				case TileEffect.BOTTOM_RIGHT_TO_TOP_LEFT :
				{
					for( r = 0; r < numRows; r++ )
					{
						row = new Array();
						for( c = 0; c < numColumns; c++ )
						{
							row.unshift( 0 - ( leftOverPerTile * i ) );
							i++;
						}
						_tileValues.unshift( row );
						
					}
					break;
				}
				case TileEffect.TOP_LEFT_TO_BOTTOM_RIGHT :
				{
					for( r = 0; r < numRows; r++ )
					{
						row = new Array();
						for( c = 0; c < numColumns; c++ )
						{
							row.push( 0 - ( leftOverPerTile * i ) );
							i++;
						}
						_tileValues.push( row );
						
					}
					break;
				}
				case TileEffect.TOP_RIGHT_TO_BOTTOM_LEFT :
				{
					for( r = 0; r < numRows; r++ )
					{
						row = new Array();
						for( c = 0; c < numColumns; c++ )
						{
							row.unshift( 0 - ( leftOverPerTile * i ) );
							i++;
						}
						_tileValues.push( row );
						
					}
					break;
				}
			}
					
			super.initEffect( event );
			
			createTiles();
		}
		
		override protected function createBitmapDatum():void
		{
			super.createBitmapDatum();
			
			var bitmapData:BitmapData;
			
			var matrix:Matrix = new Matrix();
			var t:UIComponent = UIComponent( target );
			for( var r:int = 0; r < numRows; r++ )
			{
				for( var c:int = 0; c < numColumns; c++ )
				{
					matrix.identity();
					matrix.translate( -( tileWidth * c ), -( tileHeight * r ) )
					bitmapData = new BitmapData( tileWidth, tileHeight, transparent, ( transparent ) ? 0x00000000 : 0xFF0000 );
					bitmapData.draw( t, matrix );

					bitmapDatum.push( bitmapData );
				}
			}
		}
		
		protected function createTiles():void
		{
			var i:int = 0;
			var bitmap:Bitmap;
			for( var r:int = 0; r < numRows; r++ )
			{
				for( var c:int = 0; c < numColumns; c++ )
				{
					bitmap = new Bitmap();
					bitmap.bitmapData = BitmapData( bitmapDatum[ i ] );
					bitmap.x = c * tileWidth;
					bitmap.y = r * tileHeight;
					
					display.addChild( bitmap );
					
					i++;
				}
			}
		}
		
		override public function play():void
        {
        	super.play();

			tween = createTween( this, 0, 1, duration );
        }
        
        override public function onTweenUpdate( value:Object ):void
		{
			super.onTweenUpdate( value );
			
			_tweenValue = Number( value ) * ( 1 + tileDurationPercent );
		}
		
		
//		
//		
//		override public function onTweenUpdate( value:Object ):void
//		{
//			super.onTweenUpdate( value );
//			
//			var o:Object;
//			var v:Number = Number( value );
//			var i:int = 0;
//			var tile:Bitmap;
//			for( var r:int = 0; r < numRows; r++ )
//			{
//				for( var c:int = 0; c < numColumns; c++ )
//				{
//					o = test[ i ];
//					
//					tile = getTileAt( c, r );
////					bitmap.filters = new Array( new BlurFilter( 0, o.v / 100, 2 ) );
////					bitmap.bitmapData.applyFilter( bitmap.bitmapData, bitmap.bitmapData.rect, new Point( 0, 0 ), new BlurFilter( 20, 20, 3 ) );
//					tile.y += o.v * 0.1;
//					tile.rotation += o.rv
//					o.v += 8
//					
////					bitmap.scaleY -= ( bitmap.scaleY - 0.4 ) / 10;
////					bitmap.scaleX -= ( bitmap.scaleY - 0.4 ) / 10;
//					
////					bitmap.alpha = 1 - ( v / _durations[ i ] );
//					i++;
//				}
//			}
//			
//		}
		
	}
}