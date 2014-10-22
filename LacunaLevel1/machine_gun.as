package 
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import com.greensock.*;

	public class machine_gun extends Sprite
	{

		var mm1:ak47;
		var i:int;
		var b:bullet = new bullet();
		var b_arr:Array = new Array();
		var count:int = 0;
		var flag:Boolean = false;

		public function machine_gun()
		{
			// constructor code
			mm1 = new ak47();
			this.addChild(mm1);
		}
		public function fire(pfin_x:Number, pfin_y:Number)
		{
			MovieClip(mm1).gotoAndPlay(2);
			TweenLite.delayedCall(1, hit, [pfin_x, pfin_y]);
		}
		
		private function hit(pfin_x:Number, pfin_y:Number):void {
			for (i=0;i<4;i++) {
				TweenLite.delayedCall(i*0.25, hit2,[pfin_x, pfin_y]);
			}
			TweenLite.delayedCall(1.5, ret);
		}
		
		private function hit2(pfin_x:Number, pfin_y:Number):void
		{    
			b = new bullet();
			b.x = - 40;
			b.y =  10;
			b_arr[count] = b;
			this.addChild(b_arr[count]);
			trace(count);
			TweenLite.to(b_arr[count], 0.5, {x:pfin_x-this.x, y:pfin_y-this.y, onComplete:kill, onCompleteParams:[count]});
			count++;
		}
		
		private function kill(count:int):void {
			b_arr[count].visible = false;
			this.removeChild(b_arr[count]);
		}
		private function ret():void {
			MovieClip(mm1).gotoAndPlay(31);
		}
	}

}