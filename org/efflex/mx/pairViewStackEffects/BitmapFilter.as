package org.efflex.mx.pairViewStackEffects
{
	import mx.core.UIComponent;
	import mx.effects.IEffectInstance;
	
	import org.efflex.mx.pairViewStackEffects.effectClasses.BitmapFilterInstance;

	public class BitmapFilter extends PairViewStackTweenEffect
	{
		
		private static var AFFECTED_PROPERTIES	: Array = [ "alpha" ];
		
		[Inspectable(category="General", type="Array")]
		public var hideBitmapFilterFactories	: Array = new Array();
		
		[Inspectable(category="General", type="Array")]
		public var showBitmapFilterFactories	: Array = new Array();
		
		public function BitmapFilter( target:UIComponent=null )
		{
			super( target );
		
			instanceClass = BitmapFilterInstance;
		}
	
	
		override public function getAffectedProperties():Array
		{
			return AFFECTED_PROPERTIES;
		}
	
	
		override protected function initInstance( instance:IEffectInstance ):void
		{
			super.initInstance( instance );
	
			var effectInstance:BitmapFilterInstance = BitmapFilterInstance( instance );
			effectInstance.hideBitmapFilterFactories = hideBitmapFilterFactories;
			effectInstance.showBitmapFilterFactories = showBitmapFilterFactories;
		}
		
	}
}