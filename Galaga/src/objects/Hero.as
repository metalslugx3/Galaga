package objects
{
	import citrus.input.controllers.Keyboard;
	import citrus.math.MathVector;
	
	import core.Assets;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
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
		
		public function Hero(game:GameState)
		{
			super();
			
			_game = game;
			
			initialize();
		}
		
		private function initialize():void
		{
			_canFire = false;
			_speed = 3;
			
			createArt();
		}
		
		private function createArt():void
		{
			_image1 = new Image(Assets.textureAtlasSpaceship.getTexture("spaceship-final instance 10000"));
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


	}
}



































