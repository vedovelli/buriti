package brust.components
{
	/**
	 * The YoutubeQuality class enumerates public constants that describe the Youtube video quality
	 * */
	public class YoutubeQuality
	{
			
		/**
		 * 	Quality level small: Player resolution less than 640px by 360px.
		 * */
		public static const SMALL:String = "small";
		
		/**
		 * 	Quality level medium: Minimum player resolution of 640px by 360px.
		 * */
		public static const MEDIUM:String = "medium";
		
		/**
		 * 	Quality level large: Minimum player resolution of 854px by 480px.
		 * */
		public static const LARGE:String = "large";
		
		/**
		 * 	Quality level hd720: Player resolution less than 640px by 360px.
		 * */
		public static const HD720:String = "hd720";
		
		/**
		 * 	Quality level default: YouTube selects the appropriate playback quality. 
		 * This setting effectively reverts the quality level to the default state 
		 * and nullifies any previous efforts to set playback quality using the cueVideoById, loadVideoById or setPlaybackQuality functions.
		 * */
		public static const DEFAULT:String = "default";			

	}
}