package managers
{
	import citrus.math.MathVector;
	
	import com.leebrimelow.starling.StarlingPool;
	
	import core.Assets;
	
	import objects.Alien;
	import objects.AlienProjectile;
	
	import states.GameState;
	
	import treefortress.sound.SoundAS;
	
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
			_maxProjectiles = 150;
			
			_pool = new StarlingPool(AlienProjectile, _maxProjectiles);
			
			_alienProjectilesActive = [];
			
			var ap:AlienProjectile;
			for each (ap in _pool.items)
			{
				ap.x = -100;
				ap.y = -100;
				
				// default type (will be changed dynamically on spawn)
				ap.type = 1;
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
				
				// type 2: goes to the players last location (non-homing)
				// type 3: triple spread but has the same logic (angle is just different)
				if (ap.type == 2 || ap.type == 3)
				{
					// move the projectile towards the targets location using its angle
					ap.x += (ap.speed * Math.cos(ap.targetAngle)) * deltaTime; 
					ap.y += (ap.speed * Math.sin(ap.targetAngle)) * deltaTime;
				}
				
				checkOffStage(ap, i);
			}
		}
		
		/**
		 * 	For alien projectiles we must check all four boundaries because the hero position will affect certain projectile motion locations.
		 * */
		private function checkOffStage(ap:AlienProjectile, i:int):void
		{
			if (ap.x < 0 || ap.x > _game.stage.stageWidth || ap.y < 0 || ap.y > _game.stage.stageHeight)
			{
				destroyAP(ap, i);
			}
		}
		
		/**
		 *	Spawn an alien projectile at the aliens coordinates. 
		 * 
		 */		
		public function spawnProjectile(x:int, y:int, alienType:int):void
		{
			if (_alienProjectilesActive.length >= _maxProjectiles)
			{
				trace("Cannot create more projectiles that is allowed.");
				return;
			}
			
			// play sound TODO: get sound
						
			// the angle of the target 
			var dx:Number;
			var dy:Number;
			var angle:Number;
			
			if (alienType == 2)		// basic porjectile
			{
				var a:AlienProjectile;
				a = _pool.getSprite() as AlienProjectile;
				a.speed = 50;
				
				// change the texture of the projectile based on the Alien type
				a.changeType(alienType);
				
				// the start point of the projectile
				a.x = x;
				a.y = y;
				
				// where the bullet wants to go
				a.target = [_game.hero.x, _game.hero.y];
				
				// the angle of the target 
				dx = a.target[0] - a.x;
				dy = a.target[1] - a.y;
				angle = Math.atan2(dy, dx);
				a.targetAngle = angle;
				
				// push the active projectile into the active projectiles array
				_alienProjectilesActive.push(a);
			}
			else if (alienType == 3 && _pool.counter >= 3)	// triple spread, counter >= 3 means there's at least 3 projectiles to spawn
			{
				var ap1:AlienProjectile = _pool.getSprite() as AlienProjectile;
				var ap2:AlienProjectile = _pool.getSprite() as AlienProjectile;
				var ap3:AlienProjectile = _pool.getSprite() as AlienProjectile;
				
				ap1.speed = 75;
				ap2.speed = 75;
				ap3.speed = 75;
				
				// change the texture of the projectile based on the Alien type
				ap1.changeType(alienType);
				ap2.changeType(alienType);
				ap3.changeType(alienType);
				
				// the start point of the projectile
				ap1.x = x;
				ap1.y = y;
				
				ap2.x = x;
				ap2.y = y;
				
				ap3.x = x;
				ap3.y = y;
				
				// where the bullet wants to go
				ap1.target = [_game.hero.x, _game.hero.y];
				
				// the angle of the target 
				dx = ap1.target[0] - ap1.x;
				dy = ap1.target[1] - ap1.y;
				angle = Math.atan2(dy, dx);
				ap1.targetAngle = angle - 0.1;
				ap2.targetAngle = angle;
				ap3.targetAngle = angle + 0.1;
				
				// push the active projectile into the active projectiles array
				_alienProjectilesActive.push(ap1);
				_alienProjectilesActive.push(ap2);
				_alienProjectilesActive.push(ap3);
			}
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



































