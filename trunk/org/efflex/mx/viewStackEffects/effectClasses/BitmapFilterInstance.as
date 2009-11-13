/*
Copyright (c) 2008 Tink Ltd - http://www.tink.ws

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation 
the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions
of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

package org.efflex.mx.viewStackEffects.effectClasses
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.BitmapFilter;
	
	import mx.core.UIComponent;
	
	import org.efflex.mx.viewStackEffects.BitmapFilter;
	import org.efflex.mx.bitmapFilterEffects.bitmapFilterFactories.IBitmapFilterFactory;

	public class BitmapFilterInstance extends ViewStackTweenEffectInstance
	{
		
		public var effectTarget					: String;
		public var bitmapFilterFactories		: Array;
		
		private var _effectTarget				: Bitmap;
		private var _numFilters					: int;
		private var _filters					: Array;
		
		public function BitmapFilterInstance( target:UIComponent )
		{
			super( target );
		}
		
		protected function get __effectTarget():Bitmap
		{
			return _effectTarget;
		}
		
		override protected function playViewStackEffect():void
        {
        	super.playViewStackEffect();
        	
			var bitmapFrom:Bitmap = new Bitmap( snapShot );
			var bitmapTo:Bitmap = new Bitmap( BitmapData( bitmapDatum[ selectedIndexTo ] ) );
			
			switch( effectTarget )
			{
				case org.efflex.mx.viewStackEffects.BitmapFilter.NEXT_CHILD :
				{
					_effectTarget = bitmapTo;
					display.addChild( bitmapFrom );
					display.addChild( bitmapTo );
					break;
				}
				case org.efflex.mx.viewStackEffects.BitmapFilter.PREV_CHILD :
				{
					_effectTarget = bitmapFrom;
					display.addChild( bitmapTo );
					display.addChild( bitmapFrom );
					break;
				}
			}
	
			_filters = new Array();
			_numFilters = bitmapFilterFactories.length;
			for( var i:int = 0; i < _numFilters; i++ )
			{
				_filters.push( IBitmapFilterFactory( bitmapFilterFactories[ i ] ).newFilter( contentWidth, contentHeight ) );
			}
			
			onTweenUpdate( 0 );
			tween = createTween( this, 0, 1, duration );
        }
		
		override public function onTweenUpdate( value:Object ):void
		{
			super.onTweenUpdate( value );
			
			var v:Number = Number( value );
			for( var i:int = 0; i < _numFilters; i++ )
			{
				IBitmapFilterFactory( bitmapFilterFactories[ i ] ).update( flash.filters.BitmapFilter( _filters[ i ] ), v );
			}
			
			_effectTarget.filters = _filters;
		}
		
		override protected function destroyBitmapDatum():void
		{
			super.destroyBitmapDatum();
			
			for( var i:int = 0; i < _numFilters; i++ )
			{
				IBitmapFilterFactory( bitmapFilterFactories[ i ] ).destroy();
			}
		}
		
		
		
	}
}