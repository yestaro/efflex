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

package org.efflex.mx.viewStackEffects.effectClasses
{
	import away3d.materials.TransformBitmapMaterial;
	import away3d.primitives.Cube;
	import away3d.primitives.data.CubeMaterialsData;
	
	import flash.display.BitmapData;
	
	import mx.core.UIComponent;
	
	import org.efflex.mx.viewStackEffects.CubeAway3D;

	public class CubeAway3DInstance extends Away3DEffectInstance
	{
		
		private const FRONT					: String = "FRONT";
		private const BACK					: String = "BACK";
		private const LEFT					: String = "LEFT";
		private const RIGHT					: String = "RIGHT";
		private const TOP					: String = "TOP";
		private const BOTTOM				: String = "BOTTOM";

		
		public var scaleDurationByChange	: Boolean = true;
		public var direction				: String;
		public var numSegmentsWidth			: int = 2;
		public var numSegmentsHeight		: int = 2;
		
		private var _cube					: Cube;
		private var _showingSelectedIndexTo	: Boolean;
		
		private var _rotationStart			: Number;
		private var _rotationDiff			: Number;
		
		private var _bitmapDatumSides		: Array;
		
		private var _hypotenuse				: Number;
		private var _zDifference			: Number;
		private var _zStart					: Number;
		
		private var _faceIndices				: FaceIndices;
		
		
		public function CubeAway3DInstance(target:UIComponent)
		{
			super( target );
		}
		
		override protected function setInturruptionParams():void
		{
			super.setInturruptionParams();
			
			var cubeRotation:Number;
			switch( direction )
			{
				case CubeAway3D.UP :
				{
					cubeRotation = Math.abs( _cube.rotationX );
					data.interruptedSelectedIndexFrom = ( cubeRotation > 90 ) ? _faceIndices.bottom.index : _faceIndices.back.index;
					data.interruptedSelectedIndexTo = ( cubeRotation > 90 ) ? _faceIndices.front.index : _faceIndices.bottom.index;
					break;
				}
				case CubeAway3D.DOWN :
				{
					cubeRotation = Math.abs( _cube.rotationX );
					data.interruptedSelectedIndexFrom = ( cubeRotation > 90 ) ? _faceIndices.top.index : _faceIndices.back.index;
					data.interruptedSelectedIndexTo = ( cubeRotation > 90 ) ? _faceIndices.front.index : _faceIndices.top.index;
					break;
				}
				case CubeAway3D.LEFT :
				{
					cubeRotation = Math.abs( _cube.rotationY );
					data.interruptedSelectedIndexFrom = ( cubeRotation > 90 ) ? _faceIndices.right.index : _faceIndices.back.index;
					data.interruptedSelectedIndexTo = ( cubeRotation > 90 ) ? _faceIndices.front.index : _faceIndices.right.index;
					break;
				}
				case CubeAway3D.RIGHT :
				{
					cubeRotation = Math.abs( _cube.rotationY );
					data.interruptedSelectedIndexFrom = ( cubeRotation > 90 ) ? _faceIndices.left.index : _faceIndices.back.index;
					data.interruptedSelectedIndexTo = ( cubeRotation > 90 ) ? _faceIndices.front.index : _faceIndices.left.index;
					break;
				}
			}
			
			data.interruptedRotationX = _cube.rotationX % 90;
			data.interruptedRotationY = _cube.rotationY % 90;
		}
		
		
		override protected function playViewStackEffect():void
        {
        	super.playViewStackEffect();
        	
			_faceIndices = new FaceIndices();
			_rotationStart = 0;
			var depth:Number;
			
			var directionMultiplier:int;
			switch( direction )
			{
				case CubeAway3D.DOWN :
				{
					directionMultiplier = 1;
					if( wasInterrupted )
					{
						_faceIndices.back = new FaceIndex( data.interruptedSelectedIndexFrom, false );
						_faceIndices.top = new FaceIndex( data.interruptedSelectedIndexTo, true );
						_faceIndices.front = new FaceIndex( selectedIndexTo, true );
						_rotationStart = data.interruptedRotationX;
					}
					else
					{
						_faceIndices.back = new FaceIndex( selectedIndexFrom, false );
						_faceIndices.top = new FaceIndex( selectedIndexTo, true );
					}
					depth = contentHeight;
					break;
				}
				case CubeAway3D.UP :
				{
					directionMultiplier = -1;
					
					if( wasInterrupted )
					{
						_faceIndices.back = new FaceIndex( data.interruptedSelectedIndexFrom, false );
						_faceIndices.bottom = new FaceIndex( data.interruptedSelectedIndexTo, false );
						_faceIndices.front = new FaceIndex( selectedIndexTo, true );
						_rotationStart = data.interruptedRotationX;
					}
					else
					{
						_faceIndices.back = new FaceIndex( selectedIndexFrom, false );
						_faceIndices.bottom = new FaceIndex( selectedIndexTo, false );
					}
					depth = contentHeight;
					break;
				}
				case CubeAway3D.LEFT :
				{
					directionMultiplier = 1;
					
					if( wasInterrupted )
					{
						_faceIndices.back = new FaceIndex( data.interruptedSelectedIndexFrom, false );
						_faceIndices.right = new FaceIndex( data.interruptedSelectedIndexTo, false );
						_faceIndices.front = new FaceIndex( selectedIndexTo, false );
						_rotationStart = data.interruptedRotationY;
					}
					else
					{
						_faceIndices.back = new FaceIndex( selectedIndexFrom, false );
						_faceIndices.right = new FaceIndex( selectedIndexTo, false );
					}
					depth = contentWidth;
					break;
				}
				case CubeAway3D.RIGHT :
				{
					directionMultiplier = -1;
					
					if( wasInterrupted )
					{
						_faceIndices.back = new FaceIndex( data.interruptedSelectedIndexFrom, false );
						_faceIndices.left = new FaceIndex( data.interruptedSelectedIndexTo, false );
						_faceIndices.front = new FaceIndex( selectedIndexTo, false );
						_rotationStart = data.interruptedRotationY;
					}
					else
					{
						_faceIndices.back = new FaceIndex( selectedIndexFrom, false );
						_faceIndices.left = new FaceIndex( selectedIndexTo, false );
					}
					depth = contentWidth;
					break;
				}
			}
			
			if( data.interruptedSelectedIndexFrom == selectedIndexTo )
			{
				_rotationDiff = -_rotationStart;
			}
			else if( data.interruptedSelectedIndexTo == selectedIndexTo )
			{
				_rotationDiff = ( 90 * directionMultiplier ) - _rotationStart
			}
			else
			{

				_rotationDiff = ( _rotationStart == 0 ) ? 90 * directionMultiplier : ( 180 * directionMultiplier ) - _rotationStart;
			}
			
			_zStart = depth / 2;
			_zDifference = ( viewStack.clipContent ) ? ( Math.sqrt( ( depth * depth ) * 2 ) - depth ) / 2 : 0;
			
			var cubeMaterials:CubeMaterialsData = new CubeMaterialsData();
			cubeMaterials.front = getAndRotateBitmapMaterial( _faceIndices.front );
			cubeMaterials.back = getAndRotateBitmapMaterial( _faceIndices.back );
			cubeMaterials.left = getAndRotateBitmapMaterial( _faceIndices.right );
			cubeMaterials.right = getAndRotateBitmapMaterial( _faceIndices.left );
			cubeMaterials.top = getAndRotateBitmapMaterial( _faceIndices.top );
			cubeMaterials.bottom = getAndRotateBitmapMaterial( _faceIndices.bottom );
			
			_cube = new Cube();
			_cube.width = contentWidth;
			_cube.height = contentHeight;
			_cube.depth = depth;
			_cube.segmentsW = numSegmentsWidth;
			_cube.segmentsH = numSegmentsHeight;
			
			_cube.cubeMaterials = cubeMaterials;
			_cube.name = "cube";
			_cube.z = _zStart;
			
			onTweenUpdate( 0 );
			scene.addChild( _cube );
			doubleRender();
			
			var changePercent:Number = Math.abs( _rotationDiff ) / 90;
			var targetDuration:Number = ( scaleDurationByChange ) ? duration *= changePercent : duration;
			tween = createTween( this, 0, 1, targetDuration );
        }
        
        protected function getAndRotateBitmapMaterial( faceIndex:FaceIndex ):TransformBitmapMaterial
		{
			if( !faceIndex ) return null;
			
			var transformBitmapMaterial:TransformBitmapMaterial = TransformBitmapMaterial( getBitmapMaterialAt( faceIndex.index ) );
			if( transformBitmapMaterial )
			{
				if( faceIndex.flip )
				{
					transformBitmapMaterial.scaleX = -1;
					transformBitmapMaterial.scaleY = -1;
					transformBitmapMaterial.offsetX = transformBitmapMaterial.width;
					transformBitmapMaterial.offsetY = transformBitmapMaterial.height;
				}
				else
				{
					transformBitmapMaterial.scaleX = 1;
					transformBitmapMaterial.scaleY = 1;
					transformBitmapMaterial.offsetX = 0;
					transformBitmapMaterial.offsetY = 0;
				}
			}
			return transformBitmapMaterial;
		}
		
        override protected function createBitmapMaterials():void
		{
			var child:UIComponent;
			var bitmapData:BitmapData;
			var bitmapMaterial:TransformBitmapMaterial;
			var numBitmapDatum:uint = bitmapDatum.length;
			for( var i:uint; i < numBitmapDatum; i++ )
			{
				bitmapData = bitmapDatum[ i ] as BitmapData;
				bitmapMaterial = bitmapMaterials[ i ] as TransformBitmapMaterial;
				if( !bitmapMaterial && bitmapData ) bitmapMaterials[ i ] = new TransformBitmapMaterial( bitmapData );
			}
		}
        
        
        override public function onTweenUpdate( value:Object ):void
		{
			super.onTweenUpdate( value );
			
			var targetRotation:Number = _rotationStart + ( _rotationDiff * Number( value ) );
					
			switch( direction )
			{
				case CubeAway3D.DOWN :
				case CubeAway3D.UP :
				{
					_cube.rotationX = targetRotation;
//					_cube.z = _zStart + ( _zDifference * Math.sin( MathUtil.degreesToRadians( _cube.rotationX * 2 ) ) );
					break;
				}
				case CubeAway3D.LEFT :
				case CubeAway3D.RIGHT :
				{
					_cube.rotationY = targetRotation;
//					_cube.z = _zStart + ( _zDifference * Math.sin( MathUtil.degreesToRadians( _cube.rotationY * 2 ) ) );
					break;
				}
			}
		}
		
//		public function getScaleAtZ( z:Number ):Number
//		{
//			return ( camera.focus * camera.zoom ) / ( camera.focus + ( z - camera.z ) );
//		}		
//
//		public function getZFromScale( scale:Number ):Number
//		{
//			return ( camera.focus * camera.zoom ) / scale - camera.focus + camera.z;
//		}
	}
}

class FaceIndices
{
	
	public var back		: FaceIndex;
	public var front	: FaceIndex;
	public var left		: FaceIndex;
	public var right	: FaceIndex;
	public var top		: FaceIndex;
	public var bottom	: FaceIndex;
	
	public function FaceIndices()
	{
	}

}

class FaceIndex
{
	
	public var _index		: int;
	public var _flip		: Boolean;
	
	public function FaceIndex( i:int, f:Boolean )
	{
		_index = i;
		_flip = f;
	}
	
	public function get index():int
	{
		return _index;
	}
	
	public function get flip():Boolean
	{
		return _flip;
	}

}
	

