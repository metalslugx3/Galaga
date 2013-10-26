package objects
{
	import core.Assets;
	
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
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
		
		// if the hero can fire or not
		private var _canFire:Boolean;
		
		// the speed of the hero
		private var _speed:Number;
		
		// how many lives the hero has; 0 = game over
		private var _lives:int;
		
		// how many frames will pass before the hero can fire; minimum is 2.
		private var _fireRate:Number;
		
		// if the player is currently invincible or not (for respawning)
		private var _isInvincible:Boolean;
		
		// how long the hero is invincible
		private var _invincibleTime:int;
		
		// the time invincibility started
		private var _invincibleStartTime:int;
		
		public function Hero(game:GameState)
		{
			super();
			
			_game = game;
			
			this.addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		private function initialize():void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, initialize);
			
			_canFire = false;
			_speed = 3;
			_fireRate = 20;
			_lives = 3;
			_isInvincible = false;
			_invincibleTime = 2500;
			_invincibleStartTime = 0;
			
			createArt();
		}
		
		private function createArt():void
		{
			_image1 = new Image(Assets.textureAtlasSpaceship.getTexture("spaceship-final instance 10000"));
			_image1.alignPivot("center", "center");
			this.addChild(_image1);
		}
		
		public function fire():void
		{
			_game.bulletManager.spawnBullet();
		}
		
		public function update(deltaTime:Number):void
		{
			if (_isInvincible)
			{
				trace(getInvincibleTimer());
				if (getTimer() - _invincibleStartTime >= _invincibleTime)
				{
					_isInvincible = false;
				}
			}
		}
		
		/**
		 *	 Kills the hero.  Subtracts one life.  No more lives = game over.
		 * 
		 */		
		public function destroyHero():void
		{
			// subtract 1 life
			_lives--;
			
			if (_lives <= 0)
			{
				_game.isGameOver = true;
			}
			else
			{
				// blink and ressurect
				this.x = stage.stageWidth * 0.5;
				this.y = stage.stageHeight - this.height * 0.5;
				_isInvincible = true;
				_invincibleStartTime = getTimer();
			}
		}
		
		/**
		 *	Gets the invincible timer count down if the player is invincible otherwise 0 is returned.
		 *  
		 * @return the invincible timer count down
		 * 
		 */		
		public function getInvincibleTimer():Number
		{
			if (!_isInvincible)
			{
				return 0;
			}
			
			return (_invincibleTime - (getTimer() - _invincibleStartTime));
		}
		
		/**
		 *	Primarily used to destroy the whole class. Clean up. 
		 * 
		 */		
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

		public function get fireRate():Number
		{
			return _fireRate;
		}

		public function set fireRate(value:Number):void
		{
			_fireRate = value;
		}

		public function get lives():int
		{
			return _lives;
		}

		public function set lives(value:int):void
		{
			_lives = value;
		}

		public function get isInvincible():Boolean
		{
			return _isInvincible;
		}

		public function set isInvincible(value:Boolean):void
		{
			_isInvincible = value;
		}
	}
}



































