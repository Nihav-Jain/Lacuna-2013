package{
	
	import flash.display.MovieClip;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	import flash.display.Sprite;
	import flashx.textLayout.events.ModelChange;

	public class SniperAnime extends Sprite{
	
		private var h:MovieClip;
	
		public function SniperAnime(ghand:MovieClip) {
			// constructor code
			h=ghand;
			this.addChild(h);
		}
	
		public function animate(xcord:Number,ycord:Number):void
		{
			var ratio:Number = (this.y-ycord)/(this.x-xcord);	
			TweenLite.to(h.Rest,0.5,{rotation:(Math.atan(ratio))*180/Math.PI});
			TweenLite.to(h.LH,0.5,{rotation:2.1*(Math.atan(ratio))*180/Math.PI});
			TweenLite.to(h.lhf,0.5,{rotation:1.9*(Math.atan(ratio))*180/Math.PI});
		}
		

	}
}
