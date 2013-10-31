package
{
	import citrus.core.starling.StarlingCitrusEngine;
	
	import core.Assets;
	
	import flash.events.Event;
	import flash.system.Capabilities;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import starling.core.Starling;
	import starling.core.starling_internal;
	import starling.events.Event;
	
	import states.MenuState;
	
	import treefortress.sound.SoundAS;
	
	[SWF(width="640", height="480", frameRate="60", backgroundColor="#505050")]
	public class Galaga extends StarlingCitrusEngine
	{
		public function Galaga()
		{
			// if the stage isn't initialized then we wait for it to be initialized
			if (stage)
				init();
			else
				stage.addEventListener(flash.events.Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * Initialize statements.
		 * */
		private function init(e:flash.events.Event = null):void
		{
			// remove the stage listener
			stage.removeEventListener(flash.events.Event.ADDED_TO_STAGE, init);
			
			//Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			// set up the Starling instance & show fps
			setUpStarling(false);
		}
		
		private function loop(e:starling.events.Event):void
		{
			
		}
		
		/**
		 * Override the _context3DCreated to ensure that the context3D exists before initializing our Atlas.
		 * */
		override protected function _context3DCreated(evt:starling.events.Event):void
		{
			super._context3DCreated(evt);
			
			Assets.init();
			
			trace("context3D good to go.");
			
			// go to a new state when the context3D is ready
			this.state = new MenuState();
		}
	}
}



































