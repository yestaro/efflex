package org.efflex.mx.viewStackEffects.effectClasses
{
	import away3d.cameras.Camera3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.materials.BitmapMaterial;
	
	import flash.events.Event;
	
	import mx.core.UIComponent;


	public class Away3DTileEffectInstance extends TileTweenEffectInstance
	{
		
		public var zoom								: Number;
		public var focus							: Number;
		
		private var _scene							: Scene3D;
		private var _view3D							: View3D;
		private var _camera							: Camera3D;
		
		private var _bitmapMaterials				: Array;
		private var _snapShotTileBitmapMaterials	: Array;
		
		public function Away3DTileEffectInstance( target:UIComponent )
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
		
		public function get view3D():View3D
		{
			return _view3D;
		}
		
		public function getSnapShotBitmapMaterialTile( index:int, row:uint, column:uint ):BitmapMaterial
		{
			if( !_snapShotTileBitmapMaterials[ index ] ) _snapShotTileBitmapMaterials = createBitmapMaterialsForIndex( index );
			return BitmapMaterial( _snapShotTileBitmapMaterials[ row ][ column ]  );
		}
		
		public function getBitmapMaterialTileAt( index:int, row:uint, column:uint ):BitmapMaterial
		{
			if( index == -1 ) return getSnapShotBitmapMaterialTile( index, row, column );
			
			if( !_bitmapMaterials[ index ] ) _bitmapMaterials[ index ] = createBitmapMaterialsForIndex( index );
			return BitmapMaterial( _bitmapMaterials[ index ][ row ][ column ] );
		}
		
		override public function initEffect( event:Event ):void
	    {
	    	super.initEffect( event );
	    	
			_bitmapMaterials = data.bitmapMaterials;
			_snapShotTileBitmapMaterials = data.snapShotTileBitmapMaterials;
	    }
	    
	    override protected function createTileEffect():void
		{
			super.createTileEffect();
			
			_scene = new Scene3D();
			
			_camera = new Camera3D();
			_camera.z = -( ( _camera.zoom - 1 ) * _camera.focus );
			
			_view3D = new View3D();
			_view3D.scene = _scene;
			_view3D.camera = _camera;
			
			_view3D.x = contentWidth / 2;
			_view3D.y = contentHeight / 2;

			display.addChild( _view3D );
		}
		
		override protected function createContainers():void
		{
			super.createContainers();
			
			data.bitmapMaterials = new Array( viewStack.numChildren );
			data.snapShotTileBitmapMaterials = new Array();
		}
		
		protected function createBitmapMaterialsForIndex( index:int ):Array
		{
			var rows:Array = new Array();
			var columns:Array;
			var c:int;
			var r:int;
			for( r = 0; r < numRows; r++ )
			{
				columns = new Array();
				for( c = 0; c < numColumns; c++ )
				{
					columns.push( new BitmapMaterial( getBitmapDataTileAt( index, r, c ) ) );
				}
				rows.push( columns );
			}
			
			return rows;
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

	}
}