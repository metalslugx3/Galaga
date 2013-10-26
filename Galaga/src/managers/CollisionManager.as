package managers
{
	import objects.Alien;
	import objects.Bullet;
	
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
		}
		
		private function checkBulletsAndAliens():void
		{
			var b:Bullet;
			var a:Alien;
			
			var bl:int = _game.bulletManager.bulletsActive.length - 1;
			var i:int = bl;
			for (i; i >= 0; i--)
			{
				var al:int = _game.alienManager.aliensActive.length - 1;
				var j:int = al;
				for (j; j >= 0; j--)
				{
					b = _game.bulletManager.bulletsActive[i];
					a = _game.alienManager.aliensActive[j];
					
					if (b.bounds.intersects(a.bounds))
					{
						trace("hit");
					}
				}
			}
		}
		
		public function destroy():void
		{
			
		}
	}
}



































