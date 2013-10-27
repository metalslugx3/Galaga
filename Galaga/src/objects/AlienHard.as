package objects
{
	import core.Assets;
	
	import starling.display.Image;
	import starling.events.Event;

	public class AlienHard extends Alien
	{
		public function AlienHard()
		{
			super();
		}
		
		override protected function initialize(e:Event):void
		{
			super.initialize(e);
			
			_type = 3;
			_speed = 125;
			_fireRate = 50;
		}
		
		override protected function createArt():void
		{
			super.createArt();
			
			_alienImage = new Image(Assets.textureAtlasSpaceship.getTexture("enemyship3-final instance 10000"));	
			this.addChild(_alienImage);
			_alienImage.alignPivot("center", "center");
		}
	}
}



































