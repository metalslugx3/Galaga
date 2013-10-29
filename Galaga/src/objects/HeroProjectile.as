package objects
{
	import core.Assets;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	import states.GameState;
	
	public class HeroProjectile extends Projectile
	{
		public function HeroProjectile(game:GameState = null)
		{
			super();
			
			_game = game;
			
			this.addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		override protected function initialize(e:Event):void
		{
			super.initialize(e);
			
			_speed = 200;
		}
		
		override protected function createArt():void
		{
			super.createArt();
			
			_image = new Image(Assets.textureAtlasSpaceship.getTexture("player-projectile instance 10000"));
			_image.alignPivot("center", "center");
			this.addChild(_image);
		}
		
		override public function update(deltaTime:Number):void
		{
			
		}
	}
}



































