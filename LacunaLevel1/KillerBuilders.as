package 
{
	import Box2D.Collision.b2Bound;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.net.FileReference;
	
	/**
	 * ...
	 * @author Nihav Jain
	 * @class KillerBuilders - objects that can kill the Man
	 */
	public class KillerBuilders extends Builder 
	{
		public static const FIRE:uint = 1;
		public static const SPIKES:uint = 2;
		public static const BLOCK:uint = 3;
		
		public var currentSpriteType:uint;
		
		/**
		 * @constructor
		 * @param	parent
		 * @param	spriteType
		 * @param	location
		 */
		public function KillerBuilders(parent:DisplayObjectContainer, spriteType:int, location:Point)
		{
			var killerSprite:Sprite = createKSprite(spriteType);
			var killerBody:b2Body = createKBody(killerSprite.width, killerSprite.height, location);
			
			killerSprite.x = location.x + Lacuna.WIDTH/2;
			killerSprite.y = location.y + Lacuna.HEIGHT/2;
			parent.addChild(killerSprite);
			
			currentSpriteType = spriteType;
			super(killerBody, killerSprite, false); 
		}
		
		/**
		 * @method createKSprite
		 * @desc creartes the Sprite for thegiven killer type object
		 * @param	spriteType
		 * @return	Sprite
		 */
		private function createKSprite(spriteType:uint):Sprite
		{
			var killerSprite:Sprite = new Sprite();
			killerSprite.width = 80;
			killerSprite.height = 80;
			if (spriteType == FIRE)
			{
				killerSprite = new Fire();
			}
			else if (spriteType == SPIKES)
			{
				killerSprite = new WallSprite(80, 80);
			}
			else if (spriteType == BLOCK)
			{
				killerSprite = new Dropbox();				
			}
			
			return killerSprite;
		}
		
		/**
		 * @method createKBody
		 * @desc create a Box2D body
		 * @param	wid
		 * @param	ht
		 * @param	loacation
		 * @return	b2Body
		 */
		private function createKBody(wid:Number, ht:Number, loacation:Point):b2Body 
		{
			// create body def
			var killerBodyDef:b2BodyDef = new b2BodyDef();
			killerBodyDef.position.Set((loacation.x*Lacuna.WIDTH + Lacuna.WIDTH/2) / PhysicsWorld.RATIO, (loacation.y*Lacuna.HEIGHT + Lacuna.HEIGHT/2) / PhysicsWorld.RATIO);
			killerBodyDef.type = b2Body.b2_kinematicBody;
			
			// create body
			var killerBody:b2Body = PhysicsWorld.world.CreateBody(killerBodyDef);
			
			// create shape
			var killerShape:b2PolygonShape = new b2PolygonShape();
			killerShape.SetAsBox(wid / 2 / PhysicsWorld.RATIO, ht / 2 / PhysicsWorld.RATIO);
			
			// create fixture def
			var killerFixtureDef:b2FixtureDef = new b2FixtureDef();
			killerFixtureDef.shape = killerShape;
			killerFixtureDef.density = 0;	
			killerBody.CreateFixture(killerFixtureDef);
						
			return killerBody;
		}
		
		/**
		 * @method killerAnime
		 * @desc handle killer animation for each type of killer object, currently handled in Man
		 * TODO: implement here
		 */
		public function killerAnime():void
		{
			//trace("man killed");
			//---.play(); not sure what to play..
		}
	}
	
}