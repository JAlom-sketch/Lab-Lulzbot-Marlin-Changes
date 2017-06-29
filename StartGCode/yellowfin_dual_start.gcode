; This profile is designed specifically for LulzBot TAZ6 3D Printer with the Yellowfin Dual
; Last updated: 6/29/2017
G26                          ; clear potential 'probe fail' condition
G21                          ; set units to Millimetres
M107                         ; disable fans
G90                          ; absolute positioning
; Start heating filament and bed as soon as possible
M104 S{material_soften_temperature_0} T0               ; soften filament
M104 S{material_soften_temperature_1} T1               ; soften filament
M140 S{material_bed_temperature}; get bed heating up
; Initial motion so user knows print is starting
G28 X Y                      ; home X and Y
G1 X-22 Y260 F3000           ; move over the Z_MIN switch
; Increase temperature to soften filament
M117 Heating...              ; LCD status message
M109 R{material_soften_temperature_0} T0               ; wait for temp
M109 R{material_soften_temperature_1} T1               ; wait for temp
; Do Z homing
T0                           ; return to first extruder
G28 Z                        ; home Z
G92 Z15.5                    ; account for raised home button
; Retracting filament in preparation for probe to avoid failures
T0                           ; select this extruder first
M82                          ; set extruder to absolute mode
G92 E0                       ; set extruder to zero
G1  E-15 F100                ; suck up XXmm of filament
T1                           ; switch extruders
M82                          ; set extruder to absolute mode
G92 E0                       ; set extruder to zero
G1  E-15 F100                ; suck up XXmm of filament
; Nozzle wipe sequence
M104 S{material_wipe_temperature_0} T0                 ; set to wipe temp
M104 S{material_wipe_temperature_1} T1                 ; set to wipe temp
M106                         ; Turn on fans to speed cooling
G1 X-22 Y100 F3000           ; move above wiper pad
M104
M117 Cooling...              ; LCD status message
M109 R{material_wipe_temperature_0} T0                 ; wait for T0 to reach temp
M109 R{material_wipe_temperature_1} T1                 ; wait for T1 to reach temp
M107                         ; Turn off fan
; Nozzle wipe sequence
T0                           ; switch extruders
G1 Z1                        ; push nozzle into wiper
G1 X-22  Y100 F1000            ; slow wipe
G1 X-22 Y30 F1000            ; slow wipe
G1 X-22  Y100 F1000            ; slow wipe
G1 X-22 Y30 F1000            ; slow wipe
G1 X-22  Y100 F1000            ; slow wipe
G1 X-22 Y30 F1000            ; slow wipe
G1 X-22  Y100 F2000            ; fast wipe
G1 X-22 Y30 F2000            ; fast wipe
G1 X-22  Y100 F2000            ; fast wipe
G1 X-22 Y30 F2000            ; fast wipe
G1 X-22  Y100 F2000            ; fast wipe
G1 Z10                       ; raise extruder
M109 R{material_probe_temperature_0}                   ; heat to probe temp
G1 X-9 Y-9                   ; move above first probe point
M204 S100                    ; set accel for probing
G29                          ; probe sequence (for auto-leveling)
M204 S500                    ; set accel back to normal
G1 X20 F5000                 ; clear homing button riser
M104 S{material_print_temperature_0} T0 ; set extruder temp
M104 S{material_print_temperature_1} T1; set extruder temp
G1 X98 Y-18 Z0.5 F3000       ; move to open space
M400                         ; clear buffer
M117 Heating...              ; LCD status message
M109 R{material_print_temperature_0} T0 ; set extruder temp and wait
M109 R{material_print_temperature_1} T1; set extruder temp and wait
; Material may be retracted inside print head from previous dual print.
; Purge material to make sure both extruders are even.
M117 Purging...              ; LCD status message
T0                           ; select this extruder first
G1  E0 F100                  ; undo retraction
G92 E-15                     ; set extruder negative amount to purge
G1  E0 F100                  ; purge XXmm of filament
T1                           ; switch to second extruder
G1  E0 F100                  ; undo retraction
G92 E-15                     ; set extruder negative amount to purge
G1  E0 F100                  ; purge XXmm of filament
; Shear off purged filament
G1 Z0.5                      ; clear bed (barely)
G1 X98 Y0 F5000              ; move above bed to shear off filament
T0                           ; switch to first extruder
M190 S{print_bed_temperature}; get bed temping up during first layer
G1 Z2 E0 F75
M400                         ; clear buffer
M117 TAZ Printing...         ; LCD status message
