package managers
{	
	import core.Assets;
	
	import objects.Alien;
	import objects.AlienProjectile;
	import objects.Hero;
	import objects.HeroBomb;
	import objects.HeroProjectile;
	
	import states.GameState;
	
	import treefortress.sound.SoundAS;

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
			checkHeroProjectilesAndAliens();
			checkBombAndAliens();
			checkBombAndAlienProjectiles();
			checkHeroAndAliens();
			checkAlienProjectilesAndHero();
		}
		
		private function checkHeroProjectilesAndAliens():void
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
						
						if (b.bounds.intersects(a.bounds) && !_game.isGameOver)
						{
							//trace("bullet hit alien");
							
							// spawn explosion
							//trace(a.x, a.y);
							_game.explosionManager.createExplosion(a.x, a.y);
							
							// destroy alien
							_game.alienManager.destroyAlien(a, k);
							
							// destroy bullet
							_game.heroProjectileManager.destroyBullet(b, i);
							
							// add points for player; added here to catch all aliens killed
							_game.hero.totalPoints += a.pointsWorth;
							
							// update score
							_game.hud.updateScore();
							
							// play sound
							SoundAS.play(Assets.ENEMY_EXPLODE);
							
							// break to prevent multiple overlap hit checks
							break;
						}
					}
				}
			}
		}
		
		private function checkBombAndAliens():void
		{
			var hb:HeroBomb = _game.heroProjectileManager.heroBomb;
			
			if (!hb || !hb.isActive)
				return;
			
			var a:Alien;
			
			var bl:int = _game.heroProjectileManager.bulletsActive.length - 1;
			var i:int = bl;
			
			var activeAliens:Array = _game.alienManager.aliensActive;
			
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
					
					if (hb.bounds.intersects(a.bounds) && !_game.isGameOver)
					{
						// distance check
						var dx:Number = hb.x - a.x;
						var dy:Number = hb.y - a.y;
						var dist:Number = Math.sqrt( (dx * dx + dy * dy) );
						
						// we kill alien only if its within a certain radius
						if (dist < hb.radius)
						{
							// spawn explosion
							_game.explosionManager.createExplosion(a.x, a.y);
							
							// destroy alien
							_game.alienManager.destroyAlien(a, k);
							
							// add points for player; added here to catch all aliens killed
							_game.hero.totalPoints += a.pointsWorth;
							
							// update score
							_game.hud.updateScore();
							
							// play sound
							SoundAS.play(Assets.ENEMY_EXPLODE);
						}
					}
				}
			}
		}
		
		private function checkBombAndAlienProjectiles():void
		{
			var hb:HeroBomb = _game.heroProjectileManager.heroBomb;
			
			if (!hb || !hb.isActive)
				return;
			
			var ap:AlienProjectile;
			var apl:int = _game.alienProjectileManager.alienProjectilesActive.length - 1;
			var i:int = apl;
			
			for (i; i >= 0; i--)
			{
				ap = _game.alienProjectileManager.alienProjectilesActive[i];
				
				if (hb.bounds.intersects(ap.bounds) && !_game.isGameOver)
				{
					// distance check
					var dx:Number = hb.x - ap.x;
					var dy:Number = hb.y - ap.y;
					var dist:Number = Math.sqrt( (dx * dx + dy * dy) );
					
					if (dist < hb.radius)
					{
						// destroy alien
						_game.alienProjectileManager.destroyAP(ap, i);
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
					
					if (!_game.isGameOver && !hero.isInvincible && hero.bounds.intersects(a.bounds))
					{
						// distance check
						var dx:Number = hero.x - a.x;
						var dy:Number = hero.y - a.y;
						var dist:Number = Math.sqrt( (dx * dx + dy * dy) );
						
						if (dist < 40)
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
							
							// play sound
							SoundAS.play(Assets.ENEMY_EXPLODE);
							
							// break to prevent multiple overlap hit checks
							break;
						}
					}
				}
			}
		}
		
		private function checkAlienProjectilesAndHero():void
		{
			var ap:AlienProjectile;
			var hero:Hero = _game.hero;
			
			var apl:int = _game.alienProjectileManager.alienProjectilesActive.length - 1;
			var i:int = apl;
				
			for (i; i >= 0; i--)
			{
				ap = _game.alienProjectileManager.alienProjectilesActive[i];
				
				if (!_game.isGameOver && !hero.isInvincible && hero.bounds.intersects(ap.bounds))
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
					
					// break to prevent multiple overlap hit checks
					break;
				}
			}
		}
		
		public function destroy():void
		{
			
		}
	}
}



































