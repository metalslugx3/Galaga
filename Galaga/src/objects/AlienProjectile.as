package objects
{
	import core.Assets;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	import states.GameState;

	public class AlienProjectile extends Projectile
	{
		private var _target:Array;
		private var _targetAngle:Number;
		private var _textures:Dictionary;
		
		public function AlienProjectile(game:GameState = null)
		{
			_game = game;
			
			this.addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		override protected function initialize(e:Event):void
		{
			super.initialize(e);
			
			// speed can also be set dynamically when created
			_speed = 50;
		}
		
		override protected function createArt():void
		{
			super.createArt();
			
			_textures = new Dictionary();
			
			// store each texture in the dictionary
			_textures[1] = Assets.getTextureFromAtlasSpaceship("enemy-projectile-1 instance 10000");
			_textures[2] = Assets.getTextureFromAtlasSpaceship("enemy-projectile-2 instance 10000");
			_textures[3] = Assets.getTextureFromAtlasSpaceship("enemy-projectile-3 instance 10000");
			
			// use texture based off its type
			_image = new Image(_textures[_type]);
			_image.alignPivot("center", "center");
			this.addChild(_image);
		}
		
		override public function update(deltaTime:Number):void
		{
			
		}
		
		/**
		 * 	Change the texture of the alien projectile.
		 * */
		public function changeType(type:int):void
		{			
			// if the types are the type we don't need to change the texture
			if (type == this._type)
				return;
			
			// change the type
			this._type = type;
			
			// change the image
			this._image.texture = _textures[type];
		}
		
		public function get target():Array
		{
			return _target;
		}

		public function set target(value:Array):void
		{
			_target = value;
		}

		public function get targetAngle():Number
		{
			return _targetAngle;
		}

		public function set targetAngle(value:Number):void
		{
			_targetAngle = value;
		}


	}
}



































