package objects
{
	import core.Assets;
	
	import starling.display.Image;
	import starling.events.Event;

	public class AlienMedium extends Alien
	{
		private var _hasFired:Boolean;
		
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
			_pointsWorth = 25;
			_hasFired = false;
			
			// we will set this dynamically when the Alien spawns (reason: so its different everytime a new Alien spawns)
			_fireDelay = 0;
			
			// we will set this dynamically when the Alien spawns (reason: so its different everytime a new Alien spawns)
			_fireHeight = 0;
		}
		
		override protected function createArt():void
		{
			super.createArt();
			
			_alienImage = new Image(Assets.textureAtlasSpaceship.getTexture("enemyship2-final instance 10000"));	
			this.addChild(_alienImage);
			_alienImage.alignPivot("center", "center");
		}
		
		public function fire():void
		{
			
		}

		public function get hasFired():Boolean
		{
			return _hasFired;
		}

		public function set hasFired(value:Boolean):void
		{
			_hasFired = value;
		}

	}
}



































