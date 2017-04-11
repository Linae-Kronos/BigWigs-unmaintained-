# BigWigs

Big Wigs is a boss encounter add-on. It consists of many individual encounter scripts, or boss modules, mini add-ons that are designed to trigger alert messages, timer bars, sounds, and so forth, for one specific raid encounter.
This version has been specifically tweaked for Kronos by [Risen](http://www.risencc.com/).

## Screenshot

In-game screenshot will be added after the next raid

## Installation
1. Close any instance of WoW
2. Download **[BigWigs Zip file](https://github.com/Linae-Kronos/BigWigs/archive/master.zip)**
3. Extract the zip file wherever you want
4. Copy all the folders that are inside "BigWigs" to Wow_Folder\Interface\AddOns : "BigWigs", "BigWigs_AQ20", "BigWigs_AQ40", "BigWigs_BWL", "BigWigs_CommonAuras", "BigWigs_CThunAssist", "BigWigs_MC", "BigWigs_Naxxramas", "BigWigs_Onyxia", "BigWigs_Other", "BigWigs_ZG"
Your addon folder should look like this :
```
├── WoW_Folder
    ├── Interface
        ├── Addons
            ├── BigWigs
            ├── BigWigs_AQ20
            ├── BigWigs_AQ40
            ├── BigWigs_BWL
            ├── BigWigs_CommonAuras
            ├── BigWigs_CThunAssist
            ├── BigWigs_MC
            ├── BigWigs_Naxxramas
            ├── BigWigs_Onyxia
            ├── BigWigs_Other
            ├── BigWigs_ZG
```
   
5. [Optional] If you had any previous installation from BigWigs before, make sure to delete (or backup) the old configuration files :
```
├── WoW_Folder
    ├── WTF
        ├── Account
        |    ├── Account_name
        |        ├── Kronos
        |            ├── Character_name
        |                ├── SavedVariables
        |                    ├── BigWigs.lua
        ├── Account
    	    ├── Account_name
    	        ├── SavedVariables
    	            ├── BigWigs.lua
    	                ├── BigWigs_CommonAuras.lua
    	                ├── BigWigs_*.lua (any other BigWigs file)
```

5. This is what you should have on character selection screen :

![bigwigs_charselect](https://cloud.githubusercontent.com/assets/24671466/24905771/5abf160e-1eb5-11e7-8e6c-91fe9ca36a16.png)

## How to configure

- For everyone :
```BigWigs Button > Plugins > Bars > Show Anchor```
That will display a frame you can move to choose where to display the BigWigs Bars. I personally recommend to choose an area near from your character.

- For hunters :
```BigWigs Button > Extras > Tranq > Bars (click to enable)```

![bigwigs_config](https://cloud.githubusercontent.com/assets/24671466/24906187/fdb21554-1eb6-11e7-8cab-4295bd654e1d.png)

## Commands
```
/bw    List of useful commands
```

## Credits
HappyMonster who shared the addon
[Risen](http://www.risencc.com/) for the tweaks

