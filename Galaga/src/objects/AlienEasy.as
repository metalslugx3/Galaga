package objects
{
	import core.Assets;
	
	import starling.display.Image;
	import starling.events.Event;

	public class AlienEasy extends Alien
	{
		public function AlienEasy()
		{
			super();
		}
		
		override protected function initialize(e:Event):void
		{
			super.initialize(e);
			
			_type = 1;
			_speed = 75;
			_fireRate = 0;
		}
		
		override protected function createArt():void
		{
			super.createArt();
			
			_alienImage = new Image(Assets.textureAtlasSpaceship.getTexture("enemyship1-final instance 10000"));	
			this.addChild(_alienImage);
			_alienImage.alignPivot("center", "center");
		}
	}
}



































