.data

.text
main: li $t0, 0
      li $t1, 1
      li $v0, 5
      syscall
      addi $v0, $v0, 1
      move $t2, $v0
again: add $t0, $t0, $t1
      addi $t1, $t1, 1
      bne $t1, $t2, again
      li $v0, 1
      move $a0, $t0
      syscall
      li $v0, 10
      syscall


