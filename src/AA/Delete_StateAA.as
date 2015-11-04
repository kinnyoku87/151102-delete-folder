package AA
{
	import com.greensock.OverwriteManager;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Sine;
	
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import org.agony2d.Agony;
	import org.agony2d.display.AnimeAA;
	import org.agony2d.display.ButtonAA;
	import org.agony2d.display.DragFusionAA;
	import org.agony2d.display.FusionAA;
	import org.agony2d.display.ImageAA;
	import org.agony2d.display.StateAA;
	import org.agony2d.display.ViewportFusionAA;
	import org.agony2d.display.core.NodeAA;
	import org.agony2d.events.AEvent;
	import org.agony2d.events.ATouchEvent;
	import org.agony2d.input.Touch;
	import org.agony2d.utils.AColor;

	public class Delete_StateAA extends StateAA {
		
		override public function onEnter():void
		{
			var imgA:ImageAA;
			
			imgA = new ImageAA;
			imgA.textureId = "temp/bg2.png";
			this.getFusion().addNode(imgA);
			
			this.____doInitBottom();
			this.____doInitTop();
			
			OverwriteManager.mode = 1;
			
//			Agony.getTick().timeScale = 0.33;
			
			
			
//			Agony.getTick().getTickGroup(null).timeScale = 0.1;
		}
		
		override public function onExit() : void {
			TweenMax.killAll();
		}
		
		
		private const _topTweenTime_B:Number = 0.35;
		private const _garbageTime_A:Number = 0.2;
		private const _topTweenTime_O:Number = 0.45;
		private const g_dragDelayStartupTime:Number = 0.3;
		private const DRAG_OFFSET_Y:int = -70;
		private const PRESS_SCALE:Number = 0.9;
		private const _g_flyToGarbageTime:Number = 0.55;
		private const _pressIconScale:Number = 1.35;;
		private const _revertTime:Number = 0.55;
		private const _readyToDeleteTweenTime:Number = 0.3;
		private const _readyToDeleteTweenTime2:Number = 0.25;
		
		private const _toggleFolderTime:Number = 0.25;
		private const _delayCloseFolderTime:Number = 0.35;
		
		private const FLAG_O_A:int = 1; // O -> A
		private const FLAG_BACK_TO_O:int = 2; // A -> O
		private const FLAG_A_B:int = 3; // A -> B
		private const FLAG_B_A:int = 4; // B -> A
		private const FLAG_B_C:int = 5; // B -> C
		
		private var topStatus_offsetY_A:int;
		
		private var garbage_offsetY_O:int; // -190
		private var garbage_offsetY_A:int; // -50
		private var garbage_offsetY_B:int; // 0
		
		private var topBg_offsetY_O:int; // -topBg sourceHeight
		private var topBg_offsetY_A:int; // -topBg sourceHeight+110
		private var topBg_offsetY_B:int; // -topBg sourceHeight+190
		private var topBg_offsetY_C:int; // 0
		
		private var bottom_offsetY_A:int; // 0
		private var bottom_offsetY_B:int; // 
		private var bottom_offsetY_C:int; // 
		
		private var coordY_for_delete:int; // 270
		
		
		private var _topStatus:ImageAA;
		private var _garbageImg:AnimeAA;
		private var _topRay:ImageAA;
		private var _topFusion_bg:FusionAA; // 背景
		private var _topFusion_garbage:FusionAA; // garbage
		private var _bottomFusion:FusionAA;
		private var _pressIcon:DragFusionAA;
		private var _currTouch:Touch;
		private var _dragging:Boolean;
		private var _readyToWaste:Boolean;
		private var _desktopIconList:Array = [];
		
		
		private var _numIcons:int;
		private var _iconTextureList:Array = 
			[
				"browser",
				"calculator",
				"phone",
				"theme",
				"flashlight",
				"theme",
				"camera",
				"folder",
				
				"browser",
				"calculator",
				"phone",
				"theme",
				"flashlight",
				"theme",
				"camera",
				"folder",
				
				"browser",
				"calculator",
				"phone",
				"theme",
				"flashlight",
				"theme",
				"camera",
				"folder"
			]
		private var _folderIconTextureList:Array = 
			[
				"browser",
				"calculator",
				"phone",
				"theme",
				"flashlight",
				"theme",
				"camera"]
			
		
		private function ____doInitTop() : void {
			var imgA:ImageAA;
			
			// top status
			_topStatus = new ImageAA;
			_topStatus.textureId = "temp/topStatus.png";
			this.getFusion().addNode(_topStatus);
			topStatus_offsetY_A = -_topStatus.sourceHeight;
			
			// top bg
			_topFusion_bg = new FusionAA;
			this.getFusion().addNode(_topFusion_bg);
			
			imgA = new ImageAA;
			imgA.textureId = "temp/topBg_A.png";
			_topFusion_bg.addNode(imgA);
			
			//==================================================
			
			garbage_offsetY_O = -190;
			garbage_offsetY_A = -50; //imgA.sourceHeight;
			
			topBg_offsetY_O = - imgA.sourceHeight;
			topBg_offsetY_A = 140 - imgA.sourceHeight;
			topBg_offsetY_B = 190 - imgA.sourceHeight;
			
			bottom_offsetY_B = -garbage_offsetY_A + 25;
			bottom_offsetY_C = bottom_offsetY_B-topBg_offsetY_B;
			
			coordY_for_delete = 245;
			
			//==================================================
			
			// top garbage
			_topFusion_garbage = new FusionAA;
			this.getFusion().addNode(_topFusion_garbage);
			
			_topRay = new AnimeAA();
			_topRay.textureId = "temp/topRay.png";
			_topFusion_garbage.addNode(_topRay);
			
			_garbageImg = new AnimeAA();
			_garbageImg.textureId = "atlas/garbageA0";
			_garbageImg.pivotX = _garbageImg.sourceWidth / 2;
			_garbageImg.pivotY = _garbageImg.sourceHeight / 2;
			
			_garbageImg.x = this.getRoot().getAdapter().rootWidth / 2;
			_garbageImg.y = 190 - 65;
			_topFusion_garbage.addNode(_garbageImg);
			
			_topFusion_bg.y = topBg_offsetY_O;
			_topFusion_garbage.y = garbage_offsetY_O;
			
//			this.getRoot().getAdapter().getTouch().addEventListener(ATouchEvent.PRESS, function(e:ATouchEvent):void {
//				trace(e.touch.rootX, e.touch.rootY);
//			}, 10000);
			
		}
		
		private function ____doInitBottom() : void {
			var i:int;
			var l:int;
			var dragFusion:FusionAA;
			var img_A:ImageAA;
			
			_bottomFusion = new FusionAA;
			this.getFusion().addNode(_bottomFusion);
			
			// navigator
			img_A = new ImageAA;
			img_A.textureId = "temp/navigator.png";
			_bottomFusion.addNode(img_A);
			img_A.x = (this.getRoot().getAdapter().rootWidth - img_A.sourceWidth) / 2;
			img_A.y = 1580;
			
			
			_numIcons = _iconTextureList.length;
			while(i < _numIcons){
				dragFusion = _desktopIconList[i] = ____doCreateDragIcon(i, _iconTextureList, false);
				_bottomFusion.addNode(dragFusion);
				
				i++;
			}
		}
		
		////////////////////////////////////////////
		// Create
		////////////////////////////////////////////
		
		private function ____doCreateDragIcon( index:int, iconList:Array, fromFolder:Boolean ) : FusionAA {
			var dragFusion:DragFusionAA;
			var imgA:ImageAA;
			var iconName:String;
			var AY:Array;
			
			dragFusion = new DragFusionAA;
			dragFusion.touchMerged = true;
			dragFusion.userData = AY = [index];
			
			iconName = iconList[index];
			
			imgA = AAUtil.createScaleImg(iconName);
			dragFusion.addNode(imgA);
			
			imgA = AAUtil.createScaleImg(iconName + "_text");
			dragFusion.addNode(imgA);
			imgA.y = 110;
			
			this.____doLayoutIcon(dragFusion, index, fromFolder);
			AY[1] = dragFusion.x = cachePoint.x;
			AY[2] = dragFusion.y = cachePoint.y;
			AY[3] = fromFolder;
			AY[4] = index;
			
			// 文件夹
			if(iconName == "folder"){
				dragFusion.addEventListener(ATouchEvent.CLICK, onClickFolder);
			}
			else {
				dragFusion.addEventListener(ATouchEvent.PRESS, onPressIcon);
			}
			return dragFusion;
		}
		
		
		private const paddingW:int = 150;
		private var cachePoint:Point = new Point;
		private function ____doLayoutIcon( dragFusion:FusionAA, index:int, fromFolder:Boolean ) : void {
			var gapW:Number;
			
			if(fromFolder || index < _numIcons - 4) {
				gapW = (this.getRoot().getAdapter().rootWidth - paddingW * 2) / 3;
				cachePoint.x = (index % 4) * gapW + paddingW;
				cachePoint.y = int(index / 4) * 270 + 260;
			}
			// 最后四个
			else {
				gapW = (this.getRoot().getAdapter().rootWidth - paddingW * 2) / 3;
				cachePoint.x = (index % 4) * gapW + paddingW;
				cachePoint.y = 1750;
			}
			
		}
		
		
		
		
		
		
		////////////////////////////////////////////
		////////////////////////////////////////////
		////////////////////////////////////////////
		////////////////////////////////////////////
		// Event
		////////////////////////////////////////////
		////////////////////////////////////////////
		////////////////////////////////////////////
		////////////////////////////////////////////
		
		private function onUnbindingIcon(e:ATouchEvent) : void {
//			Agony.getLog().simplify("onUnbindingIcon");
			
			_pressIcon.removeEventListener(ATouchEvent.UNBINDING, onUnbindingIcon);
			
			// 图标
			(_pressIcon.getNodeAt(0) as ImageAA).color = null;
			
//			_pressIcon.scaleX = 1.0;
//			_pressIcon.scaleY = 1.0;
			TweenLite.killTweensOf(_pressIcon);
			
			TweenLite.to(_pressIcon, g_dragDelayStartupTime, {scaleX:1, scaleY:1, ease:Linear.easeNone});
			_pressIcon = null;
			_currTouch = null;
			
		}
		
		// 1. press
		private function onPressIcon(e:ATouchEvent):void {
//			Agony.getLog().simplify("onPressIcon");
			
			_currTouch = e.touch;
			_pressIcon = e.target as DragFusionAA;
			
			// 图标
			(_pressIcon.getNodeAt(0) as ImageAA).color = new AColor(0xAAAAAA);
			
			TweenLite.to(_pressIcon, g_dragDelayStartupTime, {scaleX:PRESS_SCALE, scaleY:PRESS_SCALE, onComplete:onStartDragIcon, ease:Cubic.easeOut});
			
			_pressIcon.addEventListener(ATouchEvent.UNBINDING, onUnbindingIcon);
		}
		
		private function onStartDragIcon() : void {
			var globalPoint_A:Point;
			
			
//			Agony.getLog().simplify("onStartDragIcon");
			
			_pressIcon.removeEventListener(ATouchEvent.UNBINDING, onUnbindingIcon);
			
//			if(_isFolder){
//				trace(_pressIcon.x ,_pressIcon.y);
//			}
			
			// 更换容器
			this.getFusion().addNode(_pressIcon);
			
			// 隐藏文本
			_pressIcon.getNodeAt(1).visible = false;
			
			if(_isFolder){
				globalPoint_A = _pressIcon.getBranch().localToGlobal(_pressIcon.x, _pressIcon.y);
				_pressIcon.x = globalPoint_A.x;
				_pressIcon.y = globalPoint_A.y;
			}
			
			// 图标
			(_pressIcon.getNodeAt(0) as ImageAA).color = null;
			
			_pressIcon.touchable = false;
			_dragging = true;
			
			TweenLite.to(_pressIcon, g_dragDelayStartupTime, {scaleX:_pressIconScale, scaleY:_pressIconScale, ease:Back.easeOut});
			
			_pressIcon.startDrag(_currTouch, null, 0, DRAG_OFFSET_Y, true);
			_currTouch.addEventListener(AEvent.CHANGE,   onMoveIcon);
			_currTouch.addEventListener(AEvent.COMPLETE, onReleaseIcon);
			_currTouch = null;
			
			
//			this.doTweenGarbage(FLAG_O_A);
			if(_pressIcon.y <= coordY_for_delete && !_isFolder) {
				_readyToWaste = true;
				this.doTweenGarbage(FLAG_A_B);
				
				this.doModifyIconTexture(_pressIcon, false);
			}
			else {//if(_pressIcon.y > coordY_for_delete) {
				_readyToWaste = false;
//				this.doTweenGarbage(FLAG_B_A);
				this.doTweenGarbage(FLAG_O_A);
				
				this.doModifyIconTexture(_pressIcon, true);
			}
			
//			else {
//				trace(_pressIcon.x ,_pressIcon.y);
//			}
			
			if(_isFolder){
				_folderFusion.addEventListener(ATouchEvent.LEAVING, onFolderLeaving);
				_folderFusion.addEventListener(ATouchEvent.HOVER,   onFolderHover);
			}
			
		}
		
		// 2. drag
		private function onMoveIcon(e:AEvent):void{
			var touch:Touch;
			
			touch = e.target as Touch;
			

			if(_pressIcon.y <= coordY_for_delete && !_readyToWaste) {
				_readyToWaste = true;
				this.doTweenGarbage(FLAG_A_B);
				
				this.doModifyIconTexture(_pressIcon, false);
				
				if(_delayCloseFolderId >= 0){
					clearTimeout(_delayCloseFolderId);
				}
				this.doCheckAndCloseFolder();
			}
			else if(_pressIcon.y > coordY_for_delete && _readyToWaste) {
				_readyToWaste = false;
				this.doTweenGarbage(FLAG_B_A);
				
				this.doModifyIconTexture(_pressIcon, true);
			}
//			else if(touch.getHoveringNode() == _alertBg && _isFolder){
//				this.doCheckAndCloseFolder();
//				this.doDelayCloseFolder();
//			}
		}
		
//		private function doDelayCloseFolder() : void {
//			setTimeout(function
//		}
		
		private var _delayCloseFolderId:int = -1;
		
		private function onFolderLeaving(e:ATouchEvent):void{
//			this.doCheckAndCloseFolder();
			this.doClearDelayAndCloseFolder();
		}
		
		private function doClearDelayAndCloseFolder() : void {
			_delayCloseFolderId = setTimeout(function():void{
				doCheckAndCloseFolder();
				_delayCloseFolderId = -1
			}, _delayCloseFolderTime * 1000);
		}
		
		private function onFolderHover(e:ATouchEvent):void{
			if(_delayCloseFolderId >= 0){
				clearTimeout(_delayCloseFolderId);
				_delayCloseFolderId = -1;
			}
		}
		
		// 3. release
		private function onReleaseIcon(e:AEvent) :void{
			var index:int;
			var touch:Touch;
			var controlX:Number;
			var controlY:Number;
			var rotation:Number;
			
			touch = e.target as Touch;
			
			if(_isFolder){
				_folderFusion.removeEventListener(ATouchEvent.LEAVING, onFolderLeaving);
				_folderFusion.removeEventListener(ATouchEvent.HOVER, onFolderHover);
			}
			
			if(_readyToWaste) {
				this.doTweenGarbage(FLAG_B_C);
//				doCastToGarbage();
				
				// 检查文件夹
				if(_isFolder){
					this.doCheckAndCloseFolder();
				}
			}
			// 恢复原状
			else {
				this.doRevertIcon(false);
				this.doTweenGarbage(FLAG_BACK_TO_O);
//				_garbageImg.getAnimation().start("atlas/garbageA", "garbage.close", 1);
				
			}
			
			_dragging = _readyToWaste = false;
			
		}
		
		private function doCastToGarbage() : void {
			var index:int;
			var touch:Touch;
			var controlX:Number;
			var controlY:Number;
			var rotation:Number;
			
			controlX = _garbageImg.x + (_pressIcon.x - _garbageImg.x) * 1 / 4;
			controlY = -150;
			rotation = _pressIcon.x - _garbageImg.x < 0 ? 540 : -540;
			
			this.getRoot().getAdapter().getTouch().touchEnabled = false;
			
//			trace(_garbageImg.y);
//			TweenLite.to(_pressIcon, _g_flyToGarbageTime, {alpha:0.2, ease:Linear.easeNone });
			TweenMax.to(_pressIcon,  _g_flyToGarbageTime, {alpha:0.3, scaleX:0.2, scaleY:0.2, rotation:rotation,
				bezier:[{x:controlX, y:controlY}, {x:_garbageImg.x, y:_garbageImg.y - 5}], 
				ease:Sine.easeOut, 
				onComplete:function():void{
					_pressIcon.kill();
					_pressIcon = null;
					
					_garbageImg.getAnimation().start("atlas/garbageA", "garbage.shake", 1, 
						function():void{
							TweenLite.to(_alertBg, _readyToDeleteTweenTime, {alpha:0, ease:Linear.easeOut, onComplete:function():void{
								_alertBg.kill();
							}})
							
							doTweenGarbage(FLAG_BACK_TO_O);
							
//							TweenLite.to(_bottomFusion, _topTweenTime_B, {alpha:1.0, ease:Linear.easeOut});
							TweenLite.to(_bottomFusion, _topTweenTime_B, {alpha:1.0, y:bottom_offsetY_A, ease:Cubic.easeOut});
							
							getRoot().getAdapter().getTouch().touchEnabled = true;
							
						});
					
				}});
		}
		
		private function doRevertIcon( forCancelToCast:Boolean ) : void {
			var index:int;
			var gapW:Number;
			var AY:Array;
			var fromFolder:Boolean;
			var localPoint_A:Point;
			
			AY = _pressIcon.userData as Array;
			fromFolder = AY[3];
			
			// 桌面状态
			if(!_isFolder){
			
				// 来自桌面的icon
				if(!fromFolder){
				
					_pressIcon.touchable = true;
					
					index = int(AY[0]);
					this.doModifyIconTexture(_pressIcon, true);
					
					// 更换容器
					_bottomFusion.addNode(_pressIcon);
					if(forCancelToCast){
						_pressIcon.y -= bottom_offsetY_C;
					}
					
					// 重现文本
					_pressIcon.getNodeAt(1).visible = true;
					
					TweenLite.to(_pressIcon, _revertTime, 
						{x:AY[1], 
						y:AY[2],
						scaleX:1.0,
						scaleY:1.0,
						ease:Cubic.easeOut});
					
					_pressIcon = null;
					
					
//					trace(1);
				}
				
				// 来自文件夹
				else {
					getFusion().touchable = false;
					
					index = _folderIndex;
					AY = _desktopIconList[_folderIndex].userData as Array;
					this.doModifyIconTexture(_pressIcon, true);
					
					// 更换容器
					_bottomFusion.addNode(_pressIcon);
					if(forCancelToCast){
						_pressIcon.y -= bottom_offsetY_C;
					}
					
					// 重现文本
					_pressIcon.getNodeAt(1).visible = true;
					
					TweenLite.to(_pressIcon, _revertTime, 
						{x:AY[1], 
							y:AY[2],
							alpha:0.8,
							scaleX:0.8,
							scaleY:0.8,
							ease:Cubic.easeOut, onComplete:function() : void {
								_pressIcon.kill();
								_pressIcon = null;
								getFusion().touchable = true;
							}});
					
					
//					trace(2);
				}
			}
			// 文件夹状态
			else {
				// 如果此时文件夹处于倒计时状态，则中断关闭文件夹
				if(_delayCloseFolderId >= 0){
					clearTimeout(_delayCloseFolderId);
					_delayCloseFolderId = -1;
					
					//this.doCheckAndCloseFolder();
				}
				
				_pressIcon.touchable = true;
				
				index = int(AY[0]);
				this.doModifyIconTexture(_pressIcon, true);
				
//				trace(_pressIcon.x, _pressIcon.y, _folderFusion.pivotY);
				
				localPoint_A = _folderFusion.globalToLocal(_pressIcon.x, _pressIcon.y);
				_pressIcon.x = localPoint_A.x;
				_pressIcon.y = localPoint_A.y + _folderFusion.pivotY;
				
//				trace(localPoint_A);
				
				// 更换容器
				_folderFusion.addNode(_pressIcon);
//				if(forCancelToCast){
//					_pressIcon.y -= bottom_offsetY_C;
//				}
				
				// 重现文本
				_pressIcon.getNodeAt(1).visible = true;
				
				TweenLite.to(_pressIcon, _revertTime, 
					{x:AY[1], 
						y:AY[2],
						scaleX:1.0,
						scaleY:1.0,
						ease:Cubic.easeOut});
				
				_pressIcon = null;
				
//				trace(3);
			}
		}
		
		private function doModifyIconTexture( dragFusion:DragFusionAA, normal:Boolean ) : void {
			var index:int;
			var imgA:ImageAA;
			var iconName:String;
			
			index = int(_pressIcon.userData[0]);
			imgA = dragFusion.getNodeAt(0) as ImageAA;
			iconName = normal ? _iconTextureList[index] : _iconTextureList[index] + "2";
			imgA.textureId = "temp/" + iconName + ".png";
		}
		
		////////////////////////////////////////////
		// Interaction
		////////////////////////////////////////////
		
		private var alertFusion:FusionAA;
		private var _alertBg:ImageAA;
		private var text_A:ImageAA;
		private var _btnDetermine:ButtonAA;
		private var _btnCancel:ButtonAA;
		private const BTN_GAP_X:int = 305;
		private const BTN_COORD_Y:int = 385;
		private var _garbageDelayID:int;
		
		private function doTweenGarbage( tweenFlag:int ) : void {
			var img_A:ImageAA;
			
			if(tweenFlag == FLAG_O_A){
				TweenLite.to(_topStatus,         _topTweenTime_B, {y:topStatus_offsetY_A, ease:Cubic.easeOut});
				TweenLite.to(_topFusion_bg,      _topTweenTime_B, {y:topBg_offsetY_A,     ease:Cubic.easeOut});
				TweenLite.to(_topFusion_garbage, _topTweenTime_B, {y:garbage_offsetY_A,   ease:Cubic.easeOut});
				
			}
			else if(tweenFlag == FLAG_BACK_TO_O){
				TweenLite.to(_topStatus,         _topTweenTime_O, {y:0,                 ease:Cubic.easeOut, delay:_topTweenTime_B});
				TweenLite.to(_topFusion_bg,      _topTweenTime_O, {y:topBg_offsetY_O,   ease:Cubic.easeOut});
				
//				TweenLite.to(_bottomFusion,      _topTweenTime_O, {alpha:1.0,           ease:Linear.easeOut});
				TweenLite.to(_bottomFusion,      _topTweenTime_O, {alpha:1.0, y:bottom_offsetY_A,  ease:Cubic.easeOut });
				TweenLite.to(_topFusion_garbage, _topTweenTime_O, {y:garbage_offsetY_O, ease:Cubic.easeOut});
				_garbageImg.getAnimation().start("atlas/garbageA", "garbage.close", 1);
				if(alertFusion){
					alertFusion.kill();
					alertFusion = null;
				}
			}
			else if(tweenFlag == FLAG_A_B){
//				Agony.getLog().simplify("FLAG_A_B");
				
				TweenLite.to(_topFusion_bg,      _topTweenTime_B, {y:topBg_offsetY_B,   ease:Cubic.easeOut});
				TweenLite.to(_bottomFusion,      _topTweenTime_B, {y:bottom_offsetY_B,  ease:Cubic.easeOut});
				TweenLite.to(_topFusion_garbage, _topTweenTime_B, {y:garbage_offsetY_B, ease:Cubic.easeOut})
				if(_garbageDelayID >= 0){
					clearTimeout(_garbageDelayID);
				}
				_garbageDelayID = setTimeout(function():void{
					_garbageImg.getAnimation().start("atlas/garbageA", "garbage.open", 1);
					_garbageDelayID = -1;
				}, _garbageTime_A * 1000);
			}
			else if(tweenFlag == FLAG_B_A){
//				Agony.getLog().simplify("FLAG_B_A");
				
				TweenLite.to(_topFusion_bg,      _topTweenTime_B, {y:topBg_offsetY_A,   ease:Cubic.easeOut});
				TweenLite.to(_bottomFusion,      _topTweenTime_B, {y:bottom_offsetY_A,  ease:Cubic.easeOut});
				TweenLite.to(_topFusion_garbage, _topTweenTime_B, {y:garbage_offsetY_A, ease:Cubic.easeOut});
				if(_garbageDelayID >= 0){
					clearTimeout(_garbageDelayID);
				}
				_garbageDelayID = setTimeout(function():void{
					_garbageImg.getAnimation().start("atlas/garbageA", "garbage.close", 1);
				}, _garbageTime_A * 1000);
			}
			else if(tweenFlag == FLAG_B_C){
				TweenLite.to(_topFusion_bg,      _readyToDeleteTweenTime, {y:topBg_offsetY_C,  ease:Cubic.easeOut, onComplete:onTopBg});
//				TweenLite.to(_bottomFusion,      _readyToDeleteTweenTime, {alpha:0.3,          ease:Linear.easeOut});
				TweenLite.to(_bottomFusion,      _readyToDeleteTweenTime, {alpha:0.3, y:bottom_offsetY_C, ease:Cubic.easeOut});
				TweenLite.to(_pressIcon,         _readyToDeleteTweenTime + _readyToDeleteTweenTime2, {x:215, y:265, scaleX:1.0, scaleY:1.0, ease:Cubic.easeOut});
				this.doModifyIconTexture(_pressIcon, true);
				
				function onTopBg() : void {
//					TweenLite.to(_bottomFusion,      _readyToDeleteTweenTime2, {alpha:0.3, ease:Linear.easeOut});
					
					// 遮挡层
					_alertBg = new ImageAA;
					_alertBg.textureId = "temp/alertBg.png";
					getFusion().addNodeAt(_alertBg, 2);
					TweenLite.from(_alertBg,         _readyToDeleteTweenTime2, {alpha:0, ease:Linear.easeOut, onComplete:function():void{
						alertFusion.touchable = true;
					}});
					alertFusion = new FusionAA;
					getFusion().addNode(alertFusion);
					alertFusion.touchable = false;
						
					TweenLite.from(alertFusion,     _readyToDeleteTweenTime2, {alpha:0, ease:Linear.easeOut});
					
					text_A = new ImageAA;
					text_A.textureId = "temp/text_A.png";
					text_A.x = (getRoot().getAdapter().rootWidth - text_A.sourceWidth) / 2 + 80;
					text_A.y = 210;
					alertFusion.addNode(text_A);
					
					_btnCancel = new ButtonAA;
					_btnCancel.skinId = "A";
					_btnCancel.pivotX = _btnCancel.getBackground().sourceWidth / 2;
					_btnCancel.x = BTN_GAP_X;
					_btnCancel.y = BTN_COORD_Y;
					alertFusion.addNode(_btnCancel);
					
					img_A = new ImageAA;
					img_A.textureId = "temp/text_cancel.png";
					_btnCancel.addNode(img_A);
					
					_btnDetermine = new ButtonAA;
					_btnDetermine.skinId = "A";
					_btnDetermine.pivotX = _btnDetermine.getBackground().sourceWidth / 2;
					_btnDetermine.x = getRoot().getAdapter().rootWidth - BTN_GAP_X;
					_btnDetermine.y = BTN_COORD_Y;
					alertFusion.addNode(_btnDetermine);
					
					img_A = new ImageAA;
					img_A.textureId = "temp/text_determine.png";
					_btnDetermine.addNode(img_A);
					
					_btnCancel.addEventListener(ATouchEvent.CLICK, onCancel);
					_btnDetermine.addEventListener(ATouchEvent.CLICK,  onDetermine);
				}
			}
		}
		
		private function onCancel(e:ATouchEvent):void{
//			TweenLite.to(_bottomFusion, _readyToDeleteTweenTime, {alpha:1.0,          ease:Linear.easeOut});
			TweenLite.to(_bottomFusion, _readyToDeleteTweenTime, {alpha:1.0, y:bottom_offsetY_A, ease:Cubic.easeOut});
			
			TweenLite.to(_alertBg, _readyToDeleteTweenTime, {alpha:0, ease:Linear.easeOut, onComplete:function():void{
				_alertBg.kill();
			}})
			
			alertFusion.touchable = false;
			
			this.doRevertIcon(true);
			this.doTweenGarbage(FLAG_BACK_TO_O);
//			_garbageImg.getAnimation().start("atlas/garbageA", "garbage.close", 1);
			
			
		}
		
		private function onDetermine(e:ATouchEvent):void{
//			_alertBg.kill();
			alertFusion.touchable = false;
			
			this.doCastToGarbage();
		}
		
		
		
		
		////////////////////////////////////////////
		// Folder
		////////////////////////////////////////////
		
		private var _folderFusion:ViewportFusionAA;
		private var _folderIndex:int; // 文件夹在桌面的index
		private var _isFolder:Boolean;
		private var _folderMask:ImageAA;
		private var folderBgImg:ImageAA;
		
		private function onClickFolder(e:ATouchEvent ) : void {
			
			var imgA:ImageAA;
			
//			if(_folderFusion){
//				TweenLite.killTweensOf(_folderFusion);
//				_folderFusion.kill();
//			}
			
			_isFolder = true;
			this.getFusion().touchable = false;
			_folderIndex = (e.target as NodeAA).userData[4];
			
			// 桌面降低alpha
			_bottomFusion.alpha = 0.3;
			
			// 遮挡层
			_folderMask = new ImageAA;
			_folderMask.textureId = "temp/folder_mask.png";
			getFusion().addNodeAt(_folderMask, 2);
			TweenLite.from(_folderMask,         _toggleFolderTime, {alpha:0, ease:Linear.easeOut});
			
			_folderMask.addEventListener(ATouchEvent.CLICK, onClickFolderAlertBg);
			
			_folderFusion = new ViewportFusionAA;
			this.getFusion().addNode(_folderFusion);
			
//			trace("create folder");
			
			// 文件夹内部背景img
			folderBgImg = new ImageAA;
			folderBgImg.textureId = "temp/folder_bg.png";
			_folderFusion.addNode(folderBgImg);
			
			imgA = new ImageAA;
			imgA.textureId = "temp/folder_title_text.png";
			_folderFusion.addNode(imgA);
			imgA.x = (this.getRoot().getAdapter().rootWidth - imgA.sourceWidth) / 2;
			imgA.y = 80;
			
			var i:int;
			var l:int;
			var dragFusion:FusionAA;
			var img_A:ImageAA;
			
			_numIcons = _folderIconTextureList.length;
			while(i < _numIcons){
				dragFusion = ____doCreateDragIcon(i, _folderIconTextureList, true);
				_folderFusion.addNode(dragFusion);
				
				i++;
			}
			
//			_folderFusion.pivotY = folderBgImg.sourceHeight / 2;
//			_folderFusion.y = this.getRoot().getAdapter().rootHeight / 2;
			_folderFusion.y = this.getRoot().getAdapter().rootHeight / 2 - folderBgImg.sourceHeight / 2;
			
//			TweenLite.from(_folderFusion, _toggleFolderTime, {scaleY:0.1, alpha:0.1, ease:Linear.easeOut });
			_folderFusion.viewportEnabled = true;
			_folderFusion.viewportY = folderBgImg.sourceHeight / 2;
			_folderFusion.viewportWidth = this.getRoot().getAdapter().rootWidth; 
//			_folderFusion.viewportHeight = folderBgImg.sourceHeight; 
			TweenLite.to(_folderFusion, _toggleFolderTime, {viewportY:0, viewportHeight:folderBgImg.sourceHeight, ease:Linear.easeOut, onComplete:function():void{
				getFusion().touchable = true;
				_folderFusion.viewportEnabled = false;
			}});
			//TweenLite.from(_folderFusion, _toggleFolderTime, {alpha:0.1, ease:Linear.easeOut });
		}
		
		private function onClickFolderAlertBg(e:ATouchEvent):void{
			this.doCheckAndCloseFolder();
		}
		
		private function doCheckAndCloseFolder():void{
			if(!_isFolder){
				return;
			}
			this.getFusion().touchable = false;
			_folderFusion.viewportEnabled = true;
			_isFolder = false;
			_bottomFusion.alpha = 1.0;
			TweenLite.to(_folderMask, _toggleFolderTime, {alpha:0.1, ease:Linear.easeOut, onComplete:function():void{
				_folderMask.kill();
				_folderMask = null;
				getFusion().touchable = true;
			}})
				
			
//			TweenLite.to(_folderFusion, _toggleFolderTime, {scaleY:0.1, alpha:0.1, ease:Linear.easeOut, onComplete:function():void{
//				_folderFusion.kill();
//				_folderFusion = null;
//			} });
//			TweenLite.to(_folderFusion, _toggleFolderTime - 0.01, {viewportY:folderBgImg.sourceHeight / 2, viewportHeight:1, ease:Linear.easeOut, onComplete:function():void{
			TweenLite.to(_folderFusion, _toggleFolderTime, {viewportY:folderBgImg.sourceHeight / 2, viewportHeight:1, ease:Linear.easeOut, onComplete:function():void{
				_folderFusion.kill();
				_folderFusion = null;
				
				
//				trace("discard folder");
			}});
//			_folderFusion.kill();
//			_folderFusion = null;
		}
	}
}