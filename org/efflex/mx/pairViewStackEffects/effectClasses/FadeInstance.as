package org.efflex.mx.pairViewStackEffects.effectClasses
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import mx.core.UIComponent;
	
	import org.efflex.utils.TweenUtil;

	public class FadeInstance extends PairViewStackTweenEffectInstance
	{
		
		public var hideAlphaFrom				: Number;
		public var hideAlphaTo					: Number;
		public var showAlphaFrom				: Number;
		public var showAlphaTo					: Number;
		
		public function FadeInstance( target:UIComponent )
		{
			super( target );
		}
		
		override protected function playPairViewStackEffect():void
        {
        	super.playPairViewStackEffect();
        	
			_hidding = new Bitmap( snapShot );
			_showing = new Bitmap( BitmapData( bitmapDatum[ selectedIndexTo ] ) );
        }
        
        override protected function onPairTweenUpdate( hideValue:Number, showValue:Number ):void
		{
			super.onPairTweenUpdate( hideValue, showValue );
			
			_hidding.alpha = TweenUtil.normalizeValue( 0, 1, hideValue, hideAlphaFrom, hideAlphaTo );
			_showing.alpha = TweenUtil.normalizeValue( 0, 1, showValue, showAlphaFrom, showAlphaTo );
		}
		
	}
}