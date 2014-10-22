package  
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Nihav Jain
	 * @class WallBuilder - generates walls
	 */
	public class WallBuilder extends Builder
	{
		/**
		 * @constructor
		 * @param	parent
		 * @param	wid
		 * @param	ht
		 * @param	loacation
		 * @param	fric
		 * @param	resti
		 */
		public function WallBuilder(parent:DisplayObjectContainer, wid:Number, ht:Number, loacation:Point, fric:Number, resti:Number) 
		{
			var wallBody:b2Body = createBody(wid, ht, loacation, fric, resti);
			var wallSprite:Sprite = createSprite(wid, ht, loacation);
			
			parent.addChild(wallSprite);
			super(wallBody, wallSprite, false);
			
		}
		
		/**
		 * @method createSprite
		 * @desc creates wall sprite
		 * @param	wid
		 * @param	ht
		 * @param	loacation
		 * @return
		 */
		private function createSprite(wid:Number, ht:Number, loacation:Point):Sprite
		{
			var wallSprite:Sprite = new WallSprite(wid, ht);
			wallSprite.x = loacation.x * Lacuna.WIDTH + wallSprite.width/2;
			wallSprite.y = loacation.y * Lacuna.HEIGHT + wallSprite.height/2;
			
			return wallSprite;
		}
		
		/**
		 * @method createBody
		 * @desc creates wall bodys
		 * @param	wid
		 * @param	ht
		 * @param	loacation
		 * @param	fric
		 * @param	resti
		 * @return
		 */
		private function createBody(wid:Number, ht:Number, loacation:Point, fric:Number, resti:Number):b2Body 
		{
			// create body def
			var wallBodyDef:b2BodyDef = new b2BodyDef();
			wallBodyDef.position.Set((loacation.x*Lacuna.WIDTH + wid*Lacuna.WIDTH/2) / PhysicsWorld.RATIO, (loacation.y * Lacuna.HEIGHT + ht * Lacuna.HEIGHT/2) / PhysicsWorld.RATIO);
			wallBodyDef.type = b2Body.b2_staticBody;
			
			// create body
			var wallBody:b2Body = PhysicsWorld.world.CreateBody(wallBodyDef);
			
			// create shape
			var wallShape:b2PolygonShape = new b2PolygonShape();
			wallShape.SetAsBox((wid * Lacuna.WIDTH) / 2 / PhysicsWorld.RATIO, (ht * Lacuna.HEIGHT) / 2 / PhysicsWorld.RATIO);
			
			// create fixture def
			var wallFixtureDef:b2FixtureDef = new b2FixtureDef();
			wallFixtureDef.shape = wallShape;
			wallFixtureDef.density = 0;
			wallFixtureDef.friction = fric;
			wallFixtureDef.restitution = resti;
			wallBody.CreateFixture(wallFixtureDef);
				
			return wallBody;
		}
		
	}
}