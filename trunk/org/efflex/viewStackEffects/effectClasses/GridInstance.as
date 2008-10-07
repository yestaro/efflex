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

package org.efflex.viewStackEffects.effectClasses
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import mx.core.UIComponent;
	
	
	public class GridInstance extends ViewStackInstance
	{
		
		public var numColumns 			: uint;
		
		public function GridInstance( target:UIComponent )
		{
			super( target );
		}
		
		override public function play():void
        {
			var row:int = Math.floor( selectedIndexTo / numColumns );
			var column:int = selectedIndexTo % numColumns;
			
			var toX:Number = -( contentWidth * column );
			var toY:Number =  -( contentHeight * row );
				
			switch( state )
			{
				case HIDING :
				{
					var child:Bitmap = new Bitmap();
					child.bitmapData = BitmapData( bitmapDatum[ selectedIndexFrom ] );
					child.x = contentX;
					child.y = contentY;
					display.addChildAt( child, 0 );
					
					viewStack.callLater( onTweenEnd, [ 0 ] );
					break;
				}
				case SHOWING :
				{
					display.y = -contentHeight * Math.floor( selectedIndexFrom / numColumns );
					display.x = -contentWidth * ( selectedIndexFrom % numColumns );
					
					createGrid();
					tween = createTween( this, new Array( display.x, display.y ), new Array( toX, toY ), duration );
					break;					
				}
				case HIDING_AFTER_INTERRUPT :
				{
					createGrid();
					viewStack.callLater( onTweenEnd, [ 0 ] );
					break;
				}
				case SHOWING_AFTER_INTERRUPT :
				{
					createGrid();
					tween = createTween( this, new Array( display.x, display.y ), new Array( toX, toY ), duration );
					break;						
				}
        	}
			
			super.play();
        }
		
		override public function onTweenUpdate( value:Object ):void
		{
			super.onTweenUpdate( value );
			
			switch( state )
			{
				case SHOWING :
				case SHOWING_AFTER_INTERRUPT :
				{
					display.x = Number( value[ 0 ] );
					display.y = Number( value[ 1 ] );
				}
			}
		}
		
		private function createGrid():void
		{
			var child:Bitmap;
			var numChildren:uint = viewStack.numChildren;
			var row:uint = 0;
			var column:uint = 0;
			var i:uint;
			
			for( i = 0; i < numChildren; i++ )
			{
				child = new Bitmap();
				child.bitmapData = BitmapData( bitmapDatum[ i ] );
				child.x = contentX + ( contentWidth * column );
				child.y = contentY + ( contentHeight * row );
				display.addChild( child );
				
				if( column == numColumns - 1 )
				{
					column = 0;
					row++;
				}
				else
				{
					column++;
				}
			}
		}
		
	}
}