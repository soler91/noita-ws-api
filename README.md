# noita-ws-api
Websocket based API to Noita: allows Noita to connect through a websocket to a server, which can then execute
arbitrary Lua within Noita's environment.

## Installation

The mod dynamically links the [pollws](https://github.com/probable-basilisk/pollws) library through 
luajit's FFI in order to act as a websocket client.

* Grab the [pollws binaries](https://github.com/probable-basilisk/pollws/releases/download/0.1.0/pollws_0_1_0_windows.zip): copy
the *32 bit* `pollws.dll` into your Noita install dir (so it should be in the same directory as `Noita.exe`). You don't need
to care about the includes, bindings, or `.lib` files-- only the `.dll` is needed.

* Copy the `TwitchIntegration` directory into `{your_Noita_install_dir}/mods/`: you should end up with a file in
`{your_Noita_install_dir}/mods/TwitchIntegration/mod.xml`.

* Copy the `mod_ws_api` directory into `{your_Noita_install_dir}/mods/`: you should end up with a file in
`{your_Noita_install_dir}/mods/mod_ws_api/mod.xml`.

* Enable the `mod_ws_api` mod in the Noita mods menu. It will ask for full permissions (in order to use the FFI); presumably
you understand what that means and the risks involved.

* (optional) Copy the `mod_dev_settings` directory into your mods dir. This mod disables Noita from pausing when
it loses focus, which is very convenient when using the console. Enable this mod also in the Noita mods menu.