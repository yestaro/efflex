package org.efflex.mx.pairViewStackEffects
{
	import mx.core.UIComponent;
	import mx.effects.IEffectInstance;
	
	import org.efflex.mx.pairViewStackEffects.effectClasses.FadeBitmapFilterInstance;

	public class FadeBitmapFilter extends BitmapFilter
	{
		
		private static var AFFECTED_PROPERTIES	: Array = [ "alpha" ];
		
		[Inspectable(category="General", type="Number", defaultValue="1")]
		public var hideAlphaFrom				: Number = 1;
		
		[Inspectable(category="General", type="Number", defaultValue="0")]
		public var hideAlphaTo					: Number = 0;
		
		[Inspectable(category="General", type="Number", defaultValue="1")]
		public var showAlphaFrom				: Number = 0;
		
		[Inspectable(category="General", type="Number", defaultValue="0")]
		public var showAlphaTo					: Number = 1;
		
		public function FadeBitmapFilter( target:UIComponent=null )
		{
			super( target );
		
			instanceClass = FadeBitmapFilterInstance;
		}
	
	
		override public function getAffectedProperties():Array
		{
			return AFFECTED_PROPERTIES;
		}
	
	
		override protected function initInstance( instance:IEffectInstance ):void
		{
			super.initInstance( instance );
	
			var effectInstance:FadeBitmapFilterInstance = FadeBitmapFilterInstance( instance );
			effectInstance.hideAlphaFrom = hideAlphaFrom;
			effectInstance.hideAlphaTo = hideAlphaTo;
			effectInstance.showAlphaFrom = showAlphaFrom;
			effectInstance.showAlphaTo = showAlphaTo;
		}
		
	}
}