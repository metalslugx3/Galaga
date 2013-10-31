package states
{
	import citrus.core.starling.StarlingState;
	import citrus.objects.CitrusSprite;
	import citrus.view.starlingview.StarlingView;
	
	import core.Assets;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import managers.MasterVolumeController;
	import managers.OptionsManager;
	
	import objects.Background;
	import objects.Hero;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.events.Event;
	
	/**
	 * 	MasterVolumeController is a singleton.
	 * 	OptionsManager is like a singleton but I wanted to test having it as a publicy accessed static var (similar but most likely slower). It will not
	 * 	be added to the stage but use the passed in parameter (_ce) to get access to the stage display list for Starling.
	 * */
	public class MenuState extends StarlingState
	{
		// public static optionsManager so it can be accessed anywhere; it will only be created once
		public static var optionsManager:OptionsManager;
		
		private var _bg:Background;
		private var _titleCS:CitrusSprite;
		private var _startBtn:starling.display.Button;
		private var _optionsBtn:starling.display.Button;
		private var _isOptionsLoading:Boolean;
		
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
			
			// hide visibility until the swf's (or other stuff) is finished loading
			(_ce.state.view as StarlingView).viewRoot.visible = false;
			this.visible = false;
			
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
			
			// create options manager once
			if (!optionsManager)
			{
				optionsManager = new OptionsManager(_ce);
			}
			
			_isOptionsLoading = true;
		}
		
		private function continueOperations():void
		{
			trace("Showing the MenuState finally.");
			// default key to open the options menu; only needs to be added once since its saved by the CE->input->keyboard FOREVER!!!
			_ce.input.keyboard.addKeyAction(Hero.KB_OPTIONS.string, Hero.KB_OPTIONS.key);
			
			(_ce.state.view as StarlingView).viewRoot.visible = true;
			this.visible = true;
		}
		
		override public function update(timeDelta:Number):void
		{
			if (_ce.input.hasDone(Hero.KB_OPTIONS.string))
			{
				optionsMenu();
			}
			
			if (_isOptionsLoading && optionsManager.isDoneLoading)
			{
				trace("Menu Options SWF finished \"loading\"");
				_isOptionsLoading = false;
				continueOperations();
			}
		}
		
		/**
		 * Clean up the state.
		 * */
		override public function destroy():void
		{
			super.destroy();
			
			// starling stuff destroyed separately before this is called
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
			_optionsBtn.addEventListener(starling.events.Event.TRIGGERED, buttonTriggered);
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
			_startBtn.addEventListener(starling.events.Event.TRIGGERED, buttonTriggered);
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
		private function buttonTriggered(e:starling.events.Event):void
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
		
		/**
		 * 	Starts the Game (state).
		 * */
		private function startGame():void
		{
			// destroy Starling objects before changing states
			destroyStarlingObjects();
			
			_ce.state = new GameState();
		}
		
		/**
		 * 	Opens/Closes the options menu.
		 * */
		private function optionsMenu():void
		{
			optionsManager.toggle();
		}
		
		private function destroyStarlingObjects():void
		{
			//remove Starling buttons
			_optionsBtn.removeEventListener(starling.events.Event.TRIGGERED, buttonTriggered);
			this.removeChild(_optionsBtn);
			_optionsBtn.dispose();
			_optionsBtn = null;
			
			_startBtn.removeEventListener(starling.events.Event.TRIGGERED, buttonTriggered);
			this.removeChild(_startBtn);
			_startBtn.useHandCursor = false;
			_startBtn.dispose();
			_startBtn = null;
		}
	}
}



































