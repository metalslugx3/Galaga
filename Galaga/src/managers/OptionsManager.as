package managers
{
	import citrus.core.CitrusEngine;
	import citrus.view.starlingview.StarlingView;
	
	import core.Assets;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import flashx.textLayout.formats.TextAlign;
	
	import objects.Hero;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.text.TextField;
	
	public class OptionsManager
	{
		public var enabled:Boolean;
		public var isDoneLoading:Boolean;
		
		private var _ce:CitrusEngine;
		private var _stage:starling.display.Stage;
		private var _optionsContainer:starling.display.Sprite;
		private var _nativeOptionsContainer:flash.display.Sprite;
		
		private var _gapHeight:int;
		private var _textSelected:Dictionary;
		private var _textFieldsArray:Array;
		
		
		private var _menuSWF:MovieClip;
		private var _menuMC:MovieClip;
		private var _upMC:MovieClip;
		private var _downMC:MovieClip;
		private var _leftMC:MovieClip;
		private var _rightMC:MovieClip;
		private var _fireMC:MovieClip;
		private var _bombMC:MovieClip;
		private var _pauseMC:MovieClip;
		
		public function OptionsManager(ce:CitrusEngine)
		{
			_ce = ce;
			
			initialize();
		}
		
		private function initialize():void
		{
			_stage = (_ce.state.view as StarlingView).viewRoot.stage;
			
			enabled = false;
			isDoneLoading = false;
			
			_gapHeight = 50;
			_textSelected = new Dictionary();
			_textSelected["up"] = false;
			_textSelected["down"] = false;
			_textSelected["left"] = false;
			_textSelected["right"] = false;
			_textSelected["fire"] = false;
			_textSelected["bomb"] = false;
			_textSelected["pause"] = false;
			_textFieldsArray = [];
			
			createMenu();
			//createUI();	// ui no longer needed
			
			//enable();
			disable();
		}
		
		private function createMenu():void
		{
			_menuSWF = new Assets.MenuSWF() as MovieClip;
			Starling.current.nativeOverlay.addChild(_menuSWF);
			_menuSWF.addEventListener(flash.events.Event.COMPLETE, menuSWFLoaded);
		}

		/**
		 * 	Wait for contents of the embedded SWF to load. It's embedded but still needs to load through the Loader Class.
		 * */
		private function menuSWFLoaded(event:flash.events.Event):void
		{
			trace("MenuSWF finished \"loading\" inside OptionsManager.");
			_menuSWF.visible = false;
			
			isDoneLoading = true;
			
			// save the parent mc of the menu swf
			_menuMC = ((_menuSWF.getChildAt(0) as Loader).content as MovieClip).complete_mc;
			
			// save the individual MC's in separate MC because fucking mouse events how do they work
			_upMC = _menuMC.up;
			_downMC = _menuMC.down;
			_leftMC = _menuMC.left;
			_rightMC = _menuMC.right;
			_fireMC = _menuMC.fire;
			_bombMC = _menuMC.bomb;
			_pauseMC = _menuMC.pause;
			
			// remove mouse children or the keyBG_mc and key_txt will fucking get mouse events holy shit this is taking too long
			_upMC.mouseChildren = false;
			_downMC.mouseChildren = false;
			_leftMC.mouseChildren = false;
			_rightMC.mouseChildren = false;
			_fireMC.mouseChildren = false;
			_bombMC.mouseChildren = false;
			_pauseMC.mouseChildren = false;
		}
		
		/**
		 * 	Toggles the menu display. Used by outside Classes.
		 * */
		public function toggle():void
		{
			this.enabled = !this.enabled;
			
			if (this.enabled)
				this.enable();
			else
				this.disable();
		}
		
		/**
		 * 	Show the options menu.
		 * */
		public function enable():void
		{
			// deprecated
			//_optionsContainer.visible = true;
			//_nativeOptionsContainer.visible = true;
			
			enabled = true;
			_menuSWF.visible = true;
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, keyD);
			
			// add a mouse over to the movie clip menu in the swf
			_menuMC.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		}
		
		/**
		 * 	Hide the options menu.
		 * */
		public function disable():void
		{
			// deprecated
			//_optionsContainer.visible = false;
			//_nativeOptionsContainer.visible = false;
			
			enabled = false;
			_menuSWF.visible = false;
			
			_stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyD);
			
			// remove if it exists because most likely its still loading
			if (_menuMC)
				_menuMC.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		}
		
		/**
		 * 	Gets the mouse over for the complete_mc. Determines if it's over a specific "key" mc.
		 * */
		private function onMouseOver(e:MouseEvent):void
		{
			trace(e.target.name);
			
			// set all keys selection to false 
			_textSelected["up"] = false;
			_textSelected["down"] = false;
			_textSelected["left"] = false;
			_textSelected["right"] = false;
			_textSelected["fire"] = false;
			_textSelected["bomb"] = false;
			_textSelected["pause"] = false;
			
			if (e.target.name == "up")
			{
				_textSelected["up"] = true;
			}
			else if (e.target.name == "down")
			{
				_textSelected["down"] = true;
			}
			else if (e.target.name == "left")
			{
				_textSelected["left"] = true;
			}
			else if (e.target.name == "right")
			{
				_textSelected["right"] = true;
			}
			else if (e.target.name == "fire")
			{
				_textSelected["fire"] = true;
			}
			else if (e.target.name == "bomb")
			{
				_textSelected["bomb"] = true;
			}
			else if (e.target.name == "pause")
			{
				_textSelected["pause"] = true;
			}
		}
		
		private function keyD(e:KeyboardEvent):void
		{
			// O - default options key is O
			if (e.keyCode == 79)
			{
				trace("Cannot use the O key.");
				return;
			}
			
			for (var key:Object in _textSelected)
			{
				if (_textSelected[key])
				{
					switch (key)
					{
						case "up":
							//_textFieldsArray[0].text = convertKeyCodeToString(e.keyCode);
							_upMC.keyBG_mc.key_txt.text = convertKeyCodeToString(e.keyCode);
							Hero.KB_UP = {string:"up", key:e.keyCode};
							break;
						case "down":
							//_textFieldsArray[1].text = convertKeyCodeToString(e.keyCode);
							_downMC.keyBG_mc.key_txt.text = convertKeyCodeToString(e.keyCode);
							Hero.KB_DOWN = {string:"down", key:e.keyCode};
							break;
						case "left":
							//_textFieldsArray[2].text = convertKeyCodeToString(e.keyCode);
							_leftMC.keyBG_mc.key_txt.text = convertKeyCodeToString(e.keyCode);
							Hero.KB_LEFT = {string:"left", key:e.keyCode};
							break;
						case "right":
							//_textFieldsArray[3].text = convertKeyCodeToString(e.keyCode);
							_rightMC.keyBG_mc.key_txt.text = convertKeyCodeToString(e.keyCode);
							Hero.KB_RIGHT = {string:"right", key:e.keyCode};
							break;
						case "fire":
							//_textFieldsArray[4].text = convertKeyCodeToString(e.keyCode);
							_fireMC.keyBG_mc.key_txt.text = convertKeyCodeToString(e.keyCode);
							Hero.KB_FIRE = {string:"fire", key:e.keyCode};
							break;
						case "bomb":
							//_textFieldsArray[5].text = convertKeyCodeToString(e.keyCode);
							_bombMC.keyBG_mc.key_txt.text = convertKeyCodeToString(e.keyCode);
							Hero.KB_BOMB = {string:"bomb", key:e.keyCode};
							break;
						case "pause":
							//_textFieldsArray[6].text = convertKeyCodeToString(e.keyCode);
							_pauseMC.keyBG_mc.key_txt.text = convertKeyCodeToString(e.keyCode);
							Hero.KB_PAUSE = {string:"pause", key:e.keyCode};
							break;
					}
				}
			}
		}
		
		/**
		 * 	Converts keyboard keys to their string equivalents.
		 * */
		private function convertKeyCodeToString(keyCode:uint):String
		{
			var stringEquiv:String;
			
			switch (keyCode)
			{
				case 37:
					stringEquiv = "Left Arrow";
					break;
				case 38:
					stringEquiv = "Up Arrow";
					break;
				case 39:
					stringEquiv = "Right Arrow";
					break;
				case 40:
					stringEquiv = "Down Arrow";
					break;
				default:
					stringEquiv = String.fromCharCode(keyCode);
					break;
			}
			
			return stringEquiv;
		}
		
		
		
		
		
		
		
		
		
		
		private function createUI():void
		{
			//_optionsContainer = new starling.display.Sprite();
			//_stage.addChild(_optionsContainer);
			//_optionsContainer.visible = false;
			
			_nativeOptionsContainer = new flash.display.Sprite();
			Starling.current.nativeOverlay.addChild(_nativeOptionsContainer);
			
			/*createStarlingTF(320, 100, "Up Arrow");
			createStarlingTF(320, 150, "Down Arrow");
			createStarlingTF(320, 200, "Left Arrow");
			createStarlingTF(320, 250, "Right Arrow");
			createStarlingTF(320, 300, "Control");
			createStarlingTF(320, 350, "J");
			createStarlingTF(320, 400, "P");*/
			
			/*var x:int = 350;
			createNativeTF(x, 95, "Up Arrow");
			createNativeTF(x, 150, "Down Arrow");
			createNativeTF(x, 200, "Left Arrow");
			createNativeTF(x, 250, "Right Arrow");
			createNativeTF(x, 300, "Control");
			createNativeTF(x, 350, "J");
			createNativeTF(x, 400, "P");*/
			
			//_optionsContainer.addEventListener(starling.events.TouchEvent.TOUCH, onTouch);
			//_nativeOptionsContainer.addEventListener(flash.events.TouchEvent.TOUCH_BEGIN, t);
			//_nativeOptionsContainer.addEventListener(MouseEvent.CLICK, click);
		}
		
		protected function click(event:MouseEvent):void
		{
			trace("clickz");
		}
		
		private function t(e:flash.events.TouchEvent):void
		{
			trace(e.target);
		}
		
		private function createStarlingTF(x:int, y:int, defaultValue:String):void
		{
			var _tf:starling.text.TextField;
			_tf = new starling.text.TextField(100, 32, defaultValue, "Verdana", 12, 0xffffff);
			_optionsContainer.addChild(_tf);
			//_tf.border = true;
			_tf.autoSize = TextFieldAutoSize.CENTER;
			_tf.x = x;
			_tf.y = y;
			_textFieldsArray.push(_tf);
		}
		
		private function createNativeTF(x:int, y:int, defaultValue:String):void
		{
			var _tf:flash.text.TextField;
			_tf = new flash.text.TextField(); // 100, 32, defaultValue, "Verdana", 12, 0xffffff
			_nativeOptionsContainer.addChild(_tf);
			
			var textFormat:TextFormat = new TextFormat("Verdana", 12, 0xffffff);
			textFormat.align = TextAlign.CENTER;
			_tf.defaultTextFormat = textFormat;
			
			_tf.text = defaultValue;
			//_tf.border = true;
			_tf.autoSize = TextFieldAutoSize.NONE;
			_tf.width = 100;
			_tf.height = 16;
			_tf.x = x;
			_tf.y = y;
			_textFieldsArray.push(_tf);
		}
		
		private function returnToDefault(keyNoChange:String, indexToIgnore:int):void
		{
			var count:int = 0;
			for (var key:Object in _textSelected)
			{
				// set the others keys other than this one to false and color to white
				if (key != keyNoChange)
				{
					_textSelected[key] = false;
					if (count != indexToIgnore)		// 0 = the up key
					{
						_textFieldsArray[count].color = 0xffffff;
					}
					count++;
				}
			}
		}
		
		private function onTouch(e:starling.events.TouchEvent):void
		{
			var touch:Touch = e.getTouch(_optionsContainer);
			
			if (touch)
			{
				var i:int = _textFieldsArray.length - 1;
				for (i; i >= 0; i--)
				{
					if (touch.isTouching(_textFieldsArray[i]))
					{
						var temp:String = "";
						if (i == 0)
							temp = "up";
						if (i == 1)
							temp = "down";
						if (i == 2)
							temp = "left";
						if (i == 3)
							temp = "right";
						if (i == 4)
							temp = "fire";
						if (i == 5)
							temp = "bomb";
						if (i == 6)
							temp = "pause";
						
						if (!_textSelected[temp] && touch.tapCount == 1)
						{
							_textSelected[temp] = true;
							_textFieldsArray[i].color = 0xff0000;
							
							// make other text selected false
							returnToDefault(temp, i);
						}
					}
				}
			}
		}
	}
}



































