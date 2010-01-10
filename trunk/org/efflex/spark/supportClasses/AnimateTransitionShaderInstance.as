package org.efflex.spark.supportClasses
{
	import flash.display.BitmapData;
	
	import mx.core.IUIComponent;
	import mx.core.mx_internal;
	
	import spark.effects.Animate;
	import spark.effects.animation.Animation;
	import spark.effects.animation.Keyframe;
	import spark.effects.animation.MotionPath;
	import spark.effects.supportClasses.AnimateTransitionShaderInstance;
	import spark.primitives.supportClasses.GraphicElement;
	import spark.utils.BitmapUtil;
	import org.efflex.spark.AnimateTransitionShader;
	import org.efflex.spark.utils.InterruptedEffect;
	
	use namespace mx_internal;
	
	public class AnimateTransitionShaderInstance extends spark.effects.supportClasses.AnimateTransitionShaderInstance
	{
		
		public var factory					: AnimateTransitionShader;
		public var _interrupted				: Boolean;
		public var _interruptedEffect		: InterruptedEffect;
		
		public function AnimateTransitionShaderInstance(target:Object)
		{
			super(target);
		}
		
		public function set interruptedEffect( value:InterruptedEffect ):void
		{
			_interruptedEffect = value;
		}
		
		override public function end():void
		{
			_interrupted = true;
			
			var bmData:BitmapData
			if (target is GraphicElement)
			{
				bmData = GraphicElement(target).captureBitmapData(true, 0, false);
			}
			else
			{
				bmData = BitmapUtil.getSnapshot(IUIComponent(target));
			}
			
			factory.addInturruptedEffect( new InterruptedEffect( target, bmData, { progress: shader.data.progress.value } ) );
			super.end();
		}
		
		override protected function setValue( property:String, value:Object ):void
		{
			if( _interrupted ) return;
			super.setValue( property, value );
		}
		
		
		override public function play():void
		{
			if( _interruptedEffect ) bitmapFrom = _interruptedEffect.snapshot;
			
			super.play();
		}
		
		private function cleanup():void
		{
			if( _interruptedEffect ) bitmapFrom.dispose();
		}
		
		/**
		 * @private
		 */
		override public function animationEnd(animation:Animation):void
		{
			cleanup();
			super.animationEnd(animation);
		}
		
		/**
		 * @private
		 */
		override public function animationStop(animation:Animation):void
		{
			cleanup();
			super.animationStop(animation);
		}
	}
}