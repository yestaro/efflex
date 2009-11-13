package org.efflex.mx.dataStackEffects.effectClasses
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import mx.controls.listClasses.IListItemRenderer;
	import mx.controls.listClasses.ListBase;
	import mx.core.UIComponent;

	public class MoveResizeToFromDisplayObjectInstance extends DataStackTweenEffectInstance
	{
		
		private var _effectTargets				: Array;
		private var _numTargets					: int;
		
		public var displayObjectFunction		: Function;
		
		public function MoveResizeToFromDisplayObjectInstance( target:UIComponent )
		{
			super( target );
		}
		
		override protected function setInturruptionParams():void
		{
			for( var i:int = 0; i < _numTargets; i++ )
			{
				EffectTarget( _effectTargets[ i ] ).setStartValuesToCurrentValues();
			}
			
			data.effectTargets = _effectTargets;
		}
		
		override protected function playDataStackEffect():void
		{
			super.playDataStackEffect();
			
			_effectTargets = ( wasInterrupted ) ? data.effectTargets as Array : new Array();
			
			addOrUpdateTarget( selectedIndexFrom, EffectTarget.HIDE );
			addOrUpdateTarget( selectedIndexTo, EffectTarget.SHOW );
			
			_numTargets = _effectTargets.length;
			
			var effectTarget:EffectTarget;
			for( var i:int = 0; i < _numTargets; i++ )
			{
				effectTarget = EffectTarget( _effectTargets[ i ] );
				effectTarget.setEndValuesByType( ( effectTarget.index == selectedIndexTo ) ? EffectTarget.SHOW : EffectTarget.HIDE );
				display.addChild( effectTarget.bitmap );
			}
			
			onTweenUpdate( 0 );
			
			tween = createTween( this, 0, 1, duration );
		}
		
		private function addOrUpdateTarget( index:int, type:String ):void
		{
			var effectTarget:EffectTarget;
			var numTargets:int = _effectTargets.length;
			for( var i:int = 0; i < numTargets; i++ )
			{
				effectTarget = EffectTarget( _effectTargets[ i ] );
				if( effectTarget.index == index )
				{
					if( type == EffectTarget.SHOW ) _effectTargets.push( _effectTargets.splice( i, 1 )[ 0 ] );
					return;
				}
			}
			
			effectTarget = new EffectTarget( this, index, type );
			effectTarget.bitmap.bitmapData = BitmapData( bitmapDatum[ index ] );
			_effectTargets.push( effectTarget );
		}
		
		override public function onTweenUpdate( value:Object ):void
		{
			super.onTweenUpdate( value );
			
			var num:Number = Number( value );
			
			for( var i:int = 0; i < _numTargets; i++ )
			{
				EffectTarget( _effectTargets[ i ] ).update( num );
			}
		}
	}
}


import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.geom.Point;
import org.efflex.mx.dataStackEffects.effectClasses.MoveResizeToFromDisplayObjectInstance;

internal class EffectTarget
{
	
	public static const SHOW				: String = "show";
	public static const HIDE				: String = "hide";
	
	private var _effectInstance		: MoveResizeToFromDisplayObjectInstance;
	
	private var _startPosition		: Point;
	private var _endPosition		: Point;
	private var _diffPosition		: Point;
	
	private var _startSize			: Point;
	private var _endSize			: Point;
	private var _diffSize			: Point;
	
	private var _index				: int;
	
	private var _bitmap				: Bitmap;
	
	public function EffectTarget( effectInstance:MoveResizeToFromDisplayObjectInstance, index:Number, type:String )
	{
		initialize( effectInstance, index, type );
	}
	
	public function get bitmap():Bitmap
	{
		return _bitmap;
	}
	
	public function get index():int
	{
		return _index;
	}
	
	public function update( value:Number ):void
	{
		_bitmap.x = _startPosition.x + ( _diffPosition.x * value );
		_bitmap.y = _startPosition.y + ( _diffPosition.y * value );
		
		_bitmap.width = _startSize.x + ( _diffSize.x * value );
		_bitmap.height = _startSize.y + ( _diffSize.y * value );
	}
	
	public function setStartValuesToCurrentValues():void
	{
		_startPosition = new Point( _bitmap.x, _bitmap.y );
		_startSize = new Point( _bitmap.width, _bitmap.height );
		
		createDifferences();
	}
	
	public function setEndValuesByType( type:String ):void
	{
		switch( type )
		{
			case SHOW :
			{
				_endPosition = new Point( _effectInstance.contentX, _effectInstance.contentY );
				_endSize = new Point( _effectInstance.contentWidth, _effectInstance.contentHeight );
				break;
			}
			case HIDE :
			{
				var displayObject:DisplayObject = _effectInstance.displayObjectFunction( index );
				
				if( displayObject )
				{
					_endPosition = displayObject.localToGlobal( new Point() ).subtract( _effectInstance.display.localToGlobal( new Point() ) );
					_endSize = new Point( displayObject.width, displayObject.height );
				}
				else
				{
					_endPosition = new Point( _effectInstance.contentX + (  _effectInstance.contentWidth / 2 ), _effectInstance.contentY + ( _effectInstance.contentHeight / 2 ) );
					_endSize = new Point( 0, 0 );
				}
				break;
			}
		}
		
		createDifferences();
	}
	
	private function initialize( effectInstance:MoveResizeToFromDisplayObjectInstance, index:Number, type:String ):void
	{
		_effectInstance = effectInstance;
		_index = index;
		
		_bitmap = new Bitmap();
		
		switch( type )
		{
			case SHOW :
			{
				var displayObject:DisplayObject = _effectInstance.displayObjectFunction( index );
				
				if( displayObject )
				{
					_startPosition = displayObject.localToGlobal( new Point() ).subtract( _effectInstance.display.localToGlobal( new Point() ) );
					_startSize = new Point( displayObject.width, displayObject.height );
				}
				else
				{
					_startPosition = new Point( _effectInstance.contentX + (  _effectInstance.contentWidth / 2 ), _effectInstance.contentY + ( _effectInstance.contentHeight / 2 ) );
					_startSize = new Point( 0, 0 );
				}
				break;
			}
			case HIDE :
			{
				_startPosition = new Point( _effectInstance.contentX, _effectInstance.contentY );
				_startSize = new Point( _effectInstance.contentWidth, _effectInstance.contentHeight );
				break;
			}
		}
	}
	
	private function createDifferences():void
	{
		_diffPosition = _endPosition.subtract( _startPosition );
		_diffSize = _endSize.subtract( _startSize );
	}
	
}