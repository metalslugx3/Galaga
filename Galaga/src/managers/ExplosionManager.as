package managers
{
	import com.leebrimelow.starling.StarlingPool;
	
	import objects.Explosion;
	
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
				tempE.scaleX = tempE.scaleY = 0.35;
				tempE.x = -100;
				tempE.y = -100;
				_game.addChild(tempE);
				tempE.visible = false;
			}
			
			_activeExplosions = [];
		}
		
		public function update(deltaTime:Number):void
		{
			//trace(_activeExplosions.length)
		}
		
		public function createExplosion(x:int, y:int):void
		{
			//trace("creating explosion at: " + (x + " , " +  y));
			if (_activeExplosions.length >= _maxExplosions)
			{
				return;
			}
			
			// get explosion from pool
			var tempExplosion:Explosion = (_pool.getSprite() as Explosion);
			
			// position explosion
			tempExplosion.x = x;
			tempExplosion.y = y;
			
			// set visibility to true
			tempExplosion.visible = true;
			
			// add listener for complete
			tempExplosion.addEventListener(Event.COMPLETE, onComplete);
			
			// start explosion; end early for good effect
			tempExplosion.start(.18);
			
			// add explosion to juggler for animation
			_game.pausedGameObjectsJuggler.add(tempExplosion);
			
			// add to array
			_activeExplosions.push(tempExplosion);
		}
		
		private function onComplete(e:Event):void
		{
			//trace("Explosion complete; removing; adding back to pool.");
			var ex:Explosion = e.currentTarget as Explosion;
			
			// remove the listener
			ex.removeEventListener(Event.COMPLETE, onComplete);
			
			// check if pool is null first (just in case the pool has been destroyed before the event method runs)
			if (_pool != null)
			{
				_pool.returnSprite(ex);
			}
			
			// splice from array
			_activeExplosions.splice(_activeExplosions.indexOf(ex), 1);
			
			// set visibility to false (no need to position off-stage)
			ex.visible = false;
			
			// remove from juggler to stop animation
			_game.pausedGameObjectsJuggler.remove(ex);
		}
		
		/**
		 * 	Clean up Class.
		 * */
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
				
				_game.pausedGameObjectsJuggler.remove(ex);
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



































