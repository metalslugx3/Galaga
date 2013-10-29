package objects
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	import states.GameState;
	
	public class Projectile extends Sprite
	{
		protected var _game:GameState;
		protected var _image:Image;
		
		// the type of projectile (ie: small, medium, large / pistol, shotgun, laser, missile)
		protected var _type:int;
		protected var _speed:Number;
		
		public function Projectile(game:GameState = null)
		{
			super();
			
			_game = game;
			
			this.addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		protected function initialize(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, initialize);
			
			createArt();
		}
		
		protected function createArt():void
		{
			
		}
		
		public function update(deltaTime:Number):void
		{
			// ...
		}
		
		public function destroy():void
		{
			_image.dispose();
			this.removeChild(_image);
			_image = null;
			
			_game = null;
		}
		
		public function get speed():Number
		{
			return _speed;
		}
		
		public function set speed(value:Number):void
		{
			_speed = value;
		}

		public function get type():int
		{
			return _type;
		}

		public function set type(value:int):void
		{
			_type = value;
		}

	}
}



































