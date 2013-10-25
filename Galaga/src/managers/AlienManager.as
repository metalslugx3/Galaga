package managers
{
	import com.leebrimelow.starling.StarlingPool;
	
	import objects.Bullet;
	
	import states.GameState;
	
	public class AlienManager
	{
		private var _game:GameState;
		
		private var _maxBullets:uint;
		private var _pool:StarlingPool;
		private var _bulletsActive:Array;
		private var _tempBullet:Bullet;
		
		public function AlienManager(game:GameState)
		{
			_game = game;
			
			initialize();
		}
		
		private function initialize():void
		{
			_maxBullets = 30;
			
			_pool = new StarlingPool(Bullet, _maxBullets);
			
			_bulletsActive = [];
			
			var b:Bullet;
			for each (b in _pool.items)
			{
				b.x = -100;
				b.y = -100;
				_game.addChild(b);
			}
		}
		
		public function update(deltaTime:Number):void
		{
			var b:Bullet;
			var i:int = _bulletsActive.length - 1;
			
			for (i; i >= 0; i--)
			{
				b = _bulletsActive[i];
				b.y -= b.speed * deltaTime;
				checkOffStage(b, i);
			}
		}
		
		private function checkOffStage(b:Bullet, i:int):void
		{
			if (b.y - b.height * 0.5 <= 0)
			{
				destroyBullet(b, i);	
			}
		}
		
		public function spawnBullet():void
		{
			if (_bulletsActive.length > _maxBullets)
			{
				trace("Cannot create more bullets that is allowed.");
				return;
			}
			
			_tempBullet = _pool.getSprite() as Bullet;
			_tempBullet.x = _game.hero.x;
			_tempBullet.y = (_game.hero.y - _game.hero.height * 0.5) - _tempBullet.height;
			
			_bulletsActive.push(_tempBullet);
		}
		
		private function destroyBullet(b:Bullet, i:Number):void
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
			var b:Bullet;
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
	}
}



































