package brust.components
{
	
import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.MouseEvent;

import mx.events.FlexEvent;
import mx.utils.ObjectUtil;

import org.osmf.events.LoadEvent;
import org.osmf.events.MediaPlayerStateChangeEvent;
import org.osmf.events.TimeEvent;

import spark.components.mediaClasses.MuteButton;
import spark.components.mediaClasses.ScrubBar;
import spark.components.mediaClasses.VolumeBar;
import spark.components.supportClasses.ButtonBase;
import spark.components.supportClasses.SkinnableComponent;
import spark.components.supportClasses.TextBase;
import spark.components.supportClasses.ToggleButtonBase;
import spark.events.TrackBaseEvent;
	
//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when the data is received as a download operation progresses.
 *  This event is only dispatched when playing a video by downloading it 
 *  directly from a server, typically by issuing an HTTP request.
 *  It is not displatched when playing a video from a special media server, 
 *  such as Flash Media Server.
 *  
 * <p>This event may not be dispatched when the videoId is set to null or a playback
 *  error occurs.</p>
 *
 *  @eventType org.osmf.events.LoadEvent.BYTES_LOADED_CHANGE
 */
[Event(name="bytesLoadedChange",type="org.osmf.events.LoadEvent")]

/**
 *  Dispatched when the playhead reaches the duration for playable media.
 * 
 *  @eventType org.osmf.events.TimeEvent.COMPLETE
 *  
 */  
[Event(name="complete", type="org.osmf.events.TimeEvent")]

/**
 *  Dispatched when the <code>currentTime</code> property of the MediaPlayer has changed.
 * 
 *  <p>This event may not be dispatched when the source is set to null or a playback
 *  error occurs.</p>
 *
 *  @eventType org.osmf.events.TimeEvent.CURRENT_TIME_CHANGE
 *
 */
[Event(name="currentTimeChange",type="org.osmf.events.TimeEvent")]

/**
 *  Dispatched when the <code>duration</code> property of the media has changed.
 * 
 *  <p>This event may not be dispatched when the source is set to null or a playback
 *  error occurs.</p>
 * 
 *  @eventType org.osmf.events.TimeEvent.DURATION_CHANGE
 * 
 */
[Event(name="durationChange", type="org.osmf.events.TimeEvent")]

/**
 *  Dispatched when the MediaPlayer's state has changed.
 * 
 *  @eventType org.osmf.events.MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE
 *  
 */ 
[Event(name="mediaPlayerStateChange", type="org.osmf.events.MediaPlayerStateChangeEvent")]


//--------------------------------------
//  SkinStates
//--------------------------------------

/**
 *  Uninitialized state of the VideoPlayer.  
 *  The Video Player has been constructed at this point, 
 *  but the source has not been set and no connection 
 *  attempt is in progress.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[SkinState("uninitialized")]

/**
 *  Loading state of the VideoPlayer.
 *  The VideoPlayer is loading or connecting to the source. 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[SkinState("loading")]

/**
 *  Ready state of the VideoPlayer.
 *  The video is ready to be played.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[SkinState("ready")]

/**
 *  Playing state of the VideoPlayer
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[SkinState("playing")]

/**
 *  Paused state of the VideoPlayer
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[SkinState("paused")]

/**
 *  Buffering state of the VideoPlayer
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[SkinState("buffering")]

/**
 *  Playback Error state of the VideoPlayer. 
 *  An error was encountered while trying to play the video.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[SkinState("playbackError")]

/**
 *  Disabled state of the VideoPlayer
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[SkinState("disabled")]

/**
 *  Uninitialized state of the VideoPlayer when 
 *  in full screen mode.
 *  The Video Player has been constructed at this point, 
 *  but the source has not been set and no connection 
 *  attempt is in progress.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[SkinState("uninitializedAndFullScreen")]

/**
 *  Loading state of the VideoPlayer when 
 *  in full screen mode.
 *  The VideoPlayer is loading or connecting to the source. 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[SkinState("loadingAndFullScreen")]

/**
 *  Ready state of the VideoPlayer when 
 *  in full screen mode.  The video is ready to be played.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[SkinState("readyAndFullScreen")]

/**
 *  Playing state of the VideoPlayer when 
 *  in full screen mode.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[SkinState("playingAndFullScreen")]

/**
 *  Paused state of the VideoPlayer when 
 *  in full screen mode.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[SkinState("pausedAndFullScreen")]

/**
 *  Buffering state of the VideoPlayer when 
 *  in full screen mode.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[SkinState("bufferingAndFullScreen")]

/**
 *  Playback Error state of the VideoPlayer when 
 *  in full screen mode.  
 *  An error was encountered while trying to play the video.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[SkinState("playbackErrorAndFullScreen")]

/**
 *  Disabled state of the VideoPlayer when 
 *  in full screen mode.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[SkinState("disabledAndFullScreen")]
	
public class YoutubePlayer extends SkinnableComponent
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	public function YoutubePlayer()
	{
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Skin Parts
	//
	//--------------------------------------------------------------------------
	
	[SkinPart(required="true")]	
	/**
	 *  A required skin part that defines the Y.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public var youtubeDisplay:YoutubeDisplay;
	
	[SkinPart(required="false")]	
	/**
	 *  An optional skin part to display the current value of <code>codecurrentTime</code>.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public var currentTimeDisplay:TextBase;
	
	[SkinPart(required="false")]	
	/**
	 *  An optional skin part for a button to toggle fullscreen mode.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public var fullScreenButton:ButtonBase;
	
	[SkinPart(required="false")]	
	/**
	 *  An optional skin part for the mute button.  The mute 
	 *  button has both a <code>muted</code> property and a 
	 *  <code>volume</code> property.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public var muteButton:MuteButton;
	
	[SkinPart(required="false")]	
	/**
	 *  An optional skin part for the pause button.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public var pauseButton:ButtonBase;
	
	[SkinPart(required="false")]	
	/**
	 *  An optional skin part for the play button.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public var playButton:ButtonBase;
	
	[SkinPart(required="false")]	
	/**
	 *  An optional skin part for all of the player controls.   
	 *  This skin is used to determine what to hide when the player is in full screen 
	 *  mode and there has been no user interaction.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public var playerControls:DisplayObject;
	
	[SkinPart(required="false")]	
	/**
	 *  An optional skin part for a play/pause button.  When the 
	 *  video is playing, the <code>selected</code> property is set to 
	 *  <code>true</code>.  When the video is paused or stopped, 
	 *  the <code>selected</code> property is set to <code>false</code>.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public var playPauseButton:ToggleButtonBase;
	
	[SkinPart(required="false")]	
	/**
	 *  An optional skin part for the scrub bar (the 
	 *  timeline).
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public var scrubBar:ScrubBar;
	
	[SkinPart(required="false")]	
	/**
	 *  An optional skin part for the stop button.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public var stopButton:ButtonBase;
	
	[SkinPart(required="false")]	
	/**
	 *  An optional skin part to display the duration.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public var durationDisplay:TextBase;
	
	[SkinPart(required="false")]	
	/**
	 *  An optional skin part for the volume control.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public var volumeBar:VolumeBar;
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	private var youtubeDisplayProperties:Object = {};
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  autoPlay
	//----------------------------------
	
	[Inspectable(category="General", defaultValue="true")]
	
	/**
	 *  @copy spark.components.VideoDisplay#autoPlay
	 * 
	 *  @default true
	 * 
	 */
	public function get autoPlay():Boolean
	{
		return youtubeDisplay.autoPlay;
	}
	
	//----------------------------------
	//  bytesLoaded
	//----------------------------------
	
	[Inspectable(Category="General", defaultValue="0")]
	[Bindable("bytesLoadedChange")]
	[Bindable("mediaPlayerStateChange")]
	
	/**
	 *  @copy spark.components.VideoDisplay#bytesLoaded
	 * 
	 *  @default 0
	 */
	public function get bytesLoaded():Number
	{
		if (youtubeDisplay)
			return youtubeDisplay.bytesLoaded;
		else
			return 0;
	}
	
	//----------------------------------
	//  bytesTotal
	//----------------------------------
	
	[Inspectable(Category="General", defaultValue="0")]
	[Bindable("mediaPlayerStateChange")]
	
	/**
	 *  @copy spark.components.VideoDisplay#bytesTotal
	 * 
	 *  @default 0
	 */
	public function get bytesTotal():Number
	{
		if (youtubeDisplay)
			return youtubeDisplay.bytesTotal;
		else
			return 0;
	}
	
	//----------------------------------
	//  currentTime
	//----------------------------------
	
	[Inspectable(Category="General", defaultValue="0")]
	[Bindable("currentTimeChange")]
	[Bindable("mediaPlayerStateChange")]
	
	/**
	 *  @copy spark.components.VideoDisplay#currentTime
	 * 
	 *  @default 0
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public function get currentTime():Number
	{
		if(youtubeDisplay)
			return youtubeDisplay.currentTime;
		else
			return 0;
	}
	
	//----------------------------------
	//  duration
	//----------------------------------
	
	[Inspectable(Category="General", defaultValue="0")]
	[Bindable("durationChange")]
	[Bindable("mediaPlayerStateChange")]
	
	/**
	 *  @copy spark.components.VideoDisplay#duration
	 * 
	 *  @default 0
	 */
	public function get duration():Number
	{
		if (youtubeDisplay)
			return youtubeDisplay.duration;
		else
			return 0;
	}
	
	//----------------------------------
	//  loop
	//----------------------------------
	
	[Inspectable(Category="General", defaultValue="false")]
	
	/**
	 *  @copy spark.components.VideoDisplay#loop
	 * 
	 *  @default false
	 */
	public function get loop():Boolean
	{
		return youtubeDisplay.loop;
	}
	
	/**
	 *  @private
	 */
	public function set loop(value:Boolean):void
	{
		if(youtubeDisplay)
			youtubeDisplay.loop = value;
		else
			youtubeDisplayProperties.loop = value;
	}
	
	//----------------------------------
	//  muted
	//----------------------------------
	
	[Inspectable(category="General", defaultValue="false")]
	[Bindable("volumeChanged")]
	
	/**
	 *  @copy spark.components.VideoDisplay#muted
	 * 
	 *  @default false
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public function get muted():Boolean
	{
		if (youtubeDisplay)
			return youtubeDisplay.muted;
		else
			return false;
	}
	
	/**
	 *  @private
	 */
	public function set muted(value:Boolean):void
	{
		if(youtubeDisplay)
			youtubeDisplay.muted = value;
		else
			youtubeDisplayProperties.muted = value;
		
		if (volumeBar)
			volumeBar.muted = value;
		if (muteButton)
			muteButton.muted = value;
	}
	
	//----------------------------------
	//  playing
	//----------------------------------
	
	[Inspectable(category="General")]
	[Bindable("mediaPlayerStateChange")]
	
	/**
	 *  @copy spark.components.VideoDisplay#playing
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public function get playing():Boolean
	{
		return youtubeDisplay.playing;
	}
	
	//----------------------------------
	//  quality
	//----------------------------------
	[Bindable("qualityChanged")]
	[Bindable("mediaPlayerStateChange")]
	
	public function get quality():String
	{
		if (youtubeDisplay)
			return youtubeDisplay.quality;
		else
			return "";
	}
	
	public function set quality(value:String):void
	{
		if (youtubeDisplay)
			youtubeDisplay.quality = value
		else
			youtubeDisplayProperties.quality = value;
		
		invalidateSize();
	}
	
	//----------------------------------
	//  videoId
	//----------------------------------
	
	[Inspectable(category="General", defaultValue="null")]
	[Bindable("videoIdChanged")]
	
	/**
	 *  @copy spark.components.VideoDisplay#videoId
	 * 
	 *  @default null
	 */
	public function get videoId():String
	{
		return youtubeDisplay.source;
	}
	
	/**
	 * @private
	 */
	public function set videoId(value:String):void
	{
		if (youtubeDisplay)					
			youtubeDisplay.videoId = value;
		else
			youtubeDisplayProperties.videoId = value
	}
	
	//----------------------------------
	//  volume
	//----------------------------------
	
	[Inspectable(category="General", defaultValue="1.0", minValue="0.0", maxValue="1.0")]
	[Bindable("volumeChanged")]
	
	/**
	 *  @copy spark.components.VideoDisplay#volume
	 * 
	 *  @default 1
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public function get volume():Number
	{
		return youtubeDisplay.volume;
	}
	
	/**
	 * @private
	 */
	public function set volume(value:Number):void
	{
		if (youtubeDisplay)					
			youtubeDisplay.volume = value;
		else
			youtubeDisplayProperties.volume = value
		
		if (volumeBar)
			volumeBar.value = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Public methods
	//
	//--------------------------------------------------------------------------
	
	public function pause():void
	{
		youtubeDisplay.pause();
	}
	
	public function play():void
	{
		youtubeDisplay.play();
	}
	
	public function seek(time:Number):void
	{
		youtubeDisplay.seek(time);
	}
	
	public function stop():void
	{
		youtubeDisplay.stop();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Private methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  @private
	 */
	private function updateScrubBar():void
	{
		if (!youtubeDisplay)
			return;
		
		if (!scrubBarMouseCaptured && !scrubBarChanging)
		{
			scrubBar.minimum = 0;
			scrubBar.maximum = youtubeDisplay.duration;
			scrubBar.value = youtubeDisplay.currentTime;
		}
		
		// if streaming, then we pretend to have everything in view
		// if progressive, then look at the bytesLoaded and bytesTotal
		if (!youtubeDisplay.buffering)
			scrubBar.loadedRangeEnd = youtubeDisplay.duration;
		else if (youtubeDisplay.bytesTotal == 0)
			scrubBar.loadedRangeEnd = 0;
		else
			scrubBar.loadedRangeEnd = (youtubeDisplay.bytesLoaded/youtubeDisplay.bytesTotal)*youtubeDisplay.duration;
	}
	
	/**
	 *  @private
	 */
	private function updateDuration():void
	{
		durationDisplay.text = formatTimeValue(duration);
	}
	
	/**
	 *  Formats a time value, specified in seconds, into a String that 
	 *  gets used for <code>currentTime</code> and the <code>duration</code>.
	 * 
	 *  @param value Value in seconds of the time to format
	 * 
	 *  @return Formatted time value
	 */
	protected function formatTimeValue(value:Number):String
	{
		// default format: hours:minutes:seconds
		value = Math.round(value);
		
		var hours:uint = Math.floor(value/3600) % 24;
		var minutes:uint = Math.floor(value/60) % 60;
		var seconds:uint = value % 60;
		
		var result:String = "";
		if (hours != 0)
			result = hours + ":";
		
		if (result && minutes < 10)
			result += "0" + minutes + ":";
		else
			result += minutes + ":";
		
		if (seconds < 10)
			result += "0" + seconds;
		else
			result += seconds;
		
		return result;
	}
	
	/**
	 *  @private
	 */
	private function updateCurrentTime():void
	{
		currentTimeDisplay.text = formatTimeValue(currentTime);
	} 
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  @private
	 */
	override protected function getCurrentSkinState():String
	{   
		var state:String = youtubeDisplay.mediaPlayerState;
		
		// now that we have our video player's current state (atleast the one we care about)
		// and that we've set the previous state to something we care about, let's figure 
		// out our skin's state
		
		if (!enabled)
			state="disabled"
		
		/*if (fullScreen)
			return state + "AndFullScreen";*/
		
		return state;
	}
	
	/**
	 *  @private
	 */
	override protected function partAdded(partName:String, instance:Object):void
	{
		super.partAdded(partName, instance);
		
		if (instance == youtubeDisplay)
		{
			
			if (youtubeDisplayProperties)
				for each ( var prop:Object in ObjectUtil.getClassInfo(youtubeDisplayProperties).properties )
					youtubeDisplay[prop.localName] = youtubeDisplayProperties[prop.localName];
			
			youtubeDisplay.addEventListener(TimeEvent.CURRENT_TIME_CHANGE, videoDisplay_currentTimeChangeHandler);
			youtubeDisplay.addEventListener(LoadEvent.BYTES_LOADED_CHANGE, videoDisplay_bytesLoadedChangeHandler);
			youtubeDisplay.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, videoDisplay_mediaPlayerStateChangeHandler);
			youtubeDisplay.addEventListener(TimeEvent.DURATION_CHANGE, videoDisplay_durationChangeHandler);
			youtubeDisplay.addEventListener(TimeEvent.COMPLETE, dispatchEvent);
			
			// just strictly for binding purposes
			youtubeDisplay.addEventListener("sourceChanged", dispatchEvent);
			youtubeDisplay.addEventListener("qualityChanged", dispatchEvent);
			youtubeDisplay.addEventListener("volumeChanged", videoDisplay_volumeChangedHandler);
			
		}
		else if (instance == playButton)
		{
			playButton.addEventListener(MouseEvent.CLICK, playButton_clickHandler);
		}
		else if (instance == pauseButton)
		{
			pauseButton.addEventListener(MouseEvent.CLICK, pauseButton_clickHandler);
		}
		else if (instance == playPauseButton)
		{
			playPauseButton.addEventListener(MouseEvent.CLICK, playPauseButton_clickHandler);
		}
		else if (instance == stopButton)
		{
			stopButton.addEventListener(MouseEvent.CLICK, stopButton_clickHandler);
		}
		else if (instance == muteButton)
		{
			muteButton.muted = muted;
			muteButton.volume = volume;
			
			muteButton.addEventListener(FlexEvent.MUTED_CHANGE, muteButton_mutedChangeHandler);
		}
		else if (instance == volumeBar)
		{
			volumeBar.minimum = 0;
			volumeBar.maximum = 100;
			volumeBar.value = 50;
			volumeBar.muted = muted;
			
			volumeBar.addEventListener(Event.CHANGE, volumeBar_changeHandler);
			volumeBar.addEventListener(FlexEvent.MUTED_CHANGE, volumeBar_mutedChangeHandler);
		}
		else if (instance == scrubBar)
		{
			if (youtubeDisplay)
				updateScrubBar();
			
			// add thumbPress and thumbRelease so we pause the video while dragging
			scrubBar.addEventListener(TrackBaseEvent.THUMB_PRESS, scrubBar_thumbPressHandler);
			scrubBar.addEventListener(TrackBaseEvent.THUMB_RELEASE, scrubBar_thumbReleaseHandler);
			
			// add change to actually seek() when the change is complete
			scrubBar.addEventListener(Event.CHANGE, scrubBar_changeHandler);
			
			// add changeEnd and changeStart so we don't update the scrubbar's value 
			// while the scrubbar is moving around due to an animation
			scrubBar.addEventListener(FlexEvent.CHANGE_END, scrubBar_changeEndHandler);
			scrubBar.addEventListener(FlexEvent.CHANGE_START, scrubBar_changeStartHandler);
		}
		else if (instance == fullScreenButton)
		{
			//fullScreenButton.addEventListener(MouseEvent.CLICK, fullScreenButton_clickHandler);
		}
		else if (instance == currentTimeDisplay)
		{
			if (youtubeDisplay)
				updateCurrentTime();
		}
		else if (instance == durationDisplay)
		{
			if (youtubeDisplay)
				updateDuration();
		}
	}
	
	/**
	 * @protected
	 */
	override protected function measure():void
	{
		super.measure();
		
		var betterWidth:Number;
		var betterHeight:Number;
		
		if (quality==YoutubeQuality.HD720)
		{
			measuredWidth =  1280;
			measuredHeight = 720;
		}
		else if	 (quality==YoutubeQuality.LARGE)
		{
			measuredWidth =  854;
			measuredHeight = 480;
		}
		else if	 (quality==YoutubeQuality.MEDIUM)
		{
			measuredWidth = 640;
			measuredHeight =360;
		}				
		else	
		{
			measuredWidth = 320;
			measuredHeight = 240;
		}	
		
		measuredHeight += 25;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Event handlers
	//
	//--------------------------------------------------------------------------
	
	private function videoDisplay_currentTimeChangeHandler(event:TimeEvent):void
	{
		if (scrubBar)
			updateScrubBar();
		
		if (currentTimeDisplay)
			updateCurrentTime();
		
		dispatchEvent(event);
	}
	
	private function videoDisplay_bytesLoadedChangeHandler(event:LoadEvent):void
	{
		if (scrubBar)
			updateScrubBar();
		
		dispatchEvent(event);
	}
	
	private function videoDisplay_durationChangeHandler(event:TimeEvent):void
	{
		if (scrubBar)
			updateScrubBar();
		
		if (durationDisplay)
			updateDuration();
		
		dispatchEvent(event);
	}
	
	private function videoDisplay_mediaPlayerStateChangeHandler(event:MediaPlayerStateChangeEvent):void
	{
		invalidateSkinState();
		
		if (scrubBar)
			updateScrubBar();
		
		if (durationDisplay)
			updateDuration();
		
		if (currentTimeDisplay)
			updateCurrentTime();
		
		if (playPauseButton)
			playPauseButton.selected = playing;
		
		dispatchEvent(event);
	}
	
	private function videoDisplay_volumeChangedHandler(event:Event):void
	{
		if (volumeBar)
		{
			volumeBar.value = volume;
			volumeBar.muted = muted;
		}
		
		if (muteButton)
		{
			muteButton.muted = muted;
			muteButton.volume = volume;
		}
		
		dispatchEvent(event);
	}
	
	private function playButton_clickHandler(event:MouseEvent):void
	{
		if (!playing)
			play();
	}
	
	private function pauseButton_clickHandler(event:MouseEvent):void
	{
		pause();
	}
	
	private function playPauseButton_clickHandler(event:MouseEvent):void
	{
		if (playing)
			pause();
		else
			play();
		
		// need to synch up to what we've actually got because sometimes 
		// the play() didn't actually play() because there's no source 
		// or we're in an error state
		playPauseButton.selected = playing;
	}
	
	private function stopButton_clickHandler(event:MouseEvent):void
	{
		stop();
	}
	
	private function muteButton_mutedChangeHandler(event:FlexEvent):void
	{
		muted = muteButton.muted;
	}
	
	private function volumeBar_changeHandler(event:Event):void
	{
		if (volume != volumeBar.value)
			volume = volumeBar.value;
	}
	
	private function volumeBar_mutedChangeHandler(event:FlexEvent):void
	{
		if (muted != volumeBar.muted)
			muted = volumeBar.muted;
	}		

	private var scrubBarMouseCaptured:Boolean;
	private var wasPlayingBeforeSeeking:Boolean;
	private var scrubBarChanging:Boolean;
	
	private function scrubBar_changeStartHandler(event:Event):void
	{
		scrubBarChanging = true;
	}
	
	private function scrubBar_thumbPressHandler(event:TrackBaseEvent):void
	{
		scrubBarMouseCaptured = true;
		if (playing)
		{
			pause();
			wasPlayingBeforeSeeking = true;
		}
	}

	private function scrubBar_thumbReleaseHandler(event:TrackBaseEvent):void
	{
		scrubBarMouseCaptured = false;
		if (wasPlayingBeforeSeeking)
		{
			play();
			wasPlayingBeforeSeeking = false;
		}
	}

	private function scrubBar_changeHandler(event:Event):void
	{
		seek(scrubBar.value);
	}
	
	private function scrubBar_changeEndHandler(event:Event):void
	{      
		scrubBarChanging = false;
	}
	  
}
}