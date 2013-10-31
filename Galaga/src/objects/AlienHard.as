package objects
{
	import core.Assets;
	
	import starling.display.Image;
	import starling.events.Event;

	public class AlienHard extends Alien
	{
		private var _hasFired:Boolean;
		
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
			_pointsWorth = 60;
			_hasFired = false;
			
			// we will set this dynamically when the Alien spawns (reason: so its different everytime a new Alien spawns)
			_fireDelay = 0;
			
			// we will set this dynamically when the Alien spawns (reason: so its different everytime a new Alien spawns)
			_fireHeight = 0;
		}
		
		override protected function createArt():void
		{
			super.createArt();
			
			_alienImage = new Image(Assets.textureAtlasSpaceship.getTexture("enemyship3-final instance 10000"));	
			this.addChild(_alienImage);
			_alienImage.alignPivot("center", "center");
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



































