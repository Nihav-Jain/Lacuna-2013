package  
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Nihav Jain
	 * @class LevelCamera - camera for the displaying the level to user, panning etc.
	 */
	public class LevelCamera extends Sprite 
	{
		private static var ZOOMX:Number;
		private static var ZOOMY:Number;		
		
		/**
		 * @constructor
		 * @param	screenWid
		 * @param	screenHt
		 * @param	levelWid
		 * @param	levelHt
		 */
		public function LevelCamera(screenWid:Number, screenHt:Number, levelWid:Number, levelHt:Number) 
		{
			ZOOMX = screenWid / (levelWid*Lacuna.WIDTH);
			ZOOMY = screenHt / (levelHt*Lacuna.HEIGHT);
		}
		
		/**
		 * @method zoom_out
		 * @desc scales the level to fit screen
		 * @param	zoompoint
		 */
		public function zoom_out(zoompoint:Point):void
		{
			//trace("yeah", ZOOMX, ZOOMY);
			this.scaleX = 0.1;//ZOOMX;
			this.scaleY = 0.1;//ZOOMY;
			
			this.x = 600;
			this.y = 300;
		}
		
		/**
		 * @method zoomback
		 * @desc scales the level to original
		 * @param	zoompoint
		 */
		public function zoomback(zoompoint:Point):void
		{
			this.scaleX = 1.0;
			this.scaleY = 1.0;
//			this.x = 0;
			this.x = zoompoint.x;
			this.y = zoompoint.y;
		}
		
		public function pan(panpoint:Point):void
		{
			
		}
	}

}