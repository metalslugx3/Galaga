package objects
{
	import core.Assets;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	
	import states.GameState;
	
	public class HUD extends Sprite
	{
		private var _game:GameState;
		private var _lifeContainer:Sprite;
		private var _lives:Array;
		private var _scoreImage:Image;
		private var _scoreText:TextField;
		
		public function HUD(game:GameState)
		{
			super();
			
			_game = game;
			
			this.addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		private function initialize(e:Event):void
		{
			// life container will hold our icons, position default
			_lifeContainer = new Sprite();
			this.addChild(_lifeContainer);
			
			_lives = [];
			
			// get icon texture
			
			var t:Texture = Assets.getTextureFromAtlasSpaceship("livesIcon instance 10000");
			
			// get life texture and push into array; do it 3 times reusing life image
			var lifeImage:Image = new Image(t);
			_lives.push(lifeImage);
			
			lifeImage = new Image(t);
			_lives.push(lifeImage);
			
			lifeImage = new Image(t);
			_lives.push(lifeImage);
			
			// populate the container with the images in the array
			var img:Image;
			var i:int = 0;
			for each (img in _lives)
			{
				//_lifeContainer.addChild(_lifeImage);
				this.addChild(img);
				img.scaleX = img.scaleY = 1;
				img.x = 150 + i * 15;
				img.y = 5;
				i++;
			}
			
			// create score
			_scoreImage = new Image(Assets.getTextureFromAtlas("score"));
			this.addChild(_scoreImage);
			_scoreImage.x = 480;
			
			_scoreText = new TextField(100, 32, "0", "quantifier", 12);
			this.addChild(_scoreText);
			_scoreText.color = 0xffffff;
			_scoreText.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			_scoreText.hAlign = HAlign.LEFT;
			_scoreText.x = _scoreImage.x + 50;
			_scoreText.y = 1;
		}
		
		/**
		 * 	Removes one icon (player got hit).
		 * */
		public function removeIcon():void
		{
			trace("_game.hero.lives: " + _game.hero.lives);
			// set alpha to 0; lives have already been deducted in the heroDestroy() method
			(_lives[_game.hero.lives] as Image).alpha = 0;
		}
		
		/**
		 * 	Updates the current score.
		 * */
		public function updateScore():void
		{
			_scoreText.text = (_game.hero.totalPoints).toString();
		}
		
		/**
		 * Clean up the HUD.
		 * */
		public function destroy():void
		{
			// remove and dispose images from array and container
			var i:int = _lives.length - 1;
			var img:Image;
			for (i; i >= 0; i--)
			{
				img = _lives[i] as Image;
				_lifeContainer.removeChild(img);
				img.dispose();
				_lives.splice(i, 1);
			}
			
			// remove reference to array
			_lives = null;
			
			// remove container
			this.removeChild(_lifeContainer);
			_lifeContainer.dispose();
			_lifeContainer = null;
			
			// remove ref to temp
			img.dispose();
			img = null;
			
			// remove score
			this.removeChild(_scoreImage);
			_scoreImage.dispose();
			_scoreImage = null;
			
			this.removeChild(_scoreText);
			_scoreText.dispose();
			_scoreText = null;
		}
	}
}



































