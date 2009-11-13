package org.efflex.mx.pairViewStackEffects
{
	import mx.core.UIComponent;
	import mx.effects.IEffectInstance;
	
	import org.efflex.mx.pairViewStackEffects.effectClasses.FadeInstance;

	public class Fade extends PairViewStackTweenEffect
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
		
		public function Fade( target:UIComponent=null )
		{
			super( target );
		
			instanceClass = FadeInstance;
		}
	
	
		override public function getAffectedProperties():Array
		{
			return AFFECTED_PROPERTIES;
		}
	
	
		override protected function initInstance( instance:IEffectInstance ):void
		{
			super.initInstance( instance );
	
			var effectInstance:FadeInstance = FadeInstance( instance );
			effectInstance.hideAlphaFrom = hideAlphaFrom;
			effectInstance.hideAlphaTo = hideAlphaTo;
			effectInstance.showAlphaFrom = showAlphaFrom;
			effectInstance.showAlphaTo = showAlphaTo;
		}
		
	}
}