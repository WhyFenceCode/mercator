# Buffer Assignments
### My way of keeping track. Also makes edits easier.

## Color Tex 0
Normal color data that will be outputed in the end to the screen.
### Assigned:
Assigned in `composite/lighting`
### Used:
Most subsequent programs

## Color Tex 1
Base color as recived from `gl_Color`
### Assigned:
Assigned in `gbuffers/data_writer`
### Used:
- `composite/lighting`

## Color Tex 2
Base lightmap with x as sun and y as torch
### Assigned:
Assigned in `gbuffers/data_writer`
### Used:
- `composite/lighting`

## Color Tex 3
Normal as recived from `gl_Normal`
### Assigned:
Assigned in `gbuffers/data_writer`
### Used:
- `composite/lighting`

## Color Tex 4
Shadow data from the shadow map in screen space
### Assigned:
Assigned in `composite/shadow_writer`
### Used:
- To be used in `composite/shadow_blur`
- To be used in `composite/lighting`