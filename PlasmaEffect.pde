public class PlasmaEffect implements Effect {

  // Center
  float xmid;  
  float ymid;
  
  // Upper left quad
  float xquad;
  float yquad;
  
  OPC opc;
  
  public PlasmaEffect(OPC opc) {
    // Init code here
    
    this.opc = opc; 
    
   xmid = width/2.0;
   ymid = height/2.0;
   
   xquad = width/4.0;
   yquad= height/4.0;
    
  }
  
  
  int  loop =0;
  
  void activate() {
    // Run when the effect is about to Activated
    
    colorMode( RGB , 255 );
    
    loop=0;
    
    opc.showLocations(false);    // Dont let the OPC code put white dots over our colors. 
    
  }
  
  float pdist( float a, float v,  float c, float d) {
    
    return(sqrt( ((float)a - c) * ( (float) a - c) + ( (float) v - d) * ( (float) v - d)));
    
  }
    
// Draw the full buffer    
    
  void fulldraw() {
    // run on each frame redraw

     colorMode( RGB , 256 );
     
     int pixelpos=0;
     
     loadPixels();
     
     for( int x=0; x<width; x++) {
        
         for(int y=0;y<height;y++) {
             
           float time = loop * 3 ;  
           
           float value =                
                 sin( pdist(x + time, y, xmid , ymid ) / 50.0) 
               + sin(pdist(x, y, xquad , yquad) / 120.0)
               + sin(pdist(x, y + time / 7, width * 0.75, height * 0.25) / 90.0)
               + sin(pdist(x, y, 40.0, 10.0) / 80.0);
             
           int c = (int) ((4.0 + value) * 32.0 * 3.0 );
           
           color rgb;

           
           if (c<256) {
             rgb=color(  255-c , c , 0);
           } else if (c<512) {
             rgb=color( 0 , 511-c , c-256 );
           } else {
             rgb=color( c-512 , 0 , (512+255) - c );
           }
           
/*
           
           if (c<256) {
             rgb=color(  255 , 0 , 0);
           } else if (c<512) {
             rgb=color( 0 , 255 , 0 );
           } else {
             rgb=color( 0 , 0 , 255 );
           }
  */         
           
           pixels[ pixelpos++ ] = rgb; 
           //point( x,y);
                                     
         }
     }  
     
     updatePixels();
     
     loop++;
     
     println(loop);
    
  }
  
// Draw only pixel locations that OPC looks at    
    
  void draw() {
    // run on each frame redraw

//     colorMode( RGB , 256 );
    
     float time = loop * 2 ;  
      
     int pixelLocations[] = opc.pixelLocations; 
     
     loadPixels();
     
     for( int l : pixelLocations) {
       
       int y = l/width;
       
       int x = l - (y*width);
              
       float value =                
             sin( pdist(x + time, y, xmid , ymid ) / 50.0) 
           + sin(pdist(x, y, xquad , yquad) / 120.0)
           + sin(pdist(x, y + time / 7, width * 0.75, height * 0.25) / 90.0)
           + sin(pdist(x, y, 40.0, 10.0) / 80.0);
         
       int c = (int) ((4.0 + value) * 32.0 * 3.0 );
       
       color rgb;
       
       if (c<256) {
         rgb=color(  255-c , c , 0);
       } else if (c<512) {
         rgb=color( 0 , 511-c , c-256 );
       } else {
         rgb=color( c-512 , 0 , (512+255) - c );
       }
       
           
       pixels[ l ] = rgb; 
     }
          
     updatePixels();
     
     loop++;
     
     println(loop);
    
  }  
  
  
}
  