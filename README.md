# Heroku-AriaNG-21vianet. Heroku-AriaNG 世纪互联版
One-click to build AriaNG on Heroku, and upload to cloud drive when the file download completed.<br>
在 Heroku 上一键搭建 AriaNG ，并在文件下载完成后上传至网盘。

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

Using Rclone with 21vianet mod and Aria2, even UNRAR online by command terminal flexibly? Try this [Heroku Rclone 21vianet](https://github.com/xinxin8816/heroku-rclone-21vianet)<br>
想通过更灵活的命令行使用 Aria2、Rclone，甚至是 RAR 在线解压？试试这个 [Heroku Rclone 世纪互联版](https://github.com/xinxin8816/heroku-rclone-21vianet)

This repository forked from maple3142/heroku-aria2c and can't merged.<br>
这个项目是 maple3142/heroku-aria2c 的不可合并分支。

## Abuse Warning 滥用警告

**This APP designed for best performance so uses a lot of resources.**<br>
**本应用为最佳性能设计而使用大量资源。**

**Please be careful with that your Heroku account may be suspend.**<br>
**请注意可能会导致封号。**

## Improvement 改进

1. Rclone with 21vianet patch and Gclone mod. 融合了世纪互联补丁和 Gclone 模组的 Rclone。
2. Support mount double cloud drive. 支持双网盘挂载同步。
3. Improve performance of the built-in Aria2c and Rclone. 大幅提升内置 Aria2c 和 Rclone 性能。
4. Fix some little issues in fork source. 修复项目源的一些其他小问题。

## Connect Cloud Drive With Rclone 连接网盘

1. Setup Rclone by following [Rclone Docs](https://rclone.org/docs/), Chinese users can setup with 21vianet patch to connect OneDrive by 21vianet.<br> 
You can find your config from there:

```
Windows: %userprofile%\.config\rclone\rclone.conf
Linux: $HOME/.config/rclone/rclone.conf
```
Optional: Using service account setup with [Gclone](https://github.com/donwa/gclone) to break Google Drive 750GB limit, or easier connect to folder or Team Drive by destination ID. Create a new folder, such as `/accounts/`, upload your json in it. Open rclone config and edit `service_account_file_path = /app/accounts/` as the json paths.

Rclone with 21vianet patch and Gclone mod provided by xhuang.

2. Your `rclone.conf` file, it should look like this:

```conf
[DRIVENAME A]
type = WHATEVER
client_id = WHATEVER
client_secret = WHATEVER
scope = WHATEVER
china_version = WHATEVER
token = WHATEVER

[DRIVENAME B]
type = WHATEVER
client_id = WHATEVER
client_secret = WHATEVER
scope = WHATEVER
china_version = WHATEVER
token = WHATEVER

others entries...
```

3. Find the drive you want to use, and copy its `[DRIVENAME A] ...` to  `... token = ...` section.
4. Replace all linebreaks with `\n`
5. Deploy with the button above, and paste that text in `RCLONE_CONFIG`
6. Set `RCLONE_DESTINATION` to a path you want to store your downloaded in `[DRIVENAME A]`, format is `[DRIVENAME A]:[REMOVE PATH A]`
7. If you mount a second cloud drive, Set `RCLONE_DESTINATION_2` same as step 6

## FAQ 常见问题
### Why it automatically stop after 30 minutes, and files were lost?
Heroku Free Dyno will idle when there is no incoming request within 30 minutes, and your files will be deleted, so use Rclone to breaking this or use Heroku Hobby Dyno.

By the way, the use of memory exceeds the limit of 512M for a long time, Heroku dyno also will idle.

### Why it still stop after 24 hours when i have used rclone?
Heroku-AriaNG APP will automatically make request to prevent idling when connect cloud drive with Rclone, but Heroku Dyno reset every 24 hours is inevitable.

### How to view upload process?
Go to Heroku Dashboard, and view application logs.

### How to edit rclone or aria2c config?
Open `on-complete.sh` and `aria2c.conf`, some global variables that can be edit, but believe me, the best parameters for best performance have been provided.

### Can I delete files?
Sure. The file will be automatically deleted after the upload is complete. you can also delete the file by deleting the aria2 task.

### Can you provide more detailed configuration and deployment instructions
Nope. This README is enough.
