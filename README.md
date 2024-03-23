# CMO_comm_jam
Simple implementation and script of communication jam in Command: Modern Operations

## Description
The script is designed to simulate communication interference and can be mounted on any scenario. Specifically, when an electronic warfare aircraft capable of communication jamming activates its Communication Jammer attribute in the OECM (Offensive ECM) system, certain units within the affected range from enemy and neutral factions will lose communication (A "NO COMM" string will appear under the related unit).

## Usage

### For local user / game player

* Place the `Comms_jam_formal.lua` file from the provided compressed package into the Lua folder located in the root directory of Command: Modern Operations (usually found at `steamapps\common\Command - Modern Operations\Lua`).
* Open the scenario you want to configure communication interference in using the editor within Command: Modern Operations.
* Perform the following actions:
1. Check the `Communications Disruption` option under `Editor` -> `Scenario Features+Settings`.
2. Add a timed trigger (e.g., every 15 seconds) with a custom title (e.g., "15s").
3. Add a Lua Script action with a custom title (e.g., "ECM"). In the execution window, input the following code: 
```shell
ScenEdit_RunScript('Comms_jam_formal.lua')
```
4. Create an event where the trigger is set to the previously defined 15-second trigger, and the action is set to the "ECM" action above.

### For scenario maker
Same as above. But copy the entire code from Comms_jam_formal.lua and paste to the "ECM" action instead.