package managers
{	
	import objects.Alien;
	import objects.AlienProjectile;
	import objects.Hero;
	import objects.HeroBomb;
	import objects.HeroProjectile;
	
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
			checkBombAndAliens();
			//checkHeroAndAliens();
			//checkBulletsAndHero();
		}
		
		private function checkBulletsAndAliens():void
		{
			var b:HeroProjectile;
			var a:Alien;
			
			var bl:int = _game.heroProjectileManager.bulletsActive.length - 1;
			var i:int = bl;
			
			var activeAliens:Array = _game.alienManager.aliensActive;
			
			for (i; i >= 0; i--)
			{
				b = _game.heroProjectileManager.bulletsActive[i];
				
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
							//trace("bullet hit alien");
							
							// spawn explosion
							//trace(a.x, a.y);
							_game.explosionManager.createExplosion(a.x, a.y);
							
							// destroy alien
							_game.alienManager.destroyAlien(a, k);
							
							// destroy bullet
							_game.heroProjectileManager.destroyBullet(b, i);
						}
					}
				}
			}
		}
		
		private function checkBombAndAliens():void
		{
			var b:HeroBomb = _game.heroProjectileManager.heroBomb;
			var a:Alien;
			
			var bl:int = _game.heroProjectileManager.bulletsActive.length - 1;
			var i:int = bl;
			
			var activeAliens:Array = _game.alienManager.aliensActive;
			
			// active aliens multi-dimensional Array
			var al:int = activeAliens.length - 1;
			var j:int = al;
			
			// only check if the explosion is not null and active
			if (b && b.isActive)
			{
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
							// spawn explosion
							_game.explosionManager.createExplosion(a.x, a.y);
							
							// destroy alien
							_game.alienManager.destroyAlien(a, k);
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
						trace("hero hit");
						
						// spawn explosion
						_game.explosionManager.createExplosion(a.x, a.y);
						
						// TODO: spawn explosion at hero
						
						// destroy alien
						_game.alienManager.destroyAlien(a, k);
						
						// destroy hero
						hero.destroyHero();
						
						// take away one life icon
						_game.hud.removeIcon();
					}
				}
			}
		}
		
		private function checkBulletsAndHero():void
		{
			var ap:AlienProjectile;
			var hero:Hero = _game.hero;
			
			var apl:int = _game.alienProjectileManager.alienProjectilesActive.length - 1;
			var i:int = apl;
				
			for (i; i >= 0; i--)
			{
				ap = _game.alienProjectileManager.alienProjectilesActive[i];
				
				if (!hero.isInvincible && hero.bounds.intersects(ap.bounds))
				{
					trace("hero hit");
					
					// spawn explosion
					_game.explosionManager.createExplosion(hero.x, hero.y);
					
					// destroy hero
					hero.destroyHero();
					
					// take away one life icon
					_game.hud.removeIcon();
					
					// destroy alien projectile
					_game.alienProjectileManager.destroyAP(ap, i);
				}
			}
		}
		
		public function destroy():void
		{
			
		}
	}
}



































