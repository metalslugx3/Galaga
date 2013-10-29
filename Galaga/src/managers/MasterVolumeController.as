package managers
{
	import core.Assets;
	
	import feathers.controls.Slider;
	import feathers.themes.MetalWorksMobileTheme;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	
	import treefortress.sound.SoundAS;
	
	public class MasterVolumeController extends Sprite
	{
		private static var instance:MasterVolumeController;
		private static var allowInstantiation:Boolean;
		
		private var _sliderContainer:Sprite;
		private var _slider:Slider;
		
		// TODO: create container for icon and slider
		
		public function MasterVolumeController()
		{
			if (!allowInstantiation)
			{
				throw new Error("Cannot use the 'new' on this Class.");
			}
			
			this.addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		private function initialize(e:Event):void
		{
			trace("MasterVolumController initialize()");
			this.removeEventListener(Event.ADDED_TO_STAGE, initialize);
			
			createContainer();
			createIcon();
			createVolumeSlider();
			
			// re-adjust container since all stuff has been added to it
			_sliderContainer.x = stage.stageWidth - _sliderContainer.width;
			_sliderContainer.y = 0;
		}
		
		private function createContainer():void
		{
			_sliderContainer = new Sprite();
			stage.addChild(_sliderContainer);
		}
		
		private function createIcon():void
		{
			var icon:Image = new Image(Assets.getTextureFromAtlas("volume-icon-final"));
			_sliderContainer.addChild(icon);
		}
		
		private function createVolumeSlider():void
		{
			//  theme, is needed
			new MetalWorksMobileTheme();
			
			_slider = new Slider();
			_slider.direction = Slider.DIRECTION_VERTICAL;
			_sliderContainer.addChild(_slider);
			_slider.validate();
			_slider.step = 1;
			_slider.maximum = 100;
			_slider.minimum = 0;
			_slider.value = 100;
			_slider.alpha = 0.0;
			_slider.addEventListener(Event.CHANGE, sliderChanged);
			_slider.addEventListener(TouchEvent.TOUCH, onTouch);
			_slider.x = _slider.width * 0.5;
			//_slider.isQuickHitAreaEnabled = true;
		}
		
		/**
		 * 	Get the touch event if its the _slider.  If it is set alpha to 1 then when touch is null (not hovering _slider) set alpha to 0.
		 * */
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(_slider);
			
			if (touch)
			{
				_slider.alpha = 1.0;
			}
			else	
			{
				_slider.alpha = 0.0;
			}
		}
		
		/**
		 * 	Handles volume slider.
		 * */
		private function sliderChanged(e:Event):void
		{
			trace((e.target as Slider).value);
			
			SoundAS.masterVolume = (e.target as Slider).value;
		}
		
		/**
		 * 	Destroy this Class but really there is no need; it should exist always.
		 * */
		public function destroy():void
		{
			
		}
		
		public static function getInstance():MasterVolumeController
		{
			if (instance == null)
			{
				allowInstantiation = true;
				instance = new MasterVolumeController();
				allowInstantiation = false;
			}
			
			return instance;
		}
	}
}



































