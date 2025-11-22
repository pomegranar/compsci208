
boolean[] keys = new boolean[256];
ArrayList<Balloon> balloons;
ArrayList<Bullet> bullets;
int level = 1;
int mags = 3;
boolean gameOver = false;
Gun gun;



void setup() {
  fullScreen();
  //size(800,800);
  background(0);
  gun = new Gun(width/2, height/2, "pls work as intended");
  balloons = new ArrayList<Balloon>();
  bullets = new ArrayList<Bullet>();
  spawnBalloons();
}

void draw() {
  background(0);


  if (gameOver) {
    fill(255, 0, 0);
    textSize(80);
    textAlign(CENTER, CENTER);
    text("GAME OVER", width/2, height/2 - 40);
    textSize(32);
    fill(255);
    text("Press R to restart", width/2, height/2 + 40);
    return;
  }

  gun.handleMovement(keys);
  gun.pointTowardsMouse();
  gun.handleTrigger(mousePressed && mouseButton == LEFT);
  gun.updateFire();
  gun.drawGun();

  for (int i = balloons.size() - 1; i >= 0; i--) {
    Balloon b = balloons.get(i);
    b.update(level);
    b.display();
    if (b.isOffScreen()) {
      balloons.remove(i);
    }
  }

  for (int i = bullets.size() - 1; i >= 0; i--) {
    Bullet bullet = bullets.get(i);
    bullet.update();
    bullet.display();
    if (bullet.isOffScreen()) {
      bullets.remove(i);
      continue;
    }
    for (int j = balloons.size() - 1; j >= 0; j--) {
      Balloon b = balloons.get(j);
      if (bullet.collidesWith(b)) {
        b.takeDamage();
        bullets.remove(i);
        if (b.isDead()) {
          balloons.remove(j);
        }
        break;
      }
    }
  }

  // ######next level logic:###########
  if (balloons.size() == 0) {
    level++;
    if (mags < 3) mags++;
    spawnBalloons();
    gun.randomizeSeed();
  }

  if (gun.currentAmmo == 0 && mags == 0) {
    gameOver = true;
  }

  // ################HUD#################
  fill(255);
  textSize(24);
  textAlign(LEFT, BASELINE);
  text("Level: " + level, 20, 30);
  text("Balloons: " + balloons.size(), 20, 60);
  text("Ammo: " + gun.currentAmmo + "/" + gun.maxAmmo, 20, 90);
  text("Mags: " + mags, 20, 120);
  text("Mode: " + gun.fireModeNames[gun.fireMode], 20, 150);
  text("R: Reload", 20, 180);
}

void spawnBalloons() {
  int numBalloons = 3 + level;
  for (int i = 0; i < numBalloons; i++) {
    float x = random(100, width - 100);
    float y = random(100, height - 100);
    int strength = int(random(1, min(6, level)));
    balloons.add(new Balloon(x, y, strength));
  }
}

void keyPressed() {
  if (keyCode < 256) keys[keyCode] = true;

  if (key == 'f' || key == 'F') gun.randomizeSeed();

  if (key == 'r' || key == 'R') {
    if (gameOver) {
      level = 1;
      mags = 3;
      gameOver = false;
      gun.randomizeSeed();
      balloons.clear();
      bullets.clear();
      spawnBalloons();
      return;
    }
    if (mags > 0 && gun.currentAmmo < gun.maxAmmo) {
      mags--;
      gun.reload();
    }
  }
}

void keyReleased() {
  if (keyCode < 256) keys[keyCode] = false;
}

class Gun {
  float xpos, ypos;
  float angle = 0;
  float targetAngle = 0;
  float rotationSmoothingSpeed = 0.1;
  int seed;
  float barrelLength;
  float barrelGirth = 4;
  float handleLength = 45;
  float handleSlant = 2;
  color metalGrey = color(100, 100, 110);
  float speed = 13;
  int maxAmmo;
  int currentAmmo;
  int fireMode = 0;
  String[] fireModeNames = {"SINGLE", "BURST", "AUTO", "SINGLE SHOTGUN", "BURST SHOTGUN", "AUTO SHOTGUN"};
  int burstCount = 0;
  int burstSize = 3;
  int fireCounter = 0;
  int singleFireDelay = 10;
  int autoFireDelay = 5;
  int burstFireDelay = 3;
  int burstCooldownDelay = 15;
  int burstCooldown = 0;
  boolean triggerHeld = false;
  boolean triggerJustPressed = false;
  int shotsFired = 0;
  boolean facingLeft = false;
  float bulletSpeed = 8;
  float bulletSize = 6;
  int bulletTrajectory = 0;
  color bulletColor = color(255, 255, 150);
  float bulletSpreadDegrees = 0;
  int spreadPatternLength = 1;
  int pelletCount = 5;
  float shotgunSpreadDegrees = 15;
  float recoilAngle = 0;
  float recoilRecoverySpeed = 0.02;
  int numDecorativeShapes = 0;
  int[] shapeTypes;
  float[] shapePositions;
  float[] shapeWidths;
  float[] shapeHeights;
  float[] shapeTopWidths;
  float[] shapeOffsets;
  color[] shapeColors;
  boolean[] shapeHasUniqueColor;

  // Maybe I can add loading guns from a table for a controlled experience.
  Gun(float x, float y, String gunName) {
    this.seed = gunName.hashCode();
    this.xpos = x;
    this.ypos = y;
    generateGunFromSeed();
  }

  void generateGunFromSeed() {
    randomSeed(seed);
    barrelLength = random(200, 400);
    barrelGirth = random(12, 20);
    float barrelArea = barrelLength * barrelGirth;
    recoilRecoverySpeed = map(barrelLength, 200, 400, 0.12, 0.02);
    rotationSmoothingSpeed = map(barrelArea, 2400, 8000, 0.15, 0.03);
    fireMode = int(random(fireModeNames.length));
    singleFireDelay = int(random(8, 16));
    autoFireDelay = int(random(3, 8));
    burstSize = int(random(2, 5));
    burstFireDelay = int(random(2, 6));
    burstCooldownDelay = int(random(10, 25));
    pelletCount = int(random(4, 10));
    if (fireMode < 3) {
      maxAmmo = int(random(10, 51));
    } else {
      maxAmmo = int(random(5, 15));
    }
    currentAmmo = maxAmmo;
    bulletSpeed = random(20, 40);
    bulletSize = random(4, 11);
    bulletTrajectory = int(random(3));
    bulletColor = color(random(120, 255), random(120, 255), random(40, 200));
    bulletSpreadDegrees = random(0, 6);
    spreadPatternLength = int(random(1, 6));
    shotgunSpreadDegrees = random(10, 25);
    numDecorativeShapes = int(random(3, 10));
    shapeTypes = new int[numDecorativeShapes];
    shapePositions = new float[numDecorativeShapes];
    shapeWidths = new float[numDecorativeShapes];
    shapeHeights = new float[numDecorativeShapes];
    shapeTopWidths = new float[numDecorativeShapes];
    shapeOffsets = new float[numDecorativeShapes];
    shapeColors = new color[numDecorativeShapes];
    shapeHasUniqueColor = new boolean[numDecorativeShapes];
    for (int i = 0; i < numDecorativeShapes; i++) {
      shapeTypes[i] = int(random(3));
      shapePositions[i] = random(0, barrelLength);
      shapeWidths[i] = random(30, 120);
      shapeHeights[i] = random(20, 80);
      shapeTopWidths[i] = random(15, shapeWidths[i] * 0.8);
      shapeOffsets[i] = random(-barrelGirth/2 - 30, barrelGirth/2 + 30);
      shapeHasUniqueColor[i] = random(1) < 0.5;
      if (shapeHasUniqueColor[i]) shapeColors[i] = color(random(50, 255), random(50, 255), random(50, 255));
      else shapeColors[i] = metalGrey;
    }
    burstCount = 0;
    fireCounter = 0;
    burstCooldown = 0;
    shotsFired = 0;
    recoilAngle = 0;
    targetAngle = angle;
  }

  void randomizeSeed() {
    seed = (int)random(Integer.MAX_VALUE);
    generateGunFromSeed();
  }

  void reload() {
    currentAmmo = maxAmmo;
    burstCount = 0;
    fireCounter = 0;
    burstCooldown = 0;
  }

  void handleTrigger(boolean isPressed) {
    triggerJustPressed = isPressed && !triggerHeld;
    if (isPressed) fire();
    else if (triggerHeld && (fireMode == 1 || fireMode == 4)) burstCount = 0;
    triggerHeld = isPressed;
  }

  // fireModeNames = {"SINGLE", "BURST", "AUTO", "SINGLE SHOTGUN", "BURST SHOTGUN", "AUTO SHOTGUN"};
  void fire() {
    if (currentAmmo <= 0) return;
    if (fireMode == 0) {
      if (!triggerJustPressed || fireCounter > 0) return;
      currentAmmo--;
      bullets.add(createBullet());
      fireCounter = singleFireDelay;
      shotsFired++;
    } else if (fireMode == 1) {
      if (burstCount == 0) {
        if (!triggerJustPressed || burstCooldown > 0) return;
        currentAmmo--;
        bullets.add(createBullet());
        burstCount = 1;
        fireCounter = burstFireDelay;
        shotsFired++;
      } else {
        if (burstCount < burstSize && currentAmmo > 0 && fireCounter <= 0) {
          currentAmmo--;
          bullets.add(createBullet());
          burstCount++;
          fireCounter = burstFireDelay;
          shotsFired++;
        }
      }
    } else if (fireMode == 2) { // AUTO
      if (fireCounter > 0) return;
      currentAmmo--;
      bullets.add(createBullet());
      fireCounter = autoFireDelay;
      shotsFired++;
    } else if (fireMode == 3) {
      if (!triggerJustPressed || fireCounter > 0) return;
      currentAmmo--;
      fireShotgunPellets();
      fireCounter = singleFireDelay;
      shotsFired++;
    } else if (fireMode == 4) {
      if (burstCount == 0) {
        if (!triggerJustPressed || burstCooldown > 0) return;
        currentAmmo--;
        fireShotgunPellets();
        burstCount = 1;
        fireCounter = burstFireDelay;
        shotsFired++;
      } else {
        if (burstCount < burstSize && currentAmmo > 0 && fireCounter <= 0) {
          currentAmmo--;
          fireShotgunPellets();
          burstCount++;
          fireCounter = burstFireDelay;
          shotsFired++;
        }
      }
    } else if (fireMode == 5) {
      if (fireCounter > 0) return;
      currentAmmo--;
      fireShotgunPellets();
      fireCounter = autoFireDelay;
      shotsFired++;
    }
  }

  void updateFire() {
    if (fireCounter > 0) fireCounter--;
    if (burstCooldown > 0) burstCooldown--;
    if (recoilAngle < 0) {
      recoilAngle += recoilRecoverySpeed;
      if (recoilAngle > 0) recoilAngle = 0;
    }
    if ((fireMode == 1 || fireMode == 4) && burstCount >= burstSize && fireCounter <= 0) {
      burstCount = 0;
      burstCooldown = burstCooldownDelay;
    }
  }

  void handleMovement(boolean[] keys) {
    if (keys['w'] || keys['W']) ypos -= speed;
    if (keys['s'] || keys['S']) ypos += speed;
    if (keys['a'] || keys['A']) xpos -= speed;
    if (keys['d'] || keys['D']) xpos += speed;
  }

  void pointTowardsMouse() {
    targetAngle = atan2(mouseY - ypos, mouseX - xpos);
    facingLeft = mouseX < xpos;
    float angleDiff = targetAngle - angle;
    if (angleDiff > PI) angleDiff -= TWO_PI;
    if (angleDiff < -PI) angleDiff += TWO_PI;
    angle += angleDiff * rotationSmoothingSpeed;
    if (angle > TWO_PI) angle -= TWO_PI;
    if (angle < 0) angle += TWO_PI;
    if (targetAngle > TWO_PI) targetAngle -= TWO_PI;
    if (targetAngle < 0) targetAngle += TWO_PI;
  }

  void drawGun() {
    pushMatrix();
    translate(xpos, ypos);
    float displayAngle = angle + (facingLeft ? -recoilAngle : recoilAngle);
    if (facingLeft) {
      scale(-1, 1);
      rotate(PI - displayAngle);
    } else rotate(displayAngle);
    fill(metalGrey);
    noStroke();

    pushMatrix();
    strokeWeight(16);
    stroke(metalGrey);
    stroke(130);
    line(0, 0, handleLength * cos(handleSlant), handleLength * sin(handleSlant));
    popMatrix();

    fill(metalGrey);
    rect(0, -barrelGirth/2 - 8, barrelLength, barrelGirth);
    drawDecor();
    popMatrix();
  }

  void drawDecor() {
    noStroke();
    for (int i = 0; i < numDecorativeShapes; i++) {
      float x = shapePositions[i];
      float y = -barrelGirth/2 - 8 + shapeOffsets[i];
      pushMatrix();
      translate(x, y);
      fill(shapeColors[i]);
      if (shapeTypes[i] == 0) {
        beginShape();
        vertex(-shapeWidths[i]/2, -shapeHeights[i]/2);
        vertex(shapeWidths[i]/2, -shapeHeights[i]/2);
        vertex(shapeTopWidths[i]/2, shapeHeights[i]/2);
        vertex(-shapeTopWidths[i]/2, shapeHeights[i]/2);
        endShape(CLOSE);
      } else if (shapeTypes[i] == 1) {
        ellipse(0, 0, shapeWidths[i], shapeHeights[i]);
      } else {
        rect(-shapeWidths[i]/2, -shapeHeights[i]/2, shapeWidths[i], shapeHeights[i]);
      }
      popMatrix();
    }
  }

  Bullet createBullet() {
    float recoilAmount = radians(bulletSize * 0.5);
    recoilAngle -= recoilAmount;
    float patternIndex = (spreadPatternLength == 0) ? 0 : (shotsFired % spreadPatternLength);
    float spreadStep = spreadPatternLength <= 1 ? 0 : map(patternIndex, 0, spreadPatternLength - 1, -1, 1);
    float spreadRadians = radians(bulletSpreadDegrees) * spreadStep;
    float effectiveRecoil = facingLeft ? -recoilAngle : recoilAngle;
    float shotAngle = angle + effectiveRecoil + spreadRadians;
    float bx = xpos + cos(shotAngle) * barrelLength;
    float by = ypos + sin(shotAngle) * barrelLength;
    float vx = cos(shotAngle) * bulletSpeed;
    float vy = sin(shotAngle) * bulletSpeed;
    return new Bullet(bx, by, vx, vy, bulletSize, bulletColor, bulletTrajectory);
  }

  void fireShotgunPellets() {
    float recoilAmount =+ radians(bulletSize * 0.5 * (1 + pelletCount * 0.1));
    recoilAngle -= recoilAmount;
    float spreadRadians = radians(shotgunSpreadDegrees);
    float effectiveRecoil = facingLeft ? -recoilAngle : recoilAngle;
    for (int i = 0; i < pelletCount; i++) {
      float pelletSpread = map(i, 0, pelletCount - 1, -spreadRadians/2, spreadRadians/2);
      float pelletAngle = angle + effectiveRecoil + pelletSpread;
      float px = xpos + cos(pelletAngle) * barrelLength;
      float py = ypos + sin(pelletAngle) * barrelLength;
      float vx = cos(pelletAngle) * bulletSpeed;
      float vy = sin(pelletAngle) * bulletSpeed;
      bullets.add(new Bullet(px, py, vx, vy, bulletSize, bulletColor, bulletTrajectory));
    }
  }
}
class Balloon {
  float xpos, ypos;
  float velX, velY;
  int strength;
  float baseRadius = 20;
  color[] layerColors = {color(255, 50, 50), color(255, 150, 50), color(255, 255, 50), color(150, 255, 20), color(100, 200, 200), color(50, 100, 255)};

  Balloon(float x, float y, int str) {
    xpos = x;
    ypos = y;
    strength = str;
    velX = random(-2, 2);
    velY = random(-2, 2);
  }

  void update(int level) {
    float speedMultiplier = 0.5 + (level * 0.3);
    xpos += velX * speedMultiplier;
    ypos += velY * speedMultiplier;

    if (xpos - getRadius() < 0 || xpos + getRadius() > width) velX *= -1;

    if (ypos - getRadius() < 0 || ypos + getRadius() > height) velY *= -1;
    xpos = constrain(xpos, getRadius(), width - getRadius());
    ypos = constrain(ypos, getRadius(), height - getRadius());
  }

  void display() {
    for (int i = strength - 1; i >= 0; i--) {
      float r = baseRadius + (i * 15);
      fill(layerColors[i % layerColors.length]);
      stroke(255);
      strokeWeight(2);
      circle(xpos, ypos, r * 2);
    }
  }
  float getRadius() {
    return baseRadius + ((strength - 1) * 15);
  }
  void takeDamage() {
    strength--;
  }
  boolean isDead() {
    return strength <= 0;
  }
  boolean isOffScreen() {
    return xpos < -100 || xpos > width + 100 || ypos < -100 || ypos > height + 100;
  }
}

class Bullet {
  float xpos, ypos;
  float velX, velY;
  float size = 5;
  color bulletColor;
  int trajectory;
  float wavePhase = 0;
  float gravity = 0.15;

  Bullet(float x, float y, float vx, float vy) {
    xpos = x;
    ypos = y;
    velX = vx;
    velY = vy;
    bulletColor = color(255, 255, 150);
    trajectory = 0;
  }
  Bullet(float x, float y, float vx, float vy, float s, color c, int t) {
    xpos = x;
    ypos = y;
    velX = vx;
    velY = vy;
    size = s;
    bulletColor = c;
    trajectory = t;
  }
  void update() {
    if (trajectory == 0) { // Straight
      xpos += velX;
      ypos += velY;
    } else if (trajectory == 1) { // Sine wave
      xpos += velX;
      ypos += velY + sin(wavePhase) * 2;
      wavePhase += 0.1;
    } else if (trajectory == 2) { // Free fall
      xpos += velX;
      ypos += velY;
      velY += gravity;
    }
  }

  void display() {
    fill(bulletColor);
    stroke(red(bulletColor) * 0.8, green(bulletColor) * 0.8, blue(bulletColor) * 0.8);
    strokeWeight(1);
    circle(xpos, ypos, size);
  }
  boolean isOffScreen() {
    return xpos < 0 || xpos > width || ypos < 0 || ypos > height;
  }
  boolean collidesWith(Balloon b) {
    return dist(xpos, ypos, b.xpos, b.ypos) < size/2 + b.getRadius();
  }
}
