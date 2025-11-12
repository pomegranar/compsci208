PImage img, depth, original;

void setup() {
  size(600, 800);
  // original = loadImage("img.png");
  depth = loadImage("anar-depth.png");
  original = loadImage("anar.png");
  // depth = loadImage("ferraridepth.png");
  original.resize(width, height);
  depth.resize(width, height);
  noSmooth();
}

void draw() {
  background(0);
  img = original.get();
  img.loadPixels();
  depth.loadPixels();
  
  float t = millis() * 0.001;
  
  // mouseX: 0=water, 1=fire
  float effectMode = map(mouseX, 0, width, 0, 1);
  
  // mouseY: falloff (0.01–0.5)
  float falloff = map(mouseY, 0, height, 0.01, 0.5);
  float mid = 0.5;
  float curveStrength = 4.0;
  
  PImage processed = createImage(width, height, RGB);
  processed.loadPixels();
  
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      int i = x + y * width;
      color base = img.pixels[i];
      color d = depth.pixels[i];
      
      float depthFactor = 1.0 - (red(d) / 255.0);
      depthFactor = pow(depthFactor, 2.0);
      
      float mask = smoothstep(mid - falloff, mid + falloff, depthFactor);
      float effect = pow(mask, curveStrength);
      
      if (effect > 0.5) {
        // WATER EFFECT (left side)
        float waterN = noise(x * 0.015, y * 0.015, t * 0.8);
        int waterDx = int(sin(t * 1.5 + y * 0.05) * 8 * effect * waterN);
        int waterDy = int(cos(t * 1.2 + x * 0.03) * 6 * effect);
        
        // FIRE EFFECT (right side)
        float fireN = noise(x * 0.04, y * 0.04 + t * 2.0, t * 1.5);
        float turbulence = noise(x * 0.08, (y - t * 40) * 0.08) * noise(x * 0.03, y * 0.03, t * 3.0);
        int fireDx = int((fireN - 0.5) * 25 * effect * turbulence);
        int fireDy = int((turbulence - 0.5) * -15 * effect); // upward distortion
        
        // Blend displacement based on effectMode
        int dx = int(lerp(waterDx, fireDx, effectMode));
        int dy = int(lerp(waterDy, fireDy, effectMode));
        
        int sx = constrain(x + dx, 0, width - 1);
        int sy = constrain(y + dy, 0, height - 1);
        int si = sx + sy * width;
        
        color src = img.pixels[si];
        float r = red(src);
        float g = green(src);
        float b = blue(src);
        
        // WATER COLOR TINTING - DARKENING
        float waterWave = 0.85 + 0.15 * sin(t * 2.0 + y * 0.08);
        float waterR = r * waterWave * 0.5;  // darken significantly
        float waterG = g * waterWave * 0.65;
        float waterB = b * (0.8 + 0.2 * sin(t * 1.5 + x * 0.05));
        
        // FIRE COLOR TINTING - BRIGHTENING
        float flameFlicker = 1.0 + 0.4 * noise(x * 0.1, y * 0.1 + t * 5.0);
        float heatWave = noise(x * 0.05, (y - t * 20) * 0.1, t * 2.0);
        float fireR = r * (1.5 + heatWave * 0.7) * flameFlicker;  // brighten
        float fireG = g * (1.1 + heatWave * 0.4);
        float fireB = b * (0.6 + heatWave * 0.2);
        
        // Add ember glow for fire - brighter
        float emberGlow = pow(noise(x * 0.15, y * 0.15 + t * 3.0), 3.0) * effectMode * effect;
        fireR += emberGlow * 120;
        fireG += emberGlow * 50;
        fireB += emberGlow * 10;
        
        // Blend colors
        r = lerp(waterR, fireR, effectMode);
        g = lerp(waterG, fireG, effectMode);
        b = lerp(waterB, fireB, effectMode);
        
        // Noise overlay - subtle for water, intense for fire
        float grainIntensity = lerp(15.0, 40.0, effectMode);
        float grain = (noise(x * 0.5, y * 0.5, t * 4.0) - 0.5) * grainIntensity * effect;
        
        // RGB split - minimal for water, chaotic for fire
        int splitAmount = int(lerp(1, 4, effectMode) * effect);
        if (effectMode > 0.3) {
          int ri = constrain(si - splitAmount, 0, img.pixels.length - 1);
          int bi = constrain(si + splitAmount, 0, img.pixels.length - 1);
          r = lerp(r, red(img.pixels[ri]), effectMode * 0.6);
          b = lerp(b, blue(img.pixels[bi]), effectMode * 0.6);
        }
        
        processed.pixels[i] = color(
          constrain(r + grain, 0, 255),
          constrain(g + grain, 0, 255),
          constrain(b + grain, 0, 255)
        );
      } else {
        processed.pixels[i] = base;
      }
    }
  }
  
  processed.updatePixels();
  image(processed, 0, 0);
  
  // UI
  fill(255);
  textSize(12);
  String mode = effectMode < 0.5 ? "WATER" : "FIRE";
  text(mode + " mode | falloff: " + nf(falloff, 1, 3), 8, height - 8);
}

float smoothstep(float edge0, float edge1, float x) {
  if (edge0 == edge1) return x < edge0 ? 0 : 1;
  x = constrain((x - edge0) / (edge1 - edge0), 0, 1);
  return x * x * (3.0 - 2.0 * x);
}
