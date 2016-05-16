package;

import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import kha.Image;
import kha.Assets;
import kha.Scaler;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexStructure;
import kha.Shaders;

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
		
		var pipe = new PipelineState();
		pipe.blendDestination = BlendOne;
		pipe.blendSource = SourceAlpha;
		pipe.fragmentShader = Shaders.painter_image_frag;
		pipe.vertexShader = Shaders.painter_image_vert;
		var structure = new VertexStructure();
		pipe.inputLayout = [structure];
		pipe.compile();	

		backbuffer.g2.pipeline = pipe;
		backbuffer.g2.imageScaleQuality = High;
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
			g2.begin(true);
			var idx = pexEmitter.getShiftedIndex(0);
			for ( i in 0...pexEmitter.particleCount ) {
			g2.color = pexEmitter.getARGB(idx);
				var size = pexEmitter.getSize(idx);
				g2.drawScaledImage( particleTexture, pexEmitter.getX(idx)-0.5*size, pexEmitter.getY(idx)-0.5*size, size, size );
				idx = pexEmitter.incrementShiftedIndex(idx);
			}
			g2.end();
	
			framebuffer.g2.begin();
			Scaler.scale( backbuffer, framebuffer, System.screenRotation );
			framebuffer.g2.end();
		}
	}
}
