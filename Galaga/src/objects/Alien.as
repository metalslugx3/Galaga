package objects
{
	import core.Assets;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Alien extends Sprite
	{
		private var _alienImage:Image;
		private var _type:uint;
		private var _speed:int;
		private var _fireRate:int;
		
		public function Alien(type:uint)
		{
			super();
			
			_type = type;
			
			this.addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		private function initialize(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, initialize);
			
			_speed = 250;
			_fireRate = 10;
			
			createArt();
		}
		
		private function createArt():void
		{
			// the type of alien this class will be
			switch (_type)
			{
				case 1:
					_alienImage = new Image(Assets.textureAtlas.getTexture("enemyship1-final instance 10000");
					break;
				case 2:
					_alienImage = new Image(Assets.textureAtlas.getTexture("enemyship2-final instance 10000");
					break;
				case 3:
					_alienImage = new Image(Assets.textureAtlas.getTexture("enemyship3-final instance 10000");
					break;
			}
			
			this.addChild(_alienImage);
			_alienImage.alignPivot("center", "center");
		}
		
		public function update(deltaTime):void
		{
			
		}
		
		public function destroy():void
		{
			this.removeChild(_alienImage);
			_alienImage.dispose();
			_alienImage = null;
		}
	}
}



































