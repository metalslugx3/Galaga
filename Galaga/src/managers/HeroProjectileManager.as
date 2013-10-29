package managers
{
	import com.leebrimelow.starling.StarlingPool;
	
	import objects.HeroBomb;
	import objects.HeroProjectile;
	
	import org.osflash.signals.Signal;
	
	import states.GameState;
	
	public class HeroProjectileManager
	{
		private var _game:GameState;
		
		private var _maxProjectiles:uint;
		private var _pool:StarlingPool;
		private var _bulletsActive:Array;
		private var _tempBullet:HeroProjectile;
		private var _heroBomb:HeroBomb;
		
		public function HeroProjectileManager(game:GameState)
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
		
		/**
		 * 	Spawns a bomb around the player.
		 * */
		public function spawnBomb():void
		{
			// if _heroBomb is null then do these things once (more than once is resource heavy); it will be re-used
			if (!_heroBomb)
			{
				_heroBomb = new HeroBomb(_game);
				_game.addChild(_heroBomb);
				
				// add a signal to listen for the explosion animation complete
				_heroBomb.explosionDone.add(explosionBombComplete);
			}
			
			_heroBomb.x = _game.hero.x;
			_heroBomb.y = _game.hero.y;
			
			// begin explosion animation
			_heroBomb.beginExplosion();
		}
		
		/**
		 * 	This is not needed anymore; keeping it here for reference.
		 * 
		 * 	Fires after the explosion has completed its animation.
		 * */
		private function explosionBombComplete(params:* = null):void
		{
			//trace(params.myString);
			trace("explosionBombComplete");
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
			
			// destroy hero bomb
			_game.removeChild(_heroBomb);
			_heroBomb.destroy();
			_heroBomb.dispose();
			
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

		public function get heroBomb():HeroBomb
		{
			return _heroBomb;
		}

		public function set heroBomb(value:HeroBomb):void
		{
			_heroBomb = value;
		}

	}
}



































