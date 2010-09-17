package brust.layouts 
{	
import flash.events.TimerEvent;
import flash.geom.Matrix3D;
import flash.geom.PerspectiveProjection;
import flash.geom.Point;
import flash.geom.Vector3D;
import flash.utils.Timer;

import mx.core.ILayoutElement;
import mx.core.IVisualElement;
import mx.core.UIComponent;

import spark.layouts.supportClasses.LayoutBase;

public class CoverflowLayout extends LayoutBase 
{
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	public function CoverflowLayout()
	{
		super();
	}	
	
	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------
    private static const ANIMATION_DURATION:int = 700;
    private static const ANIMATION_STEPS:int = 24; // fps
    private static const RIGHT_SIDE:int = -1;
    private static const LEFT_SIDE:int = 1;
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 *  Matrix3D for each element that describes translation and rotations
	 */
    private var finalMatrixs:Vector.<Matrix3D>;

	/**
	 *  @private
	 *  Center point of target component
	 */
	private var centerPoint:Point;
	
	/**
	 *  @private
	 *  Timer for transition effect 
	 */
    private var transitionTimer:Timer;
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  depthDistance
	//---------------------------------- 
	private var _depthDistance:Number;
	
	/**
	 * @public
	 * Depth of lateral elements
	 */ 
	
	public function set depthDistance(value:Number):void 
	{
		_depthDistance = value;
		invalidateTarget();
	}

	//----------------------------------
	//  elementRotation
	//---------------------------------- 
    private var _elementRotation:Number;
	
	/**
	 * @public
	 * Rotation of lateral elements
	 */ 
	
	public function set elementRotation(value:Number):void 
	{
		_elementRotation = value;
		invalidateTarget();
	}
	
	//----------------------------------
	//  focalLength
	//---------------------------------- 
	private var _focalLength:Number = 300;
	
	/**
	 * @public
	 * The distance between the eye or the viewpoint's origin (0,0,0)
	 * and the display object located in the z axis.
	 */ 
	
	public function set focalLength(value:Number):void 
	{
		_focalLength = value;
		invalidateTarget();
	}
	
	//----------------------------------
	//  horizontalDistance
	//---------------------------------- 
	private var _horizontalDistance:Number = 100;
	
	/**
	 * @public
	 * The horizontal distance between the elements
	 */ 
	
	public function set horizontalDistance(value:Number):void 
	{
		_horizontalDistance = value;
		invalidateTarget();
	}
	
	//----------------------------------
	//  perspectiveProjectionX
	//---------------------------------- 
	private var _perspectiveProjectionX:Number;
	
	/**
	 * @public
	 * Horizontal perspective projection. 
	 */ 
	public function set perspectiveProjectionX(value:Number):void 
	{
		_perspectiveProjectionX = value;
		invalidateTarget();
	}
	
	//----------------------------------
	//  perspectiveProjectionY
	//---------------------------------- 
	private var _perspectiveProjectionY:Number;
	
	/**
	 * @public
	 * Vertical perspective projection. 
	 */ 
	public function set perspectiveProjectionY(value:Number):void 
	{
		_perspectiveProjectionY = value;
		invalidateTarget();		
	}
	
	//----------------------------------
	//  selectedIndex
	//---------------------------------- 
	private var _selectedIndex:int;
	
	/**
	 * @public
	 * Element index that show in the center
	 */ 
	public function set selectedIndex(value:int):void 
	{
		_selectedIndex = value;
		invalidateTarget();
	}
	
	//----------------------------------
	//  selectedItemProximity
	//---------------------------------- 
    private var _selectedItemProximity:Number;
	
	/**
	 * @public
	 * The Z perpective of center element that define the proximity.
	 */
	public function set selectedItemProximity(value:Number):void 
	{
		_selectedItemProximity = value;
		invalidateTarget();
	}   

	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @public
	 * Override method that renderer object. This is the main method.
	 */ 
	override public function updateDisplayList(width:Number, height:Number):void 
	{
		var i:int = 0;
		var j:int = 0;
		var numElements:int = target.numElements;
		var matrix:Matrix3D;
		
		if (numElements > 0) 
		{
			centerPerspectiveProjection(width, height);
			finalMatrixs = new Vector.<Matrix3D>(numElements);
			
			//center element
			var midElement:int = _selectedIndex == -1 ? Math.ceil(numElements / 2) : _selectedIndex;
			matrix = positionCentralElement(target.getVirtualElementAt(midElement), width, height);
			finalMatrixs[midElement] = matrix;
			
			//left elements
			for (i = midElement - 1; i >= 0; i--) 
			{
				matrix = positionLateralElement(target.getVirtualElementAt(i), midElement - i, LEFT_SIDE);
				finalMatrixs[i] = matrix;
			}
			
			//right elements
			for (j = 2, i = midElement + 1; i < numElements; i++, j++) 
			{
				matrix = positionLateralElement(target.getVirtualElementAt(i), j, RIGHT_SIDE);
				finalMatrixs[i] = matrix;
			}
			
			playTransition();
		}		
	}
	
	/**
	 * @public
	 * Invalidate coverflow target and force invoke updateDisplayList
	 */
	private function invalidateTarget():void 
	{
		if (target) 
		{
			target.invalidateDisplayList();
			target.invalidateSize();
		}
	}

	/**
	 * @public
	 * Define the center of perspective projection, according to the target size
	 */
    private function centerPerspectiveProjection(width:Number, height:Number):void
	{
        _perspectiveProjectionX = _perspectiveProjectionX != -1 ? _perspectiveProjectionX : width / 2;
        _perspectiveProjectionY = _perspectiveProjectionY != -1 ? _perspectiveProjectionY : height / 2;

        var perspectiveProjection:PerspectiveProjection = new PerspectiveProjection();
        perspectiveProjection.projectionCenter = new Point(_perspectiveProjectionX, _perspectiveProjectionY);
        perspectiveProjection.focalLength = _focalLength;

        target.transform.perspectiveProjection = perspectiveProjection;
    }

	/**
	 * @public
	 * Return a Matrix3D for position central element
	 */
    private function positionCentralElement(element:ILayoutElement, width:Number, height:Number):Matrix3D 
	{
        element.setLayoutBoundsSize(NaN, NaN, false);
        var matrix:Matrix3D = new Matrix3D();
        var elementWidth:Number = element.getLayoutBoundsWidth(false);
        var elementHeight:Number = element.getLayoutBoundsHeight(false);

		centerPoint = new Point( (width - elementWidth) / 2, (height - elementHeight) / 2)

        matrix.appendTranslation(centerPoint.x, centerPoint.y, -_selectedItemProximity);

        element.setLayoutBoundsSize(NaN, NaN, false);

        if (element is IVisualElement)
            IVisualElement(element).depth = 10;

        return matrix;
    }

	/**
	 * @public
	 * Return a Matrix3D for position lateral element
	 */
    private function positionLateralElement(element:ILayoutElement, index:int, side:int):Matrix3D 
	{
        element.setLayoutBoundsSize(NaN, NaN, false);

        var matrix:Matrix3D = new Matrix3D();
        var elementWidth:Number = element.getLayoutBoundsWidth(false);
        var elementHeight:Number = element.getLayoutBoundsHeight(false);

        var zPosition:Number = index * _depthDistance;

        if (side == RIGHT_SIDE) 
		{
			matrix.appendTranslation(-elementWidth, 0, 0);
			matrix.appendRotation(side * _elementRotation, Vector3D.Y_AXIS);
			matrix.appendTranslation(elementWidth - _horizontalDistance, 0, 0);
        } 
		else 
		{
            matrix.appendRotation(side * _elementRotation, Vector3D.Y_AXIS);
        }

        matrix.appendTranslation(centerPoint.x - side * (index) * _horizontalDistance, centerPoint.y, zPosition);

        if (element is IVisualElement)
            IVisualElement(element).depth = -zPosition;

        return matrix;
    }

	/**
	 * @public
	 * Play effect transition
	 */
    private function playTransition():void 
	{
        if (transitionTimer) 
		{
            transitionTimer.stop();
            transitionTimer.reset();
        } 
		else 
		{
            transitionTimer = new Timer(ANIMATION_DURATION / ANIMATION_STEPS, ANIMATION_STEPS);
            transitionTimer.addEventListener(TimerEvent.TIMER, transitionTimer_timerHandler);
            transitionTimer.addEventListener(TimerEvent.TIMER_COMPLETE, animationTimerCompleteHandler);
        }

        transitionTimer.start();
    }

	/**
	 * @public
	 * Event handler - transitionTimer - timer
	 * Animate the transition based on Matrix3D
	 */
    private function transitionTimer_timerHandler(event:TimerEvent):void 
	{
        var numElements:int = target.numElements;

        var initialMatrix:Matrix3D;
        var finalMatrix:Matrix3D;
        var element:ILayoutElement;

        for (var i:int = 0; i < numElements; i++) 
		{
            finalMatrix = finalMatrixs[i];

            element = target.getVirtualElementAt(i);

            initialMatrix = UIComponent(element).transform.matrix3D;
            initialMatrix.interpolateTo(finalMatrix, 0.2);
			
            element.setLayoutMatrix3D(initialMatrix, false);
        }
    }

	/**
	 * @public
	 * Event handler - transitionTimer - timerComplete
	 * Complete transition, set null for finalMatrixs
	 */
    private function animationTimerCompleteHandler(event:TimerEvent):void 
	{
        finalMatrixs = null;
    }
}
}