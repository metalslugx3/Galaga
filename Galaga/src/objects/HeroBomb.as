package objects
{
	import core.Assets;
	
	import org.osflash.signals.Signal;
	
	import starling.display.MovieClip;
	import starling.events.Event;
	
	import states.GameState;
	
	public class HeroBomb extends Projectile
	{
		public var radius:int;
		
		private var _mc:MovieClip;
		private var _isActive:Boolean;
		
		public var explosionDone:Signal;
		
		public function HeroBomb(game:GameState=null)
		{
			super(game);
		}
		
		override protected function initialize(e:Event):void
		{
			super.initialize(e);
			
			explosionDone = new Signal();
			_isActive = false;
			radius = 120;
		}
		
		override protected function createArt():void
		{
			super.createArt();
			
			_mc = new MovieClip(Assets.textureAtlas.getTextures("ExplosionBomb_"));
			this.addChild(_mc);
			_mc.alignPivot("center", "center");
			_mc.stop();
			_mc.visible = false;
			_mc.loop = false;
			_game.pausedGameObjectsJuggler.add(_mc);
			
			_mc.addEventListener(Event.COMPLETE, explosionComplete);
		}
		
		/**
		 * 	When the explosion is complete we will hide it and stop animation; no need to move it off-stage.
		 * */
		private function explosionComplete(e:Event):void
		{
			// dispatch that the explosion has completed its animation
			explosionDone.dispatch({myMC:_mc, myNum:5, myString:"truck"});
			
			_isActive = false;
			_mc.visible = false;
			_mc.stop();
			
			// tell hero he can fire another bomb since the first one expired
			_game.hero.canFireBomb = true;
		}
		
		/**
		 * 	Starts the explosion animation.
		 * */
		public function beginExplosion():void
		{
			_isActive = true;
			_mc.visible = true;
			_mc.play();
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			_game.pausedGameObjectsJuggler.remove(_mc);
			
			_mc.removeEventListener(Event.COMPLETE, explosionComplete);
			this.removeChild(_mc);
			_mc.dispose();
			_mc = null;
		}

		public function get isActive():Boolean
		{
			return _isActive;
		}

		public function set isActive(value:Boolean):void
		{
			_isActive = value;
		}

	}
}



































