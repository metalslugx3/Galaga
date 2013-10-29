package core
{
	import flash.utils.Dictionary;
	
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
		}
		
		/**
		 * 	Gets the texture from the texture dictionary if it exists, creates it if it doesn't.
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



































