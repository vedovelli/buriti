package buriti.components
{
import flash.display.Loader;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.net.URLRequest;

import mx.core.UIComponent;

import org.osmf.events.LoadEvent;
import org.osmf.events.MediaPlayerStateChangeEvent;
import org.osmf.events.TimeEvent;
import org.osmf.media.MediaPlayerState;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when the video is received from Youtube server.
 * 
 *  <p>This event may not be dispatched when the source is set to null or a playback
 *  error occurs.</p>
 *
 *  @eventType org.osmf.events.LoadEvent.BYTES_LOADED_CHANGE
 */
[Event(name="bytesLoadedChange",type="org.osmf.events.LoadEvent")]

/**
 *  Dispatched when the <code>currentTime</code> property of the MediaPlayer has changed.
 * 
 *  <p>This event may not be dispatched when the source is set to null or a playback
 *  error occurs.</p>
 *
 *  @eventType org.osmf.events.TimeEvent.CURRENT_TIME_CHANGE
 */
[Event(name="currentTimeChange",type="org.osmf.events.TimeEvent")]

/**
 *  Dispatched when the <code>duration</code> property of the media has changed.
 * 
 *  <p>This event may not be dispatched when the source is set to null or a playback
 *  error occurs.</p>
 * 
 *  @eventType org.osmf.events.TimeEvent.DURATION_CHANGE
 */
[Event(name="durationChange", type="org.osmf.events.TimeEvent")]

/**
 *  Dispatched when the MediaPlayer's state has changed.
 * 
 *  @eventType org.osmf.events.MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE
 */ 
[Event(name="mediaPlayerStateChange", type="org.osmf.events.MediaPlayerStateChangeEvent")]

/**
 *  Dispatched when the Youtube player error
 * 
 *  @eventType br.com.coc.events.YoutubeDisplayEvent.ERROR
 */
[Event(name="error", type="flash.events.ErrorEvent")]	


public class YoutubeDisplay extends UIComponent
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  Constructor.
	 */
	public function YoutubeDisplay()
	{
		super();
		
		addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, mediaPlayerStateChangeHandler);
	}
			
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  autoPlay
	//----------------------------------		
	private var _autoPlay:Boolean;

	[Inspectable(category="General", defaultValue="true")]
	public function get autoPlay():Boolean
	{
		return _autoPlay;
	}

	public function set autoPlay(value:Boolean):void
	{
		_autoPlay = value;
	}
	
	//----------------------------------
	//  buffering
	//----------------------------------
	[Bindable("bytesLoadedChange")]
	[Bindable("mediaPlayerStateChange")]
	public function get buffering():Boolean
	{
		return bytesLoaded < bytesTotal;
	}
	
	//----------------------------------
	//  bytesLoaded
	//----------------------------------
	private var _bytesLoaded:Number = 0;
	
	[Inspectable(Category="General", defaultValue="0")]
	[Bindable("bytesLoadedChange")]
	[Bindable("mediaPlayerStateChange")]
	
	public function get bytesLoaded():Number
	{
		return _bytesLoaded;
	}
	
	private function setBytesLoaded(value:Number):void
	{
		if (_bytesLoaded==value)
			return;
		
		_bytesLoaded = value;
		dispatchEvent( new LoadEvent(LoadEvent.BYTES_LOADED_CHANGE, false, false, "loading", value) );
	}
	
	//----------------------------------
	//  bytesTotal
	//----------------------------------
	private var _bytesTotal:Number = 0;
	
	[Inspectable(Category="General", defaultValue="0")]
	[Bindable("bytesTotalChange")]
	[Bindable("mediaPlayerStateChange")]
	
	public function get bytesTotal():Number
	{
		return _bytesTotal;
	}
	
	private function setBytesTotal(value:Number):void
	{
		if (_bytesTotal==value)
			return;
		
		_bytesTotal = value;
		dispatchEvent( new Event("bytesTotalChange") );		
	}
	
	//----------------------------------
	//  currentTime
	//----------------------------------
	private var _currentTime:Number = 0;
	
	[Inspectable(Category="General", defaultValue="0")]
	[Bindable("currentTimeChange")]
	[Bindable("mediaPlayerStateChange")]
	
	public function get currentTime():Number
	{
		return _currentTime;
	}
	
	private function setCurrentTime(value:Number):void
	{
		if (_currentTime==value)
			return;
		
		_currentTime = value;
		dispatchEvent( new TimeEvent(TimeEvent.CURRENT_TIME_CHANGE, false, false, value) );	
	}
	
	//----------------------------------
	//  duration
	//----------------------------------
	private var _duration:Number = 0;
	
	[Inspectable(Category="General", defaultValue="0")]
	[Bindable("durationChange")]
	[Bindable("mediaPlayerStateChange")]

	public function get duration():Number
	{
		if (player)			
			return player.getDuration();
		else
			return 0;
	}
	
	private function setDuration(value:Number):void
	{
		if (_duration==value)
			return;
		
		_duration = value;
		dispatchEvent( new TimeEvent(TimeEvent.DURATION_CHANGE, false, false, value) );	
	}	
	
	//----------------------------------
	//  loop
	//----------------------------------		
	private var _loop:Boolean;

	[Bindable("mediaPlayerStateChange")]
	public function get loop():Boolean
	{
		return _loop;
	}

	public function set loop(value:Boolean):void
	{
		_loop = value;
	}
	
	//----------------------------------
	//  mediaPlayerState
	//----------------------------------
	
	[Inspectable(category="General", defaultValue="uninitialized")]
	[Bindable("mediaPlayerStateChange")]
	
	/**
	 *  The current state of the video.  See 
	 *  org.osmf.media.MediaPlayerState for available values.
	 *  
	 *  @default uninitialized
	 * 
	 *  @see org.osmf.media.MediaPlayerState
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public function get mediaPlayerState():String
	{
		return getMediaPlayerState();
	}

	//----------------------------------
	//  muted
	//----------------------------------
	
	[Inspectable(category="General", defaultValue="false")]
	[Bindable("volumeChanged")]

	public function get muted():Boolean
	{
		if (player)			
			return player.isMuted();
		else
			return false;
	}
	
	/**
	 *  @private
	 */
	public function set muted(value:Boolean):void
	{
		if (muted == value)
			return;
		
		if (value)
			player.mute();
		else
			player.unMute();
		
		dispatchVolumeChangedEvent();
	}
	
	//----------------------------------
	//  playing
	//----------------------------------
	
	[Inspectable(category="General")]
	[Bindable("mediaPlayerStateChange")]
	
	public function get playing():Boolean
	{
		if (getMediaPlayerState()==MediaPlayerState.PLAYING)
			return true;
		
		return false;
	}

	//----------------------------------
	//  quality
	//----------------------------------
	private var _quality:String = YoutubeQuality.MEDIUM;

	[Bindable("qualityChanged")]
	[Bindable("mediaPlayerStateChange")]
	
	public function get quality():String
	{
		return _quality;
	}

	public function set quality(value:String):void
	{
		_quality = value;
		
		player.setPlaybackQuality(value);
		
		invalidateSize();
	}
	
	//----------------------------------
	//  startBytes
	//----------------------------------	
	private var _startBytes:Number = 0;
	
	[Inspectable(Category="General", defaultValue="0")]
	[Bindable("startBytesChange")]
	[Bindable("mediaPlayerStateChange")]
	
	public function get startBytes():Number
	{
		return _startBytes;
	}
	
	private function setStartBytes(value:Number):void
	{
		if(_startBytes==value)
			return;
		
		_startBytes = value;
		dispatchEvent( new Event("startBytesChange") );
	}
	
	//----------------------------------
	//  startSeconds
	//----------------------------------	
	[Bindable("mediaPlayerStateChange")]
	public var startSeconds:Number = 0;
	
	//----------------------------------
	//  videoId
	//----------------------------------
	private var _videoId:String;
	
	[Bindable("videoChanged")]
	[Bindable("mediaPlayerStateChange")]
	
	public function get videoId():String
	{
		return _videoId;
	}
	
	public function set videoId(value:String):void
	{
		_videoId = value;
		_videoUrl = null;
		
		invalidateCurrentVideo();
	}	

	//----------------------------------
	//  videoUrl
	//----------------------------------
	private var _videoUrl:String;
	
	[Bindable("videoChanged")]
	public function get videoUrl():String
	{
		return player.getVideoUrl();
	}
	
	//----------------------------------
	//  volume
	//----------------------------------
	
	[Inspectable(category="General", defaultValue="50", minValue="0.0", maxValue="100")]
	[Bindable("volumeChanged")]
	
	public function get volume():Number
	{
		if (player)
			return player.getVolume();
		else
			return 0;
	}
	
	/**
	 *  @private
	 */
	public function set volume(value:Number):void
	{
		if (volume == value)
			return;
		
		player.setVolume(value);
		
		dispatchVolumeChangedEvent();
	}
	
	//----------------------------------
	//  Youtube player loader
	//----------------------------------
	private var player:Object;
	private var playerLoader:Loader;
	
	//----------------------------------
	//  Read only properties
	//----------------------------------
	
	[Bindable("mediaPlayerStateChange")]
	public function get availabelQualityLevels():Array
	{
		return player.getAvailableQualityLevels();
	}		
	
	[Bindable("mediaPlayerStateChange")]
	public function get source():String
	{
		var _source:String;
		
		if (videoId)
			_source = videoId;
		else if (videoUrl)
			_source = videoUrl;
		
		return _source;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Public methods
	//
	//--------------------------------------------------------------------------			
	
	public function play():void
	{
		player.playVideo();
	}
	
	public function pause():void
	{
		player.pauseVideo();
	}
	
	public function stop():void
	{
		player.stopVideo();
	}
	
	public function seek(seconds:Number):void
	{
		player.seekTo(seconds, true);
	}	
	
	//--------------------------------------------------------------------------
	//
	//  Private methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 * Invalidate current video and change playing
	 */
	private var currentVideoInvalid:Boolean = false;
	
	private function invalidateCurrentVideo():void
	{
		currentVideoInvalid = true;
		
		invalidateProperties();
	}
	
	private function dispatchMediaPlayerStateChangeEvent():void
	{
		dispatchEvent( new MediaPlayerStateChangeEvent(
			MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, 
			false, false, getMediaPlayerState() )
		);	
	}	
	
	private function dispatchVolumeChangedEvent():void
	{
		dispatchEvent( new Event("volumeChanged") );
	}			
	
	private function getMediaPlayerState():String
	{
		if (!player)
			return MediaPlayerState.UNINITIALIZED;
		
		var state:String;
		
		switch( player.getPlayerState() )
		{
			case -1:
				state = MediaPlayerState.UNINITIALIZED;
				break;
			
			case 0:
				state = MediaPlayerState.READY;
				break;
			
			case 1:
				state = MediaPlayerState.PLAYING;
				break;
			
			case 2:
				state = MediaPlayerState.PAUSED;
				break;
			
			case 3:
				state = MediaPlayerState.BUFFERING;
				break;
			
			case 5:
				state = MediaPlayerState.READY;
				break;
		}
		
		return state;
	}		
	
	//--------------------------------------------------------------------------
	//
	//  Override methods
	//
	//--------------------------------------------------------------------------		
	
	/**
	 * @protected
	 * 
	 * */
	override protected function createChildren():void
	{
		if (!playerLoader)
		{
			playerLoader  = new Loader();
			playerLoader.load( new URLRequest("http://www.youtube.com/apiplayer?version=3"));
			playerLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, playerLoader_completeHandler);
			addChild(playerLoader);
		}
		
		super.createChildren();
	}
	
	/**
	 * @protected
	 * 
	 * */
	override protected function commitProperties():void
	{
		super.commitProperties();
		
		if(currentVideoInvalid && player)
		{
			currentVideoInvalid = false;
			
			if (autoPlay)
				player.loadVideoById(videoId, startSeconds, quality);
			else
				player.cueVideoById(videoId, startSeconds, quality);
		}			
	}
	
	override protected function measure():void
	{
		super.measure();
		
		var betterWidth:Number;
		var betterHeight:Number;
		
		if(player)
		{
			if (quality==YoutubeQuality.HD720)
			{
				betterWidth =  1280;
				betterHeight = 720;
			}
			else if	 (quality==YoutubeQuality.LARGE)
			{
				betterWidth =  854;
				betterHeight = 480;
			}
			else if	 (quality==YoutubeQuality.MEDIUM)
			{
				betterWidth = 640;
				betterHeight =360;
			}				
			else	
			{
				betterWidth=320;
				betterHeight=240;
			}				
			
			player.setSize(betterWidth, betterHeight);
		}			
		
	}
	
	//--------------------------------------------------------------------------
	//
	//  Event handlers
	//
	//--------------------------------------------------------------------------
	
	private function mediaPlayerStateChangeHandler(event:MediaPlayerStateChangeEvent):void
	{
		if (event.state == MediaPlayerState.PLAYING || buffering)
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		else
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
	}
	
	private function enterFrameHandler(event:Event):void
	{			
		setCurrentTime( player.getCurrentTime() );
		setDuration( player.getDuration() );
		setBytesLoaded( player.getVideoBytesLoaded() );
		setBytesTotal( player.getVideoBytesTotal() );
		setStartBytes(player.getVideoStartBytes() );
		
	}
	
	private function playerLoader_completeHandler(event:Event):void
	{			
		player = playerLoader.content;			
		player.addEventListener("onReady", player_readyHandler);
		player.addEventListener("onError", player_errorHandler);
		player.addEventListener("onStateChange", player_stateChangeHandler);			
		player.addEventListener("onPlaybackQualityChange", player_qualityChange);
	}
	
	private function player_readyHandler(event:Event):void
	{
		invalidateProperties();
	}
	
	private function player_qualityChange(event:Event):void
	{
		quality = player.getPlaybackQuality();
	}
	
	private function player_stateChangeHandler(event:Event):void
	{
		dispatchMediaPlayerStateChangeEvent();
	}
	
	private function player_errorHandler(event:Event):void
	{
		var errorEvent:ErrorEvent = new ErrorEvent(ErrorEvent.ERROR);
		errorEvent.text = Object(event).data
		dispatchEvent(errorEvent);
	}		
	
}
}