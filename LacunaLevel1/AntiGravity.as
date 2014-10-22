package  
{
	import Box2D.Collision.b2AABB;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import com.greensock.TweenLite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Nihav Jain
	 * @class AntiGravity - repersents the antigravity region
	 */
	public class AntiGravity 
	{
		private var aabb:b2AABB;
		private var aabb2:b2AABB;
		private var antiGravity:b2Vec2;
		private var gravFlag:Boolean = false;
		
		/**
		 * @constructor
		 * @param	location
		 * @param	width
		 * @param	height
		 */
		public function AntiGravity(location:Point, width:Number, height:Number) 
		{
			aabb = new b2AABB();
			aabb.lowerBound.Set((location.x * Lacuna.WIDTH) / PhysicsWorld.RATIO-1, (location.y * Lacuna.HEIGHT) / PhysicsWorld.RATIO);
			aabb.upperBound.Set((location.x + width)*Lacuna.WIDTH / PhysicsWorld.RATIO, (location.y + height)*Lacuna.HEIGHT / PhysicsWorld.RATIO);
			antiGravity = new b2Vec2( -2.0 * PhysicsWorld.world.GetGravity().x, -2.0 * PhysicsWorld.world.GetGravity().y);
			
			aabb2 = new b2AABB();
			aabb2.lowerBound.Set((location.x * Lacuna.WIDTH) / PhysicsWorld.RATIO+4.4, (location.y * Lacuna.HEIGHT) / PhysicsWorld.RATIO-1.6);
			aabb2.upperBound.Set((location.x + width)*Lacuna.WIDTH / PhysicsWorld.RATIO, (location.y + height)*Lacuna.HEIGHT / PhysicsWorld.RATIO-2);
		}
		
		/**
		 * @method sendQuery
		 * @desc queries the world for bodies in its area
		 */
		public function sendQuery():void
		{
			gravFlag = false;
			PhysicsWorld.world.QueryAABB(callback2, aabb2);
			if (gravFlag) {
				Man.antiGrav = true;
			}
			else {
				Man.antiGrav = false;
			}
			PhysicsWorld.world.QueryAABB(callback, aabb);
		}
		
		/**
		 * @method callback2
		 * @desc callback for first query
		 * @param	fix
		 * @return	boolean
		 */
		private function callback2(fix:b2Fixture):Boolean 
		{
			if (fix.GetBody().GetUserData() is Man) {
				gravFlag = true;
			}
			return true;
		}
		
		/**
		 * @method callback
		 * @desc callback for second query, applies impulse on Man
		 * @param	fix
		 * @return	boolean
		 */
		private function callback(fix:b2Fixture):Boolean 
		{
			////trace("yeah");
			if (fix.GetBody().GetUserData() is Man) {
				gravFlag = true;
				Man.antiGrav = true;
			}
			var body:b2Body = fix.GetBody();
			body.ApplyImpulse(new b2Vec2(0, -4) , body.GetWorldCenter());
			return true;
		}
		
	}

}