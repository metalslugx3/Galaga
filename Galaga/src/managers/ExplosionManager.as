package managers
{
	import com.leebrimelow.starling.StarlingPool;
	
	import objects.Explosion;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	import states.GameState;

	public class ExplosionManager
	{
		private var _game:GameState;
		
		private var _pool:StarlingPool;
		private var _maxExplosions:int;
		private var _activeExplosions:Array;
		
		public function ExplosionManager(game:GameState)
		{
			_game = game;
			
			initialize();
		}
		
		private function initialize():void
		{
			_maxExplosions = 20;
			_pool = new StarlingPool(Explosion, _maxExplosions);
			
			var tempE:Explosion;
			var i:int = 0;
			for (i; i < _maxExplosions; i++)
			{
				tempE = _pool.items[i];
				tempE.x = -100;
				tempE.y = -100;
				_game.addChild(tempE);
				tempE.alpha = 0;
			}
			
			_activeExplosions = [];
		}
		
		public function update(deltaTime:Number):void
		{
			
		}
		
		public function createExplosion(x:int, y:int):void
		{
			if (_activeExplosions.length >= _maxExplosions)
			{
				return;
			}
			
			var tempExplosion:Explosion = (_pool.getSprite() as Explosion);
			tempExplosion.scaleX = tempExplosion.scaleY = 0.35;
			tempExplosion.x = x;
			tempExplosion.y = y;
			Starling.juggler.add(tempExplosion);
			tempExplosion.start(.18);
			tempExplosion.alpha = 1;
			tempExplosion.addEventListener(Event.COMPLETE, onComplete);
		}
		
		private function onComplete(e:Event):void
		{
			var ex:Explosion = e.currentTarget as Explosion;
			ex.removeEventListener(Event.COMPLETE, onComplete);
			
			if (_pool != null)
			{
				_pool.returnSprite(ex);
			}
			
			Starling.juggler.remove(ex);
		}
		
		public function destroy():void
		{
			// remove the explosions added to the GameState, call destroy, call dispose, splice from Array, remove references
			var ex:Explosion;
			var i:int = _activeExplosions.length - 1;
			for (i; i >= 0; i--)
			{
				ex = _activeExplosions[i];
				
				// check for listener, just in case, and remove it
				if (ex.hasEventListener(Event.COMPLETE))
				{
					ex.removeEventListeners(Event.COMPLETE);
				}
				
				Starling.juggler.remove(ex);
				ex.stop(true);
				ex.dispose();
				_game.removeChild(ex);
				_activeExplosions.splice(i, 1);
			}
			ex = null;
			_activeExplosions = null;
			
			// destroy the pool
			_pool.destroy();
			
			// remove reference to _game
			_game = null;
		}
	}
}



































