package states
{
	import citrus.core.starling.StarlingState;
	import citrus.input.InputAction;
	import citrus.input.InputController;
	import citrus.input.controllers.Keyboard;
	
	import objects.Background;
	import objects.Hero;
	
	public class GameState extends StarlingState
	{
		private var _bg:Background;
		private var _hero:Hero;
		private var _isGameOver:Boolean;
		private var _keyboard:Keyboard;
		
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
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			if (!_isGameOver)
			{
				_hero.update(timeDelta);
				
				// check movement keys
				if (_ce.input.isDoing(Hero.KB_LEFT))
				{
					_hero.x -= _hero.speed;
				}
				
				if (_ce.input.isDoing(Hero.KB_RIGHT))
				{
					_hero.x += _hero.speed;
				}
				
				if (_ce.input.isDoing(Hero.KB_UP))
				{
					_hero.y -= _hero.speed;
				}
				
				if (_ce.input.isDoing(Hero.KB_DOWN))
				{
					_hero.y += _hero.speed;
				}
				
				// check fire key
				if (_ce.input.isDoing(Hero.KB_FIRE) && _hero.canFire)
				{
					trace("fire");	
				}
			}
		}
		
		/**
		 * Clean up the state.
		 * */
		override public function destroy():void
		{
			super.destroy();
			
			
		}
		
		private function createBackground():void
		{
			_bg = new Background("bg", {x:0,y:-_ce.stage.stageHeight,width:0,height:0});
			this.add(_bg);
		}
		
		private function createHero():void
		{
			_hero = new Hero(this);
			_hero.x = stage.stageWidth * 0.5;
			_hero.y = stage.stageHeight - _hero.height * 0.5;
			this.addChild(_hero);
		}
		
		private function createManagers():void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function createKeyInputs():void
		{
			// create a new keyboard
			_keyboard = new Keyboard("keyboard");
			
			// create new keyactions here
			_keyboard.addKeyAction(Hero.KB_FIRE, Keyboard.SPACE);
			_keyboard.addKeyAction(Hero.KB_LEFT, Keyboard.LEFT);
			_keyboard.addKeyAction(Hero.KB_RIGHT, Keyboard.RIGHT);
			_keyboard.addKeyAction(Hero.KB_UP, Keyboard.UP);
			_keyboard.addKeyAction(Hero.KB_DOWN, Keyboard.DOWN);
		}
	}
}



































