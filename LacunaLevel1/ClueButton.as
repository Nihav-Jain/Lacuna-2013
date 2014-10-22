package  
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.display.BitmapData;
	import com.greensock.TweenLite;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	/**
	 * ...
	 * @author Nihav Jain
	 * @class ClueButton - handles the clue image, answer box and answer checking
	 */
	public class ClueButton extends RayCastObjects
	{
		private var cluesymbol:Sprite;
		public var imageContainer1:Sprite;
		private var ans:Sprite;
		private var firstTime:Boolean;
		private var quesNo:uint;
		private var currentLevel:uint;
		
		var variables:URLVariables;
		var request:URLRequest;
		
		var loader:URLLoader;
		var curclickon:uint;
		var clue:Clue;
		
		var charTable:Vector.<uint>;
		
		/**
		 * @constructor
		 * @param	parent
		 * @param	link
		 * @param	location
		 * @param	ques
		 * @param	curlvl
		 */
		public function ClueButton(parent:Sprite, link:String, location:Point, ques:uint, curlvl:int) 
		{
			cluesymbol = new ClueSymbol();
			cluesymbol.x = location.x * Lacuna.WIDTH + Lacuna.WIDTH / 2;
			cluesymbol.y = location.y * Lacuna.HEIGHT + Lacuna.HEIGHT / 2;
			
			parent.addChild(cluesymbol);
			
			firstTime = true;
			quesNo = ques;
			currentLevel = curlvl;
			ans = new answerbox();
			imageContainer1 = new Sprite();

			var ig:ImageLoader = new ImageLoader(link, { name:"quesimage", container:imageContainer1, centerRegistration: true, onComplete:scaleImage} );
			ig.load();
			
			
			clue = new Clue();
			clue.buttonMode = true;
			clue.mouseChildren = false;
			clue.x = Lacuna.STAGE.stageWidth / 2 - clue.width / 2;
			clue.y = Lacuna.STAGE.stageHeight - clue.height;
			clue.visible = false;
			
			variables = new URLVariables();
			request = new URLRequest("anscheck.txt");
			request.method = URLRequestMethod.POST;
			super(parent, new Point(location.x * Lacuna.WIDTH, location.y * Lacuna.HEIGHT), new Point((location.x + 1) * Lacuna.WIDTH, (location.y+1)*Lacuna.HEIGHT));
		}
		
		/**
		 * @method gotoShowQues
		 * @desc caller for method to display clue
		 * @param	e
		 */
		private function gotoShowQues(e:MouseEvent):void 
		{
			showQues();
			clue.visible = false;
			clue.removeEventListener(MouseEvent.CLICK, gotoShowQues);
		}
		
		/**
		 * @method scaleImage
		 * @desc scales image to fit stage size
		 * @param	ld
		 */
		private function scaleImage(ld:LoaderEvent):void 
		{
			if (imageContainer1.height > Lacuna.STAGE.stageHeight - 100)
			{
				imageContainer1.width = imageContainer1.width * (Lacuna.STAGE.stageHeight - 100) / imageContainer1.height;
				imageContainer1.height = Lacuna.STAGE.stageHeight - 100;
			}
			else if (imageContainer1.width > Lacuna.STAGE.stageWidth)
			{
				imageContainer1.height = imageContainer1.height * Lacuna.STAGE.stageWidth / imageContainer1.width;
				imageContainer1.width = Lacuna.STAGE.stageWidth;
			}
				ans.addChild(imageContainer1);
			imageContainer1.x = 0; Lacuna.STAGE.stageWidth / 2;
			imageContainer1.y = 0; Lacuna.STAGE.stageHeight / 2;
			
		}
		
		/**
		 * @method showQues
		 * @desc displays the clue image along with the answer box (in FLA)
		 */
		public function showQues():void
		{
			Lacuna.STAGE.addChild(ans);
			ans.x = Lacuna.STAGE.stageWidth / 2;
			ans.y = Lacuna.STAGE.stageHeight / 2;
			
			answerbox(ans).wrong.visible=false;
			answerbox(ans).correct.visible = false;
			answerbox(ans).loadingcirc.visible = false;
			answerbox(ans).close_btn.addEventListener(MouseEvent.CLICK, removeAns);
			answerbox(ans).submit.buttonMode = true;
			answerbox(ans).close_btn.buttonMode = true;
			answerbox(ans).submit.addEventListener(MouseEvent.CLICK, checkAns);
		}
		
		/**
		 * @method checkAns
		 * @desc click listener for "submit" button, initiates a POST request for checking the answer
		 * @param	e
		 */
		private function checkAns(e:MouseEvent):void 
		{
			variables.QNo=quesNo;
			variables.Ansgiven = answerbox(ans).ansbox.text;
			variables.curLevel=currentLevel;
			request.data=variables;
			loader=new URLLoader(request);
			loader.addEventListener(Event.COMPLETE, onAnschecked);
			loader.dataFormat=URLLoaderDataFormat.VARIABLES;
			loader.load(request);
			answerbox(ans).loadingcirc.visible = true;
			answerbox(ans).correct.visible = false;
			answerbox(ans).wrong.visible = false;
			answerbox(ans).loadingcirc.play();
		}
		
		/**
		 * @method removeAns
		 * @desc click listener for close button in the answer box
		 * @param	e
		 */
		private function removeAns(e:MouseEvent):void 
		{
			Lacuna.STAGE.removeChild(ans);
			answerbox(ans).close_btn.removeEventListener(MouseEvent.CLICK, removeAns);
			answerbox(ans).submit.removeEventListener(MouseEvent.CLICK, checkAns);
			Man(Lacuna.allDynaBodies[Lacuna.allDynaBodies.length - 1]).playMan();
			Man.lacunaInstance.playGame();
		}
		
		/**
		 * @method killAnime
		 * @desc called when Man intersects the RayCast
		 * @param	spriteType
		 * @param	pt
		 */
		override protected function killAnime(spriteType:uint, pt:b2Vec2):void 
		{
			if(firstTime)
			{
				firstTime = false;
				Man(Lacuna.allDynaBodies[Lacuna.allDynaBodies.length - 1]).pauseMan();
				Man.lacunaInstance.pauseGame();
				showQues();
			}
			else
			{
				if(clue.parent != Lacuna.STAGE)
				{
					Lacuna.STAGE.addChild(clue);
					
				}
				clue.visible = true;
				clue.addEventListener(MouseEvent.CLICK, gotoShowQues);
				TweenLite.delayedCall(6, removeClueBtn);
			}
			super.killAnime(spriteType, pt);
		}
		
		/**
		 * @method removeClueBtn
		 * @desc remvoe this clue's button from the level screen
		 */
		private function removeClueBtn():void 
		{
			if(clue.parent == Lacuna.STAGE)
				Lacuna.STAGE.removeChild(clue);
			clue.visible = false;
			clue.removeEventListener(MouseEvent.CLICK, gotoShowQues);
		}

		var picbmpds:Vector.<BitmapData>;	
		var anscorrect:Boolean;
		/**
		 * @method onAnschecked
		 * @desc callback for answer checking POST request
		 * @param	event
		 */
		function onAnschecked(event:Event) 
		{
			var returndata:URLVariables=new URLVariables(event.target.data);
			answerbox(ans).loadingcirc.visible = false;
			answerbox(ans).loadingcirc.stop();
			if (returndata.checkans == "true") 
			{
				answerbox(ans).correct.visible = true;
				Man.lacunaInstance.nocorrans[quesNo] = 1;
				anscorrect = true;
				Lacuna.allClues.splice(Lacuna.allClues.indexOf(this), 1);
				Man.lacunaInstance.removeChild(this.cluesymbol);// ((Lacuna.allDynaBodies[Lacuna.allDynaBodies.length - 1])
			} else 
			{
				answerbox(ans).wrong.visible = true;
				answerbox(ans).ansbox.addEventListener(TextEvent.TEXT_INPUT, hidewrong);
			}

		}
		
		/**
		 * @method hidewrong
		 * @desc hides the symbol for wrong answer when the user starts typing another answer
		 * @param	ev
		 */
		function hidewrong(ev:TextEvent):void {
			answerbox(ans).ansbox.removeEventListener(TextEvent.TEXT_INPUT, hidewrong);
			answerbox(ans).wrong.visible=false;
		}

	}

}