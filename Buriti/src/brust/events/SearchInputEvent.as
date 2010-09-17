package brust.events 
{
	
import flash.events.Event;
 
/**
 *   The AutoCompleteEvent class represents events associated with AutoComplete
 *
 *  @see mx.controls.List
 *  @see mx.controls.listClasses.ListBase
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 4
 */

public class SearchInputEvent extends Event 
{	
    public static const SELECT:String = "select";
    
    public var item:Object;                
    
    public function SearchInputEvent(type:String, mydata:Object, bubbles:Boolean = false, cancelable:Boolean = false)
	{
    	super(type, bubbles,cancelable);			
    	item = mydata;
    }
}
}