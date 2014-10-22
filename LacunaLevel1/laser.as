package  {
	
	import flash.display.Sprite;
	public class laser extends Sprite{
		
		var half:Number;
		var i:Number;
		const HEIGHT:Number = 80;
		
		public function laser(count:int, px:Number, py:Number, mul:Boolean) {
			// constructor code
			half = count/2;
			var ls:laser_piece = new laser_piece();
			
			var ls_count:int = 1;
			var cur_px:Number = px;
			var j:int = 0;
			
			if (mul == true) {
				ls_count = 2;
				cur_px-=10;
			}
			
			
			for (j=1;j<=ls_count;j++) {
				for (i=(half-0.5);i>(-half);i--) {
					ls = new laser_piece();
					this.addChild(ls);
					ls.x = cur_px;
					ls.y = py+(HEIGHT * i);
				}
				cur_px += 20;
			}
			
		}

	}
	
}
