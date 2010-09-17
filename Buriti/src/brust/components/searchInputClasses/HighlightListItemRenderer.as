package brust.components.searchInputClasses
{
import brust.events.HighlightListEvent;

import flashx.textLayout.edit.EditManager;
import flashx.textLayout.edit.SelectionState;
import flashx.textLayout.formats.TextLayoutFormat;

import mx.events.FlexEvent;

import spark.components.RichText;
import spark.components.supportClasses.ItemRenderer;
	
public class HighlightListItemRenderer extends ItemRenderer
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
	public function HighlightListItemRenderer()
	{
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	private var _editManager:EditManager;
	
	private var _needApplyHightlight:Boolean;
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//
	//  Overridden properties
	//
	//--------------------------------------------------------------------------
	
	override public function set label(value:String):void 
	{
		super.label = value;
		highlightTexts();
	} 
	
	override public function set selected(value:Boolean):void 
	{
		super.selected = value;	
		
		if (owner is HighlightList) {
			highlightTexts();                    
		}
	}
	
	override protected function set hovered(value:Boolean):void 
	{
		super.hovered = value;                
		highlightTexts();
	} 	
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------
	
	override protected function createChildren():void
	{		
		if(!labelDisplay)
		{
			labelDisplay = new FixedRichText();
			labelDisplay.addEventListener(FlexEvent.CREATION_COMPLETE, labelDisplay_creationCompleteHandler);
			labelDisplay.verticalCenter = 0;
			labelDisplay.left = labelDisplay.right = 3;
			labelDisplay.top = 6;
			labelDisplay.bottom = 4;
			addElement( labelDisplay );
		}	
		
		super.createChildren();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	protected function highlightTexts():void 
	{
		if ( HighlightList(owner).searchMode == SearchMode.PREFIX_SEARCH) 
		{
			resetPreviousSelection();
			highlightText(0, HighlightList(owner).lookupValue.length);
		}
		
		else if ( HighlightList(owner).searchMode == SearchMode.INFIX_SEARCH)
		{
			var lookupTextValue:String = HighlightList(owner).lookupValue;				
			var searchPattern:RegExp = new RegExp(lookupTextValue, "gi");                        
			var firstFoundWordIndex:int = label.search(searchPattern);                        
			
			resetPreviousSelection();
			
			if (lookupTextValue.length == 0 || firstFoundWordIndex == -1)
				highlightText(0, 0);
		
			else 
			{                                                        
				var matches:Array = label.match(searchPattern);                            
				var previousFirstFoundIndex:int = label.length;
				
				if (matches) 
				{
					for (var i:int=0; i<matches.length; i++) 
					{
						var foundWord:String = matches[i];                                    
						var startHightlightIndex : int = label.toLowerCase().lastIndexOf(foundWord.toLowerCase(), previousFirstFoundIndex);                                
						var endHiglightIndex : int = startHightlightIndex + foundWord.length;                                    
						highlightText(startHightlightIndex, endHiglightIndex);
						
						previousFirstFoundIndex = startHightlightIndex - 1;
						
						if (previousFirstFoundIndex < 0)
							break;
						
					}    
				}
			}
		}

	}
	
	protected function highlightText(startHightlightIndex: int, endHiglightIndex:int):void 
	{
		var selectionFormat:TextLayoutFormat = new TextLayoutFormat();
		var containerFormat:TextLayoutFormat = new TextLayoutFormat();                
		var paragraphFormat:TextLayoutFormat = new TextLayoutFormat();                
		var characterFormat:TextLayoutFormat = new TextLayoutFormat();
		
		if (!_editManager)
			createEditManager();
		
		if (endHiglightIndex > startHightlightIndex && endHiglightIndex <= labelDisplay.text.length) 
		{                    
			selectionFormat.backgroundColor = HighlightList(owner).getStyle("lightBgColor");
			selectionFormat.color = HighlightList(owner).getStyle("lightColor");;                    
			
			characterFormat = selectionFormat;                
			var currentSelectionState:SelectionState = new SelectionState(RichText(labelDisplay).textFlow, 
				startHightlightIndex, endHiglightIndex, selectionFormat);
			
			_editManager.applyFormat(characterFormat, paragraphFormat, containerFormat, currentSelectionState);
		}                                
	} 
	
	protected function resetPreviousSelection():void
	{                               
		var nonSelectionFormat:TextLayoutFormat = new TextLayoutFormat();
		var paragraphFormat:TextLayoutFormat = new TextLayoutFormat();                
		var characterFormat:TextLayoutFormat = new TextLayoutFormat();
		var containerFormat:TextLayoutFormat = new TextLayoutFormat();
		
		if (!_editManager)
			createEditManager();                          
		
		if (itemIndex == HighlightList(owner).selectedIndex)
			nonSelectionFormat.backgroundColor = HighlightList(owner).getStyle("selectionColor");
		else if (hovered)
			nonSelectionFormat.backgroundColor = HighlightList(owner).getStyle("rollOverColor");
		else
			nonSelectionFormat.backgroundColor = HighlightList(owner).getStyle("contentBackgroundColor");
		
		nonSelectionFormat.color = 0x000000;
		
		characterFormat = nonSelectionFormat;                
		var restSelectionState:SelectionState = new SelectionState(RichText(labelDisplay).textFlow, 0, labelDisplay.text.length, nonSelectionFormat);                
		
		_editManager.applyFormat(characterFormat, paragraphFormat, containerFormat, restSelectionState);
	}
	
	private function createEditManager():void 
	{
		_editManager = new EditManager();
		RichText(labelDisplay).textFlow.interactionManager = _editManager;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Event Handlers
	//
	//--------------------------------------------------------------------------
	
	private function labelDisplay_creationCompleteHandler(event:FlexEvent):void 
	{                
		createEditManager();
		HighlightList(owner).addEventListener(HighlightListEvent.LOOKUP_VALUE_CHANGE, onLookupValueChange);
	}
	
	private function onLookupValueChange(event:HighlightListEvent):void 
	{
		highlightTexts();
	}	
	
}
}