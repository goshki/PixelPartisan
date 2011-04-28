package pl.vigeo.partisan {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.*;
    import flash.filters.DropShadowFilter;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.ui.Mouse;
    import flash.utils.getTimer;
    
    public class PixelPartisan extends Sprite {
        protected var canvasWidth:int;
        protected var canvasHeight:int;
        
        protected var backgroundColor:uint = 0xFFFFFFFF;
        protected var brushColor:uint = 0xFF000000;
        
        protected var snapToPixels:Boolean = true;
        
        protected var zoomStatus:TextField;
        
        protected var zoomIndex:int;
        protected var zoomValues:Array = [ 1, 2, 3, 4, 5, 6, 7, 8 ];
        
        protected var paintingStatus:TextField;
        
        protected var painting:Boolean;
        
        protected var fpsCounter:TextField;
        
        protected var lastFpsCheckTime:int;
        protected var fpsCheckInterval:int = 500;
        protected var frames:int;
        
        public function PixelPartisan() {
            addEventListener( Event.ENTER_FRAME, initialize );
        }
        
        protected function initialize( event:Event ):void {
            if ( root == null ) {
                return;
            }
            removeEventListener( Event.ENTER_FRAME, initialize );
            configureStage();
            configureEventListeners();
            addFpsCounter();
            addPaintingStatus();
            addZoomStatus();
            addEventListener( Event.ENTER_FRAME, update );
        }
        
        protected function configureStage():void {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            stage.frameRate = 100;
        }
        
        protected function configureEventListeners():void {
            stage.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
            stage.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
            stage.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
            stage.addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
            stage.addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
            stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
            stage.addEventListener( KeyboardEvent.KEY_UP, onKeyUp );
            stage.addEventListener( Event.DEACTIVATE, onFocusLost );
            stage.addEventListener( Event.ACTIVATE, onFocus );
            stage.addEventListener( Event.RESIZE, onResize );
        }
        
        protected function addFpsCounter():void {
            fpsCounter = new TextField();
			fpsCounter.width = 80;
			fpsCounter.x = canvasWidth - fpsCounter.width;
			fpsCounter.height = 20;
			fpsCounter.selectable = false;
			fpsCounter.defaultTextFormat = new TextFormat( "Verdana", 11, 0x000000, true, null, null, null, null, "right", null,
			    2, null, 4 );
			fpsCounter.text = "FPS: 0";
			addChild( fpsCounter );
        }
        
        private function updateFps():void {
            var now:int = getTimer();
            frames++;
            if ( now < lastFpsCheckTime + fpsCheckInterval ) {
                return;
            }
            var fps:int = frames / ( now - lastFpsCheckTime ) * 1000.0;
            fpsCounter.text = "FPS: " + fps;
            lastFpsCheckTime = now;
            frames = 0;
        }
        
        private function updatePaintingStatus():void {
            paintingStatus.text = "Painting: " + ( painting ? "ON" : "OFF" );
        }
        
        protected function addPaintingStatus():void {
            paintingStatus = new TextField();
			paintingStatus.width = 150;
			paintingStatus.x = 0;
			paintingStatus.height = 20;
			paintingStatus.selectable = false;
			paintingStatus.defaultTextFormat = new TextFormat( "Verdana", 11, 0x000000, true, null, null, null, null, "left", 2,
			    null, null, 4 );
			paintingStatus.text = "Painting: OFF";
			addChild( paintingStatus );
        }
        
        private function updateUiPositions():void {
            fpsCounter.x = canvasWidth - fpsCounter.width;
        }
        
        protected function update( event:Event ):void {
            updateFps();
        }
        
        protected function resizeCanvas( width:int, height:int, crop:Boolean = false ):void {
            //trace( "Resizing canvas to: " + width + "x" + height + " " + ( crop ? "cropped" : "no crop" ) );
            updateUiPositions();
        }
        
        protected function applyBrush():void {
        }
        
        protected function addZoomStatus():void {
            zoomStatus = new TextField();
			zoomStatus.width = 150;
			zoomStatus.x = 0;
			zoomStatus.y = 16;
			zoomStatus.height = 20;
			zoomStatus.selectable = false;
			zoomStatus.defaultTextFormat = new TextFormat( "Verdana", 11, 0x000000, true, null, null, null, null, "left", 2,
			    null, null, 4 );
			zoomStatus.text = "Zoom: x1";
			addChild( zoomStatus );
        }
        
        private function updateZoomStatus():void {
            zoomIndex = Math.min( Math.max( zoomIndex, 0 ), zoomValues.length - 1 );
            zoomStatus.text = "Zoom: x" + zoomValues[zoomIndex];
        }
        
        private function zoomIn():void {
            zoomIndex++;
            updateZoomStatus();
        }
        
        private function zoomOut():void {
            zoomIndex--;
            updateZoomStatus();
        }
        
        protected function onMouseMove( event:MouseEvent = null ):void {
            if ( ( event != null ) && event.buttonDown ) {
                painting = true;
                updatePaintingStatus();
            }
        }
        

        protected function onMouseDown( event:MouseEvent ):void {
            onMouseMove( event );
        }
        
        protected function onMouseUp( event:MouseEvent ):void {
            painting = false;
            updatePaintingStatus();
        }
        
        protected function onKeyUp( event:KeyboardEvent ):void {
            var keyCode:int = event.keyCode;
            // http://www.webonweboff.com/tips/js/event_key_codes.aspx
			switch ( keyCode ) {
			    case 65: // A
			        zoomIn();
			        break;
			    case 83: // S
			        zoomOut();
			        break;
			}
        }
        
        protected function onKeyDown( event:KeyboardEvent ):void {
        }
        
        protected function onMouseOut( event:MouseEvent ):void {
        }
        
        protected function onMouseOver( event:MouseEvent ):void {
            Mouse.hide();
        }
        
        protected function onFocus( event:Event = null ):void {
            Mouse.hide();
        }
        
        protected function onFocusLost( event:Event = null ):void {
            Mouse.show();
        }
        
        protected function onResize( event:Event = null ):void {
            canvasWidth = stage.stageWidth;
            canvasHeight = stage.stageHeight;
            resizeCanvas( canvasWidth, canvasHeight );
        }
    }
}

