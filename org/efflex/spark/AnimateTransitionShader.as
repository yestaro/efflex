package org.efflex.spark
{
	import mx.effects.IEffectInstance;
	
	import spark.effects.AnimateTransitionShader;
	import org.efflex.spark.supportClasses.AnimateTransitionShaderInstance;
	import org.efflex.spark.utils.InterruptedEffect;
	
	public class AnimateTransitionShader extends spark.effects.AnimateTransitionShader
	{
		
		private var _interruptedEffects		: Vector.<InterruptedEffect>;
		
		public function AnimateTransitionShader(target:Object=null)
		{
			super(target);
			_interruptedEffects = new Vector.<InterruptedEffect>();
			instanceClass = AnimateTransitionShaderInstance;
		}
		
		public function addInturruptedEffect( value:InterruptedEffect ):void
		{
			_interruptedEffects.push( value );
		}
			
		override protected function initInstance( instance:IEffectInstance ):void
		{
			super.initInstance( instance );
			
			
			var animateTransitionShaderInstance:AnimateTransitionShaderInstance = AnimateTransitionShaderInstance( instance );
			animateTransitionShaderInstance.factory = this;
			
			var numInterruptedEffect:int = _interruptedEffects.length;
			for( var i:int = 0; i < numInterruptedEffect; i++ )
			{
				if( _interruptedEffects[ i ].target == instance.target )
				{
					animateTransitionShaderInstance.interruptedEffect = _interruptedEffects.splice( i, 1 )[ 0 ];
					break;
				}
			}
			
		}
	}
}