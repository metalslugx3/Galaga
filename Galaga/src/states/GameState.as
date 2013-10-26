package states
{
	import citrus.core.starling.StarlingState;
	import citrus.input.InputAction;
	import citrus.input.InputController;
	import citrus.input.controllers.Keyboard;
	import citrus.view.starlingview.StarlingView;
	
	import flash.geom.Rectangle;
	
	import managers.AlienManager;
	import managers.BulletManager;
	import managers.CollisionManager;
	
	import objects.Background;
	import objects.Hero;
	
	public class GameState extends StarlingState
	{
		private var _bg:Background;
		private var _hero:Hero;
		private var _isGameOver:Boolean;
		
		private var _bulletManager:BulletManager;
		private var _alienManager:AlienManager;
		private var _collisionManager:CollisionManager;
		
		private var _gameBounds:Rectangle;
		
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
			createHero();
			createManagers();
			createKeyInputs();
			
			_gameBounds = new Rectangle(0, 80, stage.stageWidth, 400);
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			if (!_isGameOver)
			{
				updateHero(timeDelta);
				updateManagers(timeDelta);
			}
			else
			{
				cleanUpGameState();
				
				// go to the GameOverState
				_ce.state = new GameOverState();
			}
		}
		
		private function updateHero(deltaTime:Number):void
		{
			_hero.update(deltaTime);
			
			// check movement keys
			if (_ce.input.isDoing(Hero.KB_LEFT))
			{
				trace("left");
				_hero.x -= _hero.speed;
			}
			else if (_ce.input.isDoing(Hero.KB_RIGHT))
			{
				_hero.x += _hero.speed;
			}
			
			if (_ce.input.isDoing(Hero.KB_UP))
			{
				trace("up");
				_hero.y -= _hero.speed;
			}
			else if (_ce.input.isDoing(Hero.KB_DOWN))
			{
				_hero.y += _hero.speed;
			}
			
			// ensure the player stays within the game bounds
			checkGameBounds();
			
			// check fire key
			if (_ce.input.isDoing(Hero.KB_FIRE))
			{
				// allow the player to fire at least once by checking if time (frames passed on key press) is equal to 2
				// additional firing will be delayed the _fireRate in hero
				if (_ce.input.isDoing(Hero.KB_FIRE).time == 2 || _ce.input.isDoing(Hero.KB_FIRE).time % _hero.fireRate == 0)
				{
					_hero.fire();
				}
			}
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
		private function updateManagers(deltaTime:Number):void
		{
			_bulletManager.update(deltaTime);
		}
		
		private function createBackground():void
		{
			_bg = new Background("bg", {x:0,y:-_ce.stage.stageHeight,width:0,height:0});
			this.add(_bg);
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
			// TODO Auto Generated method stub
			_bulletManager = new BulletManager(this);
		}
		
		private function createKeyInputs():void
		{
			// create new keyactions here
			_ce.input.keyboard.addKeyAction(Hero.KB_FIRE, Keyboard.SPACE);
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
			//_alienManager.destroy();
			
			// desrtoy collision manager
			//_collisionManager.destroy();
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

	}
}



































