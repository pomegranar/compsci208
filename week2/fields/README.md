# Anar's Vector Fields

## The rule-set:

1. Divide the canvas into tiles.
2. Assign each tile a random vector field. 
3. Create 3 line-drawing entities that traverse the canvas, whose direction is affected by the vector fields. 
4. Tweak parameters such as fade speed, line speed, line weight, vector field possible ranges. 

## Usage

Open the file `fields.pde` in Processing and hit play.

## The story

The inspiration struck when I wanted to create a line-drawing entity with its own sense of direction and logic, combined with strict geometry. I figured that I can have both if they existed in different dimensions, so I put the line drawers in the normal x-y plane, and then had a tiling geometry exist in the realm of vector spaces. Thus, I didn't need to code randomness into the lines, rather I only needed to focus on making vector spaces that affected the lines in an interesting way. 
