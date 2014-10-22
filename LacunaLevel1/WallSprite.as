package  
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Nihav Jain
	 */
	public class WallSprite extends Sprite
	{
		const HEIGHT:int = 80;
		var w_v:verti_wall;
		var w_c:corner_wall;
		var w_h:horiz_wall;
		var half:Number;
		var i:Number;
		
		public function WallSprite(wid:Number, hei:Number) 
		{
		if ((wid == 1) && (hei == 1)) {
				w_h = new horiz_wall();
				w_h.y = 0;
				w_h.x = 0;
				this.addChild(w_h);
			}
			else if (wid == 1) {
				half = hei/2;
				for (i=(half+0.5);i>(-half-1);i--) {
					w_v = new verti_wall;
					w_v.y = 54*i;
					w_v.x = 0;
					this.addChild(w_v);
				}
			}
			else if (hei == 1) {
				half = wid/2;
				for (i=(half-1.5);i>(-(half-1));i--) {
					w_h = new horiz_wall;
					w_h.y = 0;
					w_h.x = HEIGHT*i;
					this.addChild(w_h);
				}
				w_c = new corner_wall();
				w_c.y = 0;
				w_c.rotationY = 180;
				w_c.x = HEIGHT * (half-0.5);
				this.addChild(w_c);
				
				w_c = new corner_wall();
				w_c.y = 0;
				w_c.x = -(HEIGHT * (half-0.5));
				this.addChild(w_c);
			}
		}

	}

		
}
