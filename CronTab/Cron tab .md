

# Crontab

-   Crontab is used to scheduling and automating the task.

-  It  facilitates the users to run the scripts or linux command at specified  times and intervals. 

-  It is helpful for repetitive tasks such as system maintenance, backups, and updates.

-  Crontab stands for cron table.

### Some of the most common crontab commands are the following:

- crontab -e UserName:  the user to edit the crontab file

- crontab -l UserName:  It lists the  user's crontab file.

- crontab -r UserName:  It removes the crontab file


### crontab schedule syntax
           
    *       *      *      *        *

  -  min(0-59)
  -  hr(0-23) 
  -  day of month(1-31) 
  -  month(1-12)
  -  day of week(0-6)
  - 0 */6  *   *  That entry will run the command for evey six hours.

