package objects
{
	import core.Assets;
	
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	import states.GameState;

	public class AlienProjectile extends Projectile
	{
		private var _target:Array;
		private var _targetAngle:Number;
		
		public function AlienProjectile(game:GameState = null)
		{
			_game = game;
			
			this.addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		override protected function initialize(e:Event):void
		{
			super.initialize(e);
			
			_speed = 50;
		}
		
		override protected function createArt():void
		{
			super.createArt();
			
			_image = new Image(Assets.textureAtlasSpaceship.getTexture("enemy-projectile-1 instance 10000"));
			_image.alignPivot("center", "center");
			this.addChild(_image);
		}
		
		override public function update(deltaTime:Number):void
		{
			
		}

		public function get target():Array
		{
			return _target;
		}

		public function set target(value:Array):void
		{
			_target = value;
		}

		public function get targetAngle():Number
		{
			return _targetAngle;
		}

		public function set targetAngle(value:Number):void
		{
			_targetAngle = value;
		}


	}
}



































