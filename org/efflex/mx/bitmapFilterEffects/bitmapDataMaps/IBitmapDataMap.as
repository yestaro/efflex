package org.efflex.mx.bitmapFilterEffects.bitmapDataMaps
{
	import flash.display.BitmapData;

	public interface IBitmapDataMap
	{
		
		function get bitmapData():BitmapData
		function update():void
		function destroy():void
			
	}
}