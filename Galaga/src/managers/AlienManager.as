package managers
{
	import citrus.core.CitrusEngine;
	
	import com.leebrimelow.starling.StarlingPool;
	
	import flash.utils.getTimer;
	
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
			_maxEasyAliens = 30;
			_maxMediumAliens = 30;
			_maxHardAliens = 30;
			
			_poolAlienEasy = new StarlingPool(AlienEasy, _maxEasyAliens);
			_poolAlienMedium = new StarlingPool(AlienMedium, _maxMediumAliens);
			_poolAlienHard = new StarlingPool(AlienHard, _maxHardAliens);
			
			_aliensActive = [];
			
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
			
			_spawnTimer = 1000;
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
			
			var a:Alien;
			var i:int = _aliensActive.length - 1;
			
			for (i; i >= 0; i--)
			{
				a = _aliensActive[i];
				a.y += a.speed * deltaTime;
				checkOffStage(a, i);
			}
		}
		
		private function checkOffStage(a:Alien, i:int):void
		{
			if (a.y + a.height * 0.5 >= 640)
			{
				destroyAlien(a, i);
			}
		}
		
		public function spawnAlien(type:int):void
		{
			// only this amount of Aliens allowed on-screens; needs to be re-worked
			if (_aliensActive.length > _maxEasyAliens)
			{
				trace("Cannot create more aliens that is allowed.");
				return;
			}
			
			if (type == 1)
			{
				_tempAlien = _poolAlienEasy.getSprite() as Alien;
			}
			
			if (type == 2)
			{
				_tempAlien = _poolAlienMedium.getSprite() as Alien;
			}
			
			if (type == 3)
			{
				_tempAlien = _poolAlienHard.getSprite() as Alien;
			}
			
			_tempAlien.x = (Math.random() * (640 - _tempAlien.width)) + _tempAlien.width;
			_tempAlien.y = 0 - _tempAlien.height * 0.5;
			_aliensActive.push(_tempAlien);
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
		
		private function destroyAlien(a:Alien, i:Number):void
		{
			if (a.type == 1)
			{
				_poolAlienEasy.returnSprite(a);
			}
			else if (a.type == 2)
			{
				_poolAlienMedium.returnSprite(a);
			}
			else if (a.type == 3)
			{
				_poolAlienHard.returnSprite(a);
			}
			
			a.x = -100;
			a.y = -100;
			_aliensActive.splice(i, 1);
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
	}
}



































