package buriti.events {
	
import flash.events.Event;
	
public class HighlightListEvent extends Event 
{	
    public static const ITEM_CLICK:String = "itemClick";
    
    public static const LOOKUP_VALUE_CHANGE:String = "lookupValueChange";
            
    public function HighlightListEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) 
	{
    	super(type, bubbles, cancelable);			        
    }

}
}