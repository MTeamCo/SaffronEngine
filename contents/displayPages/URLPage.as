package contents.displayPages
	//contents.displayPages.URLPage
{
	import contents.Contents;
	import contents.PageData;
	import contents.interFace.DisplayPageInterface;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import com.mteamapp.StringFunctions;
	
	public class URLPage extends MovieClip implements DisplayPageInterface
	{
		public static var sw:StageWebView = new StageWebView();
		protected var myPage:PageData;
		
		
		private var openInWeb:MovieClip ;
		
		private var shoOnlyWhenLoaded:Boolean ;
		
		private var isLoaded:Boolean = false ;
		
		private var myPreLoader:MovieClip ;
		
		public function URLPage(newPageSize:Rectangle=null,myPreloaderMC:MovieClip=null)
		{
			super();
			if(newPageSize)
			{
				this.graphics.clear();
				this.removeChildren();
				this.graphics.beginFill(0,0);
				this.graphics.drawRect(0,0,newPageSize.width,newPageSize.height);
			}
			else if(Contents.config.pageRect.width!=0)
			{
				this.graphics.clear();
				this.removeChildren();
				this.graphics.beginFill(0,0);
				this.graphics.drawRect(0,0,Contents.config.pageRect.width,Contents.config.pageRect.height);
			}
			if(myPreloaderMC)
			{
				myPreLoader = myPreloaderMC ;
				shoOnlyWhenLoaded = true ;
				myPreLoader.x = this.width/2;
				myPreLoader.y = this.height/2-myPreLoader.height/2;
				this.addChild(myPreLoader);
			}
			
			//this.visible = false ;
			openInWeb = Obj.get("open_mc",this);
			if(openInWeb)
			{
				openInWeb.addEventListener(MouseEvent.CLICK,openInWebBrowser);
				//this.visible = true;
			}
		}
		
		protected function openInWebBrowser(event:MouseEvent):void
		{
			
			navigateToURL(new URLRequest(myPage.content));
		}
		
		public function setUp(pageData:PageData):void
		{
			myPage = pageData ;
			controllStage();
		}
		
		private function controllStage(e:Event=null)
		{
			if(this.stage!=null)
			{
				createHTMLPage();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE,controllStage);
			}
		}
		
		private function createHTMLPage()
		{
			sw.stage = stage ;
			controllStagePlace();
			sw.addEventListener(Event.COMPLETE,pageLoaded);
			isLoaded = false ;
			if(myPreLoader)
			{
				myPreLoader.visible = true ;
			}
			if(StringFunctions.isNullOrEmpty(myPage.content)==false){
				trace("********** Open the page : "+myPage.content);
				sw.loadURL(myPage.content);
			}
			else if(StringFunctions.isNullOrEmpty(myPage.dynamicData as String)==false){
				trace("********** Open the page : "+myPage.dynamicData as String);
				sw.loadURL(myPage.dynamicData as String);
			}
			
			this.addEventListener(Event.REMOVED_FROM_STAGE,unLoad);
			this.addEventListener(Event.ENTER_FRAME,controllStagePlace);
		}
		
		protected function pageLoaded(event:Event):void
		{
			isLoaded = true ;
			if(myPreLoader)
			{
				myPreLoader.visible = false ;
			}
			trace("Page is loaded");
		}
		
		/**Unload this item from web*/
		protected function unLoad(event:Event):void
		{
			
			this.removeEventListener(Event.REMOVED_FROM_STAGE,unLoad);
			this.removeEventListener(Event.ENTER_FRAME,controllStagePlace);
			sw.stage = null ;
		}
		
		private function controllStagePlace(e:Event=null)
		{
			var rect:Rectangle = this.getBounds(stage);
			if(openInWeb)
			{
				var buttonRect:Rectangle = openInWeb.getBounds(stage);
				rect.bottom = buttonRect.top ;
			}
			sw.viewPort = rect;
			if(Obj.isAccesibleByMouse(this) && (!shoOnlyWhenLoaded || isLoaded))
			{
				sw.stage = (stage!=null)?stage:null ;
			}
			else
			{
				sw.stage = null ;
			}
		}
			
	}
}