package  
{
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import com.greensock.easing.Circ;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.XMLLoader;
	import com.greensock.plugins.ScrollRectPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	/**
	 * ...
	 * @author Nihav Jain
	 * @class Lacuna - main container Sprite for the level
	 */
	public class Lacuna extends Sprite
	{
		// XML related vars
		private var xmlLoader:XMLLoader; 
		private var xml:XML;
		
		// game elements
		public static var allDynaBodies:Array;
		public static var allRayCasts:Array;
		private var allAntiGravs:Array;
		private var allPushButtons:Array;
		public static var allKillerBodies:Array;
		private var teleporters:Array;
		public static var allClues:Array;
		
		// level helper functions, vars and constants
		public var cam:LevelCamera;
		public var restartGamefunc:Function;
		public var newlvl:Function;
		public static var STAGE:Stage;
		public static const WIDTH:Number = 80;
		public static const HEIGHT:Number = 80;
		public static var LEV_WIDTH:Number;
		public static var LEV_HEIGHT:Number;
		public var curLevel:int;
		
		// URL request vars
		public var nocorrans:Array;
		var request5:URLRequest;		
		var loader5:URLLoader;
		var phploaded:Boolean;

		/**
		 * @method oncurAnswrdgot
		 * @desc fired when php returns the status for all clues of the level, 0 for unanswered, 1 for answered
		 * @param	event
		 */
		function oncurAnswrdgot(event):void 
		{	
			var returndata:URLVariables=new URLVariables(event.target.data);
			var i:int;
			trace(returndata.curAnswrd);
			for(i=1;i<=5;i++){
				nocorrans[i] = Number(returndata.curAnswrd.charAt(i));	
			}
			if (phploaded)
			{
				var k:uint = 1;
				for each(var clue in xml.clues.clue)
				{
					curLevel = parseInt(clue.@level);
					if(nocorrans[k] == 0)
						allClues.push(new ClueButton(this, clue.@image, new Point(parseFloat(clue.@x), parseFloat(clue.@y)), k, parseInt(clue.@level)));
					k++;
				}
			}
			phploaded = true;
		}
		
		/**
		 * @constructor
		 * @param	level
		 * @param	bkgrd
		 * @param	res
		 * @param	lvl
		 */
		public function Lacuna(level:String, bkgrd:Sprite, res:Function, lvl:Function) 
		{
			phploaded = false;
			allDynaBodies = new Array();
			allKillerBodies = new Array();
			this.addChild(bkgrd);
			restartGamefunc = res;
			newlvl = lvl;
			TweenPlugin.activate([ScrollRectPlugin]);
			xmlLoader = new XMLLoader(level, { name: "mainxml", onComplete: xmlLoaded } );
			xmlLoader.load();
			
			nocorrans = new Array(0, 0, 0, 0, 0, 0);
			request5 = new URLRequest("curanswerd.txt")
			request5.method = URLRequestMethod.POST;
			loader5 = new URLLoader(request5);
			loader5.addEventListener(Event.COMPLETE, oncurAnswrdgot);
			loader5.dataFormat = URLLoaderDataFormat.VARIABLES;
		}
		
		/**
		 * @method xmlLoaded
		 * @desc called when XML containing level design is loaded, sets up the level
		 * @param	ev
		 */
		private function xmlLoaded(ev:LoaderEvent):void 
		{
			xml = new XML(LoaderMax.getContent("mainxml"));
			
			cam = new LevelCamera(1000, 600, parseFloat(xml.level.@width), parseFloat(xml.level.@height));
			LEV_WIDTH = parseFloat(xml.level.@width)*Lacuna.WIDTH;
			LEV_HEIGHT = parseFloat(xml.level.@height)*Lacuna.HEIGHT;
			this.addChild(cam);
			
			setupPhyWorld(parseFloat(xml.level.@width), parseFloat(xml.level.@height), parseFloat(xml.gravity.@X), parseFloat(xml.gravity.@Y));
			
			createBoundingWalls(parseFloat(xml.level.@width), parseFloat(xml.level.@height));
			
			var walls:Array = [];
			for each(var wall in xml.staticobjs.staticobj)
			{
				if (wall.@type == "wall")
				{
					walls.push(new Array(parseFloat(wall.@width), parseFloat(wall.@height), parseFloat(wall.@x), parseFloat(wall.@y), parseFloat(wall.@friction), parseFloat(wall.@restitution)));
				}
			}
			setupWalls(walls);
			
			teleporters = new Array();
			for each(var teleporter in xml.staticobjs.staticobj)
			{
				if (teleporter.@type == "teleporter")
				{
					teleporters.push(new Teleporter(this, new Point(parseFloat(teleporter.@x), parseFloat(teleporter.@y)), parseFloat(teleporter.@friction), parseFloat(teleporter.@restitution), parseInt(teleporter.@pairindex)));
				}
			}
			var i:int;
			
			for (i = 0; i < teleporters.length; i++)
			{
				teleporters[i].setPair(teleporters[teleporters[i].retPairIndex()]);
			}
			
			var movingPlatforms:Array = [];
			allRayCasts = new Array();
			allAntiGravs = new Array();
			allPushButtons = new Array();
			for each(var platform in xml.specobjs.specobj)
			{
				if (platform.@type == "movingplatform")
				{
					allDynaBodies.push(new MovingPlatform(this, parseFloat(platform.@width), parseFloat(platform.@height), parseFloat(platform.@constval), parseFloat(platform.@startval), parseFloat(platform.@endval), parseInt(platform.@horizontal), parseFloat(platform.@vel), parseFloat(platform.@friction)));	
				}
				else if (platform.@type == "raycast")
				{
					allRayCasts.push(new KillerRayCasts(this, parseInt(platform.@sprite), new Point(parseFloat(platform.@x), parseFloat(platform.@y)), new Point(parseFloat(platform.@startX), parseFloat(platform.@startY)), new Point(parseFloat(platform.@endX), parseFloat(platform.@endY))));
				}
				else if (platform.@type == "antigravity")
				{
					allAntiGravs.push(new AntiGravity(new Point(parseFloat(platform.@x), parseFloat(platform.@y)), parseFloat(platform.@width), parseFloat(platform.@height)));
				}
				else if (platform.@type == "collectable")
				{
					allDynaBodies.push(new CollectableItem(this, parseInt(platform.@sprite), new Point(parseFloat(platform.@x), parseFloat(platform.@y)), new Point(parseFloat(platform.@putX), parseFloat(platform.@putY))));
				}
				else if (platform.@type == "pushbutton")
				{
					var newButton:PushButton = new PushButton(this, new PushButtonSprite(), new Point(parseFloat(platform.@x), parseFloat(platform.@y)), platform.@event, parseInt(platform.@repeat));
					allPushButtons.push(newButton);
				}
				else if (platform.@type == "killer")
				{
					var newKiller:KillerBuilders = new KillerBuilders(this, parseInt(platform.@sprite), new Point(parseFloat(platform.@x), parseFloat(platform.@y)));
					allKillerBodies.push(newKiller);
				}
			}
			
			var levelExit:Exit = new Exit(this, new Point(parseFloat(xml.exit.@x), parseFloat(xml.exit.@y)));
			allClues = new Array();
			var k:uint = 1;
			if(phploaded)
			{
				for each(var clue in xml.clues.clue)
				{
					curLevel = parseInt(clue.@level);
					if(nocorrans[k] == 0)
						allClues.push(new ClueButton(this, clue.@image, new Point(parseFloat(clue.@x), parseFloat(clue.@y)), k, parseInt(clue.@level)));
					k++;
				}
			}
			phploaded = true;
			var LacunaMan:Man = new Man(this, this, new Point(parseFloat(xml.man.@x), parseFloat(xml.man.@y)), parseFloat(xml.man.@friction), parseFloat(xml.man.@restitution), parseFloat(xml.man.@density), new Inventory(cam, new Point(0, 7), 25, 1));//new Point(parseFloat(xml.man.@inventoryX), parseFloat(xml.man.@inventoryY)), parseFloat(xml.man.@width), parseFloat(xml.man.@height)));
			allDynaBodies.push(LacunaMan);
			LacunaMan.restartGame = restartGamefunc;
			LacunaMan.gotoNewLevel = newlvl;
			this.addEventListener(Event.ENTER_FRAME, updateWorld);
		}
		
		/**
		 * @method ok
		 * @desc scales the current sprite (2000x1200 px) to fit stage size (1000x600 px)
		 */
		public function ok()
		{
			this.scaleX = 1000 / 2000;
			this.scaleY = 600 / 1200;
		}
		
		/**
		 * @method buttonpushed
		 * @desc event listener for PushButtonEvent (not used in this level)
		 * @param	e
		 */
		private function buttonpushed(e:PushButtonEvent):void 
		{
			trace("inside listener");
			trace(PushButton(e.currentTarget).eventType);
		}
		
		/**
		 * @method updateWorld
		 * @desc listener for ENTER_FRAME event, acts as the GAME LOOP
		 * @param	e
		 */
		private function updateWorld(e:Event):void 
		{
				for each(var dynaBody:Builder in allDynaBodies)
				{
					dynaBody.updateNow();
				}
				for each(var killerBody:KillerBuilders in allKillerBodies)
				{
					killerBody.updateNow();	
				}
				for each(var rayCast:RayCastObjects in allRayCasts)
				{
					rayCast.createRayCast();
				}
				for each(var rayCast1:RayCastObjects in allClues)
				{
					rayCast1.createRayCast();
				}
				for each(var anti:AntiGravity in allAntiGravs)
				{
					anti.sendQuery();
				}
			PhysicsWorld.world.Step(1 / 30, 10, 10);
			PhysicsWorld.world.ClearForces();
			//PhysicsWorld.world.DrawDebugData();
		}
		
		/**
		 * @method createBoundingWalls
		 * @desc adds bounding walls to the level
		 * @param	parseFloat1 - width of level (in grid units)
		 * @param	parseFloat2 - height of level (in grid units)
		 */
		private function createBoundingWalls(parseFloat1:Number, parseFloat2:Number):void 
		{
			parseFloat1 *= Lacuna.WIDTH;
			parseFloat2 *= Lacuna.HEIGHT;

			//Roof
			var wall1bodydef:b2BodyDef = new b2BodyDef();
			wall1bodydef.position.Set(parseFloat1 / 2 / PhysicsWorld.RATIO, -10 / PhysicsWorld.RATIO);
			wall1bodydef.type = b2Body.b2_staticBody;
			
			var wallShape:b2PolygonShape = new b2PolygonShape();
			wallShape.SetAsBox(parseFloat1 / 2 / PhysicsWorld.RATIO, 5 / PhysicsWorld.RATIO);
			
			var fix:b2FixtureDef = new b2FixtureDef();
			fix.shape = wallShape;
			
			var wallBody1:b2Body = PhysicsWorld.world.CreateBody(wall1bodydef);
			wallBody1.CreateFixture(fix);
			
			//Below Ground
			wall1bodydef.position.Set(parseFloat1 / 2 / PhysicsWorld.RATIO, (parseFloat2 + 10) / PhysicsWorld.RATIO);
			var wallBody2:b2Body = PhysicsWorld.world.CreateBody(wall1bodydef);
			wallBody2.CreateFixture(fix);
			
			wallShape.SetAsBox(5 / PhysicsWorld.RATIO, parseFloat2 / 2 / PhysicsWorld.RATIO);
			
			// left wall
			wall1bodydef.position.Set( -10 / PhysicsWorld.RATIO, parseFloat2 / 2 / PhysicsWorld.RATIO);
			fix.shape = wallShape;
			var wall3:b2Body = PhysicsWorld.world.CreateBody(wall1bodydef);
			wall3.CreateFixture(fix);
			// right wall
			wall1bodydef.position.Set((parseFloat1 / PhysicsWorld.RATIO + 5 / PhysicsWorld.RATIO), parseFloat2 / 2 / PhysicsWorld.RATIO);
			var wall4:b2Body = PhysicsWorld.world.CreateBody(wall1bodydef);
			wall4.CreateFixture(fix);
		}
		
		/**
		 * @method setupWalls
		 * @desc creates walls for the level as described in the XML
		 * @param	walls
		 */
		private function setupWalls(walls:Array):void 
		{
			for each(var newWallDef:Array in walls)
			{
				var newWall:WallBuilder = new WallBuilder(this, newWallDef[0], newWallDef[1], new Point(newWallDef[2], newWallDef[3]), newWallDef[4], newWallDef[5]);
			}
		}
		
		/**
		 * @method setupPhyWorld
		 * @desc sets up the parameters of the world
		 * @param	wid
		 * @param	ht
		 * @param	gravX
		 * @param	gravY
		 */
		private function setupPhyWorld(wid:Number, ht:Number, gravX:Number, gravY:Number):void 
		{	
			var gravity:b2Vec2 = new b2Vec2(gravX, gravY);
			PhysicsWorld.world = new b2World(gravity, true);
			PhysicsWorld.world.SetContactListener(new LacunaContactListener());
			STAGE = this.stage;
			Lacuna.STAGE.focus = Lacuna.STAGE;
			// only for debugging
			var debug_draw:b2DebugDraw = new b2DebugDraw();
			var debug_sprite:Sprite = new Sprite();
			this.addChild(debug_sprite);
			debug_draw.SetSprite(debug_sprite);
			debug_draw.SetDrawScale(PhysicsWorld.RATIO);
			debug_draw.SetFlags(b2DebugDraw.e_shapeBit);
			debug_draw.SetLineThickness(1);
			debug_draw.SetAlpha(0.8);
			debug_draw.SetFillAlpha(0.3);
			PhysicsWorld.world.SetDebugDraw(debug_draw);
		}
		
		/**
		 * @method pauseGame
		 * @desc pauses the game by reving calls to GAME LOOP
		 */
		public function pauseGame():void
		{
			this.removeEventListener(Event.ENTER_FRAME, updateWorld);
		}
		
		/**
		 * @method playGame
		 * @desc starts the game by adding listener for GAME LOOP
		 */
		public function playGame():void
		{
			this.addEventListener(Event.ENTER_FRAME, updateWorld);
		}
		
		/**
		 * @method viewMap
		 * @desc scales level to display full level map, or pans to the character position depending on mapview param
		 * @param	mapview
		 * @param	pt
		 */
		public function viewMap(mapview:Boolean, pt:Point):void
		{
			if (mapview)
			{
				TweenLite.to(this, 1, { scaleX: STAGE.stageWidth / LEV_WIDTH, scaleY:STAGE.stageHeight / LEV_HEIGHT, ease: Circ.easeOut, onComplete: setKeyListener, scrollRect:{x:0, y:0, width:2000, height:1200} } );//TweenLite.to(this, 1, { scrollRect: {x:0, y:0, width: 2000, height: 1200 }} );//
			}
			else
			{
				var originX:Number = 0;
				var originY:Number = 0;
				if (pt.x < 500) {
					originX = 500;
				}
				else if (pt.x > 1500) {
					originX = 1500;
				}
				else {
					originX = pt.x;
				}
				originX -= 500;
				if (pt.y < 300) {
					originY = 300;
				}
				else if (pt.y > 900) {
					originY = 900;
				}
				else {
					originY = pt.y;
				}
				originY -= 300;
				TweenLite.to(this, 1, { scaleX:1, scaleY:1, scrollRect: { x: originX, y:originY, width: STAGE.stageWidth, height: STAGE.stageHeight}, ease: Circ.easeOut, onComplete: resetManListeners} );//TweenLite.to(this, 1, { scaleX: 1, scaleY:1, x:pt.x - STAGE.stageWidth/2, y:pt.y-STAGE.stageHeight/2, ease: Circ.easeOut, onComplete: resetManListeners } );
			}
		}
		
		/**
		 * @method resetManListeners
		 * @desc adds KEY EVENT listeners to Man
		 */
		private function resetManListeners():void 
		{
			Man(allDynaBodies[allDynaBodies.length - 1]).playMan();
		}
		/**
		 * @method setKeyListener
		 * @desc adds KEY_UP event listener to Man
		 */
		private function setKeyListener():void 
		{
			Man(allDynaBodies[allDynaBodies.length - 1]).resetUpListener();//this.addEventListener(KeyboardEvent.KEY_UP, goback);
		}
		
		private function goback(e:KeyboardEvent):void 
		{
			//viewMap(false, 
		}
		
		private function debug_draw():void {
			
		}
	}

}