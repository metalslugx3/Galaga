package objects
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Alien extends Sprite
	{
		protected var _alienImage:Image;
		protected var _type:uint;
		protected var _speed:int;
		
		// the delay (in ms) before the object fires
		protected var _fireDelay:Number;
		protected var _fireRate:Number;
		
		// the height (in px) that the Alien is allowed to start firing
		protected var _fireHeight:Number;
		
		// the amount of points this Alien is worth
		protected var _pointsWorth:int;
		
		public function Alien()
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		protected function initialize(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, initialize);
			
			createArt();
		}
		
		protected function createArt():void
		{
			// create your art here
		}
		
		public function update(deltaTime:Number):void
		{
			
		}
		
		public function destroy():void
		{
			this.removeChild(_alienImage);
			_alienImage.dispose();
			_alienImage = null;
		}

		public function get type():uint
		{
			return _type;
		}

		public function set type(value:uint):void
		{
			_type = value;
		}

		public function get speed():int
		{
			return _speed;
		}

		public function set speed(value:int):void
		{
			_speed = value;
		}

		public function get fireRate():int
		{
			return _fireRate;
		}

		public function set fireRate(value:int):void
		{
			_fireRate = value;
		}

		public function get pointsWorth():int
		{
			return _pointsWorth;
		}

		public function set pointsWorth(value:int):void
		{
			_pointsWorth = value;
		}

		public function get fireDelay():Number
		{
			return _fireDelay;
		}

		public function set fireDelay(value:Number):void
		{
			_fireDelay = value;
		}

		public function get fireHeight():Number
		{
			return _fireHeight;
		}

		public function set fireHeight(value:Number):void
		{
			_fireHeight = value;
		}
	}
}



































