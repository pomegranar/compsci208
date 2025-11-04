# Anar's DKU Tessellation

An animated tessellation of the DKU logo shape I made using Processing 4 Java Mode. 

## Usage

Open the file `tessellation.pde` in Processing and hit play.

The noise seed can be randomized by hitting <kbd>Space</kbd>.

## The story

My goal was to create something that involved a tessellation, so I had to tile something using Processing. Thus, I had to create a shape first, and chose to go with a simple hexagon tiling, since I knew that the math-properties of a hexagon could make for some really cool patterns. I just needed to set my fills to something semi-transparent, and hope to mess up my code in an interesting way. Luckily, I messed up my code super early on, while I was determining the x-displacement in the first for loop. I forgot to multiply the displacement by 3, so the resulting pattern had a lot of hourglass-looking shapes, which started to look a lot like my university's logo! 

Just one problem–DKU's logo isn't just triangles, the bottom two portions are actually circular **sectors**. Using the little trigonometry I remembered, I thought of a way to create the illusion of a circular segment glued onto the sides of my hexagons, which overlapped in the right way, would resemble the DKU logo. ChatGPT couldn't give me the correct sine and cosine values for my very specific scenario, so I had to do the math on my own, which was the most tedious part in creating the whole artwork. 

As for the colors, I wanted the hue and saturation to be randomly determined by the positional noise, and the opacity by the time-determined noise. The resulting random HSB colors turned out to prefer a green-blue hue for some reason I still don't understand, so I kept it. 


