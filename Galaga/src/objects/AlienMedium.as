package objects
{
	import core.Assets;
	
	import starling.display.Image;
	import starling.events.Event;

	public class AlienMedium extends Alien
	{
		public function AlienMedium()
		{
			super();
		}
		
		override protected function initialize(e:Event):void
		{
			super.initialize(e);
			
			_type = 2;
			_speed = 100;
			_fireRate = 10;
		}
		
		override protected function createArt():void
		{
			super.createArt();
			
			_alienImage = new Image(Assets.textureAtlasSpaceship.getTexture("enemyship2-final instance 10000"));	
			this.addChild(_alienImage);
			_alienImage.alignPivot("center", "center");
		}
	}
}



































