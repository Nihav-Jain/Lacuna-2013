package  
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import fl.motion.Keyframe;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Nihav Jain
	 * @class CollectableItem - Class for objects that can be collected and stored in the inventory
	 */
	public class CollectableItem extends Builder 
	{
		public var _spriteToUse:Sprite;
		
		public static const PLANK:uint 		= 1;
		public static const BATTERY:uint 	= 2;
		public static const SHOWEL:uint 	= 3;
		public static const KEY:uint 		= 4;
		
		public var currentSpriteType:uint;
		public var putPoint:Point;
		public var putSprite:Sprite;
		
		/**
		 * @constructor
		 * @param	parent
		 * @param	spriteTypeToUse
		 * @param	location
		 * @param	_putPoint
		 */
		public function CollectableItem(parent:Sprite, spriteTypeToUse:int, location:Point, _putPoint:Point) 
		{
			_spriteToUse = returnReqSprite(spriteTypeToUse);
			currentSpriteType = spriteTypeToUse;
			parent.addChild(_spriteToUse);
			
			putPoint = _putPoint;
			putSprite = createPutSprite(spriteTypeToUse);
			putSprite.x = putPoint.x * Lacuna.WIDTH + Lacuna.WIDTH / 2;
			putSprite.y = putPoint.y * Lacuna.HEIGHT + Lacuna.HEIGHT / 2;
			parent.addChild(putSprite);
			
			var collectableBody:b2Body = createBody(location, _spriteToUse.width, _spriteToUse.height);
			super(collectableBody, _spriteToUse, true);
		}
		
		/**
		 * @method createPutSprite
		 * @desc creates object where this collectable item has to be put
		 * @param	spriteTypeToUse
		 * @return Sprite
		 */
		private function createPutSprite(spriteTypeToUse:int):Sprite 
		{
			var spriteToUse:Sprite = new Sprite();
			if (spriteTypeToUse == PLANK)
			{
				//spriteToUse = new Plank();
				////trace("plank");
			}
			else if (spriteTypeToUse == BATTERY)
			{
				spriteToUse = new Socket();
				Socket(spriteToUse).sok_battery.visible = false;
			}
			else if (spriteTypeToUse == KEY)
			{
				spriteToUse = new Lock();
			}
			return spriteToUse;
		}
		
		/**
		 * @method createBody
		 * @desc creates Box2D body for the collectable
		 * @param	location
		 * @param	width
		 * @param	height
		 * @return b2Body
		 */
		private function createBody(location:Point, width:Number, height:Number):b2Body 
		{
			var collectableBodyDef:b2BodyDef = new b2BodyDef();
			collectableBodyDef.position.Set((location.x * Lacuna.WIDTH + width/2)/ PhysicsWorld.RATIO, (location.y * Lacuna.HEIGHT + height/2)/ PhysicsWorld.RATIO);
			
			var collectablePolygonDef:b2PolygonShape = new b2PolygonShape();
			collectablePolygonDef.SetAsBox(width / 2 / PhysicsWorld.RATIO, height / 2 / PhysicsWorld.RATIO);
			
			var collectableFixtureDef:b2FixtureDef = new b2FixtureDef();
			collectableFixtureDef.shape = collectablePolygonDef;
			collectableFixtureDef.isSensor = true;
			
			var collectableBody:b2Body = PhysicsWorld.world.CreateBody(collectableBodyDef);
			collectableBody.CreateFixture(collectableFixtureDef);
			
			return collectableBody;
		}
		
		/**
		 * @method returnReqSprite
		 * @desc createsSprite for this Collectable
		 * @param	spriteType
		 * @return
		 */
		public static function returnReqSprite(spriteType:uint):Sprite
		{
			var spriteToUse:Sprite = new Sprite();
			if (spriteType == PLANK)
			{
				spriteToUse = new Plank();
			}
			else if (spriteType == BATTERY)
			{
				spriteToUse = new Battery();
			}
			else if (spriteType == KEY)
			{
				spriteToUse = new Key();
			}
			return spriteToUse;
		}
		
	}

}