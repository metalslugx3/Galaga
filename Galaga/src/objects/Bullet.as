package objects
{
	import core.Assets;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	import states.GameState;
	
	public class Bullet extends Sprite
	{
		private var _game:GameState;
		private var _image1:Image;
		
		private var _speed:Number;
		
		public function Bullet(game:GameState = null)
		{
			super();
			
			_game = game;
			
			this.addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		private function initialize():void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, initialize);
			
			_speed = 200;
			
			createArt();
		}
		
		private function createArt():void
		{
			_image1 = new Image(Assets.textureAtlasSpaceship.getTexture("player-projectile instance 10000"));
			_image1.alignPivot("center", "center");
			this.addChild(_image1);
		}
		
		public function update(deltaTime:Number):void
		{
			// ...
		}
		
		public function destroy():void
		{
			_image1.dispose();
			this.removeChild(_image1);
			_image1 = null;
			
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

	}
}



































