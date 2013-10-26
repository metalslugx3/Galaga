package managers
{	
	import objects.Alien;
	import objects.Bullet;
	import objects.Hero;
	
	import states.GameState;

	public class CollisionManager
	{
		private var _game:GameState;
		
		public function CollisionManager(game:GameState)
		{
			_game = game;
			
			initialize();
		}
		
		private function initialize():void
		{
			
		}
		
		public function update(deltaTime:Number):void
		{
			checkBulletsAndAliens();
			checkHeroAndAliens();
		}
		
		private function checkBulletsAndAliens():void
		{
			var b:Bullet;
			var a:Alien;
			
			var bl:int = _game.bulletManager.bulletsActive.length - 1;
			var i:int = bl;
			for (i; i >= 0; i--)
			{
				b = _game.bulletManager.bulletsActive[i];
				var al:int = _game.alienManager.aliensActive.length - 1;
				var j:int = al;
				
				for (j; j >= 0; j--)
				{
					a = _game.alienManager.aliensActive[j];
					
					if (b.bounds.intersects(a.bounds))
					{
						trace("bullet hit alien");
						
						// destroy alien
						_game.alienManager.destroyAlien(a, j);
						
						// destroy bullet
						_game.bulletManager.destroyBullet(b, i);
						
						// spawn explosion
					}
				}
			}
		}
		
		private function checkHeroAndAliens():void
		{
			var hero:Hero;
			var a:Alien;
			
			var al:int = _game.alienManager.aliensActive.length - 1;
			var j:int = al;
			for (j; j >= 0; j--)
			{
				hero = _game.hero;
				a = _game.alienManager.aliensActive[j];
				
				if (!hero.isInvincible && hero.bounds.intersects(a.bounds))
				{
					trace("hero dead");
					
					// destroy alien
					_game.alienManager.destroyAlien(a, j);
					
					// destroy hero
					hero.destroyHero();
					
					// spawn explosion
				}
			}
		}
		
		public function destroy():void
		{
			
		}
	}
}



































