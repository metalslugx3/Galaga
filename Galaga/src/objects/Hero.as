package objects
{
	import citrus.input.controllers.Keyboard;
	
	import core.Assets;
	
	import flash.utils.getTimer;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.particles.PDParticleSystem;
	
	import states.GameState;
	
	import treefortress.sound.SoundAS;
	
	public class Hero extends Sprite
	{
		//-------------
		//	Default keys
		//-------------
		public static var KB_UP:Object = {string:"up", key:Keyboard.UP};
		public static var KB_DOWN:Object = {string:"down", key:Keyboard.DOWN};
		public static var KB_LEFT:Object = {string:"left", key:Keyboard.LEFT};
		public static var KB_RIGHT:Object = {string:"right", key:Keyboard.RIGHT};
		public static var KB_FIRE:Object = {string:"fire", key:Keyboard.CTRL};
		public static var KB_BOMB:Object = {string:"bomb", key:Keyboard.J};
		public static var KB_PAUSE:Object = {string:"pause", key:Keyboard.P};
		public static var KB_OPTIONS:Object = {string:"options", key:Keyboard.O};
		
		public var totalPoints:int;
		
		private var _game:GameState;
		private var _image1:Image;
		
		// if the hero can fire or not
		private var _canFire:Boolean;
		
		// if the hero can fire a bomb or not
		private var _canFireBomb:Boolean;
		
		// the speed of the hero
		private var _speed:Number;
		
		// how many lives the hero has; 0 = game over
		private var _lives:int;
		
		// how many frames will pass before the hero can fire; minimum is 2.
		private var _fireRate:Number;
		
		// how many frames will pass before the hero can fire a bomb again; minimum is 2.
		private var _bombRate:Number;
		
		// if the player is currently invincible or not (for respawning)
		private var _isInvincible:Boolean;
		
		// how long the hero is invincible
		private var _invincibleTime:int;
		
		// the time invincibility started
		private var _invincibleStartTime:int;
		
		// the hero's exhaust particle system
		private var _exhaustPS:PDParticleSystem;
		
		// cooldown for bomb in ms
		private var _bombCoolDown:int;
		
		// the time (in ms since the flash player started) when the bomb went off
		private var _bombStartCoolDown:int;
		
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
			_canFireBomb = true;
			_speed = 150;
			_fireRate = 20;
			_bombRate = 200;
			_lives = 3;
			_isInvincible = false;
			_invincibleTime = 2500;
			_invincibleStartTime = 0;
			_bombCoolDown = 3000;
			
			totalPoints = 0;
			
			// this is negative so the hero can fire a bomb immediately
			_bombStartCoolDown = -_bombCoolDown;
			
			createArt();
			createExhaustPS();
		}
		
		private function createExhaustPS():void
		{
			_exhaustPS = new PDParticleSystem(XML(new Assets.XMLSmokeParticle()), Assets.getTextureFromAtlas("smoke"));
			_exhaustPS.alignPivot("center", "center");
			_game.addChild(_exhaustPS);
			//_exhaustPS.scaleX = _exhaustPS.scaleY = 0.4;
			//_exhaustPS.x = this.x;
			//_exhaustPS.y = this.y;
			_exhaustPS.start();
			
			// add it to the pausable juggler
			_game.pausedGameObjectsJuggler.add(_exhaustPS);
		}
		
		private function createArt():void
		{
			_image1 = new Image(Assets.textureAtlasSpaceship.getTexture("spaceship-final instance 10000"));
			_image1.alignPivot("center", "center");
			this.addChild(_image1);
		}
		
		public function fire():void
		{
			_game.heroProjectileManager.spawnProjectile();
		}
		
		public function fireBomb():void
		{
			// able to fire bombs if allowed; to prevent more than one explosion happening at once
			if (_canFireBomb)
			{
				// capture the current time & insert into the start cooldown for bomb
				_game.hero.bombStartCoolDown = getTimer();
				_game.heroProjectileManager.spawnBomb();
				_canFireBomb = false;
			}
		}
		
		public function update(deltaTime:Number):void
		{
			// check if the player is invincible to begin the invincible timer
			if (_isInvincible)
			{
				//trace(getInvincibleTimer());
				if (getTimer() - _invincibleStartTime >= _invincibleTime)
				{
					_isInvincible = false;
				}
			}
			
			// update the exhaust particle system to give it realistic motion
			_exhaustPS.emitterX = this.x;
			_exhaustPS.emitterY = this.y + 25;
		}
		
		/**
		 *	 Kills the hero.  Subtracts one life.  No more lives = game over.
		 * 
		 */		
		public function destroyHero():void
		{
			// play sound
			SoundAS.play(Assets.PLAYER_EXPLODE);
			
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
			// destroy exhaust particle system
			_game.removeChild(_exhaustPS);
			_exhaustPS.stop(true);
			Starling.juggler.remove(_exhaustPS);
			_exhaustPS.dispose();
			
			// destroy hero image
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

		public function get bombRate():Number
		{
			return _bombRate;
		}

		public function set bombRate(value:Number):void
		{
			_bombRate = value;
		}

		public function get canFireBomb():Boolean
		{
			return _canFireBomb;
		}

		public function set canFireBomb(value:Boolean):void
		{
			_canFireBomb = value;
		}

		public function get bombCoolDown():int
		{
			return _bombCoolDown;
		}

		public function set bombCoolDown(value:int):void
		{
			_bombCoolDown = value;
		}

		public function get bombStartCoolDown():int
		{
			return _bombStartCoolDown;
		}

		public function set bombStartCoolDown(value:int):void
		{
			_bombStartCoolDown = value;
		}


	}
}



































