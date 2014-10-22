package  {
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import com.greensock.*;
	import com.greensock.easing.*;
	
	public class TeleportAnimation extends Sprite{

		private var masker:sprayMask;
		private var human:Sprite;
		
		public function TeleportAnimation(Human:Sprite) {
			// constructor code
			
			human = Human;
			this.addChild(human);
			masker = new sprayMask();
			this.masker.maskRect = new maskRect();
			this.addChild(masker);
			this.addChild(masker.maskRect);
			masker.maskRect.x = -masker.maskRect.width / 2;
			masker.maskRect.y = -masker.maskRect.height / 2;
			masker.x = human.x;
			masker.y = human.y;
			this.masker.maskRect.height = human.height;
			masker.maskRect.width = human.width;
			
		}
		
		public function animate(flag:String):Number
		{
			masker.rotation = 0;
			masker.y = -0.15*human.height;
			if(flag == "disappear")
			{
				human.alpha=1;
				masker.y = -0.15*human.height;				
				TweenLite.to(this.masker,2.5,{y:-3*human.height,ease:Linear});
				TweenLite.to(human,2,{alpha:0,ease:Linear});
			}
			else if (flag == "appear")
			{	
				trace("should have appeared");
				/*human.alpha=0;
				masker.y=-3*human.height;				
				TweenLite.to(this.masker,1.5,{y:-0.15*human.height,ease:Linear});
				TweenLite.to(human,2,{alpha:1,ease:Linear});*/
			}
			
			return 2.5;
		}
		
	}
	
}
