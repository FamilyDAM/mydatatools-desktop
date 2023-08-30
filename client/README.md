# LifeFLASH

Your personal Digital Asset Manager, digital take out tool, backup manager.

All stored locally on your machine. No ads. No tracking. No selling your data. Just you and your data.
         

# client Build

### TODO:
- Add archive for social sites
- Add Email archive app.
- Add Social Network Archives
  - figure out oauth plan
- Build private Social Network into app
  - research https://atproto.com/ and https://solid.mit.edu/


# Build
* Regenerate Models 
```bash
flutter pub run realm generate
```

* Build macos 
```bash
flutter build macos --no-tree-shake-icons 
```

* Create DMG  
@see https://retroportalstudio.medium.com/creating-dmg-file-for-flutter-macos-apps-e448ff1cb0f

```bash
#if needed (1st time) 
npm install -g appdmg
```
```bash
cd installers/dmg_creator
```
```bash
appdmg installers/dmg_creator/config.json installers/mydata.tools.dmg
```

