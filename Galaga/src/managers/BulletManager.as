package managers
{
	import com.leebrimelow.starling.StarlingPool;
	
	import objects.HeroProjectile;
	
	import states.GameState;

	public class BulletManager
	{
		private var _game:GameState;
		
		private var _maxProjectiles:uint;
		private var _pool:StarlingPool;
		private var _bulletsActive:Array;
		private var _tempBullet:HeroProjectile;
		
		public function BulletManager(game:GameState)
		{
			_game = game;
			
			initialize();
		}
		
		private function initialize():void
		{
			_maxProjectiles = 30;
			
			_pool = new StarlingPool(HeroProjectile, _maxProjectiles);
			
			_bulletsActive = [];
			
			var b:HeroProjectile;
			for each (b in _pool.items)
			{
				b.x = -100;
				b.y = -100;
				_game.addChild(b);
			}
		}
		
		public function update(deltaTime:Number):void
		{
			var b:HeroProjectile;
			var i:int = _bulletsActive.length - 1;
			
			for (i; i >= 0; i--)
			{
				b = _bulletsActive[i];
				b.y -= b.speed * deltaTime;
				checkOffStage(b, i);
			}
		}
		
		private function checkOffStage(b:HeroProjectile, i:int):void
		{
			if (b.y - b.height * 0.5 <= 0)
			{
				destroyBullet(b, i);	
			}
		}
		
		public function spawnProjectile():void
		{
			if (_bulletsActive.length >= _maxProjectiles)
			{
				trace("Cannot create more projectiles that is allowed.");
				return;
			}
			
			_tempBullet = _pool.getSprite() as HeroProjectile;
			_tempBullet.x = _game.hero.x;
			_tempBullet.y = (_game.hero.y - _game.hero.height * 0.5) - _tempBullet.height;
			
			_bulletsActive.push(_tempBullet);
		}
		
		public function destroyBullet(b:HeroProjectile, i:Number):void
		{
			_pool.returnSprite(b);
			b.x = -100;
			b.y = -100;
			_bulletsActive.splice(i, 1);
		}
		
		public function destroy():void
		{
			// remove reference to temp bullet
			_tempBullet = null;
			
			// remove the bullets added to the GameState, call destroy, call dispose, splice from Array, remove references
			var b:HeroProjectile;
			var i:int = _bulletsActive.length - 1;
			for (i; i >= 0; i--)
			{
				b = _bulletsActive[i];
				b.destroy();
				b.dispose();
				_game.removeChild(b);
				_bulletsActive.splice(i, 1);
			}
			b = null;
			_bulletsActive = null;
			
			// destroy the pool
			_pool.destroy();
			
			// remove reference to _game
			_game = null;
		}

		public function get bulletsActive():Array
		{
			return _bulletsActive;
		}

		public function set bulletsActive(value:Array):void
		{
			_bulletsActive = value;
		}
	}
}



































