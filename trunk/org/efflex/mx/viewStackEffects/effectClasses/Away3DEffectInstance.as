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
	import away3d.cameras.Camera3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.base.Object3D;
	import away3d.materials.BitmapMaterial;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	
	import mx.core.UIComponent;

	public class Away3DEffectInstance extends ViewStackTweenEffectInstance
	{
		
		public var zoom						: Number;
		public var focus					: Number;
		
		private var _scene					: Scene3D;
		protected var _view3D				: View3D;
//		private var _renderer				: BasicRenderEngine;
		private var _camera					: Camera3D;
		private var _bitmapMaterials		: Array;
		
		public function Away3DEffectInstance( target:UIComponent )
		{
			super( target );
		}
		
		public function get camera():Camera3D
		{
			return _camera;
		}
		
		public function get scene():Scene3D
		{
			return _scene;
		}
		
//		public function setSize( w:Number, h:Number ):void
//		{
//			_view3D.width = w;
//			_view3D.height = h;
//			
////			_view3D.x = -( ( w - contentWidth ) / 2 );
////			_view3D.y = -( ( h - contentHeight ) / 2 );
//		}
		
		final public function get bitmapMaterials():Array
		{
			return data.bitmapMaterials as Array;
		}
		
		public function getBitmapMaterialAt( index:uint ):BitmapMaterial
		{
			return BitmapMaterial( data.bitmapMaterials[ index ] );
		}
		
		public function get interruptedBitmapMaterial( ):BitmapMaterial
		{
			return data.interruptedBitmapMaterial;
		}
		
		override public function initEffect( event:Event ):void
	    {
	    	super.initEffect( event );
	    	
	    	_scene = data.scene;
			_view3D = data.viewport;
			_camera = data.camera;
			_bitmapMaterials = data.bitmapMaterials;
	    }
	    
		override protected function createContainers():void
		{
			super.createContainers();
			
			_scene = new Scene3D();
			
			_camera = new Camera3D();
			_camera.z = -( ( _camera.zoom - 1 ) * _camera.focus );

			_view3D = new View3D();
			_view3D.scene = _scene;
			_view3D.camera = _camera;
			
			_view3D.x = contentWidth / 2;
			_view3D.y = contentHeight / 2;
			
			_bitmapMaterials = new Array( viewStack.numChildren );
			
			display.addChild( _view3D );
			
			data.scene = _scene;
			data.viewport = _view3D;
			data.camera = _camera;
			data.bitmapMaterials = _bitmapMaterials;
		}
		
		override public function onTweenUpdate( value:Object ):void
		{
			super.onTweenUpdate( value );
			
			render();
		}
		
		protected function doubleRender():void
		{
			render();
			render();
		}
		
		protected function render():void
		{
			_view3D.render();
		}
		
		override protected function createBitmapDatum():void
		{
			super.createBitmapDatum();
			
			createBitmapMaterials();
		}
		
		protected function createBitmapMaterials():void
		{
			var child:UIComponent;
			var bitmapData:BitmapData;
			var bitmapMaterial:BitmapMaterial;
			var numBitmapDatum:uint = bitmapDatum.length;
			for( var i:uint; i < numBitmapDatum; i++ )
			{
				bitmapData = bitmapDatum[ i ] as BitmapData;
				bitmapMaterial = _bitmapMaterials[ i ] as BitmapMaterial;
				if( !bitmapMaterial && bitmapData ) _bitmapMaterials[ i ] = new BitmapMaterial( bitmapData );
			}
		}
		
		override protected function takeSnapShot():void
		{
			super.takeSnapShot();
			
			createInterruptedBitmapMaterial();
		}
		
		protected function createInterruptedBitmapMaterial():void
		{
			data.interruptedBitmapMaterial = new BitmapMaterial( snapShot );
		}
		
		override public function finishEffect():void
		{
			super.finishEffect();
			
			_scene = null;
			_view3D = null;
			_camera = null;
		}
		
		override protected function removeChildren():void
        {
        	for each( var child:Object3D in scene.children )
        	{
				scene.removeChild( child );
        	}
			
			
        }
        
	}
}