package objects
{
	import citrus.objects.CitrusSprite;
	
	import core.Assets;
	
	public class Background extends CitrusSprite
	{
		public function Background(name:String, params:Object=null)
		{
			super(name, params);
		}
		
		override public function initialize(poolObjectParams:Object=null):void
		{
			super.initialize(poolObjectParams);
			
			// force updateCallEnabled to be true
			this.updateCallEnabled = true;
			
			// set the image to use
			this.view = new Assets.GraphicSpaceBG();
			
			// set the velocity, you pass in an Array indicating x and y velocity
			this.velocity = [0, 9];
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			if (this.y >= 0)
			{
				this.y = -_ce.stage.stageHeight;
			}
		}
	}
}



































