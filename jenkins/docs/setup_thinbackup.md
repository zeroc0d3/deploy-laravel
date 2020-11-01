## How to Setup ThinBackup

### Configuration's Setup
1. From `Uncategorized` Plugin, select `ThinBackup`.
   <br>![ThinBackup](./img/006.png)
1. Go to `Setting` Menu.
   <br>![Setting Menu](./img/007.png)
1. Configure the ThinBackup as picture shown below.
   <br>![Setup ThinBackup](./img/008.png)
   ```
   (default)
   -----
   - Backup directory:                /tmp/backup
   - Backup schedule for full backup: 0 3 * * 5     # Every friday at 03.00 PM (server time)
   - Backup schedule for diff vackup: 0 */6 * * *   # Every 6 hours every day (increment backup)
   - Max number of backup sets:       10            # Logrotation files
   ```
1. Save your configuration.
1. Run First Full Backup, clik `Backup Now`.
   <br>![Run First Backup](./img/009.png)
1. **-- DONE --**
