package managers
{
	import citrus.math.MathVector;
	
	import com.leebrimelow.starling.StarlingPool;
	
	import objects.AlienProjectile;
	
	import states.GameState;
	
	public class AlienProjectileManager
	{
		private var _game:GameState;
		
		private var _maxProjectiles:uint;
		private var _pool:StarlingPool;
		private var _alienProjectilesActive:Array;
		private var _tempAP:AlienProjectile;
		
		public function AlienProjectileManager(game:GameState)
		{
			_game = game;
			
			initialize();
		}
		
		private function initialize():void
		{
			_maxProjectiles = 30;
			
			_pool = new StarlingPool(AlienProjectile, _maxProjectiles);
			
			_alienProjectilesActive = [];
			
			var ap:AlienProjectile;
			for each (ap in _pool.items)
			{
				ap.x = -100;
				ap.y = -100;
				_game.addChild(ap);
			}
		}
		
		public function update(deltaTime:Number):void
		{
			var ap:AlienProjectile;
			var i:int = _alienProjectilesActive.length - 1;
			
			for (i; i >= 0; i--)
			{
				ap = _alienProjectilesActive[i];
				
				// move the projectile towards the targets location using its angle
				ap.x += (ap.speed * Math.cos(ap.targetAngle)) * deltaTime; 
				ap.y += (ap.speed * Math.sin(ap.targetAngle)) * deltaTime;
				
				checkOffStage(ap, i);
			}
		}
		
		private function checkOffStage(ap:AlienProjectile, i:int):void
		{
			if (ap.y - ap.height * 0.5 <= 0)
			{
				destroyAP(ap, i);	
			}
		}
		
		/**
		 *	Spawn an alien projectile at the aliens coordinates. 
		 * 
		 */		
		public function spawnProjectile(x:int, y:int):void
		{
			if (_alienProjectilesActive.length >= _maxProjectiles)
			{
				trace("Cannot create more projectiles that is allowed.");
				return;
			}
			
			_tempAP = _pool.getSprite() as AlienProjectile;
			
			// the start point of the projectile
			_tempAP.x = x;
			_tempAP.y = y;
			
			// where the bullet wants to go
			_tempAP.target = [_game.hero.x, _game.hero.y];
			
			// the angle of the target 
			var dx:Number = _tempAP.target[0] - _tempAP.x;
			var dy:Number = _tempAP.target[1] - _tempAP.y;
			var angle:Number = Math.atan2(dy, dx);
			_tempAP.targetAngle = angle;
			
			// push the active projectile into the active projectiles array
			_alienProjectilesActive.push(_tempAP);
		}
		
		public function destroyAP(ap:AlienProjectile, i:Number):void
		{
			_pool.returnSprite(ap);
			ap.x = -100;
			ap.y = -100;
			_alienProjectilesActive.splice(i, 1);
		}
		
		public function destroy():void
		{
			// remove reference to temp bullet
			_tempAP = null;
			
			// remove the bullets added to the GameState, call destroy, call dispose, splice from Array, remove references
			var ap:AlienProjectile;
			var i:int = _alienProjectilesActive.length - 1;
			for (i; i >= 0; i--)
			{
				ap = _alienProjectilesActive[i];
				ap.destroy();
				ap.dispose();
				_game.removeChild(ap);
				_alienProjectilesActive.splice(i, 1);
			}
			ap = null;
			_alienProjectilesActive = null;
			
			// destroy the pool
			_pool.destroy();
			
			// remove reference to _game
			_game = null;
		}
		
		public function get alienProjectilesActive():Array
		{
			return _alienProjectilesActive;
		}
		
		public function set alienProjectilesActive(value:Array):void
		{
			_alienProjectilesActive = value;
		}
	}
}



































