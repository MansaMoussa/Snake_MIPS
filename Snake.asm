#                      _..._                 .           __.....__
#                    .'     '.             .'|       .-''         '.
#                   .   .-.   .          .'  |      /     .-''"'-.  `.
#                   |  '   '  |    __   <    |     /     /________\   \
#               _   |  |   |  | .:--.'.  |   | ____|                  |
#             .' |  |  |   |  |/ |   \ | |   | \ .'\    .-------------'
#            .   | /|  |   |  |`" __ | | |   |/  .  \    '-.____...---.
#          .'.'| |//|  |   |  | .'.''| | |    /\  \  `.             .'
#        .'.'.-'  / |  |   |  |/ /   | |_|   |  \  \   `''-...... -'
#        .'   \_.'  |  |   |  |\ \._,\ '/'    \  \  \
#                   '--'   '--' `--'  `"'------'  '---'
#
#
#
#                                               .......
#                                     ..  ...';:ccc::,;,'.
#                                 ..'':cc;;;::::;;:::,'',,,.
#                              .:;c,'clkkxdlol::l;,.......',,
#                          ::;;cok0Ox00xdl:''..;'..........';;
#                          o0lcddxoloc'.,. .;,,'.............,'
#                           ,'.,cc'..  .;..;o,.       .......''.
#                             :  ;     lccxl'          .......'.
#                             .  .    oooo,.            ......',.
#                                    cdl;'.             .......,.
#                                 .;dl,..                ......,,
#                                 ;,.                   .......,;
#                                                        ......',
#                                                       .......,;
#                                                       ......';'
#                                                      .......,:.
#                                                     .......';,
#                                                   ........';:
#                                                 ........',;:.
#                                             ..'.......',;::.
#                                         ..';;,'......',:c:.
#                                       .;lcc:;'.....',:c:.
#                                     .coooc;,.....,;:c;.
#                                   .:ddol,....',;:;,.
#                                  'cddl:'...,;:'.
#                                 ,odoc;..',;;.                    ,.
#                                ,odo:,..';:.                     .;
#                               'ldo:,..';'                       .;.
#                              .cxxl,'.';,                        .;'
#                              ,odl;'.',c.                         ;,.
#                              :odc'..,;;                          .;,'
#                              coo:'.',:,                           ';,'
#                              lll:...';,                            ,,''
#                              :lo:'...,;         ...''''.....       .;,''
#                              ,ooc;'..','..';:ccccccccccc::;;;.      .;''.
#          .;clooc:;:;''.......,lll:,....,:::;;,,''.....''..',,;,'     ,;',
#       .:oolc:::c:;::cllclcl::;cllc:'....';;,''...........',,;,',,    .;''.
#      .:ooc;''''''''''''''''''',cccc:'......'',,,,,,,,,,;;;;;;'',:.   .;''.
#      ;:oxoc:,'''............''';::::;'''''........'''',,,'...',,:.   .;,',
#     .'';loolcc::::c:::::;;;;;,;::;;::;,;;,,,,,''''...........',;c.   ';,':
#     .'..',;;::,,,,;,'',,,;;;;;;,;,,','''...,,'''',,,''........';l.  .;,.';
#    .,,'.............,;::::,'''...................',,,;,.........'...''..;;
#   ;c;',,'........,:cc:;'........................''',,,'....','..',::...'c'
#  ':od;'.......':lc;,'................''''''''''''''....',,:;,'..',cl'.':o.
#  :;;cclc:,;;:::;''................................'',;;:c:;,'...';cc'';c,
#  ;'''',;;;;,,'............''...........',,,'',,,;:::c::;;'.....',cl;';:.
#  .'....................'............',;;::::;;:::;;;;,'.......';loc.'.
#   '.................''.............'',,,,,,,,,'''''.........',:ll.
#    .'........''''''.   ..................................',;;:;.
#      ...''''....          ..........................'',,;;:;.
#                                ....''''''''''''''',,;;:,'.
#                                    ......'',,'','''..
#


################################################################################
#                  Fonctions d'affichage et d'entrée clavier                   #
################################################################################

# Ces fonctions s'occupent de l'affichage et des entrées clavier.
# Il n'est pas obligatoire de comprendre ce qu'elles font.

.data

# Tampon d'affichage du jeu 256*256 de manière linéaire.

frameBuffer: .word 0 : 1024  # Frame buffer

# Code couleur pour l'affichage
# Codage des couleurs 0xwwxxyyzz où
#   ww = 00
#   00 <= xx <= ff est la couleur rouge en hexadécimal
#   00 <= yy <= ff est la couleur verte en hexadécimal
#   00 <= zz <= ff est la couleur bleue en hexadécimal

colors: .word 0x00000000, 0x00ff0000, 0xff00ff00, 0x00396239, 0x00ff00ff
.eqv black 0
.eqv red   4
.eqv green 8
.eqv greenV2  12
.eqv rose  16

#Code couleur pour le Rainbow Snake
rainbow: .word 0xffff00, 0x99ccff, 0x0000ff, 0xff9900, 0xffffff, 0x00ffff, 0x808080
.eqv yellow 0
.eqv skyBlue 4
.eqv blue 8
.eqv orange 12
.eqv white 16
.eqv turquoise 20
.eqv grey 24

#La vitesse de base du jeu en milli secondes
speedLinkedToLevel: 500

# Dernière position connue de la queue du serpent.

lastSnakePiece: .word 0, 0

.text
j main

############################# printColorAtPosition #############################
# Paramètres: $a0 La valeur de la couleur
#             $a1 La position en X
#             $a2 La position en Y
# Retour: Aucun
# Effet de bord: Modifie l'affichage du jeu
################################################################################

printColorAtPosition:
lw $t0 tailleGrille
mul $t0 $a2 $t0
add $t0 $t0 $a1
sll $t0 $t0 2
sw $a0 frameBuffer($t0)
jr $ra

################################ resetAffichage ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Réinitialise tout l'affichage avec la couleur noir
################################################################################

resetAffichage:
lw $t1 tailleGrille
mul $t1 $t1 $t1
sll $t1 $t1 2
la $t0 frameBuffer
addu $t1 $t0 $t1
lw $t3 colors + black

RALoop2: bge $t0 $t1 endRALoop2
  sw $t3 0($t0)
  add $t0 $t0 4
  j RALoop2
endRALoop2:
jr $ra

################################## printSnake ##################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage aux emplacement ou se
#                trouve le serpent et sauvegarde la dernière position connue de
#                la queue du serpent.
################################################################################

printSnake:
subu $sp $sp 12
sw $ra 0($sp)
sw $s0 4($sp)
sw $s1 8($sp)

lw $s0 tailleSnake
sll $s0 $s0 2
li $s1 0
						

lw $a0 colors + greenV2
lw $a1 snakePosX($s1)
lw $a2 snakePosY($s1)
jal printColorAtPosition
li $s1 4


PSLoop:
bge $s1 $s0 endPSLoop
  lw $a0 colors + green
  lw $a1 snakePosX($s1)
  lw $a2 snakePosY($s1)
  jal printColorAtPosition
  addu $s1 $s1 4
 bge $s1 $s0 endPSLoop
  lw $a0 rainbow + yellow
  lw $a1 snakePosX($s1)
  lw $a2 snakePosY($s1)
  jal printColorAtPosition
  addu $s1 $s1 4
 bge $s1 $s0 endPSLoop
  lw $a0 rainbow + skyBlue
  lw $a1 snakePosX($s1)
  lw $a2 snakePosY($s1)
  jal printColorAtPosition
  addu $s1 $s1 4
 bge $s1 $s0 endPSLoop
  lw $a0 rainbow + blue
  lw $a1 snakePosX($s1)
  lw $a2 snakePosY($s1)
  jal printColorAtPosition
  addu $s1 $s1 4
 bge $s1 $s0 endPSLoop
  lw $a0 rainbow + orange
  lw $a1 snakePosX($s1)
  lw $a2 snakePosY($s1)
  jal printColorAtPosition
  addu $s1 $s1 4
 bge $s1 $s0 endPSLoop
  lw $a0 rainbow + white
  lw $a1 snakePosX($s1)
  lw $a2 snakePosY($s1)
  jal printColorAtPosition
  addu $s1 $s1 4
 bge $s1 $s0 endPSLoop
  lw $a0 rainbow + turquoise
  lw $a1 snakePosX($s1)
  lw $a2 snakePosY($s1)
  jal printColorAtPosition
  addu $s1 $s1 4
 bge $s1 $s0 endPSLoop
  lw $a0 rainbow + grey
  lw $a1 snakePosX($s1)
  lw $a2 snakePosY($s1)
  jal printColorAtPosition
  addu $s1 $s1 4
  j PSLoop
endPSLoop:

subu $s0 $s0 4
lw $t0 snakePosX($s0)
lw $t1 snakePosY($s0)
sw $t0 lastSnakePiece
sw $t1 lastSnakePiece + 4

lw $ra 0($sp)
lw $s0 4($sp)
lw $s1 8($sp)
addu $sp $sp 12
jr $ra

################################ printObstacles ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage aux emplacement des obstacles.
################################################################################

printObstacles:
subu $sp $sp 12
sw $ra 0($sp)
sw $s0 4($sp)
sw $s1 8($sp)

lw $s0 numObstacles
sll $s0 $s0 2
li $s1 0

POLoop:
bge $s1 $s0 endPOLoop
  lw $a0 colors + red
  lw $a1 obstaclesPosX($s1)
  lw $a2 obstaclesPosY($s1)
  jal printColorAtPosition
  addu $s1 $s1 4
  j POLoop
endPOLoop:

lw $ra 0($sp)
lw $s0 4($sp)
lw $s1 8($sp)
addu $sp $sp 12
jr $ra

################################## printCandy ##################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage à l'emplacement du bonbon.
################################################################################

printCandy:
subu $sp $sp 4
sw $ra ($sp)

lw $a0 colors + rose
lw $a1 candy
lw $a2 candy + 4
jal printColorAtPosition

lw $ra ($sp)
addu $sp $sp 4
jr $ra

eraseLastSnakePiece:
subu $sp $sp 4
sw  $ra ($sp)

lw $a0 colors + black
lw $a1 lastSnakePiece
lw $a2 lastSnakePiece + 4
jal printColorAtPosition

lw $ra ($sp)
addu $sp $sp 4
jr $ra

################################## printGame ###################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Effectue l'affichage de la totalité des éléments du jeu.
################################################################################

printGame:
subu $sp $sp 4
sw $ra 0($sp)

jal eraseLastSnakePiece
jal printSnake
jal printObstacles
jal printCandy

lw $ra 0($sp)
addu $sp $sp 4
jr $ra

############################## getRandomExcluding ##############################
# Paramètres: $a0 Un entier x | 0 <= x < tailleGrille
# Retour: $v0 Un entier y | 0 <= y < tailleGrille, y != x
################################################################################

getRandomExcluding:
move $t0 $a0
lw $a1 tailleGrille
li $v0 42
syscall
beq $t0 $a0 getRandomExcluding
move $v0 $a0
jr $ra

########################### newRandomObjectPosition ############################
# Description: Renvoie une position aléatoire sur un emplacement non utilisé
#              qui ne se trouve pas devant le serpent.
# Paramètres: Aucun
# Retour: $v0 Position X du nouvel objet
#         $v1 Position Y du nouvel objet
################################################################################

newRandomObjectPosition:
subu $sp $sp 4
sw $ra ($sp)

lw $t0 snakeDir
and $t0 0x1
bgtz $t0 horizontalMoving
li $v0 42
lw $a1 tailleGrille
syscall
move $t8 $a0
lw $a0 snakePosY
jal getRandomExcluding
move $t9 $v0
j endROPdir

horizontalMoving:
lw $a0 snakePosX
jal getRandomExcluding
move $t8 $v0
lw $a1 tailleGrille
li $v0 42
syscall
move $t9 $a0
endROPdir:

lw $t0 tailleSnake
sll $t0 $t0 2
la $t0 snakePosX($t0)
la $t1 snakePosX
la $t2 snakePosY
li $t4 0

ROPtestPos:
bge $t1 $t0 endROPtestPos
lw $t3 ($t1)
bne $t3 $t8 ROPtestPos2
lw $t3 ($t2)
beq $t3 $t9 replayROP
ROPtestPos2:
addu $t1 $t1 4
addu $t2 $t2 4
j ROPtestPos
endROPtestPos:

bnez $t4 endROP

lw $t0 numObstacles
sll $t0 $t0 2
la $t0 obstaclesPosX($t0)
la $t1 obstaclesPosX
la $t2 obstaclesPosY
li $t4 1
j ROPtestPos

endROP:
move $v0 $t8
move $v1 $t9
lw $ra ($sp)
addu $sp $sp 4
jr $ra

replayROP:
lw $ra ($sp)
addu $sp $sp 4
j newRandomObjectPosition

################################# getInputVal ##################################
# Paramètres: Aucun
# Retour: $v0 La valeur 0 (haut), 1 (droite), 2 (bas), 3 (gauche), 4 erreur
################################################################################

getInputVal:
lw $t0 0xffff0004
li $t1 122
beq $t0 $t1 GIhaut
li $t1 115
beq $t0 $t1 GIbas
li $t1 113
beq $t0 $t1 GIgauche
li $t1 100
beq $t0 $t1 GIdroite
li $v0 4
j GIend

GIhaut:
li $v0 0
j GIend

GIdroite:
li $v0 1
j GIend

GIbas:
li $v0 2
j GIend

GIgauche:
li $v0 3

GIend:
jr $ra

################################ sleepMillisec #################################
# Paramètres: $a0 Le temps en milli-secondes qu'il faut passer dans cette
#             fonction (approximatif)
# Retour: Aucun
################################################################################

sleepMillisec:
move $t0 $a0
li $v0 30
syscall
addu $t0 $t0 $a0

SMloop:
bgt $a0 $t0 endSMloop
li $v0 30
syscall
j SMloop

endSMloop:
jr $ra

##################################### main #####################################
# Description: Boucle principal du jeu
# Paramètres: Aucun
# Retour: Aucun
################################################################################

main:

# Initialisation du jeu

jal resetAffichage
jal newRandomObjectPosition
sw $v0 candy
sw $v1 candy + 4

# Boucle de jeu

mainloop:

jal getInputVal
move $a0 $v0
jal majDirection
jal updateGameStatus
jal conditionFinJeu
bnez $v0 gameOver
jal printGame
lw $a0 speedLinkedToLevel
jal sleepMillisec
j mainloop

gameOver:
jal affichageFinJeu
li $v0 10
syscall

################################################################################
#                                Partie Projet                                 #
################################################################################

# À vous de jouer !

.data

tailleGrille:  .word 16        # Nombre de case du jeu dans une dimension.

# La tête du serpent se trouve à (snakePosX[0], snakePosY[0]) et la queue à
# (snakePosX[tailleSnake - 1], snakePosY[tailleSnake - 1])
tailleSnake:   .word 1         # Taille actuelle du serpent.
snakePosX:     .word 0 : 1024  # Coordonnées X du serpent ordonné de la tête à la queue.
snakePosY:     .word 0 : 1024  # Coordonnées Y du serpent ordonné de la tête à la queue.

# Les directions sont représentés sous forme d'entier allant de 0 à 3:
snakeDir:      .word 1         # Direction du serpent: 0 (haut), 1 (droite)
                               #                       2 (bas), 3 (gauche)
numObstacles:  .word 0         # Nombre actuel d'obstacle présent dans le jeu.
obstaclesPosX: .word 0 : 1024  # Coordonnées X des obstacles
obstaclesPosY: .word 0 : 1024  # Coordonnées Y des obstacles
candy:         .word 0, 0      # Position du bonbon (X,Y)
scoreJeu:      .word 0         # Score obtenu par le joueur
messageScore:	.asciiz "GAME OVER\t\nVous avez atteint un score finale de "
messageLevel1:	.asciiz "Vous venez de passer au niveau 1. Vitesse = 450\n"
messageLevel2:	.asciiz "Vous venez de passer au niveau 2. Vitesse = 350\n"
messageLevel3:	.asciiz "Vous venez de passer au niveau 3. Vitesse = 200\n"
messageLevel4:	.asciiz "Vous venez de passer au niveau 4. Vitesse = 150\n"
messageLevel5:	.asciiz "Vous venez de passer au niveau 5. Vitesse = 100\n"

.text

################################# majDirection #################################
# Paramètres: $a0 La nouvelle position demandée par l'utilisateur. La valeur
#                 étant le retour de la fonction getInputVal.
# Retour: Aucun
# Effet de bord: La direction du serpent à été mise à jour.
# Post-condition: La valeur du serpent reste intacte si une commande illégale
#                 est demandée, i.e. le serpent ne peut pas faire de demi-tour
#                 en un unique tour de jeu. Cela s'apparente à du cannibalisme
#                 et à été proscrit par la loi dans les sociétés reptiliennes.
################################################################################

majDirection:
	move $t1, $a0		#$t1 got the inputted value
	lw $t2, snakeDir	#$t2 got the actual snake direction
	beq $t1, 4, nothing	#if a legal key was inputted
	
	  #making sure that the user do
	  beq $t1 0 testCannibalUp
	  beq $t1 2 testCannibalDown
	  beq $t1 1 testCannibalRight
	  beq $t1 3 testCannibalLeft
	
	
	  testCannibalUp: 	beq $t2 2 nothing
				  j legalKey
	  testCannibalDown: 	beq $t2 0 nothing
				  j legalKey
	  testCannibalRight: 	beq $t2 3 nothing
				  j legalKey
	  testCannibalLeft: 	beq $t2 1 nothing
				  j legalKey
	
	  #Action to do if the user inputed a correct key
	  legalKey:		sw $t1 snakeDir	#snakeDir is updated by $t1, the inputted value
			
	nothing: #do nothing, update finished
jr $ra

############################### updateGameStatus ###############################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: L'état du jeu est mis à jour d'un pas de temps. Il faut donc :
#                  - Faire bouger le serpent
#                  - Tester si le serpent à manger le bonbon
#                    - Si oui déplacer le bonbon et ajouter un nouvel obstacle
################################################################################

updateGameStatus:
		subu $sp, $sp, 16
		sw $ra, 0($sp)
		sw $s0, 4($sp)
		sw $s1, 8($sp)
		sw $s2, 12($sp)
		
		lw $t0, snakeDir
		lw $s0, tailleSnake
		sll $s0 $s0 2		#Pour avoir la taille du tableau "en mots" s0 = s0*4

		li $s1, 0
		li $t1, 0		#t1 is there in order to do not exceed tailleSnake
		
		shifting:	beq $t0, 0, shiftToUp
				beq $t0, 2, shiftToDown
				beq $t0, 1, shiftToRight
				beq $t0, 3, shiftToLeft
				
				shiftToUp: 	lw $t2, snakePosX($s1) #on charge le X de la tête
						lw $t3, snakePosY($s1) #on charge le Y de la tête
						sub $s2, $t3, 1	#Pour monter le serpent d'une case!!
						sw $s2, snakePosY($s1)
						add $s1, $s1, 4 #Pour avancer l'incrémenteur des cases du tableau
						
						toUp:
						  lw $t4, snakePosX($s1) #on charge le X actuel
						  lw $t5, snakePosY($s1) #on charge le Y actuel
						  sw $t2, snakePosX($s1) #on copie le X d'avant
						  sw $t3, snakePosY($s1) #on copie le Y d'avant
						  
						  add $s1, $s1, 4 #Pour avancer l'incrémenteur des cases du tableau
						  
						  lw $t2, snakePosX($s1) #on charge le X actuel
						  lw $t3, snakePosY($s1) #on charge le Y actuel
						  sw $t4, snakePosX($s1) #on charge le X actuel
						  sw $t5, snakePosY($s1) #on charge le Y actuel
						  
						  add $t1, $t1, 4
						  add $s1, $s1, 4 #Pour avancer l'incrémenteur des cases du tableau
						  
						  beq $t1, $s0 endShifting
						  j toUp
						  
				shiftToDown: 	  lw $t2, snakePosX($s1)
						  lw $t3, snakePosY($s1)
						  add $s2, $t3, 1 	#Pour descendre le serpent d'une case!!
						  sw $s2, snakePosY($s1)
						  addu $s1, $s1, 4 #Pour avancer l'incrémenteur des cases du tableau
						  
						  toDown:
						  lw $t4, snakePosX($s1) #on charge le X actuel
						  lw $t5, snakePosY($s1) #on charge le Y actuel
						  sw $t2, snakePosX($s1) #on copie le X d'avant
						  sw $t3, snakePosY($s1) #on copie le Y d'avant
						  
						  add $s1, $s1, 4 #Pour avancer l'incrémenteur des cases du tableau
						  
						  lw $t2, snakePosX($s1) #on charge le X actuel
						  lw $t3, snakePosY($s1) #on charge le Y actuel
						  sw $t4, snakePosX($s1) #on charge le X actuel
						  sw $t5, snakePosY($s1) #on charge le Y actuel
						  
						  add $t1, $t1, 4
						  add $s1, $s1, 4 #Pour avancer l'incrémenteur des cases du tableau
						  
						  beq $t1, $s0 endShifting
						  j toDown
						  
				shiftToRight:	  lw $t2, snakePosX($s1)
						  lw $t3, snakePosY($s1)
						  add $s2, $t2, 1 	#Pour bouger le serpent à droite d'une case!!	  
						  sw $s2, snakePosX($s1)
						  add $s1, $s1, 4 #Pour avancer l'incrémenteur des cases du tableau
						  
						  toRight:
						  lw $t4, snakePosX($s1) #on charge le X actuel
						  lw $t5, snakePosY($s1) #on charge le Y actuel
						  sw $t2, snakePosX($s1) #on copie le X d'avant
						  sw $t3, snakePosY($s1) #on copie le Y d'avant
						  
						  add $s1, $s1, 4 #Pour avancer l'incrémenteur des cases du tableau
						  
						  lw $t2, snakePosX($s1) #on charge le X actuel
						  lw $t3, snakePosY($s1) #on charge le Y actuel
						  sw $t4, snakePosX($s1) #on charge le X actuel
						  sw $t5, snakePosY($s1) #on charge le Y actuel
						  
						  add $t1, $t1, 4
						  add $s1, $s1, 4 #Pour avancer l'incrémenteur des cases du tableau
						  
						  beq $t1, $s0 endShifting
						  j toRight
						  
				shiftToLeft:	  lw $t2, snakePosX($s1)
						  lw $t3, snakePosY($s1)
						  sub $s2, $t2, 1 	#Pour bouger le serpent à gauche d'une case!!
						  sw $s2, snakePosX($s1)
						  add $s1, $s1, 4 #Pour avancer l'incrémenteur des cases du tableau
						  
						  toLeft:
						  lw $t4, snakePosX($s1) #on charge le X actuel
						  lw $t5, snakePosY($s1) #on charge le Y actuel
						  sw $t2, snakePosX($s1) #on copie le X d'avant
						  sw $t3, snakePosY($s1) #on copie le Y d'avant
						  
						  add $s1, $s1, 4 #Pour avancer l'incrémenteur des cases du tableau
						  
						  lw $t2, snakePosX($s1) #on charge le X actuel
						  lw $t3, snakePosY($s1) #on charge le Y actuel
						  sw $t4, snakePosX($s1) #on charge le X actuel
						  sw $t5, snakePosY($s1) #on charge le Y actuel
						  
						  add $t1, $t1, 4
						  add $s1, $s1, 4 #Pour avancer l'incrémenteur des cases du tableau
						  
						  beq $t1, $s0 endShifting
						  j toLeft
		
		endShifting: #The shifting is done
		
		#Check if the snake ate the candy
		lw $t2, snakePosX($zero)
		lw $t3, snakePosY($zero)
		lw $t4, candy
		lw $t5, candy + 4
		bne $t2, $t4, end
		bne $t3, $t5, end
		  #increase snake's length
		  lw $t7, tailleSnake
		  addu $t7, $t7, 1
		  sw $t7, tailleSnake
		  #increase game's score
		  lw $t4, scoreJeu
		  addu $t4, $t4, 10
		  sw $t4, scoreJeu
		
		  #apparution d'une nouvelle pastille
		  jal newRandomObjectPosition
		  sw $v0 candy
		  sw $v1 candy + 4
		  
		  #apparution d'un nouvel obstacle
		  jal newRandomObjectPosition
		  lw $t0, numObstacles		#On charge le nombre d'obstacles
		  move $t1, $t0
		  sll $t0, $t0, 2
		  sw $v0, obstaclesPosX($t0)
		  sw $v1, obstaclesPosY($t0)
		  addu $t1, $t1, 1		#On augmente de 1 le nombre d'obstacles
		  sw $t1, numObstacles		#On stocker le nouveau nombre d'obstacles
		  
		  
		  
		  lw $a0, scoreJeu
		  
		  beq $a0, 50, level1
		  beq $a0, 100, level2
		  beq $a0, 250, level3
		  beq $a0, 500, level4
		  beq $a0, 1000, level5
		  j end
		
		  level1:
		    #############
		    la $a0, messageLevel1
 		    li $v0, 4
		    syscall
	 	    #############
		    li $t0, 450
		    sw $t0, speedLinkedToLevel
		  j end
		  level2:
		    #############
		    la $a0, messageLevel2
		    li $v0, 4
		    syscall
		    #############
		    li $t0, 350
		    sw $t0, speedLinkedToLevel
		  j end
		  level3:
		    #############
		    la $a0, messageLevel3
		    li $v0, 4
		    syscall
		    #############
		    li $t0, 200
		    sw $t0, speedLinkedToLevel
		  j end
		  level4:
		    #############
		    la $a0, messageLevel4
		    li $v0, 4
		    syscall
		    #############
		    li $t0, 150
		    sw $t0, speedLinkedToLevel
		  j end
		  level5:
		    #############
		    la $a0, messageLevel5
		    li $v0, 4
		    syscall
		    #############
		    li $t0, 100
		    sw $t0, speedLinkedToLevel
		  j end
		
		end :
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		addu $sp, $sp, 16
jr $ra

############################### conditionFinJeu ################################
# Paramètres: Aucun
# Retour: $v0 La valeur 0 si le jeu doit continuer ou toute autre valeur sinon.
################################################################################

conditionFinJeu:
		subu $sp, $sp, 12
		sw $ra, 0($sp)
		sw $s0, 4($sp)
		sw $s1, 8($sp)
		
li $v0 0  #v0 vaut 0 pour continuer le jeu

		#On va une valeur non nulle (1 pour mon cas) à v0 si une des conditions de fin de jeu est enfreinte
		lw $t1, snakePosX($zero)
		lw $t2, snakePosY($zero)
		
		#checkBorderCollision
		checkBorderCollision:	
			li $t3, -1
			li $t4, 16
			beq $t1, $t3, changeV0
			beq $t2, $t3, changeV0
			beq $t1, $t4, changeV0
			beq $t2, $t4, changeV0

		
		#checkObstacleCollision
		li $s0, 0 #Pour commencer à la place 0 du tableau des obstacles
		lw $s1, numObstacles
		sll $s1, $s1, 2		#taille du tableau en mots
		checkObstacleCollision:	
			beq $s0, $s1, checkBodyCollision
			lw $t3, obstaclesPosX($s0)
			lw $t4, obstaclesPosY($s0)
			bne $t1, $t3, checkObstacleSuite
			beq $t2, $t4, changeV0
			checkObstacleSuite:
			addu $s0, $s0, 4
		j checkObstacleCollision

		#checkBodyCollision
		checkBodyCollision:
		li $s0, 16 #Pour commencer à partir de l'emplacement snakePos[4] du serpent
		lw $s1, tailleSnake
		sll $s1, $s1, 2 
		ble $s1, $s0, goOut	#Si le serpent a une taille <=4, pas de collision
		loopBodyCollision:	
			beq $s0, $s1, goOut
			lw $t3, snakePosX($s0)
			lw $t4, snakePosY($s0)
			bne $t1, $t3, checkBodySuite
			beq $t2, $t4, changeV0
			checkBodySuite:
			addu $s0, $s0, 4
		j loopBodyCollision

  
		changeV0: 
			li $v0, 1  #On change le v0 pour arrêter le jeu au prochain tour de boucle

		goOut:
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		addu $sp, $sp, 12
jr $ra

############################### affichageFinJeu ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Affiche le score du joueur dans le terminal suivi d'un petit
#                mot gentil (Exemple : «Quelle pitoyable prestation !»).
# Bonus: Afficher le score en surimpression du jeu.
################################################################################

affichageFinJeu:
	#Affiche graphiquement le message donnant le score finale obtenu
	#############
	la $a0, messageScore
	lw $a1, scoreJeu
 	li $v0, 56
	syscall
	#############
jr $ra
