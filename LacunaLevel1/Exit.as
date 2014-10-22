package  
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Nihav Jain
	 * @class Exit - represents the exit for a level
	 */
	public class Exit extends Builder 
	{
		/**
		 * @constructor
		 * @param	parent
		 * @param	location
		 */
		public function Exit(parent:Sprite, location:Point) 
		{
			var exitSprite:Sprite = new ExitSprite();
			var exitBody:b2Body = createBody(80, 80, location);
			
			parent.addChild(exitSprite);
			exitSprite.x = location.x * Lacuna.WIDTH + Lacuna.WIDTH / 2;
			exitSprite.y = location.y * Lacuna.HEIGHT + Lacuna.HEIGHT / 2;
			
			super(exitBody, exitSprite, false);
		}
		
		/**
		 * @method createBody
		 * @desc creates a Box2D body
		 * @param	wid
		 * @param	ht
		 * @param	location
		 * @return
		 */
		private function createBody(wid:Number, ht:Number, location:Point):b2Body 
		{
			var bodydef:b2BodyDef = new b2BodyDef();
			bodydef.position.Set((location.x * Lacuna.WIDTH + Lacuna.WIDTH / 2) / PhysicsWorld.RATIO, (location.y * Lacuna.HEIGHT + Lacuna.HEIGHT / 2) / PhysicsWorld.RATIO);
			bodydef.type = b2Body.b2_staticBody;
			
			var shape:b2PolygonShape = new b2PolygonShape();
			shape.SetAsBox(wid / 2 / PhysicsWorld.RATIO, ht / 2 / PhysicsWorld.RATIO);
			
			var fix:b2FixtureDef = new b2FixtureDef();
			fix.shape = shape;
			
			var exitbody:b2Body = PhysicsWorld.world.CreateBody(bodydef);
			exitbody.CreateFixture(fix);
			
			return exitbody;
		}
		
	}

}