#!/usr/bin/perl
# Copyright (C) 2010 Laszlo Simon <laszlo.simon@gmail.com>
# This file is part of the HidraVFX project.
(
basic => {
 mapeffects => {
  'none' => {        desc => 'Do nothing (for debug purpose)',
                     calc => 'tar = src;'},
  
  'invert' => {      desc => 'Invert.',
                     calc => 'tar = 1.0 - src;'},
  
  'geoinvert' => {   desc => 'Multiplicative invert.',
                     calc => 'tar = 0.1/src;'},
  
  'pitinvert' => {   desc => 'Invert with Pythagorean theorem.',
                     calc => 'tar = sqrt(1.0 - src*src);'},
  
  'upshift' => {     desc => 'Increase with <shift>.', 
                     calc => 'tar = src + shift; tar = tar - (int)tar;',
                     prms => {'shift'  => { def => 0.25 }}}, 
  
  'noise'  => {      desc => 'Add noise.', 
                     calc => 'double r = rand()/(double)RAND_MAX;
                              r = r > (1-src) ? src+(1-src)*(r-(1-src))/src :
                                  r < (1-src) ? src*r/(1-src) : 0;
                              tar = factor*r + (1-factor)*src;',
                     prms => {'factor'  => { def => 0.25 }}}, 
                       
  'bright' => {      desc => 'Additional bright with <bright>.', 
                     calc => 'tar = src + bright;',
                     prms => {'bright' => { def => 0.25 }}},
  
  'contrast' => {    desc => 'Multiplicative contrast.', 
                     calc => 'tar = (src - 0.5) * gain + 0.5;',
                     prms => {'gain'   => { def => 0.25 }}},
                     
  'relativecontrast'=>{desc => 'Multiplicative contrast relative to specified map.', 
                     calc => 'tar = (src - ref) * gain + ref;',
                     prms => {'gain'   => { def => 0.25 },
                              'ref'    => { def => 0.5,  test => "addimg.pfm" } }},
                     
  'mappedcontrast'=>{desc => 'Contrast between the specified maps or values.', 
                     calc => 'tar = (src-min)/(max-min);',
                     prms => {'min'    => { def => 0.25 },
                              'max'    => { def => 0.75  } }},
        
  'autocontrast' =>{ desc => 'Automatic contrast to the available range by channels.', 
                     init => 'tLayerStats s; stats(srcimg, &s);',
                     calc => 'tar = (src-s.min[ch])/(s.max[ch]-s.min[ch]);' },
                             
  'bright2' => {     desc => 'Multiplicative bright', 
                     calc => 'tar = (bright < 0) ? src*(1.0+bright) : src+(1.0-src)*bright;',
                     prms => {'bright' => { def => 0.25 }}},
  
  'gammacorrect' =>{ desc => 'Gamma correction', 
                     calc => 'tar = pow(src, gamma);',
                     prms => {'gamma' => { def => 2.0 }}},
    
  'stone' => {       desc => 'Special map for stone texture', 
                     calc => 'tar = 1.0 - pow(1.0-src, power);',
                     prms => {'power'  => { def => 2 }}},

  'cloud' => {       desc => 'Special map for cloud texture', 
                     calc => 'tar = src<=limit ? 0 : log(xmax*(src-limit)/(1.0-limit)+1)/log(xmax+1);',
                     prms => {'limit'  => { def => 0.25 }, 
                              'xmax'   => { def => 2 }}},
                              
  'blend' =>       { desc => 'Blends two image with linear interpolation.',
                     calc => 'double alp = alpha * add[3];
                              tar    = src*(1-alp)+add*alp;',
                     prms => {'alpha' => { def  => 0.5 },
                              'add'   => { test => "addimg.pfm" } }},
                              
  'cubic' =>       { desc => 'Blends two image with polinomial (Ax^6+Bx^4+Cx^2) interpolation.',
                     calc => 'double alp = -(4/9)*pow(alpha,6)+(17/9)*pow(alpha,4)-(22/9)*sqr(alpha)+1;
                              tar = src*alp+add*(1-alp);',
                     prms => {'alpha' => { def  => 0.5 },
                              'add'   => { test => "addimg.pfm" } }},
                                   
  'binary' =>      { desc => 'Cut to binary values based on threshold.',
                     calc => 'tar = src < threshold ? 0.0 : 1.0;',
                     prms => {'threshold' => { def  => 0.5 } }},
                     
  'mint' =>        { desc => 'Cut to binary values based on threshold and gamma.',
                     init => 'tLayerStats stat; stats(srcimg, &stat);',
                     calc => 'double val = stat.max[ch] * pow(src/stat.max[ch],gamma);
                              tar = (val > threshold) ? stat.max[ch] : 0.0;',
                     prms => {'threshold' => { def  => 0.5 },
                     	      'gamma'     => { def  => 2.0 } }},
                     	      
  'level' =>       { desc => 'Cut to color levels.',
                     init => 'tLayerStats s; stats(srcimg, &s);',
                     calc => 'int cnt = (level * (src - s.min[ch]) / (s.max[ch] - s.min[ch]));
                              tar =  s.min[ch] + cnt * (s.max[ch] - s.min[ch]) / level;',
                     prms => {'level' => { def  => 10 } }},
 },
 convolutions => {
 	
  'minifinger' =>  { desc => 'Minifinger convolution filter.',
                     calc => 'tar = convolution(srcimg, ix, iy, ch, cmminifinger, 3, 3);'},
  'ledge' =>       { desc => 'Light edge convolution filter.',
                     calc => 'tar = convolution(srcimg, ix, iy, ch, cmledge, 3, 3);'},
  'medge' =>       { desc => 'Middle edge convolution filter.',
                     calc => 'tar = convolution(srcimg, ix, iy, ch, cmmedge, 3, 3);'},
  'hedge' =>       { desc => 'Hard edge convolution filter.',
                     calc => 'tar = convolution(srcimg, ix, iy, ch, cmhedge, 3, 3);'},
  'horprewitt' =>  { desc => 'Horisontal prewitt convolution filter.',
                     calc => 'tar = convolution(srcimg, ix, iy, ch, cmhorprewitt, 3, 3);'},
  'verprewitt' =>  { desc => 'Vertical prewitt convolution filter.',
                     calc => 'tar = convolution(srcimg, ix, iy, ch, cmverprewitt, 3, 3);'},
  'horsobel' =>    { desc => 'Horisontal sobel convolution filter.',
                     calc => 'tar = convolution(srcimg, ix, iy, ch, cmhorsobel, 3, 3);'},
  'versobel' =>    { desc => 'Vertical sobel convolution filter.',
                     calc => 'tar = convolution(srcimg, ix, iy, ch, cmversobel, 3, 3);'},
  'gauss' =>       { desc => 'Gauss convolution filter.',
                     calc => 'tar = convolution(srcimg, ix, iy, ch, cmgauss, 3, 3);'},
  'enhancededge'=> { desc => 'Enhanced edge convolution filter.',
                     calc => 'tar = convolution(srcimg, ix, iy, ch, cmenhancededge, 3, 3);'},
  'endy' =>        { desc => 'Endy convolution filter.',
                     calc => 'tar = convolution(srcimg, ix, iy, ch, cmendy, 3, 3);'},
  'enhancedfocus'=>{ desc => 'Enhanced focus convolution filter.',
                     calc => 'tar = convolution(srcimg, ix, iy, ch, cmenhancedfocus, 3, 3);'},
  'sharpen' =>     { desc => 'Sharpen convolution filter.',
                     calc => 'tar = convolution(srcimg, ix, iy, ch, cmsharpen, 3, 3);'},
  'emboss1' =>     { desc => 'Emboss1 convolution filter.',
                     calc => 'tar = convolution(srcimg, ix, iy, ch, cmemboss1, 3, 3);'},
  'emboss2' =>     { desc => 'Emboss2 convolution filter.',
                     calc => 'tar = convolution(srcimg, ix, iy, ch, cmemboss2, 3, 3);'},
  'lsoften' =>     { desc => 'Light Soften convolution filter.',
                     calc => 'tar = convolution(srcimg, ix, iy, ch, cmlsoften, 3, 3);'},
  'hsoften' =>     { desc => 'Hard Soften convolution filter.',
                     calc => 'tar = convolution(srcimg, ix, iy, ch, cmhsoften, 3, 3);'},
  'lblur' =>       { desc => 'Light blur convolution filter.',
                     calc => 'tar = convolution(srcimg, ix, iy, ch, cmlblur, 3, 3);'},
  'mblur' =>       { desc => 'Middle blur convolution filter.',
                     calc => 'tar = convolution(srcimg, ix, iy, ch, cmmblur, 3, 3);'},
  'labirintXS' =>  { desc => 'LabirintXS convolution filter.',
                     calc => 'tar = convolution(srcimg, ix, iy, ch, cmlabirintXS, 3, 3);'},
  'msoften' =>     { desc => 'Middle soften convolution filter.',
                     calc => 'tar = convolution(srcimg, ix, iy, ch, cmmsoften, 3, 3);'},
  'finger' =>      { desc => 'Finger convolution filter.',
                     calc => 'tar = convolution(srcimg, ix, iy, ch, cmfinger, 5, 5);'},
  'gaussM' =>      { desc => 'GaussM convolution filter.',
                     calc => 'tar = convolution(srcimg, ix, iy, ch, cmgaussM, 5, 5);'},
  'pointilistic' => {desc => 'Pointilistic convolution filter.',
                     calc => 'tar = convolution(srcimg, ix, iy, ch, cmpointilistic, 5, 5);'},
  'instacfingerprint'=>{desc => 'Instac finger print convolution filter.',
                     calc => 'tar = convolution(srcimg, ix, iy, ch, cminstacfingerprint, 5, 5);'},
  'reducedjaggies'=>{desc => 'Reduced jaggies convolution filter.',
                     calc => 'tar = convolution(srcimg, ix, iy, ch, cmreducedjaggies, 5, 5);'},
  'psychedelic' =>  {desc => 'Psychedelic convolution filter.',
                     calc => 'tar = convolution(srcimg, ix, iy, ch, cmpsychedelic, 5, 5);'},
  'litograph' =>   { desc => 'Litograph convolution filter.',
                     calc => 'tar = convolution(srcimg, ix, iy, ch, cmlitograph, 5, 5);'},
  'labirintS' =>   { desc => 'Labirint small convolution filter.',
                     calc => 'tar = convolution(srcimg, ix, iy, ch, cmlabirintS, 5, 5);'},
  'labirintM' =>   { desc => 'Labirint middle convolution filter.',
                     calc => 'tar = convolution(srcimg, ix, iy, ch, cmlabirintM, 5, 5);'},
  'labirintL' =>   { desc => 'Labirint large convolution filter.',
                     calc => 'tar = convolution(srcimg, ix, iy, ch, cmlabirintL, 5, 5);'},
  'labirintXL' =>  { desc => 'Labirint extra large convolution filter.',
                     calc => 'tar = convolution(srcimg, ix, iy, ch, cmlabirintXL, 5, 5);'},
  'basreliefHD' => { desc => 'Basrelief hard convolution filter.',
                     calc => 'tar = convolution(srcimg, ix, iy, ch, cmbasreliefHD, 5, 5);'},
  'basreliefMD' => { desc => 'Basrelief middle convolution filter.',
                     calc => 'tar = convolution(srcimg, ix, iy, ch, cmbasreliefMD, 5, 5);'},
  'basreliefLD' => { desc => 'Basrelief light convolution filter.',
                     calc => 'tar = convolution(srcimg, ix, iy, ch, cmbasreliefLD, 5, 5);'},
 },
 blendings => {
  'allanon' => {     desc => 'Mean of pixel pair.', 
                     calc => 'tar = (src+add)/2;',
                     prms => {'add' => { desc => "Blend image.",  
                                         test => "addimg.pfm" }}},
  'multiply' => {    desc => 'Pixel pair multiplied', 
                     calc => 'tar = src*add;',
                     prms => {'add' => { desc => "Blend image.",  
                                         test => "addimg.pfm"}}},
  'bleach' => {      desc => 'Inverted pixel pair multiplied', 
                     calc => 'tar = (1-src)*(1-add);',
                     prms => {'add' => { desc => "Blend image.",  
                                         test => "addimg.pfm"}}},
  'screen' => {      desc => 'Invert of multiplied inverted pixels', 
                     calc => 'tar = 1-(1-src)*(1-add);',
                     prms => {'add' => { desc => "Blend image.",  
                                         test => "addimg.pfm"}}},
  'divide' => {      desc => 'Pixels divided', 
                     calc => 'tar = src / add;',
                     prms => {'add' => { desc => "Blend image.",  
                                         test => "addimg.pfm"}}},
  'add' => {         desc => 'Sum of pixel pair', 
                     calc => 'tar = src + add;',
                     prms => {'add' => { desc => "Blend image.",  
                                         test => "addimg.pfm"}}},
  'sub' => {         desc => 'Pixels substracted', 
                     calc => 'tar = src - add;',
                     prms => {'add' => { desc => "Blend image.",  
                                         test => "addimg.pfm"}}},
  'diff' => {        desc => 'Absolute difference of pixels', 
                     calc => 'tar = fabs(src-add);',
                     prms => {'add' => { desc => "Blend image.",  
                                         test => "addimg.pfm"}}},
  'difference' => {  desc => 'Signed difference of pixels', 
                     calc => 'tar = src - add + 1;',
                     prms => {'add' => { desc => "Blend image.",  
                                         test => "addimg.pfm"}}},
  'paralel' => {     desc => 'Calculated as parallel connected resistances', 
                     calc => 'tar = 2/(1/src+1/add);',
                     prms => {'add' => { desc => "Blend image.",  
                                         test => "addimg.pfm"}}},
  'darken' => {      desc => 'Darker pixel selected', 
                     calc => 'tar = add < src ? add : src;',
                     prms => {'add' => { desc => "Blend image.",  
                                         test => "addimg.pfm"}}},
  'lighten' => {     desc => 'Lighter pixel selected', 
                     calc => 'tar = add > src ? add : src;',
                     prms => {'add' => { desc => "Blend image.",  
                                         test => "addimg.pfm"}}},
  'texture' => {     desc => 'Symmetric addition', 
                     calc => 'tar = src + add - 0.5;',
                     prms => {'add' => { desc => "Blend image.",  
                                         test => "addimg.pfm"}}},
  'light' => {       desc => 'Multiplicative lightening', 
                     calc => 'tar = src*(1-add)+add*add;',
                     prms => {'add' => { desc => "Blend image.",  
                                         test => "addimg.pfm"}}},
  'dark' => {        desc => 'Multiplicative darkening', 
                     calc => 'tar = src*add+(1-add)*add;',
                     prms => {'add' => { desc => "Blend image.",  
                                         test => "addimg.pfm"}}},
  'ekvivalence' => { desc => 'Inverted absolute difference', 
                     calc => 'tar = 1 - fabs(src-add);',
                     prms => {'add' => { desc => "Blend image.",  
                                         test => "addimg.pfm"}}},
  'addSub' => {      desc => 'Absolute square difference', 
                     calc => 'tar = fabs(src*src-add*add);',
                     prms => {'add' => { desc => "Blend image.",  
                                         test => "addimg.pfm"}}},
  'pitagoras' => {   desc => 'Squared geometric mean', 
                     calc => 'tar = sqrt(src*src+add*add)/sqrt(2);',
                     prms => {'add' => { desc => "Blend image.",  
                                         test => "addimg.pfm"}}},
  'arctan' => {      desc => 'Modified arcus tangent of pixels', 
                     calc => 'tar = atan(2*atan2(add,1-src)/PI);',
                     prms => {'add' => { desc => "Blend image.",  
                                         test => "addimg.pfm"}}},
  'exclusion' => {   desc => '', 
                     calc => 'tar = src + add - 2 * src * add;',
                     prms => {'add' => { desc => "Blend image.",  
                                         test => "addimg.pfm"}}},
  'geomMean' => {    desc => 'geometric mean', 
                     calc => 'tar = sqrt(src * add);',
                     prms => {'add' => { desc => "Blend image.",  
                                         test => "addimg.pfm"}}},
  'gammaDark' => {   desc => 'gamma correction', 
                     calc => 'tar = pow(src,add);',
                     prms => {'add' => { desc => "Blend image.",  
                                         test => "addimg.pfm"}}},
  'gammaLight' => {  desc => 'invert gamma correction', 
                     calc => 'tar = pow(src,1/add);',
                     prms => {'add' => { desc => "Blend image.",  
                                         test => "addimg.pfm"}}},
  'burn' => {        desc => 'substract inverse', 
                     calc => 'tar = src + add - 1;',
                     prms => {'add' => { desc => "Blend image.",  
                                         test => "addimg.pfm"}}},
  'linearLight' => { desc => 'symmetric addition', 
                     calc => 'tar = src + 2 * add - 1;',
                     prms => {'add' => { desc => "Blend image.", 
                     	                 test => "addimg.pfm"}}},
  'colorDodge' => {  desc => 'Divide by invert', 
                     calc => 'tar = src / (1-add);',
                     prms => {'add' => { desc => "Blend image.", 
                                         test => "addimg.pfm"}}},
  'colorBurn' => {   desc => 'Divide invert', 
                     calc => 'tar = 1-(1-src)/add;',
                     prms => {'add' => { desc => "Blend image.", 
                                         test => "addimg.pfm"}}},
  'pinLight' => {    desc => '', 
                     calc => 'tar = max(2*add-1,min(src,2*add));',
                     prms => {'add' => { desc => "Blend image.", 
                                         test => "addimg.pfm"}}},
  'hardLight' => {   desc => 'Multiplication/inverse multiplication', 
                     calc => 'tar = add < 0.5 ? 2*src*add : 1-2*(1-src)*(1-add);',
                     prms => {'add' => { desc => "Blend image.", 
                                         test => "addimg.pfm"}}},
  'softLight' => {   desc => 'Lighten by power', 
                     calc => 'tar = pow(src,pow(2,(2*(0.5-add))));',
                     prms => {'add' => { desc => "Blend image.", 
                                         test => "addimg.pfm"}}},
  'vividLight' => {  desc => '', 
                     calc => 'tar = add < 0.5 ? 1-(1-src)/(2*add) : src/(2*(1-add));',
                     prms => {'add' => { desc => "Blend image.", 
                                         test => "addimg.pfm"}}},
  'overlay' => {     desc => 'Multiplication/inverse multiplication', 
                     calc => 'tar = add > 0.5 ? 2*src*add : 1-2*(1-src)*(1-add);',
                     prms => {'add' => { desc => "Blend image.", 
                                         test => "addimg.pfm"}}},
  'bnoise'  => {     desc => 'Configurable symmetric additional (scale) blending', 
                     calc => 'tar = src + (add-threshold);',
                     prms => {'add' => { desc => "Blend image.", 
                                         test => "addimg.pfm"},
                              'threshold' => { desc => 0.5} }},
  'bsnoise' => {     desc => 'Configurable symmetric additional (bottom scale) blending', 
                     calc => 'tar = src + min(src,1-src)*(add-threshold)/
                                          max(threshold,1-threshold);',
                     prms => {'add' => { desc => "Blend image.", 
                                         test => "addimg.pfm"},
                              'threshold' => { desc => 0.5} }},
  'and' =>       {   desc => 'Binary and blending', 
                     calc => 'tar = (src != 0) && (add != 0);',
                     prms => {'add' => { desc => "Blend image.", 
                                         test => "addimg.pfm"}}},
  'or' =>        {   desc => 'Binary and blending', 
                     calc => 'tar = (src != 0) || (add != 0);',
                     prms => {'add' => { desc => "Blend image.", 
                                         test => "addimg.pfm"}}},
  'xor' =>        {   desc => 'Binary and blending', 
                     calc => 'tar = (src != 0) ^ (add != 0);',
                     prms => {'add' => { desc => "Blend image.", 
                                         test => "addimg.pfm"}}},
 },
 mapgen => {
  'null' =>    {     desc => 'Empty image.', 
                     calc => 'tar = 0;'},
  'color' => {       desc => 'Image with the given color/value', 
                     calc => 'tar = color;',
                     prms => {'color'      =>{ desc => "Color of the image", 
                                               def => 1.0}}},
  'random' => {      desc => 'Image with random noise', 
                     calc => 'tar = 1.0 * rand() / RAND_MAX;'},
  'piramid' => {     desc => 'Four side gradient', 
                     calc => 'double d = 0;
                              double cx = (ix<x) ? ix/x : 1-(ix-x)/(w-x);
                              double cy = (iy<y) ? iy/y : 1-(iy-y)/(h-y);
                              if ((cx-cy+1 != 0) && (cy >= cx)) d = cx/(cx-cy+1);
                              if ((cy-cx+1 != 0) && (cy <= cx)) d = cy/(cy-cx+1);
                              tar = 1-(cos(d*PI)+1)/2;',
                     prms => {'x' =>    { desc => "", 
                                          def  => "20"},
                              'y' =>    { desc => "", 
                                          def  => "20"}}},,
  'gradver' => {     desc => 'Vertical gradient', 
                     calc => 'tar = c1 + (c2-c1)*iy/h;',
                     prms => {'c1' =>    { desc => "Begin color", 
                                           def  => "0"},
                              'c2' =>    { desc => "End color", 
                                           def  => "1"}}},
  'gradhor' => {     desc => 'Horizontal gradient', 
                     calc => 'tar = c1 + (c2-c1)*ix/w;',
                     prms => {'c1' =>    { desc => "Begin color", 
                                           def  => "0"},
                              'c2' =>    { desc => "End color", 
                                           def  => "1"}}},
  'sawtooth1D' => {  desc => 'Vertical sawtooth function', 
                     calc => 'int wl = wavelength*h;
                              tar = cos( (1.0 * (iy % wl) / wl) * PI/2);',
                     prms => {'wavelength' => { desc => "", 
                                                def  => "0.1"}}},
  'sine1D' =>     {  desc => 'Vertical sine function', 
                     calc => 'tar = (1+sin(2*PI*iy/(wavelength*h)))/2;',
                     prms => {'wavelength' => { desc => "", 
                                                def  => "0.1"}}},
  'sinepolar' =>  {  desc => 'Polar sine function', 
                     calc => 'double wl = w*wavelength/(2*PI);
                              double r  = sqrt(sqr(ix-x*w)+sqr(iy-y*h));
                              tar = (1+sin(r/wl))/2;',
                     prms => {'wavelength' => { desc => "",
                                                def  => "0.1"},
                              'x' =>          { desc => "", 
                                                def  => "0.5"},
                              'y' =>          { desc => "", 
                                                def  => "0.5"}}},
  'abssine2D' =>   { desc => '2D absolute sine function',
                     calc => 'double y = 2 * PI * iy / (h * xwavelen);
                              double x = 2 * PI * ix / (w * ywavelen);
                              tar = (fabs(sin(x)) + fabs(sin(y))) / 2;',
                     prms => {'xwavelen' =>   { desc => "Horizontal wavelength", 
                                                def  => "0.1"},
                              'ywavelen' =>   { desc => "Vertical wavelength", 
                                                def  => "0.1"}}},
  'sawtooth2D' =>  { desc => '2D sawtooth function',
                     calc => 'int wx = (int)(w * xwavelen);
                              int wy = (int)(h * ywavelen);
                              double y = (PI * (iy % wy) / wy) / 2;
                              double x = (PI * (ix % wx) / wx) / 2;
                              tar = min(cos(x),cos(y));',
                     prms => {'xwavelen' =>   { desc => "Horizontal wavelength", 
                                                def  => "0.1"},
                              'ywavelen' =>   { desc => "Vertical wavelength", 
                                                def  => "0.1"}}},
  'sinesawtooth2D'=>{desc => '2D sine sawtooth function',
                     calc => 'int wx = (int)(w * xwavelen);
                              int wy = (int)(h * ywavelen);
                              double y = (PI * (iy % wy) / wy) / 2;
                              double x = (PI * (ix % wx) / wx) / 2;
                              tar = cos(x) * cos(y);',
                     prms => {'xwavelen' =>   { desc => "Horizontal wavelength", 
                                                def  => "0.1"},
                              'ywavelen' =>   { desc => "Vertical wavelength", 
                                                def  => "0.1"}}},
  'sine2D' =>      { desc => '2D sine function',
                     calc => 'double y = 2 * PI * iy / (h * xwavelen);
                              double x = 2 * PI * ix / (w * ywavelen);
                              tar = (1+sin(x)*sin(y))/2;',
                     prms => {'xwavelen' =>   { desc => "Horizontal wavelength", 
                                                def  => "0.1"},
                              'ywavelen' =>   { desc => "Vertical wavelength", 
                                                def  => "0.1"}}},
  'sinebrick' =>   { desc => 'Brick shape 2D sine function',
                     calc => 'double y = 2 * PI * iy / (h * xwavelen);
                              double x = 2 * PI * ix / (w * ywavelen);
                              tar = (1+sin(x+(PI/2)*sign(sin(y))))*(fabs(sin(y)))/2;',
                     prms => {'xwavelen' =>   { desc => "Horizontal wavelength", 
                                                def  => "0.1"},
                              'ywavelen' =>   { desc => "Vertical wavelength", 
                                                def  => "0.1"}}},
  'sinegrid' =>    { desc => 'Grid like 2D sine function',
                     calc => 'double y = 2 * PI * iy / (h * xwavelen);
                              double x = 2 * PI * ix / (w * ywavelen);
                              tar  =  (1+cos(x))*(1+cos(y)) / 4;',
                     prms => {'xwavelen' =>   { desc => "Horizontal wavelength", 
                                                def  => "0.1"},
                              'ywavelen' =>   { desc => "Vertical wavelength", 
                                                def  => "0.1"}}},
  'sinehexagrid' =>{ desc => 'Hexagonal 2D sine grid',
                     calc => 'double k = sqrt(3)/2;
                              double y = 2 * PI * iy / (h * xwavelen);
                              double x = 2 * PI * ix / (w * ywavelen);
                              tar = (1+cos(y))*(1+cos(k*x+0.5*y))*(1+cos(k*x-0.5*y))/8;',
                     prms => {'xwavelen' =>   { desc => "Horizontal wavelength", 
                                                def  => "0.1"},
                              'ywavelen' =>   { desc => "Vertical wavelength", 
                                                def  => "0.1"}}},
  'sinehexa' =>    { desc => 'Hexagonal 2D sine function',
                     calc => 'double k = sqrt(3)/2;
                              double y = 2 * PI * iy / (h * xwavelen);
                              double x = 2 * PI * ix / (w * ywavelen);
                              tar = fabs(sin(y)*sin(k*x+0.5*y)*sin(k*x-0.5*y));',
                     prms => {'xwavelen' =>   { desc => "Horizontal wavelength", 
                                                def  => "0.2"},
                              'ywavelen' =>   { desc => "Vertical wavelength", 
                                                def  => "0.2"}}},
  'sinebear' =>    { desc => 'Advanced random 2D sine function',
                     init => 'double A[10];
                              int i;
                              for (i = 0; i<10; i++) A[i] = 1+(rand() % 200)/100.0;',
                     calc => 'double y = 2 * PI * iy / (h * xwavelen);
                              double x = 2 * PI * ix / (w * ywavelen);
                              tar = 1 + (A[4]*sin(A[0]*sin(A[6]*x)+A[1]*cos(A[7]*y))
                                        +A[5]*cos(A[2]*cos(A[8]*x)+A[3]*sin(A[9]*y))) / 2;',
                     prms => {'xwavelen' =>   { desc => "Horizontal wavelength", 
                                                def  => "0.3"},
                              'ywavelen' =>   { desc => "Vertical wavelength", 
                                                def  => "0.3"}}},
  'piramids' =>    { desc => 'Piramids grid map',
                     calc => 'double dx = sizex * w;
                              double x = (ix % (int)(dx));
                              double y = (iy % (int)(dx));
                              double d = fabs(x-dx/2)+fabs(y-dx/2);
                              if (d>dx/2) d = dx-d;
                              tar = 2*d/dx;
                              if (0) { tar = 2*tar; if (tar>1) tar = 2-tar; }',
                     prms => {'sizex'    =>   { desc => "Horizontal wavelength", 
                                                def  => "0.1"},
                              'fold'     =>   { desc => "folding", 
                                                def  => "0"}}},
 },
 fractals => {
  'set' =>    {      desc => 'Generates fractal set.',
                     init => 'tsetmodel sm = setmodelCreate(
                                setformulaCreate(mode, setpoint(cx,cy), formula),
                                setcoloringCreate(coloring),
                                maxiteration,
                                setpoint(xmin, ymin),
                                setpoint(xmax, ymax));',
                     calc => 'tar = setiteration(setpoint(1.0*ix/w, 1.0*iy/h), sm);',
                     post => 'autocontrast(tarimg, tarimg, fproc);',
                     prms => {'maxiteration'=>{ def  => "20"},
                              'xmin' =>       { def  => "-2.0"},
                              'ymin' =>       { def  => "-1.5"},
                              'xmax' =>       { def  => "1"},
                              'ymax' =>       { def  => "1.5"},
                              'cx'   =>       { def  => "0.4"},
                              'cy'   =>       { def  => "0.3"},
                              'formula' =>    { def  => "0", desc => 
                                                "0 = Mandelbrot, 1 = SqrMandelbrot, 2 = Phoenix, ".
                                                "3 = Newton, 4 = Szegedi, 5 = Szegedi2",
                                                test => [0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5]},
                              'coloring'=>    { def  => "0", desc => 
                                                "0 = TimeEscape, 1 = Potential,2  = CurveEstimate, ".
                                                "3 = EscapeAngle, 4 = EscapeDistance",
                                                test => [0, 1, 2, 3, 4, 0, 0, 0, 0, 0, 0]},
                              'mode'=>        { def  => "0",
                                                test => [0, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0]} }},
 }
},
distortions => {
 simple  => {
  'resize' =>       {desc => 'Resize the image.',
                     calc => 'x1 = l+(srcimg.w-1)*(x-left)/(width-1);
                              y1 = t+(srcimg.h-1)*(y-top)/(height-1);',
                     prms => {'left'    => { def => 0 },
                              'top'     => { def => 0 }, 
                              'width'   => { def => 1024 }, 
                              'height'  => { def => 768 } }},
 },
 conform => {
  # CONFORM DISTORSIONS
  'bolyaiSphere' => {desc => 'Bolyai hyperbolic geometry conversion',
                     calc => '
          double d, fi, d0;                    
          d = sqrt(sqr(x/w - x0) + sqr(y/h - y0)); 
          fi = atan2(y/h - y0, x/w - x0);          
          d0 = d * R / sqrt(sqr(d) + sqr(z0)); 
          x1 = w * (x0 + d0 * cos(fi));              
          y1 = h * (y0 + d0 * sin(fi));',
                     prms => {'x0' => { def => 0.5 },
                              'y0' => { def => 0.5 }, 
                              'z0' => { def => 0.2  }, 
                              'R'  => { def => 0.3 } }},
  'invbolyaiSphere' => {desc => 'Bolyai hyperbolic geometry inverse conversion',
                     calc => '
          double d, fi, z, d0, dx, dy;
          dx = x/w-x0;
          dy = y/h-y0;
          d = sqrt(sqr(dx)+sqr(dy)); 
          fi = atan2(dy,dx); 
          z = sqrt(sqr(R)-sqr(dx)-sqr(dy))+z0; 
          d0 = (z0 < 0)  ? -z0 * d / (z - z0) : 
                           z0 * d / (z + z0); 
          x1 = w * (x0 + d0 * cos(fi)); 
          y1 = h * (y0 + d0 * sin(fi));',
                     prms => {'x0' => { def => 0.5 }, 
                              'y0' => { def => 0.5 }, 
                              'z0' => { def => 0.2 }, 
                              'R'  => { def => 0.3 } }},
  'spherize' => {    desc => 'Transformation to  sphere surface',
                     calc => '
          double dx, dy, d;
          dx = x/w - x0;
          dy = y/h - y0;
          d = sqrt(sqr(dx)+sqr(dy));
          if (d>radius) {
            x1  = x;
            y1  = y;
          } else {
            double fi, R, z0, tmp, z, d0;
            fi  = atan2(dy,dx);
            R   = radius/sin(angle);
            z0  = R*cos(angle);
            tmp = sqr(R)-sqr(dx)-sqr(dy);
            z   = sqrt(tmp)+z0;
            d0  = (angle > 0) ? z0*d/(z-z0) : z0*d/(z+z0);
            x1  = w * (x0+d0*cos(fi));
            y1  = h * (y0+d0*sin(fi));
          }',
                     prms => {'x0'     => { def => 0.5 },
                              'y0'     => { def => 0.5 },
                              'radius' => { def => 0.5 }, 
                              'angle'  => { def => 1.0 } }},
  'polarToDescartes' => {desc => 'Convert from polar to descartes coordinate system',
                     calc => '
          double zx, zy, ux, uy, r, fi, rCons, fiCons;
          rCons  = (h-1)/(sqrt(w*w+h*h)/2.0);
          fiCons = (w-1)/(2*PI);
          ux = (w/2.0)-1;
          uy = (h/2.0)-1;
          zx = x-ux;
          zy = y-uy;
          r = sqrt(sqr(zx)+sqr(zy));
          fi = atan2(zy,zx);
          x1 = fi * fiCons;
          y1 = h - r*rCons - 1;' },
  'descartesToPolar' => {desc => 'Convert from descartes to polar coordinate system',
                     calc => '
          double rCons, fiCons, ux, uy;
          rCons  = (sqrt(w*w+h*h)/2.0)/(h-1);
          fiCons = (2*PI)/(w-1);
          ux = (w/2.0)-1;
          uy = (h/2.0)-1;
          x1 = y*rCons*cos(x*fiCons)+ux;
          y1 = y*rCons*sin(x*fiCons)+uy;' },
  'rotate' => {      desc => 'Rotate with the given angle around the specified point',
                     calc => '
          double o, ux, uy, rx, ry, zx, zy;
          rx = cos(angle);
          ry = sin(angle);
          zx = x-w*x0;
          zy = y-h*y0;
          if (ry == 0) {
             ux =zx/rx;
             uy =zy/rx;
          } else {
             o  =rx*rx+ry*ry;
             ux =(zx*rx+zy*ry)/o;
             uy =(zy*rx-zx*ry)/o;
          }
          x1 = ux+w*x0;
          y1 = uy+h*y0;',
                     prms => {'angle' => { def => 1.0 }, 
                              'x0'    => { def => 0.5 }, 
                              'y0'    => { def => 0.5 } }},
  'swirl' => {       desc => 'Swirl distorsion',
                     calc => '
          double r,fi,zx,zy,ux,uy,tx,ty,z2x,z2y;
          tx = cos(angle);
          ty = sin(angle);
          zx  = x-x0*w;
          zy  = y-y0*h;
          r   = sqrt(sqr(zx)+sqr(zy))/radial;
          fi  = r * angle;
          ux  = cos(fi);
          uy  = sin(fi);
          z2x = zx * ux - zy * uy;
          z2y = zx * uy + zy * ux;
          x1  = (z2x*tx+z2y*ty)+x0*w;
          y1  = (z2y*tx-z2x*ty)+y0*h;',
                     prms => {'angle'  => { def => 0.5 }, 
                              'radial' => { def => 10 }, 
                              'x0'     => { def => 0.5  }, 
                              'y0'     => { def => 0.5 } }},
  'pinch' => {       desc => 'Pinch distorsion',
                     calc => '
          double zx, zy, ux, uy, z2, r;
          ux = (2.0 * x / w) - 1;
          uy = (2.0 * y / h) - 1;
          r  = sqrt(sqr(ux) + sqr(uy));
          z2 = pow(r, scale);
          zx = z2 * ux / r;
          zy = z2 * uy / r;
          x1 = (zx+1)*(w/2.0);
          y1 = (zy+1)*(h/2.0);',
                     prms => {'scale' => { def => 2 }  }},
  'sinusoidal' => {  desc => 'Distort distance from center with sine',
                     calc => '
          double ux,uy,zx,zy,arcsin;
          arcsin = 1.0/asin(scale);
          ux   = (x-(w/2.0))/(w/2.0);
          uy   = (y-(h/2.0))/(h/2.0);
          ux   = ux*scale;
          uy   = uy*scale;
          zx   = asin(ux)*arcsin;
          zy   = asin(uy)*arcsin;
          x1   = zx*(w/2.0)+(w/2.0);
          y1   = zy*(h/2.0)+(h/2.0);',
                     prms => {'scale' => { def => 1 } }},
  'centermirror' => {desc => 'Mirroring across specified center point',
                     calc => '
          x1 = w * (x0 - (x/w - x0));
          y1 = h * (y0 - (y/h - y0));',
                     prms => {'x0' => { def => 0.5 }, 
                              'y0' => { def => 0.5 } }},
  'axismirror' => {  desc => 'Mirroring across specified line',
                     calc => '
          double tx, ty, naxisx, naxisy, d;
          d = sqrt(sqr(axisx)+sqr(axisy));
          naxisx = axisx / d;
          naxisy = axisy / d;
          tx = (x*naxisx + y*naxisy);
          ty = (x*naxisy - y*naxisx);
          x1 = (tx*naxisx - ty*naxisy) + w*x0;
          y1 = (tx*naxisy + ty*naxisx) + h*y0;',
                     prms => {'x0'    => { def => 0.5 }, 
                              'y0'    => { def => 0.5 }, 
                              'axisx' => { def => 0.4 }, 
                              'axisy' => { def => 0.5 } }},
  'misterx' => {     desc => 'Position inversion to the center',
                     calc => '
          double zx,zy,o;
          zx = (x/w - (1.0 / 2.0)) / rad;
          zy = (y/h - (1.0 / 2.0)) / rad;
          o  = zx * zx + zy * zy;
          zx = zx / o;
          zy = -zy / o;
          x1  = w * (zx*rad + (1.0 / 2.0));
          y1  = h * (zy*rad + (1.0 / 2.0));
          if (x1 <  0)   x1 = -x1-1;
          if (x1 >= w*2) x1 = (2.0*w)*(x1/(2.0*w)-(int)(x1/(2.0*w)));
          if (x1 >= w)   x1 = w-1-(x1-w);
          if (y1 <  0)   y1 = -y1-1;
          if (y1 >= h*2) y1 = (2*h)*(y1/(2.0*h)-(int)(y1/(2.0*h)));
          if (y1 >= h)   y1 = h-1-(y1-h);',
                     prms => {'rad' => { def => 1} }},
  'tube' => {        desc => 'Transform to the surface of a tube',
                     calc => '
          double d, fi, d0, dmax, fio, rmin, rmax, xc, yc;
          xc   = x0 * w; yc = y0 * h;
          fio  = atan2(h/2.0-xc,w/2.0-yc);
          rmin = sqrt(sqr(w/2.0)+sqr(h/2.0))-sqrt(sqr(xc-w/2.0)+sqr(yc-h/2.0));
          rmax = sqrt(sqr(w/2.0)+sqr(h/2.0))+sqrt(sqr(xc-w/2.0)+sqr(yc-h/2.0));
          fi   =  atan2(y-yc,x-xc);
          dmax =  rmin+(rmax-rmin)*(1-cos(fi-fio))/2.0;
          d    =  sqrt(sqr(x-xc) + sqr(y-yc)) / dmax;
          d0   =  (d == 0) ? 0 : rad / d;
          x1   = xc + numX * d0 * dmax + w*dX/100.0;
          y1   = yc + numY * (fi/PI)*h + h*dY/100.0;
          if (x1 <  0)   x1 = -x1 - 1;
          if (x1 >= w*2) x1 = (2.0*w)*(x1/(2.0*w)-(int)(x1/(2.0*w)));
          if (x1 >= w)   x1 = w-1-(x1-w);
          if (y1 <  0)   y1 = -y1-1;
          if (y1 >= h*2) y1 = (2*h)*(y1/(2.0*h)-(int)(y1/(2.0*h)));
          if (y1 >= h)   y1 = h-1-(y1-h);',
                     prms => {'x0'   => { def => 0.4 }, 
                              'y0'   => { def => 0.5 }, 
                              'numX' => { def => 6   },
                              'numY' => { def => 2   },
                              'rad'  => { def => 0.1 }, 
                              'dX'   => { def => 0.3 }, 
                              'dY'   => { def => 0.2 } }},
  'shift' => {       desc => 'Shift with the specified relative vector.',
                     calc => '
          x1 = x + w * ((1 < x0) ? 1-x0 : -x0);
          y1 = y + h * ((1 < y0) ? 1-y0 : -y0);
                     ',
                     prms => {'x0' =>   { def => 0.25 }, 
                              'y0' =>   { def => 0.25 } }},
 }
},
color => {
 channel => {
  'addalpha'   => {  desc => 'Set the parameter map as alpha channel of input.',
                     calc => 'tar[4] = alpha;',
                     prms => {'alpha'  => { test => "addimg.pfm" } }},
  'setchannel'  => { desc => 'Set the parameter map as specified channel of input.',
                     calc => 'tar[(int)channel] = add;',
                     prms => {'add'    => { test => "addimg.pfm" },
                              'channel'=> { def  => 0 } }},
  'getchannel'  => { desc => 'Get the specified channel of input.',
                     calc => 'tar[0] = tar[1] = tar[2] = src[(int)channel];
                              tar[3] = 1;',
                     prms => {'channel'=> { def => 0 } }},
  'copychannel' => { desc => 'Copy source channel to target channel.',
                     calc => 'tar[(int)target] = src[(int)source];',
                     prms => {'source' => { def => 0 },
                              'target' => { def => 1 } }},
  'swapchannels' => {desc => 'Swap source and target channel.',
                     calc => 'double temp = tar[(int)target];
                              tar[(int)target] = src[(int)source];
                              src[(int)source] = temp;',
                     prms => {'source' => { def => 0 },
                              'target' => { def => 1 } }},
 },
 grayscale => {
  'grayscale'  =>  { desc => 'Grayscale conversion.',
                     calc => 'tar[0] = tar[1] = tar[2] = 
                                (src[0] + src[1] + src[2])/3.0;' },
  'intensity'  =>  { desc => 'Intensity weighted grayscale conversion.',
                     calc => 'tar[0] = tar[1] = tar[2] = 
                                0.3 * src[0] + 0.59 * src[1] + 0.11 * src[2];' },
  'geograyscale'=> { desc => 'Multiplicative grayscale conversion.',
                     calc => 'tar[0] = tar[1] = tar[2] =
                                pow(src[0] * src[1] * src[2], 1.0/3.0);' },
  'pitgrayscale'=> { desc => 'Grayscale conversion.',
                     calc => 'tar[0] = tar[1] = tar[2] =
                                sqrt((sqr(src[0])+sqr(src[1])+sqr(src[2]))/3.0);' },
 },
 color => {
  'sephia' =>      { desc => 'Sephia color mapping.',
                     calc => 'double Y = 0.299*src[0] + 0.587*src[1] + 0.114*src[0];
                              tar[0] = Y+0.95568806036115671171*0.2;
                              tar[1] = Y-0.27158179694405859326*0.2;
                              tar[2] = Y-1.1081773266826619523*0.2;' },
                                      
  'cmwood' =>      { desc => 'Wood color mapping.',
                     calc => 'double gray = (src[0]+src[1]+src[2])/3.0;
                              double l = (gray*density-(int)gray*density)/3.0;
                              tar[0] = 2.0/3.0 + l;
                              tar[1] = 1.0/3.0 + l;
                              tar[2] = 0;',
                     prms => {'density' => { def => 5 } }},
                                      
  'cmmarble' =>    { desc => 'Marble color mapping.',
                     calc => 'double gray = (src[0]+src[1]+src[2])/3.0;
                              double m = pow(cos((iy/(freq/h))+(gray*6.28)),4);
                              tar[2] = (1.0+2*m)/3.0;
                              tar[1] = 1.0/3.0 + m;
                              tar[0] = 1.0;',
                     prms => {'freq' => { def => 25 } }},
                                   
  'cmstone' =>     { desc => 'Stone color mapping.',
                     calc => 'double m = 1 - ((1+cos((iy/(freq/w))+(src[0]*6.28)))/2) *
                                             ((1+cos((ix/(freq/w))+(src[1]*6.28)))/2);
                              m = src[2] * (1 - 2 * pow(m,8) / 3.0 ); 
                              tar[2] = tar[1] = tar[0] = m;',
                     prms => {'freq' => { def => 0.1 } }},
                                                           
  'csautocontrast' =>{ desc => 'Color safe autocontrast to the available range.', 
                     init => 'tLayerStats s; stats(srcimg, &s);',
                     calc => 'double gray = (src[0]+src[1]+src[2])/3.0;
                              double gain = (gray-s.intmin)/(s.intmax-s.intmin);
                              tar[0] = src[0] * gain / gray;
                              tar[1] = src[1] * gain / gray;
                              tar[2] = src[2] * gain / gray;' },

  'setHSV' =>      { desc => 'Shift Hue, Saturation, Value.',
                     calc => 'tcolor HSV; ccRGB2HSV(src, HSV);
                              HSV[0] = HSV[0] + dH;
                              HSV[0] = HSV[0] - floorf(HSV[0]);
                              HSV[1] = limit(0,HSV[1]+dS,1);
                              HSV[2] = limit(0,HSV[2]+dV,1);
                              ccHSV2RGB(HSV, tar);',
                     prms => {'dH' => { def => 0.3 },
                              'dS' => { def => 0.2 },
                              'dV' => { def => 0.1 } }},
                              
  'YIQ2RGB' =>     { desc => 'YIQ to RGB color conversion.',
                     calc => 'colorconv(src, ccYIQ2RGB, tar);' },
  'RGB2YIQ' =>     { desc => 'RGB to YIQ color conversion.',
                     calc => 'colorconv(src, ccRGB2YIQ, tar);' },
  'LMS2RGB' =>     { desc => 'LMS to RGB color conversion.',
                     calc => 'colorconv(src, ccLMS2RGB, tar);' },
  'LMS2RGB' =>     { desc => 'LMS to RGB color conversion.',
                     calc => 'colorconv(src, ccRGB2LMS, tar);' },
  'RGB2XYZ' =>     { desc => 'RGB to XYZ color conversion.',
                     calc => 'colorconv(src, ccRGB2XYZ, tar);' },
  'XYZ2RGB' =>     { desc => 'XYZ to RGB color conversion.',
                     calc => 'colorconv(src, ccXYZ2RGB, tar);' },
  'YCbCr2RGB' =>   { desc => 'YCbCr to RGB color conversion.',
                     calc => 'colorconv(src, ccYCbCr2RGB, tar);' },
  'RGB2YCbCr' =>   { desc => 'RGB to YCbCr color conversion.',
                     calc => 'colorconv(src, ccRGB2YCbCr, tar);' },
  'HSV2RGB' =>     { desc => 'HSV to RGB color conversion.',
                     calc => 'ccHSV2RGB(src, tar);' },
  'RGB2HSV' =>     { desc => 'RGB to HSV color conversion.',
                     calc => 'ccRGB2HSV(src, tar);' },
  'RGB2LAB' =>     { desc => 'RGB to LAB color conversion.',
                     calc => 'ccRGB2LAB(src, tar);' },
  'LAB2RGB' =>     { desc => 'LAB to RGB color conversion.',
                     calc => 'ccLAB2RGB(src, tar);' },
  'RGB2HSI' =>     { desc => 'RGB to HSI color conversion.',
                     calc => 'ccRGB2HSI(src, tar);' },
  'RGB2YC1C2' =>   { desc => 'RGB to YC1C2 color conversion.',
                     calc => 'ccRGB2YC1C2(src, tar);' },
 }
});


__DATA__
