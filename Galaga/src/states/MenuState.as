package states
{
	import citrus.core.starling.StarlingState;
	import citrus.objects.CitrusSprite;
	import citrus.view.spriteview.SpriteView;
	
	import core.Assets;
	
	import flashx.textLayout.elements.OverflowPolicy;
	
	import nape.geom.AABB;
	
	import objects.Background;
	
	import starling.display.Button;
	import starling.events.Event;
	
	public class MenuState extends StarlingState
	{
		private var _bg:Background;
		private var _titleCS:CitrusSprite;
		private var _startBtn:Button;
		private var _optionsBtn:Button;
		
		public function MenuState()
		{
			super();
			
			trace("MenuState started.");
		}
		
		/**
		 * Initialize the state.
		 * */
		override public function initialize():void
		{
			super.initialize();
			
			createBackground();
			createTitle();
			createStartButton();
			createOptionsButton();
		}
		
		/**
		 * Clean up the state.
		 * */
		override public function destroy():void
		{
			super.destroy();
			
			// destroy title
			// destroy bg
			
			// remove Starling buttons
			_optionsBtn.removeEventListener(Event.TRIGGERED, buttonTriggered);
			_optionsBtn.dispose();
			this.removeChild(_optionsBtn);
			_optionsBtn = null;
			
			_startBtn.removeEventListener(Event.TRIGGERED, buttonTriggered);
			_startBtn.dispose();
			this.removeChild(_startBtn);
			_startBtn = null;
		}
		
		private function createBackground():void
		{
			_bg = new Background("bg", {x:0,y:-_ce.stage.stageHeight,width:0,height:0});
			this.add(_bg);
		}
		
		/**
		 * Create the options button.
		 * */
		private function createOptionsButton():void
		{
			_optionsBtn = new Button(Assets.textureAtlas.getTexture("options"));
			_optionsBtn.x = _ce.stage.stageWidth * 0.5 - _optionsBtn.width * 0.5;
			_optionsBtn.y = 200;
			_optionsBtn.addEventListener(Event.TRIGGERED, buttonTriggered);
			this.addChild(_optionsBtn);
		}
		
		/**
		 * Create the start button.
		 * */
		private function createStartButton():void
		{	
			_startBtn = new Button(Assets.textureAtlas.getTexture("start"));
			_startBtn.x = _ce.stage.stageWidth * 0.5 - _startBtn.width * 0.5;
			_startBtn.y = 150;
			_startBtn.addEventListener(Event.TRIGGERED, buttonTriggered);
			this.addChild(_startBtn);
		}
		
		/**
		 * Create the title.
		 * */
		private function createTitle():void
		{
			_titleCS = new CitrusSprite("title", {x:_ce.stage.stageWidth * 0.5,y:100,width:0,height:0});
			_titleCS.registration = "center";
			_titleCS.view = Assets.textureAtlas.getTexture("title");
			this.add(_titleCS);
		}
		
		/**
		 * Listen for the start and options button click.
		 * */
		private function buttonTriggered(e:Event):void
		{
			var btn:Button = e.target as Button;
			
			if (e.target == _startBtn)
			{
				startGame();
			}
			else if (e.target == _optionsBtn)
			{
				optionsMenu();
			}
			
			btn = null;
		}
		
		private function startGame():void
		{
			_ce.state = new GameState();
		}
		
		private function optionsMenu():void
		{
			// TODO Auto Generated method stub
			
		}
	}
}



































