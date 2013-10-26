package objects
{
	import core.Assets;
	
	import flash.geom.Rectangle;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	import states.GameState;
	
	public class Hero extends Sprite
	{
		public static const KB_FIRE:String = "fire";
		public static const KB_LEFT:String = "left";
		public static const KB_RIGHT:String = "right";
		public static const KB_UP:String = "up";
		public static const KB_DOWN:String = "down";
		
		private var _game:GameState;
		private var _image1:Image;
		
		private var _canFire:Boolean;
		private var _speed:Number;
		
		// how many frames will pass before the player can fire; minimum is 2.
		private var _fireRate:Number;
		
		public function Hero(game:GameState)
		{
			super();
			
			_game = game;
			
			this.addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		private function initialize():void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, initialize);
			
			_canFire = false;
			_speed = 3;
			_fireRate = 40;
			
			// the area the player is allowed to move
			
			
			createArt();
		}
		
		private function createArt():void
		{
			_image1 = new Image(Assets.textureAtlasSpaceship.getTexture("spaceship-final instance 10000"));
			_image1.alignPivot("center", "center");
			this.addChild(_image1);
		}
		
		public function fire():void
		{
			_game.bulletManager.spawnBullet();
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

		public function get canFire():Boolean
		{
			return _canFire;
		}

		public function set canFire(value:Boolean):void
		{
			_canFire = value;
		}

		public function get speed():Number
		{
			return _speed;
		}

		public function set speed(value:Number):void
		{
			_speed = value;
		}

		public function get fireRate():Number
		{
			return _fireRate;
		}

		public function set fireRate(value:Number):void
		{
			_fireRate = value;
		}
	}
}



































