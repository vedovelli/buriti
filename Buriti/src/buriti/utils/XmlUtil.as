package buriti.utils
{
	public class XmlUtil
	{
		public static function removeNamespace(xml:XML):XML
		{
			var xmlString:String;
			var xmlnsPattern:RegExp;
			var namespaceRemovedXML:String;
			
			xmlString = xml.toXMLString();
			xmlnsPattern = new RegExp("xmlns[^\"]*\"[^\"]*\"", "gi");
			namespaceRemovedXML = xmlString.replace(xmlnsPattern, "");
			
			return new XML(namespaceRemovedXML);		
		}
	}
}