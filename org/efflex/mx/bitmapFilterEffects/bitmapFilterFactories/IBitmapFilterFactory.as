package org.efflex.mx.bitmapFilterEffects.bitmapFilterFactories
{
	import flash.filters.BitmapFilter;

	public interface IBitmapFilterFactory
	{
		function newFilter( width:Number, height:Number ):BitmapFilter
		function update( filter:BitmapFilter, value:Number ):void
		function destroy():void
	}
}