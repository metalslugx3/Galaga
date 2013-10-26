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
		private var _poolAlienEasy:StarlingPool;
		private var _poolAlienMedium:StarlingPool;
		private var _poolAlienHard:StarlingPool;
		private var _aliensActive:Array;
		private var _tempAlien:Alien;
		
		private var _spawnTimer:uint;
		private var _lastSpawn:uint;
		private var _spawnRate:Number;
		private var _spawnWave:int;
		
		public function AlienManager(game:GameState)
		{
			_game = game;
			
			initialize();
		}
			
		private function initialize():void
		{
			_maxAliens = 30;
			
			_poolAlienEasy = new StarlingPool(AlienEasy, _maxAliens);
			_poolAlienMedium = new StarlingPool(AlienMedium, _maxAliens);
			_poolAlienHard = new StarlingPool(AlienHard, _maxAliens);
			
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
			_spawnRate = 0.02;
		}
		
		public function update(deltaTime:Number):void
		{
			if (Math.random() < _spawnRate)
			{
				spawnAlien();
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
		
		public function spawnAlien():void
		{
			if (_aliensActive.length > _maxAliens)
			{
				trace("Cannot create more aliens that is allowed.");
				return;
			}
			
			// simple check to spawn random enemies
			var randomSpawn:Number = Math.random();
			
			if (randomSpawn <= 0.5)
			{
				_tempAlien = _poolAlienEasy.getSprite() as Alien;
			}
			else if (randomSpawn > 0.5 && randomSpawn <= 0.8)
			{
				_tempAlien = _poolAlienMedium.getSprite() as Alien;
			}
			else if (randomSpawn > 0.8 && randomSpawn <= 1)
			{
				_tempAlien = _poolAlienHard.getSprite() as Alien;
			}
			
			_tempAlien.x = (Math.random() * (640 - _tempAlien.width)) + _tempAlien.width;
			_tempAlien.y = 0 - _tempAlien.height * 0.5;
			_aliensActive.push(_tempAlien);
		}
		
		private function destroyAlien(a:Alien, i:Number):void
		{
			_poolAlienEasy.returnSprite(a);
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



































