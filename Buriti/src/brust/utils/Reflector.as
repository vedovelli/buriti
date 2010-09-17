package brust.utils
{
import flash.display.BitmapData;
import flash.display.GradientType;
import flash.display.Sprite;
import flash.events.Event;
import flash.filters.BitmapFilter;
import flash.filters.BitmapFilterQuality;
import flash.filters.BlurFilter;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

import mx.core.UIComponent;
import mx.events.FlexEvent;
import mx.events.MoveEvent;
import mx.events.ResizeEvent;

/**
 * A component that displays a reflection below another component. 
 * The reflection is "live"--as the other component's display updates,
 * the reflection updates as well.  The reflection automatically positions
 * itself below the target component (so it only works if the target
 * component's container is absolutely positioned, like a Canvas or a
 * Panel with layout="absolute").
 * 
 */
public class Reflector extends UIComponent
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	public function Reflector()
	{
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	// Cached bitmap data objects. We store these to avoid reallocating
	// bitmap data every time the target redraws.
	private var _alphaGradientBitmap:BitmapData;
	private var _targetBitmap:BitmapData;
	private var _resultBitmap:BitmapData;
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  blurAmount
	//---------------------------------- 
	private var _blurAmount:Number = 0.5;
	
	/**
	 * @public
	 * How much of the component to distortion, between 0 and 1; 0 means not to
	 * distortion. The default is 0.5
	 */ 
	
	[Bindable]
	public function get blurAmount():Number 
	{
		return _blurAmount;
	}
	
	public function set blurAmount(value: Number):void 
	{
		_blurAmount = value;
		
		// Clear the cached gradient bitmap, since we need to regenerate it to
		// reflect the new falloff value.
		_alphaGradientBitmap = null;
		
		invalidateDisplayList();
	}
	
	//----------------------------------
	//  falloff
	//---------------------------------- 
	private var _falloff:Number = 0.6;
	
	/**
	 * @public
	 * How much of the component to reflect, between 0 and 1; 0 means not to
	 * reflect any of the component, while 1 means to reflect the entire
	 * component.  The default is 0.6.
	 */
	[Bindable]
	public function get falloff():Number 
	{
		return _falloff;
	}
	
	public function set falloff(value: Number):void 
	{
		_falloff = value;
		
		// Clear the cached gradient bitmap, since we need to regenerate it to
		// reflect the new falloff value.
		_alphaGradientBitmap = null;
		
		invalidateDisplayList();
	}
	
	//----------------------------------
	//  target
	//---------------------------------- 
	
	/**
	 * @public
	 * The UIComponent that you want to reflect.  Should be in an absolutely-
	 * positioned container.  The reflector will automatically position itself
	 * beneath the target.
	 */
	private var _target:UIComponent;
	
	[Bindable]
	public function get target():UIComponent 
	{
		return _target;
	}
	
	public function set target(value: UIComponent):void 
	{
		if (_target != null) 
		{
			// Remove our listeners from the previous target.
			_target.removeEventListener(FlexEvent.UPDATE_COMPLETE, target_updateCompleteHandler, true);
			_target.removeEventListener(Event.COMPLETE, target_completeHandler);
			_target.removeEventListener(MoveEvent.MOVE, target_moveHandler);
			_target.removeEventListener(ResizeEvent.RESIZE, target_resizeHandler);				
			
			// Clear our bitmaps, so we regenerate them next time a component is targeted.
			clearCachedBitmaps();
		}
		
		_target = value;
		
		if (_target != null) 
		{
			// Register to get notified whenever the target is redrawn.  We pass "true" 
			// for useCapture here so we can detect when any descendants of the target are
			// redrawn as well.
			_target.addEventListener(FlexEvent.UPDATE_COMPLETE, target_updateCompleteHandler, true);
			_target.addEventListener(Event.COMPLETE, target_completeHandler);
			
			// Register to get notified whenever the target moves or resizes.
			_target.addEventListener(MoveEvent.MOVE, target_moveHandler);
			_target.addEventListener(ResizeEvent.RESIZE, target_resizeHandler);
			
			// Mark ourselves dirty so we get redrawn at the next opportunity.
			invalidateDisplayList();
		}
	}
	
	
	//--------------------------------------------------------------------------
	//
	//  Override methods
	//
	//--------------------------------------------------------------------------
	
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void 
	{
		// This function is called by the framework at some point after invalidateDisplayList() is called.
		if (_target != null && _target.height && _target.width) 
		{
			// Create our cached bitmap data objects if they haven't been created already.
			createBitmaps(_target);
			
			var rect: Rectangle = new Rectangle(0, 0, _target.width, _target.height);
			
			// Draw the image of the target component into the target bitmap.
			_targetBitmap.fillRect(rect, 0x00000000);
			_targetBitmap.draw(_target, new Matrix());
			
			// Combine the target image with the alpha gradient to produce the reflection image.
			_resultBitmap.fillRect(rect, 0x00000000);
			_resultBitmap.copyPixels(_targetBitmap, rect, new Point(), _alphaGradientBitmap);
			
			// Flip the image upside down.
			var transform: Matrix = new Matrix();
			transform.scale(1, -1);
			transform.translate(0, _target.height);
			
			// And blur it
			graphics.beginFill(0xFFCC00);
			graphics.drawRect(0, 0, _target.width, _target.height);
			graphics.endFill();
			var filter:BitmapFilter = new BlurFilter(_blurAmount*5, _blurAmount*10, BitmapFilterQuality.HIGH);
			var myFilters:Array = new Array();
			myFilters.push(filter);
			filters = myFilters;            
			
			// Finally, copy the resulting bitmap into our own graphic context.
			graphics.clear();
			graphics.beginBitmapFill(_resultBitmap, transform, false);
			graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  Event handlers
	//
	//--------------------------------------------------------------------------
	
	private function clearCachedBitmaps():void 
	{
		_alphaGradientBitmap = null;
		_targetBitmap = null;
		_resultBitmap = null;
	}
	
	private function createBitmaps(target:UIComponent):void 
	{
		if (_alphaGradientBitmap == null) 
		{
			// Create and store an alpha gradient.  Whenever we redraw, this will be combined
			// with an image of the target component to create the "fadeout" effect.
			_alphaGradientBitmap = new BitmapData(target.width, target.height, true, 0x00000000);
			var gradientMatrix: Matrix = new Matrix();
			var gradientSprite: Sprite = new Sprite();
			gradientMatrix.createGradientBox(target.width, target.height * _falloff, Math.PI/2, 
				0, target.height * (1.0 - _falloff));
			gradientSprite.graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xFFFFFF], 
				[0, 1], [0, 255], gradientMatrix);
			gradientSprite.graphics.drawRect(0, target.height * (1.0 - _falloff), 
				target.width, target.height * _falloff);
			gradientSprite.graphics.endFill();
			_alphaGradientBitmap.draw(gradientSprite, new Matrix());
		}
		if (_targetBitmap == null) 
		{
			// Create a bitmap to hold the target's image.  This is updated every time
			// we're redrawn in updateDisplayList().
			_targetBitmap = new BitmapData(target.width, target.height, true, 0x00000000);
		}
		if (_resultBitmap == null) 
		{
			// Create a bitmap to hold the reflected image.  This is updated every time
			// we're redrawn in updateDisplayList().
			_resultBitmap = new BitmapData(target.width, target.height, true, 0x00000000);
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  Event handlers
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 * After target invokes live cycle methods, inalidate reflector displayList.
	 * The target has been redrawn, so mark ourselves for redraw.
	 */ 
	private function target_updateCompleteHandler(event:FlexEvent):void 
	{
		invalidateDisplayList();
	}
	
	/**
	 * @private
	 * If target is a SWFLoader, it's necessary to invalidate with callLatter.
	 * Is it a bug? I don't know!
	 */ 
	private function target_completeHandler(event:Event):void
	{
		callLater( invalidateDisplayList );
	}
	
	/**
	 * @private
	 * If target moved, invalidate reflector displayList 
	 * Move to be immediately below the target.  We don't need to
	 * redraw ourselves in this case.
	 */ 
	private function target_moveHandler(event:MoveEvent):void 
	{
		move(_target.x, _target.y + _target.height);
	}
	
	/**
	 * @private
	 * If target resized, invalidate reflector displayList 
	 * Since the target is resizing, we have to recreate our bitmaps
	 * in addition to redrawing and resizing ourselves.
	 */
	private function target_resizeHandler(event:ResizeEvent):void 
	{ 
		clearCachedBitmaps();
		width = _target.width;
		height = _target.height;
		invalidateDisplayList();
	}	
	
}
}