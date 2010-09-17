package brust.components.searchInputClasses {
    
import brust.events.HighlightListEvent;

import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

import mx.core.ClassFactory;

import spark.components.List;

//--------------------------------------
//  Styles
//--------------------------------------
[Style(name="lightColor", type="uint", format="Color", inherit="yes", theme="spark")]
[Style(name="lightBgColor", type="uint", format="Color", inherit="yes", theme="spark")]

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when the user click over an ite
 *
 *  @eventType brust.events.HighlightListEvent.ITEM_CLICK
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[Event (name="itemClick", type="brust.events.HighlightListEvent")]

/**
 *  Dispatched when loockup value change.
 *
 *  @eventType brust.events.HighlightListEvent.LOOKUP_VALUE_CHANGE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[Event (name="lookupValueChange", type="brust.events.HighlightListEvent")]

public class HighlightList extends List 
{             
    
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  Constructor. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */		
    public function HighlightList() 
	{
        super();            
    }
    
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  lookupValue
	//----------------------------------
	
	private var _lookupValue:String = "";
	
	[Bindable("lookupValueChange")]
	public function get lookupValue():String 
	{
		return _lookupValue;
	}
	
	public function set lookupValue(value:String):void 
	{
        _lookupValue = value;
        dispatchEvent(new HighlightListEvent(HighlightListEvent.LOOKUP_VALUE_CHANGE));
    }        
	
	//----------------------------------
	//  searchMode
	//----------------------------------
	
	private var _searchMode:String;  

	public function get searchMode():String
	{
		return _searchMode;
	}

	public function set searchMode(value:String):void
	{
		_searchMode = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Override methods
	//
	//--------------------------------------------------------------------------
	
	override public function initialize():void
	{
		super.initialize();
		
		itemRenderer = new ClassFactory(HighlightListItemRenderer);
	}
	
	
	//--------------------------------------------------------------------------
	//
	//  Event handlers
	//
	//--------------------------------------------------------------------------
    
    public function focusListUponKeyboardNavigation(event:KeyboardEvent):void 
	{            
        adjustSelectionAndCaretUponNavigation(event);            
    }
    
    override protected function item_mouseDownHandler(event:MouseEvent):void 
	{
        super.item_mouseDownHandler(event);
        dispatchEvent(new HighlightListEvent(HighlightListEvent.ITEM_CLICK));
    }   
    
}
}