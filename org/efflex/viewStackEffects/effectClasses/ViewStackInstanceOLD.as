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

package ws.tink.flex.effects.viewStackEffects.effectClasses
{
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mx.containers.ViewStack;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.effects.effectClasses.TweenEffectInstance;
	
	import ws.tink.flex.effects.viewStackEffects.helpers.IViewStackEffectHelper;

	public class ViewStackInstanceOLD extends TweenEffectInstance
	{
		
		protected const HIDE						: String = "hide";
		protected const INTERRUPTED					: String = "interrupted";
		protected const SHOW						: String = "show";
		
		protected const HIDE_CONTENT_PANE_NAME							: String = "hideViewStackEffect";
		protected const SHOW_CONTENT_PANE_NAME							: String = "showViewStackEffect";

		protected const READY_FOR_HIDE_CONTENT_PANE_NAME					: String = "readyForHideViewStackEffect";
		protected const READY_FOR_SHOW_CONTENT_PANE_NAME					: String = "readyForShowViewStackEffect";
		
		protected const HIDE_AFTER_INTERRUPT_CONTENT_PANE_NAME			: String = "hideAfterInterruptViewStackEffect";
		protected const SHOW_AFTER_INTERRUPT_CONTENT_PANE_NAME			: String = "showAfterInterruptViewStackEffect";
		
		protected const READY_FOR_HIDE_AFTER_INTERRUPT_CONTENT_PANE_NAME	: String = "readyForHideAfterInterruptViewStackEffect";
		protected const READY_FOR_SHOW_AFTER_INTERRUPT_CONTENT_PANE_NAME	: String = "readyForShowAfterInterruptViewStackEffect";
		
		public var hideTarget						: Boolean;
		public var transparent						: Boolean;
		
		private var _prevBlendMode					: String;
		protected var _bitmaps						: Array;
		private var _viewStack						: ViewStack;
		private var _helper							: IViewStackEffectHelper;
		protected var _contentPane					: MovieClip;
		private var _mask							: Sprite;
		private var _trigger						: String;
		private var _wasInterrupted					: Boolean;
		
		public function ViewStackInstance( target:UIComponent )
		{
			super( target );
			
			if( target.parent is ViewStack )
			{
				_viewStack = ViewStack( target.parent );
			}
			else
			{
				throw new Error( "ViewStackInstance must have a target with a parent property that is a ViewStack or is a subclass of ViewStack" );
			}
		}
		
		final protected function get bitmaps():Sprite
		{
			if( _bitmaps ) return _bitmaps;

			_bitmaps = Sprite( _contentPane.getChildByName( "bitmaps" ) );
			return _bitmaps;
		}
		
		final protected function get viewStack():ViewStack
		{
			return _viewStack;
		}
		
		final protected function get selectedIndexTo():int
		{
			return _viewStack.selectedIndex;// : _viewStack.getChildIndex( DisplayObject( target ) );
		}
		
		final protected function get selectedIndexFrom():int
		{
			return _contentPane.tabIndex;
		}
		
		final protected function get wasInterrupted():Boolean
		{
			return _wasInterrupted;// : _viewStack.getChildIndex( DisplayObject( target ) );
		}
		
		final protected function get contentX():Number
		{
			return _helper.contentX;
		}
		
		final protected function get contentY():Number
		{
			return _helper.contentY;
		}
		
		final protected function get contentWidth():Number
		{
			return _helper.contentWidth;
		}
		
		final protected function get contentHeight():Number
		{
			return _helper.contentHeight;
		}
		
		final protected function get trigger():String
		{
			return _trigger;
		}
		
		final public function set helper( Helper:Class ):void
        {
            _helper = IViewStackEffectHelper( new Helper( _viewStack ) );
        }
        
		override public function initEffect( event:Event ):void
	    {
	    	retrieveContainers();
			
			switch( _contentPane.name )
			{
				case READY_FOR_SHOW_CONTENT_PANE_NAME :
				{
					_contentPane.name = SHOW_CONTENT_PANE_NAME;
					_trigger = SHOW;
					break;
				}
				case READY_FOR_HIDE_CONTENT_PANE_NAME :
				{
					_contentPane.name = HIDE_CONTENT_PANE_NAME;			
					_trigger = HIDE;
					break;
				}
				case READY_FOR_HIDE_AFTER_INTERRUPT_CONTENT_PANE_NAME :
				{
					_contentPane.name = HIDE_AFTER_INTERRUPT_CONTENT_PANE_NAME;
					_trigger = INTERRUPTED;
					_wasInterrupted = true;
					break;
				}
				case READY_FOR_SHOW_AFTER_INTERRUPT_CONTENT_PANE_NAME :
				{
					_contentPane.name = SHOW_AFTER_INTERRUPT_CONTENT_PANE_NAME;
					_trigger = SHOW;
					_wasInterrupted = true;
					break;
				}
			}
	    	
	    	super.initEffect( event );
	    }
	    
	    override public function startEffect():void
		{
			if( hideTarget ) applyEraseBlendMode( true );
			
			startViewStackEffectType();
			
			super.startEffect();
		}
		
	    override public function play():void
        {
			switch( _trigger )
			{
				case INTERRUPTED :
				case HIDE :
				{
					_viewStack.callLater( onTweenEnd, [ 0 ] );
					break;
				}
				case SHOW :
				{
					playViewStackEffect();
					break;
				}
			}
			
			
			super.play();
        }
        
        protected function startViewStackEffectType():void
		{
			// Overriden in subclass.
		}

        protected function createBitmaps():void
		{
			// Overriden in subclass.
		}
		
		protected function startViewStackEffect():void
		{
			// Overriden in subclass.
		}
		
		protected function playViewStackEffect():void
		{
			// Overriden in subclass.
		}
		
		protected function onViewStackEffectUpdate( value:Object ):void
		{
			// Overriden in subclass.
		}

	    private function retrieveContainers():void
		{
			_contentPane = _viewStack.rawChildren.getChildByName( READY_FOR_HIDE_AFTER_INTERRUPT_CONTENT_PANE_NAME ) as MovieClip;
			if( _contentPane ) return retrieveContainerChildren();

			_contentPane = _viewStack.rawChildren.getChildByName( READY_FOR_SHOW_AFTER_INTERRUPT_CONTENT_PANE_NAME ) as MovieClip;
			if( _contentPane ) return retrieveContainerChildren();
			
			_contentPane = _viewStack.rawChildren.getChildByName( READY_FOR_SHOW_CONTENT_PANE_NAME ) as MovieClip;
			if( _contentPane ) return retrieveContainerChildren();
			
			_contentPane = _viewStack.rawChildren.getChildByName( READY_FOR_HIDE_CONTENT_PANE_NAME ) as MovieClip;
			if( _contentPane ) return retrieveContainerChildren();
			
			createContainers();
		}
		
		protected function retrieveContainerChildren():void
		{
			_bitmaps = Sprite( _contentPane.getChildByName( "bitmaps" ) );
			
			var mask:DisplayObject = _contentPane.getChildByName( "mask" );
			if( mask ) _mask = Sprite( mask );
		}
		
		protected function createContainers():void
		{
			var containerContentPane:Sprite = _viewStack.mx_internal::contentPane;
			
			_contentPane = new MovieClip();
			_contentPane.name = READY_FOR_HIDE_CONTENT_PANE_NAME;
			_contentPane.tabIndex = _viewStack.getChildIndex( DisplayObject( target ) );
			_contentPane.x = ( containerContentPane ) ? containerContentPane.x : 0;
			_contentPane.y = ( containerContentPane ) ? containerContentPane.y : 0;
			
			if( _viewStack.clipContent )
			{
				_mask = new Sprite();
				_mask.name = "mask";
				_mask.graphics.beginFill( 0x666666, 1 );
				_mask.graphics.drawRect( contentX, contentY, contentWidth, contentHeight );
			
				_contentPane.mask = _mask;
				
				_contentPane.addChild( _mask );
			}

			_bitmaps = new Sprite();
			_bitmaps.name = "bitmaps";

			_contentPane.addChild( _bitmaps );

			_viewStack.rawChildren.addChild( _contentPane );
		}
		
		override public function onTweenUpdate( value:Object ):void
		{
			if( _trigger == SHOW ) onViewStackEffectUpdate( value );
		}
		
		override public function end():void
		{
			_contentPane.name = READY_FOR_HIDE_AFTER_INTERRUPT_CONTENT_PANE_NAME;
			_trigger = INTERRUPTED;
			
			super.end();
		}
		
		override public function finishEffect():void
		{
			super.finishEffect();

			switch( _contentPane.name )
			{
				case HIDE_CONTENT_PANE_NAME :
				{
					_contentPane.name = READY_FOR_SHOW_CONTENT_PANE_NAME;
					break;	
				}
				case HIDE_AFTER_INTERRUPT_CONTENT_PANE_NAME :
				{
					_contentPane.name = READY_FOR_SHOW_AFTER_INTERRUPT_CONTENT_PANE_NAME;
					break;	
				}
				case SHOW_AFTER_INTERRUPT_CONTENT_PANE_NAME :
				case SHOW_CONTENT_PANE_NAME :
				{
					_contentPane.removeChild( bitmaps );
					
					if( _contentPane.mask ) _contentPane.removeChild( _contentPane.getChildByName( "mask" ) );
	
					_viewStack.rawChildren.removeChild( _contentPane );
					_contentPane = null;
					break;
				}
			}
			
			if( hideTarget ) applyEraseBlendMode( false );
		}
		
		protected function destroyBitmaps():void
		{
			var bitmap:Bitmap;
			var numBitmaps:int = _bitmaps.numChildren;
			for( var i:int = 0; i < numBitmaps; i++ )
			{
				bitmap = Bitmap( bitmaps.removeChildAt( 0 ) );
				bitmap.bitmapData.dispose();
				bitmap = null;
			}
			
			_bitmaps = null;
		}
		
		private function applyEraseBlendMode( value:Boolean ):void
		{
			if( value )
			{
				_prevBlendMode = target.blendMode;
				target.blendMode = BlendMode.ERASE;
			}
			else
			{
				target.blendMode = _prevBlendMode;
			}
		}
	}
}