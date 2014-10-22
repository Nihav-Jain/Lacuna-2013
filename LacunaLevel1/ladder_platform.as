package  
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.display.DisplayObjectContainer;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class ladder_platform extends Builder
	{
		
		public function ladder_platform(parent:DisplayObjectContainer, px:Number, py:Number, hei:Number, wid:Number, fric:Number)
		{
			var ld_platBody:b2Body = createBody(px, py, hei, wid, fric);
			var tvec:Point = new Point(px, py);
			var sp1:Sprite = createSprite(wid, hei, tvec);
			//var ladderSprite:Sprite = createSprite(wid, ht, loacation);
			
			parent.addChild(sp1);
			super(ld_platBody, sp1, false);
		}
		private function createSprite(wid:Number, ht:Number, loacation:Point):Sprite
		{
			var ladderSprite:Sprite = new LadderSprite(wid, ht);
			trace(ladderSprite);
			ladderSprite.x = loacation.x * Lacuna.WIDTH + ladderSprite.width/2;
			ladderSprite.y = loacation.y * Lacuna.HEIGHT + ladderSprite.height/2;
			trace("ladder platform sprite created @:"+String(ladderSprite.x)+String(ladderSprite.y));
			return ladderSprite;
		}
		
		private function createBody(px:Number, py:Number, hei:Number, wid:Number, fric:Number):b2Body 
		{
			var ld_platBodyDef:b2BodyDef = new b2BodyDef();
			var platformShape:b2PolygonShape = new b2PolygonShape();
			var platformFixtureDef:b2FixtureDef = new b2FixtureDef();
			
			ld_platBodyDef.position.Set(px * Lacuna.WIDTH / PhysicsWorld.RATIO, py * Lacuna.HEIGHT / PhysicsWorld.RATIO);
			ld_platBodyDef.type = b2Body.b2_kinematicBody;
			
			platformShape.SetAsBox((wid * Lacuna.WIDTH) / 2 / PhysicsWorld.RATIO, (hei * Lacuna.HEIGHT) / 2 / PhysicsWorld.RATIO);
			
			platformFixtureDef.friction = fric;
			platformFixtureDef.shape = platformShape;
			
			var ld_platformBody:b2Body = PhysicsWorld.world.CreateBody(ld_platBodyDef);
			ld_platformBody.CreateFixture(platformFixtureDef);
			
			trace("Its returning a"+ld_platformBody);
			return ld_platformBody;
		}
		override protected function childSpecificUpdating():void 
		{
			//_skin.x = _body.GetWorldCenter().x;
			//_skin.y = _body.GetWorldCenter().y;
			/*
			Lacuna.STAGE.addEventListener(KeyboardEvent.KEY_DOWN, movePlatform);
			Lacuna.STAGE.addEventListener(KeyboardEvent.KEY_UP, brakePlatform);
			*/
			trace(_skin.y);
			super.childSpecificUpdating();
			
		}
		
		public function brakePlatform():void 
		{
			
				_body.SetLinearVelocity (new b2Vec2(0, 0));
				trace("Brake applied");
				trace("Y:" + _skin.y);
			
		}
		public function getBody():b2Body {
			return _body;
		}
		
		public function movePlatform(dir:int):void 
		{
			//1 = UP and 2 = DOWN
			trace("Listener is working");
			if (dir == 1) {
				//_body.ApplyImpulse(new b2Vec2(0, 10), _body.GetWorldCenter());
				_body.SetLinearVelocity(new b2Vec2(0, -4));
				trace("Platform Going up");
			}
			else if (dir == 2) {
				//_body.ApplyImpulse(new b2Vec2(0, 10), _body.GetWorldCenter());
				_body.SetLinearVelocity (new b2Vec2(0, 4));
				trace("Platform Going down");
			}
		}
		public function removeListeners():void {
			Lacuna.STAGE.removeEventListener(KeyboardEvent.KEY_DOWN, movePlatform);
			Lacuna.STAGE.removeEventListener(KeyboardEvent.KEY_UP, brakePlatform);
		}
		
	}

}