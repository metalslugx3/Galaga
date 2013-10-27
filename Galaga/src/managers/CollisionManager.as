package managers
{	
	import objects.Alien;
	import objects.HeroProjectile;
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
			//checkHeroAndAliens();
			checkBulletsAndHero();
		}
		
		private function checkBulletsAndAliens():void
		{
			var b:HeroProjectile;
			var a:Alien;
			
			var bl:int = _game.bulletManager.bulletsActive.length - 1;
			var i:int = bl;
			
			var activeAliens:Array = _game.alienManager.aliensActive;
			
			for (i; i >= 0; i--)
			{
				b = _game.bulletManager.bulletsActive[i];
				
				// active aliens multi-dimensional Array
				var al:int = activeAliens.length - 1;
				var j:int = al;
				
				for (j; j >= 0; j--)
				{
					// if the length of the specific alien Array is 0 then skip this iteration
					if (activeAliens[j].length == 0)
					{
						continue;
					}
					
					// iterate through the current active alien specific Array in aliensActive to find collision
					var k:int = activeAliens[j].length - 1;
					for (k; k >= 0; k--)
					{
						// the current alien
						a = activeAliens[j][k];
						
						if (b.bounds.intersects(a.bounds))
						{
							trace("bullet hit alien");
							
							// spawn explosion
							trace(a.x, a.y);
							_game.explosionManager.createExplosion(a.x, a.y);
							
							// destroy alien
							_game.alienManager.destroyAlien(a, k);
							
							// destroy bullet
							_game.bulletManager.destroyBullet(b, i);
						}
					}
				}
			}
		}
		
		private function checkHeroAndAliens():void
		{
			var hero:Hero = _game.hero;
			var a:Alien;
			
			var al:int = _game.alienManager.aliensActive.length - 1;
			var j:int = al;
			
			var activeAliens:Array = _game.alienManager.aliensActive;
			
			for (j; j >= 0; j--)
			{
				// if the length of the specific alien Array is 0 then skip this iteration
				if (activeAliens[j].length == 0)
				{
					continue;
				}
				
				var k:int = activeAliens[j].length - 1;
				for (k; k >= 0; k--)
				{
					a = activeAliens[j][k];
					
					if (!hero.isInvincible && hero.bounds.intersects(a.bounds))
					{
						trace("hero dead");
						
						// destroy alien
						_game.alienManager.destroyAlien(a, k);
						
						// destroy hero
						hero.destroyHero();
						
						// spawn explosion
					}
				}
			}
		}
		
		private function checkBulletsAndHero():void
		{
			var b:HeroProjectile;
			var a:Alien;
			
			var bl:int = _game.bulletManager.bulletsActive.length - 1;
			var i:int = bl;
			
			var activeAliens:Array = _game.alienManager.aliensActive;
			
			for (i; i >= 0; i--)
			{
				b = _game.bulletManager.bulletsActive[i];
				
				// active aliens multi-dimensional Array
				var al:int = activeAliens.length - 1;
				var j:int = al;
				
				for (j; j >= 0; j--)
				{
					// if the length of the specific alien Array is 0 then skip this iteration
					if (activeAliens[j].length == 0)
					{
						continue;
					}
					
					// iterate through the current active alien specific Array in aliensActive to find collision
					var k:int = activeAliens[j].length - 1;
					for (k; k >= 0; k--)
					{
						// the current alien
						a = activeAliens[j][k];
						
						if (b.bounds.intersects(a.bounds))
						{
							trace("bullet hit alien");
							
							// spawn explosion
							trace(a.x, a.y);
							_game.explosionManager.createExplosion(a.x, a.y);
							
							// destroy alien
							_game.alienManager.destroyAlien(a, k);
							
							// destroy bullet
							_game.bulletManager.destroyBullet(b, i);
						}
					}
				}
			}
		}
		
		public function destroy():void
		{
			
		}
	}
}



































