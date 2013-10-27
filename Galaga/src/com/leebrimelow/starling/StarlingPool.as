package com.leebrimelow.starling
{
	import starling.display.DisplayObject;

	public class StarlingPool
	{
		public var items:Array;
		private var counter:int;
		
		/**
		 * 
		 * @param	type	the type to create in the pool
		 * @param	len		how many of the specified type to create
		 * @param	params	
		 */
		public function StarlingPool(type:Class, len:int, params:int = 1337)
		{
			items = new Array();
			counter = len;
			
			var i:int = len;
			while (--i > -1)
			{
				items[i] = new type();
			}
		}
		
		public function getSprite():*
		{
			if(counter > 0)
				return items[--counter];
			else
				throw new Error("You exhausted the pool!");
		}
		
		public function returnSprite(s:*):void
		{
			items[counter++] = s;
		}
		
		public function destroy():void
		{
			items = null;
		}
	}
}