package;

import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import kha.Image;
import kha.Assets;
import kha.Scaler;

import pex.PexEmitter;
import pex.PexXmlLoader;

class Unknown {
	var pexEmitter: PexEmitter;
	var particleTexture: Image;	
	var backbuffer: Image;
	var inited = false;

	public function new() {
		System.notifyOnRender(render);
		Scheduler.addTimeTask(update, 0, 1 / 60);
		pexEmitter = PexXmlLoader.loadCompileTime( "../Resources/particle.pex" );
		Assets.loadEverything( init ); //loadImage( "particle", init );
		backbuffer = Image.createRenderTarget( 800, 600 );
	}

	public function init() {
		particleTexture = Assets.images.texture;
		inited = true;
		pexEmitter.start( Math.POSITIVE_INFINITY );
	}

	function update(): Void {
		pexEmitter.update( 1./60. );		
	}

	function render(framebuffer: Framebuffer): Void {		
		if ( inited ) {
			var g2 = backbuffer.g2;
			g2.begin();
			//trace(g2.pipeline);
			//g2.pipeline.blendSource = SourceAlpha;
			//g2.pipeline.blendDestination = BlendOne;
			var idx = pexEmitter.getShiftedIndex(0);
			for ( i in 0...pexEmitter.particleCount ) {
			//g2.setBlendingMode( SourceAlpha, BlendOne );
				g2.color = pexEmitter.getARGB(idx);
				//trace( pexEmitter.getRed(idx), pexEmitter.getGreen(idx), pexEmitter.getBlue(idx), pexEmitter.getAlpha(idx));
				var size = pexEmitter.getSize(idx);
			//	g2.pushOpacity( pexEmitter.getAlpha(idx));
				//g2.pushRotation( pexEmitter.getRotation(idx), size/2, size/2 );
				//g2.drawImage( particleTexture, 300+pexEmitter.getX(idx), 300+pexEmitter.getY(idx));
				//trace( pexEmitter.getX(idx), pexEmitter.getY(idx), size, size );
				g2.drawScaledImage( particleTexture, pexEmitter.getX(idx)-0.5*size, pexEmitter.getY(idx)-0.5*size, size, size );
				//g2.popTransformation();
				//g2.popOpacity();
				idx = pexEmitter.incrementShiftedIndex(idx);
			}
			g2.end();
	
			framebuffer.g2.begin();
			Scaler.scale( backbuffer, framebuffer, System.screenRotation );
			framebuffer.g2.end();
		}
	}
}
