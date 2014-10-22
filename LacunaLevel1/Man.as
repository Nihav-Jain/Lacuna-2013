package  
{
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.b2Collision;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Joints.b2PrismaticJoint;
	import Box2D.Dynamics.Joints.b2PrismaticJointDef;
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	/**
	 * ...
	 * @author Nihav Jain
	 * @class Man - class for user-controlled character
	 */
	public class Man extends Builder
	{	
		//movement related
		private var left:Boolean;
		private var right:Boolean;
		private var up:Boolean;
		private var down:Boolean;
		private var jump:Boolean;
		private var pickup:Boolean;
		private var jumpCounter:int;
		
		private var collection:Array;
		private var canCollect:b2Body;
		private var canJoin:b2Body;
		private var inventory:Inventory;
		private var buttonPushed:b2Body;
		public static var lacunaInstance:Lacuna;
		public static var antiGrav:Boolean;
		public var can_join:Boolean;
		public var prism_joint:b2PrismaticJoint;
		public var joint_made:Boolean;
		public var on_wall:Boolean;
		public var fine_adj:b2Vec2;
		private var tPressed:Boolean;
		private var p1Cont:Boolean;
		private var p2Cont:Boolean;
		public var pos_vec:b2Vec2;
		public var ladder_stairs:b2Body;
		public var Xtras:Array;
		public var flagw:Boolean;
		private var corPos:Boolean;
		private var throwFlag:Number;
		private var originX:Number;
		private var originY:Number;
		public static var batPut:Boolean;
		private var teleInContact:b2Body;
		public var restartGame:Function;
		public var gotoNewLevel:Function
		private var mapView:Boolean;
		private var toggle:int;
		private var dirFlag:Number;
		private var collectableWork:Boolean;
		private var sniperIsDead:Boolean;
		public var canExit:Boolean;
		private var pos:Array;
		
		/**
		 * @constructor
		 * @param	parent
		 * @param	lacuna
		 * @param	location
		 * @param	fric
		 * @param	resti
		 * @param	density
		 * @param	_inventory
		 */
		public function Man(parent:Sprite, lacuna:Sprite, location:Point, fric:Number, resti:Number, density:Number, _inventory:Inventory) 
		{
			throwFlag = 1;
			batPut = false;
			mapView = false;
			collectableWork = false;
			sniperIsDead = false;
			toggle = 0;
			dirFlag = 0;
			
			var manSprite:Sprite = new lacunaalien();
			manSprite.width = manSprite.width * Lacuna.HEIGHT / manSprite.height;
			manSprite.height = Lacuna.HEIGHT;
			parent.addChild(manSprite);
			manSprite.x = location.x * Lacuna.WIDTH + Lacuna.WIDTH / 2;
			manSprite.y = location.y * Lacuna.HEIGHT + Lacuna.HEIGHT / 2;
			
			can_join = false;
			joint_made = false;
			pos_vec = new b2Vec2();
			Xtras = new Array();
			flagw = true;
			canExit = false;
			var manBody:b2Body = createManBody(location, manSprite.width, manSprite.height, fric, resti, density);
			
			left = false;
			right = false;
			up = false;
			down = false;
			pickup = false;
			
			jump = false;
			jumpCounter = 0;
			
			Lacuna.STAGE.addEventListener(KeyboardEvent.KEY_DOWN, key_down);
			Lacuna.STAGE.addEventListener(KeyboardEvent.KEY_UP, key_up);
			
			collection = new Array();
			lacunaInstance = Lacuna(lacuna);
			
			inventory = _inventory;//new Inventory(parent, new Point(0, 620), 1200, 200);
			MovieClip(manSprite).gotoAndStop(22);
			
			var restbtn:RestartBtn = new RestartBtn();
			restbtn.buttonMode = true;
			restbtn.addEventListener(MouseEvent.CLICK, callRestart);
			restbtn.x = Lacuna.STAGE.stageWidth - restbtn.width;
			restbtn.y = Lacuna.STAGE.stageHeight - restbtn.height;
			Lacuna.STAGE.addChild(restbtn);
				
			antiGrav = false;
			pos = new Array();	
			
			variables = new URLVariables();
			request = new URLRequest("anscheck.php");
			request.method=URLRequestMethod.POST;
			super(manBody, manSprite, false);
			pos_vec = _body.GetWorldCenter();
		}
		
		/**
		 * @method key_up
		 * @desc KEY_UP event listener
		 * @param	e
		 */
		private function key_up(e:KeyboardEvent):void 
		{
			if (e.keyCode == 37)
			{
				left = false;
			}
			else if (e.keyCode == 38)
			{
				up = false;
				if (joint_made) {
					Xtras[0].brakePlatform();
				}
			}
			else if (e.keyCode == 39)
			{
				right = false;
			}
			else if (e.keyCode == 40)
			{
				down = false;
				if (joint_made) {
					Xtras[0].brakePlatform();
				}
			}
			else if (e.keyCode == 84 || e.keyCode == 116)	// 't' or 'T' pressed, for teleporting
			{
				tPressed = false;
			}
			else if (e.shiftKey)
			{
				pickup = false;
			}
			else if (e.keyCode == 77 || e.keyCode == 97)
			{
				toggle = (toggle + 1) % 2;
				if (toggle == 1)
				{
					Lacuna.STAGE.removeEventListener(KeyboardEvent.KEY_DOWN, key_down);
					Lacuna.STAGE.removeEventListener(KeyboardEvent.KEY_UP, key_up);
					mapView = true;
					lacunaInstance.viewMap(mapView, new Point(_skin.x, _skin.y));
				}
				else
				{
					lacunaInstance.viewMap(false, new Point(_skin.x, _skin.y));
				}				
			}
		}
		
		/**
		 * @method key_down
		 * @desc KEY_DOWN event listener
		 * @param	e
		 */
		private function key_down(e:KeyboardEvent):void 
		{
			if (e.keyCode == 37)
			{
				left = true;
			}
			else if (e.keyCode == 38)
			{				
				up = true;
			}
			else if (e.keyCode == 39)
			{
				right = true;
			}			
			else if (e.keyCode == 40)
			{
				down = true;
			}
			else if (e.keyCode == 84 || e.keyCode == 116)
			{
				tPressed = true;
			}
			else if (e.shiftKey)
			{
				//pickup = true;
			}
		}
		
		/**
		 * @method resetUpListener
		 * @desc resets the key_up event listener
		 */
		public function resetUpListener():void
		{
			if(!collectableWork)
				Lacuna.STAGE.addEventListener(KeyboardEvent.KEY_UP, key_up);
		}
		
		/**
		 * @method childSpecificUpdating
		 * @desc overrides the parent function to make special updates in GAME LOOP
		 */
		override protected function childSpecificUpdating():void 
		{	
			pos_vec = _body.GetWorldCenter();
			// for using wall as ladder (not used in level 1)
			if ((on_wall) && (flagw)) 
			{
				flagw = false;
				can_join = false;
				on_wall = false;
				Xtras[0] = (new ladder_platform(lacunaInstance,(pos_vec.x * PhysicsWorld.RATIO) / Lacuna.WIDTH, ((pos_vec.y * PhysicsWorld.RATIO) / Lacuna.HEIGHT)+1, 0.1, 1, 1));
				
				fine_adj = new b2Vec2(0, -8 / PhysicsWorld.RATIO);
				pos_vec.Add (fine_adj);
				_body.SetPosition (pos_vec);
				
				var prism_joint_def:b2PrismaticJointDef = new b2PrismaticJointDef();
				var temp_vec:b2Vec2;
				
				prism_joint_def.localAxisA.Set(0, 1);
				prism_joint_def.localAnchorB.Set( -0.25, 0.5) ;
				prism_joint_def.localAnchorA.Set(0,2);
				
				prism_joint_def.bodyB = Xtras[0].getBody();
				prism_joint_def.bodyA = canJoin;
				
				prism_joint_def.lowerTranslation = -5;
				prism_joint_def.upperTranslation = 5;
				prism_joint_def.enableLimit = true;
				
				prism_joint_def.maxMotorForce = 1000;
				prism_joint_def.motorSpeed = 10.0;
				prism_joint = new b2PrismaticJoint(prism_joint_def);
				
				joint_made = true;
				canJoin = null;
			}
			
			if (left)
			{	
				// not used in level 1
				if (joint_made) {
					prism_joint = null;
					PhysicsWorld.world.DestroyBody(Xtras[0].getBody());
					Xtras.pop();
					Xtras[0] = null;
					flagw = true;
					
					prism_joint = null;
					on_wall = false;
					joint_made = false;
					
					fine_adj = new b2Vec2(1.0, 0);
					pos_vec.Subtract(fine_adj);
					_body.SetPosition(pos_vec);
					
					_body.ApplyImpulse (new b2Vec2(-5, 0), _body.GetWorldCenter());
				}
				//not used in level 1
				if ((can_join) && (!joint_made)) {
					can_join = false;
					fine_adj = new b2Vec2(-2.0, 0);
					pos_vec.Add(fine_adj);
					_body.SetPosition(pos_vec);
				}
				
				_skin.rotationY = 180 - (180*dirFlag);
				
				_body.SetAwake(true);
				var newVel:b2Vec2 = new b2Vec2( -0.5, 0);
				if(_body.GetLinearVelocity().x > -5)
				{
					newVel.Add(_body.GetLinearVelocity());
					_body.SetLinearVelocity(newVel);
				}
			}
			if (right)
			{
				if (joint_made) {
					prism_joint = null;
					PhysicsWorld.world.DestroyBody(Xtras[0].getBody());
					Xtras.pop();
					Xtras[0] = null;
					flagw = true;
					
					prism_joint = null;
					on_wall = false;
					joint_made = false;
					
					fine_adj = new b2Vec2(1.0, 0);
					pos_vec.Add(fine_adj);
					_body.SetPosition(pos_vec);
					
					_body.ApplyImpulse (new b2Vec2(5, 0), _body.GetWorldCenter());
				}
				if ((can_join) && (!joint_made)) {
					can_join = false;
					fine_adj = new b2Vec2(2.0, 0);
					pos_vec.Add(fine_adj);
					_body.SetPosition(pos_vec);
				}
				_skin.rotationY = 0 + (180*dirFlag);
			
				_body.SetAwake(true);
				newVel = new b2Vec2( +0.5, 0);
				if(_body.GetLinearVelocity().x < 5)
				{
					newVel.Add(_body.GetLinearVelocity());
					_body.SetLinearVelocity(newVel);
				}
			
			}
			if (!antiGrav) {
				_skin.rotation = 0;
				dirFlag = 0;
			}
			if (antiGrav) {
				_skin.rotation = 180;
				dirFlag = 1;
			}
				pos.push(new Point(_skin.x, _skin.y));
			if (up)
			{
				if (can_join) {
					on_wall = true;
				}
				if (joint_made) {
					Xtras[0].movePlatform(1);
					on_wall = true;
				}
				else if (_body.GetLinearVelocity().y > -1)
				{
					GetBodyAtPoint(_skin.x, _skin.y + (_skin.height / 2 + 2), true);
					GetBodyAtPoint(_skin.x - (_skin.width / 2) + 2, _skin.y + (_skin.height / 2 + 2), true); 
					GetBodyAtPoint(_skin.x + (_skin.width / 2) - 2, _skin.y + (_skin.height / 2 + 2), true);
					
					if (jump)
					{
						_body.ApplyImpulse(new b2Vec2(0, -52.5), _body.GetWorldCenter());
					}					
				}
			}
			if (down)
			{
				if (joint_made) {
					Xtras[0].movePlatform(2);
					on_wall = true;
				}
				if (antiGrav) {
					GetBodyAtPoint(_skin.x, _skin.y - (_skin.height / 2 + 2), true);
					GetBodyAtPoint(_skin.x - (_skin.width / 2) + 2, _skin.y - (_skin.height / 2 + 2), true); 
					GetBodyAtPoint(_skin.x + (_skin.width / 2) - 2, _skin.y - (_skin.height / 2 + 2), true);
					
					if (jump)
					{
						_body.ApplyImpulse(new b2Vec2(0, 50), _body.GetWorldCenter());
					}
				}
			}
			if (_skin.x < 500) {
				originX = 500;
			}
			
			else if (_skin.x > 1500) {
				originX = 1500;
			}
			else {
				originX = _skin.x;
			}
			originX -= 500;
			if (_skin.y < 300) {
				originY = 300;
			}
			else if (_skin.y > 900) {
				originY = 900;
			}
			else {
				originY = _skin.y;
			}
			originY -= 300;
			// panning the level with the movement of Man
			if(!mapView)
				lacunaInstance.scrollRect = new Rectangle(originX,originY, Lacuna.STAGE.stageWidth, Lacuna.STAGE.stageHeight);
						
			if (pos.length >= 4 && int(Math.abs(pos[0].y - _skin.y)) > 0)
			{
				MovieClip(_skin).gotoAndStop(10);
			}
			else if (int(_body.GetLinearVelocity().x) != 0)
			{
				MovieClip(_skin).play();
			}
			else
			{
				MovieClip(_skin).gotoAndStop(22);
			}	
			if (pos.length >= 4)
				pos.splice(0, 1);
			if (true)
			{
				if (canCollect != null)
				{
					inventory.addToInventory(CollectableItem(canCollect.GetUserData()));
					CollectableItem(canCollect.GetUserData()).destroy();
				}
				else
				{
					pickup = false;
				}
			}
			
			if (buttonPushed != null)
			{
				PushButton(buttonPushed.GetUserData()).buttonisPushed();
				if (PushButton(buttonPushed.GetUserData()).eventType == "dropbox") 
				{
					var XtraPlatform:WallBuilder = new WallBuilder(Man.lacunaInstance, 2, 1, new Point(1, 7.5), 0.3, 0);
					var rockBuilder:FallingBlock = new FallingBlock();
					Lacuna.allDynaBodies.push(rockBuilder);
				}
				else if (PushButton(buttonPushed.GetUserData()).eventType == "firegun") 
				{
					pauseMan();
					mapView  = true;
					lacunaInstance.viewMap(true, new Point(_skin.x, _skin.y));
					collectableWork = true;
					//play the machine gun
					var gun1:machine_gun = new machine_gun();
					lacunaInstance.addChild(gun1);
					
					gun1.x = 15*Lacuna.WIDTH;
					gun1.y = 70;
						
					if (batPut == true) {
						if(!sniperIsDead)
							TweenLite.delayedCall(1, sniperDeathAnime);
						gun1.fire(7 * Lacuna.WIDTH, 2 * Lacuna.HEIGHT);
						//kill the sniper after 1 seconds
					}
					else {
						gun1.fire(8 * Lacuna.WIDTH, 2 * Lacuna.HEIGHT);
						//play the star animation of laser
					}
					TweenLite.delayedCall(3, resetCamera);
				}
				if(PushButton(buttonPushed.GetUserData()).actionrepeat == 1)
					TweenLite.delayedCall(5, createNewButton, [PushButton(buttonPushed.GetUserData()).btnLocation, PushButton(buttonPushed.GetUserData()).eventType]);
				PushButton(buttonPushed.GetUserData()).destroy();
				buttonPushed = null;
			}
			_body.SetAngle(0);
			
			if (p1Cont == true)// && p2Cont == true)
			{
				Lacuna.STAGE.removeEventListener(KeyboardEvent.KEY_DOWN, key_down);
				Lacuna.STAGE.removeEventListener(KeyboardEvent.KEY_UP, key_up);
				
				var teleportTo:b2Vec2 = new b2Vec2();
				teleportTo.Set(Teleporter(teleInContact.GetUserData()).pair.retLoc().x / PhysicsWorld.RATIO , Teleporter(teleInContact.GetUserData()).pair.retLoc().y / PhysicsWorld.RATIO);
				_body.SetPosition(teleportTo);
				
				p1Cont = false;
				p2Cont = false;
				
				Lacuna.STAGE.addEventListener(KeyboardEvent.KEY_DOWN, key_down);
				Lacuna.STAGE.addEventListener(KeyboardEvent.KEY_UP, key_up);				
			}
			
			if (teleInContact != null && tPressed == true)
			{
				PhysicsWorld.world.QueryPoint(callP1back, Teleporter(teleInContact.GetUserData()).retP1()); 
			}			
			super.childSpecificUpdating();
		}
		
		/**
		 * @method resetCamera
		 * @desc resets the camera back to position of Man
		 */
		private function resetCamera():void 
		{
			TweenLite.delayedCall(1, resetCollectableWork);
			lacunaInstance.viewMap(false, new Point(_skin.x, _skin.y));
		}
		
		/**
		 * @method resetCollectableWork
		 * @desc resets flags and adds event listeners for Man
		 */
		private function resetCollectableWork():void 
		{
			collectableWork = false;
			playMan();
		}
		
		/**
		 * @method createNewButton
		 * @desc creates push buttons
		 * @param	btnloc
		 * @param	evt
		 */
		private function createNewButton(btnloc:Point, evt:String):void 
		{
			var pbtn:PushButton = new PushButton(lacunaInstance, new PushButtonSprite(), btnloc, evt, 1);
		}
		/**
		 * @method callP1back
		 * @desc determines if Man is intersecting with teleportable area
		 * @param	fix
		 * @return boolean
		 */
		private function callP1back(fix:b2Fixture):Boolean
		{
			if (fix.GetBody().GetUserData() is Man)
			{
				p1Cont = true;
				return false;
			}
			return true;
		}
		
		/**
		 * @method spitOutItem
		 * @desc puts collected item from inventory into the level
		 * @param	itemType
		 */
		public function spitOutItem(itemType:CollectableItem):void
		{
			var aabb:b2AABB = new b2AABB();
			var px2 = (itemType.putPoint.x * Lacuna.WIDTH) / PhysicsWorld.RATIO;//_body.GetWorldCenter().x - (_skin.width/2);
			var py2 = (itemType.putPoint.y * Lacuna.HEIGHT) / PhysicsWorld.RATIO;//_body.GetWorldCenter().y - (_skin.height/2);
			
			aabb.lowerBound.Set(px2, py2);
			aabb.upperBound.Set(((px2*PhysicsWorld.RATIO) + Lacuna.WIDTH)/PhysicsWorld.RATIO, ((py2*PhysicsWorld.RATIO) + Lacuna.HEIGHT)/PhysicsWorld.RATIO);
			PhysicsWorld.world.QueryAABB(isRightPos, aabb);
			if (corPos) 
			{
				if (itemType.currentSpriteType == CollectableItem.BATTERY) 
				{
					//PUt off the lasers
					batPut = true;
					Socket(itemType.putSprite).sok_battery.visible = true;
					var i:int = 0;
					pauseMan();
					lacunaInstance.viewMap(true, new  Point(_skin.x, _skin.y));
					mapView = true;
					collectableWork = true;
					
					for (i = (Lacuna.allRayCasts.length - 1); i >= 0; i--) 
					{
						if (KillerRayCasts(Lacuna.allRayCasts[i]).currentType == KillerRayCasts.LASER) 
						{
							laser_container(Lacuna.allRayCasts[i].currentSprite).wipe();
							left = right = up = down = false;
							TweenLite.delayedCall (2, popLaser,[i]);
						}
					}
				}
				if (itemType.currentSpriteType == CollectableItem.KEY) 
				{
					//PUt off the camera
					TweenLite.to(itemType.putSprite, 1, { alpha: 0 } );
					for (i = (Lacuna.allRayCasts.length - 1); i >= 0; i--) 
					{
						if (KillerRayCasts(Lacuna.allRayCasts[i]).currentType == KillerRayCasts.CAMERA) 
						{
							left = right = up = down = false;
							popLaser(i);
						}						
					}
				}
			}
			else
			{
				if (!antiGrav)
				{
					if (_skin.rotationY == 180) {
						throwFlag = -1;
					}
					else {
						throwFlag = 1;
					}
				}
				else
				{
					if (_skin.rotationY == 180) {
						throwFlag = 1;
					}
					else {
						throwFlag = -1;
					}
				}
				var tempMan:Man = Lacuna.allDynaBodies.pop();
				var inventoryItem:CollectableItem = new CollectableItem(lacunaInstance, itemType.currentSpriteType, new Point((this._body.GetPosition().x * PhysicsWorld.RATIO + (throwFlag*itemType._spriteToUse.width/2))/Lacuna.WIDTH, (this._body.GetPosition().y * PhysicsWorld.RATIO + 40)/Lacuna.HEIGHT), itemType.putPoint);
				Lacuna.allDynaBodies.push(inventoryItem);
				Lacuna.allDynaBodies.push(tempMan);
				tempMan = null;
			}
		}
		
		/**
		 * @method popLaser
		 * @desc removes ray cast for given laser
		 * @param	i
		 */
		private function popLaser(i:uint):void 
		{
			Lacuna.allRayCasts.splice(i, 1);
			collectableWork = false;
			lacunaInstance.viewMap(false, new Point(_skin.x, _skin.y));
			Lacuna.STAGE.addEventListener(KeyboardEvent.KEY_DOWN, key_down);
			Lacuna.STAGE.addEventListener(KeyboardEvent.KEY_UP, key_up);
		}
		
		/**
		 * @method isRightPos
		 * @desc determines if man is intersecting with target area of collectable
		 * @param	fix
		 * @return boolean
		 */
		private function isRightPos(fix:b2Fixture):Boolean
		{
			if (fix.GetBody().GetUserData() is Man) {
				corPos = true;
			}
			return true;
		}
		
		/**
		 * @method GetBodyAtPoint
		 * @desc gets the bodies at given coordinated in the world
		 * @param	px
		 * @param	py
		 * @param	includeStatic
		 */
		public function GetBodyAtPoint(px:Number, py:Number, includeStatic:Boolean = false):void 
		{
			// Make a small box.
			var px2 = px/PhysicsWorld.RATIO;
			var py2 = py/PhysicsWorld.RATIO;
			var PointVec:b2Vec2 = new b2Vec2();
			PointVec.Set(px2, py2);
			var aabb:b2AABB = new b2AABB();
			aabb.lowerBound.Set(px2 - 0.001, py2 - 0.001);
			aabb.upperBound.Set(px2 + 0.001, py2 + 0.001);
			// Query the world for overlapping shapes.
			var k_maxCount:int = 10;
			var body:b2Body = null;
			var inside:Boolean;
			PhysicsWorld.world.QueryAABB(callback, aabb);
		}
		
		/**
		 * @method callback
		 * @desc callback for GetbodyAtPoint query
		 * @param	fix
		 * @return
		 */
		private function callback(fix:b2Fixture):Boolean
		{
			if((fix.GetBody().GetUserData() is Man))
			{
				jumpCounter++;
				if (jumpCounter == 2)
				{
					jumpCounter = 0;
					jump = false;
					return false;
				}
			}
			else
				jump = true;
			return true;
		}
		
		/**
		 * @method canCollectBody
		 * @desc assigns the given body as collectable
		 * @param	bd
		 */
		public function canCollectBody(bd:b2Body):void
		{
			canCollect = bd;
		}
		
		/**
		 * @method cannotCollectBody
		 * @desc Man cannot collect the current body in contact
		 */
		public function cannotCollectBody():void
		{
			canCollect = null;
		}
		
		/**
		 * @method getPushedButton
		 * @desc sets pushed button
		 * @param	bd
		 */
		public function getPushedButton(bd:b2Body):void
		{
			buttonPushed = bd;
		}
		
		/**
		 * @method inTeleContact
		 * @desc sets the teleporter in contact
		 * @param	bd
		 */
		public function inTeleContact(bd:b2Body):void
		{
			teleInContact = bd;
		}
		/**
		 * @method createJoint
		 * @desc sets the bodyon which joint can be made
		 * @param	bd
		 */
		public function createJoint(bd:b2Body):void
		{
			canJoin = bd;
			can_join = true;
		}
		
		/**
		 * @method createManBody
		 * @desc creates the Box2D body for Man
		 * @param	location
		 * @param	width
		 * @param	height
		 * @param	fric
		 * @param	resti
		 * @param	density
		 * @return	b2Body
		 */
		private function createManBody(location:Point, width:Number, height:Number, fric:Number, resti:Number, density:Number):b2Body
		{
			var manBodyDef:b2BodyDef = new b2BodyDef();
			manBodyDef.position.Set((location.x*Lacuna.WIDTH + Lacuna.WIDTH/2)/ PhysicsWorld.RATIO, (location.y*Lacuna.HEIGHT + Lacuna.HEIGHT/2) / PhysicsWorld.RATIO);
			manBodyDef.type = b2Body.b2_dynamicBody;
						
			var manShape:b2PolygonShape = new b2PolygonShape();
			manShape.SetAsBox(width / 2 / PhysicsWorld.RATIO, height / 2 / PhysicsWorld.RATIO);
			
			var manFixtureDef:b2FixtureDef = new b2FixtureDef();
			manFixtureDef.shape = manShape;
			manFixtureDef.friction = fric;
			manFixtureDef.restitution = resti;
			manFixtureDef.density = density;
			
			var manBody:b2Body = PhysicsWorld.world.CreateBody(manBodyDef);
			//manBody.SetBullet(true);
			manBody.CreateFixture(manFixtureDef);
			
			return manBody;
		}
		
		/**
		 * @method removeChildEventListeners
		 * @desc removes event listeners applied on this child i.e. Man
		 */
		override protected function removeChildEventListeners():void 
		{
			Lacuna.STAGE.removeEventListener(KeyboardEvent.KEY_DOWN, key_down);
			Lacuna.STAGE.removeEventListener(KeyboardEvent.KEY_UP, key_up);
			
			bloody();
			
			super.removeChildEventListeners();
		}
		
		/**
		 * @method bloody
		 * @desc blood spill animation when Man is killed (inspired by George R.R. Martin :P)
		 */
		private function bloody():void 
		{
			var bloodAnime:Main = new Main();
			lacunaInstance.addChild(bloodAnime);
			bloodAnime.x = _skin.x;
			bloodAnime.y = _skin.y;
			TweenLite.delayedCall(1, tryAgain);
		}
		
		/**
		 * @method pauseMan
		 * @desc pause man movement and interaction by removing event listeners for Man
		 */
		public function pauseMan():void
		{
			Lacuna.STAGE.removeEventListener(KeyboardEvent.KEY_DOWN, key_down);
			Lacuna.STAGE.removeEventListener(KeyboardEvent.KEY_UP, key_up);
			left = right = up = down = false;
			MovieClip(_skin).gotoAndStop(22);
		}
		
		/**
		 * @method playMan
		 * @desc initiated man movement and interaction listeners
		 */
		public function playMan():void
		{
			Lacuna.STAGE.addEventListener(KeyboardEvent.KEY_DOWN, key_down);
			Lacuna.STAGE.addEventListener(KeyboardEvent.KEY_UP, key_up);
			mapView = false;
			Lacuna.STAGE.focus = Lacuna.STAGE;
			//left = right = up = down = false;
		}
		
		/**
		 * @method electricShock
		 * @desc displays electric shock animation when Man hits lasers
		 */
		public function electricShock():void
		{
			var elec:Electrocution = new Electrocution();
			lacunaInstance.addChildAt(elec,3);
			MovieClip(_skin).gotoAndStop(22);
			_skin.visible = false;
			elec.x = _skin.x;
			elec.y = _skin.y;
			Man.lacunaInstance.pauseGame();
			lacunaInstance.pauseGame();
			TweenLite.delayedCall(3, tryAgain);
		}
		
		/**
		 * @method sirenblare
		 * @desc displays siren blare (red-blue lights) when Man is captured by locked camera
		 */
		public function sirenblare():void
		{
			var siren:CameraSiren = new CameraSiren(0.2, Lacuna.STAGE.stageWidth, Lacuna.STAGE.stageHeight);
			lacunaInstance.pauseGame();
			MovieClip(_skin).gotoAndStop(22);
			pauseMan();
			Lacuna.STAGE.addChild(siren);
			TweenLite.delayedCall(3, tryAgain);
		}
		
		/**
		 * @method tryAgain
		 * @desc pauses the game and displays the try again button
		 */
		private function tryAgain():void 
		{
			var darkrect:Sprite = new Sprite();
			darkrect.graphics.beginFill(0x000000, 0.5);
			darkrect.graphics.drawRect(0, 0, Lacuna.STAGE.stageWidth, Lacuna.STAGE.stageHeight);
			darkrect.graphics.endFill();
			
			Lacuna.STAGE.removeEventListener(KeyboardEvent.KEY_DOWN, key_down);
			Lacuna.STAGE.removeEventListener(KeyboardEvent.KEY_UP, key_up);
			lacunaInstance.pauseGame();
			Lacuna.STAGE.addChild(darkrect);
			var tryAgainBtn:Sprite = new TryAgain();
			tryAgainBtn.x = Lacuna.STAGE.stageWidth / 2;
			tryAgainBtn.y = Lacuna.STAGE.stageHeight / 2;
			Lacuna.STAGE.addChild(tryAgainBtn);
			tryAgainBtn.buttonMode = true;
			tryAgainBtn.addEventListener(MouseEvent.CLICK, callRestart);
		}
		
		/**
		 * @method callRestart
		 * @desc click listener for restart button
		 * @param	e
		 */
		private function callRestart(e:MouseEvent):void 
		{
			lacunaInstance.pauseGame();
			TweenLite.delayedCall(0, restartGame);
		}
		
		/**
		 * @method exit
		 * @desc checks if man can exit, if yes, takes him to next level
		 */
		public function exit():void
		{
			var i:int;
			for (i = 1; i <= 5; i++)
			{
				
				if (lacunaInstance.nocorrans[i] == 0)
					return;
			}
			if (i == 6)
			{
				variables = new URLVariables();
				request = new URLRequest("anscheck.php");
				request.method = URLRequestMethod.POST;
				checkAns();
			}			
		}
		var variables:URLVariables;
		var request:URLRequest;		
		var loader:URLLoader;
		/**
		 * @method checkAns
		 * @desc final request to backend for level completion
		 */
		private function checkAns():void 
		{
			variables.QNo=6;
			variables.Ansgiven = "nihavsoumy";
			variables.curLevel=lacunaInstance.curLevel;
			request.data=variables;
			loader=new URLLoader(request);
			loader.addEventListener(Event.COMPLETE, onAnschecked);
			loader.dataFormat=URLLoaderDataFormat.VARIABLES;
			loader.load(request);
		}
		
		/**
		 * @method onAnschecked
		 * @desc callback for POST request with answer
		 * @param	event
		 */
		function onAnschecked(event:Event) {
			var returndata:URLVariables=new URLVariables(event.target.data);		
			if (returndata.checkans=="true") {
				TweenLite.delayedCall(0, gotoNewLevel);
			}
		}

		/**
		 * @method killedBySniper
		 * @desc callback for sniper raycast
		 * @param	sniper
		 */
		public function killedBySniper(sniper:KillerRayCasts):void
		{
			pauseMan();
			lacunaInstance.viewMap(true, new  Point(_skin.x, _skin.y));
			lacunaInstance.pauseGame();
			mapView = true;
			collectableWork = true;			
			TweenLite.delayedCall(1, executeSniperAnime, [sniper]);
		}
		
		/**
		 * @method executeSniperAnime
		 * @desc executes animation of sniper
		 * @param	sniper
		 */
		private function executeSniperAnime(sniper:KillerRayCasts):void 
		{
			FullSniper(sniper.currentSprite).pointAt(_skin.x, _skin.y);
			TweenLite.to(_skin, 0.5, { alpha: 0, delay:1.5 } );
			TweenLite.delayedCall(1, bloody);			
		}
		
		/**
		 * @method sniperDeathAnime
		 * @desc displays sniper death animation
		 */
		private function sniperDeathAnime():void
		{
			var bloodAnime:Main = new Main();
			lacunaInstance.addChild(bloodAnime);
			sniperIsDead = true;
			for (var i:int = 0; i < Lacuna.allRayCasts.length; i++)
			{
				if ( KillerRayCasts(Lacuna.allRayCasts[i]).currentType == KillerRayCasts.SNIPER)
				{
					bloodAnime.x = KillerRayCasts(Lacuna.allRayCasts[i]).currentSprite.x;
					bloodAnime.y = KillerRayCasts(Lacuna.allRayCasts[i]).currentSprite.y;
					
					TweenLite.to(KillerRayCasts(Lacuna.allRayCasts[i]).currentSprite, 1.5, { alpha:0, scaleX:0, scaleY:0 } );
					Lacuna.allRayCasts.splice(i, 1);
				}
			}
				
		}
		
		/**
		 * @method killedByBuilder
		 * @desc executes specific animation when killed by children of Builder class
		 * @param	h
		 */
		public function killedByBuilder(h:uint):void
		{
			if (h == KillerBuilders.SPIKES)
			{
				
			}
			
			else if (h == KillerBuilders.FIRE)
			{
				pauseMan();
				lacunaInstance.pauseGame();
				MovieClip(_skin).gotoAndStop(23);
				TweenLite.delayedCall(1, tryAgain);
			}
		}
	}
}