# Heroku-AriaNG-21vianet. Heroku-AriaNG 世纪互联版
One-click to build AriaNG on Heroku, and upload to cloud drive when the file download completed.<br>
在 Heroku 上一键搭建 AriaNG ，并在下载完成后上传文件至网盘。

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

Using Rclone with 21vianet mod and Aria2, even UNRAR online by command terminal flexibly? Try this [Heroku Rclone 21vianet](https://github.com/xinxin8816/heroku-rclone-21vianet)<br>
想通过更灵活的命令行使用 Aria2、Rclone，甚至是 RAR 在线解压？试试这个 [Heroku Rclone 世纪互联版](https://github.com/xinxin8816/heroku-rclone-21vianet)

This repository forked from maple3142/heroku-aria2c.<br>
这个项目是 maple3142/heroku-aria2c 的不可合并分支。

## Abuse Warning 滥用警告

**This project uses a lot of resources. 这个项目使用大量资源。**

**Your Heroku account may be suspend. 可能会导致封号。**

## Improvement 改进

1. Compatible with China Onedrive by 21vianet. 兼容由世纪互联运营的中国大陆版 OneDrive。
2. Support mount multiple cloud drive. 支持多网盘挂载同步。
3. Improve performance of the built-in Aria2 and Rclone. 大幅提升内置 Aria2 和 Rclone 性能。

## Mount Cloud Drive With Rclone 挂载网盘

1. Setup Rclone by following offical instructions: https://rclone.org/docs/. Chinese users setup with 21vianet peach.

2. Find your `rclone.conf` file, it should look like this:

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
7. If you mount a second cloud drive, Set `RCLONE_DESTINATION_2` same as 6
