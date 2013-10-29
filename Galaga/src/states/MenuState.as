package states
{
	import citrus.core.starling.StarlingState;
	import citrus.objects.CitrusSprite;
	
	import core.Assets;
	
	import managers.MasterVolumeController;
	
	import objects.Background;
	
	import starling.display.Button;
	import starling.events.Event;
	
	public class MenuState extends StarlingState
	{
		private var _bg:Background;
		private var _titleCS:CitrusSprite;
		private var _startBtn:starling.display.Button;
		private var _optionsBtn:starling.display.Button;
		
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
			
			// create a master volume controller (singleton); check if it has a stage (means its already been added to stage), if so, dont add it again
			var masterVolumeController:MasterVolumeController = MasterVolumeController.getInstance();
			if (!MasterVolumeController.getInstance().stage)
			{
				trace("MasterVolumeController not added to stage yet; adding it to stage.");
				stage.addChild(masterVolumeController);
			}
		}
		
		/**
		 * Clean up the state.
		 * */
		override public function destroy():void
		{
			super.destroy();
			
			// destroy title
			// destroy bg
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
			_optionsBtn = new starling.display.Button(Assets.textureAtlas.getTexture("options"));
			_optionsBtn.x = _ce.stage.stageWidth * 0.5 - _optionsBtn.width * 0.5;
			_optionsBtn.y = _startBtn.y + 50;
			_optionsBtn.addEventListener(Event.TRIGGERED, buttonTriggered);
			this.addChild(_optionsBtn);
		}
		
		/**
		 * Create the start button.
		 * */
		private function createStartButton():void
		{	
			_startBtn = new starling.display.Button(Assets.textureAtlas.getTexture("start"));
			_startBtn.x = _ce.stage.stageWidth * 0.5 - _startBtn.width * 0.5;
			_startBtn.y = _titleCS.y + 50;
			_startBtn.addEventListener(Event.TRIGGERED, buttonTriggered);
			this.addChild(_startBtn);
		}
		
		/**
		 * Create the title.
		 * */
		private function createTitle():void
		{
			_titleCS = new CitrusSprite("title", {x:_ce.stage.stageWidth * 0.5,y:150,width:0,height:0});
			_titleCS.registration = "center";
			_titleCS.view = Assets.textureAtlas.getTexture("title");
			this.add(_titleCS);
		}
		
		/**
		 * Listen for the start and options button click.
		 * */
		private function buttonTriggered(e:Event):void
		{
			var btn:starling.display.Button = e.target as starling.display.Button;
			
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
			destroyStarlingObjects();
			
			_ce.state = new GameState();
		}
		
		private function optionsMenu():void
		{
			// TODO Auto Generated method stub
			
		}
		
		private function destroyStarlingObjects():void
		{
			//remove Starling buttons
			_optionsBtn.removeEventListener(Event.TRIGGERED, buttonTriggered);
			this.removeChild(_optionsBtn);
			_optionsBtn.dispose();
			_optionsBtn = null;
			
			_startBtn.removeEventListener(Event.TRIGGERED, buttonTriggered);
			this.removeChild(_startBtn);
			_startBtn.useHandCursor = false;
			_startBtn.dispose();
			_startBtn = null;
		}
	}
}



































