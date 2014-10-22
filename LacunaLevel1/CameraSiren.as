package  {
	
	import com.greensock.*;
	import flash.display.Stage;
	import flash.display.Sprite;
	import com.greensock.easing.*;
	import flash.display.DisplayObject;
	
	/**
	 * @author Nihav Jain
	 * @class CameraSiren - Sprite for camera blare animation
	 */
	
	public class CameraSiren extends Sprite
	{
		
		private var Time:Number;
		private static var count:Number = 0;
		private var Width:Number;
		private var Height:Number;

		/**
		 * @constructor
		 * @param	time
		 * @param	Width
		 * @param	Height
		 */
		public function CameraSiren(time:Number,Width:Number,Height:Number) {
			// constructor code
			this.visible = false;
			this.alpha = 0;
			this.Time = time;
			this.Width = Width;
			this.Height = Height;
			blare();
		}
		
		/**
		 * @method blare
		 * @desc main animation logic
		 */
		public function blare():void
		{
			this.visible = true;
			if(count%2 == 0)				
			{	
				this.graphics.clear();
				this.graphics.beginFill(0xFF0000);
				this.graphics.drawRect(0,0,Width,Height);
				this.graphics.endFill();
			}
			else
			{
				this.graphics.clear();
				this.graphics.beginFill(0x0046F4);
				this.graphics.drawRect(0,0,Width,Height);
				this.graphics.endFill();
			}
			TweenLite.to(this, Time, {alpha:0.4, onComplete:changecolor,ease:Strong});
		}
		
		/**
		 * @method changecolor
		 * @desc changes coloe of blare rectangle
		 */
		public function changecolor():void
		{
			TweenLite.to(this, Time, {alpha:0,onComplete:blare,ease:Strong});
			count++;
			if(Time>0.17 && count%2==0)
				Time-=0.05;
		}

	}
	
}
