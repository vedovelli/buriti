package buriti.components 
{

import buriti.components.searchInputClasses.HighlightList;
import buriti.components.searchInputClasses.SearchMode;
import buriti.events.HighlightListEvent;
import buriti.events.SearchInputEvent;

import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.ui.Keyboard;

import mx.collections.ArrayCollection;
import mx.collections.ArrayList;
import mx.collections.ListCollectionView;
import mx.collections.XMLListCollection;
import mx.controls.Image;
import mx.events.FlexMouseEvent;
import mx.managers.SystemManager;

import spark.components.Label;
import spark.components.PopUpAnchor;
import spark.components.TextInput;
import spark.events.TextOperationEvent;
import spark.primitives.BitmapImage;
import spark.utils.LabelUtil;

//--------------------------------------
//  Styles
//--------------------------------------
[Style(name="iconCancel", type="Class", inherit="no")]
[Style(name="iconSearch", type="Class", inherit="no")]

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when the user select an item from suggestions
 *
 *  @eventType brust.events.AutoCompleteEvent.SELECT
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[Event (name="select", type="buriti.events.SearchInputEvent")]		

//--------------------------------------
//  Skin states
//--------------------------------------
[SkinState("focused")]

public class SearchInput extends TextInput
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
    public function SearchInput() 
	{
    	super();            
    	this.mouseEnabled = true;      
		minWidth = 250;
    }
	
	//--------------------------------------------------------------------------
	//
	//  Skin Parts
	//
	//--------------------------------------------------------------------------	
	
	[SkinPart(required="true", type="brust.components.HighlightItemList")]
	public var list:HighlightList;
	
	[SkinPart(required="true", type="spark.components.PopUpAnchor")]
	public var popUp:PopUpAnchor;
	
	[SkinPart(required="false", type="spark.primitives.BitmapImage;")]
	public var searchImage:BitmapImage;
	
	[SkinPart(required="true", type="mx.controls.Image")]
	public var clearButton:Image;
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	private var _focused:Boolean;
	
	private var _completionAccepted:Boolean;
	
	private var _previouslyEnteredText:String = "";		
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
		
	//----------------------------------
	//  dataProvider
	//----------------------------------	
	private var _collection:ListCollectionView = new ListCollectionView();
	private var _dataProviderChanged:Boolean;
	
	[Bindable]
	public function get dataProvider():Object 
	{
		return _collection; 
	}	
	
	public function set dataProvider(value:Object):void
	{
		if(!value)
			return;
		
		if (value is ArrayList)
			_collection = new ArrayCollection( ArrayList(value).source );
		else if (value is ArrayCollection)
			_collection = value as ArrayCollection;
		else if (value is XMLList)
			_collection = new XMLListCollection(  XMLList(value) );
		else if (value is XMLListCollection)
			_collection = value as XMLListCollection;
		else
			throw new ArgumentError("Invalid dataProvider type");
		
		_dataProviderChanged = true;
		invalidateProperties(); 
	}   
	
	//----------------------------------
	//  _enumClass
	//----------------------------------
	
	private var _enumClass:Class; 
	
	public function get enumClass():Class
	{
		return _enumClass;
	}
	
	public function set enumClass(value:Class):void
	{
		_enumClass = value;
	}
	
	//----------------------------------
	//  forceOpen
	//----------------------------------
		
	private var _forceOpen:Boolean = true;
	
	public function get forceOpen():Boolean
	{
		return _forceOpen;
	}
	
	public function set forceOpen(value:Boolean):void
	{
		_forceOpen = value;
	}
	
	//----------------------------------
	//  labelField
	//----------------------------------
	private var _labelField:String;
	
	public function get labelField() : String 
	{ 
		return _labelField;
	}
	
	public function set labelField(value:String):void 
	{
		_labelField = value; 
		
		if (list)
			list.labelField = value;   
	}
	
	//----------------------------------
	//  labelFunction
	//----------------------------------
	private var _labelFunction:Function;
	
	public function get labelFunction():Function	 
	{ 
		return _labelFunction; 
	}
	
	public function set labelFunction(value:Function):void 
	{
		_labelFunction = value;
		
		if (list)
			list.labelFunction = value;   
	}   
	
	//----------------------------------
	//  maxRows
	//----------------------------------
            
    private var _maxRows:Number = 6;

	[Bindable("maxRowsChange")]
	
	public function get maxRows():Number
	{
		return _maxRows;
	}

	public function set maxRows(value:Number):void
	{
		_maxRows = value;
		
		dispatchEvent( new Event("maxRowsChange") );
	}
	
	//----------------------------------
	//  minChars
	//----------------------------------
    
    private var _minChars:Number = 1;                       

	public function get minChars():Number
	{
		return _minChars;
	}

	public function set minChars(value:Number):void
	{
		_minChars = value;
	}
	
	//----------------------------------
	//  promptText
	//----------------------------------	
	
	private var promptProperties:Object = {};
	private var _promptText:String;
	
	public function get promptText():String
	{
		return _promptText;
	}
	
	public function set promptText(value:String):void
	{
		prompt = value;
	}

	//----------------------------------
	//  requireSelection
	//----------------------------------
    
    private var _requireSelection:Boolean = false;

	public function get requireSelection():Boolean
	{
		return _requireSelection;
	}

	public function set requireSelection(value:Boolean):void
	{
		_requireSelection = value;
	}
	
	//----------------------------------
	//  searchMode
	//----------------------------------
	private var _searchMode:String = SearchMode.PREFIX_SEARCH;
	
	public function get searchMode():String 
	{ 
		return _searchMode;
	}
    
    public function set searchMode(value:String):void 
	{            
        _searchMode = value; 
		
        if (list)
            list.searchMode = value;
    } 
	
	//----------------------------------
	//  selectedItem
	//----------------------------------	
	private var _selectedItem:Object;
	private var _selectedItemChanged:Boolean;
    
    public function get selectedItem():Object 
	{ 
        return _selectedItem; 
    }
    
    public function set selectedItem(value:Object):void 
	{
        _selectedItem = value;
        _previouslyEnteredText = returnFunction(_selectedItem);
		
		if (_requireSelection || value)
			text = _previouslyEnteredText;
                    
        _selectedItemChanged = true;
        invalidateProperties();
	}   
    
	//--------------------------------------------------------------------------
	//
	//  Overridden properties
	//
	//--------------------------------------------------------------------------
	
	override public function set text(value:String):void
	{
		super.text = value;
		
		if (list)
			list.lookupValue = value;
		
		if(clearButton)
			clearButton.visible = (text.length > 0);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------
    
    override public function setFocus():void 
	{            
        if (textDisplay)
			textDisplay.setFocus();
    }
	
	override protected function getCurrentSkinState():String 
	{
		if (_focused)
			return "focused";
		else
			return super.getCurrentSkinState();
	}
	
	override protected function focusInHandler(event:FocusEvent):void
	{
		super.focusInHandler(event);	
		
		selectAll();
		
		_focused = true;
		invalidateSkinState();
	}
	
	override protected function focusOutHandler(event:FocusEvent):void
	{
		super.focusOutHandler(event);
		
		_focused = false;
		invalidateSkinState();			
	}	
	
	override protected function partAdded(partName:String, instance:Object):void 
	{
		super.partAdded(partName, instance);
		
		if (instance == textDisplay) 
		{			
			textDisplay.addEventListener(FocusEvent.FOCUS_OUT, textDisplay_focusOutHandler);
			textDisplay.addEventListener(FocusEvent.FOCUS_IN, textDisplay_focusInHandler);
			textDisplay.addEventListener(TextOperationEvent.CHANGE, textDisplay_changeHandler);
			textDisplay.addEventListener(KeyboardEvent.KEY_DOWN, textDisplay_keyDownHandler);            	
		}
		
		else if (instance == list) 
		{
			list.dataProvider = _collection;
			list.labelField = labelField;
			list.labelFunction = labelFunction;
			list.searchMode = searchMode;
			list.requireSelection = requireSelection;
			
			list.addEventListener(HighlightListEvent.ITEM_CLICK, list_itemClickHandler);
		}     
		
		else if(instance == searchImage)
		{
			searchImage.source = getStyle("iconSearch");
			searchImage.addEventListener("iconSearchChanged", iconSearch_imageChangedHandler);
		}
		
		else if (instance == clearButton)
		{
			clearButton.source = getStyle("iconCancel");
			clearButton.addEventListener(MouseEvent.CLICK, cancel_clickHandler);
			clearButton.addEventListener("iconCancelChanged", cancelButton_iconChangedHandler);	
			clearButton.visible = (text != null && text.length > 0);
		}
	}  
	
	override protected function partRemoved(partName:String, instance:Object):void
	{
		super.partRemoved(partName, instance);
		
		if (instance == textDisplay) 
		{			
			textDisplay.removeEventListener(FocusEvent.FOCUS_OUT, textDisplay_focusOutHandler);
			textDisplay.removeEventListener(FocusEvent.FOCUS_IN, textDisplay_focusInHandler);
			textDisplay.removeEventListener(TextOperationEvent.CHANGE, textDisplay_changeHandler);
			textDisplay.removeEventListener(KeyboardEvent.KEY_DOWN, textDisplay_keyDownHandler);            	
		}
			
		else if (instance == list) 
		{			
			list.removeEventListener(HighlightListEvent.ITEM_CLICK, list_itemClickHandler);
		}     
			
		else if(instance == searchImage)
		{
			searchImage.removeEventListener("iconSearchChanged", iconSearch_imageChangedHandler);
		}
			
		else if (instance == clearButton)
		{
			clearButton.removeEventListener(MouseEvent.CLICK, cancel_clickHandler);
			clearButton.removeEventListener("iconCancelChanged", cancelButton_iconChangedHandler);			
		}
	}
	
	override protected function commitProperties():void 
	{	
		if (_dataProviderChanged) 
		{                
			_dataProviderChanged = false;                
			list.dataProvider = _collection;                                 
		}
		
		if (_selectedItemChanged) 
		{
			var selectedIndex:int = _collection.getItemIndex(selectedItem);                
			list.selectedIndex = _collection.getItemIndex(selectedItem);
			_selectedItemChanged = false;
		}			
		
		// Should be last statement.
		// Don't move it up.
		super.commitProperties();                        
	}	
    
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------	
	
	public function cancelSearch():void
	{
		this.text = "";
	}	
	
	private function filterFunction(item:Object):Boolean 
	{
		var itemLabel:String = itemToLabel(item).toLowerCase();
		
		// prefix search mode
		if (searchMode == SearchMode.PREFIX_SEARCH) 
		{
			if (itemLabel.substr(0, text.length) == text.toLowerCase())
				return true;
			else 
				return false;
		}
		
		// infix search mode
		else 
		{
			if (itemLabel.search(text.toLowerCase()) != -1)
				return true;   
		}
		
		return false;
	}
	
	protected function itemToLabel(item:Object):String 
	{
		return LabelUtil.itemToLabel(item, labelField, labelFunction);
	}
    
	protected function acceptCompletion():void 
	{	
		if (_collection.length > 0 && list.selectedIndex >= 0) 
		{
            _completionAccepted = true;                
            selectedItem = _collection.getItemAt(list.selectedIndex);
            hidePopUp();
        }
        else if (!_requireSelection)
		{
			_completionAccepted = true;
			selectedItem = null;
			hidePopUp();
		}		
		else
		{
            _completionAccepted = false;
            selectedItem = null;
            restoreEnteredTextAndHidePopUp(!_completionAccepted);
        }
        
        var e:SearchInputEvent = new SearchInputEvent(SearchInputEvent.SELECT, _selectedItem);
        dispatchEvent(e);                         			
    }
    
    protected function filterData():void 
	{            
		_collection.filterFunction = filterFunction;                        	
		_collection.refresh();        	
                    
        if (_collection.length == 0)            
            hidePopUp();
        else if (!isDropDownOpen)
            if (forceOpen || text.length > 0)
                showPopUp();        
    }    
    
    private function returnFunction(item:Object):String 
	{
        if (item == null)
            return ""; 
		
        if (labelField)
        	return item[labelField];
        else
        	return itemToLabel(item);
    } 
	
	private function showPopUp():void 
	{            
		popUp.displayPopUp = true;
		
		if (requireSelection)
			list.selectedIndex = 0;
		else
			list.selectedIndex = -1;
		
		list.dataGroup.verticalScrollPosition = 0;
		list.dataGroup.horizontalScrollPosition = 0;
		
		popUp.popUp.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, popUp_mouseDownOutsideHandler);
	}
	
	private function restoreEnteredTextAndHidePopUp(restoreEnteredText:Boolean):void 
	{
		if (restoreEnteredText)
			text = _previouslyEnteredText;
		
		hidePopUp();
	}
	
	private function hidePopUp():void 
	{
		popUp.popUp.removeEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, popUp_mouseDownOutsideHandler);
		popUp.displayPopUp = false;            
	}
	
	private function get isDropDownOpen():Boolean 
	{
		return popUp.displayPopUp;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Event Handlers
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  textDisplay handlers
	//----------------------------------
	
	private function textDisplay_focusInHandler(event:FocusEvent):void 
	{            
		if (forceOpen)
			filterData();
		
		_previouslyEnteredText = text;
	}
    
    private function textDisplay_changeHandler(event:TextOperationEvent):void 
	{
        _completionAccepted = false;
       text = textDisplay.text;           
	   filterData();            
    }
	
	private function textDisplay_focusOutHandler(event:FocusEvent):void 
	{
		restoreEnteredTextAndHidePopUp(!_completionAccepted);
	}	
    
	private function textDisplay_keyDownHandler(event:KeyboardEvent):void 
	{        	            
		switch (event.keyCode) 
		{
			case Keyboard.UP:
			case Keyboard.DOWN:
			case Keyboard.END:
			case Keyboard.HOME:
			case Keyboard.PAGE_UP:
			case Keyboard.PAGE_DOWN: 
				list.focusListUponKeyboardNavigation(event);                                     			
				break; 
			
			case Keyboard.ENTER:
				acceptCompletion();
				break;
			
			case Keyboard.TAB:
			case Keyboard.ESCAPE:
				restoreEnteredTextAndHidePopUp(!_completionAccepted);
				break;
		}            
	}    	        				
    
	//----------------------------------
	//  list handlers
	//----------------------------------
		
    private function list_itemClickHandler(event:HighlightListEvent):void 
	{                        
        acceptCompletion();            
        event.stopPropagation();
    }
	
	//----------------------------------
	//  popUp handlers
	//----------------------------------
    
    private function popUp_mouseDownOutsideHandler(event:FlexMouseEvent):void 
	{            
        
        var mouseDownInsideComponent:Boolean = false;            
        var clickedObject:DisplayObjectContainer = event.relatedObject as DisplayObjectContainer;
                               
        while (!(clickedObject.parent is SystemManager)) 
		{                
            if (clickedObject == this) 
			{
                mouseDownInsideComponent = true;
                break;
            }
            
            clickedObject = clickedObject.parent;
        }
                    
        if (!mouseDownInsideComponent)        
            restoreEnteredTextAndHidePopUp(!_completionAccepted);
    }
	
	//----------------------------------
	//  cancelButton handlers
	//----------------------------------
	
	private function cancelButton_iconChangedHandler(event:Event):void
	{
		clearButton.source = getStyle("iconCancel");
	}
	
	private function cancel_clickHandler(event:MouseEvent):void
	{
		cancelSearch();
	}
	
	//----------------------------------
	//  iconSearch handlers
	//----------------------------------
	
	private function iconSearch_imageChangedHandler(event:Event):void
	{
		searchImage.source = getStyle("iconSearch");
	}
	
}	
}