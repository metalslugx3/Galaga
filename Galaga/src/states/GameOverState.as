package states
{
	import citrus.core.starling.StarlingState;
	import citrus.objects.CitrusSprite;
	import citrus.view.starlingview.StarlingArt;
	import citrus.view.starlingview.StarlingSpriteDebugArt;
	
	import core.Assets;
	
	import objects.Background;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class GameOverState extends StarlingState
	{
		private var _bg:Background;
		private var _gameOverImage:CitrusSprite;
		private var _retryImage:CitrusSprite;
		
		public function GameOverState()
		{
			super();
			
			trace("GameOverState started.");
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			createBG();
			createImages();
			
			Starling.current.stage.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
		}
		
		override public function destroy():void
		{
			super.destroy();
		}
		
		/**
		 * 	Listen for retry button clicked.
		 * */
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(Starling.current.stage);
			
			if (touch && touch.phase == TouchPhase.BEGAN)
			{
				if (touch.target is Image)
				{
					//var img:Image = touch.target as Image;
					
					// since retry is the only touch enabled CitrusSprite here we can assume we clicked it
					
					_ce.state = new GameState();
				}
			}
		}
		
		private function createImages():void
		{
			_gameOverImage = new CitrusSprite("gameOverImage");
			this.add(_gameOverImage);
			_gameOverImage.view = Assets.getTextureFromAtlas("gameover_01");
			_gameOverImage.registration = "center";
			_gameOverImage.x = _ce.stage.stageWidth >> 1;
			_gameOverImage.y = 220;
			
			_retryImage = new CitrusSprite("retryImage");
			this.add(_retryImage);
			_retryImage.view = Assets.getTextureFromAtlas("retry");
			_retryImage.registration = "center";
			_retryImage.x = _ce.stage.stageWidth >> 1;
			_retryImage.y = _gameOverImage.y  + 100;
			_retryImage.touchable = true;
			(this.view.getArt(_retryImage) as StarlingArt).useHandCursor = true;
		}
		
		private function createBG():void
		{
			_bg = new Background("gameOverBG");
			this.add(_bg);
		}
	}
}



































