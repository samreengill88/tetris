################ CSC258H1F Winter 2024 Assembly Final Project ##################
# This file contains our implementation of Tetris.
#
# Student 1: Jechang (Chris) Oh, 1008894216
# Student 2: Samreen Kaur, 1009200507
######################## Bitmap Display Configuration ########################
# - Unit width in pixels:       1
# - Unit height in pixels:      1
# - Display width in pixels:    64
# - Display height in pixels:   100
# - Base Address for Display:   0x10008000 ($gp)
##############################################################################
    .data
##############################################################################
# Immutable Data
##############################################################################
ADDR_DSPL:          .word 0x10008000
END_OF_GRID:        .word 0x1000DFFC
GAME_OVER_LINE:     .word 0x1000B000
ADDR_KBRD:          .word 0xffff0000
BLACK:              .word 0x000000
GREY:               .word 0xBBBBBB
BOTTOM_GREY:        .word 0xBBBBBC
LIGHTGREY:          .word 0xEEEEEE
GREEN:              .word 0x35EE00
PURPLE:             .word 0xA020F0
LANDED_PURPLE:      .word 0xA020F1
RED:                .word 0xFF0000
PAUSED_RED:         .word 0xFF0001
ORANGE:             .word 0xFFA500
WHITE:              .word 0xFFFFFF

min_value:          .word   0            # Minimum value for random number generation
max_value:          .word   64           # Maximum value for random number generation
    
PAUSED_LOCATIONS: .word 5972, 5976, 5980, 6228, 6236, 6484, 6488, 6492, 6740, 5988, 5992, 5996, 6244, 6252, 6500, 6504, 6508, 6756, 6764, 6004, 
                        6012, 6260, 6268, 6516, 6524, 6772, 6776, 6780, 6020, 6024, 6028, 6276, 6540, 6788, 6792, 6796, 6036, 6040, 6044, 6292, 
                        6548, 6552, 6804, 6808, 6812, 6052, 6056, 6308, 6316, 6564, 6572, 6820, 6824
                 
GAME_OVER_LOCATIONS: .word 5976, 5980, 5984, 6232, 6488, 6496, 6744, 6748, 6752, 5992, 5996, 6000, 6248, 6256, 6504, 6508, 6512, 6760, 6768, 
                           6008, 6016, 6264, 6268, 6272, 6520, 6528, 6776, 6784, 6024, 6028, 6032, 6280, 6536, 6540, 6796, 6792, 6800, 7288, 
                           7292, 7296, 7544, 7552, 7800, 7808, 8056, 8060, 8064, 7304, 7312, 7560, 7568, 7816, 7824, 8076, 7320, 7324, 7328, 
                           7576, 7832, 7836, 8088, 8092, 8096, 7336, 7340, 7344, 7592, 7600, 7848, 7852, 8104, 8112

OBSTACLE_1_LOCATIONS: .word 24088, 24092, 24344, 24348, 24080, 24084, 24336, 24340, 23568, 23572, 23824, 23828, 23056, 23060, 23312, 23316,
                            24112, 24116, 24120, 24124, 24128, 24132, 24136, 24140, 24144, 24148, 24152, 24156, 24160, 24164, 24168, 24172,
                            24176, 24180, 24184, 24188, 24192, 24196, 24200, 24204, 24208, 24212, 24216, 24220, 24224, 24228, 24232, 24236,
                            24240, 24244, 24248, 24252, 24256, 24260, 24264, 24268, 24272, 24276, 24280, 24284, 24288, 24292, 24296, 24300,
                            24368, 24372, 24376, 24380, 24384, 24388, 24392, 24396, 24400, 24404, 24408, 24412, 24416, 24420, 24424, 24428,
                            24432, 24436, 24440, 24444, 24448, 24452, 24456, 24460, 24464, 24468, 24472, 24476, 24480, 24484, 24488, 24492,
                            24496, 24500, 24504, 24508, 24512, 24516, 24520, 24524, 24528, 24532, 24536, 24540, 24544, 24548, 24552, 24556
                            
OBSTACLE_2_LOCATIONS: .word 24088, 24092, 24344, 24348, 24352, 24356, 24360, 24364, 24096, 24100, 24104, 24108,
                            24112, 24116, 24120, 24124, 24128, 24132, 24136, 24140, 24144, 24148, 24152, 24156, 24160, 24164, 24168, 24172,
                            24192, 24196, 24200, 24204, 24208, 24212, 24216, 24220, 24224, 24228, 24232, 24236,
                            24240, 24244, 24248, 24252, 24256, 24260, 24264, 24268, 24272, 24276, 24280, 24284, 24288, 24292, 24296, 24300,
                            24368, 24372, 24376, 24380, 24384, 24388, 24392, 24396, 24400, 24404, 24408, 24412, 24416, 24420, 24424, 24428,
                            24448, 24452, 24456, 24460, 24464, 24468, 24472, 24476, 24480, 24484, 24488, 24492,
                            24496, 24500, 24504, 24508, 24512, 24516, 24520, 24524, 24528, 24532, 24536, 24540, 24544, 24548, 24552, 24556

SCORE_LOCATIONS: .word 2172, 2176, 2180, 2184, 2188, 2192, 2196, 2200, 2428, 2684, 2940, 3196, 3452, 3708, 3964, 4220, 4476, 4732, 4988, 4992, 
                       4996, 5000, 5004, 5008, 5012, 5016, 4760, 4504, 4248, 3992, 3736, 3480, 3224, 2968, 2712, 2456, 2132, 2136, 2140, 2144, 
                       2148, 2152, 2156, 2160, 2388, 2644, 2900, 3156, 3412, 3668, 3924, 4180, 4436, 4692, 4948, 4952, 4956, 4960, 4964, 4968, 
                       4972, 4976, 4720, 4464, 4208, 3952, 3696, 3440, 3184, 2928, 2672, 2416

ONES_DIGIT_ONE:     .word 2172, 2176, 2180, 2184, 2188, 2192, 2196, 2428, 2684, 2940, 3196, 3452, 3708, 3964, 4220, 4476, 4732, 4988, 4992, 4996, 
                          5000, 5004, 5008, 5012
ONES_DIGIT_TWO:     .word 2428, 2684, 2940, 3196, 4760, 4504, 4248, 3992, 3736
ONES_DIGIT_THREE:   .word 2428, 2684, 2940, 3196, 3708, 3964, 4220, 4476, 4732
ONES_DIGIT_FOUR:    .word 2176, 2180, 2184, 2188, 2192, 2196, 3452, 3708, 3964, 4220, 4476, 4732, 4988, 4992, 4996, 5000, 5004, 5008, 5012
ONES_DIGIT_FIVE:    .word 3708, 3964, 4220, 4476, 4732, 3224, 2968, 2712, 2456
ONES_DIGIT_SIX:     .word 3224, 2968, 2712, 2456
ONES_DIGIT_SEVEN:   .word 2428, 2684, 2940, 3196, 3452, 3708, 3964, 4220, 4476, 4732, 4988, 4992, 4996, 5000, 5004, 5008, 5012
ONES_DIGIT_NINE:    .word 3708, 3964, 4220, 4476, 4732, 4988, 4992, 4996, 5000, 5004, 5008, 5012

TENS_DIGIT_ONE:     .word 2132, 2136, 2140, 2144, 2148, 2152, 2156, 2388, 2644, 2900, 3156, 3412, 3668, 3924, 4180, 4436, 4692, 4948, 4952, 4956, 
                          4960, 4964, 4968, 4972
TENS_DIGIT_TWO:     .word 2388, 2644, 2900, 3156, 4720, 4464, 4208, 3952, 3696
TENS_DIGIT_THREE:   .word 2388, 2644, 2900, 3156, 3668, 3924, 4180, 4436, 4692
TENS_DIGIT_FOUR:    .word 2136, 2140, 2144, 2148, 2152, 2156, 3412, 3668, 3924, 4180, 4436, 4692, 4948, 4952, 4956, 4960, 4964, 4968, 4972
TENS_DIGIT_FIVE:    .word 3668, 3924, 4180, 4436, 4692, 3184, 2928, 2672, 2416
TENS_DIGIT_SIX:     .word 3184, 2928, 2672, 2416
TENS_DIGIT_SEVEN:   .word 2388, 2644, 2900, 3156, 3412, 3668, 3924, 4180, 4436, 4692, 4948, 4952, 4956, 4960, 4964, 4968, 4972
TENS_DIGIT_NINE:    .word 3668, 3924, 4180, 4436, 4692, 4948, 4952, 4956, 4960, 4964, 4968, 4972

##############################################################################
# Mutable Data
##############################################################################
tetromino_s_1:                  .word 0x1000A280   # Initial coordinate of the S tetromino (bottom left)
tetromino_s_2:                  .word 0x1000A280   # Initial coordinate of the S tetromino (bottom middle)
tetromino_s_3:                  .word 0x1000A280   # Initial coordinate of the S tetromino (top middle)
tetromino_s_4:                  .word 0x1000A280   # Initial coordinate of the S tetromino (top right)
tetromino_s_rotation_status:    .word 0x10008000   # Initial status is 0x10008000 (S), 0x10008004 is rotated
tetromino_color:                .word 0xA020F0     # Current color of the tetromino
tetromino_shape:                .word 0x000000     # Current shape of the tetromino (e.g., S shape)
game_paused:                    .word 0            # Initialize to 0 (not paused)
    
##############################################################################
# Code
##############################################################################
	.text
	.globl main

main:
    # Initialize the game
    lw $t1, GREY            # Load the color GREY
    lw $t0, ADDR_DSPL       # Load the base address of the display into $t0
    li $t7, 0               # Function counter
    li $t8, 800             # Function end iteration
    li $s0, 0               # Status tracker for S tetromino
    li $s7, 0               # Score tracker

    li $t4, 4               # Inner loop max
    li $t5, 0               # Counter
    li $t6, 100             # Outer loop max
    
    jal draw_walls_outer
    
    lw $t0, ADDR_DSPL       # Reset $t0 for right wall
    addi $t0, $t0, 240      # Move to the right by 240 pixels

draw_walls_outer:
    li $t2, 0                                 # Inner loop counter

    draw_walls_inner:
        addi $t7, $t7, 1
        sw $t1, 0($t0)
        addi $t0, $t0, 4
        addi $t2, $t2, 1
        beq $t7, $t8, end
        beq $t2, $t4, draw_walls_inner_end
        j draw_walls_inner
    
    draw_walls_inner_end:
        addi $t0, $t0, -12                    # Reset $t0
        addi $t0, $t0, 252
        addi $t5, $t5, 1
        beq $t5, $t6, walls_end
        j draw_walls_outer
    
walls_end:
    beq $t7, $t8, end
    jr $ra

end:
    li $t2, 4                   # Initialize loop counter for the third loop
    li $t3, 1012                # Set the limit for the bottom wall loop
    lw $t0, ADDR_DSPL           # Reset $t0
    lw $t1, BOTTOM_GREY         # Load the color BOTTOM_GREY for bottom wall
    
bottom_wall:
    sw $t1, 24592($t0)
    addi $t0, $t0, 4
    addi $t2, $t2, 4
    blt  $t2, $t3, bottom_wall

initial_obstacles_op0:    
    jal gen_rand_num
    
    lw $t1, GREEN
    obstacle_1:
        lw $t0, ADDR_DSPL                        # Value in $a0 = value in $t0
        li $t2, 0
        obstacle_1_loop_top:
            sw $t1, 24080($t0)
            addi $t0, $t0, 4                    # Move on to next block
            addi $t2, $t2, 4                    # Increment loop counter
            blt $t2, $a0, obstacle_1_loop_top
        
        lw $t0, ADDR_DSPL                        # Value in $a0 = value in $t0
        li $t2, 0
        obstacle_1_loop_bottom:
            sw $t1, 24336($t0)
            addi $t0, $t0, 4                    # Move on to next block
            addi $t2, $t2, 4                    # Increment loop counter
            blt $t2, $a0, obstacle_1_loop_bottom
    
    jal gen_rand_num
    
    lw $t1, ORANGE
    obstacle_2:
        lw $t0, ADDR_DSPL                        # Value in $a0 = value in $t0
        li $t2, 0
        subi $t3, $a0, 8
        obstacle_2_loop_top:
            sw $t1, 23576($t0)
            addi $t0, $t0, 4                    # Move on to next block
            addi $t2, $t2, 4                    # Increment loop counter
            blt $t2, $t3, obstacle_2_loop_top
        
        lw $t0, ADDR_DSPL                        # Value in $a0 = value in $t0
        li $t2, 0
        obstacle_2_loop_bottom:
            sw $t1, 23832($t0)
            addi $t0, $t0, 4                    # Move on to next block
            addi $t2, $t2, 4                    # Increment loop counter
            blt $t2, $t3, obstacle_2_loop_bottom
    
    jal gen_rand_num
    
    obstacle_3:
        lw $t0, ADDR_DSPL                        # Value in $a0 = value in $t0
        li $t2, 0
        obstacle_3_loop_top:
            sw $t1, 23276($t0)
            subi $t0, $t0, 4                    # Move on to next block
            addi $t2, $t2, 4                    # Increment loop counter
            blt $t2, $a0, obstacle_3_loop_top
        
        lw $t0, ADDR_DSPL                        # Value in $a0 = value in $t0
        li $t2, 0
        obstacle_3_loop_bottom:
            sw $t1, 23532($t0)
            subi $t0, $t0, 4                    # Move on to next block
            addi $t2, $t2, 4                    # Increment loop counter
            blt $t2, $a0, obstacle_3_loop_bottom
    
    jal gen_rand_num
    lw $t1, GREEN
    obstacle_4:
        lw $t0, ADDR_DSPL                       # Value in $a0 = value in $t0
        li $t2, 0
        # bgt $a0, 32, obstacle_4_loop_top
        # sra $t3, $a0, 3                         # Divide by 8
        obstacle_4_loop_top:
            sw $t1, 22764($t0)
            subi $t0, $t0, 4                    # Move on to next block
            addi $t2, $t2, 4                    # Increment loop counter
            blt $t2, $a0, obstacle_4_loop_top
        
        lw $t0, ADDR_DSPL                        # Value in $a0 = value in $t0
        li $t2, 0
        obstacle_4_loop_bottom:
            sw $t1, 23020($t0)
            subi $t0, $t0, 4                    # Move on to next block
            addi $t2, $t2, 4                    # Increment loop counter
            blt $t2, $a0, obstacle_4_loop_bottom
    
    jal gen_rand_num
    lw $t1, GREEN
    obstacle_5:
        lw $t0, ADDR_DSPL                       # Value in $a0 = value in $t0
        li $t2, 0
        # bgt $a0, 32, obstacle_5_loop_top
        # sra $t3, $a0, 3                         # Divide by 8
        obstacle_5_loop_top:
            sw $t1, 22148($t0)
            subi $t0, $t0, 4                    # Move on to next block
            addi $t2, $t2, 4                    # Increment loop counter
            blt $t2, $a0, obstacle_5_loop_top
        
        lw $t0, ADDR_DSPL                        # Value in $a0 = value in $t0
        li $t2, 0
        obstacle_5_loop_bottom:
            sw $t1, 22404($t0)
            subi $t0, $t0, 4                    # Move on to next block
            addi $t2, $t2, 4                    # Increment loop counter
            blt $t2, $a0, obstacle_5_loop_bottom
            
    j start_game

start_game:
    lw $t1, LIGHTGREY
    lw $t0, ADDR_DSPL
    sw $t1, 12296($t0)              # Game over line
    sw $t1, 12300($t0)
    sw $t1, 12528($t0)              
    sw $t1, 12532($t0)
    
    # lw $t1, GREEN
	# lw $t0, ADDR_DSPL
	# la $t2, OBSTACLE_1_LOCATIONS    
    
    # test_row_loop:
    # lw $t3, 0($t2)                   # Load the memory location from the array
    # add $t4, $t0, $t3                # Calculate the actual memory address
    # sw $t1, 0($t4)                   # Store RED at the memory location
    # addi $t2, $t2, 4                 # Move to the next memory location in the array
    # li $t5, 24556
    # bne $t3, $t5, test_row_loop
    
    # lw $t1, GREEN
	# lw $t0, ADDR_DSPL
	# la $t2, OBSTACLE_2_LOCATIONS    
    
    # test_row_loop_2:
    # lw $t3, 0($t2)                   # Load the memory location from the array
    # add $t4, $t0, $t3                # Calculate the actual memory address
    # addi $t4, $t4, -512
    # sw $t1, 0($t4)                   # Store RED at the memory location
    # addi $t2, $t2, 4                 # Move to the next memory location in the array
    # li $t5, 24556
    # bne $t3, $t5, test_row_loop_2
    
    jal reset_game_score
    
    # Reset values because walls and obstacles are finished
    lw $t0, ADDR_DSPL
    
    # Initial S tetromino is purple
    li $t9, 0

draw_tetromino:
    li $s5, 0           # Game status checker (0 means completed, 1 means still tetrominoes left)
    j repaint_screen
    
    check_if_row_cleared:
        beq $s2, 1, move_tetrominoes_down
    
    update_tetromino:
    li $s2, 0
    lw $t1, PURPLE                  # Make tetromino purple
    lw $t2, tetromino_s_1           # Set S_1 tetromino position
    lw $t3, tetromino_s_2           # Set S_2 tetromino position
    lw $t4, tetromino_s_3           # Set S_3 tetromino position
    lw $t5, tetromino_s_4           # Set S_4 tetromino position
    
    lw $t6, tetromino_shape     # Load the shape of the tetromino
    li $t7, 0x000000            # Load the value 0x000000 into $t5
    
    beq $t4, $t5, shape_is_S
    
    shape_is_S:
        #    X X
        #  X X
        sw $t1, 0($t5)        # Top right X
        sw $t1, 4($t5)        
        sw $t1, 256($t5)        
        sw $t1, 260($t5)        
        
        sw $t1, -8($t4)        # Top middle X
        sw $t1, -4($t4)        
        sw $t1, 248($t4)        
        sw $t1, 252($t4)        
        
        sw $t1, 504($t3)       # Bottom middle X
        sw $t1, 508($t3)       
        sw $t1, 760($t3)       
        sw $t1, 764($t3)       
        
        sw $t1, 496($t2)       # Bottom left X, 496
        sw $t1, 500($t2)       
        sw $t1, 752($t2)       
        sw $t1, 756($t2)
    
    li $t1, 0                      # Loop counter for check_game_over
    jal check_game_over
    
    lw $t0, ADDR_KBRD

game_loop:
    # Handle keyboard input
    jal handle_input
    
    update_position:
        # Update tetromino position based on input
        jal update_tetromino_position

    # Draw the screen with updated tetromino
    jal draw_tetromino

    j game_loop

handle_input:
    li 		$v0, 32
	li 		$a0, 1
	syscall

    lw $t0, ADDR_KBRD               # $t0 = base address for keyboard
    lw $t8, 0($t0)                  # Load first word from keyboard
    beq $t8, 1, keyboard_input
    b handle_input

keyboard_input:
    lw $a0, 4($t0)                  # Load second word from keyboard
    beq $a0, 0x61, respond_to_A     # Check if the key A was pressed
    beq $a0, 0x64, respond_to_D     # Check if the key D was pressed
    beq $a0, 0x73, respond_to_S     # Check if the key S was pressed
    beq $a0, 0x77, respond_to_W     # Check if the key W was pressed
    beq $a0, 0x70, respond_to_P     # Check if the key P was pressed
    beq $a0, 0x71, respond_to_Q     # Check if the key Q was pressed
    
    b handle_input
    
respond_to_A:
    li $v0, 33      # sync play note syscall
    li $a0, 60      # midi pitch
    li $a1, 10      # duration
    li $a2, 10      # instrument
    li $a3, 100     # volume
    syscall
    li $a1, 1
    j update_position
    
respond_to_D:
    li $v0, 33      # async play note syscall
    li $a0, 65      # midi pitch
    li $a1, 10      # duration
    li $a2, 10      # instrument
    li $a3, 100     # volume
    syscall
    li $a1, 2
    j update_position
    
respond_to_S:
    li $v0, 33    # async play note syscall
    li $a0, 70    # midi pitch
    li $a1, 10   # duration
    li $a2, 10     # instrument
    li $a3, 100   # volume
    syscall
    li $a1, 3
    j update_position

respond_to_W:
    li $v0, 33      # async play note syscall
    li $a0, 75      # midi pitch
    li $a1, 10      # duration
    li $a2, 10      # instrument
    li $a3, 100     # volume
    syscall
    li $a1, 4
    j update_position
    
update_tetromino_position:
    li $t1, 1
    li $t2, 2
    li $t3, 3
    li $t4, 4
    
    beq $a1, $t1, move_left
    beq $a1, $t2, move_right
    beq $a1, $t3, move_down
    beq $a1, $t4, rotate
    
    move_left:
        handle_left_collision:
            lw $t6, GREY
            lw $t7, GREEN
            lw $t8, LANDED_PURPLE
            beq $s0, 0, left_wall_check_0
            beq $s0, 1, left_wall_check_1
            beq $s0, 2, left_wall_check_2
            beq $s0, 3, left_wall_check_3
            
            left_wall_check_0:
                lw $t0, tetromino_s_1
                subi $t1, $t0, -488                   # Not sure why 20 but it works
                lw $t5, 0($t1)
                beq $t5, $t6, move_left_return      # Check if hit grey borders
                beq $t5, $t7, move_left_return      # Check if hit green obstacle
                lw $t7, ORANGE
                beq $t5, $t7, move_left_return
                beq $t5, $t8, move_left_return    # Check if hit landed purple
                j continue_move_left_s
            
            left_wall_check_1:
                lw $t0, tetromino_s_4
                subi $t1, $t0, 12
                lw $t5, 0($t1)
                beq $t5, $t6, move_left_return
                subi $t1, $t0, 268
                lw $t5, 0($t1)
                beq $t5, $t7, move_left_return      # Check if hit green obstacle
                lw $t7, ORANGE
                beq $t5, $t7, move_left_return
                beq $t5, $t8, move_left_return      # Check if hit landed purple
                j continue_move_left_s
            
            left_wall_check_2:                # This check works for both status 2 and 3
                lw $t0, tetromino_s_4
                subi $t1, $t0, 8
                lw $t5, 0($t1)
                beq $t5, $t6, move_left_return
                beq $t5, $t7, move_left_return      # Check if hit green obstacle
                lw $t7, ORANGE
                beq $t5, $t7, move_left_return
                beq $t5, $t8, move_left_return      # Check if hit landed purple
                j continue_move_left_s
            
            left_wall_check_3:
                lw $t0, tetromino_s_4
                subi $t1, $t0, 8
                lw $t5, 0($t1)
                beq $t5, $t6, move_left_return
                beq $t5, $t7, move_left_return      # Check if hit green obstacle
                lw $t7, ORANGE
                beq $t5, $t7, move_left_return
                beq $t5, $t8, move_left_return      # Check if hit landed purple
                
                subi $t1, $t0, -504
                lw $t5, 0($t1)
                beq $t5, $t6, move_left_return
                beq $t5, $t7, move_left_return      # Check if hit green obstacle
                lw $t7, ORANGE
                beq $t5, $t7, move_left_return
                beq $t5, $t8, move_left_return      # Check if hit landed purple
                
        continue_move_left_s:
        # Decrement x-coordinate by 2 (so 8 pixels)
        lw $t0, tetromino_s_1        # Load the position of the tetromino
        lw $t1, tetromino_s_2        
        lw $t2, tetromino_s_3        
        lw $t3, tetromino_s_4        
        subi $t0, $t0, 8             # Move to the left
        subi $t1, $t1, 8             
        subi $t2, $t2, 8             
        subi $t3, $t3, 8
        sw $t0, tetromino_s_1        # Store the updated coordinate
        sw $t1, tetromino_s_2        
        sw $t2, tetromino_s_3        
        sw $t3, tetromino_s_4        
    
    move_left_return:
        jr $ra                      # Return from the function
    
    move_right:
        handle_right_collision:
            lw $t6, GREY
            lw $t7, GREEN
            lw $t8, LANDED_PURPLE
            beq $s0, 0, right_wall_check_0
            beq $s0, 1, right_wall_check_1
            beq $s0, 2, right_wall_check_2_and_3
            beq $s0, 3, right_wall_check_2_and_3
            
            right_wall_check_0:
                lw $t0, tetromino_s_4
                subi $t1, $t0, -8                     # Check next right box
                lw $t5, 0($t1)
                beq $t5, $t6, move_right_return
                beq $t5, $t7, move_right_return
                lw $t7, ORANGE
                beq $t5, $t7, move_right_return
                lw $t0, tetromino_s_2
                subi $t1, $t0, -512                   # Check next right box
                lw $t5, 0($t1)
                beq $t5, $t7, move_right_return       # Check if hit obstacle
                lw $t7, ORANGE
                beq $t5, $t7, move_right_return
                beq $t5, $t8, move_right_return       # Check if hit S tetromino
                j continue_move_right_s
            
            right_wall_check_1:
                lw $t0, tetromino_s_4
                subi $t1, $t0, -8                   # Check next right box
                lw $t5, 0($t1)
                beq $t5, $t6, move_right_return
                beq $t5, $t7, move_right_return
                lw $t7, ORANGE
                beq $t5, $t7, move_right_return
                beq $t5, $t8, move_right_return
                j continue_move_right_s
            
            right_wall_check_2_and_3:              # This check works for both status 2 and 3
                lw $t0, tetromino_s_1
                subi $t1, $t0, 4                   # Not sure why but it works
                lw $t5, 0($t1)
                beq $t5, $t6, move_right_return
                beq $t5, $t7, move_right_return
                lw $t7, ORANGE
                beq $t5, $t7, move_right_return
                beq $t5, $t8, move_right_return
                subi $t1, $t0, -504
                lw $t5, 0($t1)
                beq $t5, $t7, move_right_return
                lw $t7, ORANGE
                beq $t5, $t7, move_right_return
                beq $t5, $t8, move_right_return
                lw $t0, tetromino_s_3
                subi $t1, $t0, -256                   # Check next right box
                lw $t5, 0($t1)
                beq $t5, $t6, move_right_return
                beq $t5, $t7, move_right_return       # Check if hit obstacle
                lw $t7, ORANGE
                beq $t5, $t7, move_right_return
                beq $t5, $t8, move_right_return
        
        continue_move_right_s:
        # Increment position by 2 (so 8 pixels)
        lw $t0, tetromino_s_1        # Load the position of the tetromino
        lw $t1, tetromino_s_2        
        lw $t2, tetromino_s_3        
        lw $t3, tetromino_s_4        
        subi $t0, $t0, -8            # Move to the right
        subi $t1, $t1, -8            
        subi $t2, $t2, -8            
        subi $t3, $t3, -8            
        sw $t0, tetromino_s_1        # Store the updated coordinate
        sw $t1, tetromino_s_2        
        sw $t2, tetromino_s_3        
        sw $t3, tetromino_s_4        
        
        move_right_return:
            jr $ra                                     # Return from the function
        
    move_down:
        handle_down_collision:
            lw $t6, GREY
            lw $t7, GREEN
            lw $t8, LANDED_PURPLE
            lw $t9, BOTTOM_GREY
            beq $s0, 0, bottom_wall_check_0
            beq $s0, 1, bottom_wall_check_1
            beq $s0, 2, bottom_wall_check_2
            beq $s0, 3, bottom_wall_check_3
            
            bottom_wall_check_0:
                lw $t0, tetromino_s_2
                subi $t1, $t0, -1008
                lw $t5, 0($t1)
                beq $t5, $t6, spawn_new_s
                beq $t5, $t7, spawn_new_s
                lw $t7, ORANGE
                beq $t5, $t7, spawn_new_s
                beq $t5, $t8, spawn_new_s
                beq $t5, $t9, spawn_new_s
                lw $t0, tetromino_s_2
                subi $t1, $t0, -1020
                lw $t5, 0($t1)
                beq $t5, $t6, spawn_new_s
                beq $t5, $t7, spawn_new_s
                lw $t7, ORANGE
                beq $t5, $t7, spawn_new_s
                beq $t5, $t8, spawn_new_s
                beq $t5, $t9, spawn_new_s
                lw $t0, tetromino_s_2
                subi $t1, $t0, -512
                lw $t5, 0($t1)
                beq $t5, $t6, spawn_new_s
                beq $t5, $t7, spawn_new_s
                lw $t7, ORANGE
                beq $t5, $t7, spawn_new_s
                beq $t5, $t8, spawn_new_s
                beq $t5, $t9, spawn_new_s
            
            bottom_wall_check_3:
                lw $t0, tetromino_s_1
                subi $t1, $t0, -1008
                lw $t5, 0($t1)
                beq $t5, $t6, spawn_new_s
                beq $t5, $t7, spawn_new_s
                lw $t7, ORANGE
                beq $t5, $t7, spawn_new_s
                beq $t5, $t8, spawn_new_s
                beq $t5, $t9, spawn_new_s
                lw $t0, tetromino_s_2
                subi $t1, $t0, -1008
                lw $t5, 0($t1)
                beq $t5, $t6, spawn_new_s
                beq $t5, $t7, spawn_new_s
                lw $t7, ORANGE
                beq $t5, $t7, spawn_new_s
                beq $t5, $t8, spawn_new_s
                beq $t5, $t9, spawn_new_s
                j continue_move_down_s
            
            bottom_wall_check_1:
                lw $t0, tetromino_s_4
                subi $t1, $t0, -252
                lw $t5, 0($t1)
                beq $t5, $t6, spawn_new_s
                beq $t5, $t7, spawn_new_s
                lw $t7, ORANGE
                beq $t5, $t7, spawn_new_s
                beq $t5, $t8, spawn_new_s
                beq $t5, $t9, spawn_new_s
                subi $t1, $t0, -516
                lw $t5, 0($t1)
                beq $t5, $t6, spawn_new_s
                lw $t7, GREEN
                beq $t5, $t7, spawn_new_s
                lw $t7, ORANGE
                beq $t5, $t7, spawn_new_s
                beq $t5, $t8, spawn_new_s
                beq $t5, $t9, spawn_new_s
            
            bottom_wall_check_2:
                lw $t0, tetromino_s_4
                subi $t1, $t0, -512
                lw $t5, 0($t1)
                beq $t5, $t6, spawn_new_s
                beq $t5, $t7, spawn_new_s
                lw $t7, ORANGE
                beq $t5, $t7, spawn_new_s
                beq $t5, $t8, spawn_new_s
                beq $t5, $t9, spawn_new_s
                subi $t1, $t0, -520
                lw $t5, 0($t1)
                beq $t5, $t6, spawn_new_s
                beq $t5, $t7, spawn_new_s
                lw $t7, ORANGE
                beq $t5, $t7, spawn_new_s
                beq $t5, $t8, spawn_new_s
                beq $t5, $t9, spawn_new_s
                subi $t1, $t0, -16
                # lw $t9, LANDED_PURPLE                 # Debugging
                # sw $t9, 0($t1)
                lw $t5, 0($t1)
                beq $t5, $t6, spawn_new_s
                beq $t5, $t7, spawn_new_s
                lw $t7, ORANGE
                beq $t5, $t7, spawn_new_s
                beq $t5, $t8, spawn_new_s
                beq $t5, $t9, spawn_new_s
                
        continue_move_down_s:
        lw $t0, tetromino_s_1        # Load the position of the tetromino
        lw $t1, tetromino_s_2        
        lw $t2, tetromino_s_3        
        lw $t3, tetromino_s_4        
        subi $t0, $t0, -512          # Move down a row
        subi $t1, $t1, -512          
        subi $t2, $t2, -512          
        subi $t3, $t3, -512
        sw $t0, tetromino_s_1        # Store the updated coordinate
        sw $t1, tetromino_s_2        
        sw $t2, tetromino_s_3        
        sw $t3, tetromino_s_4
        j move_down_return
        
        spawn_new_s:
            # Reset rotation status
            li $s0, 0
            lw $t1, LANDED_PURPLE         # Load the landed color of the tetromino
            continue_spawn_new_s:
            lw $t2, tetromino_s_1           # Set S_1 tetromino position
            lw $t3, tetromino_s_2           # Set S_2 tetromino position
            lw $t4, tetromino_s_3           # Set S_3 tetromino position
            lw $t5, tetromino_s_4           # Set S_4 tetromino position
            
            lw $t6, tetromino_shape     # Load the shape of the tetromino
            beq $t4, $t5, spawn_shape_is_S
            
            spawn_shape_is_S:
                sw $t1, 0($t5)        # Top right X
                sw $t1, 4($t5)        
                sw $t1, 256($t5)        
                sw $t1, 260($t5)        
                sw $t1, -8($t4)        # Top middle X
                sw $t1, -4($t4)        
                sw $t1, 248($t4)        
                sw $t1, 252($t4)        
                sw $t1, 504($t3)       # Bottom middle X
                sw $t1, 508($t3)       
                sw $t1, 760($t3)       
                sw $t1, 764($t3)       
                sw $t1, 496($t2)       # Bottom left X, 496
                sw $t1, 500($t2)       
                sw $t1, 752($t2)       
                sw $t1, 756($t2)
                
            li $t0, 0x1000A280
            sw $t0, tetromino_s_1
            li $t1, 0x1000A280
            sw $t1, tetromino_s_2
            li $t2, 0x1000A280
            sw $t2, tetromino_s_3
            li $t3, 0x1000A280
            sw $t3, tetromino_s_4
            li $t9, 0
        
        move_down_return:
            jr $ra                      # Return from the function
    
    rotate:        
        lw $t4, tetromino_s_rotation_status
        beq $s0, 0, s_status_0
        beq $s0, 1, s_status_1
        beq $s0, 2, s_status_2
        beq $s0, 3, s_status_3
        
        s_status_0:
            lw $t6, GREY
            lw $t7, GREEN
            lw $t8, LANDED_PURPLE
            lw $t0, tetromino_s_2
            subi $t1, $t0, -516                   # Check next right box
            lw $t5, 0($t1)       
            beq $t5, $t7, rotate_return
            beq $t5, $t8, rotate_return
            
            # rotates from S to standing position
            lw $t0, tetromino_s_1        # Load the S_1 position of the tetromino
            lw $t1, tetromino_s_2        # Load the S_2 position of the tetromino
            lw $t2, tetromino_s_3        # Load the S_3 position of the tetromino
            lw $t3, tetromino_s_4        # Load the S_4 position of the tetromino
            subi $t0, $t0, 1016          # Move S_1 to match status 0
            subi $t1, $t1, 512           # Move S_2 to match status 0
            subi $t2, $t2, -8            # Move S_3 to match status 0
            subi $t3, $t3, -512          # Move S_4 to match status 0
            sw $t0, tetromino_s_1        # Store the updated coordinate
            sw $t1, tetromino_s_2        # Store the updated coordinate
            sw $t2, tetromino_s_3        # Store the updated coordinate
            sw $t3, tetromino_s_4        # Store the updated coordinate
            
            # Update rotation status
            li $s0, 1
            
            j return_from_rotation_s
        
        s_status_1:
            lw $t6, GREY
            lw $t7, GREEN
            lw $t8, LANDED_PURPLE
            lw $t0, tetromino_s_3
            subi $t1, $t0, -4                   # Check next right box
            lw $t5, 0($t1)
            beq $t5, $t6, rotate_return
            beq $t5, $t7, rotate_return
            lw $t7, ORANGE
            beq $t5, $t7, rotate_return
            beq $t5, $t8, rotate_return
            
            # rotates from standing position to S
            lw $t0, tetromino_s_1        # Load the S_1 position of the tetromino
            lw $t1, tetromino_s_2        # Load the S_2 position of the tetromino
            lw $t2, tetromino_s_3        # Load the S_3 position of the tetromino
            lw $t3, tetromino_s_4        # Load the S_4 position of the tetromino
            subi $t0, $t0, -528          # Move S_1 to match status 1
            subi $t1, $t1, -8            # Move S_2 to match status 1
            subi $t2, $t2, -512          # Move S_3 to match status 1
            subi $t3, $t3, 8             # Move S_4 to match status 1
            sw $t0, tetromino_s_1        # Store the updated coordinate
            sw $t1, tetromino_s_2        # Store the updated coordinate
            sw $t2, tetromino_s_3        # Store the updated coordinate
            sw $t3, tetromino_s_4        # Store the updated coordinate
            
            # Update rotation status
            li $s0, 2
            
            rotate_return:
                j return_from_rotation_s
        
        s_status_2:
            lw $t6, GREY
            lw $t7, GREEN
            lw $t8, LANDED_PURPLE
            lw $t0, tetromino_s_3
            subi $t1, $t0, -256                   # Check next right box
            lw $t5, 0($t1)
            beq $t5, $t7, rotate_return
            lw $t7, ORANGE
            beq $t5, $t7, rotate_return
            beq $t5, $t8, rotate_return
            
            # rotates from S to standing position
            lw $t0, tetromino_s_1        # Load the S_1 position of the tetromino
            lw $t1, tetromino_s_2        # Load the S_2 position of the tetromino
            lw $t2, tetromino_s_3        # Load the S_3 position of the tetromino
            lw $t3, tetromino_s_4        # Load the S_4 position of the tetromino
            subi $t0, $t0, -512          # Move S_1 to match status 2
            subi $t1, $t1, -8            # Move S_2 to match status 2
            subi $t2, $t2, 512           # Move S_3 to match status 2
            subi $t3, $t3, 1016          # Move S_4 to match status 2
            sw $t0, tetromino_s_1        # Store the updated coordinate
            sw $t1, tetromino_s_2        # Store the updated coordinate
            sw $t2, tetromino_s_3        # Store the updated coordinate
            sw $t3, tetromino_s_4        # Store the updated coordinate
            
            # Update rotation status
            li $s0, 3
            
            j return_from_rotation_s
        
        s_status_3:
            lw $t6, GREY
            lw $t7, GREEN
            lw $t8, LANDED_PURPLE
            lw $t0, tetromino_s_2
            subi $t1, $t0, -4                   # Check next right box
            lw $t5, 0($t1)
            beq $t5, $t6, return_from_rotation_s
            beq $t5, $t7, return_from_rotation_s
            lw $t7, ORANGE
            beq $t5, $t7, return_from_rotation_s
            beq $t5, $t8, return_from_rotation_s
            
            # rotates from S to standing position
            lw $t0, tetromino_s_1        # Load the S_1 position of the tetromino
            lw $t1, tetromino_s_2        # Load the S_2 position of the tetromino
            lw $t2, tetromino_s_3        # Load the S_3 position of the tetromino
            lw $t3, tetromino_s_4        # Load the S_4 position of the tetromino
            subi $t0, $t0, 8             # Move S_1 to match status 3
            subi $t1, $t1, -512          # Move S_2 to match status 3
            subi $t2, $t2, -8            # Move S_3 to match status 3
            subi $t3, $t3, -528          # Move S_4 to match status 3
            sw $t0, tetromino_s_1        # Store the updated coordinate
            sw $t1, tetromino_s_2        # Store the updated coordinate
            sw $t2, tetromino_s_3        # Store the updated coordinate
            sw $t3, tetromino_s_4        # Store the updated coordinate
            
            # Update rotation status
            li $s0, 0
        
        return_from_rotation_s:
            jr $ra                      # Return from the function
            
repaint_screen:    
    li $t0, 0    # Row counter
    li $t1, 0    # Column counter
    
    # Outer loop: iterate through each row
    outer_loop:
        # Check if all rows are processed
        beq $t0, 400, end_iteration         # 100 * 4 = 400
        
        # Inner loop: iterate through each column
        li $t1, 0    # Reset column counter for each row
        li $t9, 0    # Full row counter
        inner_loop:
            # Calculate memory address of the current pixel
            mul $t2, $t0, 64   # Calculate offset for row
            add $t2, $t2, $t1   # Add column offset
            lw $t3, ADDR_DSPL   # Base address of display
            add $t3, $t3, $t2   # Calculate memory address
            
            # Load value of the pixel
            lw $t4, 0($t3)

            beq $t4, $zero, reset_full_row_counter
            lw $t8, BOTTOM_GREY
            beq $t4, $zero, reset_full_row_counter
            beq $t4, $t8, reset_full_row_counter
            addi $t9, $t9, 1                        # Increment row full counter
            j continue_color_check
            
            reset_full_row_counter:
            li $t9, 0
            j skip_update
            
            continue_color_check:        
            bne $t4, $zero, check_grey
            bne $t4, $zero, check_green_obstacle
            bne $t4, $zero, check_landed_purple
            bne $t4, $zero, check_red
            bne $t4, $zero, check_orange
            j skip_update
            
            check_grey:
            lw $t5, GREY
            beq $t4, $t5, skip_update
            lw $t5, BOTTOM_GREY
            beq $t4, $t5, skip_update
            lw $t5, LIGHTGREY
            beq $t4, $t5, skip_update
            
            check_green_obstacle:
            lw $t5, GREEN
            beq $t4, $t5, game_not_finished
            j check_landed_purple
            game_not_finished:
                addi $s5, $s5, 1
                j skip_update
            
            check_landed_purple:
            lw $t5, LANDED_PURPLE
            beq $t4, $t5, game_not_finished
            
            check_red:
            lw $t5, RED
            beq $t4, $t5, game_not_finished
            
            check_orange:
            lw $t5, ORANGE
            beq $t4, $t5, game_not_finished
            
            # Set pixel to black
            li $t4, 0x000000
            sw $t4, 0($t3)
            
            skip_update:
            # Increment column counter
            addi $t1, $t1, 4
            
            beq $t9, 64, clear_row
            j continue_inner_loop
            
                clear_row:
                    li $t7, 0                                   # Initialize clear row loop counter
                    clear_row_inner:
                        mul $t8, $t0, 64                        # Assuming each row has 64 columns
                        add $t8, $t8, $t7                       # Add column offset to the base address
                        lw $t4, ADDR_DSPL                       # Load base address of display
                        add $t3, $t4, $t8                       # Calculate memory address
                        
                        lw $t4, 0($t3)                          # Check colour
                        lw $t5, GREY
                        bne $t4, $t5, fill_in_black
                        j clear_row_next_i
                        
                        fill_in_black:
                            li $v0, 33    # async play note syscall
                            li $a0, 70    # midi pitch
                            li $a1, 10    # duration
                            li $a2, 127   # instrument
                            li $a3, 100   # volume
                            syscall
                            # Store colour in one register
                            lw $t6, -256($t3)
                            lw $t8, -252($t3)
                            lw $s1, -260($t3)
                            lw $s3, -4($t3)
                            lw $s4, 4($t3)
                            lw $s6, 260($t3)
                            lw $t2, 256($t3)
                            # Repaint with another register
                            lw $t4, WHITE
                            sw $t4, -256($t3)
                            sw $t4, -252($t3)
                            sw $t4, -260($t3)
                            sw $t4, -4($t3)
                            sw $t4, 4($t3)
                            sw $t4, 260($t3)
                            sw $t4, 256($t3)
                            # Delay
                            li $v0, 32                          # Syscall for sleep
                            li $a0, 5                           # Sleep for 1000 milliseconds (adjust as needed)
                            syscall                             # Call sleep syscall
                            # Paint back to original colour
                            sw $t6, -256($t3)
                            sw $t6, -256($t3)
                            sw $t8, -252($t3)
                            sw $s1, -260($t3)
                            sw $s3, -4($t3)
                            sw $s4, 4($t3)
                            sw $s6, 260($t3)
                            sw $t2, 256($t3)
                            # Delay
                            li $v0, 32                          # Syscall for sleep
                            li $a0, 5                           # Sleep for 1000 milliseconds (adjust as needed)
                            syscall                             # Call sleep syscall
                            
                            li $t4, 0x000000                    # KEEP THIS
                            sw $t4, 0($t3)
                            sw $t4, 256($t3)
                        clear_row_next_i:
                            addi $t7, $t7 4                     # Increment counter
                            blt $t7, 240, clear_row_inner
            
                            li $s2, 1                           # Row cleared marker
                            j continue_inner_loop
                    
            continue_inner_loop:
            # Continue inner loop if all columns are not processed
            blt $t1, 256, inner_loop                            # 64 * 4 = 256
        
        # Increment row counter
        addi $t0, $t0, 4
        
        # Continue outer loop
        j outer_loop
        
    end_iteration:
        beq $s5, $zero, game_won
        j game_not_won
        game_won:
            # Play clap sound
            li $v0, 33      # async play note syscall
            li $a0, 65      # midi pitch
            li $a1, 10      # duration
            li $a2, 10      # instrument
            li $a3, 100     # volume
            syscall
            j respond_to_Q
            
        game_not_won:
        j check_if_row_cleared

move_tetrominoes_down:
    li $t0, 0    # Row counter
    li $t1, 0    # Column counter
    
    outer_loop_down:
        beq $t0, 200, end_iteration_down         # 100 * 2 = 200 (no need to check all rows)
        li $t1, 0    # Reset column counter for each row
        inner_loop_down:
            mul $t2, $t0, 64   # Calculate offset for row
            add $t2, $t2, $t1   # Add column offset
            lw $t3, END_OF_GRID   # Base address of display
            sub $t3, $t3, $t2   # Calculate memory address
            
            lw $t4, 0($t3)
            
            beq $t4, $zero, skip_update_down
            lw $t8, BOTTOM_GREY
            beq $t4, $t8, skip_update_down
            lw $t8, GREY
            beq $t4, $t8, skip_update_down
            lw $t8, LIGHTGREY
            beq $t4, $t8, skip_update_down
            lw $t8, PURPLE
            beq $t4, $t8, skip_update_down
            
            shift_tetrominoes_down:
            lw $t5, 512($t3)
            lw $t6, BOTTOM_GREY
            beq $t5, $t6, skip_update_down
            # Paint bottom, delete self
            sw $t4, 512($t3)
            
            lw $t6, BLACK
            sw $t6, 0($t3)
            
            skip_update_down:
            # Increment column counter
            addi $t1, $t1, 4
                    
            # Continue inner loop if all columns are not processed
            blt $t1, 256, inner_loop_down
        
        # Increment row counter
        addi $t0, $t0, 4
        
        # Continue outer loop
        j outer_loop_down
        
    end_iteration_down:
        addi $s7, $s7, 1
        jal update_score
        
        after_update_score:
        j update_tetromino
        
update_score:
    lw $t0, ADDR_DSPL
    lw $t1, GREEN
    
    li $t1, 99
    beq $s7, 99, game_over_screen
    # s7 stores the number to draw
    # Check if s7 is just 0
    li $t1, 0
    beq $s7, $t1, score_updated

    # Extract the tens digit
    li $t4, 10             # Load 10 into $t4
    div $s7, $t4           # Divide the number by 10
    mflo $t3               # Tens digit is in $t3
    
    # Extract the ones digit
    mfhi $t2               # Ones digit is in $t2
    
    lw $t5, BLACK
    # Check ones digit
    check_ones_digit:
    li $t1, 1
    beq $t2, $t1, ones_digit_one
    li $t1, 2
    beq $t2, $t1, ones_digit_two
    li $t1, 3
    beq $t2, $t1, ones_digit_three
    li $t1, 4
    beq $t2, $t1, ones_digit_four
    li $t1, 5
    beq $t2, $t1, ones_digit_five
    li $t1, 6
    beq $t2, $t1, ones_digit_six
    li $t1, 7
    beq $t2, $t1, ones_digit_seven
    li $t1, 8
    beq $t2, $t1, ones_digit_eight
    li $t1, 9
    beq $t2, $t1, ones_digit_nine
    jal reset_game_score
    j check_tens_digit
    
    ones_digit_one:
    	lw $t0, ADDR_DSPL
    	la $t6, ONES_DIGIT_ONE    
        
        ones_digit_one_loop:
        lw $t7, 0($t6)                   # Load the memory location from the array
        add $t4, $t0, $t7                # Calculate the actual memory address
        sw $t5, 0($t4)                   # Store RED at the memory location
        addi $t6, $t6, 4                 # Move to the next memory location in the array
        li $t9, 5012
        bne $t7, $t9, ones_digit_one_loop
        j check_tens_digit
    
    ones_digit_two:
        jal reset_game_score
        
        lw $t0, ADDR_DSPL
    	la $t6, ONES_DIGIT_TWO    
        
        ones_digit_two_loop:
        lw $t7, 0($t6)                   # Load the memory location from the array
        add $t4, $t0, $t7                # Calculate the actual memory address
        sw $t5, 0($t4)                   # Store RED at the memory location
        addi $t6, $t6, 4                 # Move to the next memory location in the array
        li $t9, 3736
        bne $t7, $t9, ones_digit_two_loop
        
        lw $t5, RED
        sw $t5, 3456($t0)
        sw $t5, 3460($t0)
        sw $t5, 3464($t0)
        sw $t5, 3468($t0)
        sw $t5, 3472($t0)
        sw $t5, 3476($t0)
        lw $t5, BLACK
        j check_tens_digit
    
    ones_digit_three:
        jal reset_game_score
        
        lw $t0, ADDR_DSPL
    	la $t6, ONES_DIGIT_THREE   
        
        ones_digit_three_loop:
        lw $t7, 0($t6)                   # Load the memory location from the array
        add $t4, $t0, $t7                # Calculate the actual memory address
        sw $t5, 0($t4)                   # Store RED at the memory location
        addi $t6, $t6, 4                 # Move to the next memory location in the array
        li $t9, 4732
        bne $t7, $t9, ones_digit_three_loop
        
        lw $t5, RED
        sw $t5, 3456($t0)
        sw $t5, 3460($t0)
        sw $t5, 3464($t0)
        sw $t5, 3468($t0)
        sw $t5, 3472($t0)
        sw $t5, 3476($t0)
        lw $t5, BLACK
        j check_tens_digit
    
    ones_digit_four:
        jal reset_game_score
        
        lw $t0, ADDR_DSPL
    	la $t6, ONES_DIGIT_FOUR  
        
        ones_digit_four_loop:
        lw $t7, 0($t6)                   # Load the memory location from the array
        add $t4, $t0, $t7                # Calculate the actual memory address
        sw $t5, 0($t4)                   # Store RED at the memory location
        addi $t6, $t6, 4                 # Move to the next memory location in the array
        li $t9, 5012
        bne $t7, $t9, ones_digit_four_loop
        
        lw $t5, RED
        sw $t5, 3456($t0)
        sw $t5, 3460($t0)
        sw $t5, 3464($t0)
        sw $t5, 3468($t0)
        sw $t5, 3472($t0)
        sw $t5, 3476($t0)
        lw $t5, BLACK
        j check_tens_digit
    
    ones_digit_five:
        jal reset_game_score
        
        lw $t0, ADDR_DSPL
    	la $t6, ONES_DIGIT_FIVE  
        
        ones_digit_five_loop:
        lw $t7, 0($t6)                   # Load the memory location from the array
        add $t4, $t0, $t7                # Calculate the actual memory address
        sw $t5, 0($t4)                   # Store RED at the memory location
        addi $t6, $t6, 4                 # Move to the next memory location in the array
        li $t9, 2456
        bne $t7, $t9, ones_digit_five_loop
        
        lw $t5, RED
        sw $t5, 3456($t0)
        sw $t5, 3460($t0)
        sw $t5, 3464($t0)
        sw $t5, 3468($t0)
        sw $t5, 3472($t0)
        sw $t5, 3476($t0)
        lw $t5, BLACK
        j check_tens_digit
    
    ones_digit_six:
        jal reset_game_score
        
        lw $t0, ADDR_DSPL
    	la $t6, ONES_DIGIT_SIX 
        
        ones_digit_six_loop:
        lw $t7, 0($t6)                   # Load the memory location from the array
        add $t4, $t0, $t7                # Calculate the actual memory address
        sw $t5, 0($t4)                   # Store RED at the memory location
        addi $t6, $t6, 4                 # Move to the next memory location in the array
        li $t9, 2456
        bne $t7, $t9, ones_digit_six_loop
        
        lw $t5, RED
        sw $t5, 3456($t0)
        sw $t5, 3460($t0)
        sw $t5, 3464($t0)
        sw $t5, 3468($t0)
        sw $t5, 3472($t0)
        sw $t5, 3476($t0)
        lw $t5, BLACK
        j check_tens_digit
    
    ones_digit_seven:
        jal reset_game_score
        
        lw $t0, ADDR_DSPL
    	la $t6, ONES_DIGIT_SEVEN
        
        ones_digit_seven_loop:
        lw $t7, 0($t6)                   # Load the memory location from the array
        add $t4, $t0, $t7                # Calculate the actual memory address
        sw $t5, 0($t4)                   # Store RED at the memory location
        addi $t6, $t6, 4                 # Move to the next memory location in the array
        li $t9, 5012
        bne $t7, $t9, ones_digit_seven_loop
        j check_tens_digit
    
    ones_digit_eight:
        jal reset_game_score
        
        lw $t0, ADDR_DSPL
        lw $t5, RED
        sw $t5, 3456($t0)
        sw $t5, 3460($t0)
        sw $t5, 3464($t0)
        sw $t5, 3468($t0)
        sw $t5, 3472($t0)
        sw $t5, 3476($t0)
        lw $t5, BLACK
        j check_tens_digit
    
    ones_digit_nine:
        jal reset_game_score
        
        lw $t0, ADDR_DSPL
    	la $t6, ONES_DIGIT_NINE
        
        ones_digit_nine_loop:
        lw $t7, 0($t6)                   # Load the memory location from the array
        add $t4, $t0, $t7                # Calculate the actual memory address
        sw $t5, 0($t4)                   # Store RED at the memory location
        addi $t6, $t6, 4                 # Move to the next memory location in the array
        li $t9, 5012
        bne $t7, $t9, ones_digit_nine_loop
        
        lw $t5, RED
        sw $t5, 3456($t0)
        sw $t5, 3460($t0)
        sw $t5, 3464($t0)
        sw $t5, 3468($t0)
        sw $t5, 3472($t0)
        sw $t5, 3476($t0)
        lw $t5, BLACK
        j check_tens_digit
    
    check_tens_digit:
        li $t4, 10             # Load 10 into $t4
        div $s7, $t4           # Divide the number by 10
        mflo $t3               # Tens digit is in $t3
        li $t1, 1
        beq $t3, $t1, tens_digit_one
        li $t1, 2
        beq $t3, $t1, tens_digit_two
        li $t1, 3
        beq $t3, $t1, tens_digit_three
        li $t1, 4
        beq $t3, $t1, tens_digit_four
        li $t1, 5
        beq $t3, $t1, tens_digit_five
        li $t1, 6
        beq $t3, $t1, tens_digit_six
        li $t1, 7
        beq $t3, $t1, tens_digit_seven
        li $t1, 8
        beq $t3, $t1, tens_digit_eight
        li $t1, 9
        beq $t3, $t1, tens_digit_nine
        j score_updated
        
        tens_digit_one:
            lw $t0, ADDR_DSPL
        	la $t6, TENS_DIGIT_ONE
            
            tens_digit_one_loop:
            lw $t7, 0($t6)                   # Load the memory location from the array
            add $t4, $t0, $t7                # Calculate the actual memory address
            sw $t5, 0($t4)                   # Store RED at the memory location
            addi $t6, $t6, 4                 # Move to the next memory location in the array
            li $t9, 4972
            bne $t7, $t9, tens_digit_one_loop
            j score_updated
        tens_digit_two:
            jal reset_game_score
        
            lw $t0, ADDR_DSPL
        	la $t6, TENS_DIGIT_TWO
            
            tens_digit_two_loop:
            lw $t7, 0($t6)                   # Load the memory location from the array
            add $t4, $t0, $t7                # Calculate the actual memory address
            sw $t5, 0($t4)                   # Store RED at the memory location
            addi $t6, $t6, 4                 # Move to the next memory location in the array
            li $t9, 3696
            bne $t7, $t9, tens_digit_two_loop
            
            lw $t5, RED
            sw $t5, 3416($t0)
            sw $t5, 3420($t0)
            sw $t5, 3424($t0)
            sw $t5, 3428($t0)
            sw $t5, 3432($t0)
            sw $t5, 3436($t0)
            lw $t5, BLACK
            j score_updated
        tens_digit_three:
            jal reset_game_score
            
            lw $t0, ADDR_DSPL
        	la $t6, TENS_DIGIT_THREE   
            
            tens_digit_three_loop:
            lw $t7, 0($t6)                   # Load the memory location from the array
            add $t4, $t0, $t7                # Calculate the actual memory address
            sw $t5, 0($t4)                   # Store RED at the memory location
            addi $t6, $t6, 4                 # Move to the next memory location in the array
            li $t9, 4692
            bne $t7, $t9, tens_digit_three_loop
            
            lw $t5, RED
            sw $t5, 3416($t0)
            sw $t5, 3420($t0)
            sw $t5, 3424($t0)
            sw $t5, 3428($t0)
            sw $t5, 3432($t0)
            sw $t5, 3436($t0)
            lw $t5, BLACK
            j score_updated
        tens_digit_four:
            lw $t0, ADDR_DSPL
        	la $t6, TENS_DIGIT_FOUR  
            
            tens_digit_four_loop:
            lw $t7, 0($t6)                   # Load the memory location from the array
            add $t4, $t0, $t7                # Calculate the actual memory address
            sw $t5, 0($t4)                   # Store RED at the memory location
            addi $t6, $t6, 4                 # Move to the next memory location in the array
            li $t9, 4972
            bne $t7, $t9, tens_digit_four_loop
            
            lw $t5, RED
            sw $t5, 3416($t0)
            sw $t5, 3420($t0)
            sw $t5, 3424($t0)
            sw $t5, 3428($t0)
            sw $t5, 3432($t0)
            sw $t5, 3436($t0)
            lw $t5, BLACK
            j score_updated
        tens_digit_five:
            lw $t0, ADDR_DSPL
        	la $t6, TENS_DIGIT_FIVE  
            
            tens_digit_five_loop:
            lw $t7, 0($t6)                   # Load the memory location from the array
            add $t4, $t0, $t7                # Calculate the actual memory address
            sw $t5, 0($t4)                   # Store RED at the memory location
            addi $t6, $t6, 4                 # Move to the next memory location in the array
            li $t9, 2416
            bne $t7, $t9, tens_digit_five_loop
            
            lw $t5, RED
            sw $t5, 3416($t0)
            sw $t5, 3420($t0)
            sw $t5, 3424($t0)
            sw $t5, 3428($t0)
            sw $t5, 3432($t0)
            sw $t5, 3436($t0)
            lw $t5, BLACK
            j score_updated
        tens_digit_six:
            lw $t0, ADDR_DSPL
        	la $t6, TENS_DIGIT_SIX 
            
            tens_digit_six_loop:
            lw $t7, 0($t6)                   # Load the memory location from the array
            add $t4, $t0, $t7                # Calculate the actual memory address
            sw $t5, 0($t4)                   # Store RED at the memory location
            addi $t6, $t6, 4                 # Move to the next memory location in the array
            li $t9, 2416
            bne $t7, $t9, tens_digit_six_loop
            
            lw $t5, RED
            sw $t5, 3416($t0)
            sw $t5, 3420($t0)
            sw $t5, 3424($t0)
            sw $t5, 3428($t0)
            sw $t5, 3432($t0)
            sw $t5, 3436($t0)
            lw $t5, BLACK
            j score_updated
        tens_digit_seven:
            lw $t0, ADDR_DSPL
        	la $t6, TENS_DIGIT_SEVEN
            
            tens_digit_seven_loop:
            lw $t7, 0($t6)                   # Load the memory location from the array
            add $t4, $t0, $t7                # Calculate the actual memory address
            sw $t5, 0($t4)                   # Store RED at the memory location
            addi $t6, $t6, 4                 # Move to the next memory location in the array
            li $t9, 4972
            bne $t7, $t9, tens_digit_seven_loop
            j score_updated
        tens_digit_eight:
            lw $t0, ADDR_DSPL
            lw $t5, RED
            sw $t5, 3416($t0)
            sw $t5, 3420($t0)
            sw $t5, 3424($t0)
            sw $t5, 3428($t0)
            sw $t5, 3432($t0)
            sw $t5, 3436($t0)
            lw $t5, BLACK
            j score_updated
        tens_digit_nine:
            lw $t0, ADDR_DSPL
        	la $t6, TENS_DIGIT_NINE
            
            tens_digit_nine_loop:
            lw $t7, 0($t6)                   # Load the memory location from the array
            add $t4, $t0, $t7                # Calculate the actual memory address
            sw $t5, 0($t4)                   # Store RED at the memory location
            addi $t6, $t6, 4                 # Move to the next memory location in the array
            li $t9, 4972
            bne $t7, $t9, tens_digit_nine_loop
            
            lw $t5, RED
            sw $t5, 3416($t0)
            sw $t5, 3420($t0)
            sw $t5, 3424($t0)
            sw $t5, 3428($t0)
            sw $t5, 3432($t0)
            sw $t5, 3436($t0)
            lw $t5, BLACK
        
    score_updated:
    j after_update_score
    
respond_to_P:
    # Toggle game pause state
    lw $t1, game_paused    # Load the game paused flag
    xori $t1, $t1, 1       # Toggle the flag
    sw $t1, game_paused    # Store the updated flag
    
    # If game is now paused, display "Game Paused" message
    beq $t1, 1, game_paused_message
    
    # If game is resumed, return to handle_input
    j handle_input

game_paused_message:
    # Display "Game Paused" message
    li 		$v0, 32
	li 		$a0, 1
	syscall
	
	jal draw_paused
	
	continue_paused:
    lw $t0, ADDR_KBRD               # $t0 = base address for keyboard
    lw $t8, 0($t0)                  # Load first word from keyboard
    beq $t8, 1, keyboard_input_paused
    b game_paused_message
    
    keyboard_input_paused:
    lw $a0, 4($t0)
    beq $a0, 0x70, unpaused     # Check if the key P was pressed
    j game_paused_message
    
    unpaused:
        jal repaint_screen
        j handle_input
    
    j game_paused_message
    
draw_paused:
    lw $t1, PAUSED_RED
	lw $t0, ADDR_DSPL

    la $t2, PAUSED_LOCATIONS            # Load the address of RED_LOCATIONS array into $t2
    
    draw_paused_loop:
    lw $t3, 0($t2)                   # Load the memory location from the array
    add $t4, $t0, $t3                # Calculate the actual memory address
    sw $t1, 0($t4)                   # Store RED at the memory location
    addi $t2, $t2, 4                 # Move to the next memory location in the array
    li $t5, 6824
    bne $t3, $t5, draw_paused_loop   # Continue the loop until reaching the end of the array
	
	jr $ra

check_game_over:
    lw $t0, GAME_OVER_LINE
    add $t0, $t0, $t1                       # Increment address by $t1 value
    lw $t2, 0($t0)
        
    lw $t3, LANDED_PURPLE
    beq $t2, $t3, game_over_screen          # Encounter a tetromino at the top
    # lw $t9, WHITE                         # Uncomment to see where game over line is
    # sw $t9, 0($t0)
    addi $t1, $t1, 4
    li $t4, 256
    blt $t1, $t4, check_game_over
    jr $ra
    
game_over_screen:
    li $v0, 33    # async play note syscall
    li $a0, 50    # midi pitch
    li $a1, 1000   # duration
    li $a2, 67     # instrument
    li $a3, 100   # volume
    syscall
    
    lw $t1, RED
	lw $t0, ADDR_DSPL
	la $t2, GAME_OVER_LOCATIONS    
    
    game_over_screen_loop:
    lw $t3, 0($t2)                   # Load the memory location from the array
    add $t4, $t0, $t3                # Calculate the actual memory address
    sw $t1, 0($t4)                   # Store RED at the memory location
    addi $t2, $t2, 4                 # Move to the next memory location in the array
    li $t5, 8112
    bne $t3, $t5, game_over_screen_loop
    
    game_over_check_keyboard:
    li 		$v0, 32
	li 		$a0, 1
	syscall
	
    lw $t0, ADDR_KBRD               # $t0 = base address for keyboard
    lw $t8, 0($t0)                  # Load first word from keyboard
    beq $t8, 1, keyboard_input_game_over
    b game_over_check_keyboard
    
    keyboard_input_game_over:
    lw $a0, 4($t0)
    beq $a0, 0x71, respond_to_Q     # Check if the key Q was pressed (quit)
    beq $a0, 0x72, restart_game

    j game_over_screen

restart_game:
    restart_repaint_screen:
    li $t0, 0    # Row counter
    li $t1, 0    # Column counter
    restart_outer_loop:
        beq $t0, 400, restart_end_iteration         # 100 * 4 = 400
        li $t1, 0
        restart_inner_loop:
            mul $t2, $t0, 64
            add $t2, $t2, $t1
            lw $t3, ADDR_DSPL
            add $t3, $t3, $t2
            lw $t4, 0($t3)
            
            bne $t4, $zero, restart_check_grey
            bne $t4, $zero, restart_check_green_obstacle
            bne $t4, $zero, restart_check_purple
            j restart_skip_update
            
            restart_check_grey:
            lw $t5, GREY
            beq $t4, $t5, restart_skip_update
            lw $t5, BOTTOM_GREY
            beq $t4, $t5, restart_skip_update
            
            restart_check_green_obstacle:
            lw $t5, GREEN
            beq $t4, $t5, restart_skip_update
            
            restart_check_purple:
            beq $t4, $t5, restart_skip_update
            
            # Set pixel to black
            li $t4, 0x000000
            sw $t4, 0($t3)
            
            restart_skip_update:
            addi $t1, $t1, 4
            blt $t1, 256, restart_inner_loop            # 64 * 4 = 256
        
        # Increment row counter
        addi $t0, $t0, 4
        
        # Continue outer loop
        j restart_outer_loop
        
    restart_end_iteration:
        j main

respond_to_Q:
    # End game
    li $v0, 10                          # Quit gracefully
	syscall
    
gen_rand_num:
	lw  $a0, min_value                         # Load min value
    lw  $a1, max_value                          # Load max value
    li  $v0, 42                                 # Load system call code for generating random number
    syscall                                     # Generate random number
    # Now, $a0 stores the random number
    
    # Increment the value in $a0 until it is divisible by 8
    andi $t0, $a0, 0x7                          # $t0 = $a0 % 8
    beq $t0, $0, div_4_done                     # If $a0 % 4 == 0, it is already divisible by 8

    div_4_loop:
        addi $a0, $a0, 1                        # Increment $a0
        andi $t0, $a0, 0x7                      # $t0 = $a0 % 8
        bne $t0, $0, div_4_loop                 # If $a0 % 8 != 0, continue looping

    div_4_done:
        # At this point, $a0 contains the value that is divisible by 8
        addi $a0, $a0, 16                       # Make sure that $a0 is not in the left wall
    
    lw $t0, ADDR_DSPL
    jr $ra                                      # Return

reset_game_score:
lw $t1, RED
lw $t0, ADDR_DSPL
la $t2, SCORE_LOCATIONS

    game_score_loop:
    lw $t3, 0($t2)                   # Load the memory location from the array
    add $t4, $t0, $t3                # Calculate the actual memory address
    sw $t1, 0($t4)                   # Store RED at the memory location
    addi $t2, $t2, 4                 # Move to the next memory location in the array
    li $t5, 2416
    bne $t3, $t5, game_score_loop

jr $ra
        