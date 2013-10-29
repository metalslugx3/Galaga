package states
{
	import citrus.core.starling.StarlingState;
	import citrus.input.InputPhase;
	import citrus.input.controllers.Keyboard;
	
	import core.Assets;
	
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import managers.AlienManager;
	import managers.AlienProjectileManager;
	import managers.BulletManager;
	import managers.CollisionManager;
	import managers.ExplosionManager;
	
	import objects.Background;
	import objects.HUD;
	import objects.Hero;
	
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class GameState extends StarlingState
	{
		private var _bg:Background;
		private var _hud:HUD;
		private var _hero:Hero;
		private var _isGameOver:Boolean;
		
		//----------------
		//	Managers
		//----------------
		private var _bulletManager:BulletManager;
		private var _alienManager:AlienManager;
		private var _collisionManager:CollisionManager;
		private var _explosionManager:ExplosionManager;
		private var _alienProjectileManager:AlienProjectileManager;
		
		private var _gameBounds:Rectangle;
		private var _level:int;
		private var _timeToIncreaseDifficulty:int;
		private var _lastTime:Number;
		
		//----------------
		//	Paused
		//----------------
		private var _isPaused:Boolean = false;
		private var _hasPressedEsc:Boolean = false;
		private var _pausedImage:Image;
		
		// juggler to hold IAnimateable objects for pausing
		private var _pausedGameObjectsJuggler:Juggler;
		
		public function GameState()
		{
			super();
			
			trace("GameState started.");
		}
		
		/**
		 * Initialize the state.
		 * */
		override public function initialize():void
		{
			super.initialize();
			
			_isGameOver = false;
			
			createBackground();
			createHUD();
			createPaused();
			createHero();
			createManagers();
			createKeyInputs();
			
			_gameBounds = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			_level = 15;
			_lastTime = 0;
			_timeToIncreaseDifficulty = 500;
		}
		
		private function createPaused():void
		{
			_pausedImage = new Image(Assets.getTextureFromAtlas("paused"));
			this.addChild(_pausedImage);
			
			_pausedImage.alignPivot("center", "center");
			_pausedImage.x = (stage.stageWidth >> 1);
			_pausedImage.y = (stage.stageHeight >> 1);
			_pausedImage.visible = false;
			
			// create juggler for pausing game objects
			_pausedGameObjectsJuggler = new Juggler();
			Starling.juggler.add(_pausedGameObjectsJuggler);
		}
		
		override public function update(timeDelta:Number):void
		{
			if (!_isGameOver)
			{
				// if the game isn't paused run these methods only
				if (!_isPaused)
				{
					super.update(timeDelta);
					checkDifficulty();
					updateHero(timeDelta);
					updateManagers(timeDelta);
				}
				
				// keep the method for checking pause on/off running unless its gameover
				updateKeyOtherKeyPresses();
			}
			
			if (_isGameOver)
			{
				cleanUpGameState();
				
				// go to the GameOverState
				_ce.state = new GameOverState();
			}
		}
		
		/**
		 *Increase game difficulty every few seconds. 
		 * 
		 */		
		private function checkDifficulty():void
		{
			if (getTimer() - _lastTime > _timeToIncreaseDifficulty)
			{
				// increase the current level
				_level++;
				
				// set the last time to the current time
				_lastTime = getTimer();
				
				// increase the difficulty for each Alien
				_alienManager.increaseDifficulty();
				
				// increase bg scroll speed slightly
				_bg.velocity = [0, _bg.velocity[1]+=1];
				
				//trace("level: " + _level);
			}
		}
		
		private function updateHero(deltaTime:Number):void
		{
			_hero.update(deltaTime);
			
			// check movement keys
			if (_ce.input.isDoing(Hero.KB_LEFT))
			{
				//trace("left");
				_hero.x -= _hero.speed;
			}
			else if (_ce.input.isDoing(Hero.KB_RIGHT))
			{
				_hero.x += _hero.speed;
			}
			
			
			if (_ce.input.isDoing(Hero.KB_UP))
			{
				//trace("up");
				_hero.y -= _hero.speed;
			}
			else if (_ce.input.isDoing(Hero.KB_DOWN))
			{
				_hero.y += _hero.speed;
			}
			
			
			// check fire key
			if (_ce.input.isDoing((Hero.KB_FIRE)))
			{
				// allow the player to fire at least once by checking if time (frames passed on key press) is equal to 2
				// additional firing will be delayed the _fireRate in hero
				if (_ce.input.isDoing(Hero.KB_FIRE).time == 2 || _ce.input.isDoing(Hero.KB_FIRE).time % _hero.fireRate == 0)
				{
					_hero.fire();
				}
			}
			
			
			// ensure the player stays within the game bounds
			checkGameBounds();
		}
		
		/**
		 * Check the players position against the allowed game bounds.
		 * */
		private function checkGameBounds():void
		{
			// right & left bounds
			if (_hero.x + _hero.width * 0.5 > _gameBounds.right)
			{
				_hero.x = _gameBounds.right - _hero.width * 0.5;
			}
			else if (_hero.x - _hero.width * 0.5 < 0)
			{
				_hero.x = _hero.width * 0.5;
			}
			
			// top & bottom bounds
			if (_hero.y - _hero.height * 0.5 < _gameBounds.top)
			{
				_hero.y = _gameBounds.top + _hero.height * 0.5;
			}
			else if (_hero.y + _hero.height * 0.5 > _gameBounds.bottom)
			{
				_hero.y = _gameBounds.bottom - _hero.height * 0.5;
			}
		}
		
		/**
		 * Update all managers with deltaTime.
		 * */
		// TODO: deltatime should be a local var
		private function updateManagers(deltaTime:Number):void
		{
			_bulletManager.update(deltaTime);
			_alienManager.update(deltaTime);
			_explosionManager.update(deltaTime);
			_alienProjectileManager.update(deltaTime);
			_collisionManager.update(deltaTime);
		}
		
		/**
		 * 	This handles updates for keypresses that are generalized.
		 * */
		private function updateKeyOtherKeyPresses():void
		{
			// check for escape to pause game
			if (!_hasPressedEsc && _ce.input.hasDone(Hero.KB_PAUSE))
			{
				// pause game
				_isPaused = !_isPaused;
				_hasPressedEsc = true;
				
				// show paused image
				if (_isPaused)
				{
					// remove the juggler holding animations from the default juggler to pause
					Starling.juggler.remove(_pausedGameObjectsJuggler);
					
					_pausedImage.visible = true;
					//Starling.current.stop(true);
				}
					
				else
				{
					// add the juggler holding animations from the default juggler to continue animation
					Starling.juggler.add(_pausedGameObjectsJuggler);
					
					_pausedImage.visible = false;
					//Starling.current.start();
				}
					
				trace("pause: " + _isPaused);
			}
			else
			{
				_hasPressedEsc = false;
			}
		}
		
		private function createBackground():void
		{
			_bg = new Background("bg", {x:0,y:-_ce.stage.stageHeight,width:0,height:0});
			this.add(_bg);
		}
		
		private function createHUD():void
		{
			_hud = new HUD(this);
			this.addChild(_hud);
		}
		
		private function createHero():void
		{
			_hero = new Hero(this);
			this.addChild(_hero);
			_hero.x = stage.stageWidth * 0.5;
			_hero.y = stage.stageHeight - _hero.height * 0.5;
		}
		
		private function createManagers():void
		{
			_bulletManager = new BulletManager(this);
			_alienManager = new AlienManager(this);
			_collisionManager = new CollisionManager(this);
			_explosionManager = new ExplosionManager(this);
			_alienProjectileManager = new AlienProjectileManager(this);
		}
		
		private function createKeyInputs():void
		{
			// create new keyactions here
			_ce.input.keyboard.addKeyAction(Hero.KB_FIRE, Keyboard.CTRL, 0);
			_ce.input.keyboard.addKeyAction(Hero.KB_PAUSE, Keyboard.ESCAPE, 0);
		}
		
		/**
		 * Clean up the state.
		 * */
		override public function destroy():void
		{
			super.destroy();
		}
		
		/**
		 * Cleans all objects/references in the GameState.
		 * */
		private function cleanUpGameState():void
		{
			// destroy hero
			this.removeChild(_hero);
			_hero.destroy();
			_hero.dispose();
			
			// destroy keyboard?
			
			// destroy bullet manager
			_bulletManager.destroy();
			
			// destroy alien manager
			_alienManager.destroy();
			
			// destroy collision manager
			_collisionManager.destroy();
			
			// destroy explosion manager
			_explosionManager.destroy();
			
			// destroy alien projectile manager
			_alienProjectileManager.destroy();
			
			// destroy the HUD
			_hud.destroy();
			
			// destroy paused image
			stage.removeChild(_pausedImage);
			_pausedImage.dispose();
			_pausedImage = null;
			
			// destroy juggler
			_pausedGameObjectsJuggler.purge();
			Starling.juggler.purge();
		}
		
		public function get collisionManager():CollisionManager
		{
			return _collisionManager;
		}

		public function set collisionManager(value:CollisionManager):void
		{
			_collisionManager = value;
		}

		public function get alienManager():AlienManager
		{
			return _alienManager;
		}
		
		public function set alienManager(value:AlienManager):void
		{
			_alienManager = value;
		}
		
		public function get bulletManager():BulletManager
		{
			return _bulletManager;
		}

		public function set bulletManager(value:BulletManager):void
		{
			_bulletManager = value;
		}

		public function get hero():Hero
		{
			return _hero;
		}

		public function set hero(value:Hero):void
		{
			_hero = value;
		}

		public function get level():int
		{
			return _level;
		}

		public function set level(value:int):void
		{
			_level = value;
		}

		public function get isGameOver():Boolean
		{
			return _isGameOver;
		}

		public function set isGameOver(value:Boolean):void
		{
			_isGameOver = value;
		}

		public function get explosionManager():ExplosionManager
		{
			return _explosionManager;
		}

		public function set explosionManager(value:ExplosionManager):void
		{
			_explosionManager = value;
		}

		public function get alienProjectileManager():AlienProjectileManager
		{
			return _alienProjectileManager;
		}

		public function set alienProjectileManager(value:AlienProjectileManager):void
		{
			_alienProjectileManager = value;
		}

		public function get hud():HUD
		{
			return _hud;
		}

		public function set hud(value:HUD):void
		{
			_hud = value;
		}

		public function get pausedGameObjectsJuggler():Juggler
		{
			return _pausedGameObjectsJuggler;
		}

		public function set pausedGameObjectsJuggler(value:Juggler):void
		{
			_pausedGameObjectsJuggler = value;
		}
	}
}



































