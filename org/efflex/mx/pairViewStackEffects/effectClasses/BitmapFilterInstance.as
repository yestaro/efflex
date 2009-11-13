package org.efflex.mx.pairViewStackEffects.effectClasses
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.BitmapFilter;
	
	import mx.core.UIComponent;
	
	import org.efflex.mx.bitmapFilterEffects.bitmapFilterFactories.IBitmapFilterFactory;

	public class BitmapFilterInstance extends PairViewStackTweenEffectInstance
	{
		
		public var hideBitmapFilterFactories	: Array;
		public var showBitmapFilterFactories	: Array;
		
		private var _numHideFilters				: int;
		private var _hideFilters				: Array;
		
		private var _numShowFilters				: int;
		private var _showFilters				: Array;
		
		public function BitmapFilterInstance( target:UIComponent )
		{
			super( target );
		}
		
		override protected function playPairViewStackEffect():void
        {
        	super.playPairViewStackEffect();
        	
			_hidding = new Bitmap( snapShot );
			_showing = new Bitmap( BitmapData( bitmapDatum[ selectedIndexTo ] ) );
			
			var i:int;
			
			_hideFilters = new Array();
			_numHideFilters = hideBitmapFilterFactories.length;
			for( i = 0; i < _numHideFilters; i++ )
			{
				_hideFilters.push( IBitmapFilterFactory( hideBitmapFilterFactories[ i ] ).newFilter( contentWidth, contentHeight ) );
			}
			
			_showFilters = new Array();
			_numShowFilters = showBitmapFilterFactories.length;
			for( i = 0; i < _numShowFilters; i++ )
			{
				_showFilters.push( IBitmapFilterFactory( showBitmapFilterFactories[ i ] ).newFilter( contentWidth, contentHeight ) );
			}
        }
        
        override protected function onPairTweenUpdate( hideValue:Number, showValue:Number ):void
		{
			super.onPairTweenUpdate( hideValue, showValue );
			
			var i:int;
			
			for( i = 0; i < _numHideFilters; i++ )
			{
				IBitmapFilterFactory( hideBitmapFilterFactories[ i ] ).update( flash.filters.BitmapFilter( _hideFilters[ i ] ), hideValue );
			}
			
			for( i = 0; i < _numShowFilters; i++ )
			{
				IBitmapFilterFactory( showBitmapFilterFactories[ i ] ).update( flash.filters.BitmapFilter( _showFilters[ i ] ), showValue );
			}
			
			_hidding.filters = _hideFilters;
			_showing.filters = _showFilters;
		}
		
		override protected function destroyBitmapDatum():void
		{
			super.destroyBitmapDatum();
			
			var i:int;
			
			for( i = 0; i < _numHideFilters; i++ )
			{
				IBitmapFilterFactory( hideBitmapFilterFactories[ i ] ).destroy();
			}
			
			for( i = 0; i < _numShowFilters; i++ )
			{
				IBitmapFilterFactory( showBitmapFilterFactories[ i ] ).destroy();
			}
		}
		
	}
}