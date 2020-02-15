# Heroku-Aria2c 世纪互联版 Heroku aria2c for 21vianet
[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)
 This Repositories forked from maple3142/heroku-aria2c. 这个项目是 maple3142/heroku-aria2c 的不可合并分支。
 
## Improvement 改进
1. Compatible with China Onedrive by 21vianet. 兼容由世纪互联运营的中国大陆版 Onedrive。
2. Support mount multiple cloud drive. 支持多网盘挂载。
3. improve performance of the built-in Aria2 and Rclone. 大幅提升内置 Aria2 和 Rclone 性能。
5. rclone webui. rclone web 管理界面。

## Mount Cloud Drive With Rclone 挂载网盘

1. Setup Rclone by following offical instructions: https://rclone.org/docs/
Chinese users setup by following Rclone with 21vianet peach.
2. Find your `rclone.conf` file, it should look like this:

```conf
[DRIVENAME A]
type = WHATEVER
client_id = WHATEVER
client_secret = WHATEVER
scope = WHATEVER
token = WHATEVER

[DRIVENAME B]
type = WHATEVER
client_id = WHATEVER
client_secret = WHATEVER
scope = WHATEVER
token = WHATEVER

others entries...
```

3. Find the drive you want to use, and copy its `[DRIVENAME A] ...` to  `... token = ...` section.
4. Replace all linebreaks with `\n`
5. Deploy with the button above, and paste that text in `RCLONE_CONFIG`
6. Set `RCLONE_DESTINATION_A` to a path you want to store your downloaded  in `[DRIVENAME A]`
7. Set `RCLONE_DESTINATION_B/C...` is the same as 6