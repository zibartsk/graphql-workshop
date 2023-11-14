# Inspecting GraphQL traffic in browser - easier way

### Chrome extension

Done on your workstation (not in Codespace):

```powershell
cd $env:TEMP
git clone https://github.com/mkol5222/devtools-networkinspector
cd devtools-networkinspector
$pwd.path | Set-Clipboard
```

* Continue in Chrome browser in [chrome://extensions/](chrome://extensions/)

* Enable Developer mode

* Load unpacked

* Folder is in your clipboard already - paste it to load dialog


Next step:

* GraphQL API client

```bash
cd /workspaces/graphql-workshop/02-api-client
code NOTES.md
```