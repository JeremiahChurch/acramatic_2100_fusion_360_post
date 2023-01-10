# Acramatic 2100 Fusion360 Post Processor

Extension and refinement of the standard autodesk/vickers provided post processor.

Probing extended via fanuc post processor

TODO:

- [ ] probing tested
- [ ] rotary 4th

### WORK IN PROGRESS

## Resources / References

### Probing G-code
* G75 internal corner
* G76 external corner
* G77 locate surface
* G78 bore buss
* G79 pocket or web
* G51 vector probe

### Tooling G-code
* G68 set tool size
* G69 check tool size


### Probe Cycle Parameter Table (pg 380)

| cycle                                   | program reference | range      | usage                                                                                                                                            |
|-----------------------------------------|-------------------|------------|--------------------------------------------------------------------------------------------------------------------------------------------------|
| Probe Approach Feed rate                | PRB_APPR_FRT      | 0 to 999in | Specifies probe approach feed rate for first probe contact                                                                                       |
| Dimensions Probe  measurement feed rate | PRB_MEAS_FRT      | 0 to 999in | Specifies probe approach feed rate on a second measurement move following the initial hit. This value is selected when the Q word = 0 or absent. |
| Rotating Tool Retract distance          | FIX_PRB_RRET      | 0 to 99in  | Specifies spindle running retract distance following the initial probe hit                                                                       |
| Probe Gage Height                       | PROBE_GH          | 0 to 9.9in | Specifies retract distance after a probe hit                                                                                                     |
|  +X Stylus Tip Dimension                | X_POS_TIP         | 0 to 9.9in | Specifies stylus tip offset for the probe used.                                                                                                  |
|  --X Stylus Tip Dimension               | X_NEG_TIP         | 0 to 9.9in | Specifies stylus tip offset for the probe used.                                                                                                  |
|  +Y Stylus Tip Dimension                | Y_POS_TIP         | 0 to 9.9in | Specifies stylus tip offset for the probe used.                                                                                                  |
|  --Y Stylus Tip Dimension               | Y_NEG_TIP         | 0 to 9.9in | Specifies stylus tip offset for the probe used.                                                                                                  |
| Tram Surface                            | TRAM_SURFACE      | 0 to 99in  | Reference from machine table surface or fixture. Usually established with precision gage blocks.                                                 |
| Fixed Probe Tram Surface                | FIX_PRB_TRAM      | 0 to 99in  | Specifies top position of fixed probe stylus.                                                                                                    |
| Fixed Probe clearance height            | PRB_PRB_CLR       | 0 to 999in | Is the value added to the Probe Tram surface above the top of the Probe                                                                          |

### Probe system variables (pg 385)				

| name            | definition                                                                                                                                                                                                          | field name                | description         |
|-----------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------|---------------------|
| [$PRB_DIA_ERR]  | Probe Tool Error contains the tool diameter deviation as measured by the fixed probe in a G69 cycle                                                                                                                 |                           | 0 - 99999mm         |
| [$PRB_PART_LOC] | Probe Part Location is the coordinates of the measured part feature for G75--79 probe cycles.                                                                                                                       | X, Y, Z                   | 0 - 99999mm         |
| [$PROBE_POS_MC] | Location of the most recent probe hit in machine coordinates                                                                                                                                                        | X, Y, Z, U, V, W, A, B, C | 0 - 99999mm         |
| [$PROBE_POS_PC] | Location of the most recent probe hit in program coordinates                                                                                                                                                        | X, Y, Z, U, V, W, A, B, C | 0 - 99999mm         |
| [$PRB_TOOL_ERR] | Probe Tool Error contains the tool length deviation as measured by the fixed probe in a G69 cycle                                                                                                                   |                           | 0 - 99999mm         |
| [$PRB_WIDTH]    | Measured width of a pocket or web after a G79 probe cycle                                                                                                                                                           |                           | 0 - 99999mm         |
| [$PRB_A_ANGLE]  | Angle between two measured points in the Y axis plane, R word specifies rotary A axis                                                                                                                               | R                         |                     |
| [$PRB_B_ANGLE]  | Angle between two measured points in the X axis plane, P word specifies rotary B axis                                                                                                                               | P                         |                     |
| [$PRB_INCL_ANG] | Angle data used by G51.4 and G51.5 for second measurement positioning                                                                                                                                               |                           |                     |
| [$PRB_X_ANGLE]  | Is the computed X axis side of the corner when P word is programmed (G75 and G76)                                                                                                                                   | P                         |                     |
| [$PRB_X_DIA]    | Measured X axis diameter of a bore or boss after a G78 probe cycle.                                                                                                                                                 |                           |                     |
| [$PRB_Y_ANGLE]  | Is the computed Y axis side of the corner when R word is programmed (G75 and G76)                                                                                                                                   |                           | 0 - 99999mm         |
| [$PRB_Y_DIA]    | Measured Y axis diameter of a bore or boss after a G78 probe cycle                                                                                                                                                  | R                         |                     |
| [$PROBE_HIT]    | Probe Hit is set to true (1) by the G75--79 probe cycles if a probe hit occurs during the probe cycle. Following a probe cycle, this value is true if the probe hit the part and false (0) if no probe hit occurred |                           | 0 - 99999mm         |
| [$SIZE_ERROR]   | True position value plus tool offset                                                                                                                                                                                | X, Y, Z                   |                     |
| [$TOL_EXCEEDED] | Measured size error exceeds U word value                                                                                                                                                                            |                           | 0 = false, true = 1 |
| [$TOOL_PRB_LOC] | Measured Tool Probe Location                                                                                                                                                                                        | X, Y                      | 0 - 99999mm         |
