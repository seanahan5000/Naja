# Naja (Tactical Force Alliance) #

**Naja** is a futuristic fantasy role-playing game for the Apple ][, designed by Sean Callahan (programming) and Richard Nielsen (artwork).  We started on it as 16 year olds in the spring of 1982 and worked through our Senior year of high school.  Development continued full-time from 1983 to 1985, with additional work being done part-time through 1989.

The title Naja comes from the game's villain, which is also the genus name of cobra snakes.  It was later renamed to the easier to understand "Tactical Force Alliance".

The game was originally designed for the Apple ][+ with 48K memory, but was eventually upgraded to require an 80 column card or Apple //e with 64K.  It covered three floppy disks, six sides total, with its own custom copy protection system.

Naja's design was heavily influenced by the game Wizardry by Sir-Tech.  The use of line tunnels, hand-drawn maps on graph paper, and text-based fight narration are conventions that we adopted from Wizardry and, to a lesser degree, Ultima.  After many hours playing Wizardry, we thought we could do better and added features we considered innovative for the time.

* A futuristic sci-fi theme and new classes instead of a typical D&D/LotR theme.
* Full-screen, six-sided tunnels.
* Monster/alien graphics integrated into the tunnels instead of just overlaid.
* Use of animations and transition effects.
* A unique mapping scheme where each game level is wrapped on the outside of a cube to approximate a spherical space station.  Each cube level contained smaller cube levels, like a Russian nesting doll.

**Graphics Simulations Software** was incorporated in 1982 with the original intent of self-publishing Naja.  We eventually decided to publish through an established game company but didn't start actively looking for a publisher until 1988.  We demonstrated the game for publishers at the second-ever Computer Game Developer's Conference (Milpitas, California Holiday Inn, 1988), and then formally submitted it to Electronic Arts, Mediagenic/Activision, Epyx, New World Computing (Might and Magic), and Origin Systems (Ultima).  While we received positive responses to the game, most weren't interested in publishing because it was Apple ][-only and they had moved to simultaneous multi-platform releases.  The Apple ][ was considered a dying platform compared to the PC at that point.  Only Origin Systems showed any interest and started a contract conversation with us, but that later fell through.

A capture of the video tape submitted to publishers can be found at https://www.youtube.com/watch?v=HZTUacbMBF4&t=346s.  Other submitted materials included the game itself, instruction manual, and a demo disk of aliens and other graphics, all of which can be found in this repo.

The sources here are a snapshot of the game in its original/classic form and playable state.  Later modifications attempting to update the look of the game, redo all the maps, and collapse it down to fewer disks have been removed.  The original disk copy protection system has been stripped out so the game will work on standard floppies and under emulation.

Some special encounters (listed below) have been implemented and can be found throughout the game world.  Others are only in the form of images on some of the disk archives.  All designed aliens are included, but no game tuning or balancing has been done.  All aliens fight with the same random, relatively weak stats.

## Building

Prebuilt disk images can be found in naja\bin.

To rebuild images, open a Windows command prompt:
```
setenv.bat
cd naja
build.bat
```

Naja sources are assembled using Asm6502, which is a Merlin assembler clone written from scratch.  Sources can be found in tools\asm6502.

## Running

Download and launch the AppleWin emulator (https://github.com/AppleWin/AppleWin).

In AppleWin Configuration (joystick/speaker icon), set machine type to Apple //e.

- Open drive 1 and select `naja\bin\boot.nib`
- Open drive 2 and select `naja\bin\tracc1.nib`
- Reset

Press any key to stop title screen animation
Press any key to leave signature page

#### General Keys

- Move/turn left: J or `<left-arrow`>
- Move/turn right: K or `<right-arrow`>
- Move up/step forward: A or I or `<up-arrow`>
- Move down/turn around: Z or M or `<down-arrow`>
- Select: `<space`> or `<return`>

NOTE: Naja assumes all upper case input so caps-lock must be enabled at all times for keys to work when running on a //e.  (Naja will run on an ][+, but the up and down arrows will not be available and some debug key combinations won't work.)

### Mothership

* Enrollment Complex

    - Enrollment and Testing (create and advance characters)
    - Group Assembly Office (build character roster)
    - Shuttle Loading (delete characters)
    - Transport (move throughout Mothership)

* Arsenal Complex

    - Energy Distribution Center (buy/sell energy)
    - Arsenal (buy/sell equipment)
    - Robot Ordering and Replacement Center (buy/update robots)

* Infirmary

    - Infirmary (heal characters)

* Tesserport

    - Tesseract to TRACC Station

### TRACC Station

#### Miscellaneous Keys

- S: Stats, enter camp
- T: Tesseract back to Mothership (Only works on shell 1, any face)
- F: Show output of "face tracker", giving current shell and face information
- R: Change tunnel view range (hold Alt/Option to force maximum range, independent of Android equipment)

#### Debugging Keys

- Left Alt/Option+T: Bring up alien editor, debug teleporter menu
- Left Alt/Option+<step>: Force alien encounter
- Left Alt/Option at end of encounter: Force dead group sequence
- Right Alt/Option+<step>: Force equipment find
- Left+Right Alt/Option+<step>: View all aliens
    - `<space`>: Next alien
    - `<escape`>: Leave alien viewer

#### Alien Editor

- `<left-arrow`>,`<right-arrow`>: Cycle through aliens
- `<space`>: Select value to edit
- `<escape`>: Back to previous screen
- Left Alt/Option+J: Jump to alien
- Left Alt/Option+S: Save
- Left Alt/Option+Q: Quit

#### Teleporter

* Space bar to change numbers
* All numbers are hex values

    NOTE: You may need to turn left/right/around and possibly take a step forward to see the actual special encounter after teleportation.

### Special Encounters

Below are most of the special encounters currently implemented in the TRACC station. Teleporter coordinates are in parenthesis.

#### Shell 1

* Viewport (S: 1, F: 3, X: 7, Y: 11) and (S: 1, F: 3, X: B, Y: 11)

    - "NO ONE CAN TRANSLATE THE WRITING.  DO YOU WANT TO TRY PRESSING BUTTONS?"
    - Press Y to see an animation of the viewport opening and a view of the title screen ship out in space.
    - All other doors along the hallway have viewports, but without buttons to open it.

* Airlock (S: 1, F: 3, X: 4, Y: 11) and (S: 1, F: 3, X: E, Y: 11)

    - Door display the infinity symbol and the letters A and L.
    - Stepping through the door was going to suck the entire group out the airlock and kill them.
    - This was never implemented.

* Door Sign (S: 1, F: 5, X: 1, Y: 9)

    - "DO YOU WANT `<android-character`> TO TRANSLATE THE WRITING?"
    - "THIS MARKS THE BORDER OF EMPEROR RUUIK'S ROYAL DOMAIN"

* King Ruuik (S: 1, F: 5, X: 8, Y: 9)

    - "I AM RUUIK, SUPREME EMPEROR OF THIS PLANET..."
    - Begin quest from "King" Ruuik to provide four light rifles in exchange for the password to the green nets and the codeword to avoid encounters with his soldiers.

* Elevator 123 (S: 1, F: 6, X: 4, Y: D)

    - Rotate to see the elevator screen on the wall and step towards it.
    - Press shell level '1', '2', or '3'.
    - Change drive to corresponding disk image (naja\bin\tracc1.nib, tracc2.nib, or tracc3.nib).
    - Press any key to see elevator animation.

* Green Orb Guard (S: 1, F: 6, X: 8, Y: F)

    - Automatic encounter with robot guarding green orb
    - (Currently only shows robot graphic, without need to fight it.)

* Green Orb Pedestal (S: 1, F: 6, X: 8, Y: 10)

    - Awards one of five orbs used to open the Orb Door on shell 5.

* Green Net (S: 1, F: 2, X: 2, Y: A) and various other locations

    - Rotate to see animation of net closing
    - Type password "GN-28" and return
    - Watch animation of net opening

#### Shell 2

* Elevator 123 (S: 2, F: 6, X: 2, Y: B)

    - See above.

#### Shell 3

* Elevator 123 (S: 3, F: 6, X: 1, Y: C)

    - See above.

* Elevator 345 (S: 3, F: 3, X: 4, Y: 7)

    - Rotate to see the elevator screen on the wall and step towards it.
    - Press shell level '3', '4', or '5'.
    - Change drive to corresponding disk image (naja\bin\tracc3.nib, tracc4.nib, or tracc5.nib).
    - Press any key to see elevator animation.

#### Shell 4

* Elevator 345 (S: 4, F: 3, X: 2, Y: 7)

    - See above.

#### Shell 5

* Elevator 345 (S: 5, F: 3, X: 1, Y: 4)

    - See above.

* Orb Door (S: 5, F: 6, X: 2, Y: 5)

    - Rotate to find face change opening and step through it.
    - "DO YOU WISH TO INSERT ORBS?"
    - Press 'Y' or 'N'
    - Watch orb door opening animation


## Other Information

MapEditor

To import a map, copy the HEX data from a PART*.S file and paste.
To export a map, select copy and then paste results back into PART*.S file.
