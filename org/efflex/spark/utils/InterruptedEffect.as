package org.efflex.spark.utils
{
	import flash.display.BitmapData;

	public class InterruptedEffect
	{
		
		private var _target		: Object;
		private var _properties	: Object;
		private var _snapshot	: BitmapData;
		
		public function InterruptedEffect( target:Object, snapshot:BitmapData, properties:Object )
		{
			_target = target;
			_snapshot = snapshot;
			_properties = properties;
		}
		
		public function get target():Object
		{
			return _target;
		}
		
		public function get snapshot():BitmapData
		{
			return _snapshot;
		}
		
		public function get properties():Object
		{
			return _properties;
		}
	}
}