package  {
	
	import flash.display.Sprite;
	import SniperAnime;
	
	/**
	 * @author Nihav Jain
	 * @class FullSniper - sniper animation class
	 */
	public class FullSniper extends Sprite{
		
		private var body:Body;
		private var gunandhand:gunHand;
		private var animation:SniperAnime;
		
		/**
		 * @constructor
		 */
		public function FullSniper() 
		{
			var body = new Body();
			gunandhand = new gunHand();
			this.addChild(body);
			animation = new SniperAnime(gunandhand);
			gunandhand.x = 25;
			gunandhand.y = 82.5;
			this.addChild(animation);
		}
		
		/**
		 * @method pointAt
		 * @desc make the siper point at given coordinates
		 * @param	xcord
		 * @param	ycord
		 */
		public function pointAt(xcord:Number,ycord:Number)
		{
			animation.animate(xcord,ycord);
		}

	}
	
}
