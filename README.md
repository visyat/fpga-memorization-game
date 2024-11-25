# FPGA Memorization Game

Single-player memorization game on the FPGA board. At the start of the game, four digits will be displayed on the seven-segment display for 5 seconds. Once the five seconds are over, the display will clear, and the user must enter the four digits in the correct order using the keyboard. If the user successfully enters the correct number, the display will indicate that it is correct, and will restart the game with a new code. If the user enters an incorrect number, the display will indicate that the response was incorrect, and clear the display so that the user can try again (the target number will not change or be redisplayed).

```
- Wait for the on/off button before beginning the game. 
- Display Phase
	- Randomly generate a set of 4 digits (0-9, 10000 possible options).
	- Print to the seven-segment display; blink at 2Hz. Do this for 5 seconds.
- Enter Phase 
	- Display blank. 
	- User enters digits into the keyboard.
	- Once entered, digits appear on the display – left to right. 
	- Once 4 digits have been entered, if matches the original 4-digit value: 
		- Print “YES”. Clear and restart from Display Phase. 
	- If doesn’t match: 
		- Print “NO”. Clear display and restart Enter Phase. 
- If the user clicks restart, start from the beginning of Display Phase. If the user clicks on/off button, stop the game – restarts when clicked again.
```