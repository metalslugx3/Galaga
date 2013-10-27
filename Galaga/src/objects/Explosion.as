package objects
{
	import core.Assets;
	
	import starling.extensions.particles.PDParticleSystem;
	import starling.textures.Texture;
	
	public class Explosion extends PDParticleSystem
	{
		// pass no parameters so that we can pass this Class into the pool parameterless
		public function Explosion()
		{
			super(XML( new Assets.XMLExplosionParticle()), Assets.textureAtlas.getTexture("explosion"));
		}
	}
}



































