package 
{

	import flash.display.Sprite;
	import laser;
	import com.greensock.*;
	import com.greensock.easing.*;

	public class laser_container extends Sprite
	{
		var ls1:laser;
		var bs1:ls_base;
		var bs2:horiz_base;
		var ls_cont:Sprite;
		
		public function laser_container(count:int, px:Number, py:Number, mul:Boolean, rot:Boolean)
		{
			// constructor code
			bs1 = new ls_base();
			bs2 = new horiz_base();
			ls_cont = new Sprite();
			ls1 = new laser(count,0,0,mul);
			
			ls1.x = 0;
			ls_cont.addChild(ls1);
			ls_cont.x =0;
			ls_cont.y =0;
			this.addChild(ls_cont);
			
			if (rot == true) {
				ls_cont.rotationZ = 90;
				ls_cont.y += -20 - ls_cont.height;
				this.addChild(bs2);
				bs2.x = /*px-*/-(ls1.height/2);
				bs2.y = /*py + */6+ -20- ls_cont.height;
				
				bs2 = new horiz_base();
				this.addChild(bs2);
				bs2.x = /*px + */(ls1.height / 2);
				bs2.rotationY = 180;
				bs2.y = /*py + */6+ -20- ls_cont.height;
			}
			else {
			//adding the base
			this.addChild(bs1);
			bs1.x = 0;// px;
			bs1.y = /*py+*/(ls1.height/2)+5;
			}
			
		}
		public function wipe():void {
			TweenLite.to(ls_cont, 1, {scaleY:0, ease:Cubic.easeIn});
		}
		public function giveMeY():Number {
			return ls_cont.y;
		}
	}

}