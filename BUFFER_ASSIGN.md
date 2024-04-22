# Buffer Assignments
### My way of keeping track. Also makes edits easier.

## Shadow Tex 0
Shadow Data in shadow space.
### Assigned:
`shadow/shadow`
### Used:
`composite/shadow_writer`

## Color Tex 0
Normal color data that will be outputed in the end to the screen.
### Assigned:
`composite/lighting`
### Used:
Most subsequent programs

## Color Tex 1
Base color as recived from `gl_Color`
### Assigned:
`gbuffers/data_writer`
### Used:
- `composite/lighting`

## Color Tex 2
Base lightmap with x as sun and y as torch
### Assigned:
`gbuffers/data_writer`
### Used:
- `composite/lighting`

## Color Tex 3
Normal as recived from `gl_Normal`
### Assigned:
`gbuffers/data_writer`
### Used:
- `composite/lighting`

## Color Tex 4
Shadow data from the shadow map in screen space
### Assigned:
`composite/shadow_writer`
### Used:
- `composite/lighting`

## Color Tex 5
AutoExposure Buffer Used for Halflife.
### Assigned:
`composite/tonemap`
### Used:
- `composite/tonemap`