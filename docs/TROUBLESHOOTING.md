# Troubleshooting

### "Your browser is managed by your organization"
This is expected after running Chrome Lean. Chrome shows the message whenever any policy is set, including the local ones Chrome Lean writes to your user preferences. Nobody is managing your browser remotely, and nothing is reported anywhere. Running `zsh scripts/revert.sh` removes the policies and the message.

If the message stays after `revert.sh`, a system configuration profile is also setting Chrome policies. Check with:
```bash
profiles list
```
```bash
ls "/Library/Managed Preferences"
```
If you find a `com.google.Chrome.plist` there, remove its profile in System Settings → General → Device Management. On a work Mac, that's your company's, so don't remove it.

### "Operation not permitted"
The shell doesn't have Full Disk Access. Turn it on for **Terminal** in System Settings → Privacy & Security → Full Disk Access, then fully quit and reopen Terminal.

### A website broke
It probably needs a blocked permission. Click the icon left of the address → **Site settings** → set that permission to **Allow**.

### Video calls have no camera or microphone
Allow **Camera** and **Microphone** for that site, the same way as above.

### Pages flicker or go blank
Reset the GPU flags at `chrome://flags` → **Reset all**.

### Usage reporting is still on
Chrome only accepts this as a Mandatory policy. Turn it off by hand at `chrome://settings/syncSetup` → **Help improve Chrome's features and performance**.

### `verify.sh` says node isn't found
Install [Node.js 22 or newer](https://nodejs.org), or check `chrome://policy` yourself.

### A policy shows Error after a Chrome update
Google renamed or removed it. Delete it:
```bash
defaults delete com.google.Chrome PolicyName
```
Then restart Chrome.

### Undo everything
```bash
zsh scripts/revert.sh
```
