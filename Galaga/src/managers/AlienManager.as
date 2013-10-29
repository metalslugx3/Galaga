package managers
{
	import com.leebrimelow.starling.StarlingPool;
	
	import objects.Alien;
	import objects.AlienEasy;
	import objects.AlienHard;
	import objects.AlienMedium;
	
	import states.GameState;
	
	public class AlienManager
	{
		private var _game:GameState;
		
		private var _maxAliens:uint;
		private var _maxEasyAliens:uint;
		private var _maxMediumAliens:uint;
		private var _maxHardAliens:uint;
		private var _maxAliensAtOnce:uint;
		
		private var _aliensEasyActive:Array;
		private var _aliensMediumActive:Array;
		private var _aliensHardActive:Array;
		
		private var _poolAlienEasy:StarlingPool;
		private var _poolAlienMedium:StarlingPool;
		private var _poolAlienHard:StarlingPool;
		private var _aliensActive:Array;
		private var _tempAlien:Alien;
		
		private var _spawnTimer:uint;
		private var _lastSpawn:uint;
		private var _alienEasySpawnRate:Number;
		private var _alienMediumSpawnRate:Number;
		private var _alienHardSpawnRate:Number;
		private var _spawnWave:int;
		
		public function AlienManager(game:GameState)
		{
			_game = game;
			
			initialize();
		}
			
		private function initialize():void
		{
			_maxEasyAliens = 0;
			_maxMediumAliens = 20;
			_maxHardAliens = 0;
			_maxAliensAtOnce = 100;
			
			_poolAlienEasy = new StarlingPool(AlienEasy, _maxEasyAliens);
			_poolAlienMedium = new StarlingPool(AlienMedium, _maxMediumAliens);
			_poolAlienHard = new StarlingPool(AlienHard, _maxHardAliens);
			
			// aliens will have one main active array that holds each individial alien specific active array
			_aliensActive = [];
			_aliensEasyActive = [];
			_aliensMediumActive = [];
			_aliensHardActive = [];
			
			_aliensActive.push(_aliensEasyActive);
			_aliensActive.push(_aliensMediumActive);
			_aliensActive.push(_aliensHardActive);
			
			// populate each pool with a set amount of enemies
			var a:Alien;
			for each (a in _poolAlienEasy.items)
			{
				a.x = -100;
				a.y = -100;
				_game.addChild(a);
			}
			
			for each (a in _poolAlienMedium.items)
			{
				a.x = -100;
				a.y = -100;
				_game.addChild(a);
			}
			
			for each (a in _poolAlienHard.items)
			{
				a.x = -100;
				a.y = -100;
				_game.addChild(a);
			}
			
			_alienEasySpawnRate = 0.02;
			_alienMediumSpawnRate = 0;
			_alienHardSpawnRate = 0;
		}
		
		public function update(deltaTime:Number):void
		{
			// spawn an alien based off spawn rate
			if (Math.random() < _alienEasySpawnRate)
			{
				spawnAlien(1);
			}
			
			if (Math.random() < _alienMediumSpawnRate)
			{
				spawnAlien(2);
			}
			
			if (Math.random() < _alienHardSpawnRate)
			{
				spawnAlien(3);
			}
			
			// iterate through the active aliens multi-dimensional array to update movement
			var a:Alien;
			var i:int = _aliensActive.length - 1;
			
			for (i; i >= 0; i--)
			{
				var lengthOfActive:int = _aliensActive[i].length - 1;
				var j:int = lengthOfActive;
				
				for (j; j >= 0; j--)
				{
					a = _aliensActive[i][j];
					a.y += a.speed * deltaTime;
					
					// check the fire delay if it is type or 3
					if (a is AlienMedium)
					{
						// TODO: i have a bug here; see github
						//trace("(a as AlienMedium).hasFired: " + (a as AlienMedium).hasFired)
						// the Alien only fire when it passes a certain height and if it hasn't already fired
						if (a.y >= a.fireHeight && !(a as AlienMedium).hasFired)
						{
							(a as AlienMedium).hasFired = true;
							_game.alienProjectileManager.spawnProjectile(a.x, a.y);
						}
					}
					
					// j should be passed as the index because j is the index of the alien inside the _aliensActive[i] Array
					checkOffStage(a, j);
				}
			}
		}
		
		private function checkOffStage(a:Alien, i:int):void
		{
			if (a.y + a.height * 0.5 >= 640)
			{
				destroyAlien(a, i);
			}
		}
		
		/**
		 *	Determine the type of alien needed to spawn and fetch it from the correct pool then push it into the correct active Array. 
		 * @param type the type of alien
		 * 
		 */		
		public function spawnAlien(type:int):void
		{
			// if the alien is of type 1
			if (type == 1)
			{
				// in the active array, do not create more of this type if the specific array dedicated to this type is greater than the allowed amount
				if (_aliensActive[0].length >= _maxEasyAliens)
				{
					//trace("Cannot create more easy aliens than allowed.");
				}
				else
				{
					_tempAlien = _poolAlienEasy.getSprite() as Alien;
					_aliensActive[0].push(_tempAlien);
				}
			}
			
			if (type == 2)
			{
				if (_aliensActive[1].length >= _maxMediumAliens)
				{
					//trace("Cannot create more medium aliens than allowed.");
				}
				else
				{
					_tempAlien = _poolAlienMedium.getSprite() as Alien;
					
					// set to false to reset it if it was true previously
					(_tempAlien as AlienMedium).hasFired = false;
					
					// set the fire delay here so that a new Alien of type 2 has a new fire rate
					_tempAlien.fireDelay = (1 + Math.random() * 1) * 1000;	// delay between 1000 and 2000 ms
					_tempAlien.fireHeight = 15 + Math.random() * 135;	// able to shoot between 15 and 150 pixels
					
					_aliensActive[1].push(_tempAlien);
				}
			}
			
			if (type == 3)
			{
				if (_aliensActive[2].length >= _maxHardAliens)
				{
					//trace("Cannot create more hard aliens than allowed.");
				}
				else
				{
					_tempAlien = _poolAlienHard.getSprite() as Alien;
					_aliensActive[2].push(_tempAlien);
				}
			}
			
			if (_tempAlien)
			{
				_tempAlien.x = (Math.random() * (640 - _tempAlien.width)) + _tempAlien.width;
				_tempAlien.y = 0 - _tempAlien.height * 0.5;
			}
			
			_tempAlien = null;
		}
		
		public function increaseDifficulty():void
		{
			updateEasyEnemies();
			updateMediumEnemies();
			updateHardEnemies();
		}
		
		private function updateEasyEnemies():void
		{
			_alienEasySpawnRate += 0.001;
			
			var a:Alien;
			for each (a in _poolAlienHard.items)
			{
				a.speed += 1;
			}
		}
		
		private function updateMediumEnemies():void
		{
			if (_game.level >= 10)
			{
				_alienMediumSpawnRate += .01;
				
				var a:Alien;
				for each (a in _poolAlienEasy.items)
				{
					a.speed += 1;
				}
			}
		}
		
		private function updateHardEnemies():void
		{
			if (_game.level >= 30)
			{
				_alienHardSpawnRate += .01;
				
				var a:Alien;
				for each (a in _poolAlienMedium.items)
				{
					a.speed += 1;
				}
			}
		}
		
		public function destroyAlien(a:Alien, i:Number):void
		{
			if (a.type == 1)
			{
				_poolAlienEasy.returnSprite(a);
				_aliensActive[0].splice(i, 1);
			}
			else if (a.type == 2)
			{
				_poolAlienMedium.returnSprite(a);
				_aliensActive[1].splice(i, 1);
			}
			else if (a.type == 3)
			{
				_poolAlienHard.returnSprite(a);
				_aliensActive[2].splice(i, 1);
			}
			
			a.x = -100;
			a.y = -100;
		}
		
		public function destroy():void
		{
			// remove reference to temp alien
			_tempAlien = null;
			
			// remove the aliens added to the GameState, call destroy, call dispose, splice from Array, remove references
			var a:Alien;
			var i:int = _aliensActive.length - 1;
			for (i; i >= 0; i--)
			{
				a = _aliensActive[i];
				a.destroy();
				a.dispose();
				_game.removeChild(a);
				_aliensActive.splice(i, 1);
			}
			a = null;
			_aliensActive = null;
			
			// destroy the pool
			_poolAlienEasy.destroy();
			_poolAlienMedium.destroy();
			_poolAlienHard.destroy();
			
			// remove reference to _game
			_game = null;
		}

		public function get aliensActive():Array
		{
			return _aliensActive;
		}

		public function set aliensActive(value:Array):void
		{
			_aliensActive = value;
		}

	}
}



































