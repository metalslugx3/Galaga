package core
{
	import flash.utils.Dictionary;
	
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Assets
	{
		/**
		 * Embed images.
		 * */
		[Embed(source="../assets/images/atlas.png")]
		public static const GraphicTextureAtlas:Class;
		
		[Embed(source="../assets/images/spacebg.jpg")]
		public static const GraphicSpaceBG:Class;
		
		[Embed(source="../assets/images/spaceship.png")]			// spaceship atlas, sprite sheet made directly from Flash CS6
		public static const GraphicTextureAtlasSpaceShip:Class;
		
		[Embed(source="../assets/fonts/quantifier_0.png")]			// quantifier bitmap font
		public static const GraphicQuantifierFont:Class;
		
		/**
		 * Embed XML.
		 * */
		[Embed(source="../assets/images/atlas.xml", mimeType="application/octet-stream")]
		public static const XMLTextureAtlas:Class;
		
		[Embed(source="../assets/images/spaceship.xml", mimeType="application/octet-stream")]	// space ship atlas's XML data
		public static const XMLTextureAtlasSpaceShip:Class;
		
		[Embed(source="../assets/images/particles/smoke.pex", mimeType="application/octet-stream")]
		public static const XMLSmokeParticle:Class;
		
		[Embed(source="../assets/images/particles/explosion.pex", mimeType="application/octet-stream")]
		public static const XMLExplosionParticle:Class;
		
		[Embed(source="../assets/fonts/quantifier.fnt", mimeType="application/octet-stream")]
		public static const XMLQuantifierFont:Class;
		
		/**
		 * 	Embed swf.
		 * */
		[Embed(source="../assets/images/options-menu.swf")]
		public static const MenuSWF:Class;
		
		/**
		 * 	Embed sounds.
		 * */
		[Embed(source="../assets/sounds/enemy-explode.mp3")]
		public static const S_ENEMY_EXPLODE:Class;
		
		[Embed(source="../assets/sounds/paused.mp3")]
		public static const S_PAUSED:Class;
		
		[Embed(source="../assets/sounds/player-explode.mp3")]
		public static const S_PLAYER_EXPLODE:Class;
		
		[Embed(source="../assets/sounds/player-shoot.mp3")]
		public static const S_PLAYER_SHOOT:Class;
		
		[Embed(source="../assets/sounds/player-shoot-bomb.mp3")]
		public static const S_PLAYER_SHOOT_BOMB:Class;
		
		[Embed(source="../assets/sounds/DST-ElektroHauz-22khz-64b.mp3")]
		public static const S_BACKGROUND_MUSIC:Class;
		
		// constants
		public static const ENEMY_EXPLODE:String = "ee";
		public static const PAUSED:String = "p";
		public static const PLAYER_EXPLODE:String = "pe";
		public static const PLAYER_SHOOT:String = "ps";
		public static const PLAYER_SHOOT_BOMB:String = "psb";
		public static const BACKGROUND_MUSIC:String = "bm";
		
		/**
		 * Texture Atlas.
		 * */
		public static var textureAtlas:TextureAtlas;
		public static var textureAtlasSpaceship:TextureAtlas;
		
		private static var textureAtlasDictionary:Dictionary;
		private static var textureAtlasSpaceshipDictionary:Dictionary;
		
		/**
		 * init: 	Initialize the TextureAtlas.
		 * 			You will access the TextureAtlas as, Assets.textureAtlas.
		 * */
		public static function init():void
		{
			textureAtlas = new TextureAtlas(Texture.fromBitmap(new GraphicTextureAtlas()), XML(new XMLTextureAtlas()));
			textureAtlasSpaceship = new TextureAtlas(Texture.fromBitmap(new GraphicTextureAtlasSpaceShip()), XML(new XMLTextureAtlasSpaceShip()));
			
			textureAtlasDictionary = new Dictionary();
			textureAtlasSpaceshipDictionary = new Dictionary();
			
			// register bitmap font
			TextField.registerBitmapFont(new BitmapFont(Texture.fromBitmap(new GraphicQuantifierFont()), XML(new XMLQuantifierFont())), "quantifier");
		}
		
		/**
		 * 	Gets the texture from the texture dictionary if it exists, creates it if it doesn't.
		 * 
		 * 	TODO:	This is only useful for single textures; need a way to access multiple textures (for mc). Until then use the TextureAtlas itself for
		 * 			MovieClips. The benefits of this is the creation of a single texture and reusability.
		 * */
		public static function getTextureFromAtlas(name:String):Texture
		{
			if (textureAtlasDictionary[name] == undefined)
			{
				textureAtlasDictionary[name] = Assets.textureAtlas.getTexture(name);
			}
			
			return textureAtlasDictionary[name];
		}
		
		/**
		 * 	Gets the texture from the spaceship texture dictionary if it exists, creates it if it doesn't.
		 * */
		public static function getTextureFromAtlasSpaceship(name:String):Texture
		{
			if (textureAtlasSpaceshipDictionary[name] == undefined)
			{
				textureAtlasSpaceshipDictionary[name] = Assets.textureAtlasSpaceship.getTexture(name);
			}
			
			return textureAtlasSpaceshipDictionary[name];
		}
	}
}



































