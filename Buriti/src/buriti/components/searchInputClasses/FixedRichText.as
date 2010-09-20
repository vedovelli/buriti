package buriti.components.searchInputClasses 
{
	
import flashx.textLayout.elements.TextFlow;

import spark.components.RichText;

/*
    FixedRichText component  is used for HighlightListItemRenderer to provide 
    workaround for Flex 4 SDK issue  
    https://bugs.adobe.com/jira/browse/SDK-25503    
*/
public class FixedRichText extends RichText 
{
    public function FixedRichText() 
	{
        super();
    }
    
    override protected function commitProperties():void 
	{                          
        var getText : String = text; 
        super.commitProperties();
    }
	
}
}